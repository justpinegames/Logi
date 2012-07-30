package  
{
	import justpinegames.Log.LogConsole;
	
	public function log(... arguments):void 
	{
		LogConsole.staticLogMessage.apply(this, arguments);
	}
}