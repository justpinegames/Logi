package justpinegames.Logi 
{
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
    import feathers.controls.text.BitmapFontTextRenderer;
    import feathers.core.FeathersControl;
	import feathers.text.BitmapFontTextFormat;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.textures.TextureSmoothing;
	
	internal class ConsoleItemRenderer extends FeathersControl implements IListItemRenderer
	{
		private static var _format:BitmapFontTextFormat = null;
		private static var _formatHighlight:BitmapFontTextFormat = null;
		
		private var _data:Object;
		private var _index:int;
		private var _owner:List;
		private var _isSelected:Boolean;
		
		private var _label:BitmapFontTextRenderer;
		
		[Event(name="change",type="starling.events.Event")]
		
		public function ConsoleItemRenderer(labelColor:int, labelColorHighlight:int) 
		{	
			_format = _format ? _format : new BitmapFontTextFormat(new BitmapFont(), 16, labelColor);
			_formatHighlight = _formatHighlight ? _formatHighlight : new BitmapFontTextFormat(new BitmapFont(), 16, labelColorHighlight);
			_label = new BitmapFontTextRenderer();
			_label.addEventListener(Event.ADDED, function(e:Event):void
			{
				_label.textFormat = _format;
			});
			_label.smoothing = TextureSmoothing.NONE;
			this.addChild(_label);
		}
		
		public function get data():Object 
		{
			return _data;
		}
		
		public function set data(value:Object):void 
		{
			if (value == null) 
			{
				return;
			}
			
			_label.text = value.label;
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
			if (_isSelected == value) 
			{
				return;
			}
			
			if (value) 
			{
				_label.textFormat = _formatHighlight;
			}
			else 
			{
				_label.textFormat = _format;
			}
			
			_isSelected = value;
			dispatchEventWith(Event.CHANGE);
		}
		 
	}
}