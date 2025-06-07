package com.uconnext
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.system.Capabilities;
    import air.media.Pipeline;

    public class DeviceConfig
    {
        public function DeviceConfig() { }

        // Removes the need for running Peripheral.as
        public static const EMULATOR:Boolean = false;

        public static const SW_VERSION:String = "0.1";
        
        public static const API_VERSION:int = 1;
    }
}