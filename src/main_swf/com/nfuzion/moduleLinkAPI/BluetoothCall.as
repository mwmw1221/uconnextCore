package com.nfuzion.moduleLinkAPI
{
   public class BluetoothCall
   {
      public static const mCallStateNone:String = "none";
      
      public static const mCallStateIdle:String = "idle";
      
      public static const mCallStateRinging:String = "ringing";
      
      public static const mCallStateDialing:String = "dialing";
      
      public static const mCallStateAlerting:String = "alerting";
      
      public static const mCallStateActive:String = "active";
      
      public static const mCallStateOnHold:String = "onhold";
      
      public static const mCallStateWaiting:String = "waiting";
      
      private var mCallId:int;
      
      private var mNumber:String;
      
      private var mCallerID:String;
      
      private var mCallState:String;
      
      private var mPreviousCallState:String;
      
      private var mActiveTime:int;
      
      private var mDuration:int;
      
      private var mAudio:Boolean;
      
      public function BluetoothCall(callID:int, callState:String)
      {
         super();
         this.mCallId = callID;
         this.mCallState = callState;
         this.mPreviousCallState = mCallStateNone;
         this.mNumber = "";
         this.mActiveTime = 0;
         this.mDuration = 0;
         this.mAudio = false;
         this.mCallerID = null;
      }
      
      public function get callId() : int
      {
         return this.mCallId;
      }
      
      public function set callId(cid:int) : void
      {
         this.mCallId = cid;
      }
      
      public function get number() : String
      {
         return this.mNumber;
      }
      
      public function set number(n:String) : void
      {
         this.mNumber = n;
      }
      
      public function get audio() : Boolean
      {
         return this.mAudio;
      }
      
      public function set audio(a:Boolean) : void
      {
         this.mAudio = a;
      }
      
      public function get callerID() : String
      {
         return this.mCallerID;
      }
      
      public function set callerID(n:String) : void
      {
         this.mCallerID = n;
      }
      
      public function get callState() : String
      {
         return this.mCallState;
      }
      
      public function set callState(state:String) : void
      {
         this.mPreviousCallState = this.mCallState;
         this.mCallState = state;
      }
      
      public function set previousCallState(pcs:String) : void
      {
         this.mPreviousCallState = pcs;
      }
      
      public function get previousCallState() : String
      {
         return this.mPreviousCallState;
      }
      
      public function setDuration(dur:int) : void
      {
         this.mDuration = dur;
         if(this.mDuration < this.mActiveTime)
         {
            this.mActiveTime = 0;
         }
         if(this.mCallState != mCallStateActive && this.mCallState != mCallStateOnHold)
         {
            this.mActiveTime = this.mDuration;
         }
      }
      
      public function duration() : int
      {
         return this.mDuration - this.mActiveTime;
      }
   }
}

