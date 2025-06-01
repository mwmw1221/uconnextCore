package ui
{
    import flash.display.Sprite;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.display.DisplayObject

    public class ImageToggleBtn extends Sprite {
        private var onImageLoader:Loader;
        private var offImageLoader:Loader;
        private var isOn:Boolean;

        public function ImageToggleBtn(onImageUrl:String, offImageUrl:String, invert:Boolean=false) {
            this.onImageLoader = new Loader();
            this.offImageLoader = new Loader();
            this.isOn = false;

            onImageLoader.load(new URLRequest(onImageUrl));
            offImageLoader.load(new URLRequest(offImageUrl));

            var ct:ColorTransform = new ColorTransform(
            -1, // redMultiplier
            -1, // greenMultiplier
            -1, // blueMultiplier
            1,  // alphaMultiplier
            255, // redOffset
            255, // greenOffset
            255, // blueOffset
            0   // alphaOffset
            );
            
            if(invert){
            (onImageLoader as DisplayObject).transform.colorTransform = ct;
            }

            offImageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onOffImageLoaded);
            this.buttonMode = true;

            this.addEventListener(MouseEvent.CLICK, toggleState);
        }

        private function onOffImageLoaded(event:Event):void {
            if (!isOn) {
                addChild(offImageLoader); // Domyślnie stan "off"
            }
        }

        private function toggleState(event:MouseEvent):void {
            isOn = !isOn;
            updateState();
        }

        private function updateState():void {
            removeChildren(); // Usuwa aktualny obrazek
            addChild(isOn ? onImageLoader : offImageLoader); // Dodaje odpowiedni obrazek
        }
    }
}