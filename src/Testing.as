package  
{
	import flash.events.KeyboardEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import justpinegames.Log.LogConsole;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	
	import starling.core.Starling;
	import starling.display.Stage;
	import starling.display.Sprite
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Testing extends Sprite
	{
		public function Testing()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			LogConsole.initializeLogOnStage(this.stage);
			
			trace(10, "10");
			log(12, "10");
			log(10, "10");
			log(10, "10");
			log(10, "10");
			log(10, "10");
			log(10, "10");
			log(10, "10");
			log(10, "10");
			log(10, "10");
			log(10, "10");
			log(11, "10");
			
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			
			Starling.current.nativeStage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, resizeDisplay);
			
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		
		}
		
		private function keyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.ENTER) 
			{
				LogConsole.getLogInstance().toggle();
			}
		}
		
		/// mouseChildren = false
		public override function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			var child:DisplayObject = super.hitTest(localPoint, forTouch);
			
			if (child)
			{
				return child;
			}
			
			return this;
		}
		
		public function resizeDisplay(e:NativeWindowBoundsEvent):void
		{
			var newWidth:Number = Starling.current.nativeStage.stageWidth;
			var newHeight:Number = Starling.current.nativeStage.stageHeight;
			
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
		
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this, TouchPhase.MOVED);
			if (touch)
			{
				log(touch.globalX + ", " + touch.globalY);
			}
		}
	}
}