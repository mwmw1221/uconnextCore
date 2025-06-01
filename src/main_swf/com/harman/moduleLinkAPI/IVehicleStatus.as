package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IVehicleStatus extends IModule
   {
      function get vehicleInPark() : Boolean;
      
      function get speedLockOut() : Boolean;
      
      function get speedLockOutFeature() : String;
      
      function toggleSpeedLockOutFeature() : void;
      
      function getSpeedLockoutFeatureState() : void;
      
      function get headlightsOn() : Boolean;
      
      function get language() : String;
      
      function getLanguage() : void;
      
      function get TestToolPresent() : Boolean;
      
      function get LangUnitMstrOverride() : String;
      
      function toggleLangUnitMstrOverride() : void;
      
      function get ThemeFileOverride() : String;
      
      function toggleThemeFileOverride() : void;
      
      function setThemeTo(param1:String) : void;
      
      function get fuelSaverModeActual() : String;
      
      function getIgnitionState() : void;
      
      function get ignitionState() : String;
   }
}

