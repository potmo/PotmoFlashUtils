package com.potmo.util.text
{

	public class TextUtil
	{
		public function TextUtil()
		{
		}


		public static function prependZeroes( string:String, minChars:int ):String
		{
			while ( string.length < minChars )
			{
				string = "0" + string;
			}

			return string;
		}
	}
}
