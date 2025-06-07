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
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.filters.BlurFilter;
    import flash.display.DisplayObject;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

	public class SystemUI extends Sprite
	{

        public var classes:Object = new Object();

        public var stageWidth:int;
        public var stageHeight:int;
        public var apps:Array = [];

        public var pkgName:String;

        private var Log:Class;
        private var Core:Object;
        private var CurrentTheme:Class;
        private var textField:TextField;

        public var appContainer:Sprite;

        public const ICON_SIZE:int = 30; // Rozmiar ikony

        public function SystemUI(){
            super();
        }

        public function init():void
        {
            Log = classes["com.uconnext.Log"];
            Core = classes["com.uconnext.Core"];
            CurrentTheme = classes["api.CurrentTheme"];

            textField = new TextField();
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.x = 100;
            textField.y = 100;
            textField.defaultTextFormat = new TextFormat("Arial", 12, 0xFFFFFF, true);
            textField.text = "SystemUI is initializing...";
            addChild(textField);

            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            Log.log("SystemUI initialized.", pkgName);
        }

        private function onAddedToStage(e:Event):void
        {
            // taskbar gui v2.0


            var taskbarBG:Shape = new Shape();
            taskbarBG.graphics.beginFill(0x0, 1);
            taskbarBG.graphics.drawRect(0, 0, stageWidth, 40);
            taskbarBG.graphics.endFill();
            taskbarBG.x = 0;
            taskbarBG.y = stageHeight - 40;
            addChild(taskbarBG);

            var taskbarTempLeft:TextField = new TextField();
            taskbarTempLeft.textColor = 0xFFFFFF;
            taskbarTempLeft.text = "00°";
            taskbarTempLeft.autoSize = TextFieldAutoSize.LEFT;
            taskbarTempLeft.x = 10;
            taskbarTempLeft.y = taskbarBG.y + taskbarBG.height / 2 - taskbarTempLeft.height / 2;
            addChild(taskbarTempLeft);

            var taskbarTempRight:TextField = new TextField();
            taskbarTempRight.textColor = 0xFFFFFF;
            taskbarTempRight.text = "00°";
            taskbarTempRight.autoSize = TextFieldAutoSize.RIGHT;
            taskbarTempRight.x = stageWidth - 10 - taskbarTempRight.width;
            taskbarTempRight.y = taskbarBG.y + taskbarBG.height / 2 - taskbarTempRight.height / 2;
            addChild(taskbarTempRight);

            var taskbarClockRight:TextField = new TextField();
            taskbarClockRight.textColor = 0xFFFFFF;
            taskbarClockRight.text = "00:00";
            taskbarClockRight.autoSize = TextFieldAutoSize.RIGHT;
            taskbarClockRight.x = stageWidth - 10 - taskbarClockRight.width - taskbarTempRight.width - 10; // Przesunięcie o szerokość temperatury
            taskbarClockRight.y = taskbarBG.y + taskbarBG.height / 2 - taskbarClockRight.height / 2;
            addChild(taskbarClockRight);

            var taskbarCompassLeft:TextField = new TextField();
            taskbarCompassLeft.textColor = 0xFFFFFF;
            taskbarCompassLeft.text = "N";
            taskbarCompassLeft.autoSize = TextFieldAutoSize.LEFT;
            taskbarCompassLeft.x = taskbarTempLeft.x + taskbarTempLeft.width + 10; // Przesunięcie o szerokość temperatury
            taskbarCompassLeft.y = taskbarBG.y + taskbarBG.height / 2 - taskbarCompassLeft.height / 2;
            addChild(taskbarCompassLeft);

            var taskbarIcons:Array = ["appsIcon", "musicIcon", "climateIcon", "phoneIcon"];
            var iconObjs:Array = []
            var iconSize:int = 20; // Rozmiar ikon
            var iconPadding:int = 15; // Odstęp między ikonami
            // ikony wyśrodkowane w taskbarze
            var totalIconsWidth:int = (taskbarIcons.length * iconSize) + ((taskbarIcons.length - 1) * iconPadding);
            var startX:int = (stageWidth - totalIconsWidth) / 2;
            for (var i:int = 0; i < taskbarIcons.length; i++) {
                var icon:Loader = new Loader();
                icon.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
                    var loader:Loader = Loader(e.target.loader);
                    loader.width = iconSize;
                    loader.height = iconSize;
                    Log.log("Taskbar icon loaded: " + loader.name, pkgName);
                });
                icon.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
                    Log.log("Failed to load taskbar icon: " + e.text, pkgName);
                });
                icon.load(new URLRequest("" + taskbarIcons[i] + ".png"));
                icon.x = startX + (i * (iconSize + iconPadding));
                icon.y = taskbarBG.y + taskbarBG.height / 2 - iconSize / 2;
                icon.name = taskbarIcons[i];
                icon.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
                    Log.log("Taskbar icon clicked: " + e.target.name, pkgName);
                    if (e.target.name == "appsIcon") {
                        if (Core && "forceCloseActiveApp" in Core) {
                            Core.forceCloseActiveApp();
                            openAppDrawer();
                            
                        } else {
                            Log.log("forceCloseActiveApp is not available in Core, aborting", pkgName);
                            showPopup("Core error", "forceCloseActiveApp is not available in Core, aborting", "OK")
                        }
                    }

                    else if (e.target.name == "musicIcon") {
                        Log.log("Opening MusicApp", pkgName);
                        Core.openAppForDefaultBinding("media")
                    }
                    else if (e.target.name == "climateIcon") {
                        Log.log("Opening ClimateApp", pkgName);
                        Core.openAppForDefaultBinding("climate");
                    }
                    else if (e.target.name == "phoneIcon") {
                        Log.log("Opening PhoneApp", pkgName);
                        Core.openAppForDefaultBinding("phone");
                    }
                });
                addChild(icon);
                iconObjs.push(icon);
                icon.alpha = 0
            }

            taskbarTempLeft.alpha = 0;
            taskbarTempRight.alpha = 0;
            taskbarClockRight.alpha = 0;
            taskbarCompassLeft.alpha = 0;


            taskbarBG.addEventListener(Event.COMPLETE, function(e:Event):void {
                Log.log("Taskbar animation complete", pkgName);
                animateScaleFadeIn(taskbarTempLeft, 0.5);

                var timer1:Timer = new Timer(250, 1);
                timer1.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
                    animateScaleFadeIn(taskbarCompassLeft, 0.5);

                    var timer2:Timer = new Timer(250, 1);
                    timer2.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
                        animateArray(iconObjs, 0.5);

                        var timer3:Timer = new Timer(250, 1);
                        timer3.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
                            animateScaleFadeIn(taskbarClockRight, 0.5);

                            var timer4:Timer = new Timer(250, 1);
                            timer4.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {
                                animateScaleFadeIn(taskbarTempRight, 0.5);
                            });
                            timer4.start();
                        });
                        timer3.start();
                    });
                    timer2.start();
                });
                timer1.start();
            });
            animateTaskbar(taskbarBG, 1);


            appContainer = new Sprite();
            appContainer.x = 10;
            appContainer.y = 10;
            appContainer.graphics.beginFill(0x000000, 0);
            appContainer.graphics.drawRoundRect(0, 0, stageWidth - 20, stageHeight - 60, 15);
            appContainer.graphics.endFill();
            addChild(appContainer);

            // Dodanie maski z zaokrąglonymi rogami
            var appContainerMask:Shape = new Shape();
            appContainerMask.graphics.beginFill(0x000000, 1);
            appContainerMask.graphics.drawRoundRect(0, 0, stageWidth - 20, stageHeight - 60, 15);
            appContainerMask.graphics.endFill();
            appContainerMask.x = appContainer.x;
            appContainerMask.y = appContainer.y;
            addChild(appContainerMask);
            appContainer.mask = appContainerMask;
            
            removeChild(textField);

	    }

        public function animateTaskbar(taskbar:Shape, duration:Number):void {
            var startY:Number = stageHeight;
            var endY:Number = stageHeight - taskbar.height;
            var startAlpha:Number = 1;
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

        public function animateScaleFadeIn(element:DisplayObject, duration:Number):void {
            var startScale:Number = element.scaleX / 2;
            var endScale:Number = element.scaleX;
            var startAlpha:Number = 0;
            var endAlpha:Number = 1;
            var startTime:Number = new Date().time;
            var endTime:Number = startTime + (duration * 1000);
            var easeInOutFunction:Function = function(t:Number):Number {
            return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
            };

            // Save the original position
            var originalX:Number = element.x + element.width / 2;
            var originalY:Number = element.y + element.height / 2;

            element.scaleX = element.scaleY = startScale;
            element.alpha = startAlpha;

            element.addEventListener(Event.ENTER_FRAME, function(e:Event):void {
            var currentTime:Number = new Date().time;
            var progress:Number = Math.min((currentTime - startTime) / (endTime - startTime), 1);

            progress = easeInOutFunction(progress); // Apply ease-in-out function
            element.scaleX = element.scaleY = startScale + (endScale - startScale) * progress;
            element.alpha = startAlpha + (endAlpha - startAlpha) * progress;

            // Adjust position to keep scaling centered
            element.x = originalX - (element.width / 2);
            element.y = originalY - (element.height / 2);

            if (progress >= 1) {
                element.removeEventListener(Event.ENTER_FRAME, arguments.callee);
            }
            });
        }

        public function animateArray(objects:Array, duration:Number):void
        {
            for(var i:int = 0; i < objects.length; i++) {
                var obj:DisplayObject = objects[i];
                obj.alpha = 0; // Ustawienie początkowej przezroczystości na 0
                animateScaleFadeIn(obj, duration);
            }
        }
        

        public function openAppDrawer():void {
            // Usuń istniejącą zawartość z appContainer
            while (appContainer.numChildren > 0) {
                appContainer.removeChildAt(0);
            }

            const ICON_SIZE:int = 30; // Rozmiar ikony
            const PADDING:int = 30;  // Odstęp między elementami
            const COLUMNS:int = 4;   // Liczba kolumn w siatce
            const MAX_ROWS:int = Math.floor((stageHeight - 110) / (ICON_SIZE + PADDING)); // Maksymalna liczba wierszy
            const LEFT_MARGIN:int = 20; // Margines z lewej strony
            const TOP_MARGIN:int = 20;  // Margines z góry

            var row:int = 0;
            var col:int = 0;

            for each (var app:Object in apps) {
                // Sprawdź, czy aplikacja ma ikonę
                if (app.icon && app.icon != "null") {
                    // Sprawdź, czy aplikacja mieści się w appContainer
                    if (row >= MAX_ROWS) {
                        Log.log("App list exceeds container height. Skipping remaining apps.", pkgName);
                        break; // Przerwij, jeśli przekroczono maksymalną liczbę wierszy
                    }

                    var appIcon:Loader = new Loader();
                    Log.log("Loading app icon: " + app.icon, pkgName);
                    appIcon.contentLoaderInfo.addEventListener(Event.COMPLETE, onIconLoaded);
                    appIcon.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
                        Log.log("Failed to load app icon: " + app.icon, pkgName);
                        showPopup("SystemUI Load error", "Failed to load icon.", "OK")
                    });
                    appIcon.load(new URLRequest(app.icon));
                    appIcon.x = LEFT_MARGIN + col * (ICON_SIZE + PADDING); // Dodanie marginesu z lewej strony
                    appIcon.y = TOP_MARGIN + row * (ICON_SIZE + PADDING); // Dodanie marginesu z góry

                    // Przypisz aplikację do ikony
                    appIcon.name = app.name;

                    // Dodaj obsługę kliknięcia na ikonę aplikacji
                    appIcon.addEventListener(MouseEvent.CLICK, onAppIconClick);

                    appContainer.addChild(appIcon);

                    // Dodaj nazwę aplikacji pod ikoną
                    var appName:TextField = new TextField();
                    appName.defaultTextFormat = new TextFormat("Arial", 12, 0xFFFFFF, true);
                    appName.text = app.friendlyName || app.name;
                    appName.autoSize = TextFieldAutoSize.CENTER;
                    appName.x = appIcon.x + (ICON_SIZE - appName.width) / 2;
                    appName.y = appIcon.y + ICON_SIZE + 5; // Pozycja pod ikoną
                    appContainer.addChild(appName);

                    // Przejdź do następnej kolumny
                    col++;
                    if (col >= COLUMNS) {
                        col = 0;
                        row++;
                    }
                }
            }
        }

        // Dedykowana funkcja obsługi kliknięcia na ikonę aplikacji
        private function onAppIconClick(e:Event):void {
            Log.log("Opening app: " + e.target.name, pkgName);
            Core.openApp(e.target.name);
        }

        // Dedykowana funkcja obsługi zdarzenia COMPLETE
        private function onIconLoaded(e:Event):void {
            var loader:Loader = Loader(e.target.loader);
            loader.width = ICON_SIZE;
            loader.height = ICON_SIZE;
            Log.log("App icon resized: " + loader.name, pkgName);
        }

        public function showPopup(title:String, text:String, buttonText:String):void {
            var popup:Sprite = new Sprite();
            popup.graphics.beginFill(0x333333, 0.9);
            popup.graphics.drawRoundRect(0, 0, 300, 200, 10, 10);
            popup.graphics.endFill();
            popup.x = (stageWidth - 300) / 2;
            popup.y = (stageHeight - 200) / 2;
            addChild(popup);

            // Dodanie efektu rozmycia do appContainer
            appContainer.filters = [new BlurFilter(5, 5)];

            var titleField:TextField = new TextField();
            titleField.defaultTextFormat = new TextFormat("Arial", 16, 0xFFFFFF, true);
            titleField.text = title;
            titleField.autoSize = TextFieldAutoSize.CENTER;
            titleField.x = (popup.width - titleField.width) / 2;
            titleField.y = 20;
            popup.addChild(titleField);

            var textField:TextField = new TextField();
            textField.defaultTextFormat = new TextFormat("Arial", 12, 0xFFFFFF);
            textField.text = text;
            textField.width = 280;
            textField.wordWrap = true;
            textField.x = 10;
            textField.y = 60;
            popup.addChild(textField);

            var closeButton:Sprite = new Sprite();
            closeButton.graphics.beginFill(0x555555);
            closeButton.graphics.drawRoundRect(0, 0, 100, 30, 5, 5);
            closeButton.graphics.endFill();
            closeButton.x = (popup.width - 100) / 2;
            closeButton.y = 150;
            popup.addChild(closeButton);

            var buttonTextfield:TextField = new TextField();
            buttonTextfield.defaultTextFormat = new TextFormat("Arial", 12, 0xFFFFFF, true);
            buttonTextfield.text = buttonText;
            buttonTextfield.autoSize = TextFieldAutoSize.CENTER;
            buttonTextfield.mouseEnabled = false;
            buttonTextfield.x = (closeButton.width - buttonTextfield.width) / 2;
            buttonTextfield.y = (closeButton.height - buttonTextfield.height) / 2;
            closeButton.addChild(buttonTextfield);

            closeButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
                removeChild(popup);
                // Usunięcie efektu rozmycia z appContainer
                appContainer.filters = [];
            });
        }
    }
}
