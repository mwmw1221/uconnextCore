package com.uconnext.ui
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import com.uconnext.api.v1.CurrentTheme;

    public class Slider extends Sprite
    {
        private var track:Sprite;
        private var thumb:Sprite;

        private var minValue:Number = 0;
        private var maxValue:Number = 100;
        private var currentValue:Number = 50;
        private var stepValue:Number = 1;

        public static const VALUE_CHANGED:String = "valueChanged";

        public function Slider()
        {
            super();
        }

        public function create(width:int,min:Number = 0, max:Number = 100, defaultValue:Number = 50, step:Number = 1):Slider
        {
            createComponents(width);
            addEventListeners();
            setMinValue(min);
            setMaxValue(max);
            setValue(defaultValue);
            stepValue = step;

            return this;
        }

        private function createComponents(w:int):void
        {
            // Tworzenie toru slidera
            track = new Sprite();
            track.graphics.beginFill(CurrentTheme.currentTheme.containerColor); // Kolor toru
            track.graphics.drawRoundRect(0, 0, w, 10, CurrentTheme.currentTheme.roundRadius); // Szerokość 200, wysokość 20
            track.graphics.endFill();
            addChild(track);

            // Tworzenie suwaka (thumb)
            thumb = new Sprite();
            thumb.graphics.beginFill(CurrentTheme.currentTheme.accentColor); // Kolor suwaka
            thumb.graphics.drawCircle(0, 0, 10); // Promień suwaka 10
            thumb.graphics.endFill();
            thumb.x = 100; // Początkowa pozycja suwaka
            thumb.y = track.height / 2; // Wyśrodkowanie suwaka na torze
            addChild(thumb);
        }

        private function addEventListeners():void
        {
            thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbMouseDown);
        }

        private function onThumbMouseDown(event:MouseEvent):void
        {
            if (this.stage) // Sprawdzenie, czy stage jest dostępny
            {
                this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onThumbMouseMove);
                this.stage.addEventListener(MouseEvent.MOUSE_UP, onThumbMouseUp);
            }
            event.stopImmediatePropagation(); // Zapobiegaj natychmiastowej zmianie wartości
        }

        private function onThumbMouseMove(event:MouseEvent):void
        {
            // Oblicz nową pozycję suwaka na podstawie pozycji myszy
            var localX:Number = this.globalToLocal(new Point(event.stageX, 0)).x;
            thumb.x = localX;

            // Ogranicz pozycję suwaka do granic toru
            if (thumb.x < track.x) thumb.x = track.x;
            if (thumb.x > track.x + track.width) thumb.x = track.x + track.width;

            // Zaktualizuj wartość slidera
            var range:Number = maxValue - minValue;
            if (range > 0)
            {
                var newValue:Number = minValue + ((thumb.x - track.x) / track.width) * range;
                if (newValue != currentValue)
                {
                    currentValue = newValue;
                    dispatchEvent(new Event(VALUE_CHANGED)); // Wywołanie zdarzenia
                }
            }
        }

        private function onThumbMouseUp(event:MouseEvent):void
        {
            if (this.stage) // Sprawdzenie, czy stage jest dostępny
            {
                this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onThumbMouseMove);
                this.stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbMouseUp);
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
        }

        private function updateThumbPosition():void
        {
            var range:Number = maxValue - minValue;
            if (range > 0)
            {
                thumb.x = track.x + (track.width) * ((currentValue - minValue) / range);
            }
        }
    }
}