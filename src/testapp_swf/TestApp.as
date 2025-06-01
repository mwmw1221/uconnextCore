package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.MouseEvent;

	public class TestApp extends Sprite
	{

        public var classes:Object = new Object();

        public var stageWidth:int;
        public var stageHeight:int;

        public var pkgName:String;

        private var Log:Class;
        private var CurrentTheme:Class;

        public function TestApp(){
            super();
        }

        public function init():void
        {
            Log = classes["com.uconnext.Log"];
            CurrentTheme = classes["api.CurrentTheme"];

            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemove);

            Log.log("Test app initialized.", pkgName);
        }

        private function onAddedToStage(e:Event):void
        {
            addChild(CurrentTheme.ui_Background(stageWidth, stageHeight));

            // Dodaj pokazowy przycisk
            var button:Sprite = CurrentTheme.ui_Button(150, 50, "Click Me");
            button.x = stageWidth / 2 - button.width / 2;
            button.y = 70 - button.height / 2;
            button.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
                Log.log("Button clicked!", pkgName);
            });
            addChild(button);

            // Dodaj pokazowy przełącznik
            var switchElement:Object = CurrentTheme.ui_Switch(100, 50);
            switchElement.x = stageWidth / 2 - switchElement.width / 2;
            switchElement.y = 100 - switchElement.height / 2;
            switchElement.addEventListener(MouseEvent.MOUSE_DOWN, function(e:Event):void {
                switchElement.toggle();
                Log.log("Switch toggled.", pkgName);
            });
            addChild(switchElement as Sprite);

            // Dodaj pokazowy suwak
            var slider:Object = CurrentTheme.ui_Slider(300);
            slider.x = stageWidth / 2 - slider.width / 2;
            slider.y = 150 - slider.height / 2;
            addChild(slider as Sprite);

            Log.log("Test app open.", pkgName);
	    }

        private function onRemove(e:Event):void
        {
            removeChildren();
            Log.log("Test app closed.", pkgName);
        }
    }
}
