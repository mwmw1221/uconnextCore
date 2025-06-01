package com.uconnext.api.v1
{
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.errors.IOError;
    import flash.events.IOErrorEvent;
    import com.uconnext.Log;
    import flash.events.EventDispatcher;
    import com.uconnext.ui.Background;
    import com.uconnext.ui.Text;
    import com.uconnext.ui.Button;
    import com.uconnext.ui.Switch;
    import com.uconnext.ui.Slider;
    
    public class CurrentTheme extends EventDispatcher
    {
        private static var themeData:Object;

        public static var COLOR_ACCENT:int = 0;
        public static var COLOR_CONTAINER:int = 1;

        public function CurrentTheme()
        {
            themeData = {
                "name" : "Default",
                "backgroundColor" : 0x000000,
                "textColor" : 0xFFFFFF,
                "accentColor" : 0xFF0000,
                "accentTextColor" : 0x000000,
                "roundRadius" : 10,
                "bgGradient1" : 0x000000,
                "bgGradient2" : 0x333333,
                "containerColor" : 0x444444,
                "containerTextColor" : 0xFFFFFF
            };
        }

        public static function get currentTheme():Object
        {
            return themeData;
        }

        public function setTheme(name:String):void {
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, onLoadComplete);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
            loader.load(new URLRequest("app:/themes.xml"));

            function onLoadComplete(event:Event):void {
                var xml:XML = new XML(loader.data);
                var themes:XMLList = xml.theme;
                for each (var theme:XML in themes) {
                    if (theme.name == name) {
                        themeData = {
                            "name": theme.name.toString(),
                            "backgroundColor": uint(theme.backgroundColor.toString().replace("#", "0x")),
                            "textColor": uint(theme.textColor.toString().replace("#", "0x")),
                            "accentColor": uint(theme.accentColor.toString().replace("#", "0x")),
                            "accentTextColor": uint(theme.accentTextColor.toString().replace("#", "0x")),
                            "roundRadius": int(theme.roundRadius.toString()),
                            "bgGradient1": uint(theme.bgGradient1.toString().replace("#", "0x")),
                            "bgGradient2": uint(theme.bgGradient2.toString().replace("#", "0x")),
                            "containerColor": uint(theme.containerColor.toString().replace("#", "0x")),
                            "containerTextColor": uint(theme.containerTextColor.toString().replace("#", "0x"))
                        };
                        dispatchEvent(new Event(Event.CHANGE));
                        return;
                    }
                }
                Log.log("Theme not found: " + name, "ThemeMgr");
                themeData = {
                "name" : "Placeholder",
                "backgroundColor" : 0x000000,
                "textColor" : 0xFFFFFF,
                "accentColor" : 0xFF0000,
                "accentTextColor" : 0x000000,
                "roundRadius" : 10,
                "bgGradient1" : 0x000000,
                "bgGradient2" : 0x333333,
                "containerColor" : 0x444444,
                "containerTextColor" : 0xFFFFFF
                };
                dispatchEvent(new Event(Event.CHANGE));
            }

            function onLoadError(event:IOErrorEvent):void {
                Log.log("Error loading themes.xml: " + event.text, "ThemeMgr");
                themeData = {
                "name" : "Placeholder",
                "backgroundColor" : 0x000000,
                "textColor" : 0xFFFFFF,
                "accentColor" : 0xFF0000,
                "accentTextColor" : 0x000000,
                "roundRadius" : 10,
                "bgGradient1" : 0x000000,
                "bgGradient2" : 0x333333,
                "containerColor" : 0x444444,
                "containerTextColor" : 0xFFFFFF
                };
                dispatchEvent(new Event(Event.CHANGE));
            }
        }

        public static function ui_Background(stageWidth:int, stageHeight:int):Background {
            return new Background().create(stageWidth, stageHeight);
        }

        public static function ui_BackgroundCustom(width:int, height:int, radius:int, color:int = 0):Background {
            return new Background().createCustom(width, height, radius, color);
        }

        public static function ui_Text():Text {
            return new Text().create();
        }

        public static function ui_Button(width:int, height:int, label:String):Button {
            return new Button().create(width, height, label);
        }

        public static function ui_Switch(width:int, height:int):Switch {
            return new Switch().create(width, height);
        }

        public static function ui_Slider(width:int):Slider {
            return new Slider().create(width);
        }

        //TODO: fix darkenColor function
        public static function darkenColor(colorUint:uint, percentage:Number):uint {
            // Upewnij się, że procent mieści się w zakresie od 0 do 100
            percentage = Math.max(0, Math.min(100, percentage));

            // Oblicz współczynnik przyciemnienia (np. 10% przyciemnienia to 0.9 współczynnika)
            var darkenFactor:Number = 1 - (percentage / 100);

            // Wyodrębnij komponenty ARGB z uint
            var alpha:uint = (colorUint >> 24) & 0xFF;
            var red:uint = (colorUint >> 16) & 0xFF;
            var green:uint = (colorUint >> 8) & 0xFF;
            var blue:uint = colorUint & 0xFF;

            // Przyciemnij każdy komponent RGB
            red = Math.round(red * darkenFactor);
            green = Math.round(green * darkenFactor);
            blue = Math.round(blue * darkenFactor);

            // Upewnij się, że wartości nie są mniejsze niż 0 (choć darkenFactor powinien to zapewnić)
            red = Math.max(0, red);
            green = Math.max(0, green);
            blue = Math.max(0, blue);

            // Złóż komponenty z powrotem w nową wartość uint
            var darkenedColorUint:uint = (alpha << 24) | (red << 16) | (green << 8) | blue;

            return darkenedColorUint;
        }
    }
}