package com.potmo.util.mouse{
	import com.potmo.util.sprite.IBlitSprite;

	public interface IBlitMouseUpAnywhereListener extends IBlitMouseListener{
		function onMouseUpAnywhere(globalX:int, globalY:int):void;
	}
}