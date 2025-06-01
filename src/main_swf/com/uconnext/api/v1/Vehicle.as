package com.uconnext.api.v1
{
    import peripheral.VehicleFeatureManager;
    import peripheral.Peripheral;
    import com.harman.moduleLinkAPI.IVehicleStatus;
    import com.nfuzion.moduleLinkAPI.IVehConfig;

    // uConnext Vehicle API v1
    
    // This class is experimental and may change in the future.

    // This class provides an interface to manage vehicle functionalities
    // such as vehicle status, feature management, and vehicle state.

    // TODO: Add error handling and validation for the methods.
    // TODO: Add documentation for each method and class.
    // TODO: Add more features in getAvailableFeatures() method.


    public class Vehicle
    {
        private var featureManager:VehicleFeatureManager;
        private var vehicleStatus:IVehicleStatus;
        private var vehConfig:IVehConfig;

        public function Vehicle()
        {
            this.featureManager = new VehicleFeatureManager();
            this.vehicleStatus = Peripheral.vehicleStatus;
            this.vehConfig = Peripheral.vehConfig
        }

        public function getVehicleFeatureSetCode():String {
            return featureManager.vehicleFeatureSet;
        }

        public function isVehicleInPark():Boolean {
            return vehicleStatus.vehicleInPark;
        }

        public function isHeadlightsOn():Boolean {
            return vehicleStatus.headlightsOn;
        }

        public function getIgnitionState():String {
            return vehicleStatus.ignitionState;
        }

        // Pobiera nazwę marki pojazdu
        public function getVehicleBrandName():String {
            return vehConfig.vehicleBrandName;
        }

        // Pobiera listę funkcji dostępnych w pojeździe
        public function getAvailableFeatures():Array {
            var features:Array = [];
            if (vehConfig.hasHeatedSeat) features.push("heated_seat");
            if (vehConfig.hasVentedSeat) features.push("vented_seat");
            if (vehConfig.hasHeatedSteeringWheel) features.push("heated_wheel");
            if (vehConfig.hasSunShade) features.push("sun_shade");
            if (vehConfig.hasEcoMode) features.push("eco_mode");
            if (vehConfig.hasCompassDisplay) features.push("compass_display");
            if (vehConfig.hasTemperatureDisplay) features.push("temperature_display");
            if (vehConfig.hasAutoHighBeams) features.push("auto_high_beams");
            if (vehConfig.hasAutoHeadLamp) features.push("auto_head_lamp");
            if (vehConfig.hasHeadLampDip) features.push("head_lamp_dip");
            if (vehConfig.hasSportsMode) features.push("sports_mode");
            if (vehConfig.hasHoldNGo) features.push("hold_n_go");
            if (vehConfig.hasElectParkBrake) features.push("elect_park_brake");
            if (vehConfig.hasElectPowerSteering) features.push("elect_power_steering");
            if (vehConfig.hasPowerLiftGate) features.push("power_lift_gate");
            if (vehConfig.hasRemoteStart) features.push("remote_start");
            if (vehConfig.hasMemorySeatModule) features.push("memory_seat_module");
            if (vehConfig.hasNav) features.push("navigation");
            if (vehConfig.hasAmp) features.push("amplifier");
            if (vehConfig.hasIcs) features.push("ics");
            if (vehConfig.rainSensorType) features.push("rain_sensor_type");
            if (vehConfig.sideDistanceWarningPresent) features.push("side_distance_warning");
            if (vehConfig.hasHapticLaneFeedback) features.push("haptic_lane_feedback");
            if (vehConfig.hasBlindSpotModule) features.push("blind_spot_module");
            if (vehConfig.hasRearCamera) features.push("rear_camera");
            if (vehConfig.hasCargoCamera) features.push("cargo_camera");
            if (vehConfig.hasOutlet) features.push("outlet");
            if (vehConfig.disableClockDisplay) features.push("disable_clock_display");
            if (vehConfig.hasCompassCalibration) features.push("compass_calibration");
            if (vehConfig.hasCompassVariance) features.push("compass_variance");
            if (vehicleStatus.speedLockOut) features.push("speed_lockout");
            return features;
        }
    }
}
