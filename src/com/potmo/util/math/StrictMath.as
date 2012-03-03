package com.potmo.util.math
{
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.display.ShaderPrecision;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;

	public class StrictMath
	{

	/*	[Embed( source="../../../../../assets/pixelBender/math/math-sqrt.pbj", mimeType="application/octet-stream" )]
		private static const PB_CLASS_SQRT:Class;
		private static const PB_SHADER_SQRT:Shader = new Shader( new PB_CLASS_SQRT() );
	*/

		[Embed( source = "../../../../../assets/pixelBender/math/math-pow.pbj", mimeType = "application/octet-stream" )]
		private static const PB_CLASS_POW:Class;
		private static const PB_SHADER_POW:Shader = new Shader( new PB_CLASS_POW() );

		private static var result:ByteArray;

		public static const PI:Number = 3.141592653589793;
		public static const TWO_PI:Number = PI << 1;
		
		
		public static function sqrt(n:Number):Number
		{
			//TODO: WARNING Uses Math.sqrt() but shouldnt
			return Math.sqrt(n);
			
			//babylonian method			
			/*var x:Number = n * 0.25;
			var a:Number;
			do
			{
				x = 0.5 * (x + n / x);
				a = x * x - n;
				if(a < 0) a = -a;
			}
			while(a > 0.0001)
			return x;*/
		}

		public static function pow( x:Number, y:Number ):Number
		{
			//return powDecay( x, y );

			//return Math.pow( x, y );
			return pixelBendIt2( PB_SHADER_POW, x, y );
			
		}


		/**
		 * Calculate the square of a number
		 */
		public static function sqr( x:Number ):Number
		{
			return x * x;
		}


		/*	public static function powDecay( x:Number, y:Number ):Number
		   {
		   var num:int, den:int = 1001, s:int = 0;
		   var n:Number = x, z:Number = Number.MAX_VALUE;
		   var i:int;

		   if ( y < 0 )
		   {
		   x = ( 1 / x ); // convert base number to fraction
		   y *= -1; // make exponent positive
		   }

		   for ( i = 1; i < s; i++ )
		   {
		   n *= x;
		   }

		   while ( z >= Number.MAX_VALUE )
		   {
		   den -= 1;
		   num = int( y * den );
		   s = ( num / den ) + 1;

		   z = x;

		   for ( i = 1; i < num; i++ )
		   {
		   z *= x;
		   }
		   }

		   while ( n > 0 )
		   {
		   var a:Number = n;

		   for ( i = 1; i < den; i++ )
		   {
		   a *= n
		   };

		   if ( ( a - z ) < .00001 || ( z - a ) > .00001 )
		   {
		   return n
		   };

		   n *= .9999;
		   }

		   return -1.0;
		   }*/

		private static function pixelBendIt( shader:Shader, value:Number ):Number
		{
			var result:ByteArray;
			var byteArray:ByteArray = new ByteArray();
			var shaderJob:ShaderJob;
			var height:int;
			var width:int;

			byteArray.writeFloat( value );

			width = byteArray.length >> 2;
			height = 1;

			shader.data.src.width = width;
			shader.data.src.height = height;
			shader.data.src.input = byteArray;
			shader.precisionHint = ShaderPrecision.FULL;

			result = new ByteArray();
			result.endian = Endian.LITTLE_ENDIAN;

			shaderJob = new ShaderJob( shader, result, width, height );
			shaderJob.start( true );

			result.position = 0;
			return result.readFloat();
		}


		private static function pixelBendIt2( shader:Shader, value:Number, value2:Number ):Number
		{
			var result:ByteArray;

			var byteArray0:ByteArray = new ByteArray();
			var byteArray1:ByteArray = new ByteArray();
			var shaderJob:ShaderJob;
			var height:int;
			var width:int;

			byteArray0.writeFloat( value );
			byteArray1.writeFloat( value2 );

			width = byteArray0.length >> 2;
			height = 1;

			shader.data.src0.width = width;
			shader.data.src0.height = height;
			shader.data.src0.input = byteArray0;
			shader.data.src1.width = width;
			shader.data.src1.height = height;
			shader.data.src1.input = byteArray1;
			shader.precisionHint = ShaderPrecision.FULL;

			result = new ByteArray();
			result.endian = Endian.LITTLE_ENDIAN;

			shaderJob = new ShaderJob( shader, result, width, height );
			shaderJob.start( true );

			result.position = 0;
			return result.readFloat();
		}


		/**
		 * Computes and returns the sine of the specified angle in radians.
		 *
		 * To calculate a radian, see the overview of the Math class.
		 *
		 * This method is only a fast sine approximation.
		 *
		 * @param angleRadians A number that represents an angle measured in radians.
		 * @return A number from -1.0 to 1.0.
		 */
		public static function sin( angleRadians:Number ):Number
		{
			//
			// http://lab.polygonal.de/wp-content/articles/fast_trig/fastTrig.as
			//

			while ( angleRadians > TWO_PI )
			{
				angleRadians -= TWO_PI;
			}

			while ( angleRadians < 0 )
			{
				angleRadians += TWO_PI;
			}

			angleRadians += ( 6.28318531 * Number( angleRadians < -3.14159265 ) ) - 6.28318531 * Number( angleRadians > 3.14159265 );
			var sign:Number = ( 1.0 - ( int( angleRadians > 0.0 ) << 1 ) );
			angleRadians = ( angleRadians * ( 1.27323954 + sign * 0.405284735 * angleRadians ) );
			sign = ( 1.0 - ( int( angleRadians < 0.0 ) << 1 ) );
			return angleRadians * ( sign * 0.225 * ( angleRadians - sign ) + 1.0 );
		}


		/**
		 * Computes and returns the cosine of the specified angle in radians.
		 *
		 * To calculate a radian, see the overview of the Math class.
		 *
		 * This method is only a fast cosine approximation.
		 *
		 * @param angleRadians A number that represents an angle measured in radians.
		 * @return A number from -1.0 to 1.0.
		 */
		public static function cos( angleRadians:Number ):Number
		{
			//
			// http://lab.polygonal.de/wp-content/articles/fast_trig/fastTrig.as
			//

			while ( angleRadians > TWO_PI )
			{
				angleRadians -= TWO_PI;
			}

			while ( angleRadians < 0 )
			{
				angleRadians += TWO_PI;
			}

			angleRadians += ( 6.28318531 * Number( angleRadians < -3.14159265 ) ) - 6.28318531 * Number( angleRadians > 3.14159265 );
			angleRadians += 1.57079632;
			angleRadians -= 6.28318531 * Number( angleRadians > 3.14159265 );

			var sign:Number = ( 1.0 - ( int( angleRadians > 0.0 ) << 1 ) );
			angleRadians = ( angleRadians * ( 1.27323954 + sign * 0.405284735 * angleRadians ) );
			sign = ( 1.0 - ( int( angleRadians < 0.0 ) << 1 ) );
			return angleRadians * ( sign * 0.225 * ( angleRadians - sign ) + 1.0 );
		}


		/**
		 * Computes and returns the angle of the point <code>y/x</code> in radians, when measured counterclockwise
		 * from a circle's <em>x</em> axis (where 0,0 represents the center of the circle).
		 * The return value is between positive pi and negative pi.
		 *
		 * @author Eugene Zatepyakin
		 * @author Joa Ebert
		 * @author Patrick Le Clec'h
		 *
		 * @param y A number specifying the <em>y</em> coordinate of the point.
		 * @param x A number specifying the <em>x</em> coordinate of the point.
		 *
		 * @return A number.
		 */
		public static function atan2( y:Number, x:Number ):Number
		{
			var sign:Number = 1.0 - ( int( y < 0.0 ) << 1 )
			var absYandR:Number = y * sign + 2.220446049250313e-16
			var partSignX:Number = ( int( x < 0.0 ) << 1 ) // [0.0/2.0]
			var signX:Number = 1.0 - partSignX // [1.0/-1.0]
			absYandR = ( x - signX * absYandR ) / ( signX * x + absYandR )
			return ( ( partSignX + 1.0 ) * 0.7853981634 + ( 0.1821 * absYandR * absYandR - 0.9675 ) * absYandR ) * sign
		}


		/**
		 * Computes and returns an absolute value.
		 *
		 * @param value The number whose absolute value is returned.
		 * @return The absolute value of the specified parameter.
		 */
		public static function abs( value:Number ):Number
		{
			return value * ( 1.0 - ( int( value < 0.0 ) << 1 ) );
		}


		/**
		 * Computes and returns the sign of the value.
		 *
		 * @param value The number whose sign value is returned.
		 * @return The -1.0 if value<0.0 or 1.0 if value >=0.0 .
		 */
		public static function sign( value:Number ):Number
		{
			return ( 1.0 - ( int( value < 0.0 ) << 1 ) );
		}


		/**
		 * Returns the smallest value of the given parameters.
		 *
		 * @param value0 A number.
		 * @param value1 A number.
		 * @return The smallest of the parameters <code>value0</code> and <code>value1</code>.
		 */
		public static function min( value0:Number, value1:Number ):Number
		{
			var tmp:Number = Number( value0 < value1 );
			return value0 * tmp + ( 1.0 - tmp ) * value1; //(value0 < value1) ? value0 : value1
		}


		/**
		 * Returns the largest value of the given parameters.
		 *
		 * @param value0 A number.
		 * @param value1 A number.
		 * @return The largest of the parameters <code>value0</code> and <code>value1</code>.
		 */
		public static function max( value0:Number, value1:Number ):Number
		{
			var tmp:Number = Number( value0 > value1 );
			return value0 * tmp + ( 1.0 - tmp ) * value1; //(value0 > value1) ? value0 : value1
		}


		/**
		 * Returns the value closest to value between min and max
		 */
		public static function clamp( value:Number, min:Number, max:Number ):Number
		{
			return StrictMath.max( min, StrictMath.min( max, value ) );
		}


		/**
		 * Return the angle of a 3d vector in radians
		 */
		public static function getAngle( dirX:Number, dirY:Number ):Number
		{
			return atan2( dirX, dirY );
		}


		/**
		 * Checks if two points are closer than max
		 * @param x0
		 * @param y0
		 * @param x1
		 * @param x1
		 * @param max the maximum distance between the points
		 * @param boxTestFirst do a box test for early exit first
		 *
		 */
		public static function isCloseEnough( x0:Number, y0:Number, x1:Number, y1:Number, max:Number, boxTestFirst:Boolean = false ):Boolean
		{
			if ( boxTestFirst )
			{
				// early exit with box test first
				if ( x0 < x1 - max || x1 + max < x0 || y0 < y1 - max || y1 + max < y0 )
				{
					return false;
				}

			}
			var x:Number = x1 - x0;
			var y:Number = y1 - y0;

			return x * x + y * y < max * max;
		}


		/**
		 * Gets the distance between to points squared
		 */
		public static function distSquared( x0:Number, y0:Number, x1:Number, y1:Number ):Number
		{
			var x:Number = x1 - x0;
			var y:Number = y1 - y0;

			return x * x + y * y;
		}


		/**
		 * Get the distance between two points in euclidian 2d space
		 */
		public static function getDist( x0:Number, y0:Number, x1:Number, y1:Number ):Number
		{
			var x:Number = x1 - x0;
			var y:Number = y1 - y0;

			return StrictMath.sqrt( x * x + y * y );
		}


		/**
		 * Get the distance of 2d vector
		 */
		public static function get2DLength( x:Number, y:Number ):Number
		{
			return StrictMath.sqrt( x * x + y * y );
		}


		/**
		 * Get the t value on a line segment that is closest to point
		 * @param cx point x
		 * @param cy point y
		 * @param ax line segment start x
		 * @param ay line segment start y
		 * @param bx line segment end x
		 * @param by line segment end y
		 * @see http://www.codeguru.com/forum/showthread.php?t=194400
		 */
		public static function getTOnLineClosestToPoint( cx:Number, cy:Number, ax:Number, ay:Number, bx:Number, by:Number ):Number
		{
			var r_numerator:Number = ( cx - ax ) * ( bx - ax ) + ( cy - ay ) * ( by - ay );
			var r_denomenator:Number = ( bx - ax ) * ( bx - ax ) + ( by - ay ) * ( by - ay );
			var r:Number = r_numerator / r_denomenator;

			return r;
		}


		/**
		 * Calculate the dot product aka the scalar product
		 */
		public static function dotProduct2D( v1x:Number, v1y:Number, v2x:Number, v2y:Number ):Number
		{
			return v1x * v2x + v1y * v2y;
		}


		/**
		 * First normalize the vectors and then calculate the dot product
		 */
		public static function dotProductNormalized2D( v1x:Number, v1y:Number, v2x:Number, v2y:Number ):Number
		{
			var v1Length:Number = get2DLength( v1x, v1y );
			var v2Length:Number = get2DLength( v2x, v2y );
			v1x /= v1Length;
			v1y /= v1Length;
			v2x /= v2Length;
			v2y /= v2Length;

			return v1x * v2x + v1y * v2y;
		}


		/*public static function getNormalizedScalarProjection2D( v1x:Number, v1y:Number, v2x:Number, v2y:Number ):Number
		   {

		   }*/

		public static function degrees2rads( degrees:Number ):Number
		{
			return degrees * PI / 180;
		}


		public static function rads2degrees( rads:Number ):Number
		{
			return rads / PI * 180;

		}


		public static function floor( num:Number ):Number
		{
			return int( num );
		}


		public static function ceil( num:Number ):Number
		{
			return int( num ) + 1;
		}
		
		public static function round(num:Number):Number
		{
			if (num > 0) return int(num +0.5) else return int(num-0.5);
			
		}


		/**
		 * Check if two rectangles intersect eachother
		 */
		public static function rectIntersectsRect( x0:Number, y0:Number, w0:Number, h0:Number, x1:Number, y1:Number, w1:Number, h1:Number ):Boolean
		{
			//http://stackoverflow.com/questions/306316/determine-if-two-rectangles-overlap-each-other
			return x0 < x1 + w1 && x0 + w0 > x1 && y0 < y1 + h1 && y0 + h0 > y1;

		}


		/**
		 * Check if the first rectangle contains the second
		 */
		public static function rectContainsRect( x0:Number, y0:Number, w0:Number, h0:Number, x1:Number, y1:Number, w1:Number, h1:Number ):Boolean
		{
			//from java.awt.Rectangle.java
			//http://www.dreamincode.net/forums/topic/221905-trying-to-find-whether-one-rectangle-contains-another-rectangle/

			if ( ( w0 | h0 | w1 | h1 ) < 0 )
			{
				// At least one of the dimensions is negative...
				return false;
			}

			// Note: if any dimension is zero, tests below must return false...
			if ( x1 < x0 || y1 < y0 )
			{
				return false;
			}

			w0 += x0;
			w1 += x1;

			if ( w1 <= x1 )
			{
				// x1+w1 overflowed or w1 was zero, return false if...
				// either original w0 or w1 was zero or
				// x0+w0 did not overflow or
				// the overflowed x0+w0 is smaller than the overflowed x1+w1
				if ( w0 >= x0 || w1 > w0 )
				{
					return false;
				}
			}
			else
			{
				// x1+w1 did not overflow and w1 was not zero, return false if...
				// original w0 was zero or
				// x0+w0 did not overflow and x0+w0 is smaller than x1+w1
				if ( w0 >= x0 && w1 > w0 )
				{
					return false;
				}
			}

			h0 += y0;
			h1 += y1;

			if ( h1 <= y1 )
			{
				if ( h0 >= y0 || h1 > h0 )
				{
					return false;
				}
			}
			else
			{
				if ( h0 >= y0 && h1 > h0 )
				{
					return false;
				}
			}

			return true;

			//return x0 <= x1 && y0 <= y1 && x0 + w0 >= y1 + w1 && y0 + w0 >= y1 + h1;
		}


		/**
		 * Checks if rectangle contains point
		 */
		public static function rectContainsPoint( x:Number, y:Number, w:Number, h:Number, px:Number, py:Number ):Boolean
		{
			//http://www.dreamincode.net/forums/topic/131829-writing-own-contains-method-for-rectangles/
			return ( ( x <= px && px <= x + w ) && ( y <= py && py <= y + h ) );

		}

	}
}
