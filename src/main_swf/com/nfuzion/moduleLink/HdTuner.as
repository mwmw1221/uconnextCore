package com.nfuzion.moduleLink
{
   import com.harman.moduleLinkAPI.HdBER;
   import com.harman.moduleLinkAPI.HdPerformance;
   import com.nfuzion.moduleLinkAPI.HdStationInfo;
   import com.nfuzion.moduleLinkAPI.HdStatus;
   import com.nfuzion.moduleLinkAPI.HdTunerEvent;
   import com.nfuzion.moduleLinkAPI.IHdTuner;
   
   public class HdTuner extends Tuner implements IHdTuner
   {
      private static var instance:HdTuner;
      
      private static const dBusTunerSetHDPerformance:String = "setHDPerformance";
      
      private var mHdStatus:Object = new HdStatus();
      
      private var mHdStationInfo:Object = new HdStationInfo();
      
      private var mLastHdStatusMsg:String = "";
      
      private var mHdBERmode:uint = 0;
      
      private var mHdBERInfo:Object = new HdBER();
      
      private var mHdPerformanceInfo:Object = new HdPerformance();
      
      private var mHdSwVersion:String = "";
      
      private var mCurrentHDProgramAvailable:Boolean = true;
      
      public function HdTuner()
      {
         super();
      }
      
      public static function getInstance() : HdTuner
      {
         if(instance == null)
         {
            instance = new HdTuner();
         }
         return instance;
      }
      
      override protected function subscribe(signalName:String) : void
      {
         super.subscribe(signalName);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         super.unsubscribe(signalName);
      }
      
      public function setHdFrequency(frequency:uint, subCh:Number) : void
      {
         super.sendFrequency_subChannel("setFrequency","frequency",frequency,"subChannel",subCh);
      }
      
      public function setHdMode(hdModeEnabled:Number) : void
      {
         super.sendFrequency("setHDMode","hdMode",hdModeEnabled);
      }
      
      public function setHdBERMode(enabled:uint) : void
      {
         this.mHdBERmode = enabled;
         super.sendFrequency("setHDBERMode","hdBERMode",enabled);
      }
      
      public function setHdPerformanceMode(enabled:Boolean) : void
      {
         if(true == enabled)
         {
            super.sendCommand(dBusTunerSetHDPerformance,"hdPerformance","ON");
         }
         else
         {
            super.sendCommand(dBusTunerSetHDPerformance,"hdPerformance","OFF");
         }
      }
      
      public function addTagToCurrentSong() : Boolean
      {
         if(this.mHdStationInfo.hdTagAvailable)
         {
            this.mHdStationInfo.hdTagged = true;
            super.sendCommand("tagSong","id",this.mHdStationInfo.hdTagId);
            return true;
         }
         return false;
      }
      
      public function get hdMode() : uint
      {
         return this.mHdStatus.hdMode;
      }
      
      public function get hdBERMode() : uint
      {
         return this.mHdBERmode;
      }
      
      public function get currentHdSubchannel() : int
      {
         return this.mHdStationInfo.hdAudioPlaying;
      }
      
      public function requestHDStatusInfo() : void
      {
         super.getValue("hdStatusInfo");
      }
      
      public function requestHDStationInfo() : void
      {
         super.getValue("hdStationInfo");
      }
      
      public function get programsAvailable() : Vector.<int>
      {
         return this.mHdStationInfo.programsAvailable;
      }
      
      public function get hdPTY() : String
      {
         return this.mHdStationInfo.hdPTY;
      }
      
      public function get hdStationLongName() : String
      {
         return this.mHdStationInfo.hdStationLongName;
      }
      
      public function get hdStationShortName() : String
      {
         return this.mHdStationInfo.hdStationShortName;
      }
      
      public function get hdArtistName() : String
      {
         return this.mHdStationInfo.hdArtistName;
      }
      
      public function get hdSongTitle() : String
      {
         return this.mHdStationInfo.hdSongTitle;
      }
      
      public function get hdAlbumName() : String
      {
         return this.mHdStationInfo.hdAlbumName;
      }
      
      public function get hdAcquisitionStatus() : uint
      {
         return this.mHdStatus.acquisitionStatus;
      }
      
      public function get hdSisStatus() : uint
      {
         return this.mHdStatus.sisCrcStatus;
      }
      
      public function get hdDigitalAudioAcquired() : uint
      {
         return this.mHdStatus.digitalAudioAcquired;
      }
      
      public function get hdStatusMsg() : String
      {
         return this.mHdStatus.hdStatusMsg;
      }
      
      public function get hdTagAvailable() : Boolean
      {
         return this.mHdStatus.hdTagId != "";
      }
      
      public function get hdTagId() : String
      {
         return this.mHdStatus.hdTagId;
      }
      
      public function get hdTagged() : Boolean
      {
         return this.mHdStatus.hdTagged;
      }
      
      public function get hdBerInfo() : Object
      {
         return this.mHdBERInfo;
      }
      
      public function get hdPerformanceInfo() : Object
      {
         return this.mHdPerformanceInfo;
      }
      
      public function get hdSwVersion() : String
      {
         return this.mHdSwVersion;
      }
      
      public function get currentHDProgramAvailable() : Boolean
      {
         return this.mCurrentHDProgramAvailable;
      }
      
      public function requestHdSwVersion() : void
      {
         super.sendCommand("getHdSwVersion","","");
         super.getValue("hdSwVersion");
      }
      
      override public function tunerMessageHandler(e:ConnectionEvent) : void
      {
         var str:String = null;
         super.tunerMessageHandler(e);
         var HdTunerObj:Object = e.data;
         if(HdTunerObj.hasOwnProperty("hdStatusInfo"))
         {
            this.mHdStatus = this.mHdStatus.updateHDStatus(HdTunerObj.hdStatusInfo.value);
            this.mLastHdStatusMsg = this.mHdStatus.hdStatusMsg;
            dispatchEvent(new HdTunerEvent(HdTunerEvent.HD_STATUS,this.mHdStatus));
         }
         else if(HdTunerObj.hasOwnProperty("hdStationInfo"))
         {
            this.mHdStationInfo.updateHdStationInfo(HdTunerObj.hdStationInfo.value);
            if(HdTunerObj.hdStationInfo.value.hasOwnProperty("hdTagId"))
            {
               this.mHdStationInfo.hdTagId = HdTunerObj.hdStationInfo.value.hdTagId;
            }
            else
            {
               this.mHdStationInfo.hdTagId = "";
            }
            if(HdTunerObj.hdStationInfo.value.hasOwnProperty("hdTagged"))
            {
               this.mHdStationInfo.hdTagged = HdTunerObj.hdStationInfo.value.hdTagged;
            }
            else
            {
               this.mHdStationInfo.hdTagged = false;
            }
            dispatchEvent(new HdTunerEvent(HdTunerEvent.HD_STATION));
         }
         else if(HdTunerObj.hasOwnProperty("hdBERErrorRate"))
         {
            this.mHdBERInfo = this.mHdBERInfo.copyBER(HdTunerObj.hdBERErrorRate.value);
            dispatchEvent(new HdTunerEvent(HdTunerEvent.HD_BER_DIAGNOSTICS));
         }
         else if(HdTunerObj.hasOwnProperty("hdPerformance"))
         {
            this.mHdPerformanceInfo = this.mHdPerformanceInfo.copyPerformance(HdTunerObj.hdPerformance.value);
            dispatchEvent(new HdTunerEvent(HdTunerEvent.HD_PERFORMANCE));
         }
         else if(HdTunerObj.hasOwnProperty("hdSwVersion"))
         {
            str = HdTunerObj.hdSwVersion.value;
            this.mHdSwVersion = str.substring(str.length - 5,str.length - 1);
            dispatchEvent(new HdTunerEvent(HdTunerEvent.HD_FW_VERSION));
         }
         else if(HdTunerObj.hasOwnProperty("hdTune"))
         {
            dispatchEvent(new HdTunerEvent(HdTunerEvent.HD_TUNE));
         }
         else if(HdTunerObj.hasOwnProperty("currentHdProgram"))
         {
            this.mCurrentHDProgramAvailable = HdTunerObj.currentHdProgram.programAvailable;
            this.dispatchEvent(new HdTunerEvent(HdTunerEvent.HD_PROGRAM_AVAIL,this.mCurrentHDProgramAvailable));
         }
         else if(HdTunerObj.hasOwnProperty("getProperties"))
         {
            if(HdTunerObj.getProperties.hasOwnProperty("hdStatusInfo"))
            {
               this.mHdStatus = this.mHdStatus.updateHDStatus(HdTunerObj.getProperties.hdStatusInfo);
               this.mLastHdStatusMsg = this.mHdStatus.hdStatusMsg;
               dispatchEvent(new HdTunerEvent(HdTunerEvent.HD_STATUS,this.mHdStatus));
            }
            if(HdTunerObj.getProperties.hasOwnProperty("hdStationInfo"))
            {
               this.mHdStationInfo.updateHdStationInfo(HdTunerObj.getProperties.hdStationInfo);
               dispatchEvent(new HdTunerEvent(HdTunerEvent.HD_STATION));
            }
            if(HdTunerObj.getProperties.hasOwnProperty("hdSwVersion"))
            {
               str = HdTunerObj.getProperties.hdSwVersion;
               this.mHdSwVersion = str.substring(str.length - 5,str.length);
               this.dispatchEvent(new HdTunerEvent(HdTunerEvent.HD_FW_VERSION));
            }
         }
      }
   }
}

