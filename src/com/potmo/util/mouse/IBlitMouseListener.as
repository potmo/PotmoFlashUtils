package com.potmo.util.mouse{
	public interface IBlitMouseListener {
		function hitTest(globalX:int, globalY:int):Boolean;		
		function get globalZ():int;
	}
}