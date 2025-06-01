package com.nfuzion.moduleLinkAPI
{
   public interface IVehConfig extends IModule
   {
      function get hasHeadlightSensitivityLevelPresent() : Boolean;
      
      function get personalSettingsAvailable() : Boolean;
      
      function get soundHornWithLocks() : Boolean;
      
      function get soundHornWithLocksType() : String;
      
      function get hasDayTimeRunningLights() : Boolean;
      
      function get hasAdvancedFrontLightSystem() : Boolean;
      
      function get hasHillStartAssist() : Boolean;
      
      function get hasRearCamera() : Boolean;
      
      function get hasCargoCamera() : Boolean;
      
      function get hasBlindSpotModule() : Boolean;
      
      function get hasMemorySeatModule() : Boolean;
      
      function get hasNav() : Boolean;
      
      function get hasAmp() : Boolean;
      
      function get hasIcs() : Boolean;
      
      function get sideDistanceWarningPresent() : Boolean;
      
      function get hasHapticLaneFeedback() : Boolean;
      
      function get hasElectParkBrake() : Boolean;
      
      function get hasElectPowerSteering() : Boolean;
      
      function get hasPowerLiftGate() : Boolean;
      
      function get hasRemoteStart() : Boolean;
      
      function get hasEcoMode() : Boolean;
      
      function get hasAutoHighBeams() : Boolean;
      
      function get hasAutoHeadLamp() : Boolean;
      
      function get hasHeadLampDip() : Boolean;
      
      function get hasSportsMode() : Boolean;
      
      function get hasHoldNGo() : Boolean;
      
      function get hasSunShade() : Boolean;
      
      function get hasTemperatureDisplay() : Boolean;
      
      function get hasCompassDisplay() : Boolean;
      
      function get hasCompassCalibration() : Boolean;
      
      function get hasCompassVariance() : Boolean;
      
      function get disableClockDisplay() : Boolean;
      
      function get hasOutlet() : Boolean;
      
      function get hasHeatedSeat() : Boolean;
      
      function get hasVentedSeat() : Boolean;
      
      function get hasHeatedSteeringWheel() : Boolean;
      
      function get rainSensorType() : String;
      
      function get hasRke() : Boolean;
      
      function get hasDoorAlert() : Boolean;
      
      function get hasForwardCollisionWarning() : Boolean;
      
      function get hasForwardCollisionBraking() : Boolean;
      
      function get hasFrontParkAssist() : Boolean;
      
      function get hasParkAssist() : Boolean;
      
      function get hasPassiveEntry() : Boolean;
      
      function get hasSurroundSound() : Boolean;
      
      function get hasPowerDoorLocks() : Boolean;
      
      function get hasAutoDoorLocks() : Boolean;
      
      function get hasAmbientLighting() : Boolean;
      
      function get hasHeadRest() : Boolean;
      
      function get hasAdaptiveFrontLightSystem() : Boolean;
      
      function get hasGreetingLights() : Boolean;
      
      function get hasDistanceOption() : Boolean;
      
      function get hasAccessoryDelay() : Boolean;
      
      function get hasTireJackMode() : Boolean;
      
      function get hasAirSuspensionWarning() : Boolean;
      
      function get hasAutoAeroMode() : Boolean;
      
      function get hasAutoDoorUnlock() : Boolean;
      
      function get hasEasySeatExit() : Boolean;
      
      function get hasFlashLampsWithLock() : Boolean;
      
      function get hasHeadlampOffDelay() : Boolean;
      
      function get hasIlluminatedApproach() : Boolean;
      
      function get hasFlashLightsWithRemoteLower() : Boolean;
      
      function get hasHornWithRemoteLower() : Boolean;
      
      function get hasParkAssistBraking() : Boolean;
      
      function get hasParkAssistFrontVolume() : Boolean;
      
      function get hasParkAssistRearVolume() : Boolean;
      
      function get hasFuelSaver() : Boolean;
      
      function get hasRearCameraDelay() : Boolean;
      
      function get hasTiltMirrorInReverse() : Boolean;
      
      function get hasTransportMode() : Boolean;
      
      function get hasWheelAligment() : Boolean;
      
      function get hasUnitOption() : Boolean;
      
      function get hasAutoEntryExit() : Boolean;
      
      function get hasNavigationTurnByTurn() : Boolean;
      
      function get hasNavigationRepetition() : Boolean;
      
      function get hasRKEUnlock() : Boolean;
      
      function get hasTrailerNumber() : Boolean;
      
      function get hasTrailerType() : Boolean;
      
      function get hasTrailerName() : Boolean;
      
      function get hasAutoDriverComfort() : Boolean;
      
      function get hasAppsButton() : Boolean;
      
      function get vehicleBrand() : String;
      
      function get vehicleBrandName() : String;
      
      function get modelYear() : String;
      
      function get steeringWheelConfig() : String;
      
      function get vehicleLine() : String;
      
      function get transmissionConfig() : String;
      
      function get countryCode() : String;
      
      function get bodyStyle() : String;
      
      function get specialPackageConfig() : String;
      
      function get hvacConfig() : String;
      
      function get vehicleDestination() : String;
      
      function get vehicleDestinationName() : String;
      
      function get variantMarket() : String;
      
      function get hvacSystemAutomatic() : Boolean;
      
      function get hasTrailerBrakesModule() : Boolean;
      
      function get parkAssistConfiguration() : String;
      
      function get audioSystemType() : String;
      
      function get hasECMirror() : Boolean;
      
      function get hasSetDatePreset() : Boolean;
      
      function get laneSenseSensitivityType() : String;
      
      function get laneSenseTorqueType() : String;
      
      function get externalPortType() : String;
      
      function get additionalLanguages() : Array;
      
      function get hasCorneringLights() : Boolean;
      
      function get engineTypeVariant() : String;
      
      function get fuelTypeConfig() : String;
      
      function get clusterDisplayType() : String;
      
      function get rearCameraGridlinesType() : String;
      
      function get SwitchOffTime() : String;
      
      function get hasConsumptionUnits() : Boolean;
      
      function get hasDisplayOnOffSK() : Boolean;
      
      function get hasSyncTime() : Boolean;
      
      function get hasRadioOn() : Boolean;
      
      function get hasRadioOff() : Boolean;
      
      function get autoOnFeatureMethod() : String;
      
      function get hasAutoParkBrake() : Boolean;
      
      function get hasDNAFeature() : Boolean;
      
      function get pressureUnitsPresent() : Boolean;
      
      function get capacityUnitsPresent() : Boolean;
      
      function get consumptionUnitsPresent() : Boolean;
      
      function get distanceUnitsPresent() : Boolean;
      
      function get powerUnitsPresent() : Boolean;
      
      function get speedUnitsPresent() : Boolean;
      
      function get temperatureUnitsPresent() : Boolean;
      
      function get torqueUnitsPresent() : Boolean;
      
      function get dabPresent() : Boolean;
      
      function isImperialDestination() : Boolean;
   }
}

