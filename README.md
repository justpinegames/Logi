justpinegames.Logi
====================

[Introduction post](http://justpinegames.com/blog/2012/08/introducing-logi/)

Logi is a small AS3 project which allows the user to display the trace on the screen as an overlay.

There are two modes of display:
* Console - can be shown/hidden and looks like a regular commandline prompt
* HUD - when the console is hidden, traces appear for a limited time on the screen.

Logi is built on top of foxhole-starling so you’ll need that as well as their dependencies.

Creating (in a Starling Sprite, after it’s added to stage):
    var logConsole:Console = new Console();
    this.stage.addChild(logConsole);

Showing the console:
    var logConsole:Console = Console.getMainConsoleInstance();
    logConsole.isShown = true;

Usage:
    log(“Just like the good old trace... ”, 4, 8, 15, 16, 23, 42 );
    
Create with custom settings:
    var settings:ConsoleSettings = new ConsoleSettings();
    // Disable HUD display:
    settings.hudEnabled = false;
    var logConsole:Console = new Console(settings);
    this.stage.addChild(logConsole);
