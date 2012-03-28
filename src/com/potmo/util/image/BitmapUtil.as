package com.potmo.util.image
{
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.MathUtil;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class BitmapUtil
	{

		private static var tempTextField:TextField = new TextField();
		private static var tempRect:Rectangle = new Rectangle();


		public static function setDefaultTextFormatForBitmapTextBlit( format:TextFormat ):void
		{
			tempTextField.defaultTextFormat = format;
		}


		/**
		 * Draw texts on a bitmapdata
		 * @returns the size of the text drawn if return drawrect is true. Null otherwise
		 */
		public static function drawTextOnBitmapData( bitmapData:BitmapData, text:String, x:int = 0, y:int = 0, textFormat:TextFormat = null, returnDrawRect:Boolean = false ):Rectangle
		{

			tempTextField.antiAliasType = AntiAliasType.NORMAL;
			tempTextField.width = 0;
			tempTextField.height = 0;
			tempTextField.text = text;
			tempTextField.autoSize = TextFieldAutoSize.LEFT;
			var matrix:Matrix = new Matrix( 1, 0, 0, 1, x, y )

			if ( !textFormat )
			{
				tempTextField.setTextFormat( tempTextField.defaultTextFormat );
			}
			else
			{

				tempTextField.setTextFormat( textFormat );
			}

			bitmapData.draw( tempTextField, matrix );

			if ( returnDrawRect )
			{
				return new Rectangle( x, y, tempTextField.width, tempTextField.height );
			}
			else
			{
				return null;
			}
		}


		public static function drawQuickTextOnBitmapData( bitmapData:BitmapData, text:String, x:int = 0, y:int = 0, color:uint = 0x000000, fontSize:Number = 12 ):void
		{

			tempTextField.antiAliasType = AntiAliasType.NORMAL;
			tempTextField.text = text;
			tempTextField.autoSize = TextFieldAutoSize.LEFT;
			var matrix:Matrix = new Matrix( 1, 0, 0, 1, x, y )

			var format:TextFormat = new TextFormat( tempTextField.defaultTextFormat.font, fontSize, color );
			tempTextField.setTextFormat( format );

			bitmapData.draw( tempTextField, matrix );
		}


		public static function blit( target:BitmapData, source:BitmapData, xOffset:int = 0, yOffset:int = 0 ):void
		{
			target.copyPixels( source, source.rect, new Point( xOffset, yOffset ), null, null, true );
		}


		/**
		 * Takes each frame of a movieclip and rasterizes them to the same size.
		 * @returns a Vector of all frames
		 */
		public static function rasterizeMovieClip( clip:MovieClip ):Vector.<BitmapData>
		{
			var out:Vector.<BitmapData> = new Vector.<BitmapData>( clip.totalFrames, true );
			var enclosingRect:Rectangle = getEnclosingRect( clip );

			var frames:int = clip.totalFrames;
			var frame:int = frames + 1;

			while ( --frame >= 1 )
			{
				out[ frame - 1 ] = rasterizeFrameOfMoviclip( clip, frame, enclosingRect );
			}

			return out;
		}


		/**
		 * Makes a big bitmapdata containing all frames stacked from left to right
		 */
		public static function createRasterizedAnimationMap( movieClip:MovieClip ):RasterizationMap
		{
			//creates a list of all frames.
			//All frames will have equal width and height
			var bitmaps:Vector.<BitmapData> = rasterizeMovieClip( movieClip );

			return createRasterizedMapFromVector( bitmaps );

		}


		public static function rasterizeRasterizableClip( clip:IRasterizableClip ):RasterizationMap
		{
			var bitmaps:Vector.<BitmapData> = new Vector.<BitmapData>();

			var rasterized:BitmapData;
			var graphics:DisplayObject;
			var frame:int = 0;

			//get the total binding box
			var bounds:Rectangle = new Rectangle( 0, 0, 0, 0 );

			while ( clip.stepFrame( frame ) )
			{

				graphics = clip.getGraphics();
				var frameBounds:Rectangle = graphics.getBounds( graphics );
				bounds = bounds.union( frameBounds );
				frame++;
			}

			// now when we have the bounding box do this agian and get the total animation
			frame = 0;

			while ( clip.stepFrame( frame ) )
			{
				graphics = clip.getGraphics();
				rasterized = rasterizeDisplayObject( graphics, bounds );
				bitmaps.push( rasterized );
				frame++;
			}

			return createRasterizedMapFromVector( bitmaps );
		}


		private static function createRasterizedMapFromVector( bitmaps:Vector.<BitmapData> ):RasterizationMap
		{
			if ( bitmaps.length == 0 )
			{
				throw new Error( "Can not create rasterized animation map since the clip contains no vaild frames" );
			}

			var rasterMap:RasterizationMap = new RasterizationMap();
			rasterMap.setImages( bitmaps );
			return rasterMap;
		}


		/**
		 * Rasterize a single frame of a movieclip
		 */
		private static function rasterizeFrameOfMoviclip( clip:MovieClip, frame:int, rect:Rectangle ):BitmapData
		{
			Logger.log( "clip: " + clip + " frame: " + frame );

			var startFrame:int = clip.currentFrame;
			clip.gotoAndStop( frame );

			var raster:BitmapData = rasterizeDisplayObject( clip, rect );

			clip.gotoAndStop( startFrame );
			return raster;

		}


		/***
		 * Rasterize a display object
		 */
		public static function rasterizeDisplayObject( displayObject:DisplayObject, rect:Rectangle ):BitmapData
		{
			// It is not possible to create a bitmapdata with height or width of 0
			// avoid that
			if ( rect.width < 1 )
			{
				rect.width = 1;
			}

			if ( rect.height < 1 )
			{
				rect.height = 1;
			}

			var buffer:BitmapData = new BitmapData( Math.ceil( rect.width ), Math.ceil( rect.height ), true, 0x00000000 );

			var matrix:Matrix = new Matrix( 1, 0, 0, 1, Math.floor( -rect.x ) - 1, Math.floor( -rect.y ) - 1 );

			buffer.draw( displayObject, matrix, null, null, null, true );

			return buffer;
		}


		public static function getEnclosingRect( clip:MovieClip ):Rectangle
		{

			var startFrame:int = clip.currentFrame;
			//Find the rect of the animation
			var rect:Rectangle = new Rectangle( 0, 0, 0, 0 );

			for ( var frame:uint = 1; frame < clip.totalFrames + 1; frame++ )
			{
				clip.gotoAndStop( frame );

				var frameRect:Rectangle = new Rectangle( 0, 0, 0, 0 );

				for ( var child:uint = 0; child < clip.numChildren; child++ )
				{
					frameRect = frameRect.union( clip.getChildAt( child ).getBounds( clip ) );
				}

				//check if the clip is all empty. Might contain Graphics data
				if ( frameRect.width == 0 && frameRect.height == 0 )
				{
					frameRect = frameRect.union( clip.getBounds( clip ) );
				}

				rect = rect.union( frameRect );

			}

			rect.x = Math.floor( rect.x );
			rect.y = Math.floor( rect.y );
			rect.width = Math.ceil( rect.width );
			rect.height = Math.ceil( rect.height );

			clip.gotoAndStop( startFrame );
			return rect;
		}


		public static function getFrameLables( clip:MovieClip ):Vector.<FrameLabel>
		{
			var labelArray:Array = clip.currentLabels;
			var labelCount:uint = labelArray.length;

			var frameLabels:Vector.<FrameLabel> = new Vector.<FrameLabel>( labelCount, true );

			for ( var i:int = 0; i < labelCount; i++ )
			{
				frameLabels[ i ] = labelArray[ i ];
			}
			return frameLabels;
		}


		/**
		 *   "Extremely Fast Line Algorithm"
		 *   @author Po-Han Lin (original version: http://www.edepot.com/algorithm.html)
		 *   @author Simo Santavirta (AS3 port: http://www.simppa.fi/blog/?p=521)
		 *   @author Jackson Dunstan (minor formatting)
		 *   @param x X component of the start point
		 *   @param y Y component of the start point
		 *   @param x2 X component of the end point
		 *   @param y2 Y component of the end point
		 *   @param color Color of the line
		 *   @param bmd Bitmap to draw on
		 */
		public static function efla( x:int, y:int, x2:int, y2:int, color:uint, bmd:BitmapData ):void
		{

			var shortLen:int = y2 - y;
			var longLen:int = x2 - x;

			if ( ( shortLen ^ ( shortLen >> 31 ) ) - ( shortLen >> 31 ) > ( longLen ^ ( longLen >> 31 ) ) - ( longLen >> 31 ) )
			{
				shortLen ^= longLen;
				longLen ^= shortLen;
				shortLen ^= longLen;

				var yLonger:Boolean = true;
			}
			else
			{
				yLonger = false;
			}

			var inc:int = longLen < 0 ? -1 : 1;

			var multDiff:Number = longLen == 0 ? shortLen : shortLen / longLen;

			if ( yLonger )
			{
				for ( var i:int = 0; i != longLen + 1; i += inc )
				{
					bmd.setPixel32( x + i * multDiff, y + i, color );
				}
			}
			else
			{
				for ( i = 0; i != longLen + 1; i += inc )
				{
					bmd.setPixel32( x + i, y + i * multDiff, color );
				}
			}

		}


		/***
		 * Alias for efla, Extremely fast line drawing algorithm
		 * Draws with 32 bit color 0xAARRGGBB
		 */
		public static function drawLine( x:int, y:int, x2:int, y2:int, color:uint, bmd:BitmapData ):void
		{
			efla( x, y, x2, y2, color, bmd );
		}


		/**
		 * Draw a vector to a bitmap
		 */
		public static function drawVector( pos:Vector3D, vel:Vector3D, color:uint, bmd:BitmapData ):void
		{
			efla( pos.x, pos.y, pos.x + vel.x, pos.y + vel.y, color, bmd );
		}


		/**
		 * Draws a rectangle with 32 bit color 0xAARRGGBB
		 */
		public static function drawRectangle( x:int, y:int, width:int, height:int, color:uint, bmd:BitmapData ):void
		{
			efla( x, y, x + width, y, color, bmd );
			efla( x + width, y, x + width, y + height, color, bmd );
			efla( x + width, y + height, x, y + height, color, bmd );
			efla( x, y + height, x, y, color, bmd );
		}


		/**
		 * Draws a filled rectangle with 32 bit color 0xAARRGGBB
		 */
		public static function drawFilledRectangle( x:int, y:int, width:int, height:int, color:uint, bmd:BitmapData ):void
		{
			tempRect.x = x;
			tempRect.y = y;
			tempRect.width = width;
			tempRect.height = height;
			bmd.fillRect( tempRect, color );

		}


		/**
		 * Draws a rotated rectangle with 32  bit color 0xAARRGGBB
		 * @param x the centre x
		 * @param y the centre y
		 * @param width the width
		 * @param height the height
		 * @param rads the angle in radians
		 * @param color the 32 bit ARGB color
		 * @param bmd the canvas to draw to
		 * @param ox the origin x coordinate to rotate around
		 * @param oy the origin y coordinate to rotate around
		 */
		public static function drawRotatedRectangle( x:int, y:int, width:int, height:int, rads:Number, color:uint, bmd:BitmapData, ox:int = 0, oy:int = 0 ):void
		{

			var h:Number = height / 2;
			var w:Number = width / 2;

			var p0:Point = MathUtil.rotatePoint( -w - ox, -h - oy, rads );
			var p1:Point = MathUtil.rotatePoint( +w - ox, -h - oy, rads );
			var p2:Point = MathUtil.rotatePoint( +w - ox, +h - oy, rads );
			var p3:Point = MathUtil.rotatePoint( -w - ox, +h - oy, rads );

			efla( x + p0.x, y + p0.y, x + p1.x, y + p1.y, color, bmd );
			efla( x + p1.x, y + p1.y, x + p2.x, y + p2.y, color, bmd );
			efla( x + p2.x, y + p2.y, x + p3.x, y + p3.y, color, bmd );
			efla( x + p3.x, y + p3.y, x + p0.x, y + p0.y, color, bmd );
		}


		/** Draw a circle with Bresenhams circle algorithm with 3d bit color 0xAARRGGBB**/
		public static function drawCirlce( x0:int, y0:int, radius:int, color:int, bmd:BitmapData ):void
		{

			var f:int = 1 - radius;
			var ddF_x:int = 1;
			var ddF_y:int = -2 * radius;
			var x:int = 0;
			var y:int = radius;

			bmd.setPixel32( x0, y0 + radius, color );
			bmd.setPixel32( x0, y0 - radius, color );
			bmd.setPixel32( x0 + radius, y0, color );
			bmd.setPixel32( x0 - radius, y0, color );

			while ( x < y )
			{
				// ddF_x == 2 * x + 1;
				// ddF_y == -2 * y;
				// f == x*x + y*y - radius*radius + 2*x - y + 1;
				if ( f >= 0 )
				{
					y--;
					ddF_y += 2;
					f += ddF_y;
				}
				x++;
				ddF_x += 2;
				f += ddF_x;
				bmd.setPixel32( x0 + x, y0 + y, color );
				bmd.setPixel32( x0 - x, y0 + y, color );
				bmd.setPixel32( x0 + x, y0 - y, color );
				bmd.setPixel32( x0 - x, y0 - y, color );
				bmd.setPixel32( x0 + y, y0 + x, color );
				bmd.setPixel32( x0 - y, y0 + x, color );
				bmd.setPixel32( x0 + y, y0 - x, color );
				bmd.setPixel32( x0 - y, y0 - x, color );
			}

		}


		/**
		 * Fills the entire bitmapData with one color
		 */
		public static function fill( bmd:BitmapData, color:uint ):void
		{
			bmd.fillRect( bmd.rect, color );
		}

	}
}
