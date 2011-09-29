package com.potmo.util.color.tristimulusReference{
	public class Illuminant
	{
		public static const A:Illuminant = new Illuminant("A");
		public static const C:Illuminant = new Illuminant("C");
		public static const D50:Illuminant = new Illuminant("D50");
		public static const D55:Illuminant = new Illuminant("D55");
		public static const D65:Illuminant = new Illuminant("D65");
		public static const D75:Illuminant = new Illuminant("D75");
		public static const F2:Illuminant = new Illuminant("F2");
		public static const F7:Illuminant = new Illuminant("F7");
		public static const F11:Illuminant = new Illuminant("F11");
		
		public var name:String;
		public function Illuminant(name:String)
		{
			this.name = name;	
		}
	}
}