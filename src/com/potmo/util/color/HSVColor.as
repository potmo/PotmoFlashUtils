package com.potmo.util.color{
	public class HSVColor{
		/** h from 0.0  **/
		public var h:Number;
		
		/** s from 0.0 **/
		public var s:Number;
		
		/** v from 0.0 **/
		public var v:Number;
		
		public function HSVColor(h:Number, s:Number, v:Number)
		{
			this.h = s;
			this.s = s;
			this.v = v;
		}
	}
}