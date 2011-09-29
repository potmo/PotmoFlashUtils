package com.potmo.util.text{
	public class Levenshtein{
		public static function distance(string_1:String, string_2:String, ignoreCase:Boolean = true):int {
			
			if (ignoreCase)
			{
				string_1 = string_1.toLowerCase();
				string_2 = string_2.toLowerCase();
			}
			var matrix:Array=new Array();
			var dist:int;
			for (var i:int=0; i<=string_1.length; i++) {
				matrix[i]=new Array();
				for (var j:int=0; j<=string_2.length; j++) {
					if (i!=0) {
						matrix[i].push(0);
					} else {
						matrix[i].push(j);
					}
				}
				matrix[i][0]=i;
			}
			for (i=1; i<=string_1.length; i++) {
				for (j=1; j<=string_2.length; j++) {
					if (string_1.charAt(i-1)==string_2.charAt(j-1)) {
						dist=0;
					} else {
						dist=1;
					}
					matrix[i][j]=Math.min(matrix[i-1][j]+1,matrix[i][j-1]+1,matrix[i-1][j-1]+dist);
				}
			}
			return matrix[string_1.length][string_2.length];
		}
	}
}