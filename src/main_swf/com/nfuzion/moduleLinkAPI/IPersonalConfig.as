package com.nfuzion.moduleLinkAPI
{
   public interface IPersonalConfig extends IModule
   {
      function getDisplayMode() : void;
      
      function get displayMode() : String;
      
      function getDisplayModeSetting() : void;
      
      function get displayModeSetting() : String;
      
      function setDisplayModeSetting(param1:String) : void;
      
      function get brightnessMin() : int;
      
      function set brightnessMin(param1:int) : void;
      
      function get brightnessMax() : int;
      
      function set brightnessMax(param1:int) : void;
      
      function getdisplayBrightHlOn() : void;
      
      function get displayBrightHlOn() : int;
      
      function setDisplayBrightHlOn(param1:int) : void;
      
      function getDisplayBrightHlOff() : void;
      
      function get displayBrightHlOff() : int;
      
      function setDisplayBrightHlOff(param1:int) : void;
      
      function getDisplayColor() : void;
      
      function get displayColor() : String;
      
      function setDisplayColor(param1:String) : void;
      
      function getDisplayLang() : void;
      
      function get displayLang() : String;
      
      function setDisplayLang(param1:String) : void;
      
      function getDisplayUnits() : void;
      
      function get displayUnits() : String;
      
      function setDisplayUnits(param1:String) : void;
      
      function get speedUnits() : String;
      
      function set speedUnits(param1:String) : void;
      
      function get distanceUnits() : String;
      
      function set distanceUnits(param1:String) : void;
      
      function get fuelConsumptionUnits() : String;
      
      function set fuelConsumptionUnits(param1:String) : void;
      
      function get capacityUnits() : String;
      
      function set capacityUnits(param1:String) : void;
      
      function get pressureUnits() : String;
      
      function set pressureUnits(param1:String) : void;
      
      function get temperatureUnits() : String;
      
      function set temperatureUnits(param1:String) : void;
      
      function get horsePowerUnits() : String;
      
      function set horsePowerUnits(param1:String) : void;
      
      function get torqueUnits() : String;
      
      function set torqueUnits(param1:String) : void;
      
      function getDisplayVoiceRes() : void;
      
      function get displayVoiceRes() : String;
      
      function setDisplayVoiceRes(param1:String) : void;
      
      function getTeleprompterMode() : void;
      
      function get teleprompterMode() : String;
      
      function setTeleprompterMode(param1:String) : void;
      
      function getDisplayTouchScreenBeep() : void;
      
      function get displayTouchScreenBeep() : Boolean;
      
      function setDisplayTouchScreenBeep(param1:Boolean) : void;
      
      function getDisplayNavCluster() : void;
      
      function get displayNavCluster() : Boolean;
      
      function setDisplayNavCluster(param1:Boolean) : void;
      
      function getDisplayFuelSaver() : void;
      
      function get displayFuelSaver() : Boolean;
      
      function setDisplayFuelSaver(param1:Boolean) : void;
      
      function getControlsTimeoutEnabled() : void;
      
      function get controlsTimeoutEnabled() : Boolean;
      
      function setControlsTimeoutEnabled(param1:Boolean) : void;
      
      function getSafeFwdCollision() : void;
      
      function get safeFwdCollision() : String;
      
      function setSafeFwdCollision(param1:String) : void;
      
      function getSafeFcwBrakeStat() : void;
      
      function get safeFcwBrakeStat() : String;
      
      function setSafeFcwBrakeStat(param1:Boolean) : void;
      
      function setForwardCollisionWarning(param1:String) : void;
      
      function getSafeParkAssist() : void;
      
      function get safeParkAssist() : String;
      
      function setSafeParkAssist(param1:String) : void;
      
      function getFrontParkAssistChimeVolume() : void;
      
      function get frontParkAssistChimeVolume() : String;
      
      function setFrontParkAssistChimeVolume(param1:String) : void;
      
      function getRearParkAssistChimeVolume() : void;
      
      function get rearParkAssistChimeVolume() : String;
      
      function setRearParkAssistChimeVolume(param1:String) : void;
      
      function getRearParkAssistBraking() : void;
      
      function get rearParkAssistBraking() : Boolean;
      
      function setRearParkAssistBraking(param1:Boolean) : void;
      
      function getSafeTiltMirror() : void;
      
      function get safeTiltMirror() : Boolean;
      
      function setSafeTiltMirror(param1:Boolean) : void;
      
      function getSafeBlindSpot() : void;
      
      function get safeBlindSpot() : String;
      
      function setSafeBlindSpot(param1:String) : void;
      
      function getSafeBackUpCamera() : void;
      
      function get safeBackUpCamera() : Boolean;
      
      function setSafeBackUpCamera(param1:Boolean) : void;
      
      function get safeBackUpCameraDelay() : Boolean;
      
      function setSafeBackUpCameraDelay(param1:Boolean) : void;
      
      function getSafeCameraDynamicGridLines() : void;
      
      function get safeCameraDynamicGridLines() : Boolean;
      
      function setSafeCameraDynamicGridLines(param1:Boolean) : void;
      
      function getSafeCameraStaticGridLines() : void;
      
      function get safeCameraStaticGridLines() : Boolean;
      
      function setSafeCameraStaticGridLines(param1:Boolean) : void;
      
      function getSafeAutoWiper() : void;
      
      function get safeAutoWiper() : Boolean;
      
      function setSafeAutoWiper(param1:Boolean) : void;
      
      function getSafeHillStartAssist() : void;
      
      function get safeHillStartAssist() : Boolean;
      
      function setSafeHillStartAssist(param1:Boolean) : void;
      
      function getSafeSlidingDoorAlert() : void;
      
      function get safeSlidingDoorAlert() : Boolean;
      
      function setDbusSafeSlidingDoorAlert(param1:Boolean) : void;
      
      function getHeadLightOffDelay() : void;
      
      function get headLightOffDelay() : int;
      
      function setHeadLightOffDelay(param1:int) : void;
      
      function getHeadLightIllumination() : void;
      
      function get headLightIllumination() : int;
      
      function setHeadLightIllumination(param1:int) : void;
      
      function getHeadLightsWiper() : void;
      
      function get headLightsWiper() : Boolean;
      
      function setHeadLightsWiper(param1:Boolean) : void;
      
      function getAutoDimHighBeams() : void;
      
      function get autoDimHighBeams() : Boolean;
      
      function setAutoDimHighBeams(param1:Boolean) : void;
      
      function getDayTimeRunningLights() : void;
      
      function get dayTimeRunningLights() : Boolean;
      
      function setDayTimeRunningLights(param1:Boolean) : void;
      
      function getSteeringDirectedLights() : void;
      
      function get steeringDirectedLights() : Boolean;
      
      function setSteeringDirectedLights(param1:Boolean) : void;
      
      function getHeadLightDip() : void;
      
      function get headLightDip() : Boolean;
      
      function setHeadLightDip(param1:Boolean) : void;
      
      function getFlashHeadLightsWithLock() : void;
      
      function get flashHeadLightsWithLock() : Boolean;
      
      function setFlashHeadLightsWithLock(param1:Boolean) : void;
      
      function getAutoDoorLock() : void;
      
      function get autoDoorLock() : Boolean;
      
      function setAutoDoorLock(param1:Boolean) : void;
      
      function getAutoUnlockOnExit() : void;
      
      function get autoUnlockOnExit() : Boolean;
      
      function setAutoUnlockOnExit(param1:Boolean) : void;
      
      function getFlashHlWithLock() : void;
      
      function get flashHlWithLock() : Boolean;
      
      function setFlashHlWithLock(param1:Boolean) : void;
      
      function getSoundHornWithLock() : void;
      
      function get soundHornWithLock() : Boolean;
      
      function setSoundHornWithLock(param1:Boolean) : void;
      
      function getSoundHornWithLock1st2nd() : void;
      
      function get soundHornWithLock1st2nd() : String;
      
      function setSoundHornWithLock1st2nd(param1:String) : void;
      
      function getSoundHornWithRemoteLock() : void;
      
      function get soundHornWithRemoteLock() : Boolean;
      
      function setSoundHornWithRemoteLock(param1:Boolean) : void;
      
      function getFirstPresskeyFob() : void;
      
      function get firstPresskeyFob() : String;
      
      function setFirstPresskeyFob(param1:String) : void;
      
      function getPassiveEntry() : void;
      
      function get passiveEntry() : Boolean;
      
      function setPassiveEntry(param1:Boolean) : void;
      
      function getPersonalSettingsFob() : void;
      
      function get personalSettingsFob() : Boolean;
      
      function setPersonalSettingsFob(param1:Boolean) : void;
      
      function getSlidingDoorAlert() : void;
      
      function get slidingDoorAlert() : Boolean;
      
      function setSlidingDoorAlert(param1:Boolean) : void;
      
      function getHornWithRemoteStart() : void;
      
      function get hornWithRemoteStart() : Boolean;
      
      function setHornWithRemoteStart(param1:Boolean) : void;
      
      function getAutoOnDCS() : void;
      
      function get autoOnDCS() : String;
      
      function setAutoOnDCS(param1:String) : void;
      
      function getSideDistanceWarning() : void;
      
      function get sideDistanceWarning() : String;
      
      function setSideDistanceWarning(param1:String) : void;
      
      function getSideDistanceWarningVolume() : void;
      
      function get sideDistanceWarningVolume() : String;
      
      function setSideDistanceWarningVolume(param1:String) : void;
      
      function getAmbientLightingLevel() : void;
      
      function get ambientLightingLevel() : String;
      
      function setAmbientLightingLevel(param1:String) : void;
      
      function getEasyExitSeat() : void;
      
      function get easyExitSeat() : Boolean;
      
      function setEasyExitSeat(param1:Boolean) : void;
      
      function getEngineOffPowerDelay() : void;
      
      function get engineOffPowerDelay() : int;
      
      function setEngineOffPowerDelay(param1:int) : void;
      
      function getCompassVariance() : void;
      
      function get compassVariance() : int;
      
      function setCompassVariance(param1:int) : void;
      
      function getAllSuspensionProps() : void;
      
      function getSoundHornWithRemoteLower() : void;
      
      function get soundHornWithRemoteLower() : Boolean;
      
      function setSoundHornWithRemoteLower(param1:Boolean) : void;
      
      function getFlashLightWithLower() : void;
      
      function get flashLightWithLower() : Boolean;
      
      function setFlashLightWithLower(param1:Boolean) : void;
      
      function getTireJackMode() : void;
      
      function get tireJackMode() : Boolean;
      
      function setTireJackMode(param1:Boolean) : void;
      
      function getSuspensionMessagesDisplay() : void;
      
      function get suspensionMessagesDisplay() : Boolean;
      
      function setsuspensionMessagesDisplay(param1:Boolean) : void;
      
      function getTransportMode() : void;
      
      function get transportMode() : Boolean;
      
      function setTransportMode(param1:Boolean) : void;
      
      function getWheelAlignment() : void;
      
      function get wheelAlignment() : Boolean;
      
      function setWheelAlignment(param1:Boolean) : void;
      
      function getAeroMode() : void;
      
      function get aeroMode() : Boolean;
      
      function setAeroMode(param1:Boolean) : void;
      
      function getSuspensionEasyExit() : void;
      
      function get SuspensionEasyExit() : Boolean;
      
      function setSuspensionEasyExit(param1:Boolean) : void;
      
      function getSelectedTrailer() : void;
      
      function get selectedTrailer() : int;
      
      function setSelectedTrailer(param1:int) : void;
      
      function getBrakeType() : void;
      
      function get brakeType() : int;
      
      function setBrakeType(param1:int) : void;
      
      function getTrailerXsBrkType(param1:int) : void;
      
      function get trailer1BrkType() : int;
      
      function get trailer2BrkType() : int;
      
      function get trailer3BrkType() : int;
      
      function get trailer4BrkType() : int;
      
      function getTrailerName() : void;
      
      function get trailerName() : String;
      
      function setTrailerName(param1:String) : void;
      
      function getTrailerXsName(param1:int) : void;
      
      function get trailer1Name() : String;
      
      function get trailer2Name() : String;
      
      function get trailer3Name() : String;
      
      function get trailer4Name() : String;
      
      function getPwrLiftgateChime() : void;
      
      function get PwrLiftgateChime() : Boolean;
      
      function setPwrLiftgateChime(param1:Boolean) : void;
      
      function getMoodLightingInts() : void;
      
      function get moodLightingInts() : String;
      
      function setMoodLightingInts(param1:String) : void;
      
      function getAutoParkBrake() : void;
      
      function get autoParkBrake() : String;
      
      function setAutoParkBrake(param1:String) : void;
      
      function getAutoBrakeHoldStatus() : void;
      
      function get autoBrakeHoldStatus() : String;
      
      function setAutoBrakeHoldStatus(param1:String) : void;
      
      function getLaneSenseWarnSensitivity() : void;
      
      function get laneSenseWarnSensitivity() : String;
      
      function setLaneSenseWarnSensitivity(param1:String) : void;
      
      function getLaneSenseTorqueIntensity() : void;
      
      function get laneSenseTorqueIntensity() : String;
      
      function setLaneSenseTorqueIntensity(param1:String) : void;
      
      function get brakeServiceStatus() : Boolean;
      
      function get brakeServiceTextDisplay() : String;
      
      function activateBrakeService() : void;
      
      function resetTripComputerA() : void;
      
      function get tripComputerAStatus() : String;
      
      function resetTripComputerB() : void;
      
      function get tripComputerBStatus() : String;
      
      function getPowerSteeringMode() : void;
      
      function get powerSteeringMode() : String;
      
      function setPowerSteeringMode(param1:String) : void;
      
      function getNavigationRepetitionEnabled() : void;
      
      function get navigationRepetitionEnabled() : Boolean;
      
      function setNavigationRepetitionEnabled(param1:Boolean) : void;
      
      function get headlightSensitivityLevel() : int;
      
      function set headlightSensitivityLevel(param1:int) : void;
   }
}

