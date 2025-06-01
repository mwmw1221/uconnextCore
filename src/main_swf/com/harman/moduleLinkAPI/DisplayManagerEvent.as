package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class DisplayManagerEvent extends Event
   {
      public static const DISPLAY_BUSY:String = "DISPLAY_busy";
      
      public static const DISPLAY_CHANGED:String = "DISPLAY_changed";
      
      public static const DISPLAY_REQUEST_RESPONSE:String = "DISPLAY_request_response";
      
      public function DisplayManagerEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

