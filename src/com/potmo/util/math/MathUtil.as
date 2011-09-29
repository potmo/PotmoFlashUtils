package com.potmo.util.math
{
	import flash.geom.Point;

	public class MathUtil
	{

		private static const PI_DIV_ONEEIGHTY:Number = Math.PI / 180;
		private static const ONEEIGHTY_DIV_PI:Number = 180 / Math.PI;


		/**
		 * Convert degrees to radians
		 * @return radians
		 */
		public static function dagree2rad( degree:Number ):Number
		{
			return degree * PI_DIV_ONEEIGHTY;
		}


		/**
		 * Convert radians to degrees
		 * @return degrees
		 */
		public static function rad2degree( rad:Number ):Number
		{
			return rad * ONEEIGHTY_DIV_PI;
		}


		/**
		 * Rotate a point around a optional origin
		 * @param x the x coordinate
		 * @param y the y coordinate
		 * @param rads the number of radians to rotate by
		 * @param ox the origin x coordinate to rotate around
		 * @param oy the origin y coordinate to rotate around
		 * @return a point containing the new coordinates
		 */
		public static function rotatePoint( x:Number, y:Number, rads:Number, ox:Number = 0, oy:Number = 0 ):Point
		{

			var np:Point = new Point();
			x + -ox;
			y + -oy;
			np.x = Math.cos( rads ) * x - Math.sin( rads ) * y;
			np.y = Math.sin( rads ) * x + Math.cos( rads ) * y;
			np.x += ox;
			np.y += oy;

			return np;

		}


		public static function getDistance( x:Number, y:Number ):Number
		{
			return Math.sqrt( Math.pow( x, 2 ) + Math.pow( y, 2 ) );
		}


		public static function getAngle( x:Number, y:Number ):Number
		{
			return Math.atan2( y, x );
		}
	}
}