package justpinegames.Logi 
{
    import feathers.controls.Button;
    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.controls.text.BitmapFontTextRenderer;
    import feathers.core.ITextRenderer;
    import feathers.text.BitmapFontTextFormat;

    import starling.text.BitmapFont;
    import starling.textures.TextureSmoothing;

    internal class ConsoleItemRenderer extends Button implements IListItemRenderer
    {
        private static var _format:BitmapFontTextFormat = null;
        private static var _formatHighlight:BitmapFontTextFormat = null;
        
        private var _data:Object;
        private var _index:int;
        private var _owner:List;

        public function ConsoleItemRenderer(labelColor:int, labelColorHighlight:int)
        {
            _index = -1;
            _format = _format ? _format : new BitmapFontTextFormat(new BitmapFont(), 16, labelColor);
            _formatHighlight = _formatHighlight ? _formatHighlight : new BitmapFontTextFormat(new BitmapFont(), 16, labelColorHighlight);

            this.labelFactory = function():ITextRenderer
            {
                return new BitmapFontTextRenderer();
            };
            this.defaultLabelProperties.smoothing = TextureSmoothing.NONE;
            this.defaultLabelProperties.textFormat = new BitmapFontTextFormat(new BitmapFont(), 16, labelColor);
            this.downLabelProperties.smoothing = TextureSmoothing.NONE;
            this.downLabelProperties.textFormat = new BitmapFontTextFormat(new BitmapFont(), 16, labelColor);

            this.horizontalAlign = HORIZONTAL_ALIGN_LEFT;
        }

        public function get data():Object { return _data; }
        public function set data(value:Object):void 
        {
            if (value == null) return;
            _data = value;

            this.label = value.label;
        }
        
        public function get index():int { return _index; }
        public function set index(value:int):void { _index = value; }
        
        public function get owner():List { return _owner; }
        public function set owner(value:List):void { _owner = value; }

    }
}