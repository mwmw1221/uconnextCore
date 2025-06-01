package com.uconnext
{
    import peripheral.Peripheral;
    import events.FrameworkEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.setTimeout;
    import com.nfuzion.moduleLinkAPI.ModuleEvent;

    public class PeripheralLoader extends EventDispatcher{
        public function load():void{
            Log.log("Starting load process", "PeripheralLoader");
            // comment these lines when testing without hardware
            if (DeviceConfig.EMULATOR) {
                Log.log("Running in debugger mode, skipping hardware loading", "PeripheralLoader");
                setTimeout(function():void{
                    dispatchEvent(new FrameworkEvent(FrameworkEvent.READY));
                }, 5000);
                return;
            }
            var peripheralLoader:Peripheral = new Peripheral();
            peripheralLoader.addEventListener(FrameworkEvent.READY, function():void{
                Log.log("Peripheral loaded successfully", "PeripheralLoader");
                dispatchEvent(new FrameworkEvent(FrameworkEvent.READY));
            });
            peripheralLoader.addEventListener(Peripheral.MODULE_READY, function(e:ModuleEvent):void{
                Log.log("Peripheral module ready: " + e.data, "PeripheralLoader");
            });
            peripheralLoader.addEventListener(Peripheral.MODULE_NOT_READY, function(e:ModuleEvent):void{
                Log.log("Peripheral module is loading: " + e.data, "PeripheralLoader");
            });
            Log.log("Peripheral loading process started", "PeripheralLoader");
            peripheralLoader.init();
        }
    }
}