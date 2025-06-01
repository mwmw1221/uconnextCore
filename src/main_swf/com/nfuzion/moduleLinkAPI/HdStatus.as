package com.nfuzion.moduleLinkAPI
{
   public class HdStatus
   {
      public static const HD_ANALOG_AUDIO:String = "analog audio";
      
      public static const HD_BUFFERING:String = "digital audio buffering";
      
      public static const HD_DIGITAL_AUDIO:String = "hd digital audio";
      
      public static const HD_MODE_OFF:String = "hd off";
      
      public static const HD_BALLGAME_MODE:String = "hd ballgame active";
      
      public static const HD_STATUS_UNINITIALIZED:String = "hd status uinitialized";
      
      private static var acquisitionBit:uint = 1;
      
      private static var sisCRCBit:uint = 2;
      
      private static var digitalAudioBit:uint = 4;
      
      private static var modeBit:uint = 8;
      
      private static var ballgameBit:uint = 16;
      
      private static var statusChange:uint = 0;
      
      public var acquisitionStatus:uint = 0;
      
      public var sisCrcStatus:uint = 0;
      
      public var digitalAudioAcquired:uint = 0;
      
      public var hdMode:uint = 0;
      
      public var ballgameMode:uint = 0;
      
      public var hdStatusMsg:String = "analog audio";
      
      public function HdStatus()
      {
         super();
      }
      
      public function updateHDStatus(newHDStatus:Object) : HdStatus
      {
         statusChange = 0;
         if(newHDStatus.hasOwnProperty("acquisitionStatus"))
         {
            this.acquisitionStatus = newHDStatus.acquisitionStatus;
            if(newHDStatus.acquisitionStatus)
            {
               statusChange |= acquisitionBit;
            }
         }
         if(newHDStatus.hasOwnProperty("sisCrcStatus"))
         {
            this.sisCrcStatus = newHDStatus.sisCrcStatus;
            if(newHDStatus.sisCrcStatus)
            {
               statusChange |= sisCRCBit;
            }
         }
         if(newHDStatus.hasOwnProperty("digitalAudioAcquired"))
         {
            this.digitalAudioAcquired = newHDStatus.digitalAudioAcquired;
            if(newHDStatus.digitalAudioAcquired)
            {
               statusChange |= digitalAudioBit;
            }
         }
         if(newHDStatus.hasOwnProperty("hdMode"))
         {
            this.hdMode = newHDStatus.hdMode;
            if(this.hdMode)
            {
               statusChange |= modeBit;
            }
         }
         if(newHDStatus.hasOwnProperty("ballgameMode"))
         {
            this.ballgameMode = newHDStatus.ballgameMode;
            if(this.ballgameMode)
            {
               statusChange |= ballgameBit;
            }
         }
         switch(statusChange)
         {
            case 1:
            case 3:
            case 7:
               this.hdStatusMsg = HD_MODE_OFF;
               break;
            case 0:
            case 8:
               this.hdStatusMsg = HD_ANALOG_AUDIO;
               break;
            case 9:
            case 11:
               this.hdStatusMsg = HD_BUFFERING;
               break;
            case 13:
            case 15:
               this.hdStatusMsg = HD_DIGITAL_AUDIO;
               break;
            case 31:
               this.hdStatusMsg = HD_BALLGAME_MODE;
         }
         return this;
      }
   }
}

