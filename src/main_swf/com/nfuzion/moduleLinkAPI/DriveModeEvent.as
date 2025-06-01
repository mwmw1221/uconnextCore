package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class DriveModeEvent extends Event
   {
      public static const POWERSSTEERINGSYSTEMTYPE:String = "PowersSteeringSystemType";
      
      public static const EPSMODECFGSTAT:String = "EPSModeCfgStat";
      
      public static const EPSWARMDISPRQ:String = "EPSWarnDispRq";
      
      public static const PADDLESMODESTS:String = "PaddlesModeSts";
      
      public static const SHFTPROG:String = "ShftPROG";
      
      public static const EPSMODESTAT:String = "EPSModeStat";
      
      public static const EPSWARNDISP:String = "EPSWarnDisp";
      
      public static const ESCMODESTAT:String = "ESCModeStat";
      
      public static const ADSMODECFGSTAT:String = "ADSModeCFGStat";
      
      public static const HOURSEPOWERMODESTAT:String = "HoursePowerModeStat";
      
      public static const LAUNCHBTNSTAT:String = "LaunchBtnStat";
      
      public static const LAUNCHRPMSETTINGESC:String = "LaunchRPMSettingEsc";
      
      public static const PSIENABLESTS:String = "PsiEnableSts";
      
      public static const PSIGR1RPM:String = "PsiGr1RPM";
      
      public static const PSIGR2RPM:String = "PsiGr2RPM";
      
      public static const PSIGR3RPM:String = "PsiGr3RPM";
      
      public static const PSIGR4RPM:String = "PsiGr4RPM";
      
      public static const PSIGR5RPM:String = "PsiGr5RPM";
      
      public static const PADDLESMODEPSRNT:String = "PaddleShiftersModesPresent";
      
      public static const TRANSMODEPRST:String = "TransmissionModesPresent";
      
      public static const ESCMODEPRSNT:String = "ESCModesPresent";
      
      public static const HOURSEPOWERMODEPRSNT:String = "EngPowerDrvMdPresent";
      
      public static const MEMORYDRVMDPRSNT:String = "MemoryDRVMDPresent";
      
      public static const SHFTPRSNT:String = "ShftIndPresent";
      
      public static const WARNING:String = "Warning";
      
      public static const CLEARWARNING:String = "ClearWarning";
      
      public static const WARNINGCHANGE:String = "WarningChange";
      
      public static const ESCCHANGE:String = "ESCCHANGE";
      
      public static const IGNITION:String = "ignition";
      
      public static const DRIVEMODEPRSNT:String = "DriveModePrsnt";
      
      public static const VEHLINEPRSNT:String = "vehLinePrsnt";
      
      public static const MODESETUPPRSNT:String = "ModeSetUpPrsnt";
      
      public static const PADDLESHIFTERSPRSNT:String = "PaddleShiftersPrsnt";
      
      public static const TRANSMISSIONPRSNT:String = "TransmissionPrsnt";
      
      public static const NETCFGEPSPRSNT:String = "NetCfgEPSPrsnt";
      
      public static const SUSPENSIONPRSNT:String = "SuspensionPrsnt";
      
      public static const ECMDRIVEPRSNT:String = "ECMDrivePrsnt";
      
      public static const SRTPRSNT:String = "SRTPrsnt";
      
      public static const STPPRSNT:String = "STPPrsnt";
      
      public static const STPBUTTON:String = "STPbButton";
      
      public static const ESCBUTTON:String = "ESCButton";
      
      public static const THROTTLE:String = "Throttle";
      
      public static const SPORTBUTTON:String = "SportButton";
      
      public static const REDKEYPRSNT:String = "RedKeyPrsnt";
      
      public static const DISPLACEMENT:String = "Displacement";
      
      public static const LEAVE_MODE_CHANGED:String = "ModeLeaveChanged";
      
      public static const ECO:String = "Eco Changed";
      
      public static const HP_CHANGED:String = "HpChanged";
      
      public static const TRANS_STATUS_CHANGED:String = "TransStatusChanged";
      
      public static const MODE_CHANGED:String = "ModeChanged";
      
      public static const MODE_LEAVE_ESC:String = "Esc Mode";
      
      public static const IGNITION_CHANGED:String = "Ignition changed";
      
      public static const ECO_CHANGED:String = "ECO changed";
      
      public var value:Object = null;
      
      public function DriveModeEvent(type:String, _value:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.value = _value;
      }
   }
}

