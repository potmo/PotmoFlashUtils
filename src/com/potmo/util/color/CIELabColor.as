package com.potmo.util.color{
	public class CIELabColor{
		/** L from 0.0  **/
		public var l:Number;
		
		/** a from 0.0 **/
		public var a:Number;
		
		/** b from 0.0 **/
		public var b:Number;
		
		public function CIELabColor(l:Number, a:Number, b:Number)
		{
			this.l = l;
			this.a = a;
			this.b = b;
		}
	}
}