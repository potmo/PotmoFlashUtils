package com.potmo.util.sprite{
	import flash.display.BitmapData;

	public interface IBlitSprite{
		
		function addChild(child:IBlitSprite):void;

		function addChildAt(child:IBlitSprite,index:uint):void;

		function removeChild(child:IBlitSprite):void;

		function getChildIndex(child:IBlitSprite):int;
		
		function setParent(parent:IBlitSprite):void;

		function getParent():IBlitSprite;
		
		function set globalX(x:int):void;

		function set globalY(y:int):void;
		
		function set globalZ(z:int):void;

		function get globalX():int;

		function get globalY():int;
		
		function get globalZ():int;

		function set x(x:int):void;

		function set y(y:int):void;
		
		function set z(z:int):void;

		function get x():int;

		function get y():int;
		
		function get z():int;

		function draw(canvas:BitmapData):void;

		function toString():String;
	}
}