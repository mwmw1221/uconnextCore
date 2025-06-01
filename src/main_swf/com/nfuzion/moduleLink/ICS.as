package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.ICSEvent;
   import com.nfuzion.moduleLinkAPI.IICS;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class ICS extends Module implements IICS
   {
      private static var instance:ICS;
      
      private static const dbusIdentifier:String = "ICS";
      
      private var connection:Connection;
      
      private var client:Client;
      
      private var mReportEncoder:Boolean = false;
      
      private var mReportSelect:Boolean = false;
      
      public function ICS()
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
         this.connection.addEventListener(ConnectionEvent.ICS,this.messageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : ICS
      {
         if(instance == null)
         {
            instance = new ICS();
         }
         return instance;
      }
      
      override protected function subscribe(signalName:String) : void
      {
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      private function messageHandler(e:ConnectionEvent) : void
      {
         var processed:Boolean = false;
         var ics:Object = e.data;
         if(Boolean(ics.hasOwnProperty("UpdateVolume")) && Boolean(ics.UpdateVolume.hasOwnProperty("vol")))
         {
            if(ics.UpdateVolume.vol != 0)
            {
               AudioSettings.getInstance().HWVolumeRelative = ics.UpdateVolume.vol;
            }
         }
         if(ics.hasOwnProperty("key"))
         {
            if(ics.key.pressed == false)
            {
               if(ics.key.key == "enter")
               {
                  this.dispatchEvent(new ICSEvent(ICSEvent.SELECT));
               }
               else
               {
                  this.dispatchEvent(new ICSEvent(ics.key.key));
               }
            }
            else if(ics.key.pressed == true)
            {
               if(ics.key.key == "dealerMode")
               {
                  this.dispatchEvent(new ICSEvent(ICSEvent.DEALER_MODE));
               }
               if(ics.key.key == "engineerMode")
               {
                  this.dispatchEvent(new ICSEvent(ICSEvent.ENGINEERING_MODE));
               }
               if(ics.key.key == "enter_2s")
               {
                  this.dispatchEvent(new ICSEvent(ICSEvent.SELECT_2SEC_PRESS));
               }
               if(ics.key.key == "ICS_launch_hardbtn_status")
               {
                  this.dispatchEvent(new ICSEvent(ICSEvent.LAUNCH));
               }
            }
         }
         if(ics.hasOwnProperty("knob"))
         {
            switch(ics.knob.knob)
            {
               case 2:
                  this.dispatchEncoder(ics.knob.value);
            }
         }
      }
      
      public function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendSubscribe("UpdateVolume");
            this.sendSubscribe("knob");
            this.sendSubscribe("key");
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      public function getSelect() : void
      {
      }
      
      public function get select() : Boolean
      {
         return false;
      }
      
      public function sendScreenOffSKPressed() : void
      {
         var message:String = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"ICS\", \"packet\": { \"SimScrnOffHKPress\": {}}}";
         this.client.send(message);
      }
      
      private function dispatchEncoder(delta:int) : void
      {
         var newEvent:ICSEvent = null;
         if(delta != 0)
         {
            newEvent = new ICSEvent(ICSEvent.ENCODER,delta);
            newEvent.delta = delta;
            this.dispatchEvent(newEvent);
         }
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
   }
}

