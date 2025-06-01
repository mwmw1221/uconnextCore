package com.uconnext.ui
{
    import flash.display.Sprite;
    import com.uconnext.api.v1.CurrentTheme;

    public class Background extends Sprite
    {
        public function Background()
        {
            super();
        }

        public function create(stageWidth:int, stageHeight:int):Background
        {
            var accentColor:uint = (CurrentTheme.currentTheme.containerColor);
            var darkenedColor:uint = CurrentTheme.darkenColor(accentColor, 0.04);
            graphics.beginFill(darkenedColor, 0.4); // 40% opacity because darkenColor is broken
            graphics.drawRoundRect(0, 0, stageWidth, stageHeight, int(CurrentTheme.currentTheme.roundRadius));
            graphics.endFill();
            return this
        }

        public function createCustom(width:int, height:int, radius:int, color:int = 0):Background
        {
            var accentColor:uint = (CurrentTheme.currentTheme.accentColor);
            if(color == 0){
                accentColor = (CurrentTheme.currentTheme.accentColor);
            }else{
                accentColor = (CurrentTheme.currentTheme.containerColor);
            }
            var darkenedColor:uint = CurrentTheme.darkenColor(accentColor, 0.04);
            graphics.beginFill(darkenedColor, 0.4); // 40% opacity because darkenColor is broken
            graphics.drawRoundRect(0, 0, width, height, radius);
            graphics.endFill();
            return this
        }
    }
}