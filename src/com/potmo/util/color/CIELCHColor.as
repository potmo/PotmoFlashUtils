package com.potmo.util.color{
	public class CIELCHColor{
		/** L from 0.0  **/
		public var l:Number;
		
		/** c from 0.0 **/
		public var c:Number;
		
		/** h from 0.0 **/
		public var h:Number;
		
		public function CIELCHColor(l:Number, c:Number, h:Number)
		{
			this.l = l;
			this.c = c;
			this.h = h;
		}
		
		/**
		 * Calculate the CIE94 color difference between two colors (delta E* 94)
		 */
		public static function difference(a:CIELCHColor, b:CIELCHColor):Number
		{
			var kl:Number = 1; // use 2 for textile
			var k1:Number = 0.045; // use 0.048 for textile
			var k2:Number = 0.015; // use 0.014 for textile
			
			var ona:Number = Math.pow( (b.l - a.l) / kl , 2);
			var due:Number = Math.pow( (b.c - a.c) / (1 + k1 * a.c), 2);
			var tre:Number = Math.pow( (b.h - a.h) / (1 + k2 * a.c) , 2);
			
			var deltaE94:Number = Math.sqrt( ona + due + tre );
			
			return deltaE94;
		}
	}
}