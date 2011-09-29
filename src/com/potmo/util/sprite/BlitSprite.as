package com.potmo.util.sprite{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	public class BlitSprite implements IBlitSprite{
		
		private var _parent:IBlitSprite;
		private var _children:Vector.<IBlitSprite> = new Vector.<IBlitSprite>();
		
		/**Local position in x*/
		private var _x:int = 0;
		
		/**Local position in y*/
		private var _y:int = 0;
		
		/**Local z layer*/
		private var _z:int = 0;
		
		public function BlitSprite()
		{
		}
		
		public function addChild(child:IBlitSprite):void
		{
			var parent:IBlitSprite = child.getParent();
			if (parent) parent.removeChild(child);
			_children.push(child);
			child.setParent(this);
		}
		
		public function addChildAt(child:IBlitSprite, index:uint):void
		{
			var parent:IBlitSprite = child.getParent();
			
			if (parent) parent.removeChild(child);
			
			if (index > _children.length)
			{
				_children.push(child);
			}
			else
			{
				_children.splice(index,0, child);
			}
				
			child.setParent(this);
			
			updateZvalues();
		}
		
		public function removeChild(child:IBlitSprite):void
		{
			var index:int = _children.indexOf(child);	
			if (index != -1)
			{
				_children.splice(index, 1);
			}
			else
			{
				var a:int = 0;
			}
			
			child.setParent(null);
			
			updateZvalues();
		}
		
		private function updateZvalues():void
		{
			var numChildren:int = _children.length;
			for (var i:int = 0; i < numChildren; i++)
			{
				_children[i].z = i;
			}
		}
		
		public function getChildIndex(child:IBlitSprite):int
		{
			return _children.indexOf(child);
		}
		
		public function setParent(parent:IBlitSprite):void
		{
			this._parent = parent;
		}
		
		public function getParent():IBlitSprite
		{
			return _parent;
		}
		
		public function set globalX(x:int):void
		{
			var parent:IBlitSprite = getParent();
			if (parent)
			{
				this.x = x - parent.globalX;				
			}
			else
			{
				this.x = x;
			}

		}
		
		public function set globalY(y:int):void
		{
			var parent:IBlitSprite = getParent();
			if (parent)
			{
				this.y = y - parent.globalY;				
			}
			else
			{
				this.y = y;
			}
		}
		
		
		public function set globalZ(y:int):void
		{
			var parent:IBlitSprite = getParent();
			if (parent)
			{
				this.z = z - parent.globalZ;				
			}
			else
			{
				this.z = z;
			}
		}
		
		public function get globalX():int
		{
			var parent:IBlitSprite = getParent();
			if (parent)
			{
				return parent.globalX + _x;
			}
			else
			{
				return _x;
			}
		}
		
		public function get globalY():int
		{
			var parent:IBlitSprite = getParent();
			if (parent)
			{
				return parent.globalY + _y;
			}
			else
			{
				return _y;
			}
		}
		
		public function get globalZ():int
		{
			var parent:IBlitSprite = getParent();
			if (parent)
			{
				return parent.globalZ + _z;
			}
			else
			{
				return _z;
			}
		}
		
		public function set x(x:int):void
		{
			var delta:int = x - _x;	

			_x += delta;
			if (delta != 0)
			{
				for each (var child:BlitSprite in _children)
				{
					child.x += delta;
				}
			}
		}
		
		public function set y(y:int):void
		{
			var delta:int = y - _y;	
			
			_y += delta;
			if (delta != 0)
			{
				for each (var child:BlitSprite in _children)
				{
					child.y += delta;
				}
			}
		}
		
		public function set z(z:int):void
		{
			var delta:int = z - _z;	
			
			_z += delta;
			if (delta != 0)
			{
				for each (var child:BlitSprite in _children)
				{
					child.z += delta;
				}
			}
		}
		
		public function get x():int
		{
			return _x;
		}
		
		public function get y():int
		{
			return _y;
		}
		
		public function get z():int
		{
			return _z;
		}
		
		/***
		 * This function is to be overridden and super must be called to draw children
		 */
		public function draw(canvas:BitmapData):void
		{
			//Override or nothing will be seen
			for each (var child:IBlitSprite in _children)
			{
				child.draw(canvas);
			}
		}
		
		public function toString():String
		{
			return "BlitSprite [" + _x +", "+ _y + "]";
		}
	}
}