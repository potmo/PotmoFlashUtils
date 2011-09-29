package com.potmo.util.color{
	public class RGBColor{
		
		/** Red from 0 to 255**/
		public var r:uint; 
		
		/** Green from 0 to 255**/
		public var g:uint;
		
		/** Blue from 0 to 255 **/
		public var b:uint;
		
		public function RGBColor(r:uint, g:uint, b:uint)
		{
			this.r = r;
			this.g = g;
			this.b = b;

		}
		
		public function setColorFromUint(color:uint):void
		{
			r = color >> 16 & 0xff;		
			g = color >> 8 & 0xff;
			b = color & 0xff;
		}
		
		public static function getRedFromUint(color:uint):uint
		{
			return color >> 16 & 0xff;	
		}
		
		public static function getGreenFromUint(color:uint):uint
		{
			return color >> 8 & 0xff;	
		}
		
		public static function getBlueFromUint(color:uint):uint
		{
			return color & 0xff;	
		}
		
		public static function uintToRGB(color:uint):RGBColor
		{
			var col:RGBColor = new RGBColor(0,0,0);
			col.setColorFromUint(color);
			return col;
		}
		
		public static function uintFromRGB(r:uint, g:uint, b:uint):uint
		{
			var colorR:Number = r << 16;
			var colorG:Number = g << 8;
			var colorB:Number = b;
			
			return colorR | colorG | colorB;
		}
		
		public function getUint():uint
		{
			var colorR:Number = r << 16;
			var colorG:Number = g << 8;
			var colorB:Number = b;
			
			return colorR | colorG | colorB;
		}
		
		/**
		 * Gives diff between colors from 0 to 1 where 1 is max diff
		 */
		public static function getRGBDifference(c1:RGBColor_2, c2:RGBColor_2):Number
		{
			
			// get diff
			var rd:int = c1.r - c2.r;
			var gd:int = c1.g - c2.g;
			var bd:int = c1.b - c2.b;
			
			// absolute but faster than abs
			var r:uint = (rd ^ (rd >> 31)) - (rd >> 31);
			var g:uint = (gd ^ (gd >> 31)) - (gd >> 31);
			var b:uint = (bd ^ (bd >> 31)) - (bd >> 31);
			
			//441.67 = sqrt(255*255+255*255+255*255) witch is the max diff possible
			return Math.sqrt(r*r+b*b+g*g)/441.67;
			
		}
		
		/**
		 * Gives diff between colors from 0 to 1 where 1 is max diff
		 */
		public static function getUintDifference(c0:uint, c1:uint):Number
		{
			//convert to rgb
			var r0:uint = c0 >> 16 & 0xff;		
			var g0:uint = c0 >> 8 & 0xff;
			var b0:uint = c0 & 0xff;
			
			var r1:uint = c1 >> 16 & 0xff;		
			var g1:uint = c1 >> 8 & 0xff;
			var b1:uint = c1 & 0xff;
			
			var r:uint = r0-r1;
			var g:uint = g0-g1;
			var b:uint = b0-b1;
			
			//Absolute value but a lot faster
			r = (r ^ (r >> 31)) - (r >> 31);
			g = (g ^ (g >> 31)) - (g >> 31);
			b = (b ^ (b >> 31)) - (b >> 31);
			
			var a:Number = Math.sqrt(255*255+255*255+255*255);
			//441.67 = sqrt(255*255+255*255+255*255) witch is the max diff possible
			return Math.sqrt(r*r+b*b+g*g)/441.67;
		}
	}
}