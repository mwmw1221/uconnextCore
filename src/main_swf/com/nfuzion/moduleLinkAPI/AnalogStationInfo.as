package com.nfuzion.moduleLinkAPI
{
   public class AnalogStationInfo
   {
      public var senderName:String = "";
      
      public var pty:String = "";
      
      public var pi:int = 0;
      
      public var frequency:uint = 0;
      
      public var rxQual:uint = 0;
      
      public var waveband:String = "unknown";
      
      public var switches:Array = new Array();
      
      public var isTP:Boolean = false;
      
      public function AnalogStationInfo()
      {
         super();
      }
      
      public function updateAnalalogStationInfo(newAnalogStationInfo:Object) : void
      {
         var swtch:String = null;
         this.senderName = newAnalogStationInfo.senderName;
         this.pty = newAnalogStationInfo.pty;
         this.pi = newAnalogStationInfo.pi;
         this.frequency = int(newAnalogStationInfo.frequency);
         this.rxQual = newAnalogStationInfo.rxQual;
         this.waveband = newAnalogStationInfo.waveband;
         this.isTP = false;
         if(newAnalogStationInfo.switches)
         {
            for each(swtch in newAnalogStationInfo.switches)
            {
               if(swtch == "TP")
               {
                  this.isTP = true;
               }
            }
         }
      }
   }
}

