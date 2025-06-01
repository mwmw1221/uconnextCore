package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IDisplayManager extends IModule
   {
      function getDisplayBusy() : void;
      
      function get DisplayBusy() : Boolean;
      
      function getCurrentLayer() : String;
      
      function getPrevLayer() : String;
      
      function requestDisplay(param1:String, param2:Boolean) : void;
   }
}

