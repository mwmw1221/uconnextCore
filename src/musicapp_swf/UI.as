package
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.events.Event;
    
    import classes.MediaPlayerTransportAction; // Importuj odpowiednią klasę dla transportu audio

    public class UI extends Sprite
    {
        private var playButton:Sprite;
        private var pauseButton:Sprite;
        private var stopButton:Sprite;
        private var seekSlider:Sprite; // Suwak przewijania piosenki
        private var albumImageLoader:Loader; // Loader do obrazka albumu
        private var songTitle:TextField; // Pole tekstowe na tytuł piosenki
        private var songAuthor:TextField; // Pole tekstowe na autora piosenki

        private var CurrentTheme:Class; // Przekazywana klasa z motywem
        private var Audio:Object; // Przekazywana klasa audio
        private var uiWidth:int; // Szerokość interfejsu
        private var uiHeight:int; // Wysokość interfejsu

        public function UI(currentTheme:Class, audio:Object, width:int, height:int)
        {
            super();
            this.CurrentTheme = currentTheme;
            this.Audio = audio;
            this.uiWidth = width;
            this.uiHeight = height;
            initializeUI();
        }

        private function initializeUI():void
        {
            // Tworzenie przycisków sterowania
            createControlButtons();

            // Tworzenie suwaków
            createSliders();

            // Tworzenie informacji o piosence
            createSongInfo();

            // Tworzenie loadera do obrazka albumu
            createAlbumImageLoader();
        }

        private function createControlButtons():void
        {
            var buttonWidth:int = 80;
            var buttonHeight:int = 40;
            var buttonSpacing:int = 10;

            // Tworzenie przycisku "Play"
            playButton = CurrentTheme.ui_Button(buttonWidth, buttonHeight, "Play/Pause");
            playButton.x = buttonSpacing;
            playButton.y = uiHeight * 0.7;
            playButton.addEventListener(MouseEvent.CLICK, onPlayClick);
            addChild(playButton);

            // Tworzenie przycisku "Pause"
            pauseButton = CurrentTheme.ui_Button(buttonWidth, buttonHeight, "Prev");
            pauseButton.x = playButton.x + buttonWidth + buttonSpacing;
            pauseButton.y = uiHeight * 0.7;
            pauseButton.addEventListener(MouseEvent.CLICK, onPauseClick);
            addChild(pauseButton);

            // Tworzenie przycisku "Stop"
            stopButton = CurrentTheme.ui_Button(buttonWidth, buttonHeight, "Next");
            stopButton.x = pauseButton.x + buttonWidth + buttonSpacing;
            stopButton.y = uiHeight * 0.7;
            stopButton.addEventListener(MouseEvent.CLICK, onStopClick);
            addChild(stopButton);
        }

        private function createSliders():void
        {
            var sliderWidth:int = uiWidth * 0.8;
            var sliderHeight:int = 20;

            // Tworzenie suwaka przewijania piosenki
            seekSlider = CurrentTheme.ui_Slider(sliderWidth);
            seekSlider.x = uiWidth * 0.1;
            seekSlider.y = uiHeight * 0.6;
            addChild(seekSlider);
        }

        private function createSongInfo():void
        {
            var textWidth:int = uiWidth * 0.8;

            // Tworzenie pola tekstowego na tytuł piosenki
            songTitle = new TextField();
            songTitle.defaultTextFormat = new TextFormat("Arial", 14, 0xFFFFFF, true);
            songTitle.text = "Tytuł piosenki";
            songTitle.x = uiWidth * 0.1;
            songTitle.y = uiHeight * 0.1;
            songTitle.width = textWidth;
            addChild(songTitle);

            // Tworzenie pola tekstowego na autora piosenki
            songAuthor = new TextField();
            songAuthor.defaultTextFormat = new TextFormat("Arial", 12, 0xCCCCCC);
            songAuthor.text = "Autor piosenki";
            songAuthor.x = uiWidth * 0.1;
            songAuthor.y = uiHeight * 0.2;
            songAuthor.width = textWidth;
            addChild(songAuthor);
        }

        private function createAlbumImageLoader():void
        {
            var imageSize:int = uiHeight * 0.3;

            // Tworzenie loadera do obrazka albumu
            albumImageLoader = new Loader();
            albumImageLoader.x = uiWidth * 0.6 - imageSize / 2;
            albumImageLoader.y = uiHeight * 0.3;
            albumImageLoader.width = imageSize;
            albumImageLoader.height = imageSize;
            //albumImageLoader.load(new URLRequest("path/to/album/image.jpg")); // Zmień na właściwą ścieżkę
            addChild(albumImageLoader);
        }

        public function populateSources(sources:Array):void {
            for each (var source:Object in sources) {
                trace("Source: " + source.name + ", availability: " + source.available + " "+ source.hardwareAvailable);
            }
        }

        private function onPlayClick(event:MouseEvent):void
        {
            trace("Play/pause clicked");
            if(Audio.transportAction == MediaPlayerTransportAction.PLAY)
            {
               Audio.transportAction = MediaPlayerTransportAction.PAUSE;
            }
            else if(Audio.transportAction == MediaPlayerTransportAction.PAUSE)
            {
               Audio.transportAction = MediaPlayerTransportAction.RESUME;
            }
            else
            {
               Audio.transportAction = MediaPlayerTransportAction.PLAY;
            }
        }

        private function onPauseClick(event:MouseEvent):void
        {
            trace("Prev clicked");
            Audio.transportAction = MediaPlayerTransportAction.PREVIOUS;
        }

        private function onStopClick(event:MouseEvent):void
        {
            trace("Next clicked");
            Audio.transportAction = MediaPlayerTransportAction.SKIP_FORWARD;
        }
    }
}