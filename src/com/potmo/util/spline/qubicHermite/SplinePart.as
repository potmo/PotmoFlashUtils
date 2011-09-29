package com.potmo.util.spline.qubicHermite{
	import flash.geom.Point;

	/**
	 * @author nissebergman
	 */
	public class SplinePart {
		
		public var point:Point;
		public var handler:Point;
		public var stepsToNext:int;
		public function SplinePart(stepsToNext:int, point:Point, handler:Point)
		{
			this.point = point;
			this.handler = handler;
			this.stepsToNext = stepsToNext;
		}
	}
}
