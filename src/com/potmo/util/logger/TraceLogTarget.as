package com.potmo.util.logger
{

	public class TraceLogTarget implements ILogTarget
	{
		public function TraceLogTarget()
		{
		}


		public function error( text:String ):void
		{
			trace( "ERROR  : " + text );
		}


		public function warning( text:String ):void
		{
			trace( "WARNING: " + text );
		}


		public function info( text:String ):void
		{
			trace( "INFO   : " + text );
		}


		public function debug( text:String ):void
		{
			trace( "DEBUG  : " + text );
		}
	}
}
