package events
{
   import flash.events.Event;
   
   public class FrameworkEvent extends Event
   {
      public static const IDLE:String = "idle";
      
      public static const READY:String = "ready";
      
      public static const APPMGR_READY:String = "appMgr_ready";
      
      public function FrameworkEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new FrameworkEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("FrameworkEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

