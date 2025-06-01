package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class VehicleStatusEvent extends Event
   {
      public static const SPEED_LOCK_OUT:String = "VehicleSpeedLockOut";
      
      public static const SPEED_LOCK_OUT_FEATURE:String = "SpeedLockOutFeature";
      
      public static const HEADLIGHTS_ON:String = "VehicleHeadlightsOn";
      
      public static const LANGUAGE:String = "Language";
      
      public static const TEST_TOOL_PRESENT:String = "TestToolPresent";
      
      public static const THEME_OVERRIDE:String = "ThemeFileOverride";
      
      public static const LANG_UNIT_MST_OVERRIDE:String = "LangUnitMstrOverride";
      
      public static const IGNITION_STATE:String = "IgnitionState";
      
      public static const VEHICLE_IN_PARK:String = "VehicleInPark";
      
      public var mData:* = null;
      
      public function VehicleStatusEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

