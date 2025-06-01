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
            var topMenu:Sprite = CurrentTheme.ui_BackgroundCustom(stageWidth - 10, 30, uint(CurrentTheme.currentTheme.roundRadius), CurrentTheme.COLOR_CONTAINER);
            topMenu.x = 5
            topMenu.y = 5;
            addChild(topMenu);


            var topMenuText:TextField = CurrentTheme.ui_Text();
            topMenuText.autoSize = TextFieldAutoSize.LEFT
            topMenuText.x = 10
            topMenuText.text = "00° | Not playing"
            topMenuText.y = 11
            addChild(topMenuText)

            var topMenuTextCenter:TextField = CurrentTheme.ui_Text();
            topMenuTextCenter.text = "Mon 00:00 | N"
            topMenuTextCenter.autoSize = TextFieldAutoSize.CENTER
            topMenuTextCenter.x = 10 + topMenu.width / 2 - topMenuText.width / 2
            topMenuTextCenter.y = 11
            addChild(topMenuTextCenter)

            var topMenuTextRight:TextField = CurrentTheme.ui_Text();
            topMenuTextRight.text = "00° out.     00°";
            topMenuTextRight.autoSize = TextFieldAutoSize.RIGHT
            topMenuTextRight.x = topMenu.width - topMenuTextRight.width
            topMenuTextRight.y = 11
            addChild(topMenuTextRight)



            var taskbar:Sprite = CurrentTheme.ui_BackgroundCustom(stageWidth, 60, 0, CurrentTheme.COLOR_CONTAINER);
            taskbar.x = 0;
            taskbar.y = stageHeight - 60;
            addChild(taskbar);

            var totalIcons:int = 4; // Liczba ikon na dolnym pasku
            var spacing:int = (stageWidth - (totalIcons * 60)) / (totalIcons + 1); // Odstęp między ikonami

            var appsIcon:Loader = new Loader();
            appsIcon.load(new URLRequest("appsIcon.png"));
            appsIcon.x = spacing;
            appsIcon.y = stageHeight - 55;
            appsIcon.scaleX = 0.7;
            appsIcon.scaleY = 0.7;
            appsIcon.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
                Log.log("Apps icon loaded.", pkgName);
            });
            appsIcon.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
                showPopup("SystemUI Load error", "Failed to load icon for item 'APPS'", "OK")
            });
            appsIcon.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
                Log.log("Apps icon clicked.", pkgName);
                if (Core && "forceCloseActiveApp" in Core) {
                    Core.forceCloseActiveApp();
                    openAppDrawer();
                    
                } else {
                    Log.log("forceCloseActiveApp is not available in Core, aborting", pkgName);
                    showPopup("Core error", "forceCloseActiveApp is not available in Core, aborting", "OK")
                }
            });
            addChild(appsIcon);

            var appsText:TextField = CurrentTheme.ui_Text();
            appsText.text = "Apps";
            appsText.autoSize = TextFieldAutoSize.CENTER;
            var textOffset:int = 15; // Stała wartość przesunięcia tekstu
            appsText.x = appsIcon.x + (appsIcon.width * appsIcon.scaleX - appsText.textWidth) / 2 + textOffset;
            appsText.y = stageHeight - 7.5 - appsText.textHeight;
            addChild(appsText);

            var musicIcon:Loader = new Loader();
            musicIcon.load(new URLRequest("musicIcon.png"))
            musicIcon.x = appsIcon.x + 60 + spacing;
            musicIcon.y = stageHeight - 55;
            musicIcon.scaleX = 0.7;
            musicIcon.scaleY = 0.7;
            musicIcon.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
                Log.log("Music icon loaded.", pkgName);
            });
            musicIcon.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
                showPopup("SystemUI Load error", "Failed to load icon for item 'MUSIC'", "OK")
            });
            musicIcon.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
                Core.openAppForDefaultBinding("media")
            })
            addChild(musicIcon)

            var musicText:TextField = CurrentTheme.ui_Text();
            musicText.text = "Media";
            musicText.autoSize = TextFieldAutoSize.CENTER;
            musicText.x = musicIcon.x + (musicIcon.width * musicIcon.scaleX - musicText.textWidth) / 2 + textOffset;
            musicText.y = stageHeight - 7.5 - musicText.textHeight;
            addChild(musicText);

            var climateIcon:Loader = new Loader();
            climateIcon.load(new URLRequest("climateIcon.png"))
            climateIcon.x = musicIcon.x + 60 + spacing;
            climateIcon.y = stageHeight - 55;
            climateIcon.scaleX = 0.7;
            climateIcon.scaleY = 0.7;
            climateIcon.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
                Log.log("Climate icon loaded.", pkgName);
            });
            climateIcon.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
                showPopup("SystemUI Load error", "Failed to load icon for item 'CLIMATE'", "OK")
            });
            climateIcon.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
                Core.openAppForDefaultBinding("climate")
            })
            addChild(climateIcon)

            var climateText:TextField = CurrentTheme.ui_Text();
            climateText.text = "Comfort";
            climateText.autoSize = TextFieldAutoSize.CENTER;
            climateText.x = climateIcon.x + (climateIcon.width * climateIcon.scaleX - climateText.textWidth) / 2 + textOffset;
            climateText.y = stageHeight - 7.5 - climateText.textHeight;
            addChild(climateText);

            var phoneIcon:Loader = new Loader();
            phoneIcon.load(new URLRequest("phoneIcon.png"))
            phoneIcon.x = climateIcon.x + 60 + spacing;
            phoneIcon.y = stageHeight - 55;
            phoneIcon.scaleX = 0.7;
            phoneIcon.scaleY = 0.7;
            phoneIcon.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
                Log.log("Phone icon loaded.", pkgName);
            });
            phoneIcon.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void {
                showPopup("SystemUI Load error", "Failed to load icon for item 'PHONE'", "OK")
            });
            phoneIcon.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
                Core.openAppForDefaultBinding("bluetooth")
            })
            addChild(phoneIcon)

            var phoneText:TextField = CurrentTheme.ui_Text();
            phoneText.text = "Phone";
            phoneText.autoSize = TextFieldAutoSize.CENTER;
            phoneText.x = phoneIcon.x + (phoneIcon.width * phoneIcon.scaleX - phoneText.textWidth) / 2 + textOffset;
            phoneText.y = stageHeight - 7.5 - phoneText.textHeight;
            addChild(phoneText);


            appContainer = new Sprite();
            appContainer.x = 10;
            appContainer.y = 40;
            appContainer.graphics.beginFill(0x000000, 0);
            appContainer.graphics.drawRoundRect(0, 0, stageWidth - 20, stageHeight - 110, 15);
            appContainer.graphics.endFill();
            addChild(appContainer);

            // Dodanie maski z zaokrąglonymi rogami
            var appContainerMask:Shape = new Shape();
            appContainerMask.graphics.beginFill(0x000000, 1);
            appContainerMask.graphics.drawRoundRect(0, 0, stageWidth - 20, stageHeight - 110, 15);
            appContainerMask.graphics.endFill();
            appContainerMask.x = appContainer.x;
            appContainerMask.y = appContainer.y;
            addChild(appContainerMask);
            appContainer.mask = appContainerMask;
            
            removeChild(textField);

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
