package com.potmo.util.color{
	public class HSLColor{
		/** h from 0.0  **/
		public var h:Number;
		
		/** s from 0.0 **/
		public var s:Number;
		
		/** l from 0.0 **/
		public var l:Number;
		
		public function HSLColor(h:Number, s:Number, l:Number)
		{
			this.h = s;
			this.s = s;
			this.l = l;
		}
	}
}