package com.potmo.util.packing
{
	import com.potmo.util.math.StrictMath;

	import flash.geom.Rectangle;

	public class PackRectangle
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		private var _id:int;


		public function PackRectangle( id:int, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0 )
		{
			this._id = id;
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}


		public function getId():int
		{
			return _id;
		}


		public function isEmpty():Boolean
		{
			return width <= 0 && height <= 0;
		}


		public function clone():PackRectangle
		{
			return new PackRectangle( _id, x, y, width, height );
		}


		public function containsRect( rect:PackRectangle ):Boolean
		{
			return StrictMath.rectContainsRect( x, y, width, height, rect.x, rect.y, rect.width, rect.height );
		}


		public static function fromRegularRectangle( rect:Rectangle, id:int ):PackRectangle
		{
			return new PackRectangle( id, rect.x, rect.y, rect.width, rect.height );
		}


		public function toRegularRectangle():Rectangle
		{
			return new Rectangle( x, y, width, height );
		}

	}
}
