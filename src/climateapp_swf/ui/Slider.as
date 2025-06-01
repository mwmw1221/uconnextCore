package ui
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.display.GradientType;
    import flash.geom.Matrix;
    import flash.display.Loader;
    import flash.net.URLRequest;

    public class Slider extends Sprite
    {
        protected var upButtonLoader:Loader;
        protected var downButtonLoader:Loader;
        protected var track:Sprite;
        protected var thumb:Sprite;
        protected var valueLabel:TextField;

        protected var minValue:Number = 0;
        protected var maxValue:Number = 100;
        protected var currentValue:Number = 0;
        protected var stepValue:Number = 1;

        public static const VALUE_CHANGED:String = "valueChanged";

        public function Slider(min:Number = 0, max:Number = 100, default_v:Number = 50, step:Number = 1)
        {
            super();
            createComponents();
            addEventListeners();
            updateThumbPosition();
            setMinValue(min);
            setMaxValue(max);
            setValue(default_v);
            stepValue = step;
        }

        private function createComponents():void
        {
            // Tworzenie toru slidera
            track = new Sprite();
            var colors:Array = [0xFF0000, 0x0000FF];
            var alphas:Array = [1, 1];
            var ratios:Array = [0, 255];
            var gradientType:String = GradientType.LINEAR;
            var matrix:Matrix = new Matrix();
            matrix.createGradientBox(20, 150, Math.PI/2, 0, 0); // Zmieniono szerokość na 20 i wysokość na 150
            track.graphics.beginGradientFill(gradientType, colors, alphas, ratios, matrix);
            track.graphics.drawRect(0, 0, 20, 150); // Zmieniono szerokość na 20 i wysokość na 150
            track.graphics.endFill();
            track.x = 20;
            track.y = 30;
            addChild(track);

            // Tworzenie suwaka (thumb)
            thumb = new Sprite();
            thumb.graphics.beginFill(0x444444, 0.5);
            thumb.graphics.drawRoundRect(0, 0, 40, 20, 10);
            thumb.graphics.endFill();
            thumb.x = 10;
            thumb.y = 30;
            addChild(thumb);

            // Tworzenie napisu na uchwycie suwaka
            valueLabel = new TextField();
            valueLabel.defaultTextFormat = new TextFormat("Arial", 12, 0xFFFFFF, true);
            valueLabel.width = 40;
            valueLabel.height = 20;
            valueLabel.mouseEnabled = false;
            valueLabel.text = currentValue.toFixed(0); // Początkowa wartość
            valueLabel.x = 10; // Pozycja względem uchwytu
            valueLabel.y = 0;
            thumb.addChild(valueLabel);

            // Tworzenie loadera dla przycisku "up"
            upButtonLoader = new Loader();
            upButtonLoader.load(new URLRequest("climate_icons/temp_up.png"));
            upButtonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
                upButtonLoader.x = track.x + (track.width - (upButtonLoader.width * 0.5)) / 2;
                upButtonLoader.y = 0;
                upButtonLoader.scaleX = 0.5;
                upButtonLoader.scaleY = 0.5;
            });
            addChild(upButtonLoader);

            // Tworzenie loadera dla przycisku "down"
            downButtonLoader = new Loader();
            downButtonLoader.load(new URLRequest("climate_icons/temp_down.png"));
            downButtonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
                downButtonLoader.x = track.x + (track.width - (downButtonLoader.width * 0.5)) / 2;
                downButtonLoader.y = 185;
                downButtonLoader.scaleX = 0.5;
                downButtonLoader.scaleY = 0.5;
            });
            addChild(downButtonLoader);
            
        }

        protected function addEventListeners():void
        {
            upButtonLoader.addEventListener(MouseEvent.CLICK, onDownButtonClick);
            downButtonLoader.addEventListener(MouseEvent.CLICK, onUpButtonClick);
            thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbMouseDown);
        }

        public function onUpButtonClick(event:MouseEvent):void
        {
            setValue(currentValue - stepValue)
        }

        public function onDownButtonClick(event:MouseEvent):void
        {
            setValue(currentValue + stepValue)
        }

        protected function onThumbMouseDown(event:MouseEvent):void
        {
            if (this.stage) // Sprawdzenie, czy stage jest dostępny
            {
                this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onThumbMouseMove);
                this.stage.addEventListener(MouseEvent.MOUSE_UP, onThumbMouseUp);
            }
            event.stopImmediatePropagation(); // Zapobiegaj natychmiastowej zmianie wartości
        }

        protected function onThumbMouseMove(event:MouseEvent):void
        {
            // Oblicz nową pozycję suwaka na podstawie pozycji myszy
            var localY:Number = this.globalToLocal(new Point(0, event.stageY)).y;
            thumb.y = localY - thumb.height / 2;

            // Ogranicz pozycję suwaka do granic toru
            if (thumb.y < track.y) thumb.y = track.y;
            if (thumb.y > track.y + track.height - thumb.height) thumb.y = track.y + track.height - thumb.height;

            // Zaktualizuj wartość slidera (odwrócony kierunek)
            var range:Number = maxValue - minValue;
            if (range > 0)
            {
                var newValue:Number = maxValue - ((thumb.y - track.y) / (track.height - thumb.height)) * range;
                if (newValue != currentValue)
                {
                    currentValue = newValue;
                    dispatchEvent(new Event(VALUE_CHANGED)); // Wywołanie zdarzenia
                }
            }
            valueLabel.text = currentValue.toFixed(0); // Aktualizacja napisu
        }

        protected function onThumbMouseUp(event:MouseEvent):void
        {
            if (this.stage) // Sprawdzenie, czy stage jest dostępny
            {
                this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onThumbMouseMove);
                this.stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbMouseUp);
            }
        }

        private function moveThumb(deltaY:Number):void
        {
            thumb.y += deltaY;
            if (thumb.y < track.y) thumb.y = track.y;
            if (thumb.y > track.y + track.height - thumb.height) thumb.y = track.y + track.height - thumb.height;

            var range:Number = maxValue - minValue;
            if (range > 0)
            {
                currentValue = minValue + ((thumb.y - track.y) / (track.height - thumb.height)) * range;
            }
        }

        public function setMinValue(value:Number):void
        {
            minValue = value;
            updateThumbPosition();
        }

        public function setMaxValue(value:Number):void
        {
            maxValue = value;
            updateThumbPosition();
        }

        public function getValue():Number
        {
            return currentValue;
        }

        public function setValue(value:Number):void
        {
            var clampedValue:Number = Math.max(minValue, Math.min(maxValue, value));
            if (clampedValue != currentValue)
            {
                currentValue = clampedValue;
                updateThumbPosition();
                dispatchEvent(new Event(VALUE_CHANGED)); // Wywołanie zdarzenia
            }
            valueLabel.text = currentValue.toFixed(0); // Aktualizacja napisu
        }

        protected function updateThumbPosition():void
        {
            var range:Number = maxValue - minValue;
            if (range > 0)
            {
                // Odwrócony kierunek
                thumb.y = track.y + (track.height - thumb.height) * ((maxValue - currentValue) / range);
            }
            valueLabel.text = currentValue.toFixed(0); // Aktualizacja napisu
        }
    }
}