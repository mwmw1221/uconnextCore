package com.nfuzion.moduleLink
{
   import com.nfuzion.moduleLinkAPI.*;
   
   public class PhoneBook extends Module implements IPhoneBook
   {
      private static const mDbusIdentifier:String = "PhoneBook";
      
      private static const mPIM_DbusIdentifier:String = "PimService";
      
      private static const mVehicle_Config_dbusIdentifier:String = "VehicleConfig";
      
      private static const mPersistancy_DbusIdentifier:String = "BluetoothHFPPersistency";
      
      private static const SYNC_SUCCESS:String = "syncComplete";
      
      private static const mPlatformDbusIdentifier:String = "platform";
      
      private static const PHONEBOOK_CACHE_SIZE:int = 6;
      
      private var mBluetooth:IBluetooth;
      
      private var mAlphaInfo:Object;
      
      private var mContacts:Vector.<PhoneBookContact>;
      
      private var mCount:Number = -1;
      
      private var mStartIndex:int = -1;
      
      private var mPendingRequestList:Boolean = false;
      
      private var mSyncSuccess:Boolean;
      
      private var mInitialized:Boolean;
      
      private var mcallerIDName:String;
      
      private var mcallerIDNumber:String;
      
      private var queriedCallerIDs:Array;
      
      private var mPhoneNumType:String;
      
      private var mNextVaildCharInfo:String;
      
      private var mSmartSpellerIndex:int;
      
      private var mSmartSpellerCount:int;
      
      private var mFavoritesIsComplete:Boolean;
      
      private var mFavoritesCount:Number;
      
      private var mFavoritesContacts:Vector.<PhoneBookContact>;
      
      private var mFavIndex:Array = [false,false,false,false,false];
      
      private var mEmergencyNumber:String = "";
      
      private var mTowingAssistanceNumber:String = "";
      
      private var mSpecialNumberType:String = "";
      
      private var mSpecialNumber:String = "";
      
      private var mPhonebookSyncUpdated:Boolean = false;
      
      private var mHFPDeviceConnected:Boolean = false;
      
      private var mPhonebookSyncStatus:String;
      
      private var mIsTowingAssisNumEmpty:Boolean = false;
      
      private var queriedCallerType:Array;
      
      private const MAX_COUNT:int = 10;
      
      private const START_INDEX:int = 0;
      
      private const EMERGENCY_NUM:String = "emergencyNumber";
      
      private const TOWING_ASSIS_NUM:String = "towingAssistance";
      
      private const EMERGENCY_FAV_INDEX:int = 6;
      
      private const TOWING_ASSIS_FAV_INDEX:int = 7;
      
      private var mConnection:Connection;
      
      public function PhoneBook()
      {
         super();
         this.mCount = -1;
         this.mFavoritesCount = -1;
         this.mContacts = null;
         this.mFavoritesContacts = null;
         this.mFavoritesIsComplete = false;
         this.mAlphaInfo = null;
         this.mInitialized = false;
         this.mConnection = null;
         this.mcallerIDName = "";
         this.mPhoneNumType = "";
         this.mcallerIDNumber = "";
         this.mNextVaildCharInfo = "";
         this.queriedCallerIDs = new Array();
         this.mSmartSpellerIndex = -1;
         this.mSmartSpellerCount = -1;
         this.queriedCallerType = new Array();
      }
      
      public function init(connect:Connection) : void
      {
         this.mCount = -1;
         this.mSyncSuccess = false;
         this.mConnection = connect;
         this.mConnection.addEventListener(ConnectionEvent.PHONEBOOK,this.messageHandler);
         this.mConnection.addEventListener(ConnectionEvent.PIM_SERVICE,this.messageHandler);
         this.mConnection.addEventListener(ConnectionEvent.BLUETOOTH_MANAGER,this.btMessageHandler);
         this.mConnection.addEventListener(ConnectionEvent.BLUETOOTH_HFP_PERSISTENCY,this.messageHandler);
         this.mConnection.addEventListener(ConnectionEvent.VEHICLE_CONFIG,this.messageHandler);
         this.mConnection.addEventListener(ConnectionEvent.PLATFORM,this.platformMessageHandler);
         this.mInitialized = true;
         this.sendSubscribePIM("pimObjectSyncState");
         this.sendSubscribe("databaseChanged");
         this.sendSubscribe("serviceDisconnected");
         this.sendSubscribe("databaseReady");
         this.requestFavoritesCount();
      }
      
      private function onServiceDisconnect() : void
      {
         this.mPendingRequestList = false;
         this.mHFPDeviceConnected = false;
         this.mSyncSuccess = false;
         this.mContacts = null;
         this.mCount = -1;
      }
      
      public function initBt(bt:IBluetooth) : void
      {
         this.mBluetooth = bt;
      }
      
      override public function isReady() : Boolean
      {
         return this.mInitialized && this.mConnection != null;
      }
      
      public function get startIndex() : int
      {
         return this.mStartIndex;
      }
      
      public function set startIndex(startIndex:int) : void
      {
         this.mStartIndex = startIndex;
      }
      
      public function get contactsCount() : Number
      {
         if(this.mCount == -1)
         {
            return 0;
         }
         return this.mCount;
      }
      
      public function contactsList(id:uint) : Vector.<PhoneBookContact>
      {
         return this.mContacts;
      }
      
      public function favoritesList(id:uint) : Vector.<PhoneBookContact>
      {
         return this.mFavoritesContacts;
      }
      
      public function get callerIDName() : String
      {
         return this.mcallerIDName;
      }
      
      public function get callerIDNumber() : String
      {
         return this.mcallerIDNumber;
      }
      
      public function get phoneNumType() : String
      {
         return this.mPhoneNumType;
      }
      
      public function get phoneNumTypeInfo() : Array
      {
         return this.queriedCallerType;
      }
      
      public function get phonebookSyncUpdateStatus() : Boolean
      {
         return this.mPhonebookSyncUpdated;
      }
      
      public function get phoneBookSyncStatus() : String
      {
         return this.mPhonebookSyncStatus;
      }
      
      public function contactStartCharactersAvailable() : Vector.<String>
      {
         var property:String = null;
         var availableChars:Vector.<String> = new Vector.<String>();
         if(null == this.mAlphaInfo)
         {
            return availableChars;
         }
         var index:uint = 0;
         while(index < this.mAlphaInfo.length)
         {
            for(property in this.mAlphaInfo[index])
            {
               availableChars.push(property);
            }
            index++;
         }
         return availableChars;
      }
      
      public function indexFromStartCharacter(char:String) : int
      {
         var property:String = null;
         if(null == this.mAlphaInfo)
         {
            return -1;
         }
         var index:uint = 0;
         while(index < this.mAlphaInfo.length)
         {
            for(property in this.mAlphaInfo[index])
            {
               if(property == char || property == char.toLocaleLowerCase())
               {
                  return int(this.mAlphaInfo[index][char]) || int(this.mAlphaInfo[index][char.toLocaleLowerCase()]);
               }
            }
            index++;
         }
         return -1;
      }
      
      public function get nextSmartSpeller() : String
      {
         return this.mNextVaildCharInfo;
      }
      
      public function get smartSpellerIndex() : int
      {
         return this.mSmartSpellerIndex;
      }
      
      public function get smartSpellerCount() : int
      {
         return this.mSmartSpellerCount;
      }
      
      public function isPhoneBookReady() : Boolean
      {
         return this.mSyncSuccess;
      }
      
      public function addFavorite(newFavorite:PhoneBookContact) : void
      {
         var j:uint = 0;
         var i:int = 0;
         var count:uint = 0;
         var message:Object = null;
         if(0 == newFavorite.favIndex)
         {
            for(j = 0; j < 5; j++)
            {
               this.mFavIndex[j] = false;
            }
            if(null == this.mFavoritesContacts)
            {
               this.mFavoritesContacts = new Vector.<PhoneBookContact>();
            }
            i = int(this.mFavoritesContacts.length);
            while(--i > -1)
            {
               this.mFavIndex[this.mFavoritesContacts[i].favIndex - 1] = true;
            }
            for(count = 0; count < 5; count++)
            {
               if(this.mFavIndex[count] == false)
               {
                  newFavorite.favIndex = count + 1;
                  break;
               }
            }
         }
         if(newFavorite.favIndex > 0 && newFavorite.favIndex <= 5)
         {
            message = {
               "Type":"Command",
               "Dest":mDbusIdentifier,
               "packet":{"insertItems":{
                  "database":"ab",
                  "insertList":[{
                     "formattedName":newFavorite.formattedName,
                     "givenName":newFavorite.firstName,
                     "familyName":newFavorite.lastName,
                     "workNumber":newFavorite.workNumber,
                     "homeNumber":newFavorite.homeNumber,
                     "mobileNumber":newFavorite.mobileNumber,
                     "otherNumber":newFavorite.otherNumber,
                     "favIndex":newFavorite.favIndex
                  }]
               }}
            };
            this.mConnection.send(message);
         }
      }
      
      public function refreshPhonebook() : void
      {
         this.mPhonebookSyncUpdated = false;
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"refreshPhonebook":{"database":"pb"}}
         };
         this.mConnection.send(message);
      }
      
      public function deleteFavorite(favorite:PhoneBookContact) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"deleteItems":{
               "database":"ab",
               "deleteList":String(favorite.id)
            }}
         };
         this.mConnection.send(message);
      }
      
      public function deleteFavoriteById(id:uint) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"deleteItems":{
               "database":"ab",
               "deleteList":id
            }}
         };
         this.mConnection.send(message);
      }
      
      public function get favoritesCount() : Number
      {
         if(this.mFavoritesCount < 0)
         {
            return 0;
         }
         if(this.mIsTowingAssisNumEmpty)
         {
            return this.mFavoritesCount + 1;
         }
         return this.mFavoritesCount;
      }
      
      public function get favoritesDbFull() : Boolean
      {
         return this.mFavoritesCount == 5;
      }
      
      public function requestAlphaJumpInformation() : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"getAlphaJumpTable":{"database":"pb"}}
         };
         this.mConnection.send(message);
      }
      
      public function requestNextValidCharacters(nextChar:String) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"getNextValidCharacters":{
               "database":"pb",
               "inputName":nextChar,
               "biDirectionalSearch":true
            }}
         };
         this.mConnection.send(message);
      }
      
      public function replaceFavorite(newFavorite:PhoneBookContact) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"updateItems":{
               "database":"ab",
               "fieldsList":[{
                  "contactsId":newFavorite.id,
                  "givenName":newFavorite.firstName,
                  "familyName":newFavorite.lastName,
                  "workNumber":newFavorite.workNumber,
                  "homeNumber":newFavorite.homeNumber,
                  "mobileNumber":newFavorite.mobileNumber,
                  "otherNumber":newFavorite.otherNumber,
                  "favIndex":newFavorite.favIndex,
                  "formattedName":newFavorite.formattedName
               }]
            }}
         };
         this.mConnection.send(message);
      }
      
      public function requestFavoritesCount() : void
      {
         if(this.mFavoritesIsComplete == true && this.mFavoritesCount != -1 && this.mFavoritesContacts != null)
         {
            this.dispatchEvent(new PhoneBookEvent(PhoneBookEvent.COUNT));
            this.dispatchEvent(new PhoneBookEvent(PhoneBookEvent.FAVORITES_LIST));
         }
         else
         {
            this.mFavoritesIsComplete = false;
            this.requestCount("ab");
         }
      }
      
      public function requestContactByName(firstName:String, lastName:String) : uint
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"getPhoneNumByName":{"database":"pb"}}
         };
         if(null != firstName)
         {
            message.packet.getPhoneNumByName["givenName"] = firstName;
         }
         else
         {
            message.packet.getPhoneNumByName["givenName"] = "";
         }
         if(null != lastName)
         {
            message.packet.getPhoneNumByName["lastName"] = lastName;
         }
         else
         {
            message.packet.getPhoneNumByName["lastName"] = "";
         }
         this.mConnection.send(message);
         return 0;
      }
      
      public function requestContactByNumber(number:String) : uint
      {
         this.queriedCallerIDs.push(number);
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"getNameByPhoneNum":{
               "database":"abpb",
               "phoneNumber":number,
               "fieldList":["formattedName","workNumber","homeNumber","mobileNumber","otherNumber"]
            }}
         };
         this.mConnection.send(message);
         return 0;
      }
      
      public function requestContactDetails(id:int) : void
      {
         var contactId:Array = [id];
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"getEcoFileItemDetails":{
               "database":"pb",
               "itemIdList":contactId
            }}
         };
         this.mConnection.send(message);
      }
      
      public function requestContactsByRange(startIndex:uint, max:uint, startLetter:String, endLetter:String) : uint
      {
         this.mStartIndex = startIndex;
         return 0;
      }
      
      public function requestContactsCount() : void
      {
         if(this.mSyncSuccess == false || this.mCount == -1)
         {
            this.requestCount("pb");
         }
         else
         {
            dispatchEvent(new PhoneBookEvent(PhoneBookEvent.COUNT));
         }
      }
      
      private function requestCount(name:String) : void
      {
         var message:Object = {
            "Type":"Command",
            "Dest":mDbusIdentifier,
            "packet":{"getItemsCount":{"database":name}}
         };
         this.mConnection.send(message);
      }
      
      public function requestContactsList(startIndex:uint, max:uint, sortBy:String, order:String, searchString:String) : uint
      {
         var message:Object = null;
         if(this.mPendingRequestList != true)
         {
            if(startIndex == this.mStartIndex && this.mContacts.length >= max)
            {
               dispatchEvent(new PhoneBookEvent(PhoneBookEvent.CONTACT_LIST));
            }
            else
            {
               this.mStartIndex = startIndex;
               message = {
                  "Type":"Command",
                  "Dest":mDbusIdentifier,
                  "packet":{"getItems":{
                     "count":max,
                     "database":"pb",
                     "fieldList":["contactsId","givenName","familyName","workNumber","homeNumber","mobileNumber","otherNumber","formattedName"],
                     "sortCriteria":sortBy,
                     "sortOrder":order,
                     "startId":startIndex,
                     "filterCriteria":searchString
                  }}
               };
               this.mPendingRequestList = true;
               this.mConnection.send(message);
            }
         }
         return 0;
      }
      
      public function requestFavoritesByRange(startIndex:uint, max:uint) : uint
      {
         var message:Object = null;
         if(this.mFavoritesIsComplete == false)
         {
            message = {
               "Type":"Command",
               "Dest":mDbusIdentifier,
               "packet":{"getItems":{
                  "count":max,
                  "database":"ab",
                  "fieldList":["contactsId","givenName","familyName","workNumber","homeNumber","mobileNumber","otherNumber","favIndex","formattedName"],
                  "sortCriteria":"formattedName",
                  "sortOrder":"ascending",
                  "startId":startIndex,
                  "notNullColumnList":["formattedName","workNumber","homeNumber","mobileNumber","otherNumber"]
               }}
            };
            this.mPendingRequestList = true;
            this.mConnection.send(message);
         }
         else
         {
            this.mFavoritesIsComplete = true;
            dispatchEvent(new PhoneBookEvent(PhoneBookEvent.FAVORITES_LIST));
         }
         return 0;
      }
      
      public function requestPhoneBookReady() : void
      {
      }
      
      public function editSpecialNumber(number:String, numberType:String) : void
      {
         var specialNumType:PhoneBookContact = new PhoneBookContact();
         if(this.EMERGENCY_NUM == numberType)
         {
            specialNumType.favIndex = this.EMERGENCY_FAV_INDEX;
            specialNumType.otherNumber = number;
            specialNumType.formattedName = "Emergency";
         }
         if(this.TOWING_ASSIS_NUM == numberType)
         {
            specialNumType.favIndex = this.TOWING_ASSIS_FAV_INDEX;
            specialNumType.otherNumber = number;
            specialNumType.formattedName = "Towing Assistance";
         }
         this.replaceFavorite(specialNumType);
      }
      
      public function get emergencyNumber() : String
      {
         return this.mEmergencyNumber;
      }
      
      public function get towingAssistanceNumber() : String
      {
         return this.mTowingAssistanceNumber;
      }
      
      public function resetToDefault(numberType:String) : void
      {
         var message:Object = null;
         trace("resetToDefault is called");
         if(this.EMERGENCY_NUM == numberType)
         {
            this.mSpecialNumberType = this.EMERGENCY_NUM;
         }
         if(this.TOWING_ASSIS_NUM == numberType)
         {
            this.mSpecialNumberType = this.TOWING_ASSIS_NUM;
         }
         message = {
            "Type":"Command",
            "Dest":mPlatformDbusIdentifier,
            "packet":{"setDefaultNumber":{"NumberType":this.mSpecialNumberType}}
         };
         this.mConnection.send(message);
      }
      
      protected function sendSubscribe(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.mConnection.span.send(message);
      }
      
      protected function sendSubscribePIM(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + mPIM_DbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.mConnection.span.send(message);
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         var message:* = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + mDbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.mConnection.span.send(message);
      }
      
      private function btMessageHandler(e:ConnectionEvent) : void
      {
         var o:Object = null;
         var message:String = null;
         var rtnstr:String = null;
         var rtn:int = 0;
         var bluetooth:Object = e.data;
         if(bluetooth.hasOwnProperty("serviceDisconnected"))
         {
            if(bluetooth.serviceDisconnected.service == "HFPGW")
            {
               this.onServiceDisconnect();
            }
         }
      }
      
      private function platformMessageHandler(e:ConnectionEvent) : void
      {
         var platform:Object = e.data;
         if(platform.hasOwnProperty("setDefaultNumber"))
         {
            trace("PhoneBook:platformMessageHandler : Default number updated in data base successful");
            this.mFavoritesIsComplete = false;
            this.requestFavoritesCount();
         }
      }
      
      private function messageHandler(e:ConnectionEvent) : void
      {
         var property:String = null;
         var phoneBook:Object = e.data;
         for(property in phoneBook)
         {
            switch(property)
            {
               case "getItems":
                  this.getItems = phoneBook.getItems;
                  break;
               case "pimObjectSyncState":
                  this.pimObjectSyncState = phoneBook.pimObjectSyncState;
                  break;
               default:
                  try
                  {
                     this[property] = phoneBook[property];
                  }
                  catch(e:Error)
                  {
                  }
                  break;
            }
         }
      }
      
      private function set getItemsCount(eventObj:Object) : void
      {
         if(eventObj.hasOwnProperty("count"))
         {
            if(Boolean(eventObj.hasOwnProperty("status")) && "success" == eventObj.status)
            {
               if("ab" == eventObj.database)
               {
                  this.mFavoritesIsComplete = false;
                  this.mFavoritesCount = eventObj.count;
                  this.emitPhonebookStatus("favorite count received = " + this.mFavoritesCount);
                  this.dispatchEvent(new PhoneBookEvent(PhoneBookEvent.COUNT));
                  if(this.mFavoritesCount != -1)
                  {
                     this.requestFavoritesByRange(0,this.MAX_COUNT);
                  }
                  else
                  {
                     this.mFavoritesIsComplete = true;
                     this.mStartIndex = -1;
                     this.requestContactsCount();
                  }
               }
               else
               {
                  trace("PhoneBook Count received:: " + this.mCount);
                  if(false == this.mSyncSuccess && this.mHFPDeviceConnected && "pb" == eventObj.database)
                  {
                     if(Boolean(eventObj.hasOwnProperty("code")) && 0 == eventObj.code)
                     {
                        this.mSyncSuccess = true;
                        dispatchEvent(new PhoneBookEvent(PhoneBookEvent.AVAILABILITY));
                     }
                  }
                  if(this.mCount == -1 && this.mHFPDeviceConnected)
                  {
                     this.mCount = eventObj.count;
                     this.emitPhonebookStatus("phonebook count received = " + this.mCount);
                     this.mStartIndex = -1;
                     this.requestContactsList(0,PHONEBOOK_CACHE_SIZE > this.mCount ? uint(this.mCount) : uint(PHONEBOOK_CACHE_SIZE),"formattedName","ascending","");
                  }
                  else
                  {
                     this.mCount = eventObj.count;
                  }
                  dispatchEvent(new PhoneBookEvent(PhoneBookEvent.COUNT));
               }
            }
         }
         if(Boolean(eventObj.hasOwnProperty("status")) && "phone not connected" == eventObj.status)
         {
            this.mSyncSuccess = false;
         }
      }
      
      private function set getItems(eventObj:Object) : void
      {
         this.mPendingRequestList = false;
         trace("PhoneBook items received");
         if(Boolean(eventObj.hasOwnProperty("status")) && "success" == eventObj.status)
         {
            this.parseContactList(eventObj.result,eventObj.database);
         }
      }
      
      private function set databaseReady(eventObj:Object) : void
      {
         this.requestFavoritesCount();
      }
      
      private function set databaseChanged(eventObj:Object) : void
      {
         if(!eventObj.hasOwnProperty("db"))
         {
         }
      }
      
      private function set getPhoneNumByName(eventObj:Object) : void
      {
         if(Boolean(eventObj.hasOwnProperty("status")) && "success" == eventObj.status)
         {
            this.parseContactList(eventObj.result.items,"pb");
         }
      }
      
      private function set getAlphaJumpTable(eventObj:Object) : void
      {
         if(Boolean(eventObj.hasOwnProperty("status")) && "success" == eventObj.status)
         {
            this.mAlphaInfo = eventObj.result.alphaTable;
         }
      }
      
      private function set getNextValidCharacters(eventObj:Object) : void
      {
         var temp1:String = null;
         var temp2:String = null;
         if(Boolean(eventObj.hasOwnProperty("status")) && "success" == eventObj.status)
         {
            temp1 = eventObj.result.characterMask;
            temp2 = eventObj.result.characterMask;
            temp1 = temp1.toLowerCase();
            temp2 = temp2.toUpperCase();
            this.mNextVaildCharInfo = temp1 + temp2;
            this.mSmartSpellerIndex = eventObj.result.index;
            this.mSmartSpellerCount = eventObj.result.count;
            dispatchEvent(new PhoneBookEvent(PhoneBookEvent.NEXT_VALID_CHAR));
         }
      }
      
      private function set getNameByPhoneNum(eventObj:Object) : void
      {
         var callerIdNumber1:String = null;
         var homeNumber:String = null;
         var mobileNumber:String = null;
         var workNumber:String = null;
         var otherNumber:String = null;
         var callInfo:Object = null;
         if(eventObj.hasOwnProperty("status"))
         {
            if("success" == eventObj.status)
            {
               this.mcallerIDName = eventObj.result[0].formattedName;
               this.mcallerIDNumber = this.queriedCallerIDs[0];
               callerIdNumber1 = this.mcallerIDNumber;
               if(10 < callerIdNumber1.length)
               {
                  callerIdNumber1 = callerIdNumber1.slice(callerIdNumber1.length - 10,callerIdNumber1.length);
               }
               homeNumber = eventObj.result[0].homeNumber;
               mobileNumber = eventObj.result[0].mobileNumber;
               workNumber = eventObj.result[0].workNumber;
               otherNumber = eventObj.result[0].otherNumber;
               if(10 < homeNumber.length)
               {
                  homeNumber = homeNumber.slice(homeNumber.length - 10,homeNumber.length);
               }
               if(10 < mobileNumber.length)
               {
                  mobileNumber = mobileNumber.slice(mobileNumber.length - 10,mobileNumber.length);
               }
               if(10 < workNumber.length)
               {
                  workNumber = workNumber.slice(workNumber.length - 10,workNumber.length);
               }
               if(10 < otherNumber.length)
               {
                  otherNumber = otherNumber.slice(otherNumber.length - 10,otherNumber.length);
               }
               if(callerIdNumber1 == homeNumber)
               {
                  this.mPhoneNumType = "homeNumber";
               }
               else if(callerIdNumber1 == mobileNumber)
               {
                  this.mPhoneNumType = "mobileNumber";
               }
               else if(callerIdNumber1 == workNumber)
               {
                  this.mPhoneNumType = "workNumber";
               }
               else if(callerIdNumber1 == otherNumber)
               {
                  this.mPhoneNumType = "otherNumber";
               }
            }
            else if("failure" == eventObj.status)
            {
               this.mcallerIDName = "";
               this.mcallerIDNumber = this.queriedCallerIDs[0];
               this.mPhoneNumType = "";
            }
            if("" != this.mcallerIDName && "" != this.mPhoneNumType)
            {
               callInfo = new Object();
               callInfo.phoneNum = callerIdNumber1;
               callInfo.phoneNumType = this.mPhoneNumType;
               this.queriedCallerType.push(callInfo);
               if(this.queriedCallerType.length > 2)
               {
                  this.queriedCallerType.splice(0,1);
               }
            }
            this.dispatchEvent(new PhoneBookEvent(PhoneBookEvent.CALLER_ID));
         }
         this.queriedCallerIDs.splice(0,1);
      }
      
      private function set getEcoFileItemDetails(payload:Object) : void
      {
         this.dispatchEvent(new PhoneBookEvent(PhoneBookEvent.CONTACT,payload));
      }
      
      private function set insertItems(eventObj:Object) : void
      {
         if(Boolean(eventObj.hasOwnProperty("status")) && "success" == eventObj.status)
         {
            this.mFavoritesIsComplete = false;
            dispatchEvent(new PhoneBookEvent(PhoneBookEvent.FAVORITE_UPDATED));
         }
         this.requestCount("ab");
      }
      
      private function set updateItems(eventObj:Object) : void
      {
         if(Boolean(eventObj.hasOwnProperty("status")) && "success" == eventObj.status)
         {
            this.mFavoritesIsComplete = false;
            dispatchEvent(new PhoneBookEvent(PhoneBookEvent.FAVORITE_UPDATED));
         }
      }
      
      private function set deleteItems(eventObj:Object) : void
      {
         if(Boolean(eventObj.hasOwnProperty("status")) && "success" == eventObj.status)
         {
            this.mFavoritesIsComplete = false;
            dispatchEvent(new PhoneBookEvent(PhoneBookEvent.FAVORITE_UPDATED));
         }
      }
      
      private function set pimObjectSyncState(e:Object) : void
      {
         if(Boolean(e.hasOwnProperty("objectType")) && e.objectType == "Contacts")
         {
            if("syncComplete" == e.syncStatus || "syncStart" == e.syncStatus || "syncInProgress" == e.syncStatus || "syncError" == e.syncStatus)
            {
               this.mPhonebookSyncStatus = e.syncStatus;
               dispatchEvent(new PhoneBookEvent(PhoneBookEvent.PHONEBOOK_SYNC_STATUS));
            }
            if("syncComplete" == e.syncStatus)
            {
               this.mHFPDeviceConnected = true;
               this.mCount = -1;
               this.requestAlphaJumpInformation();
               this.requestContactsCount();
            }
            else if("syncUpdated" == e.syncStatus)
            {
               this.mSyncSuccess = true;
               this.mPhonebookSyncUpdated = true;
               dispatchEvent(new PhoneBookEvent(PhoneBookEvent.PHONEBOOK_SYNC_UPDATED));
               this.mCount = -1;
               this.requestAlphaJumpInformation();
               this.requestContactsCount();
            }
            else
            {
               this.mSyncSuccess = false;
               dispatchEvent(new PhoneBookEvent(PhoneBookEvent.AVAILABILITY));
            }
         }
      }
      
      private function parseContactList(listObject:Object, database:String) : void
      {
         var contact:Object = null;
         var index:uint = uint(this.mStartIndex);
         var favorite:Boolean = false;
         if(database == "ab")
         {
            this.emitPhonebookStatus("favorite contact list received");
            favorite = true;
         }
         if(favorite == false)
         {
            this.emitPhonebookStatus("phonebook contact list received");
            this.mContacts = null;
            this.mContacts = new Vector.<PhoneBookContact>();
         }
         else if(null != listObject && listObject.length >= 0 || this.mFavoritesContacts == null)
         {
            this.mFavoritesContacts = new Vector.<PhoneBookContact>();
         }
         for each(contact in listObject)
         {
            if(favorite == false)
            {
               this.mContacts.push(new PhoneBookContact(contact,index));
            }
            else
            {
               if(this.EMERGENCY_FAV_INDEX == contact.favIndex)
               {
                  this.mEmergencyNumber = contact.otherNumber;
               }
               if(this.TOWING_ASSIS_FAV_INDEX == contact.favIndex)
               {
                  this.mTowingAssistanceNumber = contact.otherNumber;
                  if("" == this.mTowingAssistanceNumber)
                  {
                     this.mIsTowingAssisNumEmpty = true;
                  }
                  else
                  {
                     this.mIsTowingAssisNumEmpty = false;
                  }
               }
               this.mFavoritesContacts.push(new PhoneBookContact(contact,index));
            }
            index++;
         }
         if(favorite == false)
         {
            dispatchEvent(new PhoneBookEvent(PhoneBookEvent.CONTACT_LIST));
            if(this.mFavoritesIsComplete == false)
            {
               this.requestFavoritesCount();
            }
         }
         else
         {
            dispatchEvent(new PhoneBookEvent(PhoneBookEvent.FAVORITES_LIST));
            this.mFavoritesIsComplete = true;
            this.requestContactsCount();
         }
      }
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case PhoneBookEvent.AVAILABILITY:
               if(this.mSyncSuccess)
               {
                  dispatchEvent(new PhoneBookEvent(PhoneBookEvent.AVAILABILITY));
               }
               break;
            case PhoneBookEvent.COUNT:
               if(this.mFavoritesIsComplete)
               {
                  this.requestContactsCount();
               }
               break;
            case PhoneBookEvent.CONTACT_LIST:
            case PhoneBookEvent.FAVORITES_LIST:
            case PhoneBookEvent.CONTACT:
               break;
            case PhoneBookEvent.PHONEBOOK_SYNC_UPDATED:
               if(this.mPhonebookSyncUpdated)
               {
                  dispatchEvent(new PhoneBookEvent(PhoneBookEvent.PHONEBOOK_SYNC_UPDATED));
               }
         }
      }
      
      private function emitPhonebookStatus(info:String) : void
      {
         var message:Object = null;
         message = {
            "Type":"EmitSignal",
            "packet":{"hmiPhonebookStatus":{"status":info}}
         };
         this.mConnection.send(message);
      }
   }
}

