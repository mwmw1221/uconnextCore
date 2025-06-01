package ui {
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.display.Sprite;
    import flash.display.GradientType;
    import flash.geom.Matrix;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.text.TextFieldAutoSize;
    import ui.Slider;
    import flash.display.Shape;
    import flash.events.Event;

    public class HorizontalSlider extends Slider {
        protected var leftButtonLoader:Loader;
        protected var rightButtonLoader:Loader;

        public function HorizontalSlider(min:Number = 0, max:Number = 100, default_v:Number = 50, step:Number = 1) {
            super(min, max, default_v, step);
            adjustGraphics();
            createButtons();
            updateThumbPosition();
        }

        private function createButtons():void {
            removeChild(upButtonLoader);
            removeChild(downButtonLoader);
            // Tworzenie loadera dla przycisku "left"
            leftButtonLoader = new Loader();
            leftButtonLoader.load(new URLRequest("climate_icons/arrow_left.png"));
            leftButtonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
                leftButtonLoader.x = 0; // Pozycja po lewej stronie toru
                leftButtonLoader.y = track.y + (track.height - leftButtonLoader.height * 0.5) / 2;
                leftButtonLoader.scaleX = 0.5;
                leftButtonLoader.scaleY = 0.5;
                addChild(leftButtonLoader);
            });

            // Tworzenie loadera dla przycisku "right"
            rightButtonLoader = new Loader();
            rightButtonLoader.load(new URLRequest("climate_icons/arrow_right.png"));
            rightButtonLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
                rightButtonLoader.x = track.x + track.width + 10; // Pozycja po prawej stronie toru
                rightButtonLoader.y = track.y + (track.height - rightButtonLoader.height * 0.5) / 2;
                rightButtonLoader.scaleX = 0.5;
                rightButtonLoader.scaleY = 0.5;
                addChild(rightButtonLoader);
            });

            // Dodanie nasłuchiwaczy zdarzeń
            leftButtonLoader.addEventListener(MouseEvent.CLICK, onLeftButtonClick);
            rightButtonLoader.addEventListener(MouseEvent.CLICK, onRightButtonClick);
        }

        private function adjustGraphics():void {
            // Dostosowanie toru do poziomego układu
            track.graphics.clear();
            track.graphics.beginFill(0xCCCCCC);
            track.graphics.drawRect(0, 0, 150, 20); // Poziomy tor
            track.graphics.endFill();
            track.x = 30;
            track.y = 20;

            // Dostosowanie uchwytu (thumb)
            thumb.x = track.x;
            thumb.y = track.y - (thumb.height - track.height) / 2;
        }

        override protected function addEventListeners():void {
            upButtonLoader.removeEventListener(MouseEvent.CLICK, super.onDownButtonClick);
            downButtonLoader.removeEventListener(MouseEvent.CLICK, super.onUpButtonClick);
            upButtonLoader.addEventListener(MouseEvent.CLICK, onLeftButtonClick); // Obsługa przycisku w lewo
            downButtonLoader.addEventListener(MouseEvent.CLICK, onRightButtonClick); // Obsługa przycisku w prawo
        }

        private function onLeftButtonClick(event:MouseEvent):void {
            setValue(currentValue - stepValue); // Zmniejsz wartość (lewo)
        }

        private function onRightButtonClick(event:MouseEvent):void {
            setValue(currentValue + stepValue); // Zwiększ wartość (prawo)
        }

        override protected function onThumbMouseMove(event:MouseEvent):void {
            if (!stage) return; // Upewnij się, że stage jest dostępny

            // Oblicz nową pozycję suwaka na podstawie pozycji myszy
            var localX:Number = this.globalToLocal(new Point(event.stageX, 0)).x;
            thumb.x = Math.max(track.x, Math.min(localX - thumb.width / 2, track.x + track.width - thumb.width));

            // Zaktualizuj wartość slidera
            var range:Number = maxValue - minValue;
            if (range > 0) {
                var newValue:Number = minValue + ((thumb.x - track.x) / (track.width - thumb.width)) * range;
                if (newValue != currentValue) {
                    currentValue = newValue;
                    dispatchEvent(new Event(VALUE_CHANGED)); // Wywołanie zdarzenia
                }
            }
            valueLabel.text = currentValue.toFixed(0); // Aktualizacja napisu
        }

        override protected function onThumbMouseDown(event:MouseEvent):void {
            if (stage) {
                stage.addEventListener(MouseEvent.MOUSE_MOVE, onThumbMouseMove);
                stage.addEventListener(MouseEvent.MOUSE_UP, onThumbMouseUp);
            }
            event.stopImmediatePropagation(); // Zapobiegaj natychmiastowej zmianie wartości
        }

        override protected function onThumbMouseUp(event:MouseEvent):void {
            if (stage) {
                stage.removeEventListener(MouseEvent.MOUSE_MOVE, onThumbMouseMove);
                stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbMouseUp);
            }
        }

        override protected function updateThumbPosition():void {
            var range:Number = maxValue - minValue;
            if (range > 0) {
                // Poprawione obliczenia pozycji uchwytu
                thumb.x = track.x + (track.width - 40) * ((currentValue - minValue) / range);
            } else {
                thumb.x = track.x; // Domyślna pozycja, jeśli zakres jest zerowy
            }
            valueLabel.text = currentValue.toFixed(0); // Aktualizacja napisu
        }
    }
}