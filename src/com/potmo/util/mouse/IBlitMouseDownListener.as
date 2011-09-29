package com.potmo.util.mouse{
	import com.potmo.util.sprite.IBlitSprite;
	public interface IBlitMouseDownListener extends IBlitMouseListener{
		function onMouseDown(globalX:int, globalY:int):void;
	}
}