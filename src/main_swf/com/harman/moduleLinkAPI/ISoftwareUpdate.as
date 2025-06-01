package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface ISoftwareUpdate extends IModule
   {
      function get currentSoftwareVersion() : String;
      
      function get newSoftwareVersion() : String;
      
      function get moduleType() : String;
      
      function get moduleName() : String;
      
      function setButtonPressInfo(param1:Boolean, param2:String = null) : void;
      
      function get unitName() : String;
      
      function get unitNumber() : Number;
      
      function get unitPercentComplete() : Number;
      
      function get totalUnitCount() : Number;
      
      function get totalPercentComplete() : Number;
      
      function getStatus() : void;
      
      function get swUpdateState() : String;
      
      function get errorMessage() : String;
      
      function beginUpdate() : void;
      
      function cancelUpdate() : void;
      
      function get updateDBState() : Object;
      
      function sendDBUpdateActivationCode(param1:String) : void;
      
      function sendDBUpdateActivationCodeReset() : void;
      
      function get updateDBActivationCodeAcceptanceState() : int;
      
      function sendDBUpdateStartUpdate() : void;
      
      function sendDBUpdateDeclineUpdate() : void;
      
      function sendDBUpdateReset() : void;
   }
}

