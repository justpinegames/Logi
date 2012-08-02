justpinegames.LogConsole
====================

[Introduction post](http://www.justpinegames.com/)

LogConsole is a small AS3 project which offers the user to display the trace on the screen as an overlay.

There are two mods of display:
* Console - can be shown/hidden and looks as a regular commandline prompt
* HUD - when the console is hidden, traces appear for a limited time on the screen.

LogConsole is build on top of Foxhole-Starling so you’ll need that as well as their dependencies.

Creating (in a Starling Sprite, after it’s added to stage):
	var logConsole:LogConsole = new LogConsole();
	this.stage.addChild(logConsole);

Usage:
	log(“Just like the good old trace... ”, 4, 8, 15, 16, 23, 42 );
	
Create with custom settings:
	var settings:ConsoleSettings = new ConsoleSettings();
	// Disable HUD display:
	settings.hudEnabled = false;
	var logConsole:LogConsole = new LogConsole(settings);
	this.stage.addChild(logConsole);
