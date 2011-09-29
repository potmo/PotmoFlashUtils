package com.potmo.util.image
{

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Class to pack a series of images into one big bitmap
	 */
	public class RasterizationMap
	{

		private static const MAX_WIDTH:uint = 8191;
		private static const MAX_HEIGHT:uint = 2048;

		private var lookup:Vector.<RasterizationMapItem>;
		private var buffer:BitmapData;
		private var frameCount:int;


		/**
		 * Pack images in the map
		 */
		public function RasterizationMap()
		{
		}


		public function setImages( images:Vector.<BitmapData>, regpoints:Vector.<Point> = null ):void
		{
			// if no regpoints provided then make a list of regpoints (with nullobjects)
			if ( !regpoints )
			{
				regpoints = new Vector.<Point>( images.length, true );
			}

			if ( regpoints.length != images.length )
			{
				throw new Error( "Not the same amount of regpoints as images" );
			}

			lookup = new Vector.<RasterizationMapItem>( images.length, true );
			//maximum size for a BitmapData object is 8,191 pixels in width or height, 
			//and the total number of pixels cannot exceed 16,777,215 pixels. 
			//(So, if a BitmapData object is 8,191 pixels wide, it can only be 2,048 pixels high.)
			//keep packing left to right until max bitmapsize is reached 
			//then step one down and start over. keep in memory the height of the current line

			var xOffset:int = 0;
			var yOffset:int = 0;
			var totalWidth:int = 0;
			var totalHeight:int = 0;
			var previousLineHeights:int = 0;
			var lineWidth:int = 0;
			var lineHeight:int = 0;

			var imageCount:int = lookup.length;
			var bitmap:BitmapData;

			for ( var i:int = 0; i < imageCount; i++ )
			{

				bitmap = images[ i ];

				if ( lineWidth + bitmap.width <= MAX_WIDTH )
				{
					//fits in the same line
					lineWidth += bitmap.width;
					lineHeight = Math.max( lineHeight, bitmap.height );

				}
				else
				{
					//make new line it does not fit in previous
					lineWidth = bitmap.width;
					xOffset = 0;
					yOffset += lineHeight;
					previousLineHeights += lineHeight;

					lineHeight = Math.max( lineHeight, bitmap.height );

				}
				totalWidth = Math.max( totalWidth, lineWidth );
				totalHeight = previousLineHeights + lineHeight;

				var item:RasterizationMapItem = new RasterizationMapItem();
				item.bounds = new Rectangle( xOffset, yOffset, bitmap.width, bitmap.height );

				var regPoint:Point = regpoints[ i ];

				if ( regPoint )
				{
					// use provided regpoint
					item.regPoint = regPoint;
				}
				else
				{
					// set regpoint in centre
					item.regPoint = new Point( item.bounds.width / 2, item.bounds.height / 2 );
				}

				lookup[ i ] = item;

				xOffset += bitmap.width;
			}

			if ( totalHeight > MAX_HEIGHT || totalWidth > MAX_WIDTH )
			{
				throw new Error( "Total size exceeds the max limit of " + MAX_WIDTH + "x" + MAX_HEIGHT );
			}

			buffer = new BitmapData( totalWidth, totalHeight, true, 0xFF0000 );
			buffer.lock();

			var bound:Rectangle;

			for ( var j:int = 0; j < imageCount; j++ )
			{
				bound = lookup[ j ].bounds;
				BitmapUtil.blit( buffer, images[ j ], bound.x, bound.y );

			}
			buffer.unlock();

			frameCount = images.length;

		}


		/**
		 * Prepare the map to be used as a texture
		 * This ensures that the width and height is powers of 2
		 */
		public function prepareAsTexture():void
		{
			var newBuffer:BitmapData = new BitmapData( getTextureWidth(), getTextureHeight(), true, 0xFF0000 );
			newBuffer.copyPixels( buffer, buffer.rect, new Point( 0, 0 ) );
			buffer = newBuffer;
		}


		/**
		 * Add a movieclip to the rasterizationmap
		 */
		public function setMovieClip( clip:MovieClip ):void
		{
			var frameNums:int = clip.totalFrames;
			var frameBitmap:Vector.<BitmapData> = new Vector.<BitmapData>( frameNums, true );
			var frameRegPoints:Vector.<Point> = new Vector.<Point>( frameNums, true );

			var bounds:Rectangle;
			var tempImage:BitmapData;
			var matrix:Matrix = new Matrix( 1, 0, 0, 1, 0, 0 );

			// loop all frames and make their frames
			for ( var frame:int = 1; frame <= frameNums; frame++ )
			{
				// go to the correct frame
				clip.gotoAndStop( frame );

				// get the enclosing rectangle of the frame
				// make sure it is never 0x0 size
				bounds = clip.getBounds( clip );

				if ( bounds.width == 0 )
				{
					bounds.width = 1;
				}

				if ( bounds.height == 0 )
				{
					bounds.height = 1;
				}

				// create a new bitmapdata to draw in. Make sure it fits the frame
				tempImage = new BitmapData( Math.ceil( bounds.width ), Math.ceil( bounds.height ), true, 0x00000000 );

				// update the matrix (we do not need to recreate the matrix but only change some variables)
				matrix.tx = Math.floor( -bounds.x );
				matrix.ty = Math.floor( -bounds.y );

				//draw the frame to the bitmap
				tempImage.draw( clip, matrix, null, null, null, true );

				// save the bitmap
				frameBitmap[ frame - 1 ] = tempImage;

				// save the regpoint
				frameRegPoints[ frame - 1 ] = new Point( -bounds.x, -bounds.y );

			}

			//set the images
			this.setImages( frameBitmap, frameRegPoints );

		}


		/**
		 * Get a image by index
		 */
		public function getImage( index:uint ):BitmapData
		{
			var rect:Rectangle = lookup[ index ].bounds;
			var image:BitmapData = new BitmapData( rect.width, rect.height, true );
			image.copyPixels( buffer, rect, new Point( 0, 0 ) );
			return image;
		}


		/**
		 * Get the bounds of the frame in the image buffer
		 */
		public function getBufferBound( index:uint ):Rectangle
		{
			return lookup[ index ].bounds;
		}


		/**
		 * Get the regpoint of the frame in local coordinates
		 */
		public function getRegpoint( index:uint ):Point
		{
			return lookup[ index ].regPoint;
		}


		/**
		 * Blit image by index to a destination image
		 */
		public function blit( index:uint, destImg:BitmapData, xOffset:int, yOffset:int ):void
		{
			destImg.copyPixels( buffer, lookup[ index ].bounds, new Point( xOffset, yOffset ), null, null, true );
		}


		/**
		 * Get the buffer (the image containing all images packed)
		 */
		public function getBuffer():BitmapData
		{
			return buffer;
		}


		/**
		 * Get the bounds of the images
		 */
		public function getImageBounds():Vector.<Rectangle>
		{
			var bounds:Vector.<Rectangle> = new Vector.<Rectangle>( lookup.length, true );
			var lookupCount:uint = lookup.length;

			for ( var i:uint = 0; i < lookupCount; i++ )
			{
				bounds[ i ] = lookup[ i ].bounds;
			}
			return bounds;
		}


		/**
		 * Get number of images in map
		 */
		public function getFrameCount():uint
		{
			return frameCount;
		}


		/**
		 * Get a texture compiant width of the buffer
		 * That is a power of two
		 */
		public function getTextureWidth():uint
		{
			var width:uint = buffer.width;
			var powerWidth:uint = 1;

			while ( powerWidth < width )
			{
				powerWidth *= 2;
			}
			return powerWidth;
		}


		/**
		 * Get a texture compiant height of the buffer
		 * That is a power of two
		 */
		public function getTextureHeight():uint
		{
			var height:uint = buffer.height;
			var powerHeight:uint = 1;

			while ( powerHeight < height )
			{
				powerHeight *= 2;
			}
			return powerHeight;
		}
	}
}