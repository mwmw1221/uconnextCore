package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.IVehSettings;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.VehSettingsEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class VehSettings extends Module implements IVehSettings
   {
      private static var instance:VehSettings;
      
      private static const IS_TEST:Boolean = false;
      
      public static const ZONE_ALL:String = "all";
      
      public static const ZONE_FRONT_RIGHT:String = "frontRight";
      
      public static const ZONE_FRONT_LEFT:String = "frontLeft";
      
      public static const ZONE_REAR_RIGHT:String = "rearRight";
      
      public static const ZONE_REAR_LEFT:String = "rearLeft";
      
      private static const dbusIdentifier:String = "VehSetting";
      
      private static const dBusReadyFlag:String = "ready";
      
      private static const dBusComfortFeaturesDisabled:String = "comfortFeaturesDisabled";
      
      private static const dBusHeatSeatFrontLeft:String = "heatSeatFrontLeft";
      
      private static const dBusHeatSeatFrontRight:String = "heatSeatFrontRight";
      
      private static const dBusVentSeatFrontLeft:String = "ventSeatFrontLeft";
      
      private static const dBusVentSeatFrontRight:String = "ventSeatFrontRight";
      
      private static const dBusHeatWheel:String = "heatWheel";
      
      private static const dBusDriveStyleStatus:String = "driveStyleStatus";
      
      private static const dBusSunShade:String = "sunShade";
      
      private static const dBusPowerOutlet:String = "powerOutlet";
      
      private static const dBusScreenEnable:String = "screenEnable";
      
      private static const dBusAwdMode:String = "awdMode";
      
      private static const dBusEcoMode:String = "ecoMode";
      
      private static const dBusHeadrestDump:String = "headrestDump";
      
      private static const dBusMirrorDimming:String = "EC_MirrStat";
      
      private static const dBusCargoCamera:String = "cargoCamera";
      
      private static const dBusApiGetAllProperties:String = "getAllProperties";
      
      private static const dBusApiGetProperties:String = "getProperties";
      
      private static const dBusApiSetProperties:String = "setProperties";
      
      private var mcntrlFeaturesDisabled:Boolean = true;
      
      private var mVehServiceReady:Boolean = false;
      
      private var mHeatedSeatFrontRight:String = "off";
      
      private var mHeatedSeatFrontLeft:String = "off";
      
      private var mHeatedSeatsPresent:Boolean = false;
      
      private var mVentedSeatFrontRight:String = "off";
      
      private var mVentedSeatFrontLeft:String = "off";
      
      private var mVentedSeatsPresent:Boolean = false;
      
      private var mHeatedSteeringWheel:String = "off";
      
      private var mHeatedWheelPresent:Boolean = false;
      
      private var mSunShadePosition:String = "up";
      
      private var mSunShadePresent:Boolean = false;
      
      private var mSportsMode:String = "off";
      
      private var mSportsModePresent:Boolean = false;
      
      private var mOutletState:String = "off";
      
      private var mOutletPresent:Boolean = false;
      
      private var mScreenEnable:Boolean = true;
      
      private var mAwdMode:String = "2wd";
      
      private var mAwdModePresent:Boolean = false;
      
      private var mEcoMode:String = "off";
      
      private var mEcoModePresent:Boolean = false;
      
      private var mHeadrestDump:String = "off";
      
      private var mMirrorDimming:String = "off";
      
      private var mCargoCameraPresent:Boolean = false;
      
      private var mCargoCamera:String = "disabled";
      
      private var mDNAStatus:String = "invalid";
      
      private var mFLHeatedSeatPendingState:String;
      
      private var mFRHeatedSeatPendingState:String;
      
      private var mFLVentedSeatPendingState:String;
      
      private var mFRVentedSeatPendingState:String;
      
      private var mHeatedWheelPendingState:String;
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mVehSettingsServiceAvailable:Boolean = false;
      
      public function VehSettings()
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
         this.connection.addEventListener(ConnectionEvent.VEHICLE_SETTINGS,this.vehicleSettingsMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : VehSettings
      {
         if(instance == null)
         {
            instance = new VehSettings();
         }
         return instance;
      }
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case VehSettingsEvent.AVAILABLE:
               break;
            case VehSettingsEvent.HEATED_SEAT:
               this.sendSubscribe(dBusHeatSeatFrontLeft);
               this.sendSubscribe(dBusHeatSeatFrontRight);
               break;
            case VehSettingsEvent.VENTED_SEAT:
               this.sendSubscribe(dBusVentSeatFrontLeft);
               this.sendSubscribe(dBusVentSeatFrontRight);
               break;
            case VehSettingsEvent.HEATED_STEERING_WHEEL:
               this.sendSubscribe(dBusHeatWheel);
               break;
            case VehSettingsEvent.SPORTS_MODE:
            case VehSettingsEvent.DNA_STATUS:
               this.sendSubscribe(dBusDriveStyleStatus);
               break;
            case VehSettingsEvent.SUN_SHADE_POSITION:
               this.sendSubscribe(dBusSunShade);
               break;
            case VehSettingsEvent.OUTLET_STATE:
               this.sendSubscribe(dBusPowerOutlet);
               break;
            case VehSettingsEvent.AWD_MODE:
               this.sendSubscribe(dBusAwdMode);
               break;
            case VehSettingsEvent.ECO_MODE:
               this.sendSubscribe(dBusEcoMode);
               break;
            case VehSettingsEvent.MIRROR_DIMMING:
               this.sendSubscribe(dBusMirrorDimming);
               break;
            case VehSettingsEvent.CARGO_CAMERA:
               this.sendSubscribe(dBusCargoCamera);
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case VehSettingsEvent.AVAILABLE:
               break;
            case VehSettingsEvent.HEATED_SEAT:
               this.sendUnsubscribe(dBusHeatSeatFrontLeft);
               this.sendUnsubscribe(dBusHeatSeatFrontRight);
               break;
            case VehSettingsEvent.VENTED_SEAT:
               this.sendUnsubscribe(dBusVentSeatFrontLeft);
               this.sendUnsubscribe(dBusVentSeatFrontRight);
               break;
            case VehSettingsEvent.HEATED_STEERING_WHEEL:
               this.sendUnsubscribe(dBusHeatWheel);
               break;
            case VehSettingsEvent.SPORTS_MODE:
            case VehSettingsEvent.DNA_STATUS:
               this.sendUnsubscribe(dBusDriveStyleStatus);
               break;
            case VehSettingsEvent.SUN_SHADE_POSITION:
               this.sendUnsubscribe(dBusSunShade);
               break;
            case VehSettingsEvent.OUTLET_STATE:
               this.sendUnsubscribe(dBusPowerOutlet);
               break;
            case VehSettingsEvent.AWD_MODE:
               this.sendUnsubscribe(dBusAwdMode);
               break;
            case VehSettingsEvent.ECO_MODE:
               this.sendUnsubscribe(dBusEcoMode);
               break;
            case VehSettingsEvent.MIRROR_DIMMING:
               this.sendUnsubscribe(dBusMirrorDimming);
               break;
            case VehSettingsEvent.CARGO_CAMERA:
               this.sendUnsubscribe(dBusCargoCamera);
         }
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override public function getAll() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
      }
      
      public function get controlFeaturesDisabled() : Boolean
      {
         return this.mcntrlFeaturesDisabled;
      }
      
      public function getHeatedSeat() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\": [ \"" + dBusHeatSeatFrontLeft + "\", \"" + dBusHeatSeatFrontLeft + "\"]}}}");
         this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.HEATED_SEAT));
      }
      
      public function heatedSeat(zone:String) : String
      {
         switch(zone)
         {
            case ZONE_FRONT_RIGHT:
               return this.mHeatedSeatFrontRight;
            case ZONE_FRONT_LEFT:
               return this.mHeatedSeatFrontLeft;
            default:
               return "off";
         }
      }
      
      public function setHeatedSeat(zone:String, state:String) : void
      {
         switch(zone)
         {
            case ZONE_FRONT_RIGHT:
               if(this.mVehServiceReady)
               {
                  this.sendSetCommand(dBusHeatSeatFrontRight,state);
               }
               else
               {
                  this.mFRHeatedSeatPendingState = state;
               }
               if(IS_TEST)
               {
                  this.mHeatedSeatFrontRight = state;
                  this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.HEATED_SEAT));
               }
               break;
            case ZONE_FRONT_LEFT:
               if(this.mVehServiceReady)
               {
                  this.sendSetCommand(dBusHeatSeatFrontLeft,state);
               }
               else
               {
                  this.mFLHeatedSeatPendingState = state;
               }
               if(IS_TEST)
               {
                  this.mHeatedSeatFrontLeft = state;
                  this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.HEATED_SEAT));
               }
         }
      }
      
      public function get hasHeatedSeat() : Boolean
      {
         return this.mHeatedSeatsPresent;
      }
      
      public function getVentedSeat() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\": [ \"" + dBusVentSeatFrontLeft + "\", \"" + dBusVentSeatFrontLeft + "\"]}}}");
         if(IS_TEST)
         {
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.VENTED_SEAT));
         }
      }
      
      public function ventedSeat(zone:String) : String
      {
         switch(zone)
         {
            case ZONE_FRONT_RIGHT:
               return this.mVentedSeatFrontRight;
            case ZONE_FRONT_LEFT:
               return this.mVentedSeatFrontLeft;
            default:
               return "off";
         }
      }
      
      public function setVentedSeat(zone:String, state:String) : void
      {
         switch(zone)
         {
            case ZONE_FRONT_RIGHT:
               if(this.mVehServiceReady)
               {
                  this.sendSetCommand(dBusVentSeatFrontRight,state);
               }
               else
               {
                  this.mFRVentedSeatPendingState = state;
               }
               if(IS_TEST)
               {
                  this.mVentedSeatFrontRight = state;
                  this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.VENTED_SEAT));
               }
               break;
            case ZONE_FRONT_LEFT:
               if(this.mVehServiceReady)
               {
                  this.sendSetCommand(dBusVentSeatFrontLeft,state);
               }
               else
               {
                  this.mFLVentedSeatPendingState = state;
               }
               if(IS_TEST)
               {
                  this.mVentedSeatFrontLeft = state;
                  this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.VENTED_SEAT));
               }
         }
      }
      
      public function get hasVentedSeat() : Boolean
      {
         return this.mVentedSeatsPresent;
      }
      
      public function getHeatedSteeringWheel() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\": [ \"" + dBusHeatWheel + "\"]}}}");
         if(IS_TEST)
         {
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.HEATED_STEERING_WHEEL));
         }
      }
      
      public function heatedSteeringWheel() : String
      {
         return this.mHeatedSteeringWheel;
      }
      
      public function setHeatedSteeringWheel(state:String) : void
      {
         state = state != "off" ? "on" : "off";
         if(this.mVehServiceReady)
         {
            this.sendSetCommand(dBusHeatWheel,state);
         }
         else
         {
            this.mHeatedWheelPendingState = state;
         }
         if(IS_TEST)
         {
            this.mHeatedSteeringWheel = state;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.HEATED_STEERING_WHEEL));
         }
      }
      
      public function get hasHeatedSteeringWheel() : Boolean
      {
         return this.mHeatedWheelPresent;
      }
      
      public function getSportsMode() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\": [ \"" + dBusDriveStyleStatus + "\"]}}}");
         if(IS_TEST)
         {
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.SPORTS_MODE));
         }
      }
      
      public function sportsMode() : String
      {
         return this.mSportsMode;
      }
      
      public function dnaStatus() : String
      {
         return this.mDNAStatus;
      }
      
      public function setSportsMode(state:String) : void
      {
         if(state == "on")
         {
            this.sendSetCommand(dBusDriveStyleStatus,"sport");
         }
         else
         {
            this.sendSetCommand(dBusDriveStyleStatus,"normal");
         }
         if(IS_TEST)
         {
            this.mSportsMode = state;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.SPORTS_MODE));
         }
      }
      
      public function get hasSportsMode() : Boolean
      {
         return this.mSportsModePresent;
      }
      
      public function getAwdMode() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\": [ \"" + dBusAwdMode + "\"]}}}");
         if(IS_TEST)
         {
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.AWD_MODE));
         }
      }
      
      public function awdMode() : String
      {
         return this.mAwdMode;
      }
      
      public function setAwdMode(state:String) : void
      {
         this.sendSetCommand(dBusAwdMode,state);
         if(IS_TEST)
         {
            this.mAwdMode = state;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.AWD_MODE));
         }
      }
      
      public function get hasAwdMode() : Boolean
      {
         return this.mAwdModePresent;
      }
      
      public function getEcoMode() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\": [ \"" + dBusEcoMode + "\"]}}}");
         if(IS_TEST)
         {
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.ECO_MODE));
         }
      }
      
      public function ecoMode() : String
      {
         return this.mEcoMode;
      }
      
      public function setEcoMode(state:String) : void
      {
         this.sendSetCommand(dBusEcoMode,state);
         if(IS_TEST)
         {
            this.mEcoMode = state;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.ECO_MODE));
         }
      }
      
      public function get hasEcoMode() : Boolean
      {
         return this.mEcoModePresent;
      }
      
      public function getHeadrestDump() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\":[ \"" + dBusHeadrestDump + "\"]}}}");
         if(IS_TEST)
         {
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.HEADREST_DUMP));
         }
      }
      
      public function setHeadrestDump(state:String) : void
      {
         this.sendSetCommand(dBusHeadrestDump,state);
         if(IS_TEST)
         {
            this.mHeadrestDump = state;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.HEADREST_DUMP));
         }
      }
      
      public function get headrestDump() : String
      {
         return this.mHeadrestDump;
      }
      
      public function getMirrorDimming() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\": [ \"" + dBusMirrorDimming + "\"]}}}");
         if(IS_TEST)
         {
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.MIRROR_DIMMING));
         }
      }
      
      public function setMirrorDimming(state:Boolean) : void
      {
         this.sendSetCommand(dBusMirrorDimming,state ? "on" : "off");
         if(IS_TEST)
         {
            this.mMirrorDimming = state ? "on" : "off";
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.MIRROR_DIMMING));
         }
      }
      
      public function get mirrorDimming() : Boolean
      {
         return this.mMirrorDimming == "on";
      }
      
      public function getSunShadePosition() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\": [ \"" + dBusSunShade + "\"]}}}");
         if(IS_TEST)
         {
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.SUN_SHADE_POSITION));
         }
      }
      
      public function sunShadePosition() : String
      {
         return this.mSunShadePosition;
      }
      
      public function setSunShadePosition(position:String) : void
      {
         this.sendSetCommand(dBusSunShade,position);
         if(IS_TEST)
         {
            this.mSunShadePosition = position;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.SUN_SHADE_POSITION));
         }
      }
      
      public function get hasSunShade() : Boolean
      {
         return this.mSunShadePresent;
      }
      
      public function getOutletState() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\": [ \"" + dBusPowerOutlet + "\"]}}}");
         if(IS_TEST)
         {
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.OUTLET_STATE));
         }
      }
      
      public function outletState() : String
      {
         return this.mOutletState;
      }
      
      public function setOutletState(state:String) : void
      {
         this.sendSetCommand(dBusPowerOutlet,state);
         if(IS_TEST)
         {
            this.mOutletState = state;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.OUTLET_STATE));
         }
      }
      
      public function get hasOutlet() : Boolean
      {
         return this.mOutletPresent;
      }
      
      public function getScreenEnable() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\": [ \"" + dBusScreenEnable + "\"]}}}");
         if(IS_TEST)
         {
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.SCREEN_ENABLE));
         }
      }
      
      public function screenEnable() : Boolean
      {
         return this.mScreenEnable;
      }
      
      public function setScreenEnable(enable:Boolean) : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"setProperties\":{\"props\":{\"" + dBusScreenEnable + "\":" + enable.toString + "}  }}}");
         if(IS_TEST)
         {
            this.mScreenEnable = enable;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.SCREEN_ENABLE));
         }
      }
      
      public function getCargoCamera() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\": [ \"" + dBusCargoCamera + "\"]}}}");
      }
      
      public function setCargoCamera(state:String) : void
      {
         this.sendSetCommand(dBusCargoCamera,state);
      }
      
      public function get cargoCamera() : String
      {
         return this.mCargoCamera;
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
         this.sendSubscribe(dBusComfortFeaturesDisabled);
         this.sendSubscribe(dBusReadyFlag);
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
         this.sendUnsubscribe(dBusReadyFlag);
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function sendCommand(commandName:String, valueName:String, value:String = null) : void
      {
         var message:String = null;
         if(value == null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\"}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         }
         this.client.send(message);
      }
      
      private function sendSetCommand(valueName:String, value:String = null) : void
      {
         var message:String = null;
         if(value != null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + dBusApiSetProperties + "\":{\"props\":{\"" + valueName + "\" :\"" + value + "\"}}}}";
            this.client.send(message);
         }
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function vehicleSettingsMessageHandler(e:ConnectionEvent) : void
      {
         var vehSettings:Object = e.data;
         if(vehSettings.hasOwnProperty("dBusServiceAvailable"))
         {
            if(vehSettings.dBusServiceAvailable == "true" && this.mVehSettingsServiceAvailable == false)
            {
               this.mVehSettingsServiceAvailable = true;
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\": {\"props\":[ \"" + dBusReadyFlag + "\"]}}}");
            }
            else if(vehSettings.dBusServiceAvailable == "false")
            {
               this.mVehSettingsServiceAvailable = false;
            }
         }
         if(vehSettings.hasOwnProperty(dBusApiGetProperties))
         {
            if(vehSettings.getProperties.hasOwnProperty(dBusReadyFlag))
            {
               if(vehSettings.getProperties.ready == "true" && this.mVehServiceReady == false)
               {
                  this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
               }
            }
            else
            {
               this.handlePropertyMessage(vehSettings.getProperties);
            }
         }
         if(vehSettings.hasOwnProperty(dBusApiGetAllProperties))
         {
            this.mHeatedSeatsPresent = false;
            this.mHeatedWheelPresent = false;
            this.mVentedSeatsPresent = false;
            this.mOutletPresent = false;
            this.mSportsModePresent = false;
            this.mSunShadePresent = false;
            this.mAwdModePresent = false;
            this.mEcoModePresent = false;
            this.mCargoCameraPresent = false;
            this.handlePropertyMessage(vehSettings.getAllProperties);
         }
         if(vehSettings.hasOwnProperty(dBusReadyFlag))
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
         }
         if(vehSettings.hasOwnProperty(dBusComfortFeaturesDisabled))
         {
            this.mcntrlFeaturesDisabled = vehSettings.comfortFeaturesDisabled.comfortFeaturesDisabled;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.CNTRL_FEATURES_DISABLED));
         }
         if(vehSettings.hasOwnProperty(dBusHeatSeatFrontLeft))
         {
            this.handlePropertyMessage(vehSettings.heatSeatFrontLeft);
         }
         if(vehSettings.hasOwnProperty(dBusHeatSeatFrontRight))
         {
            this.handlePropertyMessage(vehSettings.heatSeatFrontRight);
         }
         if(vehSettings.hasOwnProperty(dBusVentSeatFrontLeft))
         {
            this.handlePropertyMessage(vehSettings.ventSeatFrontLeft);
         }
         if(vehSettings.hasOwnProperty(dBusVentSeatFrontRight))
         {
            this.handlePropertyMessage(vehSettings.ventSeatFrontRight);
         }
         if(vehSettings.hasOwnProperty(dBusHeatWheel))
         {
            this.handlePropertyMessage(vehSettings.heatWheel);
         }
         if(vehSettings.hasOwnProperty(dBusSunShade))
         {
            this.handlePropertyMessage(vehSettings.sunShade);
         }
         if(vehSettings.hasOwnProperty(dBusPowerOutlet))
         {
            this.handlePropertyMessage(vehSettings.powerOutlet);
         }
         if(vehSettings.hasOwnProperty(dBusDriveStyleStatus))
         {
            this.handlePropertyMessage(vehSettings.driveStyleStatus);
         }
         if(vehSettings.hasOwnProperty(dBusScreenEnable))
         {
            this.handlePropertyMessage(vehSettings.screenEnable);
         }
         if(vehSettings.hasOwnProperty(dBusAwdMode))
         {
            this.handlePropertyMessage(vehSettings.awdMode);
         }
         if(vehSettings.hasOwnProperty(dBusEcoMode))
         {
            this.handlePropertyMessage(vehSettings.ecoMode);
         }
         if(vehSettings.hasOwnProperty(dBusMirrorDimming))
         {
            this.handlePropertyMessage(vehSettings.EC_MirrStat);
         }
         if(vehSettings.hasOwnProperty(dBusCargoCamera))
         {
            this.handlePropertyMessage(vehSettings.cargoCamera);
         }
      }
      
      public function handlePropertyMessage(msg:Object) : void
      {
         var prevDNAStatus:String = null;
         if(msg.hasOwnProperty(dBusComfortFeaturesDisabled))
         {
            this.mcntrlFeaturesDisabled = msg.comfortFeaturesDisabled;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.CNTRL_FEATURES_DISABLED));
         }
         if(msg.hasOwnProperty(dBusHeatSeatFrontLeft))
         {
            this.mHeatedSeatsPresent = true;
            this.mHeatedSeatFrontLeft = msg.heatSeatFrontLeft;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.HEATED_SEAT));
         }
         if(msg.hasOwnProperty(dBusHeatSeatFrontRight))
         {
            this.mHeatedSeatsPresent = true;
            this.mHeatedSeatFrontRight = msg.heatSeatFrontRight;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.HEATED_SEAT));
         }
         if(msg.hasOwnProperty(dBusHeatWheel))
         {
            this.mHeatedWheelPresent = true;
            this.mHeatedSteeringWheel = msg.heatWheel;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.HEATED_STEERING_WHEEL));
         }
         if(msg.hasOwnProperty(dBusVentSeatFrontLeft))
         {
            this.mVentedSeatsPresent = true;
            this.mVentedSeatFrontLeft = msg.ventSeatFrontLeft;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.VENTED_SEAT));
         }
         if(msg.hasOwnProperty(dBusVentSeatFrontRight))
         {
            this.mVentedSeatsPresent = true;
            this.mVentedSeatFrontRight = msg.ventSeatFrontRight;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.VENTED_SEAT));
         }
         if(msg.hasOwnProperty(dBusReadyFlag))
         {
            if(msg.ready == "true" && this.mVehServiceReady == false)
            {
               this.mVehServiceReady = true;
               if(this.mFLHeatedSeatPendingState != null)
               {
                  if(this.mFLHeatedSeatPendingState != this.mHeatedSeatFrontLeft)
                  {
                     this.sendSetCommand(dBusHeatSeatFrontLeft,this.mFLHeatedSeatPendingState);
                     this.mFLHeatedSeatPendingState = this.mHeatedSeatFrontLeft;
                  }
               }
               if(this.mFRHeatedSeatPendingState != null)
               {
                  if(this.mFRHeatedSeatPendingState != this.mHeatedSeatFrontRight)
                  {
                     this.sendSetCommand(dBusHeatSeatFrontRight,this.mFRHeatedSeatPendingState);
                     this.mFRHeatedSeatPendingState = this.mHeatedSeatFrontRight;
                  }
               }
               if(this.mFLVentedSeatPendingState != null)
               {
                  if(this.mFLVentedSeatPendingState != this.mVentedSeatFrontLeft)
                  {
                     this.sendSetCommand(dBusVentSeatFrontLeft,this.mFLVentedSeatPendingState);
                     this.mFLVentedSeatPendingState = this.mVentedSeatFrontLeft;
                  }
               }
               if(this.mFRVentedSeatPendingState != null)
               {
                  if(this.mFRVentedSeatPendingState != this.mVentedSeatFrontRight)
                  {
                     this.sendSetCommand(dBusVentSeatFrontRight,this.mFRVentedSeatPendingState);
                     this.mFRVentedSeatPendingState = this.mVentedSeatFrontRight;
                  }
               }
               if(this.mHeatedWheelPendingState != null)
               {
                  if(this.mHeatedWheelPendingState != this.mHeatedSteeringWheel)
                  {
                     this.sendSetCommand(dBusHeatWheel,this.mHeatedWheelPendingState);
                     this.mHeatedWheelPendingState = this.mHeatedSteeringWheel;
                  }
               }
            }
         }
         if(msg.hasOwnProperty(dBusSunShade))
         {
            this.mSunShadePresent = true;
            this.mSunShadePosition = msg.sunShade;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.SUN_SHADE_POSITION));
         }
         if(msg.hasOwnProperty(dBusPowerOutlet))
         {
            this.mOutletPresent = true;
            this.mOutletState = msg.powerOutlet;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.OUTLET_STATE));
         }
         if(msg.hasOwnProperty(dBusDriveStyleStatus))
         {
            this.mSportsModePresent = true;
            prevDNAStatus = this.mDNAStatus;
            switch(msg.driveStyleStatus)
            {
               case "normal":
                  this.mDNAStatus = "natural";
                  break;
               case "sport":
                  this.mDNAStatus = "dynamic";
                  break;
               case "winter":
                  this.mDNAStatus = "allWeather";
            }
            this.mSportsMode = this.mDNAStatus == "dynamic" ? "on" : "off";
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.SPORTS_MODE));
            if(prevDNAStatus != "invalid")
            {
               this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.DNA_STATUS));
            }
         }
         if(msg.hasOwnProperty(dBusScreenEnable))
         {
            this.mScreenEnable = msg.screenEnable;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.SCREEN_ENABLE));
         }
         if(msg.hasOwnProperty(dBusAwdMode))
         {
            this.mAwdModePresent = true;
            this.mAwdMode = msg.awdMode;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.AWD_MODE));
         }
         if(msg.hasOwnProperty(dBusEcoMode))
         {
            this.mEcoModePresent = true;
            this.mEcoMode = msg.ecoMode;
            this.dispatchEvent(new VehSettingsEvent(VehSettingsEvent.ECO_MODE));
         }
         if(msg.hasOwnProperty(dBusHeadrestDump))
         {
            this.mHeadrestDump = msg[dBusHeadrestDump];
            dispatchEvent(new VehSettingsEvent(VehSettingsEvent.HEADREST_DUMP));
         }
         if(msg.hasOwnProperty(dBusMirrorDimming))
         {
            this.mMirrorDimming = msg[dBusMirrorDimming];
            dispatchEvent(new VehSettingsEvent(VehSettingsEvent.MIRROR_DIMMING));
         }
         if(msg.hasOwnProperty(dBusCargoCamera))
         {
            this.mCargoCameraPresent = true;
            this.mCargoCamera = msg[dBusCargoCamera];
            dispatchEvent(new VehSettingsEvent(VehSettingsEvent.CARGO_CAMERA));
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:* = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
   }
}

