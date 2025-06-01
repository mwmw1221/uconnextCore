package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.AppManagerEvent;
   import com.harman.moduleLinkAPI.HMIRequestEvent;
   import com.harman.moduleLinkAPI.IHMIRequest;
   import com.nfuzion.moduleLink.AudioSettings;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLink.VoiceRecognition;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.VoiceRecognitionEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class HMIRequest extends Module implements IHMIRequest
   {
      private static var instance:HMIRequest;
      
      private static const dbusIdentifier:String = "Audio";
      
      private var connection:Connection;
      
      private var name:String = "HMIRequest";
      
      private var client:Client;
      
      private var mCountryHasChanged:Boolean = false;
      
      private var mDealerMode:Boolean = false;
      
      private var mEngineeringMode:Boolean = false;
      
      public function HMIRequest()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.HMI_REQUEST,this.hmiRequestHandler);
         this.connection.addEventListener(ConnectionEvent.AUDIO,this.hmiRequestHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : HMIRequest
      {
         if(instance == null)
         {
            instance = new HMIRequest();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.subscribe("mediaInsert");
               this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            }
            else
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
            }
         }
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var message:* = null;
         if(this.client.connected)
         {
            message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\":\"" + signalName + "\"}";
            this.client.send(message);
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         this.name = this.connection.configuration.@name.toString();
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function globalPopupClosed(popupid:int, reason:String, btnPressed:String, btnIdPressed:uint) : void
      {
         var message:* = null;
         message = "{\"Type\":\"EmitSignal\",\"packet\":{\"globalPopupClosed\":{\"popupid\":" + popupid + ",\"reason\":\"" + reason + "\",\"btnPressed\":\"" + btnPressed + "\",\"btnIdPressed\":" + btnIdPressed + "}}}";
         this.client.send(message);
      }
      
      public function globalPopupReturnResult(popupid:int, status:String, byMsgId:Boolean) : void
      {
         var message:* = null;
         if(byMsgId == true)
         {
            message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_displayGlobalPopupByMsgId\",\"packet\":{\"displayGlobalPopupResult\":{\"popupid\":" + popupid + ",\"status\":\"" + status + "\"}}}";
         }
         else
         {
            message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_displayGlobalPopup\",\"packet\":{\"displayGlobalPopupResult\":{\"popupid\":" + popupid + ",\"status\":\"" + status + "\"}}}";
         }
         this.client.send(message);
      }
      
      public function assistRequestReturnResult() : void
      {
         var message:* = null;
         message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_assistRequest\",\"packet\":{\"success\":" + true + "}}";
         this.client.send(message);
      }
      
      public function navRouteToLocationReturnResult(result:Boolean) : void
      {
         var message:* = null;
         message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_routeToLocation\",\"packet\":{\"routable\":" + result + "}}";
         this.client.send(message);
      }
      
      public function navStartGuidanceReturnResult(result:Boolean) : void
      {
         var message:* = null;
         message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_startGuidance\",\"packet\":{\"started\":" + result + "}}";
         this.client.send(message);
      }
      
      public function navStopGuidanceReturnResult(result:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_stopGuidance\",\"packet\":{\"result\":\"" + result + "\"}}";
         this.client.send(message);
      }
      
      public function navSendGetPropertiesResponse(response:String, ldType:String, success:Boolean) : void
      {
         var message:* = null;
         message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_getLDProperties\",\"packet\":{\"" + ldType + "\":{\"response\":\"" + response + "\", \"success\":\"" + success + "\" }}}";
         this.client.send(message);
      }
      
      public function navSendSetPropertiesResponse(ldType:String, success:Boolean) : void
      {
         var message:* = null;
         message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_setLDProperties\",\"packet\":{\"" + ldType + "\":{\"success\":\"" + success + "\" }}}";
         this.client.send(message);
      }
      
      public function navSendAcceptPropertiesResponse(routable:Boolean) : void
      {
         var message:* = null;
         message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_acceptLDProperties\",\"packet\":{\"routable\":" + routable + "}}";
         this.client.send(message);
      }
      
      public function navSignalCountryChanged() : void
      {
         var message:String = null;
         this.mCountryHasChanged = true;
         message = "{\"Type\":\"EmitSignal\",\"packet\":{\"countryChanged\":\"\"}}";
         this.client.send(message);
      }
      
      public function navSignalRouteGuidanceStatus(status:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"EmitSignal\",\"packet\":{\"routeGuidanceStatus\":{\"status\":\"" + status + "\"}}}";
         this.client.send(message);
      }
      
      public function navSendRouteGuidanceStatusResponse(status:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_routeGuidanceStatus\",\"packet\":{\"status\":\"" + status + "\"}}";
         this.client.send(message);
      }
      
      public function navSendSetNavRepeatPromptResponse(success:Boolean) : void
      {
         var message:* = null;
         message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_setNavRepeatPrompt\",\"packet\":{\"success\":" + success + "}}";
         this.client.send(message);
      }
      
      public function hmiUpdatePersistencyLastScreenValue(_lastScreen:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"EmitSignal\",\"packet\":{\"new_hmi_var\":{\"key\":\"last_screen\", \"new_hmi_screen\":\"" + _lastScreen + "\"}}}";
         this.client.send(message);
      }
      
      public function hmiUpdatePersistencyNavActivatedValue(_navActivated:int) : void
      {
         var message:* = null;
         message = "{\"Type\":\"EmitSignal\",\"packet\":{\"new_hmi_var\":{\"key\":\"navigation_activated\", \"nav_activated\":\"" + _navActivated + "\"}}}";
         this.client.send(message);
      }
      
      public function setAppVisibleResult(success:Boolean) : void
      {
         var message:* = null;
         message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_setAppVisible\",\"packet\":{\"success\":" + success + "}}";
         this.client.send(message);
      }
      
      public function insightReturnResult(method:String, success:int = 0) : void
      {
         var message:* = null;
         message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_" + method + "\",\"packet\":{\"result\":" + success + "}}";
         this.client.send(message);
      }
      
      public function emitScreenStatus(event:String, currentScreen:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"EmitSignal\",\"packet\":{\"screenStatus\":{\"event\":\"" + event + "\", \"currentScreen\":\"" + currentScreen + "\" }}}";
         this.client.send(message);
      }
      
      public function emitScreenInspectResults(screenLayer:String, screenData:String, packetCurrent:int, packetTotal:int) : void
      {
         var message:* = null;
         message = "{\"Type\":\"EmitSignal\",\"packet\":{\"screenInspectResults\":{\"" + screenLayer + "\":\"" + screenData + "\", \"packetCurrent\":\"" + packetCurrent + "\", \"packetTotal\":\"" + packetTotal + "\"}}}";
         this.client.send(message);
      }
      
      public function setDealerModeStatus(status:Boolean) : void
      {
         var dealerModeString:String = null;
         var message:* = null;
         if(this.mDealerMode != status)
         {
            this.mDealerMode = status;
            dealerModeString = this.mDealerMode ? "activated" : "deactivated";
            message = "{\"Type\":\"EmitSignal\",\"packet\":{\"dealerMenuStatus\":{\"status\":\"" + dealerModeString + "\"}}}";
            this.client.send(message);
         }
      }
      
      public function setEngineeringModeStatus(status:Boolean) : void
      {
         var engineeringModeString:String = null;
         var message:* = null;
         if(this.mEngineeringMode != status)
         {
            this.mEngineeringMode = status;
            engineeringModeString = this.mEngineeringMode ? "activated" : "deactivated";
            message = "{\"Type\":\"EmitSignal\",\"packet\":{\"engineeringModeStatus\":{\"status\":\"" + engineeringModeString + "\"}}}";
            this.client.send(message);
         }
      }
      
      public function blockPopupReturnResult(byMsgId:Boolean) : void
      {
         var message:String = null;
         if(byMsgId == true)
         {
            message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_displayBlockPopupByMsgId\",\"packet\":{\"displayBlockPopupByMsgIdResult\":{\"displayStatus \":\"OK\"}}}";
         }
         else
         {
            message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_displayBlockPopup\",\"packet\":{\"displayBlockPopupResult\":{\"displayStatus \":\"OK\"}}}";
         }
         this.client.send(message);
      }
      
      public function hmiSendUpdateVolumeResponse(success:Boolean) : void
      {
         var message:* = null;
         message = "{\"Type\":\"ReturnResult\",\"response\":\"rsp_updateHMIVolume\",\"packet\":{\"success\":" + success + "}}";
         this.client.send(message);
      }
      
      public function hmiRequestHandler(e:ConnectionEvent) : void
      {
         var filepath:Object = null;
         var success:Boolean = false;
         var resp:Object = e.data;
         if(resp.hasOwnProperty("displayGlobalPopup"))
         {
            this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.DISPLAY_GLOBAL_POPUP,e.data));
         }
         else if(resp.hasOwnProperty("displayGlobalPopupByMsgId"))
         {
            this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.DISPLAY_GLOBAL_POPUP_BY_MSGID,e.data));
         }
         else if(resp.hasOwnProperty("displayBlockPopup"))
         {
            this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.DISPLAY_BLOCK_POPUP,e.data.displayBlockPopup));
            this.blockPopupReturnResult(false);
         }
         else if(resp.hasOwnProperty("displayBlockPopupByMsgId"))
         {
            this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.DISPLAY_BLOCK_POPUP_BY_MSGID,e.data.displayBlockPopupByMsgId));
            this.blockPopupReturnResult(true);
         }
         else if(resp.hasOwnProperty("routeToLocation"))
         {
            if(!this.hasEventListener(HMIRequestEvent.ROUTE_TO_LOCATION))
            {
               this.navRouteToLocationReturnResult(false);
            }
            else
            {
               this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.ROUTE_TO_LOCATION,e.data));
            }
         }
         else if(resp.hasOwnProperty("startGuidance"))
         {
            if(!this.hasEventListener(HMIRequestEvent.START_GUIDANCE))
            {
               this.navStartGuidanceReturnResult(false);
            }
            else
            {
               this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.START_GUIDANCE));
            }
         }
         else if(resp.hasOwnProperty("stopGuidance"))
         {
            if(!this.hasEventListener(HMIRequestEvent.STOP_GUIDANCE))
            {
               this.navStopGuidanceReturnResult("invalid");
            }
            else
            {
               this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.STOP_GUIDANCE));
            }
         }
         else if(resp.hasOwnProperty("getLDProperties"))
         {
            if(!this.hasEventListener(HMIRequestEvent.GET_PROP_LD))
            {
               this.navSendGetPropertiesResponse("",e.data.getLDProperties.type,false);
            }
            else if(Boolean(e.data.getLDProperties.hasOwnProperty("type")) && e.data.getLDProperties.type == "countryChanged")
            {
               this.navSendGetPropertiesResponse(String(this.mCountryHasChanged),"countryChanged",true);
            }
            else
            {
               this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.GET_PROP_LD,e.data));
            }
         }
         else if(resp.hasOwnProperty("setLDProperties"))
         {
            if(!this.hasEventListener(HMIRequestEvent.SET_PROP_LD))
            {
               this.navSendSetPropertiesResponse(resp.setLDProperties.type,false);
            }
            else
            {
               this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.SET_PROP_LD,e.data));
            }
         }
         else if(resp.hasOwnProperty("acceptLDProperties"))
         {
            this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.ACCEPT_PROP_LD,e.data));
         }
         else if(resp.hasOwnProperty("routeGuidanceStatus"))
         {
            if(!this.hasEventListener(HMIRequestEvent.GET_GUIDANCE_STATE))
            {
               this.navSendRouteGuidanceStatusResponse("inactive");
            }
            else
            {
               this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.GET_GUIDANCE_STATE));
            }
         }
         else if(resp.hasOwnProperty("setNavRepeatPrompt"))
         {
            if(!this.hasEventListener(HMIRequestEvent.SET_NAV_REPEAT_PROMPT))
            {
               this.navSendSetNavRepeatPromptResponse(false);
            }
            else
            {
               this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.SET_NAV_REPEAT_PROMPT));
            }
         }
         else if(resp.hasOwnProperty("setAppVisible"))
         {
            this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.SET_APP_VISIBLE,e.data));
         }
         else if(resp.hasOwnProperty("gotoPhoneScreen"))
         {
            dispatchEvent(new VoiceRecognitionEvent(VoiceRecognitionEvent.VR_GOTO,{"videoScreen":VoiceRecognition.getInstance().PHONE_CONNECT}));
         }
         else if(resp.hasOwnProperty("switchToDriveMode"))
         {
            dispatchEvent(new HMIRequestEvent(HMIRequestEvent.SWITCH_TO_DRIVEMODE));
         }
         else if(resp.hasOwnProperty("gotoRunningAppsScreen"))
         {
            dispatchEvent(new AppManagerEvent(AppManagerEvent.APP_REQUEST_RUNNING_SCREEN));
         }
         else if(resp.hasOwnProperty("assistRequest"))
         {
            dispatchEvent(new AppManagerEvent(AppManagerEvent.ASSIST_REQUEST));
            this.assistRequestReturnResult();
         }
         else if(resp.hasOwnProperty("InsightStart"))
         {
            this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.INSIGHT_START,e.data.InsightStart.filepath));
         }
         else if(resp.hasOwnProperty("ActivateTestSupport"))
         {
            this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.AUTOMATION_TEST_ACTIVATE));
         }
         else if(resp.hasOwnProperty("DeActivateTestSupport"))
         {
            this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.AUTOMATION_TEST_DEACTIVATE));
         }
         else if(resp.hasOwnProperty("ScreenInspect"))
         {
            if(e.data.ScreenInspect.hasOwnProperty("filepath"))
            {
               filepath = e.data.ScreenInspect.filepath;
            }
            this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.AUTOMATION_INSPECT,filepath));
         }
         else if(resp.hasOwnProperty("mediaInsert"))
         {
            this.dispatchEvent(new HMIRequestEvent(HMIRequestEvent.MEDIA_INSERT,e.data));
         }
         else if(resp.hasOwnProperty("updateHMIVolume"))
         {
            success = false;
            if(resp.updateHMIVolume.hasOwnProperty("volume"))
            {
               if(e.data.updateHMIVolume.volume >= 0 && e.data.updateHMIVolume.volume <= 38)
               {
                  AudioSettings.getInstance().volumeConfirmationValue = e.data.updateHMIVolume.volume;
                  success = true;
               }
            }
            this.hmiSendUpdateVolumeResponse(success);
         }
      }
   }
}

