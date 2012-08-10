package  
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import justpinegames.Logi.Console;
	import starling.core.Starling;
	import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	public class LogiExampleScene extends Sprite
	{
		private var _message:TextField;
		
		public function LogiExampleScene()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:starling.events.Event):void
		{			
			log(Starling.current.context.driverInfo);
			log("Logi wants to say Hello!");

			// Create Logi console
			var console:Console = new Console();
			this.stage.addChild(console);
			
			_message = new TextField(400, 60, "Press [Enter] to show the console!\nClick and move the mouse on the screen to log coordinates.");
			_message.color = 0xe4e5de;
			_message.x = this.stage.stageWidth / 2 - _message.width / 2;
			_message.y = this.stage.stageHeight / 2 - _message.height / 2;
			this.addChild(_message);
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);	
			Starling.current.nativeStage.addEventListener(flash.events.Event.RESIZE, resizeDisplay);	
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ENTER) 
			{
				var console:Console = Console.getMainConsoleInstance();
				console.isShown = !console.isShown;
			}
		}
		
		public override function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			var child:DisplayObject = super.hitTest(localPoint, forTouch);
			
			if (child)
			{
				return child;
			}
			
			return this;
		}
		
		public function resizeDisplay(e:flash.events.Event):void
		{
			var newWidth:Number = Starling.current.nativeStage.stageWidth;
			var newHeight:Number = Starling.current.nativeStage.stageHeight;
			
			// Minimum screen size to prevent errors when the dimenstions get to small.
			if (newWidth < 100 || newHeight < 100)
			{
				return;
			}
			
			var viewPortRectangle:Rectangle = new Rectangle();
			viewPortRectangle.width = newWidth;
			viewPortRectangle.height = newHeight;
			Starling.current.viewPort = viewPortRectangle;
			
			stage.stageWidth = newWidth;
			stage.stageHeight = newHeight;
			
			_message.x = this.stage.stageWidth / 2 - _message.width / 2;
			_message.y = this.stage.stageHeight / 2 - _message.height / 2;
		}
		
		private function onTouch(e:TouchEvent):void
		{
			// Display logs when the mouse was dragged or clicked.
			
			var touchMoved:Touch = e.getTouch(this, TouchPhase.MOVED);
			if (touchMoved)
			{
				log("Moved: " + touchMoved.globalX, touchMoved.globalY);
			}
			
			var touchBegan:Touch = e.getTouch(this, TouchPhase.BEGAN);
			if (touchBegan)
			{
				log("Clicked: " + touchBegan.globalX, touchBegan.globalY);
			}
		}
	}
}