package justpinegames.Log 
{
	import starling.text.TextField;
	import org.josht.starling.foxhole.controls.Label;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	import org.osflash.signals.Signal;
	import starling.display.Sprite;
	import org.osflash.signals.ISignal;
	import org.josht.starling.foxhole.controls.List;
	import org.josht.starling.foxhole.controls.renderers.IListItemRenderer;
	import starling.text.BitmapFont;
	import starling.textures.TextureSmoothing;
	
	internal class ConsoleItemRenderer extends Sprite implements IListItemRenderer
	{
		private var _label:Label;
		private var _data:Object;
		private var _index:int;
		private var _owner:List;
		private var _isSelected:Boolean;
		
		private var _textField:TextField;
		
		private var _onChange:Signal = new Signal(ConsoleItemRenderer);
		 
		
		public function ConsoleItemRenderer() 
		{
			_textField = new TextField(200, 20, "", BitmapFont.MINI);
			_textField.color = 0xffffff;
			this.addChild(_textField);
		}
		
		public function get data():Object 
		{
			return _data;
		}
		
		public function set data(value:Object):void 
		{
			//_label.text = value.toString();
			_textField.text = value as String;
	
			_data = value;
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void 
		{
			_index = value;
		}
		
		public function get owner():List 
		{
			return _owner;
		}
		
		public function set owner(value:List):void 
		{
			_owner = value;
		}
		
		public function get isSelected():Boolean 
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void 
		{
			_isSelected = value;
		}
		
		public function get onChange():ISignal {
			return this._onChange;
		}
				
	}

}