package com.potmo.util.color{
	public class CIELuvColor{
		/** L from 0.0  **/
		public var l:Number;
		
		/** u from 0.0 **/
		public var u:Number;
		
		/** v from 0.0 **/
		public var v:Number;
		
		public function CIELuvColor(l:Number, u:Number, v:Number)
		{
			this.l = l;
			this.u = u;
			this.v = v;
		}
	}
}