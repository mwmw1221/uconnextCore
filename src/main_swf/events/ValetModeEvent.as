package events
{
   import flash.events.Event;
   
   public class ValetModeEvent extends Event
   {
      public static const STATE:String = "ValetMode.State";
      
      public var data:*;
      
      public function ValetModeEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
      
      override public function clone() : Event
      {
         return new ValetModeEvent(type,bubbles,this.data,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("ValetMode","type","data","bubbles","cancelable");
      }
   }
}

