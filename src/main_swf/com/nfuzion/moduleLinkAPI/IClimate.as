package com.nfuzion.moduleLinkAPI
{
   public interface IClimate extends IModule
   {
      function get outsideTemp() : String;
      
      function get driverTemp() : Number;
      
      function get passengerTemp() : Number;
      
      function getOutsideTemp() : void;
   }
}

