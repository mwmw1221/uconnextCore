package com.harman.moduleLink
{
   import com.harman.moduleLinkAPI.AppManagerEvent;
   import com.harman.moduleLinkAPI.Applet;
   import com.harman.moduleLinkAPI.IAppManager;
   import com.harman.moduleLinkAPI.ProductVariantID;
   import com.nfuzion.moduleLink.Connection;
   import com.nfuzion.moduleLink.ConnectionEvent;
   import com.nfuzion.moduleLink.TravelLink;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class AppManager extends Module implements IAppManager
   {
      private static var instance:AppManager;
      
      public static var STATUS_RUNNING:String = "running";
      
      public static var STATUS_PAUSED:String = "paused";
      
      public static var STATUS_PAUSING:String = "pausing";
      
      public static var STATUS_STOPPED:String = "stopped";
      
      public static const UPDATE_TYPE_DOWNLOAD:int = 0;
      
      public static const UPDATE_TYPE_INSTALL:int = 1;
      
      public static const UPDATE_TYPE_FINISH:int = 2;
      
      public static var RESOURCE_LIMIT:int = 3;
      
      public static var ALL_APPS:int = -2;
      
      public static var FAVORITE_APPS:int = -1;
      
      public static var RUNNING_APPS:int = -3;
      
      public static var APP_OPTIONS:int = -10;
      
      private static const vehicleCountryCodeUSA:String = "2";
      
      private static const dbusIdentifier:String = "AppManager";
      
      private static const dbusAppsPersistency:String = "AppPersistenceManager";
      
      private var name:String = "AppManager";
      
      private var connection:Connection;
      
      private var mUpdate_statusText:String = "";
      
      private var mUpdate_statusType:int = 2;
      
      private var mStatus:String = "Init";
      
      private var mSort:String = "byName";
      
      private var mLastRunningAppId:String = "";
      
      private var mRunningAppId:String = "";
      
      private var mActiveCategory:int = -1;
      
      private var mClosedAppId:String = "";
      
      private var mApplications:Array = new Array();
      
      private var mRunningApps:Array = new Array();
      
      private var mAppOperStatus:Array = new Array();
      
      private var mUpdateTimer:Timer = new Timer(1000);
      
      private var client:Client;
      
      private var mAppManagerServicePresent:Boolean = false;
      
      private var mDriveModeApp:Applet = null;
      
      private var mAppsExist:String = "notReady";
      
      private var mSentValue:String = "";
      
      private var mFavoriteAppsFull:Boolean = false;
      
      private var productVariant:ProductVariantID = VersionInfo.getInstance().productVariantID;
      
      public function AppManager()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.APP_MANAGER,this.appMgrMessageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
         this.connection.addEventListener(ConnectionEvent.APP_PERSISTENCE_MANAGER,this.appPersistencyMessageHandler);
      }
      
      public static function getInstance() : AppManager
      {
         if(instance == null)
         {
            instance = new AppManager();
         }
         return instance;
      }
      
      private function connected(e:Event = null) : void
      {
         if(this.connection.configured)
         {
            if(this.client.connected)
            {
               this.sendAvailableRequest();
               this.mUpdateTimer.addEventListener(TimerEvent.TIMER,this.onUpdatePendingTimer);
               this.sendMultiSubscribe(["appListUpdated","appIconAvailable","operStatus","appStarted","appManagerStatus","stopStartApp","appStoppedStarted","xletActionCanceled"]);
               this.getAppsPersistency();
            }
            else
            {
               this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
            }
         }
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         this.name = this.connection.configuration.@name.toString();
         if(!this.client.connected)
         {
         }
      }
      
      public function appMgrMessageHandler(e:ConnectionEvent) : void
      {
         var bOperStatusUpdated:Boolean = false;
         var appIndex:int = 0;
         var k:int = 0;
         var appStatus:Applet = null;
         var resp:Object = e.data;
         if(resp.hasOwnProperty("dBusServiceAvailable"))
         {
            if(resp.dBusServiceAvailable == "true" && this.mAppManagerServicePresent == false)
            {
               this.mAppManagerServicePresent = true;
               this.getAppManagerStatus();
            }
            else if(resp.dBusServiceAvailable == "false")
            {
               this.mAppManagerServicePresent = false;
            }
         }
         else if(resp.hasOwnProperty("appPaused"))
         {
            if(resp.appPaused.errorCode != 0)
            {
               this.dispatchEvent(new AppManagerEvent(AppManagerEvent.START_XLET_ERROR));
            }
            else
            {
               this.dispatchEvent(new AppManagerEvent(AppManagerEvent.APP_PAUSED,e.data.appPaused.appId));
            }
         }
         else if(resp.hasOwnProperty("appListUpdated"))
         {
            this.mUpdateTimer.reset();
            this.mUpdateTimer.start();
         }
         else if(resp.hasOwnProperty("getAppList"))
         {
            if(e.data.getAppList.AppManager != null)
            {
               if(e.data.getAppList.AppManager.appList.category == ALL_APPS)
               {
                  this.mApplications = null;
                  this.mApplications = this.createApplicationList(e.data.getAppList.AppManager.appList.list);
                  if(this.mStatus == "Ready")
                  {
                     this.doAppsExist(this.mApplications);
                  }
               }
               if(e.data.getAppList.AppManager.appList.category == RUNNING_APPS)
               {
                  this.mRunningApps = null;
                  this.mRunningApps = this.createApplicationList(e.data.getAppList.AppManager.appList.list);
               }
               if(e.data.getAppList.AppManager.appList.category == this.mActiveCategory || e.data.getAppList.AppManager.appList.category == FAVORITE_APPS || e.data.getAppList.AppManager.appList.category == ALL_APPS)
               {
                  this.dispatchEvent(new AppManagerEvent(AppManagerEvent.REFRESH_APPLICATIONS));
               }
               this.dispatchEvent(new AppManagerEvent(AppManagerEvent.APPLIST,e.data.getAppList.AppManager.appList));
            }
         }
         else if(resp.hasOwnProperty("appManagerStatus"))
         {
            if(this.mStatus == "Ready")
            {
               this.getAppList(ALL_APPS);
            }
            this.mStatus = e.data.appManagerStatus.status;
            this.dispatchEvent(new AppManagerEvent(AppManagerEvent.APP_MANAGER_STATUS));
         }
         else if(resp.hasOwnProperty("getAppManagerStatus"))
         {
            if(this.mStatus != e.data.getAppManagerStatus.status)
            {
               this.mStatus = e.data.getAppManagerStatus.status;
            }
            if(this.mStatus == "Ready")
            {
               this.getAppList(ALL_APPS);
            }
            this.dispatchEvent(new AppManagerEvent(AppManagerEvent.APP_MANAGER_STATUS));
         }
         else if(resp.hasOwnProperty("startApp"))
         {
            if(resp.startApp.errorCode != 0)
            {
               this.dispatchEvent(new AppManagerEvent(AppManagerEvent.START_XLET_ERROR));
            }
         }
         else if(resp.hasOwnProperty("appStarted"))
         {
            if(resp.appStarted.errorCode != 0)
            {
               this.dispatchEvent(new AppManagerEvent(AppManagerEvent.START_XLET_ERROR));
            }
            else
            {
               this.mLastRunningAppId = resp.appStarted.appId;
            }
         }
         else if(resp.hasOwnProperty("appIconAvailable"))
         {
            this.dispatchEvent(new AppManagerEvent(AppManagerEvent.APP_ICON_AVAILABLE,e.data.appIconAvailable));
         }
         else if(resp.hasOwnProperty("appVR_isVRAppInFocus"))
         {
            if(resp.appVR_isVRAppInFocus.result == "success")
            {
               this.dispatchEvent(new AppManagerEvent(AppManagerEvent.APP_VR_IN_FOCUS,resp.appVR_isVRAppInFocus));
            }
         }
         else if(resp.hasOwnProperty("operStatus"))
         {
            bOperStatusUpdated = false;
            for(appIndex = 0; appIndex < this.mAppOperStatus.length; appIndex++)
            {
               if(e.data.operStatus.appId == this.mAppOperStatus[appIndex].appId)
               {
                  this.mAppOperStatus[appIndex].label = resp.operStatus.name;
                  this.mAppOperStatus[appIndex].status = resp.operStatus.state;
                  this.mAppOperStatus[appIndex].type = resp.operStatus.type;
                  this.mAppOperStatus[appIndex].daemon = resp.operStatus.daemon;
                  this.mAppOperStatus[appIndex].lgicon = "file:///fs/mmc1/xletsdir/xlets/" + this.mAppOperStatus[appIndex].appId + "/data/lgIcon.png";
                  bOperStatusUpdated = true;
               }
            }
            if(bOperStatusUpdated == false)
            {
               appStatus = new Applet(String(e.data.operStatus.name));
               appStatus.appId = e.data.operStatus.appId;
               appStatus.status = resp.operStatus.state;
               appStatus.type = resp.operStatus.type;
               appStatus.daemon = resp.operStatus.daemon;
               appStatus.lgicon = "file:///fs/mmc1/xletsdir/xlets/" + appStatus.appId + "/data/lgIcon.png";
               appStatus.exlgicon = "file:///fs/mmc1/xletsdir/xlets/" + appStatus.appId + "/data/exLgIcon.png";
               this.mAppOperStatus.push(appStatus);
            }
            for(k = 0; k < this.mApplications.length; k++)
            {
               if(e.data.operStatus.appId == this.mApplications[k].appId)
               {
                  if(resp.operStatus.state == STATUS_STOPPED)
                  {
                     if(this.activeCategory == RUNNING_APPS)
                     {
                        this.mApplications.splice(k,1);
                     }
                     this.getAppList(RUNNING_APPS);
                  }
                  else
                  {
                     this.mApplications[k].status = resp.operStatus.state;
                  }
                  this.dispatchEvent(new AppManagerEvent(AppManagerEvent.REFRESH_APPLICATIONS));
               }
            }
            if("running" == e.data.operStatus.state)
            {
               this.mRunningAppId = e.data.operStatus.appId;
               this.mLastRunningAppId = this.mRunningAppId;
            }
            else if("stopped" == e.data.operStatus.state && e.data.operStatus.appId == this.mRunningAppId)
            {
               if(!e.data.operStatus.daemon)
               {
                  this.dispatchEvent(new AppManagerEvent(AppManagerEvent.CLOSE,null));
               }
               this.mRunningAppId = "";
               this.mLastRunningAppId = "";
            }
            else if(("paused" == e.data.operStatus.state || "stopping" == e.data.operStatus.state) && e.data.operStatus.appId == this.mRunningAppId)
            {
               if(!e.data.operStatus.daemon)
               {
                  this.dispatchEvent(new AppManagerEvent(AppManagerEvent.CLOSE,null));
               }
               this.mLastRunningAppId = e.data.operStatus.state == "paused" ? this.mRunningAppId : "";
               this.mRunningAppId = "";
            }
            this.dispatchEvent(new AppManagerEvent(AppManagerEvent.OPER_STATUS_UPDATE,e.data));
         }
         else if(resp.hasOwnProperty("verifyDRM"))
         {
            this.dispatchEvent(new AppManagerEvent(AppManagerEvent.DRM_VERIFICATION,e.data));
         }
         else if(resp.hasOwnProperty("stopStartApp"))
         {
            this.dispatchEvent(new AppManagerEvent(AppManagerEvent.STOP_START_APP,e.data));
         }
         else if(resp.hasOwnProperty("appStoppedStarted"))
         {
            this.dispatchEvent(new AppManagerEvent(AppManagerEvent.APP_STOPPED_STARTED,e.data));
         }
         else if(resp.hasOwnProperty("getXletPropsbyName"))
         {
            this.dispatchEvent(new AppManagerEvent(AppManagerEvent.APP_PACKAGE_INFO,e.data.getXletPropsbyName.xletProps));
         }
         else if(resp.hasOwnProperty("xletActionCanceled"))
         {
            this.dispatchEvent(new AppManagerEvent(AppManagerEvent.XLET_ACTION_CANCELED,e.data.xletActionCanceled));
         }
         else if(resp.hasOwnProperty("appVRBarStatus"))
         {
            this.mUpdate_statusText = resp.appVRBarStatus.statusText;
            this.mUpdate_statusType = resp.appVRBarStatus.statusType;
            this.dispatchEvent(new AppManagerEvent(AppManagerEvent.APP_VR_BAR_STATUS,e.data));
         }
         else if(resp.hasOwnProperty("tooManyApps"))
         {
            this.dispatchEvent(new AppManagerEvent(AppManagerEvent.TOO_MANY_APPS,e.data));
         }
      }
      
      private function onUpdatePendingTimer(e:TimerEvent) : void
      {
         this.getAppList(this.mActiveCategory);
         this.mUpdateTimer.reset();
      }
      
      private function doAppsExist(list:Array) : void
      {
         var i:int = 0;
         var tmp:Boolean = false;
         for(i = 0; i < list.length; i++)
         {
            if(list[i].appId != "settings")
            {
               tmp = true;
            }
         }
         if(this.mAppsExist == "true" != tmp)
         {
            if(tmp)
            {
               this.mAppsExist = "true";
            }
            else
            {
               this.mAppsExist = "false";
            }
            this.setAppsPersistency(tmp);
         }
      }
      
      public function set driveModeApp(_driveModeApp:Applet) : void
      {
         this.mDriveModeApp = _driveModeApp;
      }
      
      public function get favoriteAppsFull() : Boolean
      {
         this.mFavoriteAppsFull = true;
         for(var i:int = 0; i < this.mApplications.length; i++)
         {
            if(!this.mApplications[i].favorite)
            {
               this.mFavoriteAppsFull = false;
               return false;
            }
         }
         return this.mFavoriteAppsFull;
      }
      
      private function createApplicationList(query:Array) : Array
      {
         var app:Applet = null;
         var apps:Array = new Array();
         for(var i:int = 0; i < query.length; i++)
         {
            app = new Applet(String(query[i]["xlet.name"]));
            app.appId = query[i]["xlet.appId"];
            app.favorite = query[i].isFavorite;
            app.embedded = query[i].isEmbeddedApp;
            app.status = this.getAppAMSOperStatus(app.appId);
            app.lgicon = "file:///fs/" + (app.embedded ? "mmc0/app/share/hmi/img/" + app.appId + ".png" : "mmc1/xletsdir/xlets/" + app.appId + "/data/lgIcon.png");
            app.exlgicon = "file:///fs/" + (app.embedded ? "mmc0/app/share/hmi/img/" + app.appId + ".png" : "mmc1/xletsdir/xlets/" + app.appId + "/data/exlgIcon.png");
            if(app.appId == "travellink")
            {
               if(TravelLink.getInstance().isAvailable)
               {
                  apps.push(app);
               }
            }
            else if(app.appId == "Drive Modes")
            {
               if(this.mDriveModeApp != null)
               {
                  app.label = this.mDriveModeApp.label;
                  app.lgicon = this.mDriveModeApp.lgicon;
                  app.exlgicon = this.mDriveModeApp.exlgicon;
                  apps.push(app);
               }
            }
            else if(app.appId == "trip")
            {
               if(this.productVariant.VARIANT_PRODUCT == "524")
               {
                  apps.push(app);
               }
            }
            else
            {
               apps.push(app);
            }
         }
         return apps;
      }
      
      private function get favorites() : Array
      {
         var _query:Array = new Array();
         for(var i:int = 0; i < this.mApplications.length; i++)
         {
            if(this.mApplications[i].favorite)
            {
               _query.push(this.mApplications[i]);
            }
         }
         return _query;
      }
      
      private function getAppAMSOperStatus(appId:String) : String
      {
         for(var statusIndex:int = 0; statusIndex < this.mAppOperStatus.length; statusIndex++)
         {
            if(appId == this.mAppOperStatus[statusIndex].appId)
            {
               return this.mAppOperStatus[statusIndex].status;
            }
         }
         return "";
      }
      
      public function saveAppCategory(appId:String) : void
      {
         for(var i:int = 0; i < this.mAppOperStatus.length; i++)
         {
            if(appId == this.mAppOperStatus[i].appId)
            {
               this.mAppOperStatus[i].cat = this.mActiveCategory;
               return;
            }
         }
         var appStatus:Applet = new Applet(appId);
         appStatus.appId = appId;
         appStatus.cat = this.mActiveCategory;
         this.mAppOperStatus.push(appStatus);
      }
      
      public function getAppLaunchedFromCategory(appId:String) : int
      {
         for(var i:int = 0; i < this.mAppOperStatus.length; i++)
         {
            if(appId == this.mAppOperStatus[i].appId)
            {
               return this.mAppOperStatus[i].cat;
            }
         }
         return -1;
      }
      
      public function get running() : Array
      {
         this.mRunningApps.length = 0;
         for(var appIndex:int = 0; appIndex < this.mAppOperStatus.length; appIndex++)
         {
            if((this.mAppOperStatus[appIndex].status == STATUS_RUNNING || this.mAppOperStatus[appIndex].status == STATUS_PAUSED) && !this.mAppOperStatus[appIndex].daemon)
            {
               this.mRunningApps.push(this.mAppOperStatus[appIndex]);
            }
         }
         return this.mRunningApps;
      }
      
      public function get applications() : Array
      {
         if(this.mActiveCategory == FAVORITE_APPS)
         {
            return this.favorites;
         }
         if(this.mActiveCategory == RUNNING_APPS)
         {
            return this.mRunningApps;
         }
         return this.mApplications;
      }
      
      public function get status() : String
      {
         return this.mStatus;
      }
      
      public function get activeCategory() : int
      {
         return this.mActiveCategory;
      }
      
      public function set activeCategory(active:int) : void
      {
         this.mActiveCategory = active;
      }
      
      public function get sortingMethod() : String
      {
         return this.mSort;
      }
      
      public function set closedAppId(appId:String) : void
      {
         this.mClosedAppId = appId;
      }
      
      public function get closedAppId() : String
      {
         return this.mClosedAppId;
      }
      
      public function set sortingMethod(sorting:String) : void
      {
         if(sorting == "byRecent")
         {
            this.mSort = "byRecent";
         }
         else
         {
            this.mSort = "byName";
         }
      }
      
      public function getAppList(category:int) : void
      {
         var params:* = null;
         category = category == FAVORITE_APPS ? ALL_APPS : category;
         params = "\"category\":\"" + category + "\",\"sortby\":\"" + this.mSort + "\"";
         this.sendAppMgrCommand("getAppList",params);
      }
      
      public function getAppManagerStatus() : void
      {
         this.sendAppMgrCommand("getAppManagerStatus","");
      }
      
      public function setFavorite(appId:String, addFav:Boolean) : void
      {
         var params:String = null;
         var i:int = 0;
         params = "\"appId\":\"" + appId + "\",\"addFav\":" + addFav;
         this.sendAppMgrCommand("setFavoriteApp",params);
         if(addFav)
         {
            this.mActiveCategory = FAVORITE_APPS;
            this.getAppList(ALL_APPS);
         }
         else
         {
            for(i = 0; i < this.mApplications.length; i++)
            {
               if(appId == this.mApplications[i].appId)
               {
                  this.mApplications[i].favorite = false;
                  this.dispatchEvent(new AppManagerEvent(AppManagerEvent.REFRESH_APPLICATIONS));
                  return;
               }
            }
         }
      }
      
      public function startXlet(uuid:String) : void
      {
         var params:* = null;
         params = "\"appId\":\"" + uuid + "\"";
         this.sendAppMgrCommand("startApp",params);
      }
      
      public function stopXlet(uuid:String) : void
      {
         var params:* = null;
         params = "\"appId\":\"" + uuid + "\"";
         this.sendAppMgrCommand("stopApp",params);
      }
      
      public function pauseXlet(uuid:String) : void
      {
         var params:* = null;
         params = "\"appId\":\"" + uuid + "\"";
         this.sendAppMgrCommand("pauseApp",params);
      }
      
      public function startEmbedded(name:String) : void
      {
         var params:* = null;
         params = "\"appId\":\"" + name + "\"";
         this.sendAppMgrCommand("startEmbedded",params);
      }
      
      public function isAppVRFocus() : void
      {
         this.sendAppMgrCommand("appVR_isVRAppInFocus","");
      }
      
      public function getRunningAppId() : String
      {
         return this.mRunningAppId;
      }
      
      public function getLastRunningAppId() : String
      {
         return this.mLastRunningAppId;
      }
      
      public function setAppMenuActive(active:Boolean) : void
      {
         var params:String = null;
         params = "\"active\":" + active;
         this.sendAppMgrCommand("setAppMenuActive",params);
      }
      
      public function verifyDRM(appId:String, appName:String) : void
      {
         var params:* = null;
         params = "\"appId\":\"" + appId + "\",\"name\":\"" + appName + "\"";
         this.sendAppMgrCommand("verifyDRM",params);
      }
      
      public function getAppPackageInfo(appName:String) : void
      {
         var params:* = null;
         if(appName != "")
         {
            params = "\"appName\":\"" + appName + "\"";
            this.sendAppMgrCommand("getXletPropsbyName",params);
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:* = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
      
      public function xletReturnToNew() : void
      {
         var params:String = null;
         params = "";
         this.sendAppMgrCommand("xletsReturnToNew",params);
      }
      
      protected function sendAppMgrCommand(commandName:String, params:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Command\",\"Dest\":\"" + dbusIdentifier + "\",\"packet\":{\"" + commandName + "\":{" + params + "}}}";
         this.client.send(message);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         var message:* = null;
         if(this.client.connected)
         {
            message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\":\"" + signalName + "\"}";
            this.client.send(message);
         }
      }
      
      private function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:* = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      public function appPersistencyMessageHandler(e:ConnectionEvent) : void
      {
         var message:Object = e.data;
         if(message.hasOwnProperty("read"))
         {
            if(message["read"].hasOwnProperty("res"))
            {
               if(message.read.res)
               {
                  this.mAppsExist = "true";
               }
               else
               {
                  this.mAppsExist = "false";
               }
            }
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      public function setAppsPersistency(appsExist:Boolean) : void
      {
         var message:* = null;
         if(appsExist)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusAppsPersistency + "\", \"packet\": {\"write\":{\"AppsExist\":true}}}";
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusAppsPersistency + "\", \"packet\": {\"write\":{\"AppsExist\":false}}}";
         }
         this.client.send(message);
      }
      
      public function getAppsPersistency() : void
      {
         var message:* = null;
         message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusAppsPersistency + "\", \"packet\": {\"read\":{\"key\":\"AppsExist\", \"escval\":0}}}";
         this.client.send(message);
      }
      
      public function getAppsExist() : String
      {
         if(this.mSentValue == "" || this.mSentValue == "notReady")
         {
            this.mSentValue = this.mAppsExist;
         }
         return this.mSentValue;
      }
      
      override public function isReady() : Boolean
      {
         if(this.mAppsExist == "notReady")
         {
            this.getAppsPersistency();
         }
         return Boolean(this.connection.configured) && Boolean(this.client.connected) && this.mAppsExist != "notReady";
      }
      
      public function startLastAudioApp() : void
      {
         for(var appIndex:int = 0; appIndex < this.mAppOperStatus.length; appIndex++)
         {
            if(this.mAppOperStatus[appIndex].type == "audio" && "paused" == this.mAppOperStatus[appIndex].status)
            {
               this.startXlet(this.mAppOperStatus[appIndex].appId);
               break;
            }
         }
      }
      
      public function startAudioApp(appLabel:String) : void
      {
         for(var appIndex:int = 0; appIndex < this.mAppOperStatus.length; appIndex++)
         {
            if(this.mAppOperStatus[appIndex].label == appLabel)
            {
               if("running" != this.mAppOperStatus[appIndex].status)
               {
                  this.mRunningAppId = "";
                  this.startXlet(this.mAppOperStatus[appIndex].appId);
               }
               break;
            }
         }
      }
      
      public function isAudioAppRunning() : Boolean
      {
         for(var appIndex:int = 0; appIndex < this.mAppOperStatus.length; appIndex++)
         {
            if(this.mAppOperStatus[appIndex].type == "audio" && "running" == this.mAppOperStatus[appIndex].status)
            {
               return true;
            }
         }
         return false;
      }
      
      public function startLastPausedApp() : Boolean
      {
         if(this.mLastRunningAppId == "")
         {
            return false;
         }
         this.startXlet(this.mLastRunningAppId);
         return true;
      }
      
      public function confirmedStartAssist() : void
      {
         var params:String = null;
         params = "";
         this.sendAppMgrCommand("confirmedStartAssist",params);
      }
      
      public function get update_statusText() : String
      {
         return this.mUpdate_statusText;
      }
      
      public function get update_statusType() : int
      {
         return this.mUpdate_statusType;
      }
      
      public function isUpdateTypeFinish(UpdateType:int) : Boolean
      {
         if(UpdateType == UPDATE_TYPE_FINISH)
         {
            return true;
         }
         return false;
      }
      
      public function getAllApplications() : Array
      {
         return this.mApplications;
      }
   }
}

