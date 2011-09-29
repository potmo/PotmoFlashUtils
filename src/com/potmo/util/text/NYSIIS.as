package com.potmo.util.text{
	
	/**
	 * Encoding of New York State Identification and Intelligence System (NYSIIS)
	 * http://utilitymill.com/utility/nysiis
	 */
	public class NYSIIS{
		

		/**
		 * Encode a string into NYSIIS code. 
		 * @param word the word to be encoded
		 * @param clampTo6Chars optional. Real NYSIIS is only 6 chars long. Truncate it? Defaults to true
		 * @return a NYSIIS encoded string
		 */
		public static function encode(word:String, clampTo6Chars:Boolean = true):String
		{
		
			// uppercase the string
			word = word.toUpperCase();
			
			// trim whitespaces
			word = word.replace(/\s+$/, "");
			
			// remove "JR", "SR", or Roman Numerals from the end of the name
			// (where "Roman Numerals" can be a malformed run of 'I' and 'V' chars)
			var suffix:Array;
			if((suffix = /\s+[JS]R$/.exec(word)) != null || (suffix = /\s+[VI]+$/.exec(word)) != null)
				word = word.substr(0, word.length - suffix[0].length);
			
			// remove all non-alpha characters
			word = word.replace(/[^A-ZÅÄÖ]+/g, "");
			
			// remove all 'S' and 'Z' chars from the end of the surname
			if(/[SZ]+$/.test(word)) {
				word = word.replace(/[SZ]+$/, "");
				if(word.length == 0)
					word = "S";
			}
			
			// change initial MAC to MC and initial PF to F
			if(/^MAC/.test(word))
				word = word.replace(/^MAC/, "MC");
			else if(/^PF/.test(word))
				word = word.replace(/^PF/, "F");
			
			// Change two-character suffix as follows,
			//	                IX -> IC
			//	                EX -> EC
			//	        YE, EE, IE -> Y
			//	DT, RT, RD, NT, ND -> D
			if(/IX$/.test(word))
				word = word.replace(/IX$/, "IC");
			else if(/EX$/.test(word))
				word = word.replace(/EX$/, "EC");
			else if(/YE$|EE$|IE$/.test(word))
				word = word.replace(/YE$|EE$|IE$/, "Y");
			else while(/DT$|RT$|RD$|NT$|ND$/.test(word)) {
				word = word.replace(/DT$|RT$|RD$|NT$|ND$/, "D");
			}
			
			// Change 'EV' to 'EF' if not at start of name
			if(/^EV/.test(word))
				word = "EV" + word.substring(2).replace(/EV/g, "EF");
			else
				word = word.replace(/EV/g, "EF");
			
			// Save first char for later
			// (if first char is a vowel, it is used as first char of code)
			var firstChar:String = word.charAt(0);

			// Remove any 'W' that follows a vowel
			word = word.replace(/([AEIOUÅÄÖ])W/g, "A");
			
			// Replace all vowels with 'A' and collapse all strings of 'A' to one 'A'
			word = word.replace(/[AEIOUÅÄÖ]+/g, "A");
			
			// Change 'GHT' to 'GT'
			word = word.replace(/GHT/g, "GT");
			
			// Change 'DG' to 'G'
			word = word.replace(/DG/g, "G");
			
			// Change 'PH' to 'F'
			word = word.replace(/PH/g, "F");
			
			// If not first character, eliminate all 'H' preceded or followed by a vowel
			if(/^H/.test(word))
				word = "H" + word.substring(1).replace(/AH|HA/g, "A");
			else
				word = word.replace(/AH|HA/g, "A");
			
			// Change 'KN' to 'N', else 'K' to 'C'
			word = word.replace(/KN/g, "N");
			word = word.replace(/K/g, "C");
			
			// If not first character, change 'M' to 'N'
			if(/^M/.test(word))
				word = "M" + word.substring(1).replace(/M/g, "N");
			else
				word = word.replace(/M/g, "N");
			
			// If not first character, change 'Q' to 'G'
			if(/^Q/.test(word))
				word = "Q" + word.substring(1).replace(/Q/g, "G");
			else
				word = word.replace(/Q/g, "G");
			
			// Change 'SH' to 'S'
			word = word.replace(/SH/g, "S");
			
			// Change 'SCH' to 'S'
			word = word.replace(/SCH/g, "S");
			
			// Change 'YW' to 'Y'
			word = word.replace(/YW/, "Y");
			
			// If not first or last character, change 'Y' to 'A'
			if(/^Y/.test(word) && /Y$/.test(word))
				word = "Y" + word.slice(1, -1).replace(/Y/g, "A") + "Y";
			else if(/^Y/.test(word))
				word = "Y" + word.substring(1).replace(/Y/g, "A");
			else if(/Y$/.test(word))
				word = word.slice(0, -1).replace(/Y/g, "A") + "Y";
			else
				word = word.replace(/Y/g, "A");
			
			// Change 'WR' to 'R'
			word = word.replace(/WR/g, "R");
			
			// If not first character, change 'Z' to 'S'
			if(/^Z/.test(word))
				word = "Z" + word.substring(1).replace(/Z/g, "S");
			else
				word = word.replace(/Z/g, "S");
			
			// Change terminal 'AY' to 'Y'
			word = word.replace(/AY$/, "Y");
			
			// remove traling vowels
			word = word.replace(/A+$/, "");
			
			// Collapse all strings of repeated characters
			// This is more brute force that it needs to be
			word = word.replace(/[AEIOU]+/g, "A");
			word = word.replace(/B+/g, "B");
			word = word.replace(/C+/g, "C");
			word = word.replace(/D+/g, "D");
			word = word.replace(/F+/g, "F");
			word = word.replace(/G+/g, "G");
			word = word.replace(/H+/g, "H");
			word = word.replace(/J+/g, "J");
			word = word.replace(/K+/g, "K");
			word = word.replace(/L+/g, "L");
			word = word.replace(/M+/g, "M");
			word = word.replace(/N+/g, "N");
			word = word.replace(/P+/g, "P");
			word = word.replace(/Q+/g, "Q");
			word = word.replace(/R+/g, "R");
			word = word.replace(/S+/g, "S");
			word = word.replace(/T+/g, "T");
			word = word.replace(/V+/g, "V");
			word = word.replace(/W+/g, "W");
			word = word.replace(/X+/g, "X");
			word = word.replace(/Y+/g, "Y");
			word = word.replace(/Z+/g, "Z");
			
			// if first char of original surname is a vowel,
			// use it as first char of code (instead of transcoded 'A')
			if(/^[AEIOU]/.test(firstChar))
				word = word.replace(/^A*/, firstChar);
			
			// Technially, the NYSIIS code is only 6 chars long
			// use the optional param
			if (clampTo6Chars && word.length > 6) {
				word = word.substr(0,6);
			}
			
			return word;
		}
	}
}