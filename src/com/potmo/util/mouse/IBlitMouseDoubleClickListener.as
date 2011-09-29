package com.potmo.util.mouse{
	import com.potmo.util.sprite.IBlitSprite;

	public interface IBlitMouseDoubleClickListener extends IBlitMouseListener{
		function onMouseDoubleClick(globalX:int, globalY:int):void;
	}
}