package com.nfuzion.moduleLinkAPI {
    import flash.events.Event;

    public class ModuleEvent extends Event {
        public static const READY:String = "ready";
        public static const NOT_READY:String = "notReady";
        public static const HELLO:String = "hello";

        public var data:Object; // Dodatkowe dane zdarzenia

        public function ModuleEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:Object = null) {
            super(type, bubbles, cancelable);
            this.data = data;
        }

        override public function clone():Event {
            return new ModuleEvent(type, bubbles, cancelable, data);
        }
    }
}