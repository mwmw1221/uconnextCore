package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IHMIRequest extends IModule
   {
      function globalPopupClosed(param1:int, param2:String, param3:String, param4:uint) : void;
      
      function globalPopupReturnResult(param1:int, param2:String, param3:Boolean) : void;
      
      function navRouteToLocationReturnResult(param1:Boolean) : void;
      
      function navStartGuidanceReturnResult(param1:Boolean) : void;
      
      function navStopGuidanceReturnResult(param1:String) : void;
      
      function navSendGetPropertiesResponse(param1:String, param2:String, param3:Boolean) : void;
      
      function navSendSetPropertiesResponse(param1:String, param2:Boolean) : void;
      
      function navSendAcceptPropertiesResponse(param1:Boolean) : void;
      
      function navSignalCountryChanged() : void;
      
      function navSignalRouteGuidanceStatus(param1:String) : void;
      
      function navSendRouteGuidanceStatusResponse(param1:String) : void;
      
      function navSendSetNavRepeatPromptResponse(param1:Boolean) : void;
      
      function hmiUpdatePersistencyLastScreenValue(param1:String) : void;
      
      function hmiUpdatePersistencyNavActivatedValue(param1:int) : void;
      
      function setAppVisibleResult(param1:Boolean) : void;
      
      function setDealerModeStatus(param1:Boolean) : void;
      
      function setEngineeringModeStatus(param1:Boolean) : void;
      
      function insightReturnResult(param1:String, param2:int = 0) : void;
      
      function emitScreenStatus(param1:String, param2:String) : void;
      
      function emitScreenInspectResults(param1:String, param2:String, param3:int, param4:int) : void;
   }
}

