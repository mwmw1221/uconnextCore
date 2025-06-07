package ui
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.display.DisplayObject;
    import flash.text.TextFieldAutoSize;

    import com.nfuzion.moduleLinkAPI.TunerBand;
    import com.nfuzion.moduleLinkAPI.TunerEvent;
    import com.harman.moduleLinkAPI.TunerSeek;
    import flash.media.AudioDecoder;
    import flash.events.MouseEvent;
    
    public class RadioUI
    {

        private var CurrentTheme:Object = null;

        public var uiObjects:Object = {};

        public function RadioUI(CurrentTheme:Object, w:Number = 400, h:Number = 400, Audio:Object = null)
        {
            super();
            this.CurrentTheme = CurrentTheme;

            var radioFrequencyContainer:Sprite = new Sprite();
            radioFrequencyContainer.x = w / 2 - radioFrequencyContainer.width / 2;
            radioFrequencyContainer.y = h / 3 - radioFrequencyContainer.height / 2;
            uiObjects.radioFrequencyContainer = radioFrequencyContainer;


            var radioFrequencyText:TextField = CurrentTheme.ui_Text()
            var textFormat:TextFormat = radioFrequencyText.defaultTextFormat;
            textFormat.size = 38; // Powiększenie tekstu
            radioFrequencyText.defaultTextFormat = textFormat;
            radioFrequencyText.autoSize = TextFieldAutoSize.CENTER;
            radioFrequencyText.text = "000.0";
            radioFrequencyText.name = "frequency"; // Ustawienie nazwy dla późniejszego dostępu
            radioFrequencyContainer.addChild(radioFrequencyText)

            radioFrequencyContainer.x = w / 2 - radioFrequencyText.textWidth / 2;
            radioFrequencyContainer.y = h / 3 - radioFrequencyText.textHeight / 2;

            var radioFrequencyUnits:TextField = CurrentTheme.ui_Text()
            var textMediumFormat:TextFormat = radioFrequencyUnits.defaultTextFormat;
            textMediumFormat.size = 18; // Ustawienie mniejszego rozmiaru tekstu
            radioFrequencyUnits.defaultTextFormat = textMediumFormat;
            radioFrequencyUnits.autoSize = TextFieldAutoSize.LEFT;
            radioFrequencyUnits.text = "MHz";
            radioFrequencyUnits.x = radioFrequencyText.x + radioFrequencyText.textWidth + 4; // Przesunięcie w prawo od częstotliwości
            radioFrequencyUnits.y = radioFrequencyText.y + radioFrequencyText.textHeight / 2 - radioFrequencyUnits.textHeight / 2; // Wyśrodkowanie pionowo względem częstotliwości
            radioFrequencyUnits.name = "unit"
            radioFrequencyContainer.addChild(radioFrequencyUnits);

            var radioPtyText:TextField = CurrentTheme.ui_Text()
            var textSmallFormat:TextFormat = radioPtyText.defaultTextFormat;
            textSmallFormat.size = 14; // Ustawienie mniejszego rozmiaru tekstu
            radioPtyText.autoSize = TextFieldAutoSize.CENTER;
            radioPtyText.defaultTextFormat = textSmallFormat;
            radioPtyText.alpha = 0.6
            radioPtyText.text = "Pop";
            radioPtyText.x = w / 2 - radioPtyText.textWidth / 2;
            radioPtyText.y = h / 3 - radioFrequencyText.textHeight - 6; // Przesunięcie powyżej częstotliwości
            uiObjects.radioPtyText = radioPtyText;

            var radioRDSText:TextField = CurrentTheme.ui_Text()
            radioRDSText.defaultTextFormat = textMediumFormat;
            radioRDSText.text = "Stacja 101.1 FM";
            radioRDSText.autoSize = TextFieldAutoSize.CENTER;
            radioRDSText.x = w / 2 - radioRDSText.textWidth / 2;
            radioRDSText.y = h / 3 + radioFrequencyText.textHeight + 4; // Przesunięcie poniżej częstotliwości
            uiObjects.radioRDSText = radioRDSText;

            var radioRDSSubText:TextField = CurrentTheme.ui_Text()
            var textMediumSmallFormat:TextFormat = radioRDSSubText.defaultTextFormat;
            textMediumSmallFormat.size = 16; // Ustawienie mniejszego rozmiaru tekstu
            radioRDSSubText.defaultTextFormat = textMediumSmallFormat;
            radioRDSSubText.text = "rds rds rds rds rds rds";
            radioRDSSubText.autoSize = TextFieldAutoSize.CENTER;
            radioRDSSubText.x = w / 2 - radioRDSSubText.textWidth / 2;
            radioRDSSubText.y = h / 3 + radioFrequencyText.textHeight + radioRDSText.textHeight + 16; // Przesunięcie poniżej RDS
            uiObjects.radioRDSSubText = radioRDSSubText;

            var radioSeekPrevButton:Object = CurrentTheme.ui_Button(100, 50, "⏮");
            radioSeekPrevButton.x = w / 4 - radioSeekPrevButton.realW / 2; // Wyśrodkowanie na 1/4 szerokości
            radioSeekPrevButton.y = h - radioSeekPrevButton.realH - 20; // Wyśrodkowanie pionowe z marginesem 20
            radioSeekPrevButton.addEventListener(MouseEvent.MOUSE_DOWN, function(e:Event):void {
                Audio.tuner.setSeekPress(TunerSeek.sAUTO_DOWN);
            });
            radioSeekPrevButton.addEventListener(MouseEvent.MOUSE_UP, function(e:Event):void {
                Audio.tuner.setSeekPress(TunerSeek.sSTOP);
            });
            uiObjects.radioSeekPrevButton = radioSeekPrevButton;

            var radioSeekNextButton:Object = CurrentTheme.ui_Button(100, 50, "⏭");
            radioSeekNextButton.x = w / 4 * 3 - radioSeekNextButton.realW / 2; // Wyśrodkowanie na 3/4 szerokości
            radioSeekNextButton.y = h - radioSeekNextButton.realH - 20; // Wyśrodkowanie pionowe z marginesem 20
            radioSeekNextButton.addEventListener(MouseEvent.MOUSE_DOWN, function(e:Event):void {
                Audio.tuner.setSeekPress(TunerSeek.sAUTO_UP);
            });
            radioSeekNextButton.addEventListener(MouseEvent.MOUSE_UP, function(e:Event):void {
                Audio.tuner.setSeekPress(TunerSeek.sSTOP);
            });
            uiObjects.radioSeekNextButton = radioSeekNextButton;
        }

        public function getFormattedFrequency(frequency:uint, Audio:Object, useAudioMgr:Boolean = false) : String
        {
            var returnVal:String = "";
            var source:String = "";
            if(useAudioMgr == true)
            {
                source = Audio.audioManager.source;
                source = source.toUpperCase();
            }
            else
            {
                source = Audio.tuner.band;
            }
            if(source == TunerBand.FM)
            {
                if(false)//Global.market == TunerRegion.EUROPE)
                {
                returnVal = Number(frequency * 0.001).toFixed(2);
                }
                else
                {
                returnVal = Number(frequency * 0.001).toFixed(1);
                }
            }
            else if(source == TunerBand.MW || source == TunerBand.AM)
            {
                returnVal = String(frequency);
            }
            return returnVal;
        }

        public function setFrequency(freq:String):void{
            uiObjects.radioFrequencyContainer.getChildByName("frequency").text = freq
            var radioFrequencyText:TextField = uiObjects.radioFrequencyContainer.getChildByName("frequency")
            var radioFrequencyUnits:TextField = uiObjects.radioFrequencyContainer.getChildByName("unit")
            radioFrequencyUnits.x = radioFrequencyText.x + radioFrequencyText.textWidth + 4; // Przesunięcie w prawo od częstotliwości
            radioFrequencyUnits.y = radioFrequencyText.y + radioFrequencyText.textHeight / 2 - radioFrequencyUnits.textHeight / 2; // Wyśrodkowanie pionowo względem częstotliwości
            
        }

        public function setRDS(text:String):void{
            uiObjects.radioRDSText.text = text
        }

        public function setRDS2(text:String):void{
            uiObjects.radioRDSSubText.text = text
        }

        public function setPTY(pty:String):void{
            uiObjects.radioPtyText.text = pty
        }

        public function onStationInfo(evt:TunerEvent, Audio:Object, RDS:Boolean) : void
        {
            var frequency:uint = 0;
            var frequencyString:String = null;
            var band:String = Audio.tuner.band;
            var audioManagerBand:String = Audio.audioManager.source;
            audioManagerBand = Audio.tuner.translateAudioManagerBandToTunerBand(audioManagerBand);
            if(band == audioManagerBand)
            {
                frequency = uint(Audio.tuner.frequency);
                frequencyString = this.getFormattedFrequency(frequency, Audio);
                switch(band)
                {
                case TunerBand.AM:
                case TunerBand.MW:
                    trace("Not implemented for AM/MW yet")
                    break;
                case TunerBand.FM:
                    if(frequency > 0)
                    {
                        setFrequency(frequencyString)
                    }
                    if(RDS)
                    {

                        //TODO: reimplement rds and shit

                        if(Audio.tuner.seek == TunerSeek.sSTOP)
                        {
                            setRDS(Audio.tuner.stationName)
                        }
                        setPTY(Audio.tuner.stationProgramType)
                        if(Audio.tuner.radioTextPlus.active == false)
                        {
                            setRDS2(Audio.tuner.stationText)
                        }
                    }
                    else
                    {
                        setRDS("")
                    }
                }
            }
        }
    }
}