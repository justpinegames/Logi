package Log
{
	import flash.ui.Mouse;
	
	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.controls.Label;
	import org.josht.starling.foxhole.controls.List;
	import org.josht.starling.foxhole.controls.ScrollContainer;
	import org.josht.starling.foxhole.layout.VerticalLayout;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	
	import starling.display.Quad;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	
	import org.josht.starling.display.Sprite
	import starling.events.Event;
	
	import com.gskinner.motion.GTweener;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	
	import flash.events.NativeWindowBoundsEvent;
	
	import starling.core.Starling;

	
	public class LogConsole extends Sprite
	{
		private const ANIMATION_TIME:Number = 0.2;
		
		private var _root:Sprite;
		
		private static var _console: LogConsole = null;
		
		private var _scrolling: ScrollContainer;
		private var _defaultFont:BitmapFont;
		private var _format:BitmapFontTextFormat;
		private var _formatBackground:BitmapFontTextFormat;
		
		
		private var _consoleContainer:Sprite;
		private var _quickMessageContainer:ScrollContainer;
		
		private var _consoleHeight:Number;
		
		private var _consoleVisible:Boolean;
		
		private var _copyButton:Button;
		
		private var _currentlyVisible:Array;
		
		private var _data:Array;
		
		private var _quad:Quad;
		
		private const VERTICAL_PADDING: Number = 5;
		private const HORIZONTAL_PADDING: Number = 5;
		
		public function LogConsole() 
		{
			_data = new Array();
			_currentlyVisible = new Array();
			
			_defaultFont = new BitmapFont();
			_format = new BitmapFontTextFormat(_defaultFont, 16, 0x00ff00);
			_formatBackground = new BitmapFontTextFormat(_defaultFont, 16, 0x000000);
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function get consoleHeight():Number 
		{
			return _consoleHeight;
		}
		
		private function addedToStageHandler(e:Event):void
		{
			_consoleHeight = this.stage.stageHeight / 3;
			
			_consoleVisible = false;
			
			_consoleContainer = new Sprite();
			_consoleContainer.alpha = 0;
			_consoleContainer.y = -this.consoleHeight;

			_quad = new Quad(this.stage.stageWidth, this.consoleHeight, 0x000000);
			_quad.alpha = 0.7;
			_consoleContainer.addChild(_quad);

			
			_scrolling = new ScrollContainer();
			_scrolling.x = HORIZONTAL_PADDING;
			_scrolling.y = VERTICAL_PADDING;
			_scrolling.layout = new VerticalLayout();
			_consoleContainer.addChild(_scrolling);
			
			var buttonDown:BitmapFontTextFormat = new BitmapFontTextFormat(_defaultFont, 16, 0xccffcc);
			_copyButton = new Button();
			_copyButton.labelProperties.smoothing = TextureSmoothing.NONE;
			_copyButton.label = "Copy";
			_copyButton.defaultTextFormat = _format;
			_copyButton.downTextFormat = buttonDown;
			_copyButton.validate();
			//_copyButton.x = _consoleContainer.width - _copyButton.width - horizontalPadding;
			//_copyButton.y = _consoleContainer.height - _copyButton.height - verticalPadding;

			_copyButton.onPress.add(copy);
			_consoleContainer.addChild(_copyButton);
			
			this.addChild(_consoleContainer);
			
			_quickMessageContainer = new ScrollContainer();
			_quickMessageContainer.touchable = false;
			_quickMessageContainer.layout = new VerticalLayout();
			_quickMessageContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			this.addChild(_quickMessageContainer);
			
			_console = this;
			
			resizeComponents(this.stage.stageWidth, this.stage.stageHeight)
			
			Starling.current.nativeStage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, resizeDisplay);

		}
		
		
		
		public function changeTextColor(color:uint):void
		{
			_format.color = color;
		}
		
		public function changeBackgroundColor(color:uint, alpha:Number = 0.7):void
		{
			//_formatBackground.color = color;
			//_quad.alpha = alpha;
		}
		
		private function resizeComponents(width:Number, height:Number):void 
		{
			_consoleHeight = height / 3;
			
			_quad.width = width;
			_quad.height = this.consoleHeight;
			
			_copyButton.x = width - 46 - HORIZONTAL_PADDING;
			_copyButton.y = this.consoleHeight - 24 - VERTICAL_PADDING;
			
			_scrolling.width = this.stage.stageWidth - HORIZONTAL_PADDING * 2;
			_scrolling.height = this.consoleHeight - VERTICAL_PADDING * 2;
			
			if (!_consoleVisible) 
			{
				_consoleContainer.y = -this.consoleHeight;
			}
		}
		
		private function resizeDisplay(e:NativeWindowBoundsEvent):void
		{
			var newWidth:Number = Starling.current.nativeStage.stageWidth;
			var newHeight:Number = Starling.current.nativeStage.stageHeight;
			
			this.resizeComponents(newWidth, newHeight);
		}
		
		public function show():void 
		{
			_consoleContainer.visible = true;
			
			GTweener.to(_consoleContainer, ANIMATION_TIME, { y: 0, alpha: 1 } );
			GTweener.to(_quickMessageContainer, ANIMATION_TIME, { alpha: 0 } );
			
			_consoleVisible = true;
		}
		
		public function hide():void 
		{
			GTweener.to(_consoleContainer, ANIMATION_TIME, { y: -this.consoleHeight, alpha: 0 }).onComplete = function():void 
			{
				_consoleContainer.visible = false;	
			};
			
			GTweener.to(_quickMessageContainer, ANIMATION_TIME, { alpha: 1 } );
			
			_consoleVisible = false;
		}
		
		public function toggle():void 
		{
			if (_consoleVisible) 
			{
				hide();
			}
			else 
			{
				show();
			}
		}
		
		public function copy(button:Button):void
		{
			var text:String = _data.join("\n");
			
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, text);
		}
		
		public function logMessage(thing:*):void 
		{
			var createLabel:Function = function(text:String, format:BitmapFontTextFormat):Label
			{
				var label:Label = new Label();
				label.textFormat = format;
				label.smoothing = TextureSmoothing.NONE;
				label.text = text;
				_data.push(thing.toString());
				label.validate();
				return label;
			};
						
			var consoleLabel:Label = createLabel( (new Date()).toLocaleTimeString() + ": " + thing.toString(), _format);
			
			_scrolling.addChild(consoleLabel);
			
			var quickLabelContainer:Sprite = new Sprite();
			
			var quickLabelBackground:Label = createLabel(thing.toString(), _formatBackground);
			quickLabelBackground.x = -1;
			quickLabelBackground.y = -1;
			var quickLabel:Label = createLabel(thing.toString(), _format);
			
			quickLabelContainer.addChild(quickLabelBackground);
			quickLabelContainer.addChild(quickLabel);
			
			_quickMessageContainer.addChildAt(quickLabelContainer, 0);
			
			GTweener.to(quickLabelContainer, 0.2, { alpha: 0 }, { delay: 2 } ).onComplete = function():void
			{
				_quickMessageContainer.removeChild(quickLabelContainer);
			};
			

			
			trace(thing);
			
	
			
			//TODO: pronaci pravilan nacin kako se scroll do dolje
			_scrolling.verticalScrollPosition = _scrolling.numChildren * 25; //_scrolling.maxVerticalScrollPosition;
			
		}
		
		public static function getLogInstance():LogConsole 
		{
			return _console;
		}
	}
}