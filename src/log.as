package  
{
	import Log.LogConsole;
	
	public function log(message:*):void 
	{
		LogConsole.getLogInstance().logMessage(message);
	}
}