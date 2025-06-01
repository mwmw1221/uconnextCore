package peripheral
{
   import com.harman.moduleLinkAPI.DABEvent;
   import com.harman.moduleLinkAPI.DMBSeekTypes;
   import com.nfuzion.moduleLinkAPI.AudioEvent;
   import com.nfuzion.moduleLinkAPI.DriveModeSetOption;
   import com.nfuzion.moduleLinkAPI.ICSEvent;
   import com.nfuzion.moduleLinkAPI.ISWCEvent;
   import com.nfuzion.moduleLinkAPI.MediaPlayerTransportAction;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioEvent;
   import com.nfuzion.moduleLinkAPI.TunerEvent;
   import events.HardControlEvent;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import events.WidgetEvent;
   import com.uconnext.Log;
   
   public class HardControls implements IEventDispatcher
   {
      private static var instance:HardControls;
      
      private var eventDispatcher:EventDispatcher = new EventDispatcher();
      
      private var mPriorities:Object = new Object();
      
      private var mStage:DisplayObjectContainer;
      
      private var mEncoderDelta:int = 0;
      
      private var mPressTimer:Timer = new Timer(500);
      
      private var mPress:uint = 0;
      
      private var mSportPress:Boolean = false;
      
      private var mediaICSEnabled:Boolean = false;
      
      public function HardControls()
      {
         super();
         this.mPriorities[HardControlEvent.VERTICAL_SCROLL] = 0;
         this.onSource(null);
         Peripheral.audioManager.addEventListener(AudioEvent.SOURCE,this.onSource);
         Peripheral.tuner.addEventListener(TunerEvent.AVAILABLE,this.onTunerAvailable);
         Peripheral.satelliteRadio.addEventListener(SatelliteRadioEvent.APP_STATUS,this.onSatAvailable);
         Peripheral.dabTunerControl.addEventListener(DABEvent.AVAILABLE,this.onDABAvailable);
         Peripheral.ics.addEventListener(ICSEvent.ENCODER,this.onIcsEncoder);
         Peripheral.ics.addEventListener(ICSEvent.SELECT,this.onIcsSelect);
         Peripheral.ics.addEventListener(ICSEvent.BACK,this.onIcsBack);
         Peripheral.ics.addEventListener(ICSEvent.EXIT,this.onIcsExit);
         Peripheral.ics.addEventListener(ICSEvent.SCREEN_OFF,this.onIcsScreenOff);
         Peripheral.ics.addEventListener(ICSEvent.SELECT_2SEC_PRESS,this.onICSSelectPressAndHold);
         Peripheral.swc.addEventListener(ISWCEvent.PRESET_ADVANCE,this.onSwcPresetAdvance);
         Peripheral.swc.addEventListener(ISWCEvent.MODE_ADVANCE,this.onModeAdvancePressed);
         Peripheral.swc.addEventListener(ISWCEvent.SEEK_PLUS,this.onSeekPlusSWC);
         Peripheral.swc.addEventListener(ISWCEvent.SEEK_MINUS,this.onSeekMinusSWC);
         Peripheral.ics.addEventListener(ICSEvent.RADIO,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.PLAYER,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.NAV,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.PHONE,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.MORE,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.SETTINGS,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.BACK,this.onICSKey);
         Peripheral.ics.addEventListener(ICSEvent.SRT,this.onICSKeySRT);
         Peripheral.ics.addEventListener(ICSEvent.SPORT,this.onICSKeySport);
         this.mPressTimer.addEventListener(TimerEvent.TIMER,this.onICSKeySRTDoubleClick);
      }
      
      public static function getInstance() : HardControls
      {
         if(instance == null)
         {
            instance = new HardControls();
         }
         return instance;
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         return this.eventDispatcher.dispatchEvent(event);
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return this.hasEventListener(type);
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(!this.mPriorities.hasOwnProperty(type))
         {
            this.mPriorities[type] = 0;
         }
         if(type == HardControlEvent.VERTICAL_SCROLL)
         {
            if(this.mPriorities[HardControlEvent.VERTICAL_SCROLL] == 0)
            {
               this.disableICSTuning();
            }
         }
         ++this.mPriorities[type];
         if(priority == 0)
         {
            priority = int(this.mPriorities[type]);
         }
         this.eventDispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         if(!(!this.mPriorities.hasOwnProperty(type) || this.mPriorities[type] <= 0))
         {
            this.eventDispatcher.removeEventListener(type,listener,useCapture);
            --this.mPriorities[type];
            if(type == HardControlEvent.VERTICAL_SCROLL)
            {
               if(this.mPriorities[HardControlEvent.VERTICAL_SCROLL] == 0)
               {
                  this.enableICSTuning();
               }
            }
         }
      }
      
      public function willTrigger(type:String) : Boolean
      {
         return this.willTrigger(type);
      }
      
      private function onSource(e:AudioEvent) : void
      {
         if(!this.enableICSMedia())
         {
            if(this.mPriorities[HardControlEvent.VERTICAL_SCROLL] == 0)
            {
               this.enableICSTuning();
            }
         }
      }
      
      private function onTunerAvailable(e:TunerEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_AM || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_MW || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_FM)
         {
            if(this.mPriorities[HardControlEvent.VERTICAL_SCROLL] == 0)
            {
               this.enableICSTuning();
            }
         }
      }
      
      private function onSatAvailable(e:SatelliteRadioEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_SAT)
         {
            if(this.mPriorities[HardControlEvent.VERTICAL_SCROLL] == 0)
            {
               this.enableICSTuning();
            }
         }
      }
      
      private function onDABAvailable(e:DABEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_DAB)
         {
            if(this.mPriorities[HardControlEvent.VERTICAL_SCROLL] == 0)
            {
               this.enableICSTuning();
            }
         }
      }
      
      private function disableICSTuning() : void
      {
         Peripheral.tuner.setTuneKnobEnabled(false);
         if(Peripheral.satelliteRadio.appStatus == "READY")
         {
            Peripheral.satelliteRadio.requestDisableICSTuning();
         }
         if(Peripheral.vehConfig.dabPresent == true)
         {
            Peripheral.dabApp.requestDisableICSTuning();
         }
      }
      
      private function enableICSMedia() : Boolean
      {
         var changed:Boolean = false;
         if(Peripheral.audioManager.isSourceMediaService() || Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_CD)
         {
            if(!this.mediaICSEnabled)
            {
               changed = true;
               this.mediaICSEnabled = true;
               this.addEventListener(HardControlEvent.VERTICAL_SCROLL,this.onTuneKnob,false,-1000);
            }
         }
         else if(this.mediaICSEnabled)
         {
            changed = true;
            this.mediaICSEnabled = false;
            this.removeEventListener(HardControlEvent.VERTICAL_SCROLL,this.onTuneKnob);
         }
         return changed;
      }
      
      private function enableICSTuning() : void
      {
         switch(Peripheral.audioManager.source)
         {
            case Peripheral.audioManager.SOURCE_SAT:
               Peripheral.tuner.setTuneKnobEnabled(false);
               if(Peripheral.satelliteRadio.appStatus == "READY")
               {
                  Peripheral.satelliteRadio.requestEnableICSTuning();
               }
               if(Peripheral.vehConfig.dabPresent == true)
               {
                  Peripheral.dabApp.requestDisableICSTuning();
               }
               break;
            case Peripheral.audioManager.SOURCE_FM:
            case Peripheral.audioManager.SOURCE_AM:
            case Peripheral.audioManager.SOURCE_MW:
               Peripheral.tuner.setTuneKnobEnabled(true);
               if(Peripheral.satelliteRadio.appStatus == "READY")
               {
                  Peripheral.satelliteRadio.requestDisableICSTuning();
               }
               if(Peripheral.vehConfig.dabPresent == true)
               {
                  Peripheral.dabApp.requestDisableICSTuning();
               }
               break;
            case Peripheral.audioManager.SOURCE_DAB:
               Peripheral.tuner.setTuneKnobEnabled(false);
               if(Peripheral.satelliteRadio.appStatus == "READY")
               {
                  Peripheral.satelliteRadio.requestDisableICSTuning();
               }
               if(Peripheral.vehConfig.dabPresent == true)
               {
                  Peripheral.dabApp.requestEnableICSTuning();
               }
               break;
            default:
               this.disableICSTuning();
         }
      }
      
      private function onTuneKnob(e:HardControlEvent) : void
      {
         var delta:int = e.data;
         switch(Peripheral.audioManager.source)
         {
            case Peripheral.audioManager.SOURCE_BLUETOOTH:
            case Peripheral.audioManager.SOURCE_SDCARD:
            case Peripheral.audioManager.SOURCE_USB1:
            case Peripheral.audioManager.SOURCE_USB2:
            case Peripheral.audioManager.SOURCE_USB3:
            case Peripheral.audioManager.SOURCE_USB4:
               while(delta > 0)
               {
                  Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.SKIP_FORWARD);
                  delta--;
               }
               while(delta < 0)
               {
                  Peripheral.mediaPlayer.setTransportAction(MediaPlayerTransportAction.PREVIOUS);
                  delta++;
               }
               break;
            case Peripheral.audioManager.SOURCE_CD:
               if(delta > 0)
               {
                  Peripheral.rse.nextTrack(delta);
               }
               else if(delta < 0)
               {
                  Peripheral.rse.previousTrack(Math.abs(delta));
               }
         }
      }
      
      public function onIcsEncoder(e:ICSEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.VERTICAL_SCROLL,e.delta));
      }
      
      public function onIcsSelect(e:ICSEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.SELECT));
      }
      
      public function onICSSelectPressAndHold(e:ICSEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.SELECT_2SEC_PRESS));
      }
      
      public function onIcsBack(e:ICSEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.BACK));
      }
      
      public function onIcsScreenOff(e:ICSEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.SCREEN_OFF));
      }
      
      public function onIcsExit(e:ICSEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.EXIT));
      }
      
      public function onSwcPresetAdvance(e:ISWCEvent) : void
      {
         Peripheral.presetManager.onSWCPresetAdvance();
      }
      
      public function onModeAdvancePressed(e:ISWCEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.MODE_ADVANCE));
      }
      
      public function onSeekPlusSWC(e:ISWCEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_DMB)
         {
            Log.log("Navigation is not implemented yet", "HardControls");
            //Peripheral.navigation["navDMBAppControl"].seek(DMBSeekTypes.SEEK_UP);
         }
      }
      
      public function onSeekMinusSWC(e:ISWCEvent) : void
      {
         if(Peripheral.audioManager.source == Peripheral.audioManager.SOURCE_DMB)
         {
            Log.log("Navigation is not implemented yet", "HardControls");
            //Peripheral.navigation["navDMBAppControl"].seek(DMBSeekTypes.SEEK_DN);
         }
      }
      
      private function onSelect(e:MouseEvent) : void
      {
         this.dispatchEvent(new HardControlEvent(HardControlEvent.SELECT));
      }
      
      private function onICSKey(e:ICSEvent) : void
      {
         this.dispatchEvent(new WidgetEvent(WidgetEvent.PRESS,{"identifier":e.type}));
      }
      
      private function onICSKeySRT(e:ICSEvent) : void
      {
         this.mPress += 1;
         this.mPressTimer.start();
      }
      
      private function onICSKeySRTDoubleClick(e:TimerEvent) : void
      {
         Log.log("DriveModeManager not implemented yet", "HardControls");
         if(!false)
         {
            return;
         }
         this.mPressTimer.reset();
      }
      
      private function onICSKeySport(e:Event) : void
      {
         this.mSportPress = !this.mSportPress;
         if(Peripheral.driveMode.getBaseState())
         {
            if(this.mSportPress)
            {
               Peripheral.driveMode.setDefaultToBase(1);
            }
            else
            {
               Peripheral.driveMode.setDefaultToBase(2);
            }
         }
         else
         {
            Log.log("DriveModeManager not implemented yet", "HardControls");
            if(!false)
            {
               return;
            }
         }
      }
      
      private function onlaunchKey(e:Event) : void
      {
         if(Peripheral.driveMode.launchBtnStat == "Launch on")
         {
            Peripheral.driveMode.setLaunchBtnStat("Launch off",false);
         }
         else
         {
            Peripheral.driveMode.setLaunchBtnStat("Launch on",false);
         }
      }
   }
}

