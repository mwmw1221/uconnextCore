package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.AudioEvent;
   import com.nfuzion.moduleLinkAPI.IAudioSettings;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   
   public class AudioSettings extends Module implements IAudioSettings
   {
      private static var instance:AudioSettings;
      
      private const dbusIdentifier:String = "AudioSettings";
      
      private const dBusAudioSurroundSoundStatus:String = "surroundSoundStatus";
      
      private const dBusAudioSurroundSoundAvailable:String = "surroundSoundAvailable";
      
      private const dBusAudioSpeedVolume:String = "speedAdjustedVolume";
      
      private const dBusGetAudioSpeedVolume:String = "getSpeedAdjustedVolume";
      
      private const dBusBalanceFade:String = "balanceFade";
      
      private const dbusGetBalanceFade:String = "getBalanceFade";
      
      private const dBusEq:String = "equalizer";
      
      private const dBusGetEq:String = "getEqualizer";
      
      private const dBusMute:String = "mute";
      
      private const dBusUnmute:String = "unmute";
      
      private const dBusGetMute:String = "getMute";
      
      private const dBusVolume:String = "volume";
      
      private const dBusGetVolume:String = "getVolume";
      
      private const dBusInterrruptStatus:String = "interruptStatus";
      
      private const dBusreadyStatus:String = "ready";
      
      private const dBusGetReadyStatus:String = "getReady";
      
      private const dBusGetBoosterAmp:String = "getBoosterAmp";
      
      private const dBusGetTwoChannel:String = "getTwoChannel";
      
      private const dBusTwoChannel:String = "two_channel";
      
      private const dBusBoosterAmp:String = "booster_amp";
      
      private const SCALE_VOLUME:uint = 38;
      
      private const SCALE_BALANCE_FADE:uint = 10;
      
      private const SCALE_EQ:uint = 9;
      
      private const SCALE_SPEED_VOLUME:uint = 4;
      
      private const VOLUME_CAP_0:Number = 38;
      
      private const VOLUME_CAP_1:Number = 20;
      
      private const VOLUME_CAP_2:Number = 0;
      
      private var mAudioSettingRead:Boolean = false;
      
      private var mBalance:Number = 0;
      
      private var mFade:Number = 0;
      
      private var mVolumeRaw:Number = 0;
      
      private var mVolumeConfirmation:Number = 0;
      
      private var mMute:Boolean;
      
      private var mSHFMicMute:Boolean = false;
      
      private var mSurroundSoundAvailable:Boolean = false;
      
      private var mSurroundSoundStatus:Boolean = false;
      
      private var mSpeedVolume:Number;
      
      private var mLoudness:Boolean;
      
      private var mVolumeCapped:Number = 38;
      
      private var mSourceVolumes:Vector.<Number>;
      
      private var mInterruptStatus:Boolean = false;
      
      private var mSuppressVolumeUpdates:Boolean = false;
      
      private var mBass:Number;
      
      private var mMid:Number;
      
      private var mTreble:Number;
      
      private var mTwoChannelMode:Boolean = false;
      
      private var mBoosterAmpPresent:Boolean = false;
      
      private var client:Client;
      
      private var connection:Connection;
      
      public function AudioSettings()
      {
         super();
         this.mSourceVolumes = new Vector.<Number>();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.AUDIOSETTINGS,this.messageHandler);
         this.sendSubscribe(this.dBusreadyStatus);
         this.requestGetReady();
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      public static function getInstance() : AudioSettings
      {
         if(instance == null)
         {
            instance = new AudioSettings();
         }
         return instance;
      }
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case AudioEvent.BALANCEFADE:
               this.sendSubscribe(this.dBusBalanceFade);
               break;
            case AudioEvent.EQUALIZER:
               this.sendSubscribe(this.dBusEq);
               break;
            case AudioEvent.MUTE:
               this.sendSubscribe(this.dBusMute);
               break;
            case AudioEvent.SPEED:
               this.sendSubscribe(this.dBusAudioSpeedVolume);
               break;
            case AudioEvent.SURROUNDSOUNDSTATUS:
               this.sendSubscribe(this.dBusAudioSurroundSoundStatus);
               break;
            case AudioEvent.SURROUNDSOUNDAVAILABLE:
               this.sendSubscribe(this.dBusAudioSurroundSoundAvailable);
               break;
            case AudioEvent.VOLUME:
               this.sendSubscribe(this.dBusVolume);
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case AudioEvent.BALANCEFADE:
               this.sendUnsubscribe(this.dBusBalanceFade);
               break;
            case AudioEvent.EQUALIZER:
               this.sendUnsubscribe(this.dBusEq);
               break;
            case AudioEvent.MUTE:
               this.sendUnsubscribe(this.dBusMute);
               break;
            case AudioEvent.SPEED:
               this.sendUnsubscribe(this.dBusAudioSpeedVolume);
               break;
            case AudioEvent.SURROUNDSOUNDSTATUS:
               this.sendUnsubscribe(this.dBusAudioSurroundSoundStatus);
               break;
            case AudioEvent.SURROUNDSOUNDAVAILABLE:
               this.sendUnsubscribe(this.dBusAudioSurroundSoundAvailable);
               break;
            case AudioEvent.VOLUME:
               this.sendUnsubscribe(this.dBusVolume);
         }
      }
      
      override public function isReady() : Boolean
      {
         return Boolean(this.connection.configured) && Boolean(this.client.connected);
      }
      
      public function requestVolume(source:String = null) : void
      {
         this.sendCommand("getVolume","","");
      }
      
      public function set HWVolumeRelative(step:int) : void
      {
         this.mVolumeRaw = this.checkWithCap(this.mVolumeRaw + step);
         this.mVolumeConfirmation = this.mVolumeRaw;
         this.dispatchEvent(new AudioEvent(AudioEvent.VOLUME));
         if(this.mute != this.mMute)
         {
            this.dispatchEvent(new AudioEvent(AudioEvent.MUTE));
         }
      }
      
      public function get volumeRaw() : Number
      {
         return this.mVolumeRaw;
      }
      
      public function set volumeRaw(value:Number) : void
      {
         value = this.checkWithCap(value);
         this.sendCommand("setVolume","volume",value);
         if(this.mMute && value != 0)
         {
            this.sendCommand("setMute","mute",false);
         }
      }
      
      public function requestMute() : void
      {
         this.sendCommand("getMute","","");
      }
      
      public function setMute(status:Boolean) : void
      {
         if(status != this.mMute)
         {
            this.sendCommand("setMute","mute",status);
         }
      }
      
      public function setSHFMicMute(status:Boolean) : void
      {
         if(status && !this.mSHFMicMute)
         {
            this.sendCommand("setSHFMicMute","mute",true);
         }
         else if(!status && this.mSHFMicMute)
         {
            this.sendCommand("setSHFMicMute","mute",false);
         }
      }
      
      public function get SHFMicMute() : Boolean
      {
         return this.mSHFMicMute;
      }
      
      private function setHWMute(mute:Boolean) : void
      {
         this.mMute = mute;
      }
      
      public function get mute() : Boolean
      {
         return this.mMute;
      }
      
      public function requestBalance() : void
      {
         this.requestBalanceFade();
      }
      
      public function setBalance(balance:Number) : void
      {
         var oldHw:int = this.mBalance * this.SCALE_BALANCE_FADE;
         this.mBalance = this.limitFullRange(this.roundToPrecision(balance,2));
         var hwBalance:int = this.mBalance * this.SCALE_BALANCE_FADE;
         if(oldHw != hwBalance)
         {
            this.sendCommand("setBalanceFade","balance",hwBalance);
         }
      }
      
      private function setHWBalance(balance:int) : void
      {
         this.mBalance = this.checkWithScale(balance,this.mBalance,this.SCALE_BALANCE_FADE);
      }
      
      public function get balance() : Number
      {
         return this.mBalance;
      }
      
      public function requestGetReady() : void
      {
         this.sendCommand("getReady","","");
      }
      
      public function requestBalanceFade() : void
      {
         this.sendCommand("getBalanceFade","","");
      }
      
      public function setBalanceFade(balance:Number, fade:Number) : void
      {
         var message:String = null;
         var oldHwFade:int = this.mFade * this.SCALE_BALANCE_FADE;
         var oldHwBalance:int = this.mBalance * this.SCALE_BALANCE_FADE;
         this.mBalance = this.limitFullRange(this.roundToPrecision(balance,2));
         var hwBalance:int = this.mBalance * this.SCALE_BALANCE_FADE;
         this.mFade = this.limitFullRange(this.roundToPrecision(fade,2));
         var hwFade:int = this.mFade * this.SCALE_BALANCE_FADE;
         if(hwFade != oldHwFade || hwBalance != oldHwBalance)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
            message += "\", \"packet\": { \"" + "setBalanceFade";
            message += "\": { \"" + "balance" + "\": " + hwBalance.toString();
            message += ", \"" + "fade" + "\": " + hwFade.toString() + "}}}";
            this.client.send(message);
         }
      }
      
      public function requestFade() : void
      {
         this.requestBalanceFade();
      }
      
      public function setFade(fade:Number) : void
      {
         var oldHw:int = this.mFade * this.SCALE_BALANCE_FADE;
         this.mFade = this.limitFullRange(this.roundToPrecision(fade,2));
         var hwFade:int = this.mFade * this.SCALE_BALANCE_FADE;
         if(oldHw != hwFade)
         {
            this.sendCommand("setBalanceFade","fade",hwFade);
         }
      }
      
      public function requestLoudness() : void
      {
         this.sendCommand("getLoudness","","");
      }
      
      public function setLoudness(status:Boolean) : void
      {
         this.sendCommand("setLoudness","loudness",status);
      }
      
      public function get Loudness() : Boolean
      {
         return this.mLoudness;
      }
      
      private function roundToPrecision(numberVal:Number, precision:int = 0) : Number
      {
         var decimalPlaces:Number = Math.pow(10,precision);
         return Math.round(decimalPlaces * numberVal) / decimalPlaces;
      }
      
      private function setHWFade(fade:int) : void
      {
         this.mFade = this.checkWithScale(fade,this.mFade,this.SCALE_BALANCE_FADE);
      }
      
      public function get fade() : Number
      {
         return this.mFade;
      }
      
      public function requestEqualizer() : void
      {
         this.sendCommand("getEqualizer","","");
      }
      
      public function requestBass() : void
      {
         this.requestEqualizer();
      }
      
      public function setBass(bass:Number) : void
      {
         var oldHw:int = this.mBass * this.SCALE_EQ;
         this.mBass = this.limitFullRange(bass);
         var hwBass:int = this.mBass * this.SCALE_EQ;
         if(oldHw != hwBass)
         {
            this.sendCommand("setEqualizer","bass",hwBass);
         }
      }
      
      private function setHWBass(bass:uint) : void
      {
         this.mBass = this.checkWithScale(bass,this.mBass,this.SCALE_EQ);
      }
      
      public function get bass() : Number
      {
         return this.mBass;
      }
      
      public function requestTreble() : void
      {
         this.requestEqualizer();
      }
      
      public function setTreble(treble:Number) : void
      {
         var oldHw:int = this.mTreble * this.SCALE_EQ;
         this.mTreble = this.limitFullRange(treble);
         var hwTreble:int = this.mTreble * this.SCALE_EQ;
         if(oldHw != hwTreble)
         {
            this.sendCommand("setEqualizer","treble",hwTreble);
         }
      }
      
      private function setHWTreble(treble:uint) : void
      {
         this.mTreble = this.checkWithScale(treble,this.mTreble,this.SCALE_EQ);
      }
      
      public function get treble() : Number
      {
         return this.mTreble;
      }
      
      public function requestMid() : void
      {
         this.requestEqualizer();
      }
      
      public function setMid(mid:Number) : void
      {
         var oldHw:int = this.mMid * this.SCALE_EQ;
         this.mMid = this.limitFullRange(mid);
         var hwMid:int = this.mMid * this.SCALE_EQ;
         if(oldHw != hwMid)
         {
            this.sendCommand("setEqualizer","mid",hwMid);
         }
      }
      
      private function setHWMid(mid:uint) : void
      {
         this.mMid = this.checkWithScale(mid,this.mMid,this.SCALE_EQ);
      }
      
      public function get mid() : Number
      {
         return this.mMid;
      }
      
      public function requestSurroundSoundAvailable() : void
      {
         this.sendCommand("getSurroundSoundAvailable","","");
      }
      
      public function requestTwoChannel() : void
      {
         this.sendCommand("getTwoChannel","","");
      }
      
      public function requestBoosterAmp() : void
      {
         this.sendCommand("getBoosterAmp","","");
      }
      
      public function setSurroundSoundAvailable(avail:Boolean) : void
      {
         var message:String = null;
         if(false == avail)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
            message += "\", \"packet\": { \"" + "setSurroundSoundAvailable";
            message += "\": { \"" + "on" + "\": " + false + "}}}";
            this.client.send(message);
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
            message += "\", \"packet\": { \"" + "setSurroundSoundAvailable";
            message += "\": { \"" + "on" + "\": " + true + "}}}";
            this.client.send(message);
         }
      }
      
      public function requestSurroundSoundStatus() : void
      {
         this.sendCommand("getSurroundSoundStatus","","");
      }
      
      public function setSurroundSoundStatus(status:Boolean) : void
      {
         var message:String = null;
         if(false == status)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
            message += "\", \"packet\": { \"" + "setSurroundSoundStatus";
            message += "\": { \"" + "on" + "\": " + false + "}}}";
            this.client.send(message);
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
            message += "\", \"packet\": { \"" + "setSurroundSoundStatus";
            message += "\": { \"" + "on" + "\": " + true + "}}}";
            this.client.send(message);
         }
      }
      
      private function setSurroundSoundAvail(avail:Boolean) : void
      {
         this.mSurroundSoundAvailable = avail;
      }
      
      public function get surroundSoundAvailable() : Boolean
      {
         return this.mSurroundSoundAvailable;
      }
      
      private function setSurroundSound(on:Boolean) : void
      {
         this.mSurroundSoundStatus = on;
      }
      
      public function get surroundSoundStatus() : Boolean
      {
         return this.mSurroundSoundStatus;
      }
      
      public function requestSpeedVolume() : void
      {
         this.sendCommand("getSpeedAdjustedVolume","","");
      }
      
      public function setSpeedVolume(percent:Number) : void
      {
         var message:String = null;
         var oldHw:uint = this.mSpeedVolume * this.SCALE_SPEED_VOLUME;
         this.mSpeedVolume = this.limitHalfRange(percent);
         var hwSetting:uint = this.mSpeedVolume * this.SCALE_SPEED_VOLUME;
         if(oldHw != hwSetting)
         {
            if(0 == this.mSpeedVolume)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
               message += "\", \"packet\": { \"" + "setSpeedAdjustedVolume";
               message += "\": { \"" + "on" + "\": " + false;
               message += ", \"" + "variance" + "\": 0 }}}";
               this.client.send(message);
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier;
               message += "\", \"packet\": { \"" + "setSpeedAdjustedVolume";
               message += "\": { \"" + "on" + "\": " + true;
               message += ", \"" + "variance" + "\": " + hwSetting.toString() + "}}}";
               this.client.send(message);
            }
         }
      }
      
      public function get twoChannelMode() : Boolean
      {
         return this.mTwoChannelMode;
      }
      
      public function get boosterAmpPresent() : Boolean
      {
         return this.mBoosterAmpPresent;
      }
      
      private function setHWSpeedVolume(on:Boolean, variance:uint) : void
      {
         if(on)
         {
            this.mSpeedVolume = this.checkWithScale(variance,this.mSpeedVolume,this.SCALE_SPEED_VOLUME);
         }
         else
         {
            this.mSpeedVolume = 0;
         }
      }
      
      public function get speedVolume() : Number
      {
         return this.mSpeedVolume;
      }
      
      public function get interruptStatus() : Boolean
      {
         return this.mInterruptStatus;
      }
      
      private function checkWithScale(value:int, oldValue:Number, scale:int) : Number
      {
         var scaledOld:int = oldValue * scale;
         if(value != scaledOld)
         {
            return Number(value / scale);
         }
         return oldValue;
      }
      
      private function checkWithCap(value:Number) : Number
      {
         if(value < 0)
         {
            return 0;
         }
         if(value > this.mVolumeCapped)
         {
            return this.mVolumeCapped;
         }
         return value;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendSubscribe("MuteValue");
            this.sendSubscribe(this.dBusInterrruptStatus);
            this.sendSubscribe("loudness");
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
            this.sendSubscribe("volumeCapped");
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function limitFullRange(val:Number) : Number
      {
         if(val > 1)
         {
            return 1;
         }
         if(val < -1)
         {
            return -1;
         }
         return val;
      }
      
      private function limitHalfRange(val:Number) : Number
      {
         if(val > 1)
         {
            return 1;
         }
         if(val < 0)
         {
            return 0;
         }
         return val;
      }
      
      private function sendCommand(commandName:String, valueName:String, value:Object) : void
      {
         var message:* = null;
         if(value is String)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + this.dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value.toString() + "}}}";
         }
         this.client.send(message);
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + this.dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + this.dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      public function getInterruptStatus() : void
      {
         this.dispatchEvent(new AudioEvent(AudioEvent.INTERRUPT_STATUS));
      }
      
      public function set volumeConfirmationValue(value:Number) : void
      {
         this.mVolumeConfirmation = value;
         if(this.mSuppressVolumeUpdates == false)
         {
            this.mVolumeRaw = this.mVolumeConfirmation;
         }
      }
      
      public function set volumePopupIsActive(active:Boolean) : void
      {
         if(this.mSuppressVolumeUpdates != active)
         {
            if(true != active)
            {
               this.mVolumeRaw = this.mVolumeConfirmation;
            }
            this.mSuppressVolumeUpdates = active;
         }
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var bass:Number = NaN;
         var mid:Number = NaN;
         var treb:Number = NaN;
         var mute:Boolean = false;
         var audioSetting:Object = e.data;
         if(audioSetting.hasOwnProperty(this.dBusreadyStatus))
         {
            if(audioSetting[this.dBusreadyStatus][this.dBusreadyStatus] == "true")
            {
               if(this.mAudioSettingRead == false)
               {
                  this.mAudioSettingRead == true;
                  this.requestSurroundSoundAvailable();
                  this.requestSurroundSoundStatus();
                  this.requestBalanceFade();
                  this.requestSpeedVolume();
                  this.requestBass();
                  this.requestTwoChannel();
                  this.requestBoosterAmp();
               }
            }
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetReadyStatus))
         {
            if(audioSetting[this.dBusGetReadyStatus][this.dBusreadyStatus] == "true")
            {
               if(this.mAudioSettingRead == false)
               {
                  this.mAudioSettingRead = true;
                  this.requestSurroundSoundAvailable();
                  this.requestSurroundSoundStatus();
                  this.requestBalanceFade();
                  this.requestSpeedVolume();
                  this.requestBass();
                  this.requestTwoChannel();
                  this.requestBoosterAmp();
               }
            }
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetBoosterAmp))
         {
            this.mBoosterAmpPresent = audioSetting.getBoosterAmp.booster_amp;
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetTwoChannel))
         {
            this.mTwoChannelMode = audioSetting.getTwoChannel.two_channel;
         }
         else if(audioSetting.hasOwnProperty(this.dBusAudioSpeedVolume))
         {
            if(0 == audioSetting.speedAdjustedVolume.variance || false == audioSetting.speedAdjustedVolume.on)
            {
               this.setHWSpeedVolume(false,0);
            }
            else
            {
               this.setHWSpeedVolume(audioSetting.speedAdjustedVolume.on,audioSetting.speedAdjustedVolume.variance);
            }
            this.dispatchEvent(new AudioEvent(AudioEvent.SPEED));
         }
         else if(audioSetting.hasOwnProperty("volumeCapped"))
         {
            switch(audioSetting.volumeCapped.volumeCappedValue)
            {
               case 0:
                  this.mVolumeCapped = this.VOLUME_CAP_0;
                  break;
               case 1:
                  this.mVolumeCapped = this.VOLUME_CAP_1;
                  break;
               case 2:
                  this.mVolumeCapped = this.VOLUME_CAP_2;
            }
            this.dispatchEvent(new AudioEvent(AudioEvent.VOLUME));
         }
         else if(audioSetting.hasOwnProperty("getSurroundSoundAvailable"))
         {
            if(audioSetting.getSurroundSoundAvailable.on != null)
            {
               this.setSurroundSoundAvail(audioSetting.getSurroundSoundAvailable.on);
            }
         }
         else if(audioSetting.hasOwnProperty("getLoudness"))
         {
            this.mLoudness = audioSetting.getLoudness.loudness;
            dispatchEvent(new AudioEvent(AudioEvent.LOUDNESS));
         }
         else if(audioSetting.hasOwnProperty("loudness"))
         {
            this.mLoudness = audioSetting.loudness.loudness;
            dispatchEvent(new AudioEvent(AudioEvent.LOUDNESS));
         }
         else if(audioSetting.hasOwnProperty(this.dBusAudioSurroundSoundAvailable))
         {
            if(false == audioSetting.surroundSoundAvailable.on)
            {
               this.setSurroundSoundAvail(false);
            }
            else
            {
               this.setSurroundSoundAvail(true);
            }
            this.dispatchEvent(new AudioEvent(AudioEvent.SURROUNDSOUNDAVAILABLE));
         }
         else if(audioSetting.hasOwnProperty(this.dBusAudioSurroundSoundStatus))
         {
            if(false == audioSetting.surroundSoundStatus.on)
            {
               this.setSurroundSound(false);
            }
            else
            {
               this.setSurroundSound(true);
            }
            this.dispatchEvent(new AudioEvent(AudioEvent.SURROUNDSOUNDSTATUS));
         }
         else if(audioSetting.hasOwnProperty("getSurroundSoundStatus"))
         {
            if(audioSetting.getSurroundSoundStatus.on != null)
            {
               this.setSurroundSound(audioSetting.getSurroundSoundStatus.on);
            }
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetAudioSpeedVolume))
         {
            if(0 == audioSetting.getSpeedAdjustedVolume.variance || false == audioSetting.getSpeedAdjustedVolume.on)
            {
               this.setHWSpeedVolume(false,0);
            }
            else
            {
               this.setHWSpeedVolume(audioSetting.getSpeedAdjustedVolume.on,audioSetting.getSpeedAdjustedVolume.variance);
            }
            this.dispatchEvent(new AudioEvent(AudioEvent.SPEED));
         }
         if(audioSetting.hasOwnProperty(this.dBusBalanceFade))
         {
            if(audioSetting.balanceFade.hasOwnProperty("balance"))
            {
               this.setHWBalance(audioSetting.balanceFade.balance);
            }
            if(audioSetting.balanceFade.hasOwnProperty("fade"))
            {
               this.setHWFade(audioSetting.balanceFade.fade);
            }
            this.dispatchEvent(new AudioEvent(AudioEvent.BALANCEFADE));
         }
         else if(audioSetting.hasOwnProperty(this.dbusGetBalanceFade))
         {
            this.setHWBalance(audioSetting.getBalanceFade.balance);
            this.setHWFade(audioSetting.getBalanceFade.fade);
            this.dispatchEvent(new AudioEvent(AudioEvent.BALANCEFADE));
         }
         if(audioSetting.hasOwnProperty(this.dBusEq))
         {
            bass = this.mBass;
            mid = this.mMid;
            treb = this.mTreble;
            if(audioSetting.equalizer.hasOwnProperty("bass"))
            {
               this.setHWBass(audioSetting.equalizer.bass);
            }
            if(audioSetting.equalizer.hasOwnProperty("mid"))
            {
               this.setHWMid(audioSetting.equalizer.mid);
            }
            if(audioSetting.equalizer.hasOwnProperty("treble"))
            {
               this.setHWTreble(audioSetting.equalizer.treble);
            }
            if(bass != this.mBass || this.mMid != mid || this.mTreble != treb)
            {
               this.dispatchEvent(new AudioEvent(AudioEvent.EQUALIZER));
            }
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetEq))
         {
            bass = this.mBass;
            mid = this.mMid;
            treb = this.mTreble;
            this.setHWBass(audioSetting.getEqualizer.bass);
            this.setHWMid(audioSetting.getEqualizer.mid);
            this.setHWTreble(audioSetting.getEqualizer.treble);
            if(bass != this.mBass || this.mMid != mid || this.mTreble != treb)
            {
               this.dispatchEvent(new AudioEvent(AudioEvent.EQUALIZER));
            }
         }
         if(audioSetting.hasOwnProperty(this.dBusVolume))
         {
            mute = this.mMute;
            this.mVolumeRaw = this.checkWithCap(audioSetting.volume.volume);
            this.mVolumeConfirmation = this.mVolumeRaw;
            this.dispatchEvent(new AudioEvent(AudioEvent.VOLUME));
         }
         else if(audioSetting.hasOwnProperty(this.dBusGetVolume))
         {
            mute = this.mMute;
            this.mVolumeRaw = this.checkWithCap(audioSetting.getVolume.volume);
            this.mVolumeConfirmation = this.mVolumeRaw;
            this.dispatchEvent(new AudioEvent(AudioEvent.VOLUME));
            if(mute != this.mMute)
            {
               this.dispatchEvent(new AudioEvent(AudioEvent.MUTE));
            }
         }
         if(audioSetting.hasOwnProperty(this.dBusGetMute))
         {
            this.mMute = audioSetting.getMute.mute;
            this.dispatchEvent(new AudioEvent(AudioEvent.MUTE));
         }
         else if(audioSetting.hasOwnProperty(this.dBusMute))
         {
            this.mMute = true;
            this.dispatchEvent(new AudioEvent(AudioEvent.MUTE));
         }
         else if(audioSetting.hasOwnProperty(this.dBusUnmute))
         {
            this.mMute = false;
            this.dispatchEvent(new AudioEvent(AudioEvent.MUTE));
         }
         if(audioSetting.hasOwnProperty("MuteValue"))
         {
            this.mSHFMicMute = audioSetting.MuteValue.mutevalue;
            this.dispatchEvent(new AudioEvent(AudioEvent.HFMIC));
         }
         if(audioSetting.hasOwnProperty(this.dBusInterrruptStatus))
         {
            this.mInterruptStatus = audioSetting.interruptStatus.active;
            this.dispatchEvent(new AudioEvent(AudioEvent.INTERRUPT_STATUS));
         }
      }
   }
}

