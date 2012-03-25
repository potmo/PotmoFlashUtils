package com.potmo.util.logger
{

	public class Logger
	{

		public static function log( str:String ):void
		{
			trace( " LOG: " + str + " [in " + getCallee() + "]" );
		}


		public static function warn( str:String ):void
		{
			trace( "WARN: " + str + " [in " + getCallee() + "]" );
		}


		public static function error( str:String ):void
		{
			trace( " ERR:" + str + " [in " + getCallee() + "]" );
		}


		private static function getCallee():String
		{
			var e:Error = new Error();
			var s:String = e.getStackTrace();
			var lines:Array = s.split( "\n" );
			// get the fourth line from top (first contains 'Error', the second this function and the third the logger function)
			var line:String = lines[ 3 ];

			var func:String;
			var clazz:String;
			var pack:String = "";

			// get the classname and function if it is in basepacket
			if ( line.indexOf( "::" ) == -1 )
			{
				clazz = line.slice( line.lastIndexOf( "/" ) + 1, line.lastIndexOf( ".as:" ) );
				func = line.slice( line.indexOf( "at " ) + 3, line.indexOf( "(" ) );

			}
			else
			{
				clazz = line.slice( line.lastIndexOf( "/" ) + 1, line.lastIndexOf( ".as:" ) );
				func = line.slice( line.indexOf( "::" ) + 2, line.indexOf( "(" ) );
				pack = line.slice( line.indexOf( "at " ) + 3, line.indexOf( "::" ) );

				if ( func.indexOf( "/" ) != -1 )
				{
					func = func.slice( func.indexOf( "/" ) + 1 );
				}
				else
				{
					func = clazz;
				}

			}

			return pack + "." + clazz + "::" + func + "(...)";
		}
	}
}
