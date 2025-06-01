package peripheral
{
   import com.harman.moduleLink.*;
   import com.harman.moduleLinkAPI.*;
   import com.nfuzion.moduleLink.*;
   import com.nfuzion.moduleLinkAPI.*;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import com.uconnext.Log;
   import com.harman.framework.controller.ListController;
   import com.harman.framework.controller.ListControllerBuffer;
   import events.FrameworkEvent;
   import com.uconnext.api.v1.GlobalVars;
   
   public class Peripheral extends EventDispatcher
   {
      public static var audioManager:IAudioManager;
      
      public static var audioSettings:IAudioSettings;
      
      public static var bluetooth:IBluetooth;
      
      public static var bluetoothPhone:IBluetoothPhone;
      
      public static var climate:IClimate;
      
      public static var clock:IClock;
      
      public static var hvac:IHvac;
      
      public static var ics:IICS;
      
      public static var mediaPlayer:IMediaPlayer;
      
      public static var persistency:Persistency;
      
      public static var personalConfig:IPersonalConfig;
      
      public static var phonebook:IPhoneBook;
      
      public static var phoneCallList:IPhoneCallList;
      
      public static var presetPersistencyManager:IPresetPersistencyManager;
      
      public static var satelliteRadio:ISatelliteRadio;
      
      public static var satelliteRadioIR:ISatelliteRadioInstantReplay;
      
      public static var smsMessaging:ISMSMessaging;
      
      public static var swc:ISWC;
      
      public static var textToSpeach:ITextToSpeech;
      
      public static var travelLink:ITravelLink;
      
      public static var tuner:IHdTuner;
      
      public static var vehConfig:IVehConfig;
      
      public static var location:ILocation;
      
      public static var vehSettings:IVehSettings;
      
      public static var voiceRecognition:IVoiceRecognition;
      
      public static var ams:IAMS;
      
      public static var amsFileInfo:IAmsFileInfo;
      
      public static var antiTheft:IAntiTheft;
      
      public static var appManager:IAppManager;
      
      public static var audioMixerManager:IAudioMixerManager;
      
      public static var Camera:ICameraUpdate;
      
      public static var connectionManager:IConnectionManager;
      
      public static var cvpdemo:ICVPDemo;
      
      public static var dabApp:IDABApp;
      
      public static var dabTunerControl:IDABTunerControl;
      
      public static var dabTunerFollowMaster:IDABTunerFollowMaster;
      
      public static var dabTunerStation:IDABTunerStation;
      
      public static var dBusTraceMonitor:IDBusTraceMonitor;
      
      public static var diagnostics:IDiagnostics;
      
      public static var displayManager:IDisplayManager;
      
      public static var hmiRequest:IHMIRequest;
      
      public static var ipaddressInfo:IIPAddressInfo;
      
      public static var naviSyncTool:INaviSyncTool;
      
      public static var omapTemp:OmapTemp;
      
      public static var beaconDSRC:IBeaconDSRCHMI;
      
      public static var vicsTuner:IVicsTunerHMI;
      
      public static var vicsDSRCEtcDiag:IVicsDSRCEtcDiagHMI;
      
      public static var vicsDiagEngMenu:IVicsDiagEngMenuHMI;
      
      public static var vicsFMHMI:IVicsFMHMI;
      
      public static var vicsEtcHMI:IVicsEtcHMI;
      
      public static var kanjiHMI:IKanjiHMI;
      
      public static var performanceInfo:IPerformanceInfo;
      
      public static var pps:IPPS;
      
      public static var rse:IRse;
      
      public static var sierraUpdate:ISierraUpdate;
      
      public static var softwareUpdate:ISoftwareUpdate;
      
      public static var vehicleStatus:IVehicleStatus;
      
      public static var driveMode:IDriveMode;
      
      public static var versionInfo:IVersionInfo;
      
      public static var wifiService:IWiFiService;
      
      public static var ecallsvc:IECallSvc;
      
      public static var ipodTagger:iPodTagger;
      
      public static var spellerManager:ISpellerManager;
      
      public static var dmbManager:IDMBManager;
      
      public static var hardControls:HardControls;
      
      public static var presetManager:PresetManager;
      
      public static var mListScreen:MovieClip;
      
      public static var instance:Peripheral;
      
      private static const DEFAULT_REGION:String = TunerRegion.NORTH_AMERICA;
      
      private static const PRIORITY_HIGHEST:int = 5;
      
      private static const PRIORITY_LOWEST:int = 0;
      
      private static const MODULE_MANIFEST:Array = [{
         "propertyName":"personalConfig",
         "type":PersonalConfig,
         "priority":5,
         "synchronous":true
      },{
         "propertyName":"persistency",
         "type":Persistency,
         "priority":5,
         "synchronous":true
      },{
         "propertyName":"tuner",
         "type":HdTuner,
         "priority":5,
         "synchronous":true,
         "postprocess":function():void
         {
            Peripheral.tuner.setRegion(GlobalVars.region);
            Peripheral.tuner.setMarket(GlobalVars.market);
         }
      },{
         "propertyName":"Camera",
         "type":CameraUpdate,
         "priority":5,
         "synchronous":true
      },{
         "propertyName":"rse",
         "type":Rse,
         "priority":5,
         "synchronous":true
      },{
         "propertyName":"vehicleStatus",
         "type":VehicleStatus,
         "priority":5,
         "synchronous":true
      },{
         "propertyName":"driveMode",
         "type":DriveMode,
         "priority":5,
         "synchronous":true
      },{
         "propertyName":"vehConfig",
         "type":VehConfig,
         "priority":4,
         "synchronous":false
      },{
         "propertyName":"bluetooth",
         "type":Bluetooth,
         "priority":4,
         "synchronous":true
      },{
         "propertyName":"bluetoothPhone",
         "type":BluetoothPhone,
         "priority":4,
         "synchronous":true,
         "postprocess":function():void
         {
            Peripheral.phonebook = Peripheral.bluetoothPhone.phoneBook;
            Peripheral.phoneCallList = Peripheral.bluetoothPhone.callList;
            Peripheral.phonebook.initBt(Peripheral.bluetooth);
            Peripheral.phoneCallList.initBt(Peripheral.bluetooth);
         }
      },{
         "propertyName":"cvpdemo",
         "type":CVPDemo,
         "priority":4,
         "synchronous":true
      },{
         "propertyName":"ecallsvc",
         "type":ECallSvc,
         "priority":4,
         "synchronous":true
      },{
         "propertyName":"ics",
         "type":ICS,
         "priority":3,
         "synchronous":true
      },{
         "propertyName":"presetPersistencyManager",
         "type":PresetPersistencyManager,
         "priority":3,
         "synchronous":true,
         "preprocess":function():void
         {
            Peripheral.presetPersistencyManager.init(Peripheral.tuner.region);
         }
      },{
         "propertyName":"swc",
         "type":SWC,
         "priority":2,
         "synchronous":true
      },{
         "propertyName":"pps",
         "type":PPS,
         "priority":2,
         "synchronous":true
      },{
         "propertyName":"versionInfo",
         "type":VersionInfo,
         "priority":1,
         "synchronous":true
      },{
         "propertyName":"audioSettings",
         "type":AudioSettings,
         "priority":1,
         "synchronous":false
      },{
         "propertyName":"audioManager",
         "type":AudioManager,
         "priority":1,
         "synchronous":false
      },{
         "propertyName":"climate",
         "type":Climate,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"clock",
         "type":Clock,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"hvac",
         "type":Hvac,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"mediaPlayer",
         "type":MediaPlayer,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"satelliteRadio",
         "type":SatelliteRadio,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"satelliteRadioIR",
         "type":SatelliteRadioInstantReplay,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"smsMessaging",
         "type":SMSMessaging,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"textToSpeach",
         "type":TextToSpeech,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"travelLink",
         "type":TravelLink,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"vehSettings",
         "type":VehSettings,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"location",
         "type":Location,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"voiceRecognition",
         "type":VoiceRecognition,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"antiTheft",
         "type":AntiTheft,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"ams",
         "type":AMS,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"amsFileInfo",
         "type":AmsFileInfo,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"appManager",
         "type":AppManager,
         "priority":0,
         "synchronous":false
      },{
         "propertyName":"audioMixerManager",
         "type":AudioMixerManager,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"connectionManager",
         "type":ConnectionManager,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"dabApp",
         "type":DABApp,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"dabTunerControl",
         "type":DABTunerControl,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"dabTunerFollowMaster",
         "type":DABTunerFollowMaster,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"dabTunerStation",
         "type":DABTunerStation,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"dBusTraceMonitor",
         "type":DBusTraceMonitor,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"diagnostics",
         "type":Diagnostics,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"displayManager",
         "type":DisplayManager,
         "priority":0,
         "synchronous":true,
         "postprocess":function():void
         {
            Peripheral.displayManager.requestDisplay("hmi",true);
         }
      },{
         "propertyName":"dmbManager",
         "type":DMBManager,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"spellerManager",
         "type":SpellerManager,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"hmiRequest",
         "type":HMIRequest,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"ipaddressInfo",
         "type":IPAddressInfo,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"beaconDSRC",
         "type":BeaconDSRCHMI,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"vicsFMHMI",
         "type":VicsFMHMI,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"vicsTuner",
         "type":VicsTunerHMI,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"vicsDSRCEtcDiag",
         "type":VicsDSRCEtcDiagHMI,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"vicsDiagEngMenu",
         "type":VicsDiagEngMenuHMI,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"vicsEtcHMI",
         "type":VicsEtcHMI,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"kanjiHMI",
         "type":KanjiHMI,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"omapTemp",
         "type":OmapTemp,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"performanceInfo",
         "type":PerformanceInfo,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"sierraUpdate",
         "type":SierraUpdate,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"softwareUpdate",
         "type":SoftwareUpdate,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"wifiService",
         "type":WiFiService,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"ipodTagger",
         "type":iPodTagger,
         "priority":0,
         "synchronous":true
      },{
         "propertyName":"hardControls",
         "type":HardControls,
         "priority":0,
         "synchronous":true,
         "minion":true
      },{
         "propertyName":"presetManager",
         "type":PresetManager,
         "priority":0,
         "synchronous":true,
         "minion":true
      }];
      
      public static var ready:Boolean = false;

      public static const MODULE_READY:String = "MODULE_READY";
      public static const MODULE_NOT_READY:String = "MODULE_NOT_READY";
      
      private var mCurrentPriorityLevel:int;
      
      private var mCurrentModules:Array;
      
      private var mPreProcessingComplete:Object;
      
      private var mPostProcessingComplete:Object;
      
      public function Peripheral()
      {
         super();
         if(!instance)
         {
            instance = this;
         }
      }
      
      public static function get listScreen() : MovieClip
      {
         return mListScreen;
      }
      
      public static function set listScreen(screen:MovieClip) : void
      {
         mListScreen = screen;
      }
      
      private static var mListController:ListController;
      private static var mListControllerBuffer:ListControllerBuffer;

      public static function get listController() : ListController
      {
         if(mListController == null)
         {
            mListController = new ListController();
         }
         return mListController;
      }
      
      public static function get listControllerBuffer() : ListControllerBuffer
      {
         if(mListControllerBuffer == null)
         {
            mListControllerBuffer = new ListControllerBuffer();
         }
         return mListControllerBuffer;
      }
      
      public function init() : void
      {
         Log.log("PERIPHERAL: START...", "Peripheral.as");
         this.mPreProcessingComplete = {};
         this.mPostProcessingComplete = {};
         this.processPriorityLevel(PRIORITY_HIGHEST);
      }
      
      private function processPriorityLevel(priority:int) : void
      {
         var module:Object = null;
         var waitRequired:Boolean = false;
         this.mCurrentPriorityLevel = priority;
         this.mCurrentModules = this.getCurrentModules(MODULE_MANIFEST);
         for each(module in this.mCurrentModules)
         {
            if(Peripheral[module.propertyName] == undefined)
            {
               if(typeof (module.type as Class).getInstance == "function")
               {
                  Peripheral[module.propertyName] = (module.type as Class).getInstance();
               }
               else
               {
                  Peripheral[module.propertyName] = new (module.type as Class)();
               }
            }
         }
         this.preprocessModules(this.mCurrentModules);
         waitRequired = false;
         for each(module in this.mCurrentModules)
         {
            if(false == module.synchronous && !Peripheral[module.propertyName].isReady())
            {
               Log.log("PERIPHERAL: DEPENDENCY - " + module.type + " must be ready to continue...", "Peripheral.as");
               waitRequired = true;
               Peripheral[module.propertyName].addEventListener(ModuleEvent.READY,this.onModuleReady);
            }
         }
         if(!waitRequired)
         {
            this.onModuleReady(null);
         }
      }
      
      private function getNextPriorityLevel() : int
      {
         var module:Object = null;
         var nextPriorityLevel:int = int.MIN_VALUE;
         for each(module in MODULE_MANIFEST)
         {
            if(module.priority < this.mCurrentPriorityLevel && module.priority > nextPriorityLevel)
            {
               nextPriorityLevel = int(module.priority);
            }
         }
         return nextPriorityLevel;
      }
      
      private function getCurrentModules(modules:Array) : Array
      {
         var module:Object = null;
         var currentModules:Array = new Array();
         for each(module in modules)
         {
            if(module.priority == this.mCurrentPriorityLevel)
            {
               currentModules.push(module);
            }
         }
         return currentModules;
      }
      
      private function preprocessModules(modules:Array) : void
      {
         var module:Object = null;
         for each(module in modules)
         {
            if(Boolean(module.hasOwnProperty("preprocess")) && !this.mPreProcessingComplete.hasOwnProperty(module))
            {
               (module.preprocess as Function)();
               this.mPreProcessingComplete[module.propertyName] = new Boolean(true);
            }
         }
      }
      
      private function postprocessModules(modules:Array) : void
      {
         var module:Object = null;
         for each(module in modules)
         {
            if(Boolean(module.hasOwnProperty("postprocess")) && !this.mPostProcessingComplete.hasOwnProperty(module))
            {
               (module.postprocess as Function)();
               this.mPostProcessingComplete[module.propertyName] = new Boolean(true);
            }
         }
      }
      
      private function onModuleReady(e:ModuleEvent) : void
      {
         if(e != null)
         {
            e.target.removeEventListener(ModuleEvent.READY,this.onModuleReady);
         }
         if(this.modulesReady(this.mCurrentModules))
         {
            this.postprocessModules(this.mCurrentModules);
            if(this.mCurrentPriorityLevel == PRIORITY_LOWEST)
            {
               ready = true;
               dispatchEvent(new FrameworkEvent(FrameworkEvent.READY));
            }
            else
            {
               this.processPriorityLevel(this.getNextPriorityLevel());
            }
         }
      }
      
      private function modulesReady(modules:Array) : Boolean
      {
         for(var i:int = 0; i < modules.length; i++)
         {
            if(!modules[i].minion && !modules[i].synchronous && !Peripheral[modules[i].propertyName].isReady())
            {
               dispatchEvent(new ModuleEvent(MODULE_NOT_READY,false,false,modules[i].propertyName));
               Log.log("PERIPHERAL: WAIT - " + modules[i].type + "...", "Peripheral.as");
               Peripheral[modules[i].propertyName].addEventListener(ModuleEvent.READY,this.onModuleReady);
               return false;
            }
            Log.log("PERIPHERAL: READY! - " + modules[i].type, "Peripheral.as");
            dispatchEvent(new ModuleEvent(MODULE_READY,false,false,modules[i].propertyName));
         }
         return true;
      }
   }
}

