package com.uconnext.api.v1
{
    import flash.events.EventDispatcher;
    import peripheral.Peripheral;
    import com.nfuzion.moduleLinkAPI.IAudioManager;
    import com.nfuzion.moduleLinkAPI.IAudioSettings;
    import com.nfuzion.moduleLinkAPI.IHdTuner;
    import com.nfuzion.moduleLinkAPI.IMediaPlayer;
    import com.harman.moduleLinkAPI.IAudioMixerManager;
    import com.nfuzion.moduleLinkAPI.MediaPlayerDevice;
    import com.nfuzion.moduleLink.MediaPlayer;
    import com.nfuzion.moduleLinkAPI.MediaPlayerPath;
    import com.nfuzion.moduleLinkAPI.MediaPlayerTrackInfo;
    import com.uconnext.Log;

    // uConnext Audio API v1

    // This class is experimental and may change in the future.

    // This class provides an interface to manage audio functionalities
    // such as volume control, media playback, and tuning.

    // TODO: Add validation for all methods.
    // TODO: Add documentation for all methods.

    public class Audio extends EventDispatcher
    {
        public function Audio()
        {
            super();
            Log.log("Audio API initialized", "api.Audio");
        }

        public function get audioManager() : IAudioManager
        {
            return Peripheral.audioManager;
        }

        public function get audioSettings() : IAudioSettings
        {
            return Peripheral.audioSettings;
        }

        public function get tuner() : IHdTuner
        {
            return Peripheral.tuner;
        }

        public function get mediaPlayer() : IMediaPlayer
        {
            return Peripheral.mediaPlayer;
        }

        public function get audioMixerManager() : IAudioMixerManager
        {
            return Peripheral.audioMixerManager;
        }

        // AudioManager

        public function set currentSource(source:String):void
        {
            try {
                Log.log("setSource: " + source, "api.Audio");
                audioManager.setSource(source);
            } catch (error:Error) {
                Log.log("Error in setSource: " + error.message, "api.Audio");
            }
        }

        public function get currentSource():String
        {
            try {
                Log.log("get currentSource", "api.Audio");
                return audioManager.source;
            } catch (error:Error) {
                Log.log("Error in get currentSource: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get sources():Array{
            try {
                Log.log("get sources", "api.Audio");
                var sources:Array = [];

                var audioSources : Vector.<String> = audioManager.mediaSources;
                audioSources = audioSources + audioManager.radioSources;

                for (var i:int = 0; i < audioSources.length; i++)
                {
                    var obj:Object = new Object()

                    obj.source = audioSources[i];
                    if (audioManager.isSourceRadio(audioSources[i])) {
                        obj.type = "radio";
                    } else if (audioManager.isSourceMedia(audioSources[i])) {
                        obj.type = "media";
                    } else {
                        obj.type = "other";
                    }
                    obj.available = audioManager.isSourceAvailable(audioSources[i]);
                    obj.hardwareAvailable = audioManager.isHardwareAvailable(audioSources[i]);

                    sources.push(obj);
                }

                return sources;
            } catch (error:Error) {
                Log.log("Error in get sources: " + error.message, "api.Audio");
                return [];
            }
        }

        public function isSourceMediaService(source:String):Boolean
        {
            try {
                Log.log("isSourceMediaService: " + source, "api.Audio");
                return audioManager.isSourceMediaService(source);
            } catch (error:Error) {
                Log.log("Error in isSourceMediaService: " + error.message, "api.Audio");
                return false;
            }
        }

        public function isSourceAvailable(source:String):Boolean
        {
            try {
                Log.log("isSourceAvailable: " + source, "api.Audio");
                return audioManager.isSourceAvailable(source);
            } catch (error:Error) {
                Log.log("Error in isSourceAvailable: " + error.message, "api.Audio");
                return false;
            }
        }

        public function refreshSources():void
        {
            try {
                Log.log("refreshSources", "api.Audio");
                audioManager.refreshSource();
            } catch (error:Error) {
                Log.log("Error in refreshSources: " + error.message, "api.Audio");
            }
        }

        public function getSourceObject(source:String):Object
        {
            try {
                Log.log("getSourceObject: " + source, "api.Audio");
                var obj:Object = new Object();
                
                if (audioManager.isSourceRadio(source)) {
                    obj.type = "radio";
                } else if (audioManager.isSourceMedia(source)) {
                    obj.type = "media";
                } else {
                    obj.type = "other";
                }
                obj.source = source;
                obj.available = audioManager.isSourceAvailable(source);
                obj.hardwareAvailable = audioManager.isHardwareAvailable(source);

                return obj;
            } catch (error:Error) {
                Log.log("Error in getSourceObject: " + error.message, "api.Audio");
                return null;
            }
        }

        public function beep():void
        {
            try {
                Log.log("beep", "api.Audio");
                audioManager.sendAudioBeep();
            } catch (error:Error) {
                Log.log("Error in beep: " + error.message, "api.Audio");
            }
        }

        public function alertTone(tone:String):void
        {
            try {
                Log.log("alertTone: " + tone, "api.Audio");
                audioManager.sendAlertTone(tone);
            } catch (error:Error) {
                Log.log("Error in alertTone: " + error.message, "api.Audio");
            }
        }

        // AudioSettings

        public function get volume():Number
        {
            try {
                Log.log("get volume", "api.Audio");
                return audioSettings.volumeRaw;
            } catch (error:Error) {
                Log.log("Error in get volume: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function set volume(value:Number):void
        {
            try {
                Log.log("set volume: " + value, "api.Audio");
                audioSettings.volumeRaw = value;
            } catch (error:Error) {
                Log.log("Error in set volume: " + error.message, "api.Audio");
            }
        }

        public function get mute():Boolean
        {
            try {
                Log.log("get mute", "api.Audio");
                audioSettings.requestMute();
                return audioSettings.mute;
            } catch (error:Error) {
                Log.log("Error in get mute: " + error.message, "api.Audio");
                return false;
            }
        }

        public function set mute(value:Boolean):void
        {
            try {
                Log.log("set mute: " + value, "api.Audio");
                audioSettings.setMute(value);
            } catch (error:Error) {
                Log.log("Error in set mute: " + error.message, "api.Audio");
            }
        }

        public function get balanceFade():Array
        {
            try {
                Log.log("get balanceFade", "api.Audio");
                audioSettings.requestBalanceFade();
                return [audioSettings.balance, audioSettings.fade];
            } catch (error:Error) {
                Log.log("Error in get balanceFade: " + error.message, "api.Audio");
                return [];
            }
        }

        public function set balanceFade(value:Array):void
        {
            try {
                Log.log("set balanceFade: " + value, "api.Audio");
                audioSettings.setBalanceFade(value[0], value[1]);
            } catch (error:Error) {
                Log.log("Error in set balanceFade: " + error.message, "api.Audio");
            }
        }

        public function get equalizer():Object
        {
            try {
                Log.log("get equalizer", "api.Audio");
                audioSettings.requestBass();
                audioSettings.requestTreble();
                audioSettings.requestMid();
                return {
                    bass: audioSettings.bass,
                    treble: audioSettings.treble,
                    mid: audioSettings.mid
                };
            } catch (error:Error) {
                Log.log("Error in get equalizer: " + error.message, "api.Audio");
                return null;
            }
        }

        public function set equalizer(value:Object):void
        {
            try {
                Log.log("set equalizer: " + value, "api.Audio");
                audioSettings.setBass(value.bass);
                audioSettings.setTreble(value.treble);
                audioSettings.setMid(value.mid);
            } catch (error:Error) {
                Log.log("Error in set equalizer: " + error.message, "api.Audio");
            }
        }

        public function get speedAdjVolume():Number
        {
            try {
                Log.log("get speedAdjVolume", "api.Audio");
                audioSettings.requestSpeedVolume();
                return audioSettings.speedVolume;
            } catch (error:Error) {
                Log.log("Error in get speedAdjVolume: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function set speedAdjVolume(value:Number):void
        {
            try {
                Log.log("set speedAdjVolume: " + value, "api.Audio");
                audioSettings.setSpeedVolume(value);
            } catch (error:Error) {
                Log.log("Error in set speedAdjVolume: " + error.message, "api.Audio");
            }
        }

        public function get surroundAvailable():Boolean
        {
            try {
                Log.log("get surroundAvailable", "api.Audio");
                audioSettings.requestSurroundSoundAvailable();
                return audioSettings.surroundSoundAvailable;
            } catch (error:Error) {
                Log.log("Error in get surroundAvailable: " + error.message, "api.Audio");
                return false;
            }
        }

        public function set surroundAvailable(value:Boolean):void
        {
            try {
                Log.log("set surroundAvailable: " + value, "api.Audio");
                audioSettings.setSurroundSoundAvailable(value);
            } catch (error:Error) {
                Log.log("Error in set surroundAvailable: " + error.message, "api.Audio");
            }
        }

        public function get surroundStatus():Boolean
        {
            try {
                Log.log("get surroundStatus", "api.Audio");
                audioSettings.requestSurroundSoundStatus();
                return audioSettings.surroundSoundStatus;
            } catch (error:Error) {
                Log.log("Error in get surroundStatus: " + error.message, "api.Audio");
                return false;
            }
        }

        public function set surroundStatus(value:Boolean):void
        {
            try {
                Log.log("set surroundStatus: " + value, "api.Audio");
                audioSettings.setSurroundSoundStatus(value);
            } catch (error:Error) {
                Log.log("Error in set surroundStatus: " + error.message, "api.Audio");
            }
        }

        public function get loudness():Boolean
        {
            try {
                Log.log("get loudness", "api.Audio");
                audioSettings.requestLoudness();
                return audioSettings.Loudness;
            } catch (error:Error) {
                Log.log("Error in get loudness: " + error.message, "api.Audio");
                return false;
            }
        }

        public function set loudness(value:Boolean):void
        {
            try {
                Log.log("set loudness: " + value, "api.Audio");
                audioSettings.setLoudness(value);
            } catch (error:Error) {
                Log.log("Error in set loudness: " + error.message, "api.Audio");
            }
        }

        public function get twoChannelMode():Boolean
        {
            try {
                Log.log("get twoChannelMode", "api.Audio");
                return audioSettings.twoChannelMode;
            } catch (error:Error) {
                Log.log("Error in get twoChannelMode: " + error.message, "api.Audio");
                return false;
            }
        }

        public function get boosterAmpPresent():Boolean
        {
            try {
                Log.log("get boosterAmpPresent", "api.Audio");
                return audioSettings.boosterAmpPresent;
            } catch (error:Error) {
                Log.log("Error in get boosterAmpPresent: " + error.message, "api.Audio");
                return false;
            }
        }

        public function get interruptStatus():Boolean
        {
            try {
                Log.log("get interruptStatus", "api.Audio");
                audioSettings.getInterruptStatus();
                return audioSettings.interruptStatus;
            } catch (error:Error) {
                Log.log("Error in get interruptStatus: " + error.message, "api.Audio");
                return false;
            }
        }

        // HdTuner

        public function setHDFrequency(param1:uint, param2:Number):void
        {
            try {
                Log.log("setHDFrequency: " + param1 + ", " + param2, "api.Audio");
                tuner.setHdFrequency(param1, param2);
            } catch (error:Error) {
                Log.log("Error in setHDFrequency: " + error.message, "api.Audio");
            }
        }

        public function get hdMode():uint
        {
            try {
                Log.log("get hdMode", "api.Audio");
                tuner.requestHDStatusInfo();
                return tuner.hdMode;
            } catch (error:Error) {
                Log.log("Error in get hdMode: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function set hdMode(param1:uint):void
        {
            try {
                Log.log("set hdMode: " + param1, "api.Audio");
                tuner.setHdMode(Number(param1));
            } catch (error:Error) {
                Log.log("Error in set hdMode: " + error.message, "api.Audio");
            }
        }

        public function get hdBERMode():uint
        {
            try {
                Log.log("get hdBERMode", "api.Audio");
                tuner.requestHDStatusInfo();
                return tuner.hdBERMode;
            } catch (error:Error) {
                Log.log("Error in get hdBERMode: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function set hdBERMode(param1:uint):void
        {
            try {
                Log.log("set hdBERMode: " + param1, "api.Audio");
                tuner.setHdBERMode(Number(param1));
            } catch (error:Error) {
                Log.log("Error in set hdBERMode: " + error.message, "api.Audio");
            }
        }

        public function setHDPerformanceMode(param1:Boolean):void
        {
            try {
                Log.log("setHDPerformanceMode: " + param1, "api.Audio");
                tuner.setHdPerformanceMode(param1);
            } catch (error:Error) {
                Log.log("Error in setHDPerformanceMode: " + error.message, "api.Audio");
            }
        }

        public function get hdPerformanceInfo():Object
        {
            try {
                Log.log("get hdPerformanceInfo", "api.Audio");
                tuner.requestHDStatusInfo();
                return tuner.hdPerformanceInfo;
            } catch (error:Error) {
                Log.log("Error in get hdPerformanceInfo: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get currentHdSubchannel():int
        {
            try {
                Log.log("get currentHdSubchannel", "api.Audio");
                tuner.requestHDStatusInfo();
                return tuner.currentHdSubchannel;
            } catch (error:Error) {
                Log.log("Error in get currentHdSubchannel: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function get programsAvailable():Vector.<int>
        {
            try {
                Log.log("get programsAvailable", "api.Audio");
                tuner.requestHDStationInfo();
                return tuner.programsAvailable;
            } catch (error:Error) {
                Log.log("Error in get programsAvailable: " + error.message, "api.Audio");
                return new Vector.<int>();
            }
        }

        public function getStationInfo():Object
        {
            try {
                Log.log("getStationInfo", "api.Audio");
                tuner.requestHDStationInfo();
                return {
                    hdPTY: tuner.hdPTY,
                    hdStationLongName: tuner.hdStationLongName,
                    hdStationShortName: tuner.hdStationShortName,
                    hdArtistName: tuner.hdArtistName,
                    hdSongTitle: tuner.hdSongTitle,
                    hdAlbumName: tuner.hdAlbumName,
                    hdTagAvailable: tuner.hdTagAvailable,
                    hdTagged: tuner.hdTagged
                };
            } catch (error:Error) {
                Log.log("Error in getStationInfo: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get hdSwVersion():String
        {
            try {
                Log.log("get hdSwVersion", "api.Audio");
                tuner.requestHdSwVersion();
                return tuner.hdSwVersion;
            } catch (error:Error) {
                Log.log("Error in get hdSwVersion: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get currentHDProgramAvailable():Boolean
        {
            try {
                Log.log("get currentHDProgramAvailable", "api.Audio");
                tuner.requestHDStationInfo();
                return tuner.currentHDProgramAvailable;
            } catch (error:Error) {
                Log.log("Error in get currentHDProgramAvailable: " + error.message, "api.Audio");
                return false;
            }
        }

        public function tagCurrentSong():Boolean
        {
            try {
                Log.log("tagCurrentSong", "api.Audio");
                return tuner.addTagToCurrentSong();
            } catch (error:Error) {
                Log.log("Error in tagCurrentSong: " + error.message, "api.Audio");
                return false;
            }
        }

        public function get hdAcquisitionStatus():uint
        {
            try {
                Log.log("get hdAcquisitionStatus", "api.Audio");
                tuner.requestHDStatusInfo();
                return tuner.hdAcquisitionStatus;
            } catch (error:Error) {
                Log.log("Error in get hdAcquisitionStatus: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function get hdSisStatus():uint
        {
            try {
                Log.log("get hdSisStatus", "api.Audio");
                tuner.requestHDStatusInfo();
                return tuner.hdSisStatus;
            } catch (error:Error) {
                Log.log("Error in get hdSisStatus: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function get hdDigitalAudioAcquired():uint
        {
            try {
                Log.log("get hdDigitalAudioAcquired", "api.Audio");
                tuner.requestHDStatusInfo();
                return tuner.hdDigitalAudioAcquired;
            } catch (error:Error) {
                Log.log("Error in get hdDigitalAudioAcquired: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function get hdStatusMsg():String
        {
            try {
                Log.log("get hdStatusMsg", "api.Audio");
                tuner.requestHDStatusInfo();
                return tuner.hdStatusMsg;
            } catch (error:Error) {
                Log.log("Error in get hdStatusMsg: " + error.message, "api.Audio");
                return null;
            }
        }

        // Tuner

        public function set region(param1:String):void
        {
            try {
                Log.log("set region: " + param1, "api.Audio");
                tuner.setRegion(param1);
            } catch (error:Error) {
                Log.log("Error in set region: " + error.message, "api.Audio");
            }
        }

        public function get region():String
        {
            try {
                Log.log("get region", "api.Audio");
                tuner.getRegion();
                return tuner.region;
            } catch (error:Error) {
                Log.log("Error in get region: " + error.message, "api.Audio");
                return null;
            }
        }

        public function set market(param1:String):void
        {
            try {
                Log.log("set market: " + param1, "api.Audio");
                tuner.setMarket(param1);
            } catch (error:Error) {
                Log.log("Error in set market: " + error.message, "api.Audio");
            }
        }

        public function get isHdAvailable():Boolean
        {
            try {
                Log.log("get isHdAvailable", "api.Audio");
                return tuner.isHdAvailable;
            } catch (error:Error) {
                Log.log("Error in get isHdAvailable: " + error.message, "api.Audio");
                return false;
            }
        }

        public function get supportRDS():Boolean
        {
            try {
                Log.log("get supportRDS", "api.Audio");
                return tuner.supportRDS;
            } catch (error:Error) {
                Log.log("Error in get supportRDS: " + error.message, "api.Audio");
                return false;
            }
        }

        public function get band():String
        {
            try {
                Log.log("get band", "api.Audio");
                tuner.getBand();
                return tuner.band;
            } catch (error:Error) {
                Log.log("Error in get band: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get available():Boolean
        {
            try {
                Log.log("get available", "api.Audio");
                return tuner.available;
            } catch (error:Error) {
                Log.log("Error in get available: " + error.message, "api.Audio");
                return false;
            }
        }

        public function set frequency(param1:uint):void
        {
            try {
                Log.log("set frequency: " + param1, "api.Audio");
                tuner.setFrequency(param1);
            } catch (error:Error) {
                Log.log("Error in set frequency: " + error.message, "api.Audio");
            }
        }

        public function get frequency():uint
        {
            try {
                Log.log("get frequency", "api.Audio");
                return tuner.frequency;
            } catch (error:Error) {
                Log.log("Error in get frequency: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function get frequencyMin():Number
        {
            try {
                Log.log("get frequencyMin", "api.Audio");
                return tuner.frequencyMin;
            } catch (error:Error) {
                Log.log("Error in get frequencyMin: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function get frequencyMax():Number
        {
            try {
                Log.log("get frequencyMax", "api.Audio");
                return tuner.frequencyMax;
            } catch (error:Error) {
                Log.log("Error in get frequencyMax: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function get frequencyStep():Number
        {
            try {
                Log.log("get frequencyStep", "api.Audio");
                return tuner.frequencyStepSize;
            } catch (error:Error) {
                Log.log("Error in get frequencyStep: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function seekPress(param1:String = ""):void
        {
            try {
                Log.log("seekPress: " + param1, "api.Audio");
                tuner.setSeekPress(param1);
            } catch (error:Error) {
                Log.log("Error in seekPress: " + error.message, "api.Audio");
            }
        }

        public function seekRelease():void
        {
            try {
                Log.log("seekRelease", "api.Audio");
                tuner.setSeekRelease();
            } catch (error:Error) {
                Log.log("Error in seekRelease: " + error.message, "api.Audio");
            }
        }

        public function get seek():String
        {
            try {
                Log.log("get seek", "api.Audio");
                return tuner.seek;
            } catch (error:Error) {
                Log.log("Error in get seek: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get stationQuality():uint
        {
            try {
                Log.log("get stationQuality", "api.Audio");
                return tuner.stationQuality;
            } catch (error:Error) {
                Log.log("Error in get stationQuality: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function get stationStereo():Boolean
        {
            try {
                Log.log("get stationStereo", "api.Audio");
                tuner.getStationStereo();
                return tuner.stationStereo;
            } catch (error:Error) {
                Log.log("Error in get stationStereo: " + error.message, "api.Audio");
                return false;
            }
        }

        public function get stationName():String
        {
            try {
                Log.log("get stationName", "api.Audio");
                return tuner.stationName;
            } catch (error:Error) {
                Log.log("Error in get stationName: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get stationPTY():String
        {
            try {
                Log.log("get stationPTY", "api.Audio");
                return tuner.stationProgramType;
            } catch (error:Error) {
                Log.log("Error in get stationPTY: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get stationText():String
        {
            try {
                Log.log("get stationText", "api.Audio");
                tuner.getStationText();
                return tuner.stationText;
            } catch (error:Error) {
                Log.log("Error in get stationText: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get availableStations():Vector.<Object>
        {
            try {
                Log.log("get availableStations", "api.Audio");
                return tuner.availableStations;
            } catch (error:Error) {
                Log.log("Error in get availableStations: " + error.message, "api.Audio");
                return new Vector.<Object>();
            }
        }

        public function tunerSeekInteruptHdlr(param1:String):Boolean
        {
            try {
                Log.log("tunerSeekInteruptHdlr: " + param1, "api.Audio");
                //TODO: better name for this method
                return tuner.tunerSeekInteruptHdlr(param1);
            } catch (error:Error) {
                Log.log("Error in tunerSeekInteruptHdlr: " + error.message, "api.Audio");
                return false;
            }
        }

        public function get afStatus():Boolean
        {
            try {
                Log.log("get afStatus", "api.Audio");
                tuner.requestAfFreqencyStatus();
                return tuner.afStatus;
            } catch (error:Error) {
                Log.log("Error in get afStatus: " + error.message, "api.Audio");
                return false;
            }
        }

        public function set afStatus(param1:Boolean):void
        {
            try {
                Log.log("set afStatus: " + param1, "api.Audio");
                tuner.setAfFreqencyStatus(param1);
            } catch (error:Error) {
                Log.log("Error in set afStatus: " + error.message, "api.Audio");
            }
        }

        public function get regStatus():Boolean
        {
            try {
                Log.log("get regStatus", "api.Audio");
                tuner.requestRegionalizationStatus();
                return tuner.regStatus;
            } catch (error:Error) {
                Log.log("Error in get regStatus: " + error.message, "api.Audio");
                return false;
            }
        }

        public function set regStatus(param1:Boolean):void
        {
            try {
                Log.log("set regStatus: " + param1, "api.Audio");
                tuner.setRegionalizationStatus(param1);
            } catch (error:Error) {
                Log.log("Error in set regStatus: " + error.message, "api.Audio");
            }
        }

        public function get tpStatus():Boolean
        {
            try {
                Log.log("get tpStatus", "api.Audio");
                tuner.requestTPStatus();
                return tuner.tpStatus;
            } catch (error:Error) {
                Log.log("Error in get tpStatus: " + error.message, "api.Audio");
                return false;
            }
        }

        public function set tpStatus(param1:Boolean):void
        {
            try {
                Log.log("set tpStatus: " + param1, "api.Audio");
                tuner.setTPStatus(param1);
            } catch (error:Error) {
                Log.log("Error in set tpStatus: " + error.message, "api.Audio");
            }
        }

        public function set tuneEnabled(param1:Boolean):void
        {
            try {
                Log.log("set tuneEnabled: " + param1, "api.Audio");
                tuner.setTuneKnobEnabled(param1);
            } catch (error:Error) {
                Log.log("Error in set tuneEnabled: " + error.message, "api.Audio");
            }
        }

        public function requestTAEscape():void
        {
            try {
                Log.log("requestTAEscape", "api.Audio");
                tuner.requestTAEscape();
            } catch (error:Error) {
                Log.log("Error in requestTAEscape: " + error.message, "api.Audio");
            }
        }

        public function requestPTY31Escape():void
        {
            try {
                Log.log("requestPTY31Escape", "api.Audio");
                tuner.requestPTY31Escape();
            } catch (error:Error) {
                Log.log("Error in requestPTY31Escape: " + error.message, "api.Audio");
            }
        }

        public function get stationListSortType():String
        {
            try {
                Log.log("get stationListSortType", "api.Audio");
                return tuner.stationListSortType;
            } catch (error:Error) {
                Log.log("Error in get stationListSortType: " + error.message, "api.Audio");
                return null;
            }
        }

        public function set stationListSortType(param1:String):void
        {
            try {
                Log.log("set stationListSortType: " + param1, "api.Audio");
                tuner.stationListSortType = param1;
            } catch (error:Error) {
                Log.log("Error in set stationListSortType: " + error.message, "api.Audio");
            }
        }

        public function getItemFromStationList(param1:int, param2:String):String
        {
            try {
                Log.log("getItemFromStationList: " + param1 + ", " + param2, "api.Audio");
                return tuner.getItemFromStationList(param1, param2);
            } catch (error:Error) {
                Log.log("Error in getItemFromStationList: " + error.message, "api.Audio");
                return null;
            }
        }

        public function set diagMode(param1:Boolean):void
        {
            try {
                Log.log("set diagMode: " + param1, "api.Audio");
                if (param1) {
                    tuner.requestSetDiagModeOn();
                } else {
                    tuner.requestSetDiagModeOff();
                }
            } catch (error:Error) {
                Log.log("Error in set diagMode: " + error.message, "api.Audio");
            }
        }

        public function requestSetDiagFrequency():void
        {
            try {
                Log.log("requestSetDiagFrequency", "api.Audio");
                tuner.requestSetDiagFrequency();
            } catch (error:Error) {
                Log.log("Error in requestSetDiagFrequency: " + error.message, "api.Audio");
            }
        }

        public function get stationRDSInfo():Object
        {
            try {
                Log.log("get stationRDSInfo", "api.Audio");
                tuner.requestRDSData();
                return tuner.tunerDiagRDSInfo;
            } catch (error:Error) {
                Log.log("Error in get stationRDSInfo: " + error.message, "api.Audio");
                return null;
            }
        }

        //TODO: Add the diagnostic functions for tuner

        public function get tmcStations():Array
        {
            try {
                Log.log("get tmcStations", "api.Audio");
                tuner.requestTmcStations();
                return tuner.tmcStations;
            } catch (error:Error) {
                Log.log("Error in get tmcStations: " + error.message, "api.Audio");
                return [];
            }
        }

        public function get presetPos():int
        {
            try {
                Log.log("get presetPos", "api.Audio");
                return tuner.presetPositionNone;
            } catch (error:Error) {
                Log.log("Error in get presetPos: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function getPresetFromPos(param1:String):int
        {
            try {
                Log.log("getPresetFromPos: " + param1, "api.Audio");
                return tuner.bandPresetPosition(param1);
            } catch (error:Error) {
                Log.log("Error in getPresetFromPos: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function translateBands(direction:Boolean, band:String):String{
            try {
                Log.log("translateBands: " + direction + ", " + band, "api.Audio");
                if(direction){
                    return tuner.translateAudioManagerBandToTunerBand(band);
                }else{
                    return tuner.translateTunerBandToAudioManagerBand(band);
                }
            } catch (error:Error) {
                Log.log("Error in translateBands: " + error.message, "api.Audio");
                return null;
            }
        }

        public function recallPreset(param1:int):void
        {
            try {
                Log.log("recallPreset: " + param1, "api.Audio");
                tuner.requestRecallPreset(param1);
            } catch (error:Error) {
                Log.log("Error in recallPreset: " + error.message, "api.Audio");
            }
        }

        public function storePreset(param1:int):void
        {
            try {
                Log.log("storePreset: " + param1, "api.Audio");
                tuner.requestStorePreset(param1);
            } catch (error:Error) {
                Log.log("Error in storePreset: " + error.message, "api.Audio");
            }
        }

        public function clearPreset(param1:int):void
        {
            try {
                Log.log("clearPreset: " + param1, "api.Audio");
                tuner.requestClearPreset(param1);
            } catch (error:Error) {
                Log.log("Error in clearPreset: " + error.message, "api.Audio");
            }
        }

        public function get RDSPlus():Object
        {
            try {
                Log.log("get RDSPlus", "api.Audio");
                return tuner.radioTextPlus;
            } catch (error:Error) {
                Log.log("Error in get RDSPlus: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get pi():int
        {
            try {
                Log.log("get pi", "api.Audio");
                return tuner.pi;
            } catch (error:Error) {
                Log.log("Error in get pi: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function get advisoryMessageType():String
        {
            try {
                Log.log("get advisoryMessageType", "api.Audio");
                return tuner.advisoryMessageType;
            } catch (error:Error) {
                Log.log("Error in get advisoryMessageType: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get stationNameField():String
        {
            try {
                Log.log("get stationNameField", "api.Audio");
                return tuner.stationNameField;
            } catch (error:Error) {
                Log.log("Error in get stationNameField: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get stationGenreField():String
        {
            try {
                Log.log("get stationGenreField", "api.Audio");
                return tuner.stationGenreField;
            } catch (error:Error) {
                Log.log("Error in get stationGenreField: " + error.message, "api.Audio");
                return null;
            }
        }

        public function setPiFreq(param1:uint, param2:uint):void
        {
            try {
                Log.log("setPiFreq: " + param1 + ", " + param2, "api.Audio");
                tuner.setPIFreq(param1, param2);
            } catch (error:Error) {
                Log.log("Error in setPiFreq: " + error.message, "api.Audio");
            }
        }

        // MediaPlayer

        public function get devices():Array
        {
            try {
                Log.log("get devices", "api.Audio");
                mediaPlayer.getDevices();
                var devices:Array = [];
                var deviceList:Vector.<MediaPlayerDevice> = mediaPlayer.devices;
                for (var i:int = 0; i < deviceList.length; i++)
                {
                    devices.push(deviceList[i]);
                }
                return devices;
            } catch (error:Error) {
                Log.log("Error in get devices: " + error.message, "api.Audio");
                return [];
            }
        }

        public function deSelectActiveDevice():void
        {
            try {
                Log.log("deSelectActiveDevice", "api.Audio");
                mediaPlayer.deSelectActiveDevice();
            } catch (error:Error) {
                Log.log("Error in deSelectActiveDevice: " + error.message, "api.Audio");
            }
        }

        public function getDevice(param1:int = -1):void
        {
            try {
                Log.log("getDevice: " + param1, "api.Audio");
                mediaPlayer.getDevice(param1);
            } catch (error:Error) {
                Log.log("Error in getDevice: " + error.message, "api.Audio");
            }
        }

        public function get currentDevice():MediaPlayerDevice
        {
            try {
                Log.log("get currentDevice", "api.Audio");
                mediaPlayer.getCurrentDevice();
                return mediaPlayer.currentDevice;
            } catch (error:Error) {
                Log.log("Error in get currentDevice: " + error.message, "api.Audio");
                return null;
            }
        }

        public function setBrowsePath(param1:MediaPlayerPath, param2:Boolean = true):void
        {
            try {
                Log.log("setBrowsePath: " + param1 + ", " + param2, "api.Audio");
                mediaPlayer.setBrowsePath(param1, param2);
            } catch (error:Error) {
                Log.log("Error in setBrowsePath: " + error.message, "api.Audio");
            }
        }

        public function get browsePath():MediaPlayerPath
        {
            try {
                Log.log("get browsePath", "api.Audio");
                mediaPlayer.getBrowsePath();
                return mediaPlayer.browsePath;
            } catch (error:Error) {
                Log.log("Error in get browsePath: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get alphaJumpTable():Array
        {
            try {
                Log.log("get alphaJumpTable", "api.Audio");
                mediaPlayer.getAlphaJumpTable();
                var alphaJumpTable:Array = [];
                var startChars:Vector.<String> = mediaPlayer.startCharactersAvailable();
                for (var i:int = 0; i < startChars.length; i++)
                {
                    alphaJumpTable.push(startChars[i]);
                }
                return alphaJumpTable;
            } catch (error:Error) {
                Log.log("Error in get alphaJumpTable: " + error.message, "api.Audio");
                return [];
            }
        }

        public function getBrowseItems(param1:* = null, param2:int = -1):void
        {
            try {
                Log.log("getBrowseItems: " + param1 + ", " + param2, "api.Audio");
                mediaPlayer.getBrowseItems(param1, param2);
            } catch (error:Error) {
                Log.log("Error in getBrowseItems: " + error.message, "api.Audio");
            }
        }

        public function get playPath():MediaPlayerPath
        {
            try {
                Log.log("get playPath", "api.Audio");
                mediaPlayer.getPlayPath();
                return mediaPlayer.playPath;
            } catch (error:Error) {
                Log.log("Error in get playPath: " + error.message, "api.Audio");
                return null;
            }
        }

        public function mediaFilterListShow(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number):void
        {
            try {
                Log.log("mediaFilterListShow: " + param1 + ", " + param2 + ", " + param3 + ", " + param4 + ", " + param5 + ", " + param6 + ", " + param7 + ", " + param8, "api.Audio");
                mediaPlayer.mediaFilterListShow(param1, param2, param3, param4, param5, param6, param7, param8);
            } catch (error:Error) {
                Log.log("Error in mediaFilterListShow: " + error.message, "api.Audio");
            }
        }

        public function goToRoot():void
        {
            try {
                Log.log("goToRoot", "api.Audio");
                mediaPlayer.goToRoot();
            } catch (error:Error) {
                Log.log("Error in goToRoot: " + error.message, "api.Audio");
            }
        }

        public function getPlayItems(param1:* = null, param2:int = -1):void
        {
            try {
                Log.log("getPlayItems: " + param1 + ", " + param2, "api.Audio");
                mediaPlayer.getPlayItems(param1, param2);
            } catch (error:Error) {
                Log.log("Error in getPlayItems: " + error.message, "api.Audio");
            }
        }

        public function get getCurrentTrack():uint
        {
            try {
                Log.log("get getCurrentTrack", "api.Audio");
                mediaPlayer.getCurrentTrack();
                return mediaPlayer.currentTrack;
            } catch (error:Error) {
                Log.log("Error in get getCurrentTrack: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function get currentTrackInfo():MediaPlayerTrackInfo
        {
            try {
                Log.log("get currentTrackInfo", "api.Audio");
                mediaPlayer.getCurrentTrackInfo();
                return mediaPlayer.currentTrackInfo;
            } catch (error:Error) {
                Log.log("Error in get currentTrackInfo: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get albumArtPath():String
        {
            try {
                Log.log("get albumArtPath", "api.Audio");
                mediaPlayer.getCurrentAlbumArtPath();
                return mediaPlayer.currentAlbumArtPath;
            } catch (error:Error) {
                Log.log("Error in get albumArtPath: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get transportAction():String
        {
            try {
                Log.log("get transportAction", "api.Audio");
                mediaPlayer.getTransportAction();
                return mediaPlayer.transportAction;
            } catch (error:Error) {
                Log.log("Error in get transportAction: " + error.message, "api.Audio");
                return null;
            }
        }

        public function set transportAction(param1:String):void
        {
            try {
                Log.log("set transportAction: " + param1, "api.Audio");
                mediaPlayer.setTransportAction(param1);
            } catch (error:Error) {
                Log.log("Error in set transportAction: " + error.message, "api.Audio");
            }
        }
        
        public function get skipThreshold():Number
        {
            try {
                Log.log("get skipThreshold", "api.Audio");
                mediaPlayer.getSkipThreshold();
                return mediaPlayer.skipThreshold;
            } catch (error:Error) {
                Log.log("Error in get skipThreshold: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function set skipThreshold(param1:Number):void
        {
            try {
                Log.log("set skipThreshold: " + param1, "api.Audio");
                mediaPlayer.setSkipThreshold(param1);
            } catch (error:Error) {
                Log.log("Error in set skipThreshold: " + error.message, "api.Audio");
            }
        }

        public function get repeat():String
        {
            try {
                Log.log("get repeat", "api.Audio");
                mediaPlayer.getRepeatMode();
                return mediaPlayer.repeatMode;
            } catch (error:Error) {
                Log.log("Error in get repeat: " + error.message, "api.Audio");
                return null;
            }
        }

        public function set repeat(param1:String):void
        {
            try {
                Log.log("set repeat: " + param1, "api.Audio");
                mediaPlayer.setRepeatMode(param1);
            } catch (error:Error) {
                Log.log("Error in set repeat: " + error.message, "api.Audio");
            }
        }

        public function get playTime():uint
        {
            try {
                Log.log("get playTime", "api.Audio");
                mediaPlayer.getPlayTime();
                return mediaPlayer.playTime;
            } catch (error:Error) {
                Log.log("Error in get playTime: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function set playTime(param1:uint):void
        {
            try {
                Log.log("set playTime: " + param1, "api.Audio");
                mediaPlayer.setPlayTime(param1);
            } catch (error:Error) {
                Log.log("Error in set playTime: " + error.message, "api.Audio");
            }
        }

        public function get playDuration():uint
        {
            try {
                Log.log("get playDuration", "api.Audio");
                mediaPlayer.getPlayDuration();
                return mediaPlayer.playDuration;
            } catch (error:Error) {
                Log.log("Error in get playDuration: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function set playDuration(param1:uint):void
        {
            try {
                Log.log("set playDuration: " + param1, "api.Audio");
                mediaPlayer.setPlayDuration(param1);
            } catch (error:Error) {
                Log.log("Error in set playDuration: " + error.message, "api.Audio");
            }
        }

        public function get auditionPeriod():uint
        {
            try {
                Log.log("get auditionPeriod", "api.Audio");
                mediaPlayer.getAuditionPeriod();
                return mediaPlayer.auditionPeriod;
            } catch (error:Error) {
                Log.log("Error in get auditionPeriod: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function set auditionPeriod(param1:uint):void
        {
            try {
                Log.log("set auditionPeriod: " + param1, "api.Audio");
                mediaPlayer.setAuditionPeriod(param1);
            } catch (error:Error) {
                Log.log("Error in set auditionPeriod: " + error.message, "api.Audio");
            }
        }

        public function get seekSpeed():Number
        {
            try {
                Log.log("get seekSpeed", "api.Audio");
                mediaPlayer.getSeekSpeed();
                return mediaPlayer.seekSpeed;
            } catch (error:Error) {
                Log.log("Error in get seekSpeed: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function set seekSpeed(param1:Number):void
        {
            try {
                Log.log("set seekSpeed: " + param1, "api.Audio");
                mediaPlayer.setSeekSpeed(param1);
            } catch (error:Error) {
                Log.log("Error in set seekSpeed: " + error.message, "api.Audio");
            }
        }

        public function get playlistCount():uint
        {
            try {
                Log.log("get playlistCount", "api.Audio");
                mediaPlayer.getPlaylistCount();
                return mediaPlayer.playlistCount;
            } catch (error:Error) {
                Log.log("Error in get playlistCount: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function get random():String
        {
            try {
                Log.log("get random", "api.Audio");
                mediaPlayer.getRandomMode();
                return mediaPlayer.randomMode;
            } catch (error:Error) {
                Log.log("Error in get random: " + error.message, "api.Audio");
                return null;
            }
        }

        public function set random(param1:String):void
        {
            try {
                Log.log("set random: " + param1, "api.Audio");
                mediaPlayer.setRandomMode(param1);
            } catch (error:Error) {
                Log.log("Error in set random: " + error.message, "api.Audio");
            }
        }

        public function get mediaError():Object
        {
            try {
                Log.log("get mediaError", "api.Audio");
                return mediaPlayer.mediaError;
            } catch (error:Error) {
                Log.log("Error in get mediaError: " + error.message, "api.Audio");
                return null;
            }
        }

        public function get readyToBrowse():Boolean
        {
            try {
                Log.log("get readyToBrowse", "api.Audio");
                return mediaPlayer.readyToBrowse;
            } catch (error:Error) {
                Log.log("Error in get readyToBrowse: " + error.message, "api.Audio");
                return false;
            }
        }

        public function getItemsFilterText(param1:Number,param2:int,param3:int):void
        {
            try {
                Log.log("getItemsFilterText: " + param1 + ", " + param2 + ", " + param3, "api.Audio");
                mediaPlayer.getItemsFilterText(param1,param2,param3);
            } catch (error:Error) {
                Log.log("Error in getItemsFilterText: " + error.message, "api.Audio");
            }
        }

        public function set searchText(param1:String):void
        {
            try {
                Log.log("set searchText: " + param1, "api.Audio");
                mediaPlayer.SearchText = param1;
            } catch (error:Error) {
                Log.log("Error in set searchText: " + error.message, "api.Audio");
            }
        }

        public function get searchText():String
        {
            try {
                Log.log("get searchText", "api.Audio");
                return mediaPlayer.SearchText;
            } catch (error:Error) {
                Log.log("Error in get searchText: " + error.message, "api.Audio");
                return null;
            }
        }

        public function cancelSearch():void
        {
            try {
                Log.log("cancelSearch", "api.Audio");
                mediaPlayer.cancelSearch();
            } catch (error:Error) {
                Log.log("Error in cancelSearch: " + error.message, "api.Audio");
            }
        }

        public function cancelAlphaJump():void
        {
            try {
                Log.log("cancelAlphaJump", "api.Audio");
                mediaPlayer.cancelAlphaJump();
            } catch (error:Error) {
                Log.log("Error in cancelAlphaJump: " + error.message, "api.Audio");
            }
        }

        // AudioMixerManager

        public function get mixerBusy():Boolean
        {
            try {
                Log.log("get mixerBusy", "api.Audio");
                audioMixerManager.getAMMBusy();
                return audioMixerManager.AMMBusy;
            } catch (error:Error) {
                Log.log("Error in get mixerBusy: " + error.message, "api.Audio");
                return false;
            }
        }

        public function get navVolume():int
        {
            try {
                Log.log("get navVolume", "api.Audio");
                audioMixerManager.getNavPromptVolume();
                return audioMixerManager.navPromptVolume;
            } catch (error:Error) {
                Log.log("Error in get navVolume: " + error.message, "api.Audio");
                return 0;
            }
        }

        public function setNavVolume(param1:String):void
        {
            try {
                Log.log("setNavVolume: " + param1, "api.Audio");
                audioMixerManager.adjustNavPromptVolume(param1);
            } catch (error:Error) {
                Log.log("Error in setNavVolume: " + error.message, "api.Audio");
            }
        }

        public function get dabfmMux():Boolean
        {
            try {
                Log.log("get dabfmMux", "api.Audio");
                return audioMixerManager.dabfmMuxSource;
            } catch (error:Error) {
                Log.log("Error in get dabfmMux: " + error.message, "api.Audio");
                return false;
            }
        }

        public function get interrupt():String
        {
            try {
                Log.log("get interrupt", "api.Audio");
                return audioMixerManager.interruptSource;
            } catch (error:Error) {
                Log.log("Error in get interrupt: " + error.message, "api.Audio");
                return null;
            }
        }

        public function entertainmentMute(param1:String, mute:Boolean):Boolean
        {
            try {
                Log.log("entertainmentMute: " + param1 + ", " + mute, "api.Audio");
                if (mute) {
                    return audioMixerManager.setEntertainmentSrcMute(param1);
                } else {
                    return audioMixerManager.setEntertainmentSrcUnmute(param1);
                }
            } catch (error:Error) {
                Log.log("Error in entertainmentMute: " + error.message, "api.Audio");
                return false;
            }
        }

        public function enableTouch(param1:Boolean):void
        {
            try {
                Log.log("enableTouch: " + param1, "api.Audio");
                audioMixerManager.setTouchScreenEnable(param1);
            } catch (error:Error) {
                Log.log("Error in enableTouch: " + error.message, "api.Audio");
            }
        }

    }
}