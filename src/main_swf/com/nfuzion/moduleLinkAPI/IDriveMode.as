package com.nfuzion.moduleLinkAPI
{
   public interface IDriveMode extends IModule
   {
      function getPowersSteeringSystemType() : void;
      
      function getEPSModeCfgStat() : void;
      
      function getEPSWarnDispRq() : void;
      
      function getPaddlesModeSts() : void;
      
      function getShftPROG() : void;
      
      function getEPSModeStat() : void;
      
      function getEPSWarnDisp() : void;
      
      function getESCModeStat() : void;
      
      function getADSModeCFGStat() : void;
      
      function getADSModeStat() : void;
      
      function getHoursePowerModeStat() : void;
      
      function getLaunchBtnStat() : void;
      
      function getLaunchRPMSettingEsc() : void;
      
      function getPsiEnableSts() : void;
      
      function getPsiGr1RPM() : void;
      
      function getPsiGr2RPM() : void;
      
      function getPsiGr3RPM() : void;
      
      function getPsiGr4RPM() : void;
      
      function getPsiGr5RPM() : void;
      
      function getBaseState() : Boolean;
      
      function setEPSCfgMode(param1:String) : void;
      
      function setLaunchRPMSettingEsc(param1:String) : void;
      
      function setPsiEnableSts(param1:String) : void;
      
      function setPsiGr1RPM(param1:String) : void;
      
      function setPsiGr2RPM(param1:String) : void;
      
      function setPsiGr3RPM(param1:String) : void;
      
      function setPsiGr4RPM(param1:String) : void;
      
      function setPsiGr5RPM(param1:String) : void;
      
      function get driveModeKeyMode() : uint;
      
      function get Displacement() : Boolean;
      
      function get PsiMaxRpm() : uint;
      
      function get EscStatus() : Boolean;
      
      function get TransmissionPrsnt() : Boolean;
      
      function get launchBtnStat() : String;
      
      function get launchRPMValue() : String;
      
      function get driveModeType() : String;
      
      function get driveModeTypePresent() : Boolean;
      
      function setDriveModeOption(param1:uint, param2:uint, param3:uint, param4:Boolean = false) : void;
      
      function setDriveModeOptionEnable(param1:uint, param2:Boolean) : void;
      
      function setDriveModeOptionSupport(param1:uint, param2:uint, param3:uint) : void;
      
      function getDriveModeOptionValue(param1:uint, param2:uint) : uint;
      
      function getDriveModeRunTimeValue(param1:uint, param2:uint) : uint;
      
      function getDriveModeOptionLevelVisible(param1:uint, param2:uint, param3:uint) : Boolean;
      
      function getDriveModeOptionLevelEnable(param1:uint, param2:uint, param3:uint) : Boolean;
      
      function getDriveModeOptionTypeEnable(param1:uint) : Boolean;
      
      function setDriveModeMode(param1:uint) : void;
      
      function getDriveModeMode() : int;
      
      function setDriveModeEco(param1:Boolean) : void;
      
      function getDriveModeEco() : Boolean;
      
      function setLaunchBtnStat(param1:String, param2:Boolean) : void;
      
      function setShiftBtnStat(param1:Boolean) : void;
      
      function getShiftBtnStat() : Boolean;
      
      function setLaunchRPMValuve(param1:String) : void;
      
      function getLaunchRPMValuve() : String;
      
      function setRaceOptionScreenMode(param1:String) : void;
      
      function getRaceOptionScreenMode() : String;
      
      function setCacheLaunchScreen(param1:String) : void;
      
      function getCacheLaunchScreen() : String;
      
      function get gear1RPM() : String;
      
      function get gear2RPM() : String;
      
      function get gear3RPM() : String;
      
      function get gear4RPM() : String;
      
      function get gear5RPM() : String;
      
      function setGear1RPM(param1:String) : void;
      
      function setGear2RPM(param1:String) : void;
      
      function setGear3RPM(param1:String) : void;
      
      function setGear4RPM(param1:String) : void;
      
      function setGear5RPM(param1:String) : void;
      
      function getSRTPresent() : void;
      
      function getIgnition() : void;
      
      function getDriveModePrsnt() : void;
      
      function get Ignition() : String;
      
      function get SRTPresent() : Boolean;
      
      function get SPORTPresent() : Boolean;
      
      function get STPButtonPress() : Boolean;
      
      function get DriveModePresnt() : Boolean;
      
      function get RedKeyPresent() : Boolean;
      
      function getPaddleShiftersPrsnt() : void;
      
      function getTransmissionPrsnt() : void;
      
      function getShftIndPresent() : void;
      
      function getNetCfgEPSPrsnt() : void;
      
      function getSuspensionPrsnt() : void;
      
      function getEngPowerDrvMdPrsnt() : void;
      
      function getRedKeyPrsnt() : void;
      
      function get LaunchRPMSettingEsc() : String;
      
      function setDefaultMode(param1:Boolean = true) : void;
      
      function setSportMode() : void;
      
      function setTrackMode() : void;
      
      function setCustomMode() : void;
      
      function setValetMode(param1:Boolean = true) : void;
      
      function get STPPresent() : Boolean;
      
      function getSTPPresent() : void;
      
      function setDefaultToBase(param1:uint) : void;
      
      function isSupportLaunchControl() : Boolean;
      
      function isSupportShiftLight() : Boolean;
      
      function isSupportNonSrtDriveMode() : Boolean;
      
      function get engineType() : String;
      
      function get throttle() : uint;
      
      function isATX() : Boolean;
      
      function isMTX() : Boolean;
      
      function isNetCfgTCM() : Boolean;
      
      function isHellcat() : Boolean;
      
      function getSettings() : void;
      
      function setPSIRPMReset() : void;
      
      function loadModeConfig(param1:DriveModeSetOption, param2:DriveModeSetOption, param3:DriveModeSetOption, param4:DriveModeSetOption, param5:uint) : void;
   }
}

