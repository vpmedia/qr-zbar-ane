package {

import com.sbhave.nativeExtensions.zbar.Config;
import com.sbhave.nativeExtensions.zbar.Scanner;
import com.sbhave.nativeExtensions.zbar.ScannerEvent;
import com.sbhave.nativeExtensions.zbar.Symbology;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.media.Camera;
import flash.text.TextField;

public class Main extends Sprite {

    private var s:Scanner;

    private var cameraLocation:String = "back"; // front or back or rear

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(event:Event):void {
        trace(this, "onAdded");
        trace(Camera.isSupported);
        trace(Camera.names);
        trace(Scanner.isSupported);

        removeEventListener(Event.ADDED_TO_STAGE, onAdded);

        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        // 1. Create a new Scanner() object. Whnever your design allows have only one instance of this
        s = new Scanner();

        // 2. Specify size and colors for target area for barcode scanning. Default is 100px, Red and Green
        s.setTargetArea(350, "0xFF0000FF", "0xFFABCDEF");

        // 3. Set configs, for eg enable more symbologies, set crop area, or min-max lengths for scanned data
        s.setConfig(Symbology.QRCODE, Config.ENABLE, 1);

        //4. Add event listenser so that we get notfied whenever a barcode is scanned.
        s.addEventListener(ScannerEvent.SCAN, onScan);

        //5. Actually launch the scanning UI, true means UI will automatically close after 1 scan.
        s.launch(false, cameraLocation);

        // 6. Use launched property to know if the scanner is already running.
        // Optionally call stop() to stop the scanning UI and bring the user back to the app.
        trace("Launched: " + s.launched);

    }

    private function onScan(event:ScannerEvent):void {
        // En event handler data property will give you the data that was scanned.
        trace(this, "onScan: " + event.data);
    }


}

}