package com.potmo.util.mouse{
	import com.potmo.util.sprite.IBlitSprite;

	public interface IBlitMouseUpListener extends IBlitMouseListener{
		function onMouseUp(globalX:int, globalY:int):void;
	}
}