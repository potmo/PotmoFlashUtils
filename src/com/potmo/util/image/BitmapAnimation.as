package com.potmo.util.image
{
	import com.potmo.util.logger.Logger;
	import com.potmo.util.math.StrictMath;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class BitmapAnimation extends Bitmap
	{
		private var frameLabels:Vector.<FrameLabel>;
		private var frames:Vector.<BitmapData>;
		private var lastFrame:uint = 0;
		private var frame:uint = 0;
		private var offsetX:int = 0;
		private var offsetY:int = 0;

		private var loop:Boolean = true;


		/**
		 * This class can be initialized with a BitmapAnimationCacheObject.
		 * Then it will split the movieclip into bitmaps and use that one
		 * Otheriwise it can be populated later with a MovieClip or with a array of BitmapDatas or a BitmapAnimationCacheObject
		 */
		public function BitmapAnimation( source:BitmapAnimationCacheObject = null )
		{

			if ( source )
			{
				populateWithBitmapAnimationCache( source );

			}

			super( null, pixelSnapping, smoothing );

		}


		public function populateWithMovieClip( source:MovieClip ):void
		{
			frames = BitmapUtil.rasterizeMovieClip( source );
			lastFrame = frames.length - 1;
			var enclosingRect:Rectangle = BitmapUtil.getEnclosingRect( source );
			offsetX = enclosingRect.x;
			offsetY = enclosingRect.y;

			frameLabels = BitmapUtil.getFrameLables( source );

			this.bitmapData = frames[ 0 ];

		}


		public function setLooping( value:Boolean ):void
		{
			loop = value;
		}


		/**
		 * @param frames a list of all the frames
		 * @frameLavels a list of framelabels
		 * @offsetX the horizontal offset the left of the image is from origo
		 * @offsetY the vertical offset the top of the image is from origo
		 */
		public function populateWithBitmapDatas( frames:Vector.<BitmapData>, frameLabels:Vector.<FrameLabel>, offsetX:int, offsetY:int ):void
		{
			this.frames = frames;
			this.lastFrame = frames.length - 1;
			this.frameLabels = frameLabels;
			this.offsetX = offsetX;
			this.offsetY = offsetY;

			this.bitmapData = frames[ 0 ];
		}


		public function populateWithBitmapAnimationCache( cache:BitmapAnimationCacheObject ):void
		{
			this.frames = cache.frames;
			this.frameLabels = cache.frameLabels;
			this.offsetX = cache.offsetX;
			this.offsetY = cache.offsetY;
			this.lastFrame = frames.length - 1;

			this.bitmapData = frames[ 0 ];
		}


		public override function get x():Number
		{
			return super.x - offsetX;
		}


		public override function set x( value:Number ):void
		{
			super.x = value + offsetX;
		}


		public override function get y():Number
		{
			return super.y - offsetY;
		}


		public override function set y( value:Number ):void
		{
			super.y = value + offsetY;
		}


		/**
		 * Set the name from framelabel
		 * @throws Error if not frame has that name
		 */
		public function setFrameFromName( name:String ):void
		{
			setFrame( getFrameFromName( name ) );
		}


		/**
		 * get the frame named with a framelabel
		 * @returns the frame or -1 if not found
		 */
		public function getFrameFromName( name:String ):int
		{
			for each ( var frameLabel:FrameLabel in frameLabels )
			{
				if ( frameLabel.name == name )
				{
					// flash indexes from 1 but I index from 0
					return frameLabel.frame - 1;
				}
			}

			return -1;
		}


		/**
		 * Sets the frame. If the frame is more than the maximum
		 * number of frames it will loop around if loop is true (deafult)
		 * or set it to the last frame
		 */
		public function setFrame( frame:uint ):void
		{

			if ( frame >= 0 )
			{

				if ( loop )
				{
					this.frame = frame % ( lastFrame + 1 );
				}
				else
				{
					this.frame = StrictMath.min( frame, lastFrame );
				}

			}

			else
			{
				throw Error( "Frame can not be negative" );
			}

			this.bitmapData = frames[ this.frame ];
		}


		/**
		 * Gets the first found name of a frame
		 * @returns the name if found and empty string otherwise
		 */
		public function getNameOfFrame( frame:uint ):String
		{
			for each ( var label:FrameLabel in frameLabels )
			{
				// remember the flash indexes from 1 but I do from 0
				if ( label.frame - 1 == frame )
				{
					return label.name;
				}
			}

			return "";
		}


		/**
		 * Goes to the next frame. If loop is true (default) it will loop if the end is reached
		 */
		public function nextFrame():void
		{

			// check if it is a label decorator to loop
			var frameName:String = getNameOfFrame( frame );

			if ( frameName != "" )
			{
				// split the name 
				// LOOP_NAME means loop on the frame
				// GOTO_NAME means go to frame to NAME
				var parts:Array = frameName.split( "_" );

				if ( parts.length >= 2 )
				{
					// get the first element witch is the instruction
					// remove the instruction
					var instruction:String = parts.splice( 0, 1 )[ 0 ];

					if ( instruction == "GOTO" )
					{

						// join the rest so we get the underscore but without the first one
						var rest:String = parts.join( "_" );

						var newFrame:int = getFrameFromName( rest );

						if ( newFrame != -1 )
						{
							setFrame( newFrame );
							return;
						}
					}
					else if ( instruction == "LOOP" )
					{
						return;
					}

				}

			}

			// just step ahead
			setFrame( frame + 1 );
		}


		/**
		 * Goes to the previous frame. if loop is true (default) it will loop if the begining is reached
		 */
		public function previousFrame():void
		{
			frame--;

			if ( frame < 0 )
			{
				if ( loop )
				{
					frame = lastFrame;
				}
				else
				{
					frame = 0;
				}
			}

			this.bitmapData = frames[ frame ];
		}
	}

}
