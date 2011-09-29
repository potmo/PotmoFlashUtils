package com.potmo.util.image
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	internal class RasterizationMapItem
	{

		// Bounds correspond to the place in the RasterizationMap
		private var _bounds:Rectangle;

		// Regpoint is the point the image should rotate around
		private var _regPoint:Point;


		public function RasterizationMapItem()
		{
		}


		public function get bounds():Rectangle
		{
			return _bounds;
		}


		public function set bounds( value:Rectangle ):void
		{
			_bounds = value;
		}


		public function get regPoint():Point
		{
			return _regPoint;
		}


		public function set regPoint( value:Point ):void
		{
			_regPoint = value;
		}

	}
}