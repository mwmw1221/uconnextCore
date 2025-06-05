package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import UI;
    import flash.globalization.CurrencyFormatter;

    public class MusicApp extends Sprite
    {
        public var classes:Object; // Przekazywane klasy
        public var pkgName:String; // Nazwa pakietu
        private var musicUI:UI;

        private var CurrentTheme:Class; // Przekazywana klasa z motywem
        private var Log:Class; // Przekazywana klasa logowania
        private var Audio:Object; // Przekazywana klasa audio

        public var stageWidth:int;
        public var stageHeight:int;

        public function MusicApp()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }

        public function init():void{
            CurrentTheme = classes["api.CurrentTheme"];
            Audio = new classes["api.Audio"] as Object;
            Log = classes["com.uconnext.Log"];
            Log.log("MusicApp initialized", pkgName);
        }

        private function onAddedToStage(event:Event):void
        {
            initializeApp();
            Log.log("MusicApp added to stage", pkgName);
        }

        private function onRemovedFromStage(event:Event):void
        {
            if (musicUI && contains(musicUI)) {
                removeChild(musicUI);
                musicUI = null;
            }
            Log.log("MusicApp removed from stage", pkgName);
        }

        private function initializeApp():void
        {
            // Inicjalizacja interfejsu użytkownika
            musicUI = new UI(CurrentTheme, Audio, stageWidth, stageHeight);
            addChild(CurrentTheme.ui_Background(stageWidth, stageHeight) as Sprite);
            addChild(musicUI);
        }
    }
}