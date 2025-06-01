package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.ConnectionManagerEvent;
   import com.harman.moduleLinkAPI.DisplayManagerEvent;
   import com.harman.moduleLinkAPI.IDisplayManager;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class DisplayManager extends Module implements IDisplayManager
   {
      private static var instance:DisplayManager;
      
      private static const dbusIdentifier:String = "DisplayManager";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mBusy:Boolean = true;
      
      private var mConnected:Boolean = false;
      
      private var mPrevLayer:String = "";
      
      private var mCurrentLayer:String = "";
      
      public function DisplayManager()
      {
         super();
         this.init();
      }
      
      public static function getInstance() : DisplayManager
      {
         if(instance == null)
         {
            instance = new DisplayManager();
         }
         return instance;
      }
      
      private function init() : void
      {
         this.mBusy = true;
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.DISPLAY_MANAGER,this.displayMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.mConnected = true;
               this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
               this.sendEvent(DisplayManagerEvent.DISPLAY_BUSY);
            }
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new ConnectionManagerEvent(eventType));
      }
      
      public function getDisplayBusy() : void
      {
         this.sendEvent(DisplayManagerEvent.DISPLAY_BUSY);
      }
      
      public function get DisplayBusy() : Boolean
      {
         return this.mBusy;
      }
      
      public function getCurrentLayer() : String
      {
         return this.mCurrentLayer;
      }
      
      public function getPrevLayer() : String
      {
         return this.mPrevLayer;
      }
      
      public function requestDisplay(requester:String, show:Boolean) : void
      {
         this.mPrevLayer = this.mCurrentLayer;
         this.mCurrentLayer = requester;
         var message:* = "{\"Type\":\"Command\", \"Dest\":\"DisplayManager\",\"packet\":{\"requestDisplay\":{\"requester\":\"" + requester + "\",\"value\":\"" + (show ? "true" : "false") + "\"}}}";
         this.client.send(message);
      }
      
      public function displayMessageHandler(e:ConnectionEvent) : void
      {
         var resp:Object = e.data;
         if(resp.hasOwnProperty("requestDisplay"))
         {
            if(resp.requestDisplay.hasOwnProperty("granted"))
            {
               dispatchEvent(new DisplayManagerEvent(DisplayManagerEvent.DISPLAY_REQUEST_RESPONSE,e.data));
            }
            if(!resp.requestDisplay.hasOwnProperty("status"))
            {
            }
         }
      }
   }
}

