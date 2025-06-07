package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import ui.RadioUI;
    import flash.globalization.CurrencyFormatter;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.display.DisplayObject;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    import com.nfuzion.moduleLinkAPI.TunerEvent;
    import com.nfuzion.moduleLinkAPI.TunerRegion;

    public class MusicApp extends Sprite
    {
        public var classes:Object; // Przekazywane klasy
        public var pkgName:String; // Nazwa pakietu
        
        private var radioUI:RadioUI; // UI radia

        private var CurrentTheme:Class; // Przekazywana klasa z motywem
        private var Log:Class; // Przekazywana klasa logowania
        private var Audio:Object; // Przekazywana klasa audio
        private var GlobalVars:Object

        public var stageWidth:int;
        public var stageHeight:int;

        private var RDS:Boolean = false;

        public function MusicApp()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }

        public function init():void{
            CurrentTheme = classes["api.CurrentTheme"];
            Audio = new classes["api.Audio"] as Object;
            GlobalVars = classes["api.GlobalVars"];
            Log = classes["com.uconnext.Log"];

            reloadRDS();
            Audio.tuner.addEventListener(TunerEvent.STATION_INFO, radioUIHandler);

            Log.log("MusicApp initialized", pkgName);
        }

        private function onAddedToStage(event:Event):void
        {
            radioUI = new RadioUI(CurrentTheme, stageWidth, stageHeight, Audio);
            restoreRadioData()
            reRenderUI(radioUI.uiObjects);
            enterAnimateUIDelayed();
            Log.log("MusicApp added to stage", pkgName);
        }

        private function restoreRadioData():void
        {
            radioUI.onStationInfo(null, Audio, RDS)
        }

        private function onRemovedFromStage(event:Event):void
        {
            removeChildren()
            Log.log("MusicApp removed from stage", pkgName);
        }

        private function radioUIHandler(event:TunerEvent):void
        {
            if(event.type == TunerEvent.STATION_INFO){
                radioUI.onStationInfo(event, Audio, RDS)
            }
        }
        
        private function reRenderUI(uiObjects:Object):void
        {
            removeChildren()

            var bg:Sprite = CurrentTheme.ui_Background(stageWidth, stageHeight);
            addChild(bg);

            for (var key:String in uiObjects) {
                if (uiObjects[key] is DisplayObject) {
                    Log.log("Adding UI object: " + key, pkgName + "::uiRenderer");
                    addChild(uiObjects[key]);
                }
            }
        }

        private function enterAnimateUI():void {
            for (var key:String in radioUI.uiObjects) {
                var uiObject:Object = radioUI.uiObjects[key];
                if (uiObject is DisplayObject) {
                    animate2(uiObject as DisplayObject, 0.5); // Animacja obiektu
                }
            }
        }

        private function enterAnimateUIDelayed():void {
            var keys:Array = [];
            for (var key:String in radioUI.uiObjects) {
                keys.push(key);
                radioUI.uiObjects[key].alpha = 0; // Ustawienie początkowej przezroczystości na 0
            }

            var delay:Number = 75; // Odstęp czasowy między animacjami (w milisekundach)
            var index:int = 0;

            var timer:Timer = new Timer(delay, keys.length);
            timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void {
                var key:String = keys[index];
                var uiObject:Object = radioUI.uiObjects[key];
                if (uiObject is DisplayObject) {
                    animate2(uiObject as DisplayObject, 0.5); // Animacja obiektu
                }
                index++;
            });

            timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(event:TimerEvent):void {
                timer.stop();
                timer.removeEventListener(TimerEvent.TIMER, arguments.callee);
                timer.removeEventListener(TimerEvent.TIMER_COMPLETE, arguments.callee);
            });

            timer.start();
        }

        private function reloadRDS() : void
        {
            if(GlobalVars.market == TunerRegion.CHINA || GlobalVars.market == TunerRegion.KOREA)
            {
                RDS = false;
            }
            else{
                RDS = true;
            }
        }

        public function animate2(taskbar:DisplayObject, duration:Number):void {
            var startY:Number = taskbar.y + 50;
            var endY:Number = taskbar.y;
            var startAlpha:Number = 0;
            var endAlpha:Number = 1;
            var startTime:Number = new Date().time;
            var endTime:Number = startTime + (duration * 1000);
            var easeInOutFunction:Function = function(t:Number):Number {
                return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
            };

            taskbar.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
                var currentTime:Number = new Date().time;
                var progress:Number = Math.min((currentTime - startTime) / (endTime - startTime), 1);

                progress = easeInOutFunction(progress); // Zastosowanie funkcji ease-in-out
                taskbar.y = startY + (endY - startY) * progress;
                taskbar.alpha = startAlpha + (endAlpha - startAlpha) * progress;

                if (progress >= 1) {
                    taskbar.removeEventListener(Event.ENTER_FRAME, arguments.callee);
                    taskbar.dispatchEvent(new Event(Event.COMPLETE)); // Wywołanie zdarzenia COMPLETE po zakończeniu animacji
                }
            });
        }
    }
}