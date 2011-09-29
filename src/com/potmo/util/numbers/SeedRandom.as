package com.potmo.util.numbers
{
	public class SeedRandom
	{
		
		private static var _seed:int = 0;
				
		public static function set seed(seed:int):void
		{

			SeedRandom._seed = seed;	
		}
		
		/**
		 * Get a random number
		 */
		private static function rnd():Number
		{
			SeedRandom._seed = (SeedRandom._seed*9301+49297) % 233280;
			return SeedRandom._seed/(233280.0);
		}
		
		/**
		 * Get a random number between n and m
		 */
		public static function randomRange(n:Number, m:Number):int
		{
			return SeedRandom.rnd() * (m - n) + n;
		}
		
		/**
		 * Generate a random number between 0 and max
		 */
		public static function random(max:Number = 1):Number
		{
			return SeedRandom.rnd() * max;
		}
	}
}