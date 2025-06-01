package com.nfuzion.moduleLink
{
   import com.adobe.serialization.json.JSON;
   import com.nfuzion.moduleLinkAPI.DriveModeEvent;
   import com.nfuzion.moduleLinkAPI.DriveModeSetOption;
   import com.nfuzion.moduleLinkAPI.IDriveMode;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DriveMode extends Module implements IDriveMode
   {
      private static var instance:DriveMode;
      
      private static const dbusIdentifier:String = "DriveMode";
      
      private static const dBusReadyFlag:String = "ready";
      
      private static const DEFAULT_LUA:String = "unavailable";
      
      private static const dBusPaddleShiftersModesPresent:String = "PaddleShiftersModesPresent";
      
      private static const dBusTransmissionModesPresent:String = "TransmissionModesPresent";
      
      private static const dBusESCModesPresent:String = "ESCModesPresent";
      
      private static const dBusSuspensionModesPresent:String = "SuspensionModesPresent";
      
      private static const dBusEngPowerDrvMdPresent:String = "EngPowerDrvMdPrsnt";
      
      private static const dBusDriveModePresent:String = "DriveModePresent";
      
      private static const dBusMemoryDRVMDPresent:String = "MemoryDRVMDPresent";
      
      private static const dBusShftIndPresent:String = "ShftIndPresent";
      
      private static const dBusPowersSteeringSystemType:String = "PowersSteeringSystemType";
      
      private static const dBusEPSModeCfgStat:String = "EPSModeCfgStat";
      
      private static const dBusEPSWarnDispRq:String = "EPSWarnDispRq";
      
      private static const dBusWarnDispRq:String = "ErrResponse";
      
      private static const dBusPsiMaxRpm:String = "PsiMaxRpm";
      
      private static const dBusPaddlesModeSts:String = "PaddlesModeSts";
      
      private static const dBusShftPROG:String = "ShftPROG";
      
      private static const dBusEPSModeStat:String = "EPSModeStat";
      
      private static const dBusEPSWarnDisp:String = "EPSWarnDisp";
      
      private static const dBusESCModeStat:String = "ESCModeStat";
      
      private static const dBusADSModeCFGStat:String = "ADSModeCFGStat";
      
      private static const dBusADSModeStat:String = "ADSModeStat";
      
      public static const dBusEcoModeStat:String = "ECOModeEnable";
      
      private static const dBusHoursePowerModeStat:String = "HoursePowerModeStat";
      
      private static const dBusEnginPowerModeStat:String = "EnginPowerModeStat";
      
      public static const dBusLaunchBtnStat:String = "LaunchBtnStat";
      
      public static const dBusLaunchRPMSettingEsc:String = "LaunchRPMSettingEsc";
      
      public static const dBusPsiEnableSts:String = "PsiEnableSts";
      
      public static const dBusPsiGr1RPM:String = "PsiGr1RPM";
      
      public static const dBusPsiGr2RPM:String = "PsiGr2RPM";
      
      public static const dBusPsiGr3RPM:String = "PsiGr3RPM";
      
      public static const dBusPsiGr4RPM:String = "PsiGr4RPM";
      
      public static const dBusPsiGr5RPM:String = "PsiGr5RPM";
      
      public static const dBusignition:String = "ignition";
      
      public static const dBusDriveModePrsnt:String = "DriveModePrsnt";
      
      public static const dBusvehLinePrsnt:String = "vehLinePrsnt";
      
      public static const dBusModeSetUpPrsnt:String = "ModeSetUpPrsnt";
      
      public static const dBusPaddleShiftersPrsnt:String = "PaddleShiftersPrsnt";
      
      public static const dBusTransmissionPrsnt:String = "TransmissionPrsnt";
      
      public static const dBusNetCfgEPSPrsnt:String = "NetCfgEPSPrsnt";
      
      public static const dBusSuspensionPrsnt:String = "SuspensionPrsnt";
      
      public static const dBusECMDrivePrsnt:String = "ECMDrivePrsnt";
      
      public static const dBusSRTPrsnt:String = "SRTPrsnt";
      
      public static const dBusSTPPrsnt:String = "STPPrsnt";
      
      public static const dBusSPORTPrsnt:String = "SPORTPrsnt";
      
      public static const dBusSTPbButton:String = "STPbButton";
      
      public static const dBusESCbButton:String = "ESCbButton";
      
      public static const dBusThrottle:String = "Throttle";
      
      public static const dBusRedKeyPrsnt:String = "RedKeyPrsnt";
      
      public static const dBusShftIndPrsnt:String = "ShftIndPrsnt";
      
      public static const dBusDisplacement:String = "Displacement";
      
      public static const dBusTransType:String = "TransType";
      
      public static const dBusNetCfgTcm:String = "NetCfgTcm";
      
      public static const dBusESCDrvMdPrsnt:String = "ESCDrvMdPrsnt";
      
      private static const dBusApiGetAllProperties:String = "getAllProperties";
      
      private static const dBusApiGetProperties:String = "getProperties";
      
      private static const dBusApiSetProperties:String = "setProperties";
      
      private static const dBusServiceAvailable:String = "dBusServiceAvailable";
      
      private static const PSI_STEP_VALUE:uint = 250;
      
      private static const PSI_INITIAL_VALUE:uint = 500;
      
      private var mPowersSteeringType:String = "";
      
      private var mEPSModeCfgStat:String = "";
      
      private var mPaddlesModeSts:String = "";
      
      private var mShftPROG:String = "";
      
      private var mEPSModeStat:String = "";
      
      private var mEPSWarnDisp:String = "";
      
      private var mESCModeStat:String = "";
      
      private var mECOModeStat:String = "";
      
      private var mADSModeCFGStat:String = "";
      
      private var mHoursePowerModeStat:String = "";
      
      private var mLaunchRPMSettingEsc:String = "";
      
      private var mPsiEnableSts:String = "";
      
      private var mPsiGr1RPM:String = "2750";
      
      private var mPsiGr2RPM:String = "2750";
      
      private var mPsiGr3RPM:String = "2750";
      
      private var mPsiGr4RPM:String = "2750";
      
      private var mPsiGr5RPM:String = "2750";
      
      private var mPaddleShiftersModesPresent:String = "";
      
      private var mTransmissionModesPresent:String = "";
      
      private var mESCModesPresent:String = "";
      
      private var mDriveModePresent:String = "";
      
      private var mMemoryDRVMDPresent:String = "";
      
      private var mShftIndPresent:String = "";
      
      private var mSRTPresent:String = "";
      
      private var mSTPPresent:String = "";
      
      private var mSTPButton:String = "";
      
      private var mESCButton:String = "";
      
      private var mSPORTPresent:String = "";
      
      private var mKeyMode:uint = 0;
      
      private var mKeyModeTemp:uint = 0;
      
      private var mDisplacement:Boolean = false;
      
      private var mEcoStatus:Boolean = false;
      
      private var mLaunchRPMValue:String = "1500";
      
      private var mDriveModeType:String = "";
      
      private var mDriveModeTypePresent:Boolean;
      
      private var mPsiMaxRpm:uint = 7000;
      
      private var mDriveModeTrack:DriveModeSetOption = new DriveModeSetOption();
      
      private var mDriveModeSport:DriveModeSetOption = new DriveModeSetOption();
      
      private var mDriveModeDefault:DriveModeSetOption = new DriveModeSetOption();
      
      private var mDriveModeCustome:DriveModeSetOption = new DriveModeSetOption();
      
      private var mDriveModeMode:int = -1;
      
      private var mLaunchBtnStat:String = "Launch off";
      
      private var mShiftBtnStat:String = "Off";
      
      private var mLaunchRPMValuve:String = "1500";
      
      private var mGear1RPM:String = "2750";
      
      private var mGear2RPM:String = "2750";
      
      private var mGear3RPM:String = "2750";
      
      private var mGear4RPM:String = "2750";
      
      private var mGear5RPM:String = "2750";
      
      private var mIgnition:String = "";
      
      private var mDriveModePresnt:Boolean = false;
      
      private var mRaceOptionScreenStat:String = "";
      
      private var mCacheLaunchScreen:String = "";
      
      private var mRedKey:Boolean = true;
      
      private var mEngPowerDrvMdPresent:Boolean = true;
      
      private var mTransmissionPrsnt:Boolean = true;
      
      private var mPaddleShiftersPrsnt:Boolean = true;
      
      private var mSuspensionPrsnt:Boolean = true;
      
      private var mNetCfgEPSPrsnt:Boolean = true;
      
      private var mShftIndPrsnt:Boolean = true;
      
      private var mTransType:Boolean = false;
      
      private var mNetCfgTcm:Boolean = false;
      
      private var mEscMode:Boolean = false;
      
      private var mSupportLaunchControl:Boolean = true;
      
      private var mSupportShiftLight:Boolean = true;
      
      private var mSupportNonSrtDriveMode:Boolean = true;
      
      private var mThrottle:uint;
      
      private var mEngineType:String = "5.7l";
      
      private var mEscStauts:Boolean = false;
      
      private var mEnableEscHK:Boolean = true;
      
      private var mSetRpm1Timer:Timer = new Timer(1000,1);
      
      private var mSetRpm2Timer:Timer = new Timer(1000,1);
      
      private var mSetRpm3Timer:Timer = new Timer(1000,1);
      
      private var mSetRpm4Timer:Timer = new Timer(1000,1);
      
      private var mSetRpm5Timer:Timer = new Timer(1000,1);
      
      private var mSetKeyModeTimer:Timer = new Timer(500,1);
      
      private var mDriveModeServicePresent:Boolean = false;
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mVehSettingsServiceAvailable:Boolean = false;
      
      private var mKeyModeProcessed:Boolean = false;
      
      private var mIsValet:Boolean = false;
      
      public function DriveMode()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.DRIVE_MODE,this.DriveModeMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
         this.mSetRpm1Timer.addEventListener(TimerEvent.TIMER,this.onSetRpm1Timer);
         this.mSetRpm2Timer.addEventListener(TimerEvent.TIMER,this.onSetRpm2Timer);
         this.mSetRpm3Timer.addEventListener(TimerEvent.TIMER,this.onSetRpm3Timer);
         this.mSetRpm4Timer.addEventListener(TimerEvent.TIMER,this.onSetRpm4Timer);
         this.mSetRpm5Timer.addEventListener(TimerEvent.TIMER,this.onSetRpm5Timer);
         this.mSetKeyModeTimer.addEventListener(TimerEvent.TIMER,this.onSetKeyModeTimer);
      }
      
      public static function getInstance() : DriveMode
      {
         if(instance == null)
         {
            instance = new DriveMode();
         }
         return instance;
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function DriveModeMessageHandler(e:ConnectionEvent) : void
      {
         var driveMode:Object = e.data;
         var jsonMessge:String = com.adobe.serialization.json.JSON.encode(driveMode);
         if(Boolean(jsonMessge) && 0 <= jsonMessge.indexOf(DEFAULT_LUA))
         {
            return;
         }
         if(driveMode.hasOwnProperty(dBusReadyFlag))
         {
            if(driveMode[dBusReadyFlag] == "true")
            {
               this.getSettings();
            }
         }
         if(driveMode.hasOwnProperty(dBusServiceAvailable))
         {
            if(driveMode.dBusServiceAvailable == "true" && this.mDriveModeServicePresent == false)
            {
               this.mDriveModeServicePresent = true;
               this.getProperties("ready");
            }
            else if(dBusServiceAvailable == "false")
            {
               this.mDriveModeServicePresent = false;
            }
         }
         if(driveMode.hasOwnProperty(dBusApiGetProperties))
         {
            this.handlePropertyMessage(driveMode.getProperties);
         }
         if(driveMode.hasOwnProperty(dBusPowersSteeringSystemType))
         {
            this.handlePropertyMessage(driveMode.PowersSteeringSystemType);
         }
         if(driveMode.hasOwnProperty(dBusShftIndPrsnt))
         {
            this.handlePropertyMessage(driveMode.ShftIndPrsnt);
         }
         if(driveMode.hasOwnProperty(dBusEPSModeCfgStat))
         {
            this.handlePropertyMessage(driveMode.EPSModeCfgStat);
         }
         if(driveMode.hasOwnProperty(dBusEPSModeStat))
         {
            this.handlePropertyMessage(driveMode.EPSModeStat);
         }
         if(driveMode.hasOwnProperty(dBusPaddlesModeSts))
         {
            this.handlePropertyMessage(driveMode.PaddlesModeSts);
         }
         if(driveMode.hasOwnProperty(dBusShftPROG))
         {
            this.handlePropertyMessage(driveMode.ShftPROG);
         }
         if(driveMode.hasOwnProperty(dBusESCModeStat))
         {
            this.handlePropertyMessage(driveMode.ESCModeStat);
         }
         if(driveMode.hasOwnProperty(dBusADSModeCFGStat))
         {
            this.handlePropertyMessage(driveMode.ADSModeCFGStat);
         }
         if(driveMode.hasOwnProperty(dBusADSModeStat))
         {
            this.handlePropertyMessage(driveMode.ADSModeStat);
         }
         if(driveMode.hasOwnProperty(dBusHoursePowerModeStat))
         {
            this.handlePropertyMessage(driveMode.HoursePowerModeStat);
         }
         if(driveMode.hasOwnProperty(dBusEcoModeStat))
         {
            this.handlePropertyMessage(driveMode.ECOModeEnable);
         }
         if(driveMode.hasOwnProperty(dBusEnginPowerModeStat))
         {
            this.handlePropertyMessage(driveMode.EnginPowerModeStat);
         }
         if(driveMode.hasOwnProperty(dBusLaunchBtnStat))
         {
            this.handlePropertyMessage(driveMode.LaunchBtnStat);
         }
         if(driveMode.hasOwnProperty(dBusLaunchRPMSettingEsc))
         {
            this.handlePropertyMessage(driveMode.LaunchRPMSettingEsc);
         }
         if(driveMode.hasOwnProperty(dBusPsiEnableSts))
         {
            this.handlePropertyMessage(driveMode.PsiEnableSts);
         }
         if(driveMode.hasOwnProperty(dBusPsiGr1RPM))
         {
            this.handlePropertyMessage(driveMode.PsiGr1RPM);
         }
         if(driveMode.hasOwnProperty(dBusPsiGr2RPM))
         {
            this.handlePropertyMessage(driveMode.PsiGr2RPM);
         }
         if(driveMode.hasOwnProperty(dBusPsiGr3RPM))
         {
            this.handlePropertyMessage(driveMode.PsiGr3RPM);
         }
         if(driveMode.hasOwnProperty(dBusPsiGr4RPM))
         {
            this.handlePropertyMessage(driveMode.PsiGr4RPM);
         }
         if(driveMode.hasOwnProperty(dBusPsiGr5RPM))
         {
            this.handlePropertyMessage(driveMode.PsiGr5RPM);
         }
         if(driveMode.hasOwnProperty(dBusPaddleShiftersModesPresent))
         {
            this.handlePropertyMessage(driveMode.PaddleShiftersModesPresent);
         }
         if(driveMode.hasOwnProperty(dBusTransmissionModesPresent))
         {
            this.handlePropertyMessage(driveMode.TransmissionModesPresent);
         }
         if(driveMode.hasOwnProperty(dBusTransType))
         {
            this.handlePropertyMessage(driveMode.TransType);
         }
         if(driveMode.hasOwnProperty(dBusNetCfgTcm))
         {
            this.handlePropertyMessage(driveMode.dBusNetCfgTcm);
         }
         if(driveMode.hasOwnProperty(dBusESCDrvMdPrsnt))
         {
            this.handlePropertyMessage(driveMode.ESCDrvMdPrsnt);
         }
         if(driveMode.hasOwnProperty(dBusESCModesPresent))
         {
            this.handlePropertyMessage(driveMode.ESCModesPresent);
         }
         if(driveMode.hasOwnProperty(dBusEngPowerDrvMdPresent))
         {
            this.handlePropertyMessage(driveMode.EngPowerDrvMdPresent);
         }
         if(driveMode.hasOwnProperty(dBusDriveModePresent))
         {
            this.handlePropertyMessage(driveMode.DriveModePresent);
         }
         if(driveMode.hasOwnProperty(dBusMemoryDRVMDPresent))
         {
            this.handlePropertyMessage(driveMode.MemoryDRVMDPresent);
         }
         if(driveMode.hasOwnProperty(dBusShftIndPresent))
         {
            this.handlePropertyMessage(driveMode.ShftIndPresent);
         }
         if(driveMode.hasOwnProperty(dBusignition))
         {
            this.handlePropertyMessage(driveMode.ignition);
         }
         if(driveMode.hasOwnProperty(dBusDriveModePrsnt))
         {
            this.handlePropertyMessage(driveMode.DriveModePrsnt);
         }
         if(driveMode.hasOwnProperty(dBusvehLinePrsnt))
         {
            this.handlePropertyMessage(driveMode.vehLinePrsnt);
         }
         if(driveMode.hasOwnProperty(dBusModeSetUpPrsnt))
         {
            this.handlePropertyMessage(driveMode.ModeSetUpPrsnt);
         }
         if(driveMode.hasOwnProperty(dBusPaddleShiftersPrsnt))
         {
            this.handlePropertyMessage(driveMode.PaddleShiftersPrsnt);
         }
         if(driveMode.hasOwnProperty(dBusTransmissionPrsnt))
         {
            this.handlePropertyMessage(driveMode.TransmissionPrsnt);
         }
         if(driveMode.hasOwnProperty(dBusNetCfgEPSPrsnt))
         {
            this.handlePropertyMessage(driveMode.NetCfgEPSPrsnt);
         }
         if(driveMode.hasOwnProperty(dBusSuspensionPrsnt))
         {
            this.handlePropertyMessage(driveMode.SuspensionPrsnt);
         }
         if(driveMode.hasOwnProperty(dBusECMDrivePrsnt))
         {
            this.handlePropertyMessage(driveMode.ECMDrivePrsnt);
         }
         if(driveMode.hasOwnProperty(dBusSRTPrsnt))
         {
            this.handlePropertyMessage(driveMode.SRTPrsnt);
         }
         if(driveMode.hasOwnProperty(dBusSTPPrsnt))
         {
            this.handlePropertyMessage(driveMode.STPPrsnt);
         }
         if(driveMode.hasOwnProperty(dBusSPORTPrsnt))
         {
            this.handlePropertyMessage(driveMode.SPORTPrsnt);
         }
         if(driveMode.hasOwnProperty(dBusSTPbButton))
         {
            this.handlePropertyMessage(driveMode.STPbButton);
         }
         if(driveMode.hasOwnProperty(dBusESCbButton))
         {
            this.handlePropertyMessage(driveMode.ESCbButton);
         }
         if(driveMode.hasOwnProperty(dBusThrottle))
         {
            this.handlePropertyMessage(driveMode.Throttle);
         }
         if(driveMode.hasOwnProperty(dBusEPSWarnDispRq))
         {
            this.handlePropertyMessage(driveMode.EPSWarnDispRq);
         }
         if(driveMode.hasOwnProperty(dBusWarnDispRq))
         {
            this.handlePropertyMessage(driveMode.ErrResponse);
         }
         if(driveMode.hasOwnProperty(dBusRedKeyPrsnt))
         {
            this.handlePropertyMessage(driveMode.RedKeyPrsnt);
            this.getEngPowerDrvMdPrsnt();
            this.getSRTPresent();
         }
         if(driveMode.hasOwnProperty(dBusDisplacement))
         {
            this.handlePropertyMessage(driveMode.Displacement);
            this.getEngPowerDrvMdPrsnt();
            this.getSRTPresent();
         }
         if(driveMode.hasOwnProperty(dBusPsiMaxRpm))
         {
            this.handlePropertyMessage(driveMode.PsiMaxRpm);
         }
      }
      
      public function handlePropertyMessage(msg:Object) : void
      {
         var engDrvMode:uint = 0;
         var mEngDrvmode:String = null;
         var susp:uint = 0;
         var paddle:uint = 0;
         var trans:uint = 0;
         var eps:uint = 0;
         var traction:uint = 0;
         var eco:Boolean = false;
         var srt:String = null;
         var mCurrentMode:String = null;
         var mode:DriveModeSetOption = this.driveModeData(this.mDriveModeMode);
         if(msg.hasOwnProperty(dBusPowersSteeringSystemType))
         {
            this.mPowersSteeringType = msg[dBusPowersSteeringSystemType];
            if(this.mPowersSteeringType == "EPS" && this.mNetCfgEPSPrsnt)
            {
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_EPS,true);
            }
            else
            {
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_EPS,false);
            }
            dispatchEvent(new DriveModeEvent(DriveModeEvent.POWERSSTEERINGSYSTEMTYPE));
         }
         if(msg.hasOwnProperty(dBusReadyFlag))
         {
            if(msg[dBusReadyFlag] == "true")
            {
               this.getSettings();
            }
         }
         if(msg.hasOwnProperty(dBusShftIndPrsnt))
         {
            if(msg[dBusShftIndPrsnt] == "Present")
            {
               this.mSupportShiftLight = true;
            }
            else
            {
               this.mSupportShiftLight = false;
            }
         }
         if(msg.hasOwnProperty(dBusEnginPowerModeStat))
         {
            if(this.isMTX() && "non-SRT" == this.mDriveModeType)
            {
               mEngDrvmode = msg[dBusEnginPowerModeStat];
               switch(mEngDrvmode)
               {
                  case "Track":
                     engDrvMode = 1;
                     break;
                  case "Normal":
                     engDrvMode = 3;
                     break;
                  case "Sport":
                     engDrvMode = 1;
               }
               if(DriveModeSetOption.mTrans != engDrvMode && (engDrvMode == 1 || engDrvMode == 3))
               {
                  DriveModeSetOption.mTrans = engDrvMode;
                  dispatchEvent(new DriveModeEvent(DriveModeEvent.SHFTPROG,mode));
                  dispatchEvent(new DriveModeEvent(DriveModeEvent.CLEARWARNING,DriveModeSetOption.TYPE_TRANS));
               }
            }
         }
         if(msg.hasOwnProperty(dBusADSModeStat))
         {
            this.mADSModeCFGStat = msg[dBusADSModeStat];
            if(this.mADSModeCFGStat == "Mode 1")
            {
               susp = 3;
            }
            else if(this.mADSModeCFGStat == "Mode 2")
            {
               susp = 2;
            }
            else if(this.mADSModeCFGStat == "Mode 3")
            {
               susp = 1;
            }
            if(DriveModeSetOption.mSusp != susp)
            {
               DriveModeSetOption.mSusp = susp;
               dispatchEvent(new DriveModeEvent(DriveModeEvent.ADSMODECFGSTAT,mode));
               dispatchEvent(new DriveModeEvent(DriveModeEvent.CLEARWARNING,DriveModeSetOption.TYPE_SUSP));
            }
         }
         if(!msg.hasOwnProperty(dBusEPSModeCfgStat))
         {
         }
         if(msg.hasOwnProperty(dBusPaddlesModeSts))
         {
            this.mPaddlesModeSts = msg[dBusPaddlesModeSts];
            if(this.mPaddlesModeSts == "Paddles Disabled")
            {
               paddle = 3;
            }
            else if(this.mPaddlesModeSts == "Paddles Enabled")
            {
               paddle = 1;
            }
            if(mode.mPaddle != paddle)
            {
               dispatchEvent(new DriveModeEvent(DriveModeEvent.PADDLESMODESTS,mode));
               dispatchEvent(new DriveModeEvent(DriveModeEvent.CLEARWARNING,DriveModeSetOption.TYPE_PADDLE));
            }
         }
         if(msg.hasOwnProperty(dBusShftPROG))
         {
            if("SRT" == this.mDriveModeType || this.isATX() || this.TransmissionPrsnt)
            {
               this.mShftPROG = msg[dBusShftPROG];
               switch(this.mShftPROG)
               {
                  case "Track mode":
                     trans = 1;
                     break;
                  case "Normal transmission mode":
                     trans = 3;
                     break;
                  case "Sport mode":
                     trans = 2;
                     if("non-SRT" == this.mDriveModeType)
                     {
                        trans = 1;
                     }
                     break;
                  case "Economy mode":
                  case "Valet mode":
                  case "Default":
               }
               if(DriveModeSetOption.mTrans != trans && (trans == 1 || trans == 2 || trans == 3))
               {
                  DriveModeSetOption.mTrans = trans;
                  dispatchEvent(new DriveModeEvent(DriveModeEvent.SHFTPROG,mode));
                  dispatchEvent(new DriveModeEvent(DriveModeEvent.CLEARWARNING,DriveModeSetOption.TYPE_TRANS));
               }
            }
         }
         if(msg.hasOwnProperty(dBusEPSModeStat))
         {
            this.mEPSModeStat = msg[dBusEPSModeStat];
            if("SRT" == this.mDriveModeType)
            {
               if(this.mEPSModeStat == "Mode 1")
               {
                  eps = 3;
               }
               else if(this.mEPSModeStat == "Mode 2")
               {
                  eps = 2;
               }
               else if(this.mEPSModeStat == "Mode 3")
               {
                  eps = 1;
               }
            }
            else if(this.mEPSModeStat == "Mode 1")
            {
               eps = 2;
            }
            else if(this.mEPSModeStat == "Mode 2")
            {
               eps = 1;
            }
            else if(this.mEPSModeStat == "Mode 3")
            {
               eps = 3;
            }
            if(DriveModeSetOption.mEps != eps)
            {
               DriveModeSetOption.mEps = eps;
               dispatchEvent(new DriveModeEvent(DriveModeEvent.EPSMODESTAT,mode));
               dispatchEvent(new DriveModeEvent(DriveModeEvent.CLEARWARNING,DriveModeSetOption.TYPE_EPS));
            }
         }
         if(msg.hasOwnProperty(dBusEPSWarnDisp))
         {
            this.mEPSWarnDisp = msg[dBusEPSWarnDisp];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.EPSWARNDISP));
         }
         if(msg.hasOwnProperty(dBusESCModeStat))
         {
            this.mESCModeStat = msg[dBusESCModeStat];
            if(this.mESCModeStat == "Street mode")
            {
               traction = 3;
               this.mEscStauts = false;
            }
            else if(this.mESCModeStat == "Sport mode")
            {
               if("SRT" == this.driveModeType)
               {
                  traction = 2;
               }
               else
               {
                  traction = 1;
               }
               this.mEscStauts = false;
            }
            else if(this.mESCModeStat == "Track mode")
            {
               traction = 1;
               this.mEscStauts = false;
            }
            else if(this.mESCModeStat == "Full OFF")
            {
               traction = DriveModeSetOption.mTraction;
               this.mEscStauts = true;
            }
            if(0 != traction)
            {
               DriveModeSetOption.mTraction = traction;
               dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,mode));
               dispatchEvent(new DriveModeEvent(DriveModeEvent.ESCMODESTAT,mode));
               dispatchEvent(new DriveModeEvent(DriveModeEvent.CLEARWARNING,DriveModeSetOption.TYPE_TRACTION));
            }
            this.mEnableEscHK = true;
         }
         if(!msg.hasOwnProperty(dBusHoursePowerModeStat))
         {
         }
         if(msg.hasOwnProperty(dBusEcoModeStat))
         {
            this.mECOModeStat = msg[dBusEcoModeStat];
            if(this.mECOModeStat == "enable")
            {
               eco = true;
            }
            else if(this.mECOModeStat == "disable")
            {
               eco = false;
            }
            if(this.mEcoStatus != eco)
            {
            }
         }
         if(msg.hasOwnProperty(dBusLaunchBtnStat))
         {
            this.mLaunchBtnStat = msg[dBusLaunchBtnStat];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LAUNCHBTNSTAT));
         }
         if(msg.hasOwnProperty(dBusLaunchRPMSettingEsc))
         {
            this.mLaunchRPMSettingEsc = msg[dBusLaunchRPMSettingEsc];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LAUNCHRPMSETTINGESC));
         }
         if(msg.hasOwnProperty(dBusPsiEnableSts))
         {
            this.mShiftBtnStat = msg[dBusPsiEnableSts];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.PSIENABLESTS));
         }
         if(msg.hasOwnProperty(dBusPsiGr1RPM))
         {
            this.mPsiGr1RPM = msg[dBusPsiGr1RPM];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.PSIGR1RPM));
         }
         if(msg.hasOwnProperty(dBusPsiGr2RPM))
         {
            this.mPsiGr2RPM = msg[dBusPsiGr2RPM];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.PSIGR2RPM));
         }
         if(msg.hasOwnProperty(dBusPsiGr3RPM))
         {
            this.mPsiGr3RPM = msg[dBusPsiGr3RPM];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.PSIGR3RPM));
         }
         if(msg.hasOwnProperty(dBusPsiGr4RPM))
         {
            this.mPsiGr4RPM = msg[dBusPsiGr4RPM];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.PSIGR4RPM));
         }
         if(msg.hasOwnProperty(dBusPsiGr5RPM))
         {
            this.mPsiGr5RPM = msg[dBusPsiGr5RPM];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.PSIGR5RPM));
         }
         if(msg.hasOwnProperty(dBusPaddleShiftersModesPresent))
         {
            this.mPaddleShiftersModesPresent = msg[dBusPaddleShiftersModesPresent];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.PADDLESMODEPSRNT));
         }
         if(msg.hasOwnProperty(dBusTransmissionModesPresent))
         {
            this.mTransmissionModesPresent = msg[dBusTransmissionModesPresent];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.TRANSMODEPRST));
         }
         if(msg.hasOwnProperty(dBusESCModesPresent))
         {
            this.mESCModesPresent = msg[dBusESCModesPresent];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.ESCMODEPRSNT));
         }
         if(msg.hasOwnProperty(dBusEngPowerDrvMdPresent))
         {
            if(msg[dBusEngPowerDrvMdPresent] == "Present")
            {
               this.mEngPowerDrvMdPresent = true;
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_POWER,true);
            }
            else
            {
               this.mEngPowerDrvMdPresent = false;
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_POWER,false);
            }
            dispatchEvent(new DriveModeEvent(DriveModeEvent.HOURSEPOWERMODEPRSNT));
         }
         if(msg.hasOwnProperty(dBusDriveModePresent))
         {
            this.mDriveModePresent = msg[dBusDriveModePresent];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.DRIVEMODEPRSNT));
         }
         if(msg.hasOwnProperty(dBusMemoryDRVMDPresent))
         {
            this.mMemoryDRVMDPresent = msg[dBusMemoryDRVMDPresent];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.MEMORYDRVMDPRSNT));
         }
         if(msg.hasOwnProperty(dBusShftIndPresent))
         {
            this.mShftIndPresent = msg[dBusShftIndPresent];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.SHFTPRSNT));
         }
         if(msg.hasOwnProperty(dBusignition))
         {
            this.mIgnition = msg[dBusignition];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.IGNITION));
         }
         if(msg.hasOwnProperty(dBusDriveModePrsnt))
         {
            this.mDriveModePresnt = msg[dBusDriveModePrsnt] == "Present";
            dispatchEvent(new DriveModeEvent(DriveModeEvent.DRIVEMODEPRSNT));
         }
         if(msg.hasOwnProperty(dBusvehLinePrsnt))
         {
            dispatchEvent(new DriveModeEvent(DriveModeEvent.VEHLINEPRSNT));
         }
         if(msg.hasOwnProperty(dBusModeSetUpPrsnt))
         {
            dispatchEvent(new DriveModeEvent(DriveModeEvent.MODESETUPPRSNT));
         }
         if(msg.hasOwnProperty(dBusPaddleShiftersPrsnt))
         {
            if(msg[dBusPaddleShiftersPrsnt] == "Present")
            {
               this.mPaddleShiftersPrsnt = true;
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_PADDLE,true);
            }
            else
            {
               this.mPaddleShiftersPrsnt = false;
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_PADDLE,false);
            }
            dispatchEvent(new DriveModeEvent(DriveModeEvent.PADDLESHIFTERSPRSNT));
         }
         if(msg.hasOwnProperty(dBusTransmissionPrsnt))
         {
            if(msg[dBusTransmissionPrsnt] == "Present")
            {
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_TRANS,true);
               this.mTransmissionPrsnt = true;
            }
            else
            {
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_TRANS,false);
               this.mTransmissionPrsnt = false;
            }
            dispatchEvent(new DriveModeEvent(DriveModeEvent.TRANSMISSIONPRSNT));
         }
         if(msg.hasOwnProperty(dBusTransType))
         {
            if(msg[dBusTransType] == "automatic")
            {
               this.mTransType = true;
            }
            else
            {
               this.mTransType = false;
            }
         }
         if(msg.hasOwnProperty(dBusNetCfgTcm))
         {
            if(msg[dBusNetCfgTcm] == "Present")
            {
               this.mNetCfgTcm = true;
            }
            else
            {
               this.mNetCfgTcm = false;
            }
         }
         if(msg.hasOwnProperty(dBusESCDrvMdPrsnt))
         {
            if(msg[dBusESCDrvMdPrsnt] == "Present")
            {
               this.mEscMode = true;
            }
            else
            {
               this.mEscMode = false;
            }
         }
         if(msg.hasOwnProperty(dBusNetCfgEPSPrsnt))
         {
            if(msg[dBusNetCfgEPSPrsnt] == "Present")
            {
               this.mNetCfgEPSPrsnt = true;
               if(this.mPowersSteeringType == "EPS")
               {
                  this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_EPS,true);
               }
            }
            else
            {
               this.mNetCfgEPSPrsnt = false;
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_EPS,false);
            }
            dispatchEvent(new DriveModeEvent(DriveModeEvent.NETCFGEPSPRSNT));
         }
         if(msg.hasOwnProperty(dBusSuspensionPrsnt))
         {
            if(msg[dBusSuspensionPrsnt] == "Present")
            {
               this.mSuspensionPrsnt = true;
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_SUSP,true);
            }
            else
            {
               this.mSuspensionPrsnt = false;
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_SUSP,false);
            }
            dispatchEvent(new DriveModeEvent(DriveModeEvent.SUSPENSIONPRSNT));
         }
         if(msg.hasOwnProperty(dBusECMDrivePrsnt))
         {
            dispatchEvent(new DriveModeEvent(DriveModeEvent.ECMDRIVEPRSNT));
         }
         if(msg.hasOwnProperty(dBusSRTPrsnt))
         {
            srt = "";
            this.mSRTPresent = msg[dBusSRTPrsnt];
            this.mDriveModeTypePresent = true;
            if(this.mSRTPresent == "Present")
            {
               srt = "SRT";
            }
            else
            {
               srt = "non-SRT";
            }
            this.mDriveModeType = srt;
            this.updateSrtMode();
            dispatchEvent(new DriveModeEvent(DriveModeEvent.SRTPRSNT));
         }
         if(msg.hasOwnProperty(dBusSTPPrsnt))
         {
            this.mSTPPresent = msg[dBusSTPPrsnt];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.STPPRSNT));
         }
         if(msg.hasOwnProperty(dBusSPORTPrsnt))
         {
            this.mSPORTPresent = msg[dBusSPORTPrsnt];
         }
         if(msg.hasOwnProperty(dBusSTPbButton))
         {
            this.mSTPButton = msg[dBusSTPbButton];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.STPBUTTON));
         }
         if(msg.hasOwnProperty(dBusESCbButton))
         {
            this.mESCButton = msg[dBusESCbButton];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.ESCBUTTON));
         }
         if(msg.hasOwnProperty(dBusThrottle))
         {
            this.mThrottle = msg[dBusThrottle];
            dispatchEvent(new DriveModeEvent(DriveModeEvent.THROTTLE));
            if(this.mThrottle == 0)
            {
               dispatchEvent(new DriveModeEvent(DriveModeEvent.CLEARWARNING,DriveModeSetOption.TYPE_POWER));
            }
         }
         if(msg.hasOwnProperty(dBusDisplacement))
         {
            if(msg[dBusDisplacement] == "64")
            {
               this.mDisplacement = false;
            }
            else
            {
               this.mDisplacement = true;
            }
            if(this.isHellcat() && !this.mKeyModeProcessed && this.mKeyModeTemp != 0)
            {
               this.mSetKeyModeTimer.reset();
               this.mSetKeyModeTimer.start();
               this.mKeyModeProcessed = true;
            }
         }
         if(msg.hasOwnProperty(dBusRedKeyPrsnt))
         {
            if(msg[dBusRedKeyPrsnt] == "Present")
            {
               this.mKeyModeTemp = 1;
            }
            else
            {
               this.mKeyModeTemp = 2;
            }
            if(this.isHellcat())
            {
               this.mSetKeyModeTimer.reset();
               this.mSetKeyModeTimer.start();
               this.mKeyModeProcessed = true;
            }
         }
         if(msg.hasOwnProperty(dBusPsiMaxRpm))
         {
            this.mPsiMaxRpm = parseInt(msg[dBusPsiMaxRpm].toString()) * PSI_STEP_VALUE + PSI_INITIAL_VALUE;
         }
         if(msg.hasOwnProperty(dBusEPSWarnDispRq))
         {
            dispatchEvent(new DriveModeEvent(DriveModeEvent.EPSWARMDISPRQ,msg[dBusEPSWarnDispRq]));
         }
         if(msg.hasOwnProperty(dBusWarnDispRq))
         {
            if(msg.hasOwnProperty("mode"))
            {
               switch(this.mDriveModeMode)
               {
                  case DriveModeSetOption.MODE_TRACK:
                     mCurrentMode = "Track";
                     break;
                  case DriveModeSetOption.MODE_SPORT:
                     mCurrentMode = "Sport";
                     break;
                  case DriveModeSetOption.MODE_CUSTOM:
                     mCurrentMode = "Custom";
                     break;
                  case DriveModeSetOption.MODE_DEFAULT:
                     mCurrentMode = "Default";
               }
               if(msg["mode"].indexOf(mCurrentMode) != -1)
               {
                  if(!((this.isATX() || this.TransmissionPrsnt) && msg[dBusWarnDispRq] == "EnginPowerModeStat"))
                  {
                     dispatchEvent(new DriveModeEvent(DriveModeEvent.WARNING,msg[dBusWarnDispRq]));
                  }
               }
            }
         }
      }
      
      private function onSetKeyModeTimer(e:TimerEvent) : void
      {
         this.mKeyMode = this.mKeyModeTemp;
         this.ChangeHPWithKeyMode(this.mKeyMode);
         this.updateSrtMode();
         dispatchEvent(new DriveModeEvent(DriveModeEvent.REDKEYPRSNT,"changeKey"));
      }
      
      private function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:* = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      private function ChangeHPWithKeyMode(keymode:int) : void
      {
         var transStatus:String = null;
         var hpStatus:String = "";
         if(keymode == 1)
         {
            this.mDriveModeTrack.mPower = this.mDriveModeTrack.mPowerSetup = DriveModeSetOption.HPHIGH;
            this.mDriveModeSport.mPower = this.mDriveModeSport.mPowerSetup = DriveModeSetOption.HPHIGH;
            this.mDriveModeDefault.mPower = this.mDriveModeDefault.mPowerSetup = DriveModeSetOption.HPHIGH;
            this.mDriveModeTrack.mTransSetup = 1;
            this.mDriveModeSport.mTransSetup = 2;
            this.mDriveModeDefault.mTransSetup = 3;
            hpStatus = "RED";
            this.mDriveModeTrack.mDriveMode = DriveModeSetOption.MODE_TRACK;
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,this.mDriveModeTrack));
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_TRACK,dBusHoursePowerModeStat,hpStatus);
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_TRACK,dBusShftPROG,"Track");
            this.mDriveModeSport.mDriveMode = DriveModeSetOption.MODE_SPORT;
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,this.mDriveModeSport));
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_SPORT,dBusHoursePowerModeStat,hpStatus);
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_SPORT,dBusShftPROG,"Sport");
            this.mDriveModeDefault.mDriveMode = DriveModeSetOption.MODE_DEFAULT;
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,this.mDriveModeDefault));
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_DEFAULT,dBusHoursePowerModeStat,hpStatus);
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_DEFAULT,dBusShftPROG,"Street");
         }
         else
         {
            hpStatus = "BLACK";
            transStatus = "Street";
            this.mDriveModeCustome.mPower = this.mDriveModeCustome.mPowerSetup = DriveModeSetOption.HPLOW;
            this.mDriveModeCustome.mTransSetup = 3;
            this.mDriveModeCustome.mDriveMode = DriveModeSetOption.MODE_CUSTOM;
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_CUSTOM,dBusHoursePowerModeStat,hpStatus);
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_CUSTOM,dBusShftPROG,transStatus);
            this.mDriveModeTrack.mPower = this.mDriveModeTrack.mPowerSetup = DriveModeSetOption.HPLOW;
            this.mDriveModeSport.mPower = this.mDriveModeSport.mPowerSetup = DriveModeSetOption.HPLOW;
            this.mDriveModeDefault.mPower = this.mDriveModeDefault.mPowerSetup = DriveModeSetOption.HPLOW;
            this.mDriveModeTrack.mTransSetup = 3;
            this.mDriveModeSport.mTransSetup = 3;
            this.mDriveModeDefault.mTransSetup = 3;
            this.mDriveModeTrack.mDriveMode = DriveModeSetOption.MODE_TRACK;
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,this.mDriveModeTrack));
            this.mDriveModeSport.mDriveMode = DriveModeSetOption.MODE_SPORT;
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,this.mDriveModeSport));
            this.mDriveModeDefault.mDriveMode = DriveModeSetOption.MODE_DEFAULT;
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,this.mDriveModeDefault));
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_TRACK,dBusHoursePowerModeStat,hpStatus);
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_TRACK,dBusShftPROG,transStatus);
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_SPORT,dBusHoursePowerModeStat,hpStatus);
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_SPORT,dBusShftPROG,transStatus);
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_DEFAULT,dBusHoursePowerModeStat,hpStatus);
            this.sendSetLocaPropCommand(DriveModeSetOption.MODE_DEFAULT,dBusShftPROG,transStatus);
            if(!this.mIsValet)
            {
               this.sendSetCommand(dBusHoursePowerModeStat,hpStatus);
               this.sendSetCommand(dBusShftPROG,transStatus);
            }
         }
      }
      
      public function InitDrivemodeLuaData(driveMode:DriveModeSetOption, driveModeFlag:uint) : void
      {
         var message:* = null;
         var paddleStatus:String = null;
         var transStatus:String = null;
         var suspStatus:String = null;
         var epsStatus:String = null;
         var tractionStatus:String = null;
         var powerStatus:String = null;
         var engStatus:String = null;
         var transValue:uint = driveMode.mTransSetup;
         var tractionValue:uint = driveMode.mTractionSetup;
         var epsValue:uint = driveMode.mEpsSetup;
         var suspValue:uint = driveMode.mSuspSetup;
         if(4 == driveMode.mDriveMode)
         {
            epsValue = DriveModeSetOption.mEps;
            suspValue = DriveModeSetOption.mSusp;
         }
         if("non-SRT" == this.mDriveModeType)
         {
            if(1 == transValue)
            {
               transValue = 2;
            }
            if(1 == tractionValue)
            {
               tractionValue = 2;
            }
            if(1 == epsValue)
            {
               epsValue = 2;
            }
            else if(2 == epsValue)
            {
               epsValue = 3;
            }
            else if(3 == epsValue)
            {
               epsValue = 1;
            }
         }
         switch(driveMode.mPaddle)
         {
            case 1:
               paddleStatus = "Paddles Enabled";
               break;
            case 3:
               paddleStatus = "Paddles Disabled";
         }
         switch(transValue)
         {
            case 1:
               transStatus = "Track";
               break;
            case 2:
               transStatus = "Sport";
               break;
            case 3:
               transStatus = "Street";
               break;
            case 4:
               transStatus = "Eco";
               break;
            case 5:
               transStatus = "Valet";
               break;
            case 6:
               transStatus = "Default";
         }
         switch(suspValue)
         {
            case 1:
               suspStatus = "Mode 3";
               break;
            case 2:
               suspStatus = "Mode 2";
               break;
            case 3:
               suspStatus = "Mode 1";
               break;
            case 0:
               suspStatus = "DEFAULT";
         }
         switch(epsValue)
         {
            case 1:
               epsStatus = "Mode 3";
               break;
            case 2:
               epsStatus = "Mode 2";
               break;
            case 3:
               epsStatus = "Mode 1";
               break;
            case 0:
               epsStatus = "DEFAULT";
         }
         switch(tractionValue)
         {
            case 1:
               tractionStatus = "PARTIAL 2";
               break;
            case 2:
               tractionStatus = "PARTIAL 1";
               break;
            case 3:
               tractionStatus = "ON";
               break;
            case 4:
               tractionStatus = "OFF";
               break;
            case 5:
               tractionStatus = "NOT_PRESSED";
         }
         switch(driveMode.mPower)
         {
            case 1:
               powerStatus = "RED";
               break;
            case 3:
               powerStatus = "BLACK";
               break;
            case 0:
               powerStatus = "NONE";
         }
         if("non-SRT" == this.mDriveModeType)
         {
            switch(transValue)
            {
               case 1:
                  engStatus = "Track";
                  break;
               case 2:
                  engStatus = "Sport";
                  break;
               case 3:
                  engStatus = "Normal";
            }
         }
         switch(driveModeFlag)
         {
            case DriveModeSetOption.MODE_TRACK:
               message = "track";
               break;
            case DriveModeSetOption.MODE_SPORT:
               message = "sport";
               break;
            case DriveModeSetOption.MODE_CUSTOM:
               message = "custom";
               break;
            case DriveModeSetOption.MODE_DEFAULT:
               message = "default";
         }
         message = paddleStatus + "\",\"" + transStatus + "\",\"" + suspStatus + "\",\"" + epsStatus + "\",\"" + tractionStatus + "\",\"" + powerStatus + "\",\"" + engStatus + "\",\"" + message;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"initModeData\":{\"props\":[\"" + message + "\"]}}}";
         this.client.send(message);
      }
      
      public function setDefaultToBase(sportStat:uint) : void
      {
         var message:* = null;
         var paddleStatus:String = null;
         var transStatus:String = null;
         var suspStatus:String = null;
         var epsStatus:String = null;
         var tractionStatus:String = null;
         var powerStatus:String = null;
         var status:String = null;
         paddleStatus = "button not pressed";
         suspStatus = "DEFAULT";
         tractionStatus = "NOT_PRESSED";
         powerStatus = "NONE";
         if(sportStat == 0)
         {
            epsStatus = "DEFAULT";
            transStatus = "Default";
            message = "default";
            status = "Normal";
         }
         else if(sportStat == 1)
         {
            epsStatus = "Mode 2";
            transStatus = "Sport";
            message = "sport";
            status = "Sport";
         }
         else if(sportStat == 2)
         {
            epsStatus = "DEFAULT";
            transStatus = "Street";
            message = "default";
            status = "Normal";
         }
         message = paddleStatus + "\",\"" + transStatus + "\",\"" + suspStatus + "\",\"" + epsStatus + "\",\"" + tractionStatus + "\",\"" + powerStatus + "\",\"" + status + "\",\"" + message;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setBaseModeData\":{\"props\":[\"" + message + "\"]}}}";
         this.client.send(message);
      }
      
      public function getBaseState() : Boolean
      {
         if(!this.SRTPresent && !this.STPPresent && this.SPORTPresent)
         {
            return true;
         }
         return false;
      }
      
      public function setModeCommand(value:String) : void
      {
         var message:* = null;
         if(value)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + value + "\":{}}}";
            this.client.send(message);
         }
      }
      
      public function getPaddleShiftersPrsnt() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"PaddleShiftersPrsnt\"]}}}");
      }
      
      public function getTransmissionPrsnt() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"TransmissionPrsnt\"]}}}");
      }
      
      public function getShftIndPresent() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"ShftIndPrsnt\"]}}}");
      }
      
      public function getNetCfgEPSPrsnt() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"NetCfgEPSPrsnt\"]}}}");
      }
      
      public function getPowersSteeringSystemType() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"PowersSteeringSystemType\"]}}}");
      }
      
      public function getSuspensionPrsnt() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"SuspensionPrsnt\"]}}}");
      }
      
      public function getSRTPresent() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"SRTPrsnt\"]}}}");
      }
      
      public function getSTPPresent() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"STPPrsnt\"]}}}");
      }
      
      public function getIgnition() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"ignition\"]}}}");
      }
      
      public function getDriveModePrsnt() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"DriveModePrsnt\"]}}}");
      }
      
      public function getEngPowerDrvMdPrsnt() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"EngPowerDrvMdPrsnt\"]}}}");
      }
      
      public function getRedKeyPrsnt() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"RedKeyPrsnt\"]}}}");
      }
      
      public function getDisplacement() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"Displacement\"]}}}");
      }
      
      public function getPsiMaxRpm() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"PsiMaxRpm\"]}}}");
      }
      
      public function getEPSModeCfgStat() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"EPSModeCfgStat\"]}}}");
      }
      
      public function getEPSWarnDispRq() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"EPSWarnDispRq\"]}}}");
      }
      
      public function getPaddlesModeSts() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"PaddlesModeSts\"]}}}");
      }
      
      public function getShftPROG() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"ShftPROG\"]}}}");
      }
      
      public function getEPSModeStat() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"EPSModeStat\"]}}}");
      }
      
      public function getEPSWarnDisp() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"EPSWarnDisp\"]}}}");
      }
      
      public function getESCModeStat() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"ESCModeStat\"]}}}");
      }
      
      public function getADSModeCFGStat() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"ADSModeCFGStat\"]}}}");
      }
      
      public function getADSModeStat() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"ADSModeStat\"]}}}");
      }
      
      public function getHoursePowerModeStat() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"HoursePowerModeStat\"]}}}");
      }
      
      public function getLaunchBtnStat() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"LaunchBtnStat\"]}}}");
      }
      
      public function getLaunchRPMSettingEsc() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"LaunchRPMSettingEsc\"]}}}");
      }
      
      public function getPsiEnableSts() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"PsiEnableSts\"]}}}");
      }
      
      public function getPsiGr1RPM() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"PsiGr1RPM\"]}}}");
      }
      
      public function getPsiGr2RPM() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"PsiGr2RPM\"]}}}");
      }
      
      public function getPsiGr3RPM() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"PsiGr3RPM\"]}}}");
      }
      
      public function getPsiGr4RPM() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"PsiGr4RPM\"]}}}");
      }
      
      public function getPsiGr5RPM() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"PsiGr5RPM\"]}}}");
      }
      
      private function getProperties(property:String) : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"" + property + "\"]}}}");
      }
      
      public function setEPSCfgMode(state:String) : void
      {
         this.mEPSModeCfgStat = state;
         this.sendSetCommand(dBusEPSModeCfgStat,state);
      }
      
      private function setHp(setupmode:int, value:uint, forceSet:Boolean = false) : void
      {
         var status:String = null;
         var mode:DriveModeSetOption = this.driveModeData(setupmode);
         if(1 == value)
         {
            status = "RED";
         }
         else if(3 == value)
         {
            status = "BLACK";
         }
         else if(0 == value)
         {
            status = "NONE";
         }
         if(status)
         {
            mode.mPowerSetup = value;
            if("SRT" == this.mDriveModeType)
            {
               mode.mPower = value;
               if(this.mEcoStatus)
               {
                  this.EcoStatus = false;
               }
               dispatchEvent(new DriveModeEvent(DriveModeEvent.HP_CHANGED));
               mode.mDriveMode = setupmode;
               dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,mode));
               this.sendSetCommand(dBusHoursePowerModeStat,status);
            }
         }
      }
      
      private function setEps(setupmode:int, value:uint, forceSet:Boolean = false) : void
      {
         var status:String = null;
         var mode:DriveModeSetOption = this.driveModeData(setupmode);
         var local_value:uint = value;
         if("non-SRT" == this.mDriveModeType)
         {
            if(1 == local_value)
            {
               local_value = 2;
            }
            else if(2 == local_value)
            {
               local_value = 3;
            }
            else if(3 == local_value)
            {
               local_value = 1;
            }
         }
         switch(local_value)
         {
            case 1:
               status = "Mode 3";
               break;
            case 2:
               status = "Mode 2";
               break;
            case 3:
               status = "Mode 1";
         }
         if(status)
         {
            mode.mEpsSetup = value;
            if("SRT" == this.mDriveModeType || setupmode == this.getDriveModeMode())
            {
               this.sendSetCommand(dBusEPSModeStat,status);
            }
            else
            {
               this.sendSetLocaPropCommand(setupmode,dBusEPSModeStat,status);
            }
            mode.mDriveMode = setupmode;
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,mode));
         }
      }
      
      private function setPaddles(setupmode:int, value:uint, forceSet:Boolean = false) : void
      {
         var status:String = null;
         var mode:DriveModeSetOption = this.driveModeData(setupmode);
         if(1 == value)
         {
            status = "Paddles Enabled";
         }
         else if(3 == value)
         {
            status = "Paddles Disabled";
         }
         if(status)
         {
            mode.mPaddleSetup = value;
            mode.mPaddle = value;
            if("SRT" == this.mDriveModeType || setupmode == this.getDriveModeMode())
            {
               if(this.mEcoStatus)
               {
                  this.EcoStatus = false;
               }
               this.sendSetCommand(dBusPaddlesModeSts,status);
            }
            else
            {
               this.sendSetLocaPropCommand(setupmode,dBusPaddlesModeSts,status);
            }
            mode.mDriveMode = setupmode;
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,mode));
         }
      }
      
      private function setTrans(setupmode:int, value:uint, forceSet:Boolean = false) : void
      {
         var status:String = null;
         var mode:DriveModeSetOption = this.driveModeData(setupmode);
         var local_value:uint = value;
         if("non-SRT" == this.mDriveModeType && 1 == local_value)
         {
            local_value = 2;
         }
         switch(local_value)
         {
            case 1:
               status = "Track";
               break;
            case 2:
               status = "Sport";
               break;
            case 3:
               status = "Street";
               break;
            case 4:
               status = "Eco";
               break;
            case 5:
               status = "Valet";
               break;
            case 6:
               status = "Default";
         }
         if(status)
         {
            mode.mTransSetup = value;
            if(setupmode == this.getDriveModeMode())
            {
               if("SRT" == this.mDriveModeType)
               {
                  if(this.mEcoStatus)
                  {
                     this.EcoStatus = false;
                  }
                  this.sendSetCommand(dBusShftPROG,status);
               }
               else
               {
                  if(this.isATX() || this.TransmissionPrsnt)
                  {
                     this.sendSetCommand(dBusShftPROG,status);
                  }
                  this.sendSetCommand(dBusEnginPowerModeStat,status);
               }
            }
            else
            {
               if(this.isATX() || this.TransmissionPrsnt)
               {
                  this.sendSetLocaPropCommand(setupmode,DriveModeEvent.SHFTPROG,status);
               }
               this.sendSetLocaPropCommand(setupmode,dBusEnginPowerModeStat,status);
            }
            mode.mDriveMode = setupmode;
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,mode));
         }
      }
      
      private function setTraction(setupmode:int, value:uint, forceSet:Boolean = false) : void
      {
         var status:String = null;
         var mode:DriveModeSetOption = this.driveModeData(setupmode);
         if(0 == value)
         {
            value = mode.mTractionSetup;
         }
         var local_value:uint = value;
         this.mEnableEscHK = false;
         this.mEscStauts = false;
         if("non-SRT" == this.mDriveModeType && 1 == local_value)
         {
            local_value = 2;
         }
         switch(local_value)
         {
            case 1:
               status = "PARTIAL 2";
               break;
            case 2:
               status = "PARTIAL 1";
               break;
            case 3:
               status = "ON";
               break;
            case 4:
               status = "OFF";
               break;
            case 5:
               status = "NOT_PRESSED";
         }
         if(status)
         {
            mode.mTractionSetup = value;
            if("SRT" == this.mDriveModeType || setupmode == this.getDriveModeMode())
            {
               this.sendSetCommand(dBusESCModeStat,status);
            }
            else
            {
               this.sendSetLocaPropCommand(setupmode,dBusESCModeStat,status);
            }
            mode.mDriveMode = setupmode;
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,mode));
         }
      }
      
      private function setSusp(setupmode:int, value:uint, forceSet:Boolean = false) : void
      {
         var status:String = null;
         var mode:DriveModeSetOption = this.driveModeData(setupmode);
         switch(value)
         {
            case 1:
               status = "Mode 3";
               break;
            case 2:
               status = "Mode 2";
               break;
            case 3:
               status = "Mode 1";
               break;
            case 4:
               status = "DEFAULT";
         }
         if(status)
         {
            mode.mSuspSetup = value;
            if("SRT" == this.mDriveModeType || setupmode == this.getDriveModeMode())
            {
               this.sendSetCommand(dBusADSModeStat,status);
            }
            else
            {
               this.sendSetLocaPropCommand(setupmode,dBusADSModeStat,status);
            }
            mode.mDriveMode = setupmode;
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LEAVE_MODE_CHANGED,mode));
         }
      }
      
      public function setLaunchBtnStat(state:String, sendCmd:Boolean) : void
      {
         this.mLaunchBtnStat = state;
         if(sendCmd)
         {
            this.sendSetCommand("LaunchBtnStat","Launch on");
         }
         else
         {
            dispatchEvent(new DriveModeEvent(DriveModeEvent.LAUNCHBTNSTAT));
         }
      }
      
      public function setLaunchRPMSettingEsc(state:String) : void
      {
         this.sendSetCommand(dBusLaunchRPMSettingEsc,state);
      }
      
      public function setPsiEnableSts(state:String) : void
      {
         this.sendSetCommand(dBusPsiEnableSts,state);
      }
      
      public function setPsiGr1RPM(state:String) : void
      {
         this.sendSetCommand(dBusPsiGr1RPM,state);
      }
      
      public function setPsiGr2RPM(state:String) : void
      {
         this.sendSetCommand(dBusPsiGr2RPM,state);
      }
      
      public function setPsiGr3RPM(state:String) : void
      {
         this.sendSetCommand(dBusPsiGr3RPM,state);
      }
      
      public function setPsiGr4RPM(state:String) : void
      {
         this.sendSetCommand(dBusPsiGr4RPM,state);
      }
      
      public function setPsiGr5RPM(state:String) : void
      {
         this.sendSetCommand(dBusPsiGr5RPM,state);
      }
      
      public function get driveModeKeyMode() : uint
      {
         return this.mKeyMode;
      }
      
      public function get Displacement() : Boolean
      {
         return this.mDisplacement;
      }
      
      public function get PsiMaxRpm() : uint
      {
         return this.mPsiMaxRpm;
      }
      
      public function get SRTPresent() : Boolean
      {
         if(this.mSRTPresent == "Present")
         {
            return true;
         }
         return false;
      }
      
      public function get STPPresent() : Boolean
      {
         if(this.mSTPPresent == "Present")
         {
            return true;
         }
         return false;
      }
      
      public function get SPORTPresent() : Boolean
      {
         if(this.mSPORTPresent == "Present")
         {
            return true;
         }
         return false;
      }
      
      public function get DriveModePresnt() : Boolean
      {
         return this.mDriveModePresnt && (this.STPPresent || this.SRTPresent);
      }
      
      public function get TransmissionPrsnt() : Boolean
      {
         return this.mTransmissionPrsnt;
      }
      
      public function get Ignition() : String
      {
         return this.mIgnition;
      }
      
      public function get STPButtonPress() : Boolean
      {
         if(this.mSTPButton == "Present")
         {
            return true;
         }
         return false;
      }
      
      public function get launchBtnStat() : String
      {
         return this.mLaunchBtnStat;
      }
      
      public function get launchRPMValue() : String
      {
         return this.mLaunchRPMValue;
      }
      
      public function get driveModeType() : String
      {
         return this.mDriveModeType;
      }
      
      public function get driveModeTypePresent() : Boolean
      {
         return this.mDriveModeTypePresent;
      }
      
      public function setDriveModeOption(mode:uint, type:uint, value:uint, forceSet:Boolean = false) : void
      {
         var option:uint = this.getDriveModeOptionValue(mode,type);
         if(value != option || forceSet)
         {
            switch(type)
            {
               case DriveModeSetOption.TYPE_POWER:
                  this.setHp(mode,value,forceSet);
                  break;
               case DriveModeSetOption.TYPE_TRANS:
                  this.setTrans(mode,value,forceSet);
                  break;
               case DriveModeSetOption.TYPE_PADDLE:
                  this.setPaddles(mode,value,forceSet);
                  break;
               case DriveModeSetOption.TYPE_TRACTION:
                  this.setTraction(mode,value,forceSet);
                  break;
               case DriveModeSetOption.TYPE_SUSP:
                  this.setSusp(mode,value,forceSet);
                  break;
               case DriveModeSetOption.TYPE_EPS:
                  this.setEps(mode,value,forceSet);
            }
         }
      }
      
      public function setDriveModeOptionEnable(type:uint, enalbe:Boolean) : void
      {
         switch(type)
         {
            case DriveModeSetOption.TYPE_POWER:
               this.mDriveModeTrack.mPowerEnable = enalbe;
               this.mDriveModeSport.mPowerEnable = enalbe;
               this.mDriveModeCustome.mPowerEnable = enalbe;
               this.mDriveModeDefault.mPowerEnable = enalbe;
               break;
            case DriveModeSetOption.TYPE_TRACTION:
               this.mDriveModeTrack.mTractionEnabl = enalbe;
               this.mDriveModeSport.mTractionEnabl = enalbe;
               this.mDriveModeCustome.mTractionEnabl = enalbe;
               this.mDriveModeDefault.mTractionEnabl = enalbe;
               break;
            case DriveModeSetOption.TYPE_PADDLE:
               this.mDriveModeTrack.mPaddleEnable = enalbe;
               this.mDriveModeSport.mPaddleEnable = enalbe;
               this.mDriveModeCustome.mPaddleEnable = enalbe;
               this.mDriveModeDefault.mPaddleEnable = enalbe;
               break;
            case DriveModeSetOption.TYPE_TRANS:
               this.mDriveModeTrack.mTransEnable = enalbe;
               this.mDriveModeSport.mTransEnable = enalbe;
               this.mDriveModeCustome.mTransEnable = enalbe;
               this.mDriveModeDefault.mTransEnable = enalbe;
               break;
            case DriveModeSetOption.TYPE_SUSP:
               this.mDriveModeTrack.mSuspEnable = enalbe;
               this.mDriveModeSport.mSuspEnable = enalbe;
               this.mDriveModeCustome.mSuspEnable = enalbe;
               this.mDriveModeDefault.mSuspEnable = enalbe;
               break;
            case DriveModeSetOption.TYPE_EPS:
               this.mDriveModeTrack.mEpsEnable = enalbe;
               this.mDriveModeSport.mEpsEnable = enalbe;
               this.mDriveModeCustome.mEpsEnable = enalbe;
               this.mDriveModeDefault.mEpsEnable = enalbe;
         }
      }
      
      public function getDriveModeOptionValue(mode:uint, type:uint) : uint
      {
         var option:uint = 0;
         var driveModeOption:DriveModeSetOption = this.driveModeData(mode);
         if(null != driveModeOption)
         {
            switch(type)
            {
               case DriveModeSetOption.TYPE_POWER:
                  option = driveModeOption.mPowerEnable ? driveModeOption.mPowerSetup : 0;
                  break;
               case DriveModeSetOption.TYPE_TRACTION:
                  option = driveModeOption.mTractionEnabl ? driveModeOption.mTractionSetup : 0;
                  break;
               case DriveModeSetOption.TYPE_PADDLE:
                  option = driveModeOption.mPaddleEnable ? driveModeOption.mPaddleSetup : 0;
                  break;
               case DriveModeSetOption.TYPE_TRANS:
                  option = driveModeOption.mTransEnable ? driveModeOption.mTransSetup : 0;
                  break;
               case DriveModeSetOption.TYPE_SUSP:
                  option = driveModeOption.mSuspEnable ? driveModeOption.mSuspSetup : 0;
                  break;
               case DriveModeSetOption.TYPE_EPS:
                  option = driveModeOption.mEpsEnable ? driveModeOption.mEpsSetup : 0;
            }
         }
         if("SRT" != this.mDriveModeType && type == DriveModeSetOption.TYPE_TRANS)
         {
            option = driveModeOption.mTransSetup;
         }
         return option;
      }
      
      public function getDriveModeRunTimeValue(mode:uint, type:uint) : uint
      {
         var option:uint = 0;
         var driveModeOption:DriveModeSetOption = this.driveModeData(mode);
         if(null != driveModeOption)
         {
            switch(type)
            {
               case DriveModeSetOption.TYPE_POWER:
                  option = driveModeOption.mPowerEnable ? driveModeOption.mPower : 0;
                  break;
               case DriveModeSetOption.TYPE_TRACTION:
                  option = driveModeOption.mTractionEnabl ? DriveModeSetOption.mTraction : 0;
                  break;
               case DriveModeSetOption.TYPE_PADDLE:
                  option = driveModeOption.mPaddleEnable ? driveModeOption.mPaddle : 0;
                  break;
               case DriveModeSetOption.TYPE_TRANS:
                  option = driveModeOption.mTransEnable ? DriveModeSetOption.mTrans : 0;
                  break;
               case DriveModeSetOption.TYPE_SUSP:
                  option = driveModeOption.mSuspEnable ? DriveModeSetOption.mSusp : 0;
                  break;
               case DriveModeSetOption.TYPE_EPS:
                  option = driveModeOption.mEpsEnable ? DriveModeSetOption.mEps : 0;
            }
         }
         if("SRT" != this.mDriveModeType && type == DriveModeSetOption.TYPE_TRANS)
         {
            option = DriveModeSetOption.mTrans;
         }
         return option;
      }
      
      public function setDriveModeOptionSupport(mode:uint, type:uint, Support:uint) : void
      {
         var driveModeOption:DriveModeSetOption = this.driveModeData(mode);
         if(null != driveModeOption)
         {
            switch(type)
            {
               case DriveModeSetOption.TYPE_POWER:
                  driveModeOption.mPowerTypes = Support;
                  break;
               case DriveModeSetOption.TYPE_TRACTION:
                  driveModeOption.mTractionTypes = Support;
                  break;
               case DriveModeSetOption.TYPE_PADDLE:
                  driveModeOption.mPaddleTypes = Support;
                  break;
               case DriveModeSetOption.TYPE_TRANS:
                  driveModeOption.mTransTypes = Support;
                  break;
               case DriveModeSetOption.TYPE_SUSP:
                  driveModeOption.mSuspTypes = Support;
                  break;
               case DriveModeSetOption.TYPE_EPS:
                  driveModeOption.mEpsTypes = Support;
            }
         }
      }
      
      public function getDriveModeOptionLevelVisible(mode:uint, type:uint, index:uint) : Boolean
      {
         var value:uint = this.getIndexValue(mode,type,index);
         return value >= 1;
      }
      
      public function getDriveModeOptionLevelEnable(mode:uint, type:uint, index:uint) : Boolean
      {
         var value:uint = this.getIndexValue(mode,type,index);
         return value == 2;
      }
      
      public function getDriveModeOptionTypeEnable(type:uint) : Boolean
      {
         var enalbe:Boolean = false;
         switch(type)
         {
            case DriveModeSetOption.TYPE_POWER:
               enalbe = this.mDriveModeTrack.mPowerEnable;
               break;
            case DriveModeSetOption.TYPE_TRACTION:
               enalbe = this.mDriveModeTrack.mTractionEnabl;
               break;
            case DriveModeSetOption.TYPE_PADDLE:
               enalbe = this.mDriveModeTrack.mPaddleEnable;
               break;
            case DriveModeSetOption.TYPE_TRANS:
               enalbe = this.mDriveModeTrack.mTransEnable;
               break;
            case DriveModeSetOption.TYPE_SUSP:
               enalbe = this.mDriveModeTrack.mSuspEnable;
               break;
            case DriveModeSetOption.TYPE_EPS:
               enalbe = this.mDriveModeTrack.mEpsEnable;
         }
         if("SRT" != this.mDriveModeType)
         {
            if(type == DriveModeSetOption.TYPE_SUSP || type == DriveModeSetOption.TYPE_POWER)
            {
               return false;
            }
            if(type == DriveModeSetOption.TYPE_TRANS)
            {
               return true;
            }
         }
         return enalbe;
      }
      
      public function setDriveModeMode(mode:uint) : void
      {
         switch(mode)
         {
            case 1:
               this.setTrackMode();
               break;
            case 2:
               this.setSportMode();
               break;
            case 3:
               this.setCustomMode();
               break;
            case 4:
               this.setDefaultMode();
         }
      }
      
      public function getDriveModeMode() : int
      {
         return this.mDriveModeMode;
      }
      
      public function setDriveModeEco(enable:Boolean) : void
      {
         this.EcoStatus = enable;
         if(!enable)
         {
            this.setHp(this.mDriveModeMode,this.driveModeData(this.mDriveModeMode).mPowerSetup,true);
         }
      }
      
      public function getDriveModeEco() : Boolean
      {
         return this.mEcoStatus;
      }
      
      public function setShiftBtnStat(status:Boolean) : void
      {
         if(status)
         {
            this.sendSetCommand(dBusPsiEnableSts,"Enabled");
         }
         else
         {
            this.sendSetCommand(dBusPsiEnableSts,"Disabled");
         }
      }
      
      public function getShiftBtnStat() : Boolean
      {
         if(this.mShiftBtnStat == "Enabled")
         {
            return true;
         }
         return false;
      }
      
      public function setLaunchRPMValuve(value:String) : void
      {
         this.mLaunchRPMValuve = value;
      }
      
      public function getLaunchRPMValuve() : String
      {
         return this.mLaunchRPMValuve;
      }
      
      public function setRaceOptionScreenMode(mode:String) : void
      {
         this.mRaceOptionScreenStat = mode;
      }
      
      public function getRaceOptionScreenMode() : String
      {
         if("" == this.mRaceOptionScreenStat)
         {
            if("SRT" == this.mDriveModeType)
            {
               if(this.mSupportLaunchControl)
               {
                  this.mRaceOptionScreenStat = "LaunchControlSrt";
               }
               else
               {
                  this.mRaceOptionScreenStat = "ShiftLightSrt";
               }
            }
            else if(this.mSupportLaunchControl)
            {
               this.mRaceOptionScreenStat = "LaunchControlNonSrt";
            }
            else if(this.mSupportShiftLight)
            {
               this.mRaceOptionScreenStat = "ShiftLightNonSrt";
            }
            else
            {
               this.mRaceOptionScreenStat = "DriveMode";
            }
         }
         return this.mRaceOptionScreenStat;
      }
      
      public function setCacheLaunchScreen(currentScreen:String) : void
      {
         this.mCacheLaunchScreen = currentScreen;
      }
      
      public function getCacheLaunchScreen() : String
      {
         return this.mCacheLaunchScreen;
      }
      
      public function setGear1RPM(rpm:String) : void
      {
         this.mSetRpm1Timer.reset();
         this.mSetRpm1Timer.start();
         this.mPsiGr1RPM = rpm;
      }
      
      private function onSetRpm1Timer(e:TimerEvent) : void
      {
         this.sendSetCommand(dBusPsiGr1RPM,this.mPsiGr1RPM);
      }
      
      public function setGear2RPM(rpm:String) : void
      {
         this.mSetRpm2Timer.reset();
         this.mSetRpm2Timer.start();
         this.mPsiGr2RPM = rpm;
      }
      
      private function onSetRpm2Timer(e:TimerEvent) : void
      {
         this.sendSetCommand(dBusPsiGr2RPM,this.mPsiGr2RPM);
      }
      
      public function setGear3RPM(rpm:String) : void
      {
         this.mSetRpm3Timer.reset();
         this.mSetRpm3Timer.start();
         this.mPsiGr3RPM = rpm;
      }
      
      private function onSetRpm3Timer(e:TimerEvent) : void
      {
         this.sendSetCommand(dBusPsiGr3RPM,this.mPsiGr3RPM);
      }
      
      public function setGear4RPM(rpm:String) : void
      {
         this.mSetRpm4Timer.reset();
         this.mSetRpm4Timer.start();
         this.mPsiGr4RPM = rpm;
      }
      
      private function onSetRpm4Timer(e:TimerEvent) : void
      {
         this.sendSetCommand(dBusPsiGr4RPM,this.mPsiGr4RPM);
      }
      
      public function setGear5RPM(rpm:String) : void
      {
         this.mSetRpm5Timer.reset();
         this.mSetRpm5Timer.start();
         this.mPsiGr5RPM = rpm;
      }
      
      private function onSetRpm5Timer(e:TimerEvent) : void
      {
         this.sendSetCommand(dBusPsiGr5RPM,this.mPsiGr5RPM);
      }
      
      public function get gear1RPM() : String
      {
         return this.mPsiGr1RPM;
      }
      
      public function get gear2RPM() : String
      {
         return this.mPsiGr2RPM;
      }
      
      public function get gear3RPM() : String
      {
         return this.mPsiGr3RPM;
      }
      
      public function get gear4RPM() : String
      {
         return this.mPsiGr4RPM;
      }
      
      public function get gear5RPM() : String
      {
         return this.mPsiGr5RPM;
      }
      
      public function isSupportLaunchControl() : Boolean
      {
         return this.mSupportLaunchControl;
      }
      
      public function isSupportShiftLight() : Boolean
      {
         return this.mSupportShiftLight;
      }
      
      public function isSupportNonSrtDriveMode() : Boolean
      {
         return this.mSupportNonSrtDriveMode;
      }
      
      public function get engineType() : String
      {
         return this.mEngineType;
      }
      
      public function get throttle() : uint
      {
         return this.mThrottle;
      }
      
      public function isATX() : Boolean
      {
         return this.mTransType;
      }
      
      public function isMTX() : Boolean
      {
         return !this.mTransType;
      }
      
      public function isNetCfgTCM() : Boolean
      {
         return this.mNetCfgTcm;
      }
      
      public function isHellcat() : Boolean
      {
         if("non-SRT" == this.mDriveModeType)
         {
            return false;
         }
         return this.mDisplacement;
      }
      
      public function setPSIRPMReset() : void
      {
         var value:String = "ResetRPM";
         var message:Object = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + value + "\":{}}}";
         this.client.send(message);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case DriveModeEvent.POWERSSTEERINGSYSTEMTYPE:
               this.sendSubscribe(dBusPowersSteeringSystemType);
               break;
            case DriveModeEvent.EPSMODECFGSTAT:
               this.sendSubscribe(dBusEPSModeCfgStat);
               break;
            case DriveModeEvent.EPSWARMDISPRQ:
               this.sendSubscribe(dBusEPSWarnDispRq);
               break;
            case DriveModeEvent.WARNING:
               this.sendSubscribe(dBusWarnDispRq);
               break;
            case DriveModeEvent.THROTTLE:
               this.sendSubscribe(dBusThrottle);
               break;
            case DriveModeEvent.PADDLESMODESTS:
               this.sendSubscribe(dBusPaddlesModeSts);
               break;
            case DriveModeEvent.SHFTPROG:
               this.sendSubscribe(dBusShftPROG);
               break;
            case DriveModeEvent.EPSMODESTAT:
               this.sendSubscribe(dBusEPSModeStat);
               break;
            case DriveModeEvent.EPSWARNDISP:
               this.sendSubscribe(dBusEPSWarnDisp);
               break;
            case DriveModeEvent.ESCMODESTAT:
               this.sendSubscribe(dBusESCModeStat);
               break;
            case DriveModeEvent.ADSMODECFGSTAT:
               this.sendSubscribe(dBusADSModeCFGStat);
               break;
            case DriveModeEvent.HOURSEPOWERMODESTAT:
               this.sendSubscribe(dBusHoursePowerModeStat);
               break;
            case DriveModeEvent.LAUNCHBTNSTAT:
               this.sendSubscribe(dBusLaunchBtnStat);
               break;
            case DriveModeEvent.LAUNCHRPMSETTINGESC:
               this.sendSubscribe(dBusLaunchRPMSettingEsc);
               break;
            case DriveModeEvent.PSIENABLESTS:
               this.sendSubscribe(dBusPsiEnableSts);
               break;
            case DriveModeEvent.PSIGR1RPM:
               this.sendSubscribe(dBusPsiGr1RPM);
               break;
            case DriveModeEvent.PSIGR2RPM:
               this.sendSubscribe(dBusPsiGr2RPM);
               break;
            case DriveModeEvent.PSIGR3RPM:
               this.sendSubscribe(dBusPsiGr3RPM);
               break;
            case DriveModeEvent.PSIGR4RPM:
               this.sendSubscribe(dBusPsiGr4RPM);
               break;
            case DriveModeEvent.PSIGR5RPM:
               this.sendSubscribe(dBusPsiGr5RPM);
               break;
            case DriveModeEvent.IGNITION:
               this.sendSubscribe(dBusignition);
               break;
            case DriveModeEvent.DRIVEMODEPRSNT:
               this.sendSubscribe(dBusDriveModePrsnt);
               break;
            case DriveModeEvent.VEHLINEPRSNT:
               this.sendSubscribe(dBusvehLinePrsnt);
               break;
            case DriveModeEvent.MODESETUPPRSNT:
               this.sendSubscribe(dBusModeSetUpPrsnt);
               break;
            case DriveModeEvent.PADDLESHIFTERSPRSNT:
               this.sendSubscribe(dBusPaddleShiftersPrsnt);
               break;
            case DriveModeEvent.TRANSMISSIONPRSNT:
               this.sendSubscribe(dBusTransmissionPrsnt);
               break;
            case DriveModeEvent.NETCFGEPSPRSNT:
               this.sendSubscribe(dBusNetCfgEPSPrsnt);
               break;
            case DriveModeEvent.SUSPENSIONPRSNT:
               this.sendSubscribe(dBusSuspensionPrsnt);
               break;
            case DriveModeEvent.ECMDRIVEPRSNT:
               this.sendSubscribe(dBusECMDrivePrsnt);
               break;
            case DriveModeEvent.SRTPRSNT:
               this.sendSubscribe(dBusSRTPrsnt);
               break;
            case DriveModeEvent.STPPRSNT:
               this.sendSubscribe(dBusSTPPrsnt);
               break;
            case DriveModeEvent.STPBUTTON:
               this.sendSubscribe(dBusSTPbButton);
               break;
            case DriveModeEvent.ECO:
               this.sendSubscribe(dBusEcoModeStat);
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case DriveModeEvent.POWERSSTEERINGSYSTEMTYPE:
               this.sendUnsubscribe(dBusPowersSteeringSystemType);
               break;
            case DriveModeEvent.EPSMODECFGSTAT:
               this.sendUnsubscribe(dBusEPSModeCfgStat);
               break;
            case DriveModeEvent.EPSWARMDISPRQ:
               this.sendUnsubscribe(dBusEPSWarnDispRq);
               break;
            case DriveModeEvent.WARNING:
               this.sendUnsubscribe(dBusWarnDispRq);
               break;
            case DriveModeEvent.THROTTLE:
               this.sendUnsubscribe(dBusThrottle);
               break;
            case DriveModeEvent.PADDLESMODESTS:
               this.sendUnsubscribe(dBusPaddlesModeSts);
            case DriveModeEvent.SHFTPROG:
               this.sendUnsubscribe(dBusShftPROG);
               break;
            case DriveModeEvent.EPSMODESTAT:
               this.sendUnsubscribe(dBusEPSModeStat);
               break;
            case DriveModeEvent.EPSWARNDISP:
               this.sendUnsubscribe(dBusEPSWarnDisp);
               break;
            case DriveModeEvent.ESCMODESTAT:
               this.sendUnsubscribe(dBusESCModeStat);
               break;
            case DriveModeEvent.ADSMODECFGSTAT:
               this.sendUnsubscribe(dBusADSModeCFGStat);
               break;
            case DriveModeEvent.HOURSEPOWERMODESTAT:
               this.sendUnsubscribe(dBusHoursePowerModeStat);
               break;
            case DriveModeEvent.LAUNCHBTNSTAT:
               this.sendUnsubscribe(dBusLaunchBtnStat);
               break;
            case DriveModeEvent.LAUNCHRPMSETTINGESC:
               this.sendUnsubscribe(dBusLaunchRPMSettingEsc);
               break;
            case DriveModeEvent.PSIENABLESTS:
               this.sendUnsubscribe(dBusPsiEnableSts);
               break;
            case DriveModeEvent.PSIGR1RPM:
               this.sendUnsubscribe(dBusPsiGr1RPM);
               break;
            case DriveModeEvent.PSIGR2RPM:
               this.sendUnsubscribe(dBusPsiGr2RPM);
               break;
            case DriveModeEvent.PSIGR3RPM:
               this.sendUnsubscribe(dBusPsiGr3RPM);
               break;
            case DriveModeEvent.PSIGR4RPM:
               this.sendUnsubscribe(dBusPsiGr4RPM);
               break;
            case DriveModeEvent.PSIGR5RPM:
               this.sendUnsubscribe(dBusPsiGr5RPM);
               break;
            case DriveModeEvent.IGNITION:
               this.sendUnsubscribe(dBusignition);
               break;
            case DriveModeEvent.DRIVEMODEPRSNT:
               this.sendUnsubscribe(dBusDriveModePrsnt);
               break;
            case DriveModeEvent.VEHLINEPRSNT:
               this.sendUnsubscribe(dBusvehLinePrsnt);
               break;
            case DriveModeEvent.MODESETUPPRSNT:
               this.sendUnsubscribe(dBusModeSetUpPrsnt);
               break;
            case DriveModeEvent.PADDLESHIFTERSPRSNT:
               this.sendUnsubscribe(dBusPaddleShiftersPrsnt);
               break;
            case DriveModeEvent.TRANSMISSIONPRSNT:
               this.sendUnsubscribe(dBusTransmissionPrsnt);
               break;
            case DriveModeEvent.NETCFGEPSPRSNT:
               this.sendUnsubscribe(dBusNetCfgEPSPrsnt);
               break;
            case DriveModeEvent.SUSPENSIONPRSNT:
               this.sendUnsubscribe(dBusSuspensionPrsnt);
               break;
            case DriveModeEvent.ECMDRIVEPRSNT:
               this.sendUnsubscribe(dBusECMDrivePrsnt);
               break;
            case DriveModeEvent.SRTPRSNT:
               this.sendUnsubscribe(dBusSRTPrsnt);
               break;
            case DriveModeEvent.STPPRSNT:
               this.sendUnsubscribe(dBusSTPPrsnt);
               break;
            case DriveModeEvent.STPBUTTON:
               this.sendUnsubscribe(dBusSTPbButton);
         }
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            this.sendMultiSubscribe([dBusEPSModeStat,dBusApiGetProperties,dBusEPSWarnDispRq,dBusShftPROG,dBusPowersSteeringSystemType,dBusEPSModeCfgStat,dBusPaddlesModeSts,dBusADSModeCFGStat,dBusADSModeStat,dBusHoursePowerModeStat,dBusESCModeStat,dBusLaunchBtnStat,dBusPsiEnableSts,dBusEnginPowerModeStat,dBusLaunchRPMSettingEsc,dBusignition,dBusDriveModePrsnt,dBusvehLinePrsnt,dBusModeSetUpPrsnt,dBusPaddleShiftersPrsnt,dBusTransmissionPrsnt,dBusTransType,dBusNetCfgTcm,dBusESCDrvMdPrsnt,dBusNetCfgEPSPrsnt,dBusSuspensionPrsnt,dBusECMDrivePrsnt,dBusSRTPrsnt,dBusSTPPrsnt,dBusSTPbButton,dBusEPSModeCfgStat,dBusPsiGr1RPM,dBusPsiGr2RPM,dBusPsiGr3RPM,dBusPsiGr4RPM,dBusPsiGr5RPM,dBusThrottle,dBusShftIndPrsnt,dBusDisplacement,dBusRedKeyPrsnt,dBusPsiMaxRpm]);
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
         this.sendSubscribe(dBusReadyFlag);
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
         this.sendUnsubscribe(dBusReadyFlag);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:* = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendSetCommand(valueName:String, value:String = null) : void
      {
         var message:* = null;
         if(value != null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + dBusApiSetProperties + "\":{\"props\":{\"" + valueName + "\" :\"" + value + "\"}}}}";
            this.client.send(message);
         }
      }
      
      private function sendSetEcoCommand(value:String = null) : void
      {
         var message:* = null;
         if(value)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + value + "\":{}}}";
            this.client.send(message);
         }
      }
      
      private function sendSetLocaPropCommand(mode:int, valueName:String, value:String = null) : void
      {
         var message:* = null;
         if(value)
         {
            message = mode + "\",\"" + valueName + "\",\"" + value;
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setLocalProp\":{\"props\":[\"" + message + "\"]}}}";
            this.client.send(message);
         }
      }
      
      private function driveModeData(mode:uint) : DriveModeSetOption
      {
         var driveModeOption:DriveModeSetOption = new DriveModeSetOption();
         switch(mode)
         {
            case 1:
               driveModeOption = this.mDriveModeTrack;
               break;
            case 2:
               driveModeOption = this.mDriveModeSport;
               break;
            case 3:
               driveModeOption = this.mDriveModeCustome;
               break;
            case 4:
               driveModeOption = this.mDriveModeDefault;
         }
         return driveModeOption;
      }
      
      private function getIndexValue(mode:uint, type:uint, index:uint) : uint
      {
         var supports:uint = 0;
         var support:Boolean = false;
         var stand:uint = 0;
         var filter:uint = 0;
         var driveModeOption:DriveModeSetOption = this.driveModeData(mode);
         if(null != driveModeOption)
         {
            switch(type)
            {
               case DriveModeSetOption.TYPE_POWER:
                  supports = driveModeOption.mPowerTypes;
                  break;
               case DriveModeSetOption.TYPE_TRACTION:
                  supports = driveModeOption.mTractionTypes;
                  break;
               case DriveModeSetOption.TYPE_PADDLE:
                  supports = driveModeOption.mPaddleTypes;
                  break;
               case DriveModeSetOption.TYPE_TRANS:
                  supports = driveModeOption.mTransTypes;
                  break;
               case DriveModeSetOption.TYPE_SUSP:
                  supports = driveModeOption.mSuspTypes;
                  break;
               case DriveModeSetOption.TYPE_EPS:
                  supports = driveModeOption.mEpsTypes;
            }
         }
         switch(index)
         {
            case 1:
               stand = 768;
               break;
            case 2:
               stand = 48;
               break;
            case 3:
               stand = 3;
         }
         return uint((stand & supports) >> (3 - index) * 4);
      }
      
      public function get LaunchRPMSettingEsc() : String
      {
         return this.mLaunchRPMSettingEsc;
      }
      
      public function get RedKeyPresent() : Boolean
      {
         if(this.mKeyMode == 1)
         {
            return true;
         }
         return false;
      }
      
      public function get EscStatus() : Boolean
      {
         return this.mEscStauts;
      }
      
      public function setTrackMode() : void
      {
         this.mDriveModeMode = 1;
         if(this.mEcoStatus)
         {
            this.EcoStatus = false;
         }
         this.setModeCommand("setTrackMode");
         this.disableEscHk();
         dispatchEvent(new DriveModeEvent(DriveModeEvent.MODE_CHANGED));
      }
      
      public function setSportMode() : void
      {
         this.mDriveModeMode = 2;
         if(this.mEcoStatus)
         {
            this.EcoStatus = false;
         }
         this.setModeCommand("setSportMode");
         this.disableEscHk();
         dispatchEvent(new DriveModeEvent(DriveModeEvent.MODE_CHANGED));
      }
      
      public function setDefaultMode(needSetToLUA:Boolean = true) : void
      {
         this.mDriveModeMode = 4;
         if(this.mEcoStatus)
         {
            this.EcoStatus = false;
         }
         if(needSetToLUA)
         {
            this.setModeCommand("setDefaultMode");
         }
         this.disableEscHk();
         dispatchEvent(new DriveModeEvent(DriveModeEvent.MODE_CHANGED));
      }
      
      public function setCustomMode() : void
      {
         this.mDriveModeMode = 3;
         if(this.mEcoStatus)
         {
            this.EcoStatus = false;
         }
         this.setModeCommand("setcustomMode");
         this.disableEscHk();
         dispatchEvent(new DriveModeEvent(DriveModeEvent.MODE_CHANGED));
      }
      
      public function setValetMode(isValet:Boolean = true) : void
      {
         this.mIsValet = isValet;
         if(isValet)
         {
            this.setModeCommand("setValetMode");
         }
      }
      
      public function getSettings() : void
      {
         this.getSTPPresent();
         this.getIgnition();
         this.getDriveModePrsnt();
         this.getSuspensionPrsnt();
         this.getEngPowerDrvMdPrsnt();
         this.getTransmissionPrsnt();
         this.getProperties(dBusTransType);
         this.getProperties(dBusNetCfgTcm);
         this.getProperties(dBusESCDrvMdPrsnt);
         this.getPaddleShiftersPrsnt();
         this.getPowersSteeringSystemType();
         this.getNetCfgEPSPrsnt();
         this.getDisplacement();
         this.getRedKeyPrsnt();
         this.getShftIndPresent();
         this.getProperties(dBusThrottle);
         this.getPsiEnableSts();
         this.getSRTPresent();
         this.getPsiMaxRpm();
         this.getProperties(dBusSPORTPrsnt);
      }
      
      public function loadModeConfig(track:DriveModeSetOption, sport:DriveModeSetOption, custom:DriveModeSetOption, defau:DriveModeSetOption, driveModeFlag:uint) : void
      {
         var mode1:DriveModeSetOption = null;
         var mode2:DriveModeSetOption = null;
         var modeArray:Array = new Array();
         modeArray.push(track);
         modeArray.push(sport);
         modeArray.push(custom);
         modeArray.push(defau);
         var modeArray2:Array = new Array();
         modeArray2.push(this.mDriveModeTrack);
         modeArray2.push(this.mDriveModeSport);
         modeArray2.push(this.mDriveModeCustome);
         modeArray2.push(this.mDriveModeDefault);
         while(0 < modeArray.length)
         {
            mode1 = modeArray.pop();
            mode2 = modeArray2.pop();
            if(mode1)
            {
               mode2.mPower = mode1.mPower;
               mode2.mPowerSetup = mode1.mPowerSetup;
               mode2.mTractionSetup = mode1.mTractionSetup;
               mode2.mPaddle = mode1.mPaddle;
               mode2.mPaddleSetup = mode1.mPaddleSetup;
               mode2.mTransSetup = mode1.mTransSetup;
               mode2.mSuspSetup = mode1.mSuspSetup;
               mode2.mEpsSetup = mode1.mEpsSetup;
            }
         }
         if(driveModeFlag != 0)
         {
            this.InitDrivemodeLuaData(defau,driveModeFlag);
         }
      }
      
      private function updateSrtMode() : void
      {
         if("SRT" == this.mDriveModeType)
         {
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_TRACK,DriveModeSetOption.TYPE_POWER,258);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_TRACK,DriveModeSetOption.TYPE_TRACTION,529);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_TRACK,DriveModeSetOption.TYPE_PADDLE,513);
            if(this.mDriveModeTrack.mPowerSetup == DriveModeSetOption.HPLOW && this.isHellcat())
            {
               this.setDriveModeOptionSupport(DriveModeSetOption.MODE_TRACK,DriveModeSetOption.TYPE_TRANS,274);
            }
            else
            {
               this.setDriveModeOptionSupport(DriveModeSetOption.MODE_TRACK,DriveModeSetOption.TYPE_TRANS,529);
            }
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_TRACK,DriveModeSetOption.TYPE_SUSP,529);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_TRACK,DriveModeSetOption.TYPE_EPS,529);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_SPORT,DriveModeSetOption.TYPE_POWER,258);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_SPORT,DriveModeSetOption.TYPE_TRACTION,289);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_SPORT,DriveModeSetOption.TYPE_PADDLE,513);
            if(this.mDriveModeSport.mPowerSetup == DriveModeSetOption.HPLOW && this.isHellcat())
            {
               this.setDriveModeOptionSupport(DriveModeSetOption.MODE_SPORT,DriveModeSetOption.TYPE_TRANS,274);
            }
            else
            {
               this.setDriveModeOptionSupport(DriveModeSetOption.MODE_SPORT,DriveModeSetOption.TYPE_TRANS,289);
            }
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_SPORT,DriveModeSetOption.TYPE_SUSP,289);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_SPORT,DriveModeSetOption.TYPE_EPS,289);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_CUSTOM,DriveModeSetOption.TYPE_POWER,258);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_CUSTOM,DriveModeSetOption.TYPE_TRACTION,546);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_CUSTOM,DriveModeSetOption.TYPE_PADDLE,514);
            if(this.mDriveModeCustome.mPowerSetup == DriveModeSetOption.HPLOW && this.isHellcat())
            {
               this.setDriveModeOptionSupport(DriveModeSetOption.MODE_CUSTOM,DriveModeSetOption.TYPE_TRANS,274);
            }
            else
            {
               this.setDriveModeOptionSupport(DriveModeSetOption.MODE_CUSTOM,DriveModeSetOption.TYPE_TRANS,546);
            }
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_CUSTOM,DriveModeSetOption.TYPE_SUSP,546);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_CUSTOM,DriveModeSetOption.TYPE_EPS,546);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_DEFAULT,DriveModeSetOption.TYPE_POWER,258);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_DEFAULT,DriveModeSetOption.TYPE_TRACTION,274);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_DEFAULT,DriveModeSetOption.TYPE_PADDLE,514);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_DEFAULT,DriveModeSetOption.TYPE_TRANS,274);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_DEFAULT,DriveModeSetOption.TYPE_SUSP,546);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_DEFAULT,DriveModeSetOption.TYPE_EPS,546);
            if(1 == this.mKeyMode)
            {
               this.setDriveModeOptionSupport(DriveModeSetOption.MODE_TRACK,DriveModeSetOption.TYPE_POWER,514);
               this.setDriveModeOptionSupport(DriveModeSetOption.MODE_SPORT,DriveModeSetOption.TYPE_POWER,514);
               this.setDriveModeOptionSupport(DriveModeSetOption.MODE_CUSTOM,DriveModeSetOption.TYPE_POWER,514);
               this.setDriveModeOptionSupport(DriveModeSetOption.MODE_DEFAULT,DriveModeSetOption.TYPE_POWER,514);
            }
            if(!this.isHellcat())
            {
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_POWER,false);
            }
            else
            {
               this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_EPS,false);
            }
         }
         else
         {
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_SPORT,DriveModeSetOption.TYPE_TRANS,514);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_SPORT,DriveModeSetOption.TYPE_TRACTION,514);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_SPORT,DriveModeSetOption.TYPE_PADDLE,514);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_SPORT,DriveModeSetOption.TYPE_EPS,546);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_DEFAULT,DriveModeSetOption.TYPE_TRANS,258);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_DEFAULT,DriveModeSetOption.TYPE_TRACTION,258);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_DEFAULT,DriveModeSetOption.TYPE_PADDLE,514);
            this.setDriveModeOptionSupport(DriveModeSetOption.MODE_DEFAULT,DriveModeSetOption.TYPE_EPS,546);
         }
         this.setDriveModeOptionEnable(DriveModeSetOption.TYPE_TRACTION,this.mEscMode);
      }
      
      private function set EcoStatus(aStatus:Boolean) : void
      {
         var status:String = null;
         this.mEcoStatus = aStatus;
         if(aStatus)
         {
            status = "enableECOMode";
         }
         else
         {
            status = "disableECOMode";
         }
         this.sendSetEcoCommand(status);
         dispatchEvent(new DriveModeEvent(DriveModeEvent.ECO));
      }
      
      private function disableEscHk() : void
      {
         this.mEnableEscHK = false;
      }
   }
}

