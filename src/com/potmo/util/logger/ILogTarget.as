package com.potmo.util.logger
{

	public interface ILogTarget
	{
		function error( text:String ):void;
		function warning( text:String ):void;
		function info( text:String ):void;
		function debug( text:String ):void;
	}
}
