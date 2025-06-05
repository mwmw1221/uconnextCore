package com.uconnext
{
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.profiler.profile;
    import flash.display.Loader;
    import flash.filesystem.File;
    import flash.errors.IOError;
    import flash.display.LoaderInfo;
    import flash.events.EventDispatcher;
    import mx.events.ModuleEvent;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import com.uconnext.Log;
    import flash.text.TextField;
    import flash.display.Stage;
    import flash.display.Sprite;
    import com.uconnext.PeripheralLoader
    import events.FrameworkEvent;
    import com.uconnext.api.v1.Audio;
    import com.uconnext.api.v1.Vehicle;
    import com.uconnext.api.v1.GlobalVars;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;
    import com.nfuzion.moduleLinkAPI.TunerRegion;
    import com.nfuzion.moduleLinkAPI.MarketConverter;
    import com.uconnext.api.v1.CurrentTheme;

    public class Core extends EventDispatcher{
        public static const VERSION:String = "0.2";
        public static const ALL_APPS_READY:String = "allAppsReady";
        public static const PERIPHERAL_READY:String = "peripheralReady";
        public static const VARS_READY:String = "varsReady";

        private var OEM_CONFIG_FILE_NAME:String = "hmiVars";

        public var APP_PATH:String = "";

        private var xmlData:XML;
        private var logBox:TextField;

        public var apps:Array = [];
        public var appLoaders:Array = [];
        public var systemUIIdx:int;

        private var loaded:Boolean = false;
        private var loadedAppsCount:int = 0;

        public var stage:Stage;
        
        public function Core(appPath:String = "pkgs") {
            APP_PATH = "app:/"+appPath
        }
        public function loadCore(logBox:TextField):void {
            trace("")
            Log.log("BOOT STAGE - peripherals ----------------------------", "Core");

            Log.log("Loading HMI variables", "Core");
            Log.log("OEM_CONFIG_FILE_NAME: " + OEM_CONFIG_FILE_NAME, "Core");
            readHMIVars();
            Log.log("HMI variables loaded", "Core");
            dispatchEvent(new Event(VARS_READY));

            Log.log("Loading Peripheral...", "Core");

            var loaderP:PeripheralLoader = new PeripheralLoader()
            loaderP.addEventListener(FrameworkEvent.READY, function(event:FrameworkEvent):void {
                Log.log("Peripheral loaded successfully", "Core");
                onPeripheral();
            });
            loaderP.load();
        }

        private function onPeripheral():void{
            trace("")
            dispatchEvent(new Event(PERIPHERAL_READY));
            Log.log("BOOT STAGE - core init ----------------------------", "Core");
            Log.log("Loading core...", "Core");
            var loader:URLLoader = new URLLoader();
            var appsXml:URLRequest = new URLRequest(APP_PATH+"/pkglist.xml");
            this.logBox = logBox;

            loader.addEventListener(Event.COMPLETE, onXMLLoaded);
            loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);

            loader.load(appsXml);

            Log.log("Core loaded with version: " + VERSION, "Core");
            Log.log("Loading apps from: " + APP_PATH, "Core");
        }

        public function getPackagesList():Array {
            var packagesList:Array = [];
            if (xmlData) {
                for each (var packageNode:XML in xmlData.pkg) {
                    var packageObj:Object = {
                        name: packageNode.name.toString(),
                        version: packageNode.version.toString(),
                        friendlyName: packageNode.friendlyname.toString(),
                        file: packageNode.file.toString(),
                        description: packageNode.description.toString(),
                        isSystem: packageNode.isSystem.toString() == "true",
                        isVisibleInLauncher: packageNode.isVisibleInLauncher.toString() == "true",
                        classDependencies: [],
                        defaultAppBindings: [],
                        icon: packageNode.icon.toString()
                    };

                    // Wczytaj classDependencies
                    for each (var classNode:XML in packageNode.classDependencies.dependency) {
                        packageObj.classDependencies.push(classNode.toString());
                    }

                    for each (var defaultAppNode:XML in packageNode.defaultAppBindings.bind) {
                        packageObj.defaultAppBindings.push(defaultAppNode.toString());
                    }

                    packagesList.push(packageObj);
                    Log.log("Package descriptor loaded: " + packageObj.name.toString() + " - " + packageObj.friendlyName.toString(), "Core");
                    Log.log("Class dependencies: " + packageObj.classDependencies.join(", "), "Core");
                }
            } else {
                Log.log("XML data is not loaded yet.", "Core");
            }
            return packagesList;
        }

        private function onXMLLoaded(event:Event):void {
            xmlData = new XML(event.target.data);
            Log.log("Loaded apps file, parsing XML...", "Core");
            trace("")
            Log.log("BOOT STAGE - parse ----------------------------", "Core");
            apps = getPackagesList()
            Log.log("Parsed XML, found " + apps.length + " packages.", "Core");
            trace("")
            Log.log("BOOT STAGE - load -----------------------------", "Core");
            Log.log("Loading apps...", "Core");
            for each (var app:Object in apps) {
                Log.log("Loading app: " + app.name, "Core");
                appLoaders.push(loadApp(app));
            }
            dispatchEvent(new Event(ModuleEvent.READY))
        }

        private function loadApp(app:Object):Loader {
            loaded = false;
            try{
                var loader:Loader = new Loader();
                Log.log("App file: "+APP_PATH + "/" + app.file, "Core");
                var appRequest:URLRequest = new URLRequest(APP_PATH + "/" + app.file);
                loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
                var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
                loader.load(appRequest, loaderContext);
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
                    onAppLoaded(event, app);
                });
                Log.log("App file loaded: " + app.name, "Core");
                return loader;
            }
            catch (error:IOError) {
                Log.log("Error loading app: " + error.message, "Core");
                return null;
            }
        }

        private function onIOError(event:IOErrorEvent):void {
            Log.log("IOError while loading core: " + event.text, "Core");
        }

        private function onAppLoaded(event:Event, app:Object):void {
            try {
                Log.log("App loaded successfully: " + app.name, "Core");

                // Uzyskaj dostęp do zawartości załadowanego SWF
                var loaderInfo:LoaderInfo = event.target as LoaderInfo;
                var loadedContent:Object = loaderInfo.content;

                if (loadedContent && "classes" in loadedContent) {
                    loadedContent.classes = {}; // Inicjalizuj obiekt classes
                    for each (var className:String in app.classDependencies) {
                        if (className == "com.uconnext.SystemUIEvent") {
                            loadedContent.classes[className] = SystemUIEvent;
                        } else if (className == "com.uconnext.Core") {
                            loadedContent.classes[className] = this;
                        } else if (className == "api.Audio") {
                            loadedContent.classes[className] = Audio;
                        } else if (className == "api.Vehicle") {
                            loadedContent.classes[className] = Vehicle;
                        } else if (className == "api.GlobalVars") {
                            loadedContent.classes[className] = GlobalVars;
                        } else if (className == "api.CurrentTheme") {
                            loadedContent.classes[className] = CurrentTheme;
                        } else {
                            Log.log("Class dependency not found: " + className + ", skipping", "Core");
                        }
                    }
                    loadedContent.classes["com.uconnext.Log"] = Log; // Log jest zawsze dostępny
                } else {
                    Log.log("No classes property found in loaded app: " + app.name, "Core");
                }

                if (loadedContent && "pkgName" in loadedContent) {
                    loadedContent.pkgName = app.name; // Ustawienie pkgName
                } else {
                    Log.log("No pkgName property found in loaded app: " + app.name, "Core");
                }

                // Sprawdź, czy załadowana zawartość ma określoną funkcję
                if (loadedContent && "init" in loadedContent) {
                    Log.log("Calling init() in loaded app: " + app.name, "Core");
                    loadedContent.init(); // Wywołanie funkcji w załadowanym SWF

                    // Wywołaj zdarzenie tylko dla aplikacji com.uconnect.systemui
                    if (app.name == "com.uconnext.systemui") {
                        if (loadedContent && "stageWidth" in loadedContent) {
                            loadedContent.stageWidth = stage.stageWidth; // Ustawienie szerokości sceny
                        }

                        if (loadedContent && "stageHeight" in loadedContent) {
                            loadedContent.stageHeight = stage.stageHeight; // Ustawienie wysokości sceny
                        }

                        if (loadedContent && "apps" in loadedContent) {
                            loadedContent.apps = apps; // Ustawienie szerokości sceny
                        }

                        Log.log("Dispatching SystemUIEvent.UI_READY", "Core");
                        dispatchEvent(new Event(SystemUIEvent.UI_READY));
                    }
                } else {
                    Log.log("Loaded app does not have an initializer function, skipping", "Core");
                }

                Log.log("App " + app.name + " loaded and initialized.", "Core");

                loadedAppsCount++;
                Log.log("Loaded apps count: " + loadedAppsCount + "/" + apps.length, "Core");

                // Sprawdź, czy wszystkie aplikacje zostały załadowane
                if (loadedAppsCount == apps.length) {
                    Log.log("All apps loaded and initialized. Dispatching ALL_APPS_READY event.", "Core");
                    trace("");
                    Log.log("BOOT COMPLETE -------------------------", "Core");
                    trace("");
                    dispatchEvent(new Event(ALL_APPS_READY));
                }
            } catch (error:Error) {
                Log.log("Error in app: " + app.name + " - " + error.message, "Core");
                appLoaders[systemUIIdx].content.showPopup(
                    "Application Error",
                    "An error occurred in app '" + app.name + "': " + error.message,
                    "OK"
                );
            }
        }

        public function openApp(appName:String):void {
            Log.log("Trying to open app:" + appName, "Core")
            var i:int = 0;
            for each (var app:Object in apps) {
                if (app.name == appName) {
                    Log.log("Opening app: " + app.name, "Core");
                    if (appLoaders[i]) {
                        while (appLoaders[systemUIIdx].content.appContainer.numChildren > 0) {
                                appLoaders[systemUIIdx].content.appContainer.removeChildAt(0);
                            }
                            appLoaders[i].content.stageWidth = appLoaders[systemUIIdx].content.appContainer.width;
                            appLoaders[i].content.stageHeight = appLoaders[systemUIIdx].content.appContainer.height;
                        // Dodanie animacji przed otwarciem aplikacji
                        appLoaders[systemUIIdx].content.appContainer.addChild(appLoaders[i]);
                    } else {
                        Log.log("App loader does not exist:" + app.name, "Core");
                    }
                }
                i++;
            }
        }

        public function closeApp(appName:String):void {
            var i:int = 0;
            for each (var app:Object in apps) {
                if (app.name == appName) {
                    Log.log("Closing app: " + app.name, "Core");
                    if (appLoaders[i]) {
                        appLoaders[systemUIIdx].content.appContainer.removeChild(appLoaders[i]);
                    } else {
                        Log.log("App loader does not exist:" + app.name, "Core");
                    }
                }
                i++;
            }
        }

        public function forceCloseActiveApp():void{
            if(appLoaders[systemUIIdx]){
                Log.log("Force closing active apps", "Core");
                while (appLoaders[systemUIIdx].content.appContainer.numChildren > 0) {
                    appLoaders[systemUIIdx].content.appContainer.removeChildAt(0);
                    Log.log("Closed app", "Core");
                }
            }
        }

        public function openAppForDefaultBinding(bind:String):void {
            Log.log("Trying to open app for default binding: " + bind, "Core");
            for each (var app:Object in apps) {
                if (app.defaultAppBindings.indexOf(bind) != -1) {
                    Log.log("Found app for binding: " + app.name, "Core");
                    openApp(app.name);
                    return;
                }
            }
            Log.log("No app found for binding: " + bind, "Core");
            appLoaders[systemUIIdx].content.showPopup("Binding error", "No bound app for binding '"+bind+"'", "OK")
        }

        private function readHMIVars() : void
        {
         var NAVIGATION_ACTIVATED:uint = 0;
         var byteArray:ByteArray = new ByteArray();
         var file:File = File.applicationDirectory.resolvePath(this.OEM_CONFIG_FILE_NAME);
         var fileStream:FileStream = new FileStream();
         try
         {
            fileStream.open(file,FileMode.READ);
            fileStream.readBytes(byteArray,0,fileStream.bytesAvailable - 1);
            GlobalVars.languageId = int(byteArray.readUnsignedByte());
            GlobalVars.themeUrl = byteArray.readUTFBytes(50);
            GlobalVars.skinName = byteArray.readUTFBytes(20);
            GlobalVars.lastBranch = byteArray.readUTFBytes(40);
            GlobalVars.brandId = byteArray.readUnsignedByte();
            switch(byteArray.readUnsignedByte())
            {
               case 0:
                  GlobalVars.region = TunerRegion.EUROPE;
                  break;
               case 7:
                  GlobalVars.region = TunerRegion.ROW;
                  break;
               case 2:
                  GlobalVars.region = TunerRegion.JAPAN;
                  break;
               case 10:
                  GlobalVars.region = TunerRegion.KOREA;
                  break;
               case 11:
                  GlobalVars.region = TunerRegion.CHINA;
                  break;
               case 1:
               default:
                  GlobalVars.region = TunerRegion.NORTH_AMERICA;
            }
            NAVIGATION_ACTIVATED = byteArray.readUnsignedByte();
            GlobalVars.navActivated = NAVIGATION_ACTIVATED == 1 ? true : false;
            GlobalVars.antiTheftState = byteArray.readUTFBytes(10);
            GlobalVars.driverConfiguration = byteArray.readUnsignedByte();
            GlobalVars.comfortConfiguration = byteArray.readUnsignedByte();
            GlobalVars.SRTpackagePrsnt = !!(byteArray.readUnsignedByte() & 1) ? true : false;
            GlobalVars.destinationCode = byteArray.readUnsignedByte();
            GlobalVars.speedlockout = SpeedLockout.getLockout(GlobalVars.destinationCode);
            GlobalVars.market = MarketConverter.getMarketFromDestCode(GlobalVars.destinationCode);
            GlobalVars.region = GlobalVars.market;
         }
         catch(e:Error)
         {
            GlobalVars.brandId = 0;
            GlobalVars.themeUrl = "Default/001_Uconnect.swf";
            GlobalVars.skinName = "default";
            GlobalVars.region = TunerRegion.NORTH_AMERICA;
            if(GlobalVars.region == TunerRegion.NORTH_AMERICA)
            {
               GlobalVars.lastBranch = new String("fmhomescreen");
            }
            else
            {
               GlobalVars.lastBranch = new String("radiohomescreen");
            }
            GlobalVars.market = GlobalVars.region;
            GlobalVars.languageId = 3;
            GlobalVars.navActivated = false;
            GlobalVars.comfortConfiguration = 7;
            GlobalVars.driverConfiguration = 1;
            GlobalVars.SRTpackagePrsnt = false;
            Log.log("Error reading HMI variables: " + e.message, "Core");
         }
         Log.log("HMI Variables: ", "Core");
        Log.log("language :  " + GlobalVars.languageId, "Core");
        Log.log("theme : " + GlobalVars.themeUrl, "Core");
        Log.log("skin : " + GlobalVars.skinName, "Core");
        Log.log("last_screen : " + GlobalVars.lastBranch, "Core");
        Log.log("brand : " + GlobalVars.brandId, "Core");
        Log.log("region_code : " + GlobalVars.region, "Core");
        Log.log("navigation_activated : " + GlobalVars.navActivated, "Core");
        Log.log("antiTheftState : " + GlobalVars.antiTheftState, "Core");
        Log.log("driverConfig : " + GlobalVars.driverConfiguration, "Core");
        Log.log("comfortConfig : " + GlobalVars.comfortConfiguration, "Core");
        Log.log("SRTpackagePrsnt : " + GlobalVars.SRTpackagePrsnt, "Core");
        Log.log("destinationCode : " + GlobalVars.destinationCode, "Core");
        Log.log("---", "Core");
        trace("")

        fileStream.close();
        if(GlobalVars.brandId < 0 || GlobalVars.brandId > 14)
        {
            GlobalVars.brandId = 0;
        }
        switch(GlobalVars.themeUrl.substr(0,4))
        {
            case "Abar":
            case "Alfa":
            case "Chry":
            case "Defa":
            case "Dodg":
            case "Ferr":
            case "Fiat":
            case "Jeep":
            case "Lanc":
            case "Mase":
            case "Ram/":
            case "SRT/":
            case "Vipe":
                break;
            default:
                Log.log("Invalid theme URL, resetting to default", "Core");
                GlobalVars.themeUrl = "Default/001_Uconnect.swf";
        }
        if(GlobalVars.skinName != "default")
        {
            GlobalVars.skinName = "default";
        }
        if(GlobalVars.languageId < 2 || GlobalVars.languageId > 20)
        {
            GlobalVars.languageId = 3;
        }
      }
    }
}