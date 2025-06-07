package com.uconnext.ui
{
    import flash.display.Sprite;
    import com.uconnext.api.v1.CurrentTheme;

    public class Switch extends Sprite
    {
        private var isOn:Boolean;

        public function Switch()
        {
            super();
            this.isOn = false;
        }

        public function create(width:int, height:int):Switch
        {
            graphics.clear();
            var accentColor:uint = isOn ? CurrentTheme.currentTheme.accentTextColor : CurrentTheme.currentTheme.accentColor;
            var darkenedColor:uint = accentColor
            graphics.beginFill(darkenedColor, 0.6); // 60% opacity
            graphics.drawRoundRect(0, 0, width, height, int(CurrentTheme.currentTheme.roundRadius));
            graphics.endFill();
            return this;
        }

        public function toggle():void
        {
            this.isOn = !this.isOn;
            create(width, height); // Re-render switch with updated state
        }
    }
}
