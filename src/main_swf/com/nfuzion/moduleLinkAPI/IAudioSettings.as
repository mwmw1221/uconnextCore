package com.nfuzion.moduleLinkAPI
{
   public interface IAudioSettings extends IModule
   {
      function requestVolume(param1:String = null) : void;
      
      function get volumeRaw() : Number;
      
      function set volumeRaw(param1:Number) : void;
      
      function set HWVolumeRelative(param1:int) : void;
      
      function set volumeConfirmationValue(param1:Number) : void;
      
      function set volumePopupIsActive(param1:Boolean) : void;
      
      function requestMute() : void;
      
      function setMute(param1:Boolean) : void;
      
      function get mute() : Boolean;
      
      function setSHFMicMute(param1:Boolean) : void;
      
      function get SHFMicMute() : Boolean;
      
      function requestBalance() : void;
      
      function setBalanceFade(param1:Number, param2:Number) : void;
      
      function requestBalanceFade() : void;
      
      function setBalance(param1:Number) : void;
      
      function get balance() : Number;
      
      function requestFade() : void;
      
      function setFade(param1:Number) : void;
      
      function get fade() : Number;
      
      function requestBass() : void;
      
      function setBass(param1:Number) : void;
      
      function get bass() : Number;
      
      function requestTreble() : void;
      
      function setTreble(param1:Number) : void;
      
      function get treble() : Number;
      
      function requestMid() : void;
      
      function setMid(param1:Number) : void;
      
      function get mid() : Number;
      
      function requestSpeedVolume() : void;
      
      function setSpeedVolume(param1:Number) : void;
      
      function get speedVolume() : Number;
      
      function requestSurroundSoundAvailable() : void;
      
      function setSurroundSoundAvailable(param1:Boolean) : void;
      
      function requestSurroundSoundStatus() : void;
      
      function setSurroundSoundStatus(param1:Boolean) : void;
      
      function get surroundSoundAvailable() : Boolean;
      
      function get surroundSoundStatus() : Boolean;
      
      function requestLoudness() : void;
      
      function setLoudness(param1:Boolean) : void;
      
      function get Loudness() : Boolean;
      
      function get twoChannelMode() : Boolean;
      
      function get boosterAmpPresent() : Boolean;
      
      function get interruptStatus() : Boolean;
      
      function getInterruptStatus() : void;
   }
}

