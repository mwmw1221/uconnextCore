package com.nfuzion.moduleLink
{
   import com.harman.moduleLink.VersionInfo;
   import com.harman.moduleLinkAPI.ProductVariantID;
   import com.harman.moduleLinkAPI.TunerSeek;
   import com.nfuzion.moduleLinkAPI.AnalogStationInfo;
   import com.nfuzion.moduleLinkAPI.ITuner;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.TunerBand;
   import com.nfuzion.moduleLinkAPI.TunerDiagACFInfo;
   import com.nfuzion.moduleLinkAPI.TunerDiagFieldStrength;
   import com.nfuzion.moduleLinkAPI.TunerDiagFuncInfo;
   import com.nfuzion.moduleLinkAPI.TunerDiagPartInfo;
   import com.nfuzion.moduleLinkAPI.TunerDiagRDS;
   import com.nfuzion.moduleLinkAPI.TunerDiagRSQInfo;
   import com.nfuzion.moduleLinkAPI.TunerEvent;
   import com.nfuzion.moduleLinkAPI.TunerRegion;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class Tuner extends Module implements ITuner
   {
      private static const dbusTunerSeekStatus:String = "seekStatus";
      
      private static const dbusTunerStationInfo:String = "stationInfo";
      
      private static const dBusTunerBand:String = "waveband";
      
      private static const dbusTunerBandCommand:String = "setWaveband";
      
      private static const dBusTunerSignalQuality:String = "rxQual";
      
      private static const dBusTunerStereo:String = "stereo";
      
      private static const dBusTunerProgramType:String = "pty";
      
      private static const dBusTmcStations:String = "tmcStations";
      
      private static const dbusTunerAdvisoryMessage:String = "advisoryMessage";
      
      private static const dBusTunerSeek:String = "seekType";
      
      private static const dBusTunerSeekPressCommand:String = "seekPress";
      
      private static const dBusTunerSeekReleaseCommand:String = "seekRelease";
      
      private static const dBusTunerSeekInterruptCommand:String = "seekInterrupt";
      
      private static const dBusRegionCode:String = "regionCode";
      
      private static const dBusTunerSenderName:String = "senderName";
      
      private static const dBusTunerStationText:String = "radioText";
      
      private static const dBusTunerSwitches:String = "switches";
      
      private static const dBusTunerFrequency:String = "frequency";
      
      private static const dBusTunerFrequencyCommand:String = "setFrequency";
      
      private static const dBusTunerDiagGetRdsDataCommand:String = "getDiagRdsData";
      
      private static const dBusTunerDiagGetRSQDataCommand:String = "getRsqStatusInfo";
      
      private static const dBusTunerDiagGetACFDataCommand:String = "getAcfStatusInfo";
      
      private static const dBusTunerDiagFrequencyCommand:String = "setDiagFrequency";
      
      private static const dBusTunerDiagGetDiagFieldStrengthCommand:String = "getDiagFieldstrength";
      
      private static const dBusTunerSetDiagSwitchCommand:String = "setDiagSwitch";
      
      private static const dbusGetAllProperties:String = "getAllProperties";
      
      private static const dbusGetProperties:String = "getProperties";
      
      private static const dbusSetProperties:String = "setProperties";
      
      private static const dBusFreqInfoTbl:String = "freqInfoTbl";
      
      private static const dbusIdentifier:String = "Tuner";
      
      private static const FAST_SEEK_MULTIPLIER:int = 5;
      
      private static const FAST_SEEK_DELAY:uint = 200;
      
      private static const PRESET_POSITION_NONE:int = -1;
      
      public static const mStationNameField:String = "senderName";
      
      public static const mStationGenreField:String = "pty";
      
      private static const mDestinationCountryUS:String = "2";
      
      private var localRegion:String = "unknown";
      
      private var mMarket:String = "North America";
      
      private var mSupportRDS:Boolean = false;
      
      private var localSeek:String;
      
      private var localStationStereo:Boolean = false;
      
      private var localAfFreqencyStatus:Boolean = false;
      
      private var localRegionalStatus:Boolean = false;
      
      private var localTPStatus:Boolean = false;
      
      private var localStationText:String = "";
      
      private var localAvailableStations:Vector.<Object> = new Vector.<Object>();
      
      private var mStationlistSortType:String = "";
      
      private var mInfoSubscriptions:uint = 0;
      
      private var mTPNotify:Boolean = false;
      
      private var mAdvisoryMessageType:String = "none";
      
      private var localTmcStations:Array = new Array();
      
      private var connection:Connection;
      
      private var mTunerServiceAvailable:Boolean = false;
      
      private var mTunerDiagRDS:Object = new TunerDiagRDS();
      
      private var mTunerDiagRSQInfo:Object = new TunerDiagRSQInfo();
      
      private var mTunerDiagACFInfo:Object = new TunerDiagACFInfo();
      
      private var mTunerDiagFieldStrength:Object = new TunerDiagFieldStrength();
      
      private var mTunerDiagPartInfo:Object = new TunerDiagPartInfo();
      
      private var mTunerDiagFuncInfo:Object = new TunerDiagFuncInfo();
      
      private var mTunerPresetPositionSynced:Boolean = false;
      
      private var mTunerPresetPosition:Object = {
         "AM": PRESET_POSITION_NONE,
         "MW": PRESET_POSITION_NONE,
         "FM": PRESET_POSITION_NONE
      };
      
      private var mTunerRTPlusText:Object = {
         "Artist":"",
         "Title":"",
         "active":false
      };
      
      private var mAnalogStatInfo:Object = new AnalogStationInfo();
      
      private var mTunerBandLimits:Object = new Object();
      
      protected var client:Client;
      
      public function Tuner()
      {
         super();
         this.connection = Connection.share();
         this.localSeek = TunerSeek.sSTOP;
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.TUNER,this.tunerMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function get stationNameField() : String
      {
         return mStationNameField;
      }
      
      public function get stationGenreField() : String
      {
         return mStationGenreField;
      }
      
      public function setRegion(region:String) : void
      {
         this.localRegion = region;
         this.dispatchEvent(new TunerEvent(TunerEvent.REGION));
      }
      
      public function get isHdAvailable() : Boolean
      {
         var productVariantInfo:ProductVariantID = VersionInfo.getInstance().productVariantID;
         var available:Boolean = false;
         var vehDest:String = VehConfig.getInstance().vehicleDestination;
         if(productVariantInfo != null && productVariantInfo.VARIANT_MODEL == "VP4" && productVariantInfo.VARIANT_MARKET == "NA" && vehDest == mDestinationCountryUS)
         {
            available = true;
         }
         return available;
      }
      
      public function setMarket(market:String) : void
      {
         this.mMarket = market;
         this.mSupportRDS = this.mMarket != TunerRegion.CHINA && this.mMarket != TunerRegion.KOREA;
      }
      
      public function getRegion() : void
      {
         this.getValue(dBusRegionCode);
      }
      
      public function get region() : String
      {
         return this.localRegion;
      }
      
      public function getBand() : void
      {
         this.getValue(dBusTunerBand);
      }
      
      public function get band() : String
      {
         return this.mAnalogStatInfo.waveband;
      }
      
      public function get available() : Boolean
      {
         return this.mTunerServiceAvailable;
      }
      
      public function setFrequency(frequency:uint) : void
      {
         this.sendFrequency(dBusTunerFrequencyCommand,dBusTunerFrequency,frequency);
      }
      
      public function setPIFreq(frequency:uint, pi:uint) : void
      {
         this.sendFrequency_subChannel(dBusTunerFrequencyCommand,dBusTunerFrequency,frequency,"pi",pi);
      }
      
      public function requestStationInfo() : void
      {
         this.getValue(dbusTunerStationInfo);
      }
      
      public function get frequency() : uint
      {
         return this.mAnalogStatInfo.frequency;
      }
      
      public function get frequencyMin() : Number
      {
         return this.mTunerBandLimits[this.mAnalogStatInfo.waveband].min;
      }
      
      public function get frequencyMax() : Number
      {
         return this.mTunerBandLimits[this.mAnalogStatInfo.waveband].max;
      }
      
      public function get frequencyStepSize() : Number
      {
         return this.mTunerBandLimits[this.mAnalogStatInfo.waveband].step;
      }
      
      public function setSeekPress(seek:String = "") : void
      {
         this.sendCommand(dBusTunerSeekPressCommand,dBusTunerSeek,seek);
      }
      
      public function setSeekRelease() : void
      {
         this.sendCommand(dBusTunerSeekReleaseCommand,"","");
      }
      
      public function get seek() : String
      {
         return this.localSeek;
      }
      
      public function get stationQuality() : uint
      {
         return this.mAnalogStatInfo.rxQual;
      }
      
      public function getStationStereo() : void
      {
         this.getValue(dBusTunerStereo);
      }
      
      public function get stationStereo() : Boolean
      {
         return this.localStationStereo;
      }
      
      public function get stationName() : String
      {
         return this.mAnalogStatInfo.senderName;
      }
      
      public function get stationProgramType() : String
      {
         return this.mAnalogStatInfo.pty;
      }
      
      public function getStationText() : void
      {
         this.localStationText = "";
         this.getValue(dBusTunerStationText);
      }
      
      public function get stationText() : String
      {
         return this.localStationText;
      }
      
      public function get availableStations() : Vector.<Object>
      {
         return this.localAvailableStations;
      }
      
      public function tunerSeekInteruptHdlr(seekType:String) : Boolean
      {
         var rtnVal:Boolean = false;
         if(Boolean(seekType) && this.localSeek != TunerSeek.sSTOP)
         {
            if(seekType == TunerSeek.sSTOP || seekType == TunerSeek.sSTOP_ON_STATION)
            {
               this.sendCommand(dBusTunerSeekInterruptCommand,dBusTunerSeek,seekType);
               rtnVal = true;
            }
         }
         return rtnVal;
      }
      
      public function requestAfFreqencyStatus() : void
      {
         this.getValue("afEnabled");
      }
      
      public function setAfFreqencyStatus(status:Boolean) : void
      {
         if(status != this.localAfFreqencyStatus)
         {
            this.sendBooleanProps("setProperties","afEnabled",status);
            this.requestAfFreqencyStatus();
         }
      }
      
      public function requestRegionalizationStatus() : void
      {
         this.getValue("regEnabled");
      }
      
      public function setRegionalizationStatus(status:Boolean) : void
      {
         if(status != this.localRegionalStatus)
         {
            this.sendBooleanProps("setProperties","regEnabled",status);
            this.requestRegionalizationStatus();
         }
      }
      
      public function requestTPStatus() : void
      {
         this.getValue("tpEnabled");
      }
      
      public function setTPStatus(status:Boolean) : void
      {
         this.sendBooleanProps("setProperties","tpEnabled",status);
         this.requestTPStatus();
      }
      
      public function get afStatus() : Boolean
      {
         return this.localAfFreqencyStatus;
      }
      
      public function get regStatus() : Boolean
      {
         return this.localRegionalStatus;
      }
      
      public function get tpStatus() : Boolean
      {
         return this.localTPStatus;
      }
      
      public function requestTAEscape() : void
      {
         this.sendCommand("taEscape","","");
      }
      
      public function requestPTY31Escape() : void
      {
         this.sendCommand("pty31Escape","","");
      }
      
      public function get stationListSortType() : String
      {
         return this.mStationlistSortType;
      }
      
      public function set stationListSortType(listSortType:String) : void
      {
         this.mStationlistSortType = listSortType;
      }
      
      public function set afEnabled(value:Boolean) : void
      {
         this.localAfFreqencyStatus = value;
         this.dispatchEvent(new TunerEvent(TunerEvent.AF_MODE));
      }
      
      public function set tpEnabled(value:Boolean) : void
      {
         this.localTPStatus = value;
         this.dispatchEvent(new TunerEvent(TunerEvent.TA_MODE));
      }
      
      public function set regEnabled(value:Boolean) : void
      {
         this.localRegionalStatus = value;
         this.dispatchEvent(new TunerEvent(TunerEvent.REG_MODE));
      }
      
      public function set stereo(value:Boolean) : void
      {
         this.localStationStereo = value;
         this.dispatchEvent(new TunerEvent(TunerEvent.STATION_STEREO));
      }
      
      public function set presetPositions(posTable:Object) : void
      {
         this.mTunerPresetPositionSynced = true;
         this.mTunerPresetPosition[TunerBand.MW] = posTable["am"];
         this.mTunerPresetPosition[TunerBand.AM] = posTable["am"];
         this.mTunerPresetPosition[TunerBand.FM] = posTable["fm"];
      }
      
      private function set freqInfoTbl(freqTable:Object) : void
      {
         this.mTunerBandLimits = freqTable;
      }
      
      public function requestSetDiagModeOn() : void
      {
         this.sendCommand(dBusTunerSetDiagSwitchCommand,"state","ON");
      }
      
      public function requestSetDiagModeOff() : void
      {
         this.sendCommand(dBusTunerSetDiagSwitchCommand,"state","OFF");
      }
      
      public function requestSetDiagFrequency() : void
      {
         var message:* = null;
         var commandName:String = dBusTunerDiagFrequencyCommand;
         var valueName:String = "tuner";
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + "\"DIAG_TUNER3\"" + "," + "\"freq\"" + ":" + this.frequency + "}}}";
         this.client.send(message);
      }
      
      public function requestRDSData() : void
      {
         this.sendCommand(dBusTunerDiagGetRdsDataCommand,"tuner","DIAG_TUNER_ALL");
      }
      
      public function requestRSQData() : void
      {
         this.sendCommand(dBusTunerDiagGetRSQDataCommand,"tuner","DIAG_TUNER_ALL");
      }
      
      public function requestACFData() : void
      {
         this.sendCommand(dBusTunerDiagGetACFDataCommand,"tuner","DIAG_TUNER_ALL");
      }
      
      public function get tunerDiagRDSInfo() : Object
      {
         return this.mTunerDiagRDS;
      }
      
      public function get tunerDiagRSQInfo() : Object
      {
         return this.mTunerDiagRSQInfo;
      }
      
      public function get tunerDiagACFInfo() : Object
      {
         return this.mTunerDiagACFInfo;
      }
      
      public function requestDiagFieldStrength() : void
      {
         this.sendCommand(dBusTunerDiagGetDiagFieldStrengthCommand,"tuner","DIAG_TUNER_ALL");
      }
      
      public function get supportRDS() : Boolean
      {
         return this.mSupportRDS;
      }
      
      public function get tunerDiagFieldStrengthInfo() : Object
      {
         return this.mTunerDiagFieldStrength;
      }
      
      public function requestDiagPartInfo() : void
      {
         this.sendCommand("getDiag6xPartInfo","","");
      }
      
      public function get tunerDiagPartInfo() : Object
      {
         return this.mTunerDiagPartInfo;
      }
      
      public function requestDiagFuncInfo() : void
      {
         this.sendCommand("getDiagFuncInfo","","");
      }
      
      public function get tunerDiagFuncInfo() : Object
      {
         return this.mTunerDiagFuncInfo;
      }
      
      public function requestTrafficAnnouncementStatus() : void
      {
         this.getValue("trafficAnnouncement");
      }
      
      public function requestTmcStations() : void
      {
         this.dispatchEvent(new TunerEvent(TunerEvent.TMC_STATIONS));
      }
      
      public function get tmcStations() : Array
      {
         return this.localTmcStations;
      }
      
      public function bandPresetPosition(wb:String) : int
      {
         var pos:int = PRESET_POSITION_NONE;
         switch(wb)
         {
            case TunerBand.AM:
            case TunerBand.MW:
            case TunerBand.FM:
               pos = int(this.mTunerPresetPosition[wb]);
         }
         return pos;
      }
      
      public function get pi() : int
      {
         return this.mAnalogStatInfo.pi;
      }
      
      public function requestPresetPosition() : void
      {
         this.sendCommand("requestPresetPosition","","");
      }
      
      private function requestAllPresetPositions() : void
      {
         this.getValue("presetPositions");
      }
      
      public function requestRecallPreset(pos:int) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":dbusIdentifier,
            "packet":{"requestRecallPreset":{"Position":pos}}
         };
         this.connection.send(message);
      }
      
      public function requestStorePreset(pos:int) : void
      {
         this.mTunerPresetPosition[this.mAnalogStatInfo.waveband] = pos;
         var message:Object = {
            "Type":"Command",
            "Dest":dbusIdentifier,
            "packet":{"requestStorePreset":{"Position":pos}}
         };
         this.connection.send(message);
      }
      
      public function requestClearPreset(pos:int) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":dbusIdentifier,
            "packet":{"requestClearPreset":{"Position":pos}}
         };
         this.connection.send(message);
      }
      
      public function get radioTextPlus() : Object
      {
         return this.mTunerRTPlusText;
      }
      
      public function requestTunerConfVersion(action:String) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":dbusIdentifier,
            "packet":{"tunerJSONFileHandler":{"action":action}}
         };
         this.connection.send(message);
      }
      
      public function get advisoryMessageType() : String
      {
         return this.mAdvisoryMessageType;
      }
      
      public function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendSubscribe("region");
            this.sendSubscribe(dBusTunerBand);
            this.sendSubscribe(dbusTunerStationInfo);
            this.sendSubscribe(dBusTunerStationText);
            this.sendSubscribe(dbusTunerSeekStatus);
            this.sendSubscribe(dBusTunerStereo);
            this.sendSubscribe("dtStationsFreq");
            this.sendSubscribe("trafficAnnouncement");
            this.sendSubscribe("hdStatusInfo");
            this.sendSubscribe("hdStationInfo");
            this.sendSubscribe("hdBERErrorRate");
            this.sendSubscribe("hdTune");
            this.sendSubscribe("hdPerformance");
            this.sendSubscribe("diag6xPartInfo");
            this.sendSubscribe("diagFuncInfo");
            this.sendSubscribe(dBusTmcStations);
            this.sendSubscribe("presetUpdate");
            this.sendSubscribe("currentHdProgram");
            this.sendSubscribe("radioTextPlus");
            this.sendSubscribe("tunerJSONFileHandler");
            this.sendSubscribe("rsqStatusInfo");
            this.sendSubscribe("acfStatusInfo");
            this.sendSubscribe("advisoryMessage");
            this.sendSubscribe("presetPositions");
            this.sendSubscribe("freqInfoTbl");
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      protected function getValue(valueName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"" + valueName + "\"]}}}";
         this.client.send(message);
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
      
      private function sendBooleanProps(commandName:String, valueName:String, value:Boolean) : void
      {
         var message:* = null;
         if(value)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"props\": {\"" + valueName + "\":true}}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"props\": { \"" + valueName + "\":false}}}}";
         }
         this.client.send(message);
      }
      
      protected function sendFrequency(commandName:String, valueName:String, value:Number) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
         this.client.send(message);
      }
      
      protected function sendFrequency_subChannel(commandName:String, valueName:String, value:Number, valueName2:String, value2:Number) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\":" + value + ",\"" + valueName2 + "\":" + value2 + "}} }";
         this.client.send(message);
      }
      
      public function setTuneKnobEnabled(enabled:Boolean) : void
      {
         var commandName:String = "setTuneKnobEnabled";
         var valueName:String = "tuneKnobEnabled";
         var message:* = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + enabled + "}}}";
         this.client.send(message);
      }
      
      public function getItemFromStationList(requestedFreq:int, item:String) : String
      {
         var station:Object = null;
         var station2:Object = null;
         if(item == mStationGenreField)
         {
            for each(station in this.localAvailableStations)
            {
               if(station.freq == requestedFreq)
               {
                  return station.pty;
               }
            }
         }
         else if(item == mStationNameField)
         {
            for each(station2 in this.localAvailableStations)
            {
               if(station2.freq == requestedFreq)
               {
                  return station2.senderName;
               }
            }
         }
         return "";
      }
      
      protected function sendSubscribe(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         if(dbusTunerStationInfo == signalName)
         {
            if(0 == this.mInfoSubscriptions)
            {
               ++this.mInfoSubscriptions;
               this.client.send(message);
            }
         }
         else
         {
            this.client.send(message);
         }
      }
      
      protected function sendUnsubscribe(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         if(dbusTunerStationInfo == signalName)
         {
            if(this.mInfoSubscriptions > 0)
            {
               --this.mInfoSubscriptions;
               if(0 == this.mInfoSubscriptions)
               {
                  this.client.send(message);
               }
            }
         }
         else
         {
            this.client.send(message);
         }
      }
      
      public function tunerMessageHandler(e:ConnectionEvent) : void
      {
         var listSize:int = 0;
         var i:int = 0;
         var property:String = null;
         var action:String = null;
         var version:String = null;
         var tuner:Object = e.data;
         if(tuner.hasOwnProperty("dBusServiceAvailable"))
         {
            if(tuner.dBusServiceAvailable == "true" && this.mTunerServiceAvailable == false)
            {
               this.mTunerServiceAvailable = true;
               this.getValue(dBusFreqInfoTbl);
               this.getValue(dBusTunerBand);
               this.getValue(dBusTmcStations);
               this.requestPresetPosition();
               this.requestAllPresetPositions();
               this.requestStationInfo();
               this.requestAfFreqencyStatus();
               this.requestTPStatus();
               this.requestRegionalizationStatus();
               this.dispatchEvent(new TunerEvent(TunerEvent.AVAILABLE));
            }
            else if(tuner.dBusServiceAvailable == "false")
            {
               this.mTunerServiceAvailable = false;
            }
         }
         if(Boolean(tuner.hasOwnProperty(dBusTunerStereo)) && Boolean(tuner.stereo.hasOwnProperty(dBusTunerStereo)))
         {
            this.localStationStereo = tuner.stereo.stereo;
            this.dispatchEvent(new TunerEvent(TunerEvent.STATION_STEREO));
         }
         if(tuner.hasOwnProperty(dbusTunerStationInfo))
         {
            if(tuner.stationInfo.hasOwnProperty("value"))
            {
               tuner.stationInfo = tuner.stationInfo.value;
            }
            if(this.mAnalogStatInfo.waveband != tuner.stationInfo.waveband || this.mAnalogStatInfo.frequency != tuner.stationInfo.frequency)
            {
               this.localStationText = "";
            }
            this.mAnalogStatInfo.updateAnalalogStationInfo(tuner.stationInfo);
            this.dispatchEvent(new TunerEvent(TunerEvent.STATION_INFO,this.mAnalogStatInfo));
            if(this.mTunerPresetPositionSynced == false)
            {
               this.requestAllPresetPositions();
            }
            if(this.mTPNotify != this.mAnalogStatInfo.isTP)
            {
               this.mTPNotify = this.mAnalogStatInfo.isTP;
               dispatchEvent(new TunerEvent(TunerEvent.TP_NOTIFY,this.mTPNotify));
            }
         }
         if(tuner.hasOwnProperty("regEnabled"))
         {
            if(this.localRegionalStatus != tuner.regEnabled)
            {
               this.localRegionalStatus = tuner.regEnabled;
            }
            this.dispatchEvent(new TunerEvent(TunerEvent.REG_MODE));
         }
         if(tuner.hasOwnProperty("afEnabled"))
         {
            if(this.localAfFreqencyStatus != tuner.afEnabled)
            {
               this.localAfFreqencyStatus = tuner.afEnabled;
            }
            this.dispatchEvent(new TunerEvent(TunerEvent.AF_MODE));
         }
         if(tuner.hasOwnProperty("tpEnabled"))
         {
            if(this.localTPStatus != tuner.tpEnabled)
            {
               this.localTPStatus = tuner.tpEnabled;
            }
            this.dispatchEvent(new TunerEvent(TunerEvent.TA_MODE));
         }
         if(tuner.hasOwnProperty(dbusTunerSeekStatus))
         {
            if(tuner.seekStatus.hasOwnProperty(dBusTunerSeek))
            {
               switch(tuner.seekStatus.seekType)
               {
                  case "SEEK_UP_PTY_AUTO":
                     this.localSeek = TunerSeek.sAUTO_UP;
                     break;
                  case "SEEK_DN_PTY_AUTO":
                     this.localSeek = TunerSeek.sAUTO_DOWN;
                     break;
                  default:
                     this.localSeek = tuner.seekStatus.seekType;
               }
               this.dispatchEvent(new TunerEvent(TunerEvent.SEEK));
            }
         }
         if(tuner.hasOwnProperty("dtStationsFreq"))
         {
            this.localAvailableStations = new Vector.<Object>();
            listSize = int(tuner.dtStationsFreq.listSize);
            for(i = 0; i < listSize; i++)
            {
               this.localAvailableStations.push({
                  "senderName":tuner.dtStationsFreq.stations[i].senderName,
                  "pty":tuner.dtStationsFreq.stations[i].pty,
                  "freq":tuner.dtStationsFreq.stations[i].freq,
                  "pi":tuner.dtStationsFreq.stations[i].pi
               });
            }
            this.dispatchEvent(new TunerEvent(TunerEvent.AVAILABLE_STATIONS));
         }
         if(tuner.hasOwnProperty("getProperties"))
         {
            if(tuner.getProperties.hasOwnProperty(dbusTunerSeekStatus))
            {
               switch(tuner.getProperties.seekStatus.seekType)
               {
                  case "SEEK_UP_PTY_AUTO":
                     this.localSeek = TunerSeek.sAUTO_UP;
                     break;
                  case "SEEK_DN_PTY_AUTO":
                     this.localSeek = TunerSeek.sAUTO_DOWN;
                     break;
                  default:
                     this.localSeek = tuner.getProperties.seekStatus.seekType;
               }
               this.dispatchEvent(new TunerEvent(TunerEvent.SEEK));
            }
            if(tuner.getProperties.hasOwnProperty(dBusRegionCode))
            {
               switch(tuner.getProperties.regionCode)
               {
                  case 0:
                     this.localRegion = TunerRegion.EUROPE;
                     break;
                  case 7:
                     this.localRegion = TunerRegion.ROW;
                     break;
                  case 1:
                     this.localRegion = TunerRegion.NORTH_AMERICA;
                     break;
                  default:
                     this.localRegion = TunerRegion.UNKNOWN;
               }
               this.dispatchEvent(new TunerEvent(TunerEvent.REGION));
            }
            if(tuner.getProperties.hasOwnProperty(dbusTunerStationInfo))
            {
               this.mAnalogStatInfo.updateAnalalogStationInfo(tuner.getProperties.stationInfo);
               this.dispatchEvent(new TunerEvent(TunerEvent.STATION_INFO,this.mAnalogStatInfo));
            }
            else
            {
               try
               {
                  for(property in tuner.getProperties)
                  {
                     this[property] = tuner.getProperties[property];
                  }
               }
               catch(e:Error)
               {
               }
            }
         }
         if(tuner.hasOwnProperty(dBusTunerStationText))
         {
            if(tuner.radioText.hasOwnProperty("radiotext"))
            {
               this.localStationText = tuner.radioText.radiotext;
               if(this.localStationText.length > 64)
               {
                  this.localStationText = this.localStationText.substring(0,64);
               }
               this.dispatchEvent(new TunerEvent(TunerEvent.STATION_TEXT,{"radioText":this.localStationText}));
            }
         }
         if(tuner.hasOwnProperty(dbusTunerAdvisoryMessage))
         {
            this.mAdvisoryMessageType = tuner.advisoryMessage.value;
            this.dispatchEvent(new TunerEvent(TunerEvent.ADVISORY_MSG_ANNOUNCEMENT,e.data));
         }
         if(tuner.hasOwnProperty("getDiagRdsData"))
         {
            this.mTunerDiagRDS = this.mTunerDiagRDS.copyTunerDiagRDS(tuner.getDiagRdsData);
            this.dispatchEvent(new TunerEvent(TunerEvent.RDS_DIAG_DATA));
         }
         if(tuner.hasOwnProperty("rsqStatusInfo"))
         {
            this.mTunerDiagRSQInfo = this.mTunerDiagRSQInfo.copyTunerDiagRSQInfo(tuner.rsqStatusInfo.value);
            this.dispatchEvent(new TunerEvent(TunerEvent.RSQ_DIAG_DATA));
         }
         if(tuner.hasOwnProperty("acfStatusInfo"))
         {
            this.mTunerDiagACFInfo = this.mTunerDiagACFInfo.copyTunerDiagACFInfo(tuner.acfStatusInfo.value);
            this.dispatchEvent(new TunerEvent(TunerEvent.ACF_DIAG_DATA));
         }
         if(tuner.hasOwnProperty("getDiagFieldstrength"))
         {
            this.mTunerDiagFieldStrength = this.mTunerDiagFieldStrength.copyTunerDiagFieldStrength(tuner.getDiagFieldstrength);
            this.dispatchEvent(new TunerEvent(TunerEvent.DIAG_FIELD_STRENGTH_DATA));
         }
         if(tuner.hasOwnProperty("diag6xPartInfo"))
         {
            this.mTunerDiagPartInfo = this.mTunerDiagPartInfo.copyTunerDiagPartInfo(tuner.diag6xPartInfo.value);
            this.dispatchEvent(new TunerEvent(TunerEvent.PARTINFO_DATA));
         }
         if(tuner.hasOwnProperty("diagFuncInfo"))
         {
            this.mTunerDiagFuncInfo = this.mTunerDiagFuncInfo.copyTunerDiagFuncInfo(tuner.diagFuncInfo.value);
            this.dispatchEvent(new TunerEvent(TunerEvent.FUNCINFO_DATA));
         }
         if(tuner.hasOwnProperty(dBusTmcStations))
         {
            if(tuner.tmcStations.listSize > 0)
            {
               this.localTmcStations = tuner.tmcStations.stations;
            }
            else
            {
               this.localTmcStations.splice(this.localTmcStations.length);
            }
            this.dispatchEvent(new TunerEvent(TunerEvent.TMC_STATIONS));
         }
         if(tuner.hasOwnProperty("presetUpdate"))
         {
            if(tuner.presetUpdate.presetId != this.mTunerPresetPosition[tuner.presetUpdate.wb] && this.mAnalogStatInfo.waveband != TunerBand.UNKNOWN)
            {
               this.mTunerPresetPosition[this.mAnalogStatInfo.waveband] = tuner.presetUpdate.presetId;
               this.mTunerPresetPosition[this.mAnalogStatInfo.waveband] = this.mTunerPresetPosition[this.mAnalogStatInfo.waveband] == 255 ? PRESET_POSITION_NONE : this.mTunerPresetPosition[this.mAnalogStatInfo.waveband];
               this.dispatchEvent(new TunerEvent(TunerEvent.PRESET_UPDATE));
            }
         }
         if(tuner.hasOwnProperty("radioTextPlus"))
         {
            this.mTunerRTPlusText.Artist = tuner.radioTextPlus.Artist;
            this.mTunerRTPlusText.Title = tuner.radioTextPlus.Title;
            if(this.mTunerRTPlusText.Artist != "" && this.mTunerRTPlusText.Title != "")
            {
               this.mTunerRTPlusText.active = true;
            }
            else
            {
               this.mTunerRTPlusText.active = false;
            }
            this.dispatchEvent(new TunerEvent(TunerEvent.RT_PLUS_TEXT,this.mTunerRTPlusText));
         }
         if(tuner.hasOwnProperty("tunerJSONFileHandler"))
         {
            action = tuner.tunerJSONFileHandler.tunerJSONFileHandler.action;
            version = tuner.tunerJSONFileHandler.tunerJSONFileHandler.version;
            this.dispatchEvent(new TunerEvent(TunerEvent.CONF_FILE_VERSION,{
               "action":action,
               "version":version
            }));
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:* = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      public function get presetPositionNone() : int
      {
         return PRESET_POSITION_NONE;
      }
      
      public function translateAudioManagerBandToTunerBand(audioManagerBand:String) : String
      {
         var tunerBand:String = "";
         switch(audioManagerBand)
         {
            case AudioManager.sSOURCE_AM:
               tunerBand = TunerBand.AM;
               break;
            case AudioManager.sSOURCE_FM:
               tunerBand = TunerBand.FM;
               break;
            case AudioManager.sSOURCE_MW:
               tunerBand = TunerBand.MW;
         }
         return tunerBand;
      }
      
      public function translateTunerBandToAudioManagerBand(tunerBand:String) : String
      {
         var audioManagerBand:String = "";
         switch(tunerBand)
         {
            case TunerBand.AM:
               audioManagerBand = AudioManager.sSOURCE_AM;
               break;
            case TunerBand.FM:
               audioManagerBand = AudioManager.sSOURCE_FM;
               break;
            case TunerBand.MW:
               audioManagerBand = AudioManager.sSOURCE_MW;
         }
         return audioManagerBand;
      }
   }
}

