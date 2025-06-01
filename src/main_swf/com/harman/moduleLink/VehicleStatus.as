package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.IVehicleStatus;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class VehicleStatus extends Module implements IVehicleStatus
   {
      private static var instance:VehicleStatus;
      
      private static const dbusIdentifier:String = "VehicleStatus";
      
      private static const dbusIdCANService:String = "canservice";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mTestToolPresent:Boolean = false;
      
      private var mSpeedLockOut:Boolean = false;
      
      private var mSpeedLockOutFeature:String = "undefined";
      
      private var mheadlightsOn:Boolean = true;
      
      private var mLanguage:String = "en_US";
      
      private var mVehServiceReady:Boolean = false;
      
      private var mVehStatusServicePresent:Boolean = false;
      
      private var mLangUnitMstrOverride:String = "off";
      
      private var mThemeFileOverride:String = "off";
      
      private var mFuelSaverModeActual:String = "na";
      
      private var mIgnitionState:String = "undefined";
      
      private var mVehicleInPark:Boolean = false;
      
      public function VehicleStatus()
      {
         super();
         this.init();
      }
      
      public static function getInstance() : VehicleStatus
      {
         if(instance == null)
         {
            instance = new VehicleStatus();
         }
         return instance;
      }
      
      private function init() : void
      {
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.VEHICLE_STATUS,this.VehicleStatusMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.sendMultiSubscribe(["speedLockOut","speedLockOutFeature","headlightsOn","comfortFeaturesDisabled","language","testToolPresent","themeFileOverride","langUnitMstrOverride","fuelSaverModeActual","vehicleInPark","ready","ignitionState"]);
            }
            else
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
            }
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
      
      public function VehicleStatusMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         if(resp.hasOwnProperty("dBusServiceAvailable"))
         {
            if(resp.dBusServiceAvailable == "true" && this.mVehStatusServicePresent == false)
            {
               this.mVehStatusServicePresent = true;
               this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getAllProperties\": {}}}");
            }
            else if(resp.dBusServiceAvailable == "false")
            {
               this.mVehStatusServicePresent = false;
            }
         }
         else if(resp.hasOwnProperty("getAllProperties"))
         {
            if(resp.getAllProperties.hasOwnProperty("speedLockOut"))
            {
               this.mSpeedLockOut = Boolean(resp.getAllProperties.speedLockOut == "enabled");
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT,this.mSpeedLockOut));
            }
            if(resp.getAllProperties.hasOwnProperty("vehicleInPark"))
            {
               this.mVehicleInPark = Boolean(resp.getAllProperties.vehicleInPark == "true");
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.VEHICLE_IN_PARK,this.mVehicleInPark));
            }
            if(resp.getAllProperties.hasOwnProperty("speedLockOutFeature"))
            {
               this.mSpeedLockOutFeature = resp.getAllProperties.speedLockOutFeature;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT_FEATURE));
            }
            if(resp.getAllProperties.hasOwnProperty("headlightsOn"))
            {
               this.mheadlightsOn = resp.getAllProperties.headlightsOn;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.HEADLIGHTS_ON));
            }
            if(resp.getAllProperties.hasOwnProperty("language"))
            {
               this.mLanguage = resp.getAllProperties.language;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.LANGUAGE));
            }
            if(resp.getAllProperties.hasOwnProperty("testToolPresent"))
            {
               this.mTestToolPresent = resp.getAllProperties.testToolPresent;
            }
            if(resp.getAllProperties.hasOwnProperty("themeFileOverride"))
            {
               this.mThemeFileOverride = resp.getAllProperties.themeFileOverride;
            }
            if(resp.getAllProperties.hasOwnProperty("langUnitMstrOverride"))
            {
               this.mLangUnitMstrOverride = resp.getAllProperties.langUnitMstrOverride;
            }
            if(resp.getAllProperties.hasOwnProperty("fuelSaverModeActual"))
            {
               this.mFuelSaverModeActual = resp.getAllProperties.fuelSaverModeActual;
            }
            if(resp.getAllProperties.hasOwnProperty("ignition"))
            {
               this.mIgnitionState = resp.getAllProperties.ignition;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.IGNITION_STATE));
            }
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
         else if(resp.hasOwnProperty("speedLockOut"))
         {
            this.mSpeedLockOut = Boolean(resp.speedLockOut.speedLockOut == "enabled");
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT,this.mSpeedLockOut));
         }
         else if(resp.hasOwnProperty("vehicleInPark"))
         {
            this.mVehicleInPark = Boolean(resp.vehicleInPark.vehicleInPark == "true");
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.VEHICLE_IN_PARK,this.mVehicleInPark));
         }
         else if(resp.hasOwnProperty("setSpeedLockOutFeature"))
         {
            this.mSpeedLockOutFeature = resp.setSpeedLockOutFeature.setting;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT_FEATURE));
         }
         else if(resp.hasOwnProperty("speedLockOutFeature"))
         {
            this.mSpeedLockOutFeature = resp.speedLockOutFeature.setting;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT_FEATURE));
         }
         else if(resp.hasOwnProperty("getProperties"))
         {
            if(resp.getProperties.hasOwnProperty("speedLockOutFeature"))
            {
               this.mSpeedLockOutFeature = resp.getProperties.speedLockOutFeature;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT_FEATURE));
            }
         }
         else if(resp.hasOwnProperty("headlightsOn"))
         {
            this.mheadlightsOn = resp.headlightsOn.headlightsOn;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.HEADLIGHTS_ON));
         }
         else if(resp.hasOwnProperty("language"))
         {
            this.mLanguage = resp.language.language;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.LANGUAGE,resp.language));
         }
         else if(resp.hasOwnProperty("themeFileOverride"))
         {
            this.mThemeFileOverride = resp.themeFileOverride.themeFileOverride;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.THEME_OVERRIDE));
         }
         else if(resp.hasOwnProperty("langUnitMstrOverride"))
         {
            this.mLangUnitMstrOverride = resp.langUnitMstrOverride.langUnitMstrOverride;
            this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.LANG_UNIT_MST_OVERRIDE));
         }
         else if(!resp.hasOwnProperty("ready"))
         {
            if(resp.hasOwnProperty("testToolPresent"))
            {
               this.mTestToolPresent = resp.testToolPresent.testToolPresent;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.TEST_TOOL_PRESENT));
            }
            else if(resp.hasOwnProperty("fuelSaverModeActual"))
            {
               this.mFuelSaverModeActual = resp.fuelSaverModeActual.fuelSaverModeActual;
            }
            else if(resp.hasOwnProperty("ignitionState"))
            {
               this.mIgnitionState = resp.ignitionState.state;
               this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.IGNITION_STATE));
            }
         }
      }
      
      public function getSpeedLockoutFeatureState() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"speedLockOutFeature\"]}}}");
      }
      
      public function toggleSpeedLockOutFeature() : void
      {
         if(this.mSpeedLockOutFeature == "on")
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setSpeedLockOutFeature\":{\"setting\":\"off\"}}}");
         }
         else if(this.mSpeedLockOutFeature == "off")
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setSpeedLockOutFeature\":{\"setting\":\"on\"}}}");
         }
      }
      
      public function set speedLockOut(locked:Boolean) : void
      {
         this.mSpeedLockOut = locked;
         this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.SPEED_LOCK_OUT));
      }
      
      public function get vehicleInPark() : Boolean
      {
         return this.mVehicleInPark;
      }
      
      public function get speedLockOut() : Boolean
      {
         return this.mSpeedLockOut;
      }
      
      public function get speedLockOutFeature() : String
      {
         return this.mSpeedLockOutFeature;
      }
      
      public function get headlightsOn() : Boolean
      {
         return this.mheadlightsOn;
      }
      
      public function get language() : String
      {
         return this.mLanguage;
      }
      
      public function getLanguage() : void
      {
         this.dispatchEvent(new VehicleStatusEvent(VehicleStatusEvent.LANGUAGE));
      }
      
      public function get TestToolPresent() : Boolean
      {
         return this.mTestToolPresent;
      }
      
      public function get LangUnitMstrOverride() : String
      {
         return this.mLangUnitMstrOverride;
      }
      
      public function toggleLangUnitMstrOverride() : void
      {
         if(this.mLangUnitMstrOverride == "on")
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setLangUnitMstrOverride\":{\"setting\":\"off\"}}}");
         }
         else if(this.mLangUnitMstrOverride == "off")
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setLangUnitMstrOverride\":{\"setting\":\"on\"}}}");
         }
      }
      
      public function get ThemeFileOverride() : String
      {
         return this.mThemeFileOverride;
      }
      
      public function toggleThemeFileOverride() : void
      {
         if(this.mThemeFileOverride == "on")
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setThemeOverride\":{\"setting\":\"off\"}}}");
         }
         else if(this.mThemeFileOverride == "off")
         {
            this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"setThemeOverride\":{\"setting\":\"on\"}}}");
         }
      }
      
      public function setThemeTo(theme:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"VehicleConfig\", \"packet\": { \"setThemeTo\": { \"theme\": \"" + theme + "\"}}}";
         this.client.send(message);
      }
      
      public function get fuelSaverModeActual() : String
      {
         return this.mFuelSaverModeActual;
      }
      
      public function getIgnitionState() : void
      {
         this.client.send("{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"getProperties\":{\"props\":[\"ignition\"]}}}");
      }
      
      public function get ignitionState() : String
      {
         return this.mIgnitionState;
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
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
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendAvailableRequest() : void
      {
         var message:* = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      protected function sendCommand(commandName:String, valueName:String, value:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         this.client.send(message);
      }
   }
}

