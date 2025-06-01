package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class HMIRequestEvent extends Event
   {
      public static const BTN_PRESSED:String = "btnPressed";
      
      public static const TIMEOUT:String = "timeout";
      
      public static const NEW_POPUP:String = "newPopup";
      
      public static const POPUP_DISPLAYED:String = "popupDisplayed";
      
      public static const POPUP_IN_QUEUE:String = "popupInQueue";
      
      public static const POPUP_DISPLAY_DENIED:String = "popupDisplayDenied";
      
      public static const DISPLAY_BLOCK_POPUP:String = "displayBlockPopup";
      
      public static const DISPLAY_BLOCK_POPUP_BY_MSGID:String = "displayBlockPopupByMsgId";
      
      public static const DISPLAY_GLOBAL_POPUP:String = "displayGlobalPopup";
      
      public static const DISPLAY_GLOBAL_POPUP_BY_MSGID:String = "displayGlobalPopupByMsgId";
      
      public static const GET_PROP_LD:String = "getPropertyLD";
      
      public static const SET_PROP_LD:String = "setPropertyLD";
      
      public static const ACCEPT_PROP_LD:String = "acceptPropertyLD";
      
      public static const ROUTE_TO_LOCATION:String = "routeToLocation";
      
      public static const START_GUIDANCE:String = "startGuidance";
      
      public static const STOP_GUIDANCE:String = "stopGuidance";
      
      public static const GET_GUIDANCE_STATE:String = "getGuidanceState";
      
      public static const SET_NAV_REPEAT_PROMPT:String = "setNavRepeatPrompt";
      
      public static const SWITCH_TO_DRIVEMODE:String = "switchToDriveMode";
      
      public static const SET_APP_VISIBLE:String = "setAppVisible";
      
      public static const MEDIA_INSERT:String = "mediaInsert";
      
      public static const AUTOMATION_TEST_ACTIVATE:String = "automationTestActivate";
      
      public static const AUTOMATION_TEST_DEACTIVATE:String = "automationTestDeActivate";
      
      public static const AUTOMATION_INSPECT:String = "automationInspect";
      
      public static const INSIGHT_START:String = "InsightStart";
      
      public var mData:Object = null;
      
      public function HMIRequestEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

