package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import starling.core.Starling;
	
	public class LogiExampleMain extends Sprite 
	{
		private var starling:Starling;
		
		public function LogiExampleMain():void 
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			}
		}
		
		private function init(e:Event = null):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
			
			starling = new Starling(LogiExampleScene, stage);
			starling.start();
		}
	}
}