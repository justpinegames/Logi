package justpinegames.Logi
{
	import com.gskinner.motion.GTweener;
	import flash.events.Event;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import org.josht.starling.display.Sprite;
	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.controls.Label;
	import org.josht.starling.foxhole.controls.List;
	import org.josht.starling.foxhole.controls.renderers.IListItemRenderer;
	import org.josht.starling.foxhole.controls.ScrollContainer;
	import org.josht.starling.foxhole.core.FoxholeControl;
	import org.josht.starling.foxhole.data.ListCollection;
	import org.josht.starling.foxhole.layout.VerticalLayout;
	import org.josht.starling.foxhole.text.BitmapFontTextFormat;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.textures.TextureSmoothing;

	/**
	 * Main class, used to display console and handle its events.
	 */
	public class Console extends Sprite
	{
		private static var _console:Console;
		private static var _archiveOfUndisplayedLogs:Array = [];
		
		private var _consoleSettings:ConsoleSettings;
		private var _defaultFont:BitmapFont;
		private var _format:BitmapFontTextFormat;
		private var _formatBackground:BitmapFontTextFormat;
		private var _consoleContainer:Sprite;
		private var _hudContainer:ScrollContainer;
		private var _consoleHeight:Number;
		private var _isShown:Boolean;
		private var _copyButton:Button;
		private var _data:Array;
		private var _quad:Quad;
		private var _list:List;
		
		private const VERTICAL_PADDING: Number = 5;
		private const HORIZONTAL_PADDING: Number = 5;
		
		/**
		 * You need to create the instance of this class and add it to the stage in order to use this library.
		 * 
		 * @param	consoleSettings   Optional parameter which can specify the look and behaviour of the console.
		 */
		public function Console(consoleSettings:ConsoleSettings = null) 
		{
			_consoleSettings = consoleSettings ? consoleSettings : new ConsoleSettings();
			
			_console = _console ? _console : this;
			
			_data = [];
			
			_defaultFont = new BitmapFont();
			_format = new BitmapFontTextFormat(_defaultFont, 16, _consoleSettings.textColor);
			_format.letterSpacing = 2;
			_formatBackground = new BitmapFontTextFormat(_defaultFont, 16, _consoleSettings.textBackgroundColor);
			_formatBackground.letterSpacing = 2;
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function get isShown():Boolean 
		{
			return _isShown;
		}
		
		public function set isShown(value:Boolean):void 
		{
			if (_isShown == value) 
			{
				return;
			}
			
			_isShown = value;
			
			if (_isShown) 
			{
				show();
			}
			else 
			{
				hide();
			}
		}
		
		private function addedToStageHandler(e:starling.events.Event):void
		{
			_consoleHeight = this.stage.stageHeight * _consoleSettings.consoleSize;
			
			_isShown = false;
			
			_consoleContainer = new FoxholeControl();
			_consoleContainer.alpha = 0;
			_consoleContainer.y = -_consoleHeight;
			this.addChild(_consoleContainer);
			
			_quad = new Quad(this.stage.stageWidth, _consoleHeight, _consoleSettings.consoleBackground);
			_quad.alpha = _consoleSettings.consoleTransparency;
			_consoleContainer.addChild(_quad);
			
			// TODO Make the list selection work correctly.
			_list = new List();
			_list.x = HORIZONTAL_PADDING;
			_list.y = VERTICAL_PADDING;
			_list.dataProvider = new ListCollection(_data);
			_list.itemRendererFactory = function():IListItemRenderer 
			{
				var consoleItemRenderer:ConsoleItemRenderer = new ConsoleItemRenderer(_consoleSettings.textColor, _consoleSettings.highlightColor);
				consoleItemRenderer.width = _list.width;
				consoleItemRenderer.height = 20;
				return consoleItemRenderer; 
			};
			_list.onChange.add(copyLine);
			_consoleContainer.addChild(_list);
			
			_copyButton = new Button();
			_copyButton.labelProperties.smoothing = TextureSmoothing.NONE;
			_copyButton.label = "Copy All";
			_copyButton.addEventListener(starling.events.Event.ADDED, function(e:starling.events.Event):void
			{
				_copyButton.defaultTextFormat = new BitmapFontTextFormat(_defaultFont, 16, _consoleSettings.textColor);
				_copyButton.downTextFormat = new BitmapFontTextFormat(_defaultFont, 16, _consoleSettings.highlightColor);
				
				_copyButton.disabledSkin = null;
				_copyButton.defaultSkin = null;
				_copyButton.upSkin = null;
				_copyButton.downSkin = null;
				_copyButton.hoverSkin = null;
				
				_copyButton.width = 150;
				_copyButton.height = 40;
			});
			_copyButton.onPress.add(copy);
			_consoleContainer.addChild(_copyButton);
			
			_hudContainer = new ScrollContainer();
			// TODO This should be changed to prevent the hud from even creating, not just making it invisible.
			if (!_consoleSettings.hudEnabled) 
			{
				_hudContainer.visible = false;
			}
			_hudContainer.x = HORIZONTAL_PADDING;
			_hudContainer.y = VERTICAL_PADDING;
			_hudContainer.touchable = false;
			_hudContainer.layout = new VerticalLayout();
			_hudContainer.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
			this.addChild(_hudContainer);
			
			this.setScreenSize(this.stage.stageWidth, this.stage.stageHeight)
			
			for each (var undisplayedMessage:* in _archiveOfUndisplayedLogs) 
			{
				this.logMessage(undisplayedMessage);
			}
			
			_archiveOfUndisplayedLogs = [];
			
			Starling.current.nativeStage.addEventListener(flash.events.Event.RESIZE, function(e:flash.events.Event):void 
			{
				setScreenSize(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
			});
		}
		
		private function setScreenSize(width:Number, height:Number):void 
		{
			_consoleContainer.width = width;
			_consoleContainer.height = height;
			
			_consoleHeight = height * _consoleSettings.consoleSize;
			
			_quad.width = width;
			_quad.height = _consoleHeight;
			
			_copyButton.x = width - 110 - HORIZONTAL_PADDING;
			_copyButton.y = _consoleHeight - 33 - VERTICAL_PADDING;
			
			_list.width = this.stage.stageWidth - HORIZONTAL_PADDING * 2;
			_list.height = _consoleHeight - VERTICAL_PADDING * 2;
			
			if (!_isShown) 
			{
				_consoleContainer.y = -_consoleHeight;
			}
		}
		
		private function show():void 
		{
			_consoleContainer.visible = true;
			
			GTweener.to(_consoleContainer, _consoleSettings.animationTime, { y: 0, alpha: 1 } );
			GTweener.to(_hudContainer, _consoleSettings.animationTime, { alpha: 0 } );
			
			_isShown = true;
		}
		
		private function hide():void 
		{
			GTweener.to(_consoleContainer, _consoleSettings.animationTime, { y: -_consoleHeight, alpha: 0 }).onComplete = function():void 
			{
				_consoleContainer.visible = false;	
			};
			
			GTweener.to(_hudContainer, _consoleSettings.animationTime, { alpha: 1 } );
			
			_isShown = false;
		}
		
		private function copyLine(list:List):void
		{
			//log(list.selectedItem.data);
		}
		
		/**
		 * You can use this data to save a log to the file.
		 * 
		 * @return  Log messages joined into a String with new lines.
		 */
		public function getLogData():String 
		{
			var text:String = "";
			
			for each (var object:Object in _data) 
			{
				text += object.data + "\n";
			}
			
			return text;
		}
		
		private function copy(button:Button):void
		{
			var text:String = this.getLogData();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, text);
		}
		
		/**
		 * Displays the message string in the console, or on the HUD if the console is hidden.
		 * 
		 * @param	message   String to display
		 */
		public function logMessage(message:String):void 
		{
			if (_consoleSettings.traceEnabled)
			{
				trace(message);
			}
			
			var labelDisplay: String = (new Date()).toLocaleTimeString() + ": " + message;
			
			_list.dataProvider.push({label: labelDisplay, data: message});
			
			var createLabel:Function = function(text:String, format:BitmapFontTextFormat):Label
			{
				var label:Label = new Label();
				label.addEventListener(starling.events.Event.ADDED, function(e:starling.events.Event):void
				{
					label.textFormat = format;
				});
				label.smoothing = TextureSmoothing.NONE;
				label.text = text;
				label.validate();
				return label;
			};
			
			var hudLabelContainer:FoxholeControl = new FoxholeControl();
			hudLabelContainer.width = 640;
			hudLabelContainer.height = 20;
			
			var addBackground:Function = function(offsetX:int, offsetY: int):void 
			{
				var hudLabelBackground:Label = createLabel(message, _formatBackground);
				hudLabelBackground.x = offsetX;
				hudLabelBackground.y = offsetY;
				hudLabelContainer.addChild(hudLabelBackground);
			};
			
			addBackground(0, 0);
			addBackground(2, 0);
			addBackground(0, 2);
			addBackground(2, 2);
			
			var hudLabel:Label = createLabel(message, _format);
			hudLabel.x += 1;
			hudLabel.y += 1;
			hudLabelContainer.addChild(hudLabel);
			
			_hudContainer.addChildAt(hudLabelContainer, 0);
			
			GTweener.to(hudLabelContainer, _consoleSettings.hudMessageFadeOutTime, { alpha: 0 }, { delay: _consoleSettings.hudMessageDisplayTime } ).onComplete = function():void
			{
				_hudContainer.removeChild(hudLabelContainer);
			};
				
			// TODO use the correct API, currently there is a problem with List max vertical position. A bug in foxhole?
			_list.verticalScrollPosition = _list.dataProvider.length * 20;
		}
		
		/**
		 * Returns the fist created Console instance.
		 * 
		 * @return Console instance
		 */
		public static function getMainConsoleInstance():Console 
		{
			return _console;
		}
		
		/**
		* Main log function. Usage is the same as for the trace statement.
		* 
		* For data sent to the log function to be displayed, you need to first create a LogConsole instance, and add it to the Starling stage.
		* 
		* @param	... arguments   Variable number of arguments, which will be displayed in the log
		*/
		public static function staticLogMessage(... arguments):void 
		{
			var message:String = "";
			var firstTime:Boolean = true;
			
			for each (var argument:* in arguments)
			{
				if (firstTime)
				{
					message = argument;
					firstTime = false;
				}
				else
				{
					message += ", " + argument;
				}
			}
			
			if (Console.getMainConsoleInstance() == null) 
			{
				_archiveOfUndisplayedLogs.push(message);
			}
			else
			{
				Console.getMainConsoleInstance().logMessage(message);
			}
		}
	}
}