package com.uconnext
{
    import flash.text.TextField;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;

    public class Log {

        public static var logBox_:TextField = null;
        private static var logFile:File = File.applicationStorageDirectory.resolvePath("latest.log");
        private static var fileStream:FileStream = new FileStream();

        public static function log(message:String, tag:String="null", logBox:TextField = null):void
        {
            logBox = logBox_;

            var date:Date = new Date();
            var formattedDate:String = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds() + "." + date.getMilliseconds();
            var logMessage:String = "[" + formattedDate + " | " + tag + "] " + message;

            // Wyświetl log w konsoli
            trace(logMessage);

            // Dodaj log do logBox, jeśli istnieje
            if (logBox != null) {
                logBox.appendText(logMessage + "\n");
            }

            // Zapisz log do pliku
            try {
                fileStream.open(logFile, FileMode.APPEND);
                fileStream.writeUTFBytes(logMessage + "\n");
                fileStream.close();
            } catch (error:Error) {
                trace("Failed to write log to file: " + error.message);
            }
        }

        // Funkcja do czyszczenia pliku logu przy starcie aplikacji
        public static function clearLogFile():void {
            trace("Log file path: " + logFile.nativePath)
            try {
                fileStream.open(logFile, FileMode.WRITE);
                fileStream.truncate(); // Wyczyść zawartość pliku
                fileStream.close();
            } catch (error:Error) {
                trace("Failed to clear log file: " + error.message);
            }
        }

        public static function get logPath():String {
            return logFile.nativePath;
        }
    }
}