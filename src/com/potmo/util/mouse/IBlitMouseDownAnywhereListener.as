package com.potmo.util.mouse{
	import com.potmo.util.sprite.IBlitSprite;
	public interface IBlitMouseDownAnywhereListener extends IBlitMouseListener{
		function onMouseDownAnywhere(globalX:int, globalY:int):void;
	}
}