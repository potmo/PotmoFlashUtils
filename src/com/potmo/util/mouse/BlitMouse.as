package com.potmo.util.mouse{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	public class BlitMouse{
		
		private static var _instance:BlitMouse;
		private var _isDown:Boolean;
		private var _x:int;
		private var _y:int;
		
		private var mouseUpListeners:Vector.<IBlitMouseUpListener> = new Vector.<IBlitMouseUpListener>();
		private var mouseDownListeners:Vector.<IBlitMouseDownListener> = new Vector.<IBlitMouseDownListener>();

		private var mouseUpAnywhereListeners:Vector.<IBlitMouseUpAnywhereListener> = new Vector.<IBlitMouseUpAnywhereListener>();
		private var mouseDownAnywhereListeners:Vector.<IBlitMouseDownAnywhereListener> = new Vector.<IBlitMouseDownAnywhereListener>();
		
		public function BlitMouse(stage:Stage)
		{
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
		}
		
		private function onDoubleClick(event:MouseEvent):void
		{
			
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
			
			_x = event.stageX;
			_y = event.stageY;
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
			
			_x = event.stageX;
			_y = event.stageY;
			_isDown = false;
			
			// mouse up listeners is sorted
			//start from top and see who is hitted or nothing
			for each (var listener:IBlitMouseUpListener in mouseUpListeners)
			{
				if (listener.hitTest(_x, _y))
				{
					listener.onMouseUp(_x, _y);
				}
			}
			
			for each (var anywherelistener:IBlitMouseUpAnywhereListener in mouseUpAnywhereListeners)
			{
				anywherelistener.onMouseUpAnywhere(_x,_y);
			}
			
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			event.stopPropagation();
			
			_x = event.stageX;
			_y = event.stageY;
			_isDown = true;
			
			// mouse up listeners is sorted
			//start from top and see who is hitted or nothing
			for each (var listener:IBlitMouseDownListener in mouseDownListeners)
			{
				if (listener.hitTest(_x, _y))
				{
					listener.onMouseDown(_x, _y);
				}
			}
			
			for each (var anywherelistener:IBlitMouseDownAnywhereListener in mouseDownAnywhereListeners)
			{
				anywherelistener.onMouseDownAnywhere(_x,_y);
			}
		}
		
		public static function instanciate(stage:Stage):void
		{
			_instance = new BlitMouse(stage);
		}
		
		public static function get instance():BlitMouse
		{
			if (!_instance) throw new Error("BlitMouse must be intanciated first");
			return _instance;
		}
		
		public function startListenToMouseUp(who:IBlitMouseUpListener):void
		{
			var index:int = mouseUpListeners.indexOf(who);
			if (index != -1)
			{
				//already added
				return;
			}
			mouseUpListeners.push(who);
			mouseUpListeners.sort(zSortFoction);
		}
		
		public function stopListenToMouseUp(who:IBlitMouseUpListener):void
		{
			var index:int = mouseUpListeners.indexOf(who);
			if (index != -1)
			{
				mouseUpListeners.splice(index,1);
			}
		}
		
		public function startListenToMouseDown(who:IBlitMouseDownListener):void
		{
			var index:int = mouseDownListeners.indexOf(who);
			if (index != -1)
			{
				//already added
				return;
			}
			mouseDownListeners.push(who);
			mouseDownListeners.sort(zSortFoction);
		}
		
		public function stopListenToMouseDown(who:IBlitMouseDownListener):void
		{
			var index:int = mouseDownListeners.indexOf(who);
			if (index != -1)
			{
				mouseDownListeners.splice(index,1);
			}
		}
		
		public function startListenToMouseDownAnywhere(who:IBlitMouseDownAnywhereListener):void
		{
			var index:int = mouseDownAnywhereListeners.indexOf(who);
			if (index != -1)
			{
				//already added
				return;
			}
			mouseDownAnywhereListeners.push(who);

		}
		
		public function stopListenToMouseDownAnywhere(who:IBlitMouseDownAnywhereListener):void
		{
			var index:int = mouseDownAnywhereListeners.indexOf(who);
			if (index != -1)
			{
				mouseDownAnywhereListeners.splice(index,1);
			}
		}
		
		public function startListenToMouseUpAnywhere(who:IBlitMouseUpAnywhereListener):void
		{
			var index:int = mouseUpAnywhereListeners.indexOf(who);
			if (index != -1)
			{
				//already added
				return;
			}
			mouseUpAnywhereListeners.push(who);
		
		}
		
		public function stopListenToMouseUpAnywhere(who:IBlitMouseUpAnywhereListener):void
		{
			var index:int = mouseUpAnywhereListeners.indexOf(who);
			if (index != -1)
			{
				mouseUpAnywhereListeners.splice(index,1);
			}
		}
		
		public function startListenToMouseDoubleClick(who:IBlitMouseDoubleClickListener):void
		{
			
		}
		
		public function stopListenToMouseDoubleClick(who:IBlitMouseDoubleClickListener):void
		{
			
		}
		
		public function get globalX():int
		{
			return _x;
		}
		
		public function get globalY():int
		{
			return _y;
		}
		
		private function zSortFoction(a:IBlitMouseListener, b:IBlitMouseListener):int
		{
			var diff:int =  b.globalZ - a.globalZ;
			
			if (diff == 0) return diff;
			
			//makes it return -1 or 1
			var absDiff:int = Math.abs(diff);
			return diff/absDiff;
		}
	}
}




