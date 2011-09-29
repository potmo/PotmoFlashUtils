package com.potmo.util.input
{
	import com.potmo.util.logger.Logger;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class MouseManager
	{
		private static var stage:InteractiveObject;
		private static var _isDown:Boolean = false;
		private static var _pos:Point = new Point( 0, 0 );
		private static var _lastDownPos:Point = new Point( 0, 0 );
		private static var _lastUpPos:Point = new Point( 0, 0 );


		public static function initialize( stage:InteractiveObject ):void
		{
			MouseManager.stage = stage;

			if ( Multitouch.supportsTouchEvents )
			{
				Logger.log( "Using multitouch events" );
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				stage.addEventListener( TouchEvent.TOUCH_BEGIN, touchBegin );
				stage.addEventListener( TouchEvent.TOUCH_END, touchEnd );
				stage.addEventListener( TouchEvent.TOUCH_MOVE, touchMove );
			}
			else
			{
				Logger.log( "Using mouse events" );
				stage.addEventListener( MouseEvent.MOUSE_DOWN, mouseDown );
				stage.addEventListener( MouseEvent.MOUSE_UP, mouseUp );
				stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMove );
			}

		}


		private static function touchMove( event:TouchEvent ):void
		{
			deviceMove( event.stageX, event.stageY );
		}


		private static function touchEnd( event:TouchEvent ):void
		{
			deviceUp( event.stageX, event.stageY );
		}


		private static function touchBegin( event:TouchEvent ):void
		{
			deviceDown( event.stageX, event.stageY );
		}


		private static function mouseDown( event:MouseEvent ):void
		{
			deviceDown( event.stageX, event.stageY )
		}


		private static function mouseUp( event:MouseEvent ):void
		{

			deviceUp( event.stageX, event.stageY );
		}


		private static function mouseMove( event:MouseEvent ):void
		{
			//Logger.log("Mouse move");
			deviceMove( event.stageX, event.stageY );
		}


		private static function deviceDown( x:int, y:int ):void
		{
			_isDown = true;
			deviceMove( x, y );
			_lastDownPos = pos;
			Logger.log( "Mouse down: " + _pos );
		}


		private static function deviceUp( x:int, y:int ):void
		{
			_isDown = false;
			deviceMove( x, y );
			_lastUpPos = pos;
			Logger.log( "Mouse up: " + _pos );
		}


		private static function deviceMove( x:int, y:int ):void
		{
			_pos.x = x;
			_pos.y = y;
		}


		public static function get pos():Point
		{
			return _pos.clone();
		}


		public static function get isDown():Boolean
		{
			return _isDown;
		}


		public static function get lastUpPos():Point
		{
			return _lastUpPos;
		}


		public static function get lastDownPos():Point
		{
			return _lastDownPos;
		}

	}
}
