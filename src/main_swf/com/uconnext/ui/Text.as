package com.uconnext.ui
{
    import flash.text.TextField;
    import com.uconnext.api.v1.CurrentTheme;

    public class Text extends TextField{
        public function create():Text
        {
            var textColor:uint = (CurrentTheme.currentTheme.accentTextColor);
            this.textColor = textColor;
            return this
        }
    }
}