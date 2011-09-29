package com.potmo.util.image
{
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class BitmapAnimationCacheObject
	{
		private var _frames:Vector.<BitmapData>;
		private var _offsetX:int;
		private var _offsetY:int;
		private var _frameLabels:Vector.<FrameLabel>;


		public function BitmapAnimationCacheObject( clip:MovieClip )
		{
			_frames = BitmapUtil.rasterizeMovieClip( clip );

			var enclosingRect:Rectangle = BitmapUtil.getEnclosingRect( clip );
			_offsetX = enclosingRect.x;
			_offsetY = enclosingRect.y;

			_frameLabels = BitmapUtil.getFrameLables( clip );
		}


		public function get frames():Vector.<BitmapData>
		{
			return _frames;
		}


		public function get offsetX():int
		{
			return _offsetX;
		}


		public function get offsetY():int
		{
			return _offsetY;
		}


		public function get frameLabels():Vector.<FrameLabel>
		{
			return _frameLabels;
		}

	}
}