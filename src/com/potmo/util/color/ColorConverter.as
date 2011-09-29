package com.potmo.util.color{
	import com.potmo.util.color.tristimulusReference.Illuminant;
	import com.potmo.util.color.tristimulusReference.Observer;
	import com.potmo.util.color.tristimulusReference.TristimulusReference;
	
	/**
	 * Converting colors between different color models
	 * 
	 * Most of the algorithms found at 
	 * http://www.easyrgb.com/index.php?X=MATH
	 * 
	 */
	public class ColorConverter{
		
		/**
		 * Convert RGB to XYZ
		 * @param rgb to be converted
		 * @tristimulusReference the reference values (optional. default is Observer CIE1931 and Illuminant D65) (Not yet implemented)
		 */
		public static function RGB_XYZ(rgb:RGBColor, tristimulusReference:TristimulusReference = null):XYZColor
		{
			
			if (!tristimulusReference)
			{
				tristimulusReference = TristimulusReference.getTristimulus(Observer.CIE1931, Illuminant.D65);
			}
			
			var var_R:Number = ( rgb.r / 255 );        //R from 0 to 255
			var var_G:Number = ( rgb.g / 255 );        //G from 0 to 255
			var var_B:Number = ( rgb.b / 255 );        //B from 0 to 255
			
			if ( var_R > 0.04045 )
			{
				var_R = Math.pow( ( var_R + 0.055 ) / 1.055,  2.4);	
			}
			else
			{
				var_R = var_R / 12.92;
			}
			
			if ( var_G > 0.04045 )
			{
				var_G = Math.pow( ( var_G + 0.055 ) / 1.055, 2.4);	
			}
			else
			{
				var_G = var_G / 12.92;
			}
			
			if ( var_B > 0.04045 )
			{
				var_B = Math.pow( ( var_B + 0.055 ) / 1.055, 2.4);
			}
			else
			{
				var_B = var_B / 12.92;
			}
			
			var_R = var_R * 100;
			var_G = var_G * 100;
			var_B = var_B * 100;
			
			//Observer. = 2°, Illuminant = D65
			var X:Number = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805;
			var Y:Number = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722;
			var Z:Number = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505;
			
			return new XYZColor(X,Y,Z);
		}
		
		public static function XYZ_RGB(xyz:XYZColor):RGBColor
		{
			var var_X:Number = xyz.x / 100;        //X from 0 to  95.047      (Observer = 2°, Illuminant = D65)
			var var_Y:Number = xyz.y / 100;        //Y from 0 to 100.000
			var var_Z:Number = xyz.z / 100;        //Z from 0 to 108.883
			
			var var_R:Number = var_X *  3.2406 + var_Y * -1.5372 + var_Z * -0.4986;
			var var_G:Number = var_X * -0.9689 + var_Y *  1.8758 + var_Z *  0.0415;
			var var_B:Number = var_X *  0.0557 + var_Y * -0.2040 + var_Z *  1.0570;
			
			if ( var_R > 0.0031308 )
			{
				var_R = 1.055 *  Math.pow(var_R,  1 / 2.4 )  - 0.055;	
			}
			else{
				var_R = 12.92 * var_R;
			}   
			if ( var_G > 0.0031308 )
			{
				var_G = 1.055 *  Math.pow(var_G,  1 / 2.4 ) - 0.055;	
			}
			else
			{
				var_G = 12.92 * var_G;	
			}
			if ( var_B > 0.0031308 )
			{
				var_B = 1.055 *  Math.pow(var_B,  1 / 2.4 ) - 0.055;	
			}
			else
			{
				var_B = 12.92 * var_B;	
			}
			
			var R:int = var_R * 255;
			var G:int = var_G * 255;
			var B:int = var_B * 255;
			
			return new RGBColor(R,G,B);
			
		}
		
		public static function XYZ_HunterLab(xyz:XYZColor):HunterLabColor
		{
			var X:Number = xyz.x;
			var Y:Number = xyz.y;
			var Z:Number = xyz.z;
			var HL:Number = 10 * Math.sqrt( Y );
			var Ha:Number = 17.5 * ( ( ( 1.02 * X ) - Y ) / Math.sqrt( Y ) );
			var Hb:Number = 7 * ( ( Y - ( 0.847 * Z ) ) / Math.sqrt( Y ) );
			
			return new HunterLabColor(HL, Ha, Hb);
		}
		
		public static function HunterLab_XYZ(hunter:HunterLabColor):XYZColor
		{
			var var_Y:Number = hunter.l / 10
			var var_X:Number = hunter.a / 17.5 * hunter.l / 10
			var var_Z:Number = hunter.b / 7 * hunter.l / 10
			
			var Y:Number = Math.pow(var_Y,2);
			var X:Number = ( var_X + Y ) / 1.02
			var Z:Number = -( var_Z - Y ) / 0.847
			
			return new XYZColor(X,Y,Z);
		}
		
		public static function XYZ_CIELab(xyz:XYZColor):CIELabColor
		{
			var var_X:Number = xyz.x / 95.047;          //ref_X =  95.047   Observer= 2°, Illuminant= D65
			var var_Y:Number = xyz.y / 100.000;          //ref_Y = 100.000
			var var_Z:Number = xyz.z / 108.883;          //ref_Z = 108.883
			
			if ( var_X > 0.008856 )
			{
				var_X = Math.pow(var_X ,  1.0/3.0 );	
			}
			else
			{
				var_X = ( 7.787 * var_X ) + ( 16.0 / 116.0 )	
			}
			if ( var_Y > 0.008856 )
			{
				var_Y = Math.pow(var_Y ,  1.0/3.0 );	
			}
			else 
			{
				var_Y = ( 7.787 * var_Y ) + ( 16 / 116 );
			}
			if ( var_Z > 0.008856 )
			{
				var_Z = Math.pow(var_Z ,  1.0/3.0 );		
			}
			else
			{
				var_Z = ( 7.787 * var_Z ) + ( 16 / 116 );
			}
			
			var CIEL:Number = ( 116 * var_Y ) - 16;
			var	CIEa:Number = 500 * ( var_X - var_Y );
			var	CIEb:Number = 200 * ( var_Y - var_Z );
			
			return new CIELabColor(CIEL, CIEa, CIEb);						
			
		}
		
		public static function CIELab_XYZ(lab:CIELabColor):XYZColor
		{
			var var_Y:Number = ( lab.l + 16 ) / 116;
			var var_X:Number = lab.a / 500 + var_Y;
			var var_Z:Number = var_Y - lab.b / 200;
			
			if ( Math.pow(var_Y,3) > 0.008856 )
			{
				
			}
			else
			{
				var_Y = ( var_Y - 16 / 116 ) / 7.787;	
			}
			if ( Math.pow(var_X,3) > 0.008856 )
			{
				var_X = Math.pow(var_X,3);
			}
			else
			{
				var_X = ( var_X - 16 / 116 ) / 7.787;	
			}
			if ( Math.pow(var_Z,3) > 0.008856 )
			{
				var_Z = Math.pow(var_Z,3);
			}
			else
			{
				var_Z = ( var_Z - 16 / 116 ) / 7.787	
			}
			
			var X:Number = 95.047  * var_X;     //ref_X =  95.047     Observer= 2°, Illuminant= D65
			var Y:Number = 100.000 * var_Y;     //ref_Y = 100.000
			var Z:Number = 108.883 * var_Z;     //ref_Z = 108.883
			
			return new XYZColor(X,Y,Z);
		}
		
		public static function CIELab_CIELCH(cielab:CIELabColor):CIELCHColor
		{
			var var_H:Number = Math.atan2( cielab.b, cielab.a );  //Quadrant by signs
			
			if ( var_H > 0 )
			{
				var_H = ( var_H / Math.PI ) * 180;
			}
			else
			{
				var_H = 360 - ( Math.abs( var_H ) / Math.PI ) * 180;
			}
			
			var CIEL:Number = cielab.l;
			var	CIEC:Number = Math.sqrt( Math.pow(cielab.a, 2) + Math.pow(cielab.b, 2) );
			var	CIEH:Number = var_H;
			
			return new CIELCHColor(CIEL, CIEC, CIEH);
		}
		
		public static function CIELCH_CIELab(lch:CIELCHColor):CIELabColor
		{
			var CIEL:Number = lch.l;
			var	CIEa:Number = Math.cos(  lch.h * Math.PI/180 ) * lch.c;
			var CIEb:Number = Math.sin(  lch.h * Math.PI/180 ) * lch.c;
			
			return new CIELabColor(CIEL, CIEa, CIEb);
		}
		
		public static function XYZ_CIELuv(xyz:XYZColor):CIELuvColor
		{
			var var_U:Number = ( 4 * xyz.x ) / ( xyz.x + ( 15 * xyz.y ) + ( 3 * xyz.z ) );
			var var_V:Number = ( 9 * xyz.y ) / ( xyz.x + ( 15 * xyz.y ) + ( 3 * xyz.z ) );
			
			var var_Y:Number = xyz.y / 100;
			
			if ( var_Y > 0.008856 )
			{
				var_Y = Math.pow(var_Y, 1/3 );
			}
			else
			{
				var_Y = ( 7.787 * var_Y ) + ( 16 / 116 );	
			}
			
			var ref_X:Number =  95.047;        //Observer= 2°, Illuminant= D65
			var ref_Y:Number = 100.000;
			var ref_Z:Number = 108.883;
			
			var ref_U:Number = ( 4 * ref_X ) / ( ref_X + ( 15 * ref_Y ) + ( 3 * ref_Z ) );
			var ref_V:Number = ( 9 * ref_Y ) / ( ref_X + ( 15 * ref_Y ) + ( 3 * ref_Z ) );
			
			var CIEL:Number = ( 116 * var_Y ) - 16;
			var	CIEu:Number = 13 * CIEL * ( var_U - ref_U );
			var CIEv:Number = 13 * CIEL * ( var_V - ref_V );
			
			return new CIELuvColor(CIEL, CIEu, CIEv);
		}
		
		public static function CIELuv_XYZ(luv:CIELuvColor):XYZColor
		{
			var var_Y:Number = ( luv.l + 16 ) / 116;
			if ( Math.pow(var_Y,3) > 0.008856 )
			{
				var_Y = Math.pow(var_Y,3);
			}
			else
			{
				var_Y = ( var_Y - 16 / 116 ) / 7.787;	
			}
			
			var ref_X:Number =  95.047;      //Observer= 2°, Illuminant= D65
			var ref_Y:Number = 100.000;
			var ref_Z:Number = 108.883;
			
			var ref_U:Number = ( 4 * ref_X ) / ( ref_X + ( 15 * ref_Y ) + ( 3 * ref_Z ) );
			var ref_V:Number = ( 9 * ref_Y ) / ( ref_X + ( 15 * ref_Y ) + ( 3 * ref_Z ) );
			
			var var_U:Number = luv.u / ( 13 * luv.l ) + ref_U;
			var var_V:Number = luv.v / ( 13 * luv.l ) + ref_V;
			
			var Y:Number = var_Y * 100;
			var X:Number =  - ( 9 * Y * var_U ) / ( ( var_U - 4 ) * var_V  - var_U * var_V );
			var Z:Number = ( 9 * Y - ( 15 * var_V * Y ) - ( var_V * X ) ) / ( 3 * var_V );
			
			return new XYZColor(X,Y,Z);
		}
		
		public static function RGB_HSL(rgb:RGBColor):HSLColor
		{
			var var_R:int = ( rgb.r / 255 );                     //RGB from 0 to 255
			var var_G:int = ( rgb.g / 255 );
			var var_B:int = ( rgb.b / 255 );
			
			var var_Min:Number = Math.min( var_R, var_G, var_B );    //Min. value of RGB
			var var_Max:Number = Math.max( var_R, var_G, var_B );    //Max. value of RGB
			var del_Max:Number = var_Max - var_Min;             //Delta RGB value
			
			var L:Number = ( var_Max + var_Min ) / 2;
			var H:Number;
			var S:Number;
			if ( del_Max == 0 )                     //This is a gray, no chroma...
			{
				H = 0                                //HSL results from 0 to 1
				S = 0
			}
			else                                    //Chromatic data...
			{
				if ( L < 0.5 )
				{
					S = del_Max / ( var_Max + var_Min );	
				}
				else
				{
					S = del_Max / ( 2 - var_Max - var_Min );	
				}
				
				var del_R:Number = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
				var del_G:Number = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
				var del_B:Number = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
				
				if      ( var_R == var_Max )
				{
					H = del_B - del_G;	
				}
				else if ( var_G == var_Max )
				{
					H = ( 1 / 3 ) + del_R - del_B;	
				}
				else if ( var_B == var_Max )
				{
					H = ( 2 / 3 ) + del_G - del_R;
				}
				
				if ( H < 0 )
				{
					H += 1;	
				}
				if ( H > 1 )
				{
					H -= 1;	
				}
				
				
			}
			
			return new HSLColor(H,S,L);

		}
		
		public static function HSL_RGB(hsl:HSLColor):RGBColor
		{
			var R:int;
			var G:int;
			var B:int;
			if ( hsl.s == 0 )                       //HSL from 0 to 1
			{
				R = hsl.l * 255;                      //RGB results from 0 to 255
				G = hsl.l * 255;
				B = hsl.l * 255;
			}
			else
			{
				var var_2:Number;
				if ( hsl.l < 0.5 )
				{
					var_2 = hsl.l * ( 1 + hsl.s );
				}
				else
				{
					var_2 = ( hsl.l + hsl.s ) - ( hsl.s * hsl.l );
				}
				
				var var_1:Number = 2 * hsl.l - var_2;
				
				R = 255 * HUE_RGB( var_1, var_2, hsl.h + ( 1 / 3 ) ) ;
				G = 255 * HUE_RGB( var_1, var_2, hsl.h );
				B = 255 * HUE_RGB( var_1, var_2, hsl.h - ( 1 / 3 ) );
			}		
			
			return new RGBColor(R,G,B);

		}
		
		private static function HUE_RGB( v1:Number, v2:Number, vH:Number ):Number
		{
			if ( vH < 0 ) vH += 1;
			if ( vH > 1 ) vH -= 1;
			if ( ( 6 * vH ) < 1 ) return ( v1 + ( v2 - v1 ) * 6 * vH );
			if ( ( 2 * vH ) < 1 ) return ( v2 );
			if ( ( 3 * vH ) < 2 ) return ( v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 );
			return ( v1 );
		}
		
		public static function RGB_HSV(rgb:RGBColor):HSVColor
		{
			var var_R:Number = ( rgb.r / 255 );                     //RGB from 0 to 255
			var var_G:Number = ( rgb.g / 255 );
			var var_B:Number = ( rgb.b / 255 );
			
			var var_Min:Number = Math.min( var_R, var_G, var_B );    //Min. value of RGB
			var var_Max:Number = Math.max( var_R, var_G, var_B );    //Max. value of RGB
			var del_Max:Number = var_Max - var_Min             //Delta RGB value 
			
			var V:Number = var_Max;
			var H:Number;
			var S:Number;
			
			if ( del_Max == 0 )                     //This is a gray, no chroma...
			{
				H = 0;                                //HSV results from 0 to 1
				S = 0;
			}
			else                                    //Chromatic data...
			{
				S = del_Max / var_Max;
				
				var del_R:Number = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
				var del_G:Number = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
				var del_B:Number = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
				
				if ( var_R == var_Max )
				{
					 H = del_B - del_G;
				}
				else if ( var_G == var_Max )
				{
					H = ( 1 / 3 ) + del_R - del_B;	
				}
				else if ( var_B == var_Max )
				{
					H = ( 2 / 3 ) + del_G - del_R;	
				}
				
				if ( H < 0 )
				{
					H += 1	
				}
				if ( H > 1 )
				{
					H -= 1;
				}

			}
			
			return new HSVColor(H,S,V);
		}
		
		public static function HSV_RGB(hsv:HSVColor):RGBColor
		{
			var R:Number;
			var G:Number;
			var B:Number;
			
			if ( hsv.s == 0 )                       //HSV from 0 to 1
			{
				R = hsv.v * 255;
				G = hsv.v * 255;
				B = hsv.v * 255;
			}
			else
			{
				var var_h:Number = hsv.h * 6;
				if ( var_h == 6 )
				{
					var_h = 0;      //H must be < 1	
				}
				var var_i:Number = int( var_h );             //Or ... var_i = floor( var_h )
				var var_1:Number = hsv.v * ( 1 - hsv.s );
				var var_2:Number = hsv.v * ( 1 - hsv.s * ( var_h - var_i ) );
				var var_3:Number = hsv.v * ( 1 - hsv.s * ( 1 - ( var_h - var_i ) ) );
				
				var var_r:Number;
				var var_g:Number;
				var var_b:Number;
				
				if      ( var_i == 0 ) { var_r = hsv.v ; var_g = var_3 ; var_b = var_1 }
				else if ( var_i == 1 ) { var_r = var_2 ; var_g = hsv.v ; var_b = var_1 }
				else if ( var_i == 2 ) { var_r = var_1 ; var_g = hsv.v ; var_b = var_3 }
				else if ( var_i == 3 ) { var_r = var_1 ; var_g = var_2 ; var_b = hsv.v }
				else if ( var_i == 4 ) { var_r = var_3 ; var_g = var_1 ; var_b = hsv.v }
				else                   { var_r = hsv.v ; var_g = var_1 ; var_b = var_2 }
				
				R = var_r * 255;                 //RGB results from 0 to 255
				G = var_g * 255;
				B = var_b * 255;
			}

			return new RGBColor(R,G,B);

		}
		
		
		public static function XYZ_Yxy(xyz:XYZColor):YXYColor
		{
			var Y:Number = xyz.y;
			var x:Number = xyz.x / ( xyz.x + xyz.y + xyz.z );
			var y:Number = xyz.y / ( xyz.x + xyz.y + xyz.z );
			
			return new YXYColor(Y,x,y);
		}
		
		public static function Yxy_XYZ(Yxy:YXYColor):XYZColor
		{
			var X:Number = Yxy.x * ( Yxy.Y / Yxy.y );
			var Y:Number = Yxy.Y;
			var Z:Number = ( 1 - Yxy.x - Yxy.y ) * ( Yxy.Y / Yxy.y );
			
			return new XYZColor(X,Y,Z);
		}
		
		public static function RGB_CMYK(rgb:RGBColor):CMYKColor
		{
			var cyan:Number = 1.0 - rgb.r / 255;
			var magenta:Number = 1.0 - rgb.g / 255;
			var yellow:Number = 1.0 - rgb.b / 255;
			
			var key:Number = Math.min(cyan,magenta,yellow)*0.5;
			
			//avoid division by zero
			if (key == 1.0){
				cyan = 0;
				magenta = 0;
				yellow = 0;
				key = 1;
			}
			
			cyan = (cyan - key) / (1 - key);
			magenta = (magenta - key) / (1 - key);
			yellow = (yellow - key) / (1 - key);
			
			return new CMYKColor(cyan, magenta, yellow, key);
		}
		
		
	}
}