package com.potmo.util.input
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	public class KeyboardManager
	{
		
		private static var stage:Stage;	
		private static var keyDowns:Vector.<Boolean> = new Vector.<Boolean>(222, true);
		
		public static function initialize(stage:Stage):void
		{
			trace("Initialize Keyboard Manager");
			if (KeyboardManager.stage) remove();
			
			KeyboardManager.stage = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		}
		
		public static function remove():void
		{
			if (!stage) return;
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			stage = null;
		}
		
		private static function keyDown(event:KeyboardEvent):void
		{
			keyDowns[event.keyCode] = true;
			trace("--DownKey: " + event.keyCode);
		}
		
		private static function keyUp(event:KeyboardEvent):void
		{
			
			keyDowns[event.keyCode] = false;
			
			trace("----UpKey: " + event.keyCode);
		}
		
		public static function isDown(keyCode:uint):Boolean
		{
			return keyDowns[keyCode];
		}
	}
}