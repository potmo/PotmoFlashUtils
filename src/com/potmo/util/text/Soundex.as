package com.potmo.util.text{
	
	/**
	 * Soundex encoding class
	 * http://ianserlin.com/index.php/2009/08/02/accurate-actionscript-3-soundex-algorithm-comparing-words-phonetically/
	 */
	public class Soundex{
			public static var SOUNDEX_SIGNIFICANT_CHARS:String = "BFPVCSKGJQXZDTLMNR"; 
			public static var SOUNDEX_REPLACEMENT_CHARS:String = "111122222222334556";
			
			public static function encode(s:String, length:int = 3):String {
				s = squeeze(s.toUpperCase().replace(/^A-Z/, ''));
				var rest:String = transpose( s.substr(1).replace( new RegExp( "[^" + SOUNDEX_SIGNIFICANT_CHARS + "]", "g" ), ''), 
					SOUNDEX_SIGNIFICANT_CHARS, SOUNDEX_REPLACEMENT_CHARS, false );
				return s.charAt(0) + pad(rest, length, "0").substr(0, length);
			}
			
			public static function splitAndEncode(s:String, lengthPerWord:int = 3):String
			{
				var words:Array = s.split(" ");
				var output:String = "";
				
				for each (var word:String in words)
				{
					output += encode(word, lengthPerWord);
				}

				return output;
			}
			
			private static function squeeze(s:String):String {
				return s.replace(/(.)\1+/g, '$1');
			}
			
			private static function frontPad( s:String, desiredLength:Number, characterToPadWith:String ):String {
				while( s.length < desiredLength){
					s = characterToPadWith + s;
				}
				return s;
			}
			
			private static function pad(s:String, desiredLength:Number, characterToPadWith:String):String { 
				while( s.length < desiredLength){
					s += characterToPadWith;
				}
				return s;
			}
			
			private static function transpose( s:String, originalCharacters:String, targetCharacters:String, caseSensitive:Boolean = true ):String {
				var flags:String = caseSensitive ? "g" : "gi";
				for( var i:int = 0; i < originalCharacters.length; i++){
					s = s.replace( new RegExp( originalCharacters.charAt(i), flags) , targetCharacters.charAt(i) );
				}
				return s; 
			}
		}
}