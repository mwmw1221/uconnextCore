// TODO: API implementations for other features

package
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import com.uconnext.Core;
	import mx.events.ModuleEvent;
	import flash.events.Event;
	import com.uconnext.SystemUIEvent;
	import com.uconnext.Log;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import com.uconnext.DeviceConfig;
	import flash.utils.getDefinitionByName;
	import flash.display.StageQuality;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import org.bytearray.gif.player.GIFPlayer;
	import com.uconnext.api.v1.CurrentTheme;
	import com.uconnext.api.v1.GlobalVars;

	public class uConnext extends Sprite
	{
		internal var core:Core = new Core();
		internal var theme:CurrentTheme = new CurrentTheme();
		internal var launchLog:TextField = new TextField();
		internal var launchLogFormat:TextFormat = new TextFormat("Arial", 12, 0xFFFFFF, true);

		internal var systemUIIdx:int;
		internal var launchBg:Sprite;
		internal var bg:Shape;

		/**
		 * uConnext main class, initializes the core and system UI.
		 * This is the entry point for the uConnext application.
		 */

		public function uConnext()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onStage);

		}

		private function onStage(e:Event):void{
			var ioWindowClass:Object = null;
         	var iow:Object = null;
			try
			{
				ioWindowClass = getDefinitionByName("qnx.display.IowWindow");
				iow = ioWindowClass.getAirWindow();
				iow.id = "hmi";
			}
			catch(e:Error)
			{
				trace("INIT: Error setting IOWindow class: " + e.message + " This is normal if you are not running on QNX.");
			}

			stage.stageFocusRect = false;
         	stage.quality = StageQuality.HIGH;

			Log.clearLogFile()

			stage.color = 0x000000;
			
			bg = new Shape();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(stage.stageWidth, stage.stageHeight, 1.570796, 0, 50); // Tworzenie gradientu na całej scenie

			bg.graphics.beginGradientFill(
				"linear", 
				[0x134ead, 0x031142], // Kolory gradientu
				[1, 1],               // Przezroczystość dla każdego koloru
				[0, 255],             // Podział w połowie
				matrix                // Użycie macierzy transformacji
			);
			bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			bg.graphics.endFill();
			addChild(bg);

			var bg_layer2:Shape = new Shape();
			bg_layer2.graphics.beginFill(0x000000, 0.5);
			bg_layer2.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			bg_layer2.graphics.endFill();
			addChild(bg_layer2);

			launchLog.defaultTextFormat = launchLogFormat;
			launchLog.x = 10;
			launchLog.y = 10;
			launchLog.autoSize = TextFieldAutoSize.LEFT;
			launchLog.text = "uConnext is starting...";
			addChild(launchLog);

			var versionText:TextField = new TextField();
			versionText.textColor = 0xFFFFFF;
			versionText.text = "uConnext core v" + Core.VERSION + "\nAPI v" + DeviceConfig.API_VERSION + "\nLog path: " + Log.logPath;
			versionText.x = 10;
			versionText.y = stage.stageHeight - 40 - versionText.textHeight;
			versionText.autoSize = TextFieldAutoSize.LEFT;
			addChild(versionText);

			launchBg = new Sprite();
            launchBg.graphics.beginFill(0x000000);
            launchBg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            launchBg.graphics.endFill();

			var launchGIF:GIFPlayer = new GIFPlayer();
			launchGIF.load(new URLRequest("app:/ui/loading.gif"));
			launchGIF.addEventListener(Event.COMPLETE, function(e:Event):void{
				launchGIF.play();
				launchGIF.x = (launchBg.width - 150 * 0.5) / 2;
				launchGIF.y = (launchBg.height - 150 * 0.5) / 2;
			});
			launchGIF.scaleX = 0.5;
			launchGIF.scaleY = 0.5;
			launchBg.addChild(launchGIF);

			var launchText:TextField = new TextField();
			launchText.textColor = 0xFFFFFF;
			launchText.text = "Starting...";
			launchText.x = (launchBg.width - launchText.textWidth) / 2;
			launchText.y = (launchBg.height - launchText.textHeight) / 2 - (150 * 0.5) / 2 - 50;
			launchText.autoSize = TextFieldAutoSize.LEFT;
			launchBg.addChild(launchText);
			
            addChild(launchBg);
			addChild(launchLog);

			core.addEventListener(ModuleEvent.READY, onCoreReady)
			core.addEventListener(SystemUIEvent.UI_READY, onUIReady)
			core.addEventListener(Core.ALL_APPS_READY, onAppsReady)
			core.addEventListener(Core.PERIPHERAL_READY, onPeripheralReady)
			core.addEventListener(Core.VARS_READY, onVarsReady);
			core.stage = stage;
			core.loadCore(launchLog);
		}

		private function onVarsReady(e:Event):void{
			Log.log("Variables are ready", "Main");
			launchLog.appendText("\nVariables are ready");
			Log.log("Initializing Theme...", "Main");
			theme.addEventListener(Event.CHANGE, onThemeChange);
			var themeName:String = GlobalVars.themeUrl.replace(".swf", "");
			theme.setTheme(themeName);
		}

		private function onThemeChange(e:Event):void{
			Log.log("Theme changed to: " + CurrentTheme.currentTheme.name, "Main");
			launchLog.appendText("\nTheme changed to: " + CurrentTheme.currentTheme.name);
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(stage.stageWidth, stage.stageHeight, 1.570796, 0, 50); // Tworzenie gradientu na całej scenie
			bg.graphics.clear(); // Czyszczenie poprzedniego gradientu
			bg.graphics.beginGradientFill(
				"linear", 
				[(CurrentTheme.currentTheme.bgGradient1), (CurrentTheme.currentTheme.bgGradient2)], // Kolory gradientu
				[1, 1],               // Przezroczystość dla każdego koloru
				[0, 255],             // Podział w połowie
				matrix                // Użycie macierzy transformacji
			);
			bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			bg.graphics.endFill();
			
		}

		private function onPeripheralReady(e:Event):void{
			launchLog.appendText("\nPeripheral is ready, loading core");
		}

		private function onCoreReady(e:Event):void{
			Log.log("Initialized, waiting for SystemUI to load...", "Main");
			launchLog.appendText("\nCore is ready, waiting for SystemUI to load...");
		}

		private function onUIReady(e:Event):void{
			Log.log("SystemUI is ready", "Main");
			launchLog.appendText("\nSystemUI is ready");
			var i:int = 0;
			for each (var ui:Object in core.apps){
				if(ui.name == "com.uconnext.systemui"){
					Log.log("Adding SystemUI to stage...", "Main");
					launchLog.appendText("\nAdding SystemUI to stage...");
					systemUIIdx = i;
					core.systemUIIdx = i;
					addChild(core.appLoaders[systemUIIdx])
				}
				i++;
			}
			launchLog.appendText("\nWaiting for apps to initialize...")
		}

		private function onAppsReady(e:Event):void{
			core.openAppForDefaultBinding("media")
			removeChild(launchLog);
			removeChild(launchBg);
		}
	}
}
