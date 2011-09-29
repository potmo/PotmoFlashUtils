package com.potmo.util.color
{
	public class RGBColor_2
	{
		private var _r:uint;
		private var _g:uint;
		private var _b:uint;
		public function RGBColor_2(r:uint, g:uint, b:uint)
		{
			_r = r;
			_g = g;
			_b = b;
			
		}
		
		public function setColorFromUint(color:uint):void
		{
			_r = color >> 16 & 0xff;		
			_g = color >> 8 & 0xff;
			_b = color & 0xff;
		}
				
		public function get r():uint
		{
			return _r;
		}
		public function get g():uint
		{
			return _g;
		}
		public function get b():uint
		{
			return _b;
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
		
		public static function uintToRGB(color:uint):RGBColor_2
		{
			var col:RGBColor_2 = new RGBColor_2(0,0,0);
			col.setColorFromUint(color);
			return col;
		}
		
		public static function uintFromRGB(r:uint, g:uint, b:uint):uint{
			var colorR:Number = r << 16;
			var colorG:Number = g << 8;
			var colorB:Number = b;
			
			return colorR | colorG | colorB;
		}
		
		public function getUint():uint
		{
			var colorR:Number = _r << 16;
			var colorG:Number = _g << 8;
			var colorB:Number = _b;
			
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
		
		
		/***
		 * Hue should be between 0 and 360
		 * Saturnation should be between 1 and 100
		 * lightness should be between 1 and 100
		 */
		public static function HSL2RGB(h:Number, s:Number, l:Number):RGBColor_2
		{
			var m1:Number;
			var m2:Number;
			var hue:Number;
			var r:Number;
			var g:Number;
			var b:Number;
			
			s /=100;
			l /= 100;
			if (s == 0)
				r = g = b = (l * 255);
			else {
				if (l <= 0.5)
					m2 = l * (s + 1);
				else
					m2 = l + s - l * s;
				m1 = l * 2 - m2;
				hue = h / 360;
				r = HueToRgb(m1, m2, hue + 1/3);
				g = HueToRgb(m1, m2, hue);
				b = HueToRgb(m1, m2, hue - 1/3);
			}
			return new RGBColor_2(r,g,b);
			
		}
		
		private static function HueToRgb(m1:Number, m2:Number, hue:Number):Number
		{
			var v:Number;
			if (hue < 0)
				hue += 1;
			else if (hue > 1)
				hue -= 1;
			
			if (6 * hue < 1)
				v = m1 + (m2 - m1) * hue * 6;
			else if (2 * hue < 1)
				v = m2;
			else if (3 * hue < 2)
				v = m1 + (m2 - m1) * (2/3 - hue) * 6;
			else
				v = m1;
			
			return 255 * v;
		}
		

	}
}