package com.potmo.util.spline.qubicHermite
{
	import flash.geom.Point;

	/**
	 * @author nissebergman
	 */
	public class Spline
	{

		public static function cubicHermiteSplineFromPoints( n:uint, p0:Point, p1:Point, h0:Point, h1:Point ):Vector.<Point>
		{
			return cubicHermiteSpline( n, p0.x, p0.y, p1.x, p1.y, h0.x, h0.y, h1.x, h1.y );
		}


		/**
		 * Get the cubic hermite spline of p0 to p1 with h0 and h1 as handles
		 * @returns the a list of n elements containing the spline
		 */
		public static function cubicHermiteSpline( n:uint, p0x:Number, p0y:Number, p1x:Number, p1y:Number, h0x:Number, h0y:Number, h1x:Number, h1y:Number ):Vector.<Point>
		{

			var out:Vector.<Point> = new Vector.<Point>( n, true );
			var px:Number;
			var py:Number;
			var t:Number = 0;

			for ( var i:Number = 0; i < n; i++ )
			{

				t += 1.0 / n;

				var t_2:Number = t * t;
				var t_3:Number = t_2 * t;

				// some repetitive math for clarity
				px = ( 2 * t_3 - 3 * t_2 + 1 ) * p0x + ( t_3 - 2 * t_2 + t ) * h0x + ( -2 * t_3 + 3 * t_2 ) * p1x + ( t_3 - t_2 ) * h1x;
				py = ( 2 * t_3 - 3 * t_2 + 1 ) * p0y + ( t_3 - 2 * t_2 + t ) * h0y + ( -2 * t_3 + 3 * t_2 ) * p1y + ( t_3 - t_2 ) * h1y;

				out[ i ] = new Point( px, py );

			}

			return out;
		}


		public static function cubicHermiteSplineFromSplineParts( parts:Vector.<SplinePart> ):Vector.<Point>
		{
			var out:Vector.<Point> = new Vector.<Point>();
			var spline:Vector.<Point>;

			for ( var i:int = 0; i < parts.length - 1; i++ )
			{
				spline = cubicHermiteSplineFromPoints( parts[ i ].stepsToNext, parts[ i ].point, parts[ i + 1 ].point, parts[ i ].handler, parts[ i + 1 ].handler );

				for each ( var p:Point in spline )
				{
					out.push( p );
				}
			}
			return out;
		}

	}

}
