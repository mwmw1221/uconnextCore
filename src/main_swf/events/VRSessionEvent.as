package events
{
   import flash.events.Event;
   
   public class VRSessionEvent extends Event
   {
      public static const VR_SESSION_OVERRIDE_ON:String = "events.VRSessionEvent.vrSessionOverrideOn";
      
      public static const VR_SESSION_OVERRIDE_OFF:String = "events.VRSessionEvent.vrSessionOverrideOff";
      
      public static const VR_HIDE_VOICE_BAR:String = "events.VRSessionEvent.vrStatusbarHide";
      
      public function VRSessionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

