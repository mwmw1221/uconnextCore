package com.uconnext.ui
{
    import flash.display.Sprite;
    import com.uconnext.api.v1.CurrentTheme;
    import flash.text.TextField;

    public class Button extends Sprite
    {
        public var realW:Number
        public var realH:Number

        public function Button()
        {
            super();
        }

        public function create(width:int, height:int, label:String):Button
        {
            realH = height
            realW = width

            var accentColor:uint = CurrentTheme.currentTheme.accentColor;
            var darkenedColor:uint = CurrentTheme.darkenColor(accentColor, 0.1);
            graphics.beginFill(darkenedColor, 0.8); // 80% opacity
            graphics.drawRoundRect(0, 0, width, height, int(CurrentTheme.currentTheme.roundRadius));
            graphics.endFill();

            var textField:TextField = new TextField();
            textField.text = label;
            textField.x = width / 2 - textField.textWidth / 2;
            textField.y = height / 2 - textField.textHeight / 2;
            textField.textColor = 0xFFFFFF; // White text
            textField.selectable = false;
            addChild(textField);

            return this;
        }
    }
}
