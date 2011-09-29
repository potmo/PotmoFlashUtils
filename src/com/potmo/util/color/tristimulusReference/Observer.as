package com.potmo.util.color.tristimulusReference{
	public class Observer
	{
		public static const CIE1931:Observer = new Observer("CIE-1931"); // 2 degrees
		public static const CIE1964:Observer = new Observer("CIE-1964"); // 10 degrees
		
		public var name:String;
		public function Observer(name:String)
		{
			this.name = name;
		}
	}
}