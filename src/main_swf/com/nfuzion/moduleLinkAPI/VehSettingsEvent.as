package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class VehSettingsEvent extends Event
   {
      public static const CNTRL_FEATURES_DISABLED:String = "ControlFeaturesDisabled";
      
      public static const AVAILABLE:String = "Available";
      
      public static const HEATED_SEAT:String = "heatedSeat";
      
      public static const VENTED_SEAT:String = "ventedSeat";
      
      public static const HEATED_STEERING_WHEEL:String = "heatedSteeringWheel";
      
      public static const SPORTS_MODE:String = "sportsMode";
      
      public static const DNA_STATUS:String = "dnaStatus";
      
      public static const AWD_MODE:String = "awdMode";
      
      public static const ECO_MODE:String = "ecoMode";
      
      public static const SUN_SHADE_POSITION:String = "sunShadePosition";
      
      public static const OUTLET_STATE:String = "outletState";
      
      public static const SCREEN_ENABLE:String = "screenEnable";
      
      public static const HEADREST_DUMP:String = "headrestDump";
      
      public static const MIRROR_DIMMING:String = "EC_MirrStat";
      
      public static const CARGO_CAMERA:String = "cargoCamera";
      
      public function VehSettingsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

