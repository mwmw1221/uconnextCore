package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.text.TextField;
	import flash.text.TextFormat;
    import flash.display.Shape;
    import flash.events.Event;
    import ui.Slider;
    import ui.HorizontalSlider;
    import ui.ImageToggleBtn;

	public class ClimateApp extends Sprite
	{
        public var classes:Object = new Object();

        public var stageWidth:int;
        public var stageHeight:int;

        public var pkgName:String;

        private var Log:Class;

        private var driverTempSlider:Slider;
        private var passengerTempSlider:Slider;
        private var fanSpeedSlider:HorizontalSlider;

        private var driverTemp:Number;
        private var passengerTemp:Number;

        public function ClimateApp(){
            super();
        }

        public function init():void
        {
            Log = classes["com.uconnext.Log"];

            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemove);

            Log.log("Climate app initialized.", pkgName);
        }

        private function onAddedToStage(e:Event):void
        {

            var background:Shape = new Shape();
            background.graphics.beginFill(0x191d2e, 0.8);
            background.graphics.drawRoundRect(0, 0, stageWidth, stageHeight, 15, 15);
            background.graphics.endFill();
            addChild(background);

            var menuBar:Shape = new Shape();
            menuBar.graphics.beginFill(0x869af0, 0.2)
            menuBar.graphics.drawRect(0,0,stageWidth,35)
            menuBar.graphics.endFill()
            addChild(menuBar)

            var offBtn:ImageToggleBtn = new ImageToggleBtn("climate_icons/off.png", "climate_icons/off.png", true);
            offBtn.x = 10;
            offBtn.y = 35 / 2 - (30 * 0.7) / 2;
            offBtn.scaleX = 0.7;
            offBtn.scaleY = 0.7;
            addChild(offBtn); // Dodanie przycisku do sceny

            var defrostBtn:ImageToggleBtn = new ImageToggleBtn("climate_icons/defroster.png", "climate_icons/defroster.png", true);
            defrostBtn.x = 40;
            defrostBtn.y = 35 / 2 - (30 * 0.7) / 2;
            defrostBtn.scaleX = 0.7;
            defrostBtn.scaleY = 0.7;
            addChild(defrostBtn); // Dodanie przycisku do sceny

            var syncBtn:ImageToggleBtn = new ImageToggleBtn("climate_icons/sync.png", "climate_icons/sync.png", true);
            syncBtn.x = 70;
            syncBtn.y = 35 / 2 - (30 * 0.7) / 2;
            syncBtn.scaleX = 0.7;
            syncBtn.scaleY = 0.7;
            addChild(syncBtn); // Dodanie przycisku do sceny

            var recirculationBtn:ImageToggleBtn = new ImageToggleBtn("climate_icons/recirculation.png", "climate_icons/recirculation.png", true);
            recirculationBtn.x = 100;
            recirculationBtn.y = 35 / 2 - (30 * 0.7) / 2;
            recirculationBtn.scaleX = 0.7;
            recirculationBtn.scaleY = 0.7;
            addChild(recirculationBtn); // Dodanie przycisku do sceny

            var airConditioningBtn:ImageToggleBtn = new ImageToggleBtn("climate_icons/ac.png", "climate_icons/ac.png", true);
            airConditioningBtn.x = 130;
            airConditioningBtn.y = 35 / 2 - (30 * 0.7) / 2;
            airConditioningBtn.scaleX = 0.7;
            airConditioningBtn.scaleY = 0.7;
            addChild(airConditioningBtn); // Dodanie przycisku do sceny
            
            var maxACBtn:ImageToggleBtn = new ImageToggleBtn("climate_icons/max_ac.png", "climate_icons/max_ac.png", true);
            maxACBtn.x = 160;
            maxACBtn.y = 35 / 2 - (30 * 0.7) / 2;
            maxACBtn.scaleX = 0.7;
            maxACBtn.scaleY = 0.7;
            addChild(maxACBtn); // Dodanie przycisku do sceny

            var autoACBtn:ImageToggleBtn = new ImageToggleBtn("climate_icons/auto_ac.png", "climate_icons/auto_ac.png", true);
            autoACBtn.x = 190;
            autoACBtn.y = 35 / 2 - (30 * 0.7) / 2;
            autoACBtn.scaleX = 0.7;
            autoACBtn.scaleY = 0.7;
            addChild(autoACBtn); // Dodanie przycisku do sceny

            driverTempSlider = new Slider(14, 30, 22);
            addChild(driverTempSlider); // Dodanie suwaka do sceny
            driverTempSlider.y = (stageHeight / 2) - ((185 + 25) / 2) + 20; // Wyśrodkowanie w pionie
            driverTempSlider.addEventListener(Slider.VALUE_CHANGED, function(e:Event):void {
                if (Math.round(driverTemp) != Math.round(driverTempSlider.getValue())) {
                    driverTemp = driverTempSlider.getValue();
                    Log.log("Driver temperature changed to: " + Math.round(driverTempSlider.getValue()), pkgName);
                }
            });

            passengerTempSlider = new Slider(14, 30, 22);
            addChild(passengerTempSlider); // Dodanie suwaka do sceny
            passengerTempSlider.x = stageWidth - passengerTempSlider.width - 20; // Ustawienie pozycji w poziomie
            passengerTempSlider.y = (stageHeight / 2) - ((185 + 25) / 2) + 20; // Wyśrodkowanie w pionie
            passengerTempSlider.addEventListener(Slider.VALUE_CHANGED, function(e:Event):void {
                if (Math.round(passengerTemp) != Math.round(passengerTempSlider.getValue())) {
                    passengerTemp = passengerTempSlider.getValue();
                    Log.log("Passenger temperature changed to: " + Math.round(passengerTempSlider.getValue()), pkgName);
                }
            });

            fanSpeedSlider = new HorizontalSlider(1, 7, 5);
            addChild(fanSpeedSlider); // Dodanie suwaka do sceny
            fanSpeedSlider.x = (stageWidth / 2) - (fanSpeedSlider.width / 2); // Wyśrodkowanie w poziomie
            fanSpeedSlider.y = stageHeight - fanSpeedSlider.height - 20; // Ustawienie pozycji w pionie
            fanSpeedSlider.addEventListener(Slider.VALUE_CHANGED, function(e:Event):void {
                Log.log("Fan speed changed to: " + Math.round(fanSpeedSlider.getValue()), pkgName);
            });

            Log.log("Climate app open.", pkgName);
	    }

        private function onRemove(e:Event):void
        {
            removeChildren();
            Log.log("Climate app closed.", pkgName);
        }
    }
}
