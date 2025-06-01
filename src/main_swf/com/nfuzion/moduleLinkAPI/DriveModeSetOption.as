package com.nfuzion.moduleLinkAPI
{
   public class DriveModeSetOption
   {
      public static var mTraction:uint;
      
      public static var mTrans:uint;
      
      public static var mSusp:uint;
      
      public static var mEps:uint;
      
      public static const POWERENALBE:String = "poserenalbe";
      
      public static const TRACTIONENABLE:String = "tractionenalbe";
      
      public static const PADDLEENABLE:String = "paddleenable";
      
      public static const TRANSENALBE:String = "transenalbe";
      
      public static const SUSPENALBE:String = "suspenalbe";
      
      public static const EPSENALBE:String = "epsenalbe";
      
      public static const POWER:String = "power";
      
      public static const TRACTION:String = "Traction";
      
      public static const PADDLE:String = "Paddle";
      
      public static const TRANS:String = "Trans";
      
      public static const SUSP:String = "Susp";
      
      public static const EPS:String = "Eps";
      
      public static const LA_RT:uint = 9;
      
      public static const LA_SRT:uint = 10;
      
      public static const LA_HELLCAT:uint = 11;
      
      public static const LD_RT:uint = 6;
      
      public static const LD_SRT:uint = 7;
      
      public static const LD_HELLCAT:uint = 8;
      
      public static const LX_BASE:uint = 3;
      
      public static const LX_SRT:uint = 4;
      
      public static const MODE_TRACK:uint = 1;
      
      public static const MODE_SPORT:uint = 2;
      
      public static const MODE_CUSTOM:uint = 3;
      
      public static const MODE_DEFAULT:uint = 4;
      
      public static const HPLOW:uint = 3;
      
      public static const HPHIGH:uint = 1;
      
      public static const TYPE_POWER:uint = 1;
      
      public static const TYPE_TRANS:uint = 2;
      
      public static const TYPE_PADDLE:uint = 3;
      
      public static const TYPE_TRACTION:uint = 4;
      
      public static const TYPE_SUSP:uint = 5;
      
      public static const TYPE_EPS:uint = 6;
      
      public static const TYPE_POWER_SETUP:uint = 7;
      
      public static const TYPE_TRANS_SETUP:uint = 8;
      
      public static const TYPE_PADDLE_SETUP:uint = 9;
      
      public static const TYPE_TRACTION_SETUP:uint = 10;
      
      public static const TYPE_SUSP_SETUP:uint = 11;
      
      public static const TYPE_EPS_SETUP:uint = 12;
      
      public var mPowerEnable:Boolean = false;
      
      public var mTractionEnabl:Boolean = false;
      
      public var mPaddleEnable:Boolean = false;
      
      public var mTransEnable:Boolean = false;
      
      public var mSuspEnable:Boolean = false;
      
      public var mEpsEnable:Boolean = false;
      
      public var mPower:uint;
      
      public var mPaddle:uint;
      
      public var mPowerSetup:uint;
      
      public var mTractionSetup:uint;
      
      public var mPaddleSetup:uint;
      
      public var mTransSetup:uint;
      
      public var mSuspSetup:uint;
      
      public var mEpsSetup:uint;
      
      public var mPowerTypes:uint;
      
      public var mTractionTypes:uint;
      
      public var mPaddleTypes:uint;
      
      public var mTransTypes:uint;
      
      public var mSuspTypes:uint;
      
      public var mEpsTypes:uint;
      
      public var mEscStauts:Boolean;
      
      public var mDriveMode:int = 0;
      
      public function DriveModeSetOption()
      {
         super();
      }
   }
}

