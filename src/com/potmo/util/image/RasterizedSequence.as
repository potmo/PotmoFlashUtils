package com.potmo.util.image
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	public class RasterizedSequence
	{
		private var images:Vector.<BitmapData>;
		private var labels:Vector.<String>;


		public function RasterizedSequence( displayObject:DisplayObject )
		{

			if ( displayObject is MovieClip )
			{
				createFromMovieClip( displayObject as MovieClip );
			}
			else
			{
				createFromDisplayObject( displayObject );
			}
		}


		/**
		 * Create from the one frame display object
		 */
		private function createFromDisplayObject( displayObject:DisplayObject ):void
		{
			this.images = new Vector.<BitmapData>( 1, true );
			images[ 0 ] = BitmapUtil.rasterizeDisplayObject( displayObject, displayObject.getBounds( displayObject ) );
			labels = new Vector.<String>( 1, true );
			labels[ 0 ] = "";

		}


		/**
		 * Create from the multiple frame display object
		 */
		private function createFromMovieClip( movieClip:MovieClip ):void
		{
			images = BitmapUtil.rasterizeMovieClip( movieClip );

			labels = new Vector.<String>( images.length, true );

			for ( var i:int = 0; i < labels.length; i++ )
			{
				labels[ i ] = "";
			}

			var clipLabels:Vector.<FrameLabel> = Vector.<FrameLabel>( movieClip.currentLabels );

			for each ( var label:FrameLabel in clipLabels )
			{
				// FrameLabel.frame starts from 1 but arrays from 0
				labels[ label.frame - 1 ] = label.name;
			}
		}


		public function getImages():Vector.<BitmapData>
		{
			return images;
		}


		public function getLables():Vector.<String>
		{
			return labels;
		}
	}
}
