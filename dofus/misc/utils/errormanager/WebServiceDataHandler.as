package com.ankamagames.dofus.misc.utils.errormanager
{
   import by.blooddy.crypto.Base64;
   import by.blooddy.crypto.MD5;
   import by.blooddy.crypto.image.JPEGEncoder;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.utils.DateFormat;
   import com.ankamagames.dofus.misc.utils.RpcServiceCenter;
   import com.ankamagames.dofus.misc.utils.RpcServiceManager;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.TextLogEvent;
   import com.ankamagames.jerakine.logger.targets.LimitedBufferTarget;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setInterval;
   
   public class WebServiceDataHandler extends EventDispatcher
   {
      
      public static var ENABLE_SCREENSHOT:Boolean = true;
      
      public static var buffer:LimitedBufferTarget;
      
      private static var _self:WebServiceDataHandler;
      
      private static var LIMIT_REBOOT:int = 20;
      
      public static const ALL_DATA_SENT:String = "everythings has been sent";
      
      private static const MIN_DELAY:int = 30;
      
      private static const MAX_DELAY:int = 5 * 60 - MIN_DELAY;
       
      
      private var _log:Logger;
      
      private var _exceptionsList:Vector.<DataExceptionModel>;
      
      private var _webService:RpcServiceManager;
      
      private var _exceptionsInProgress:Dictionary;
      
      private var _timersList:Dictionary;
      
      private var _previousErrorType:String = "";
      
      public function WebServiceDataHandler(param1:PrivateClass)
      {
         this._log = Log.getLogger(getQualifiedClassName(WebServiceDataHandler));
         this._exceptionsList = new Vector.<DataExceptionModel>();
         this._exceptionsInProgress = new Dictionary(true);
         this._timersList = new Dictionary(true);
         super();
         if(param1 == null)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : WebServiceDataHandler
      {
         if(_self == null)
         {
            _self = new WebServiceDataHandler(new PrivateClass());
         }
         return _self;
      }
      
      public function createNewException(param1:Object, param2:String) : DataExceptionModel
      {
         var _loc3_:Frame = null;
         var _loc4_:Array = null;
         var _loc5_:Date = null;
         var _loc6_:Array = null;
         var _loc7_:Number = NaN;
         var _loc8_:BitmapData = null;
         var _loc9_:Matrix = null;
         if(this._previousErrorType == "ONE" && this._exceptionsList.length >= 1)
         {
            return null;
         }
         this._previousErrorType = this.getSendingType(param2);
         var _loc10_:DataExceptionModel = new DataExceptionModel();
         if(param1.stacktrace == null)
         {
            return null;
         }
         _loc10_.hash = MD5.hash(this.cleanStacktrace(param1.stacktrace));
         _loc10_.stacktrace = param1.stacktrace;
         if(param1.errorMsg != null && param1.errorMsg != "")
         {
            _loc10_.stacktrace = param1.errorMsg + "\n" + _loc10_.stacktrace;
         }
         _loc10_.buildType = param1.buildType;
         _loc10_.buildVersion = param1.buildVersion;
         if(_loc10_.buildType == "INTERNAL" || _loc10_.buildType == "DEBUG")
         {
            _loc5_ = new Date();
            _loc6_ = _loc10_.buildVersion.split(".");
            _loc6_[_loc6_.length - 2] = DateFormat.dayOfYear(_loc5_.fullYear,_loc5_.month,_loc5_.date);
            _loc6_.pop();
            _loc10_.buildVersion = _loc6_.join(".");
         }
         var _loc11_:Array = param1.os.split(" ");
         _loc10_.osType = _loc11_[0];
         _loc10_.osVersion = !!_loc11_[1]?_loc11_[1]:"";
         if(ENABLE_SCREENSHOT)
         {
            _loc7_ = 1 / 3;
            _loc8_ = new BitmapData(StageShareManager.startWidth * _loc7_,StageShareManager.startHeight * _loc7_);
            (_loc9_ = new Matrix()).scale(_loc7_,_loc7_);
            _loc8_.draw(StageShareManager.stage,_loc9_);
            buffer.logEvent(new TextLogEvent("[BUG_REPORT]","[SCREEN]" + Base64.encode(JPEGEncoder.encode(_loc8_,60))));
         }
         _loc10_.logsSos = buffer.getFormatedBuffer();
         _loc10_.serverId = param1.serverId;
         _loc10_.mapId = param1.idMap;
         _loc10_.characterId = param1.characterId;
         _loc10_.isInFight = param1.wasFighting;
         _loc10_.isMultiAccount = param1.multicompte;
         _loc10_.date = TimeManager.getInstance().getTimestamp() / 1000;
         var _loc12_:* = "";
         for each(_loc3_ in Kernel.getWorker().framesList)
         {
            _loc4_ = getQualifiedClassName(_loc3_).split("::");
            _loc12_ = _loc12_ + (String(!!_loc4_[1]?_loc4_[1]:_loc4_[0]).replace("Frame","") + ",");
         }
         _loc10_.framesList = _loc12_;
         this._exceptionsList.push(_loc10_);
         return _loc10_;
      }
      
      public function cleanStacktrace(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:RegExp = null;
         var _loc5_:* = "";
         var _loc6_:Array = param1.split("\n");
         for each(_loc2_ in _loc6_)
         {
            _loc3_ = _loc6_.indexOf(_loc2_);
            if(_loc3_ > 0)
            {
               _loc2_ = _loc2_.replace(/\\/g,"/");
            }
            _loc4_ = /^(.*?\[)(.*?)((\/modules\/Ankama_|\/com\/ankama).*?)(:?[0-9]*?)(\].*?)/g;
            _loc5_ = _loc5_ + _loc2_.replace(_loc4_,"$1$3$6");
            if(_loc3_ < _loc6_.length - 1)
            {
               _loc5_ = _loc5_ + "\n";
            }
         }
         return _loc5_;
      }
      
      private function sendDataToWebservice(param1:DataExceptionModel) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(this._webService == null)
         {
            this.initWebService();
         }
         this._webService.callMethod("Exception",{
            "sHash":param1.hash,
            "sStacktrace":param1.stacktrace,
            "iVersion":param1.buildType,
            "iBuildVersion":param1.buildVersion,
            "iDate":param1.date,
            "sOs":param1.osType,
            "sOsVersion":param1.osVersion,
            "iServerId":param1.serverId,
            "iCharacterId":param1.characterId,
            "iMapId":param1.mapId,
            "bMultipleAccout":param1.isMultiAccount,
            "bIsFighting":param1.isInFight,
            "sFrameList":param1.framesList,
            "sCustom":param1.logsSos,
            "sErrorType":param1.errorType
         });
      }
      
      private function onDataSavedComplete(param1:Event) : void
      {
         var _loc2_:RpcServiceManager = param1.currentTarget as RpcServiceManager;
         var _loc3_:String = _loc2_.requestData.params.sHash;
         if(this._exceptionsInProgress[_loc3_])
         {
            (this._exceptionsInProgress[_loc3_] as DataExceptionModel).sent = true;
            delete this._exceptionsInProgress[_loc3_];
         }
         if(this.getWaitingExceptionsNumber() == 0)
         {
            dispatchEvent(new Event(ALL_DATA_SENT));
         }
      }
      
      private function getWaitingExceptionsNumber() : int
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         for(_loc1_ in this._exceptionsInProgress)
         {
            _loc2_++;
         }
         return _loc2_;
      }
      
      private function onDataSavedError(param1:Event) : void
      {
         this._log.trace(param1.toString());
         var _loc2_:RpcServiceManager = param1.currentTarget as RpcServiceManager;
      }
      
      private function initWebService() : void
      {
         var _loc1_:* = RpcServiceCenter.getInstance().apiDomain + "/dofus/logger.json";
         this._webService = new RpcServiceManager(_loc1_,"json");
         this._webService.addEventListener(Event.COMPLETE,this.onDataSavedComplete);
         this._webService.addEventListener(IOErrorEvent.IO_ERROR,this.onDataSavedError);
         this._webService.addEventListener(RpcServiceManager.SERVER_ERROR,this.onDataSavedError);
      }
      
      public function clearService(param1:RpcServiceManager = null) : void
      {
         if(param1 == null)
         {
            param1 = this._webService;
         }
         param1.removeEventListener(Event.COMPLETE,this.onDataSavedComplete);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onDataSavedError);
         param1.removeEventListener(RpcServiceManager.SERVER_ERROR,this.onDataSavedError);
         param1.destroy();
         param1 = null;
      }
      
      public function saveException(param1:DataExceptionModel, param2:Boolean = false) : void
      {
         var v:int = 0;
         var t:Timer = null;
         var exception:DataExceptionModel = param1;
         var forceSend:Boolean = param2;
         if(forceSend)
         {
            this.sendDataToWebservice(exception);
            this._exceptionsInProgress[exception.hash] = exception;
         }
         else
         {
            v = Math.round(Math.random() * MAX_DELAY * 1000 + MIN_DELAY * 1000);
            t = new Timer(v,1);
            this._exceptionsInProgress[exception.hash] = exception;
            this._timersList[t] = null;
            t.addEventListener(TimerEvent.TIMER_COMPLETE,function e(param1:TimerEvent):void
            {
               sendDataToWebservice(exception);
               (param1.currentTarget as Timer).stop();
            });
            t.start();
         }
      }
      
      public function sendWaitingException() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:DataExceptionModel = null;
         for(_loc1_ in this._timersList)
         {
            (_loc1_ as Timer).stop();
            _loc1_ = null;
         }
         for each(_loc2_ in this._exceptionsList)
         {
            if(!_loc2_.sent)
            {
               this.saveException(_loc2_,true);
            }
         }
      }
      
      public function quit() : Boolean
      {
         if(this._exceptionsList.length == 0)
         {
            return false;
         }
         var exception:DataExceptionModel = this._exceptionsList[this._exceptionsList.length - 1];
         var d:Date = new Date();
         if(Math.round(d.time / 1000) - exception.date <= LIMIT_REBOOT)
         {
            exception.isBlockerAndReboot = true;
         }
         if(this._exceptionsList.length > 0)
         {
            setInterval(function e():void
            {
               dispatchEvent(new Event(ALL_DATA_SENT));
            },3000);
            return true;
         }
         return false;
      }
      
      public function changeCharacter() : void
      {
         var _loc1_:DataExceptionModel = null;
         if(this._exceptionsList == null || this._exceptionsList.length == 0)
         {
            return;
         }
         var _loc2_:Date = new Date();
         for each(_loc1_ in this._exceptionsList)
         {
            if(_loc1_ != null && Math.round(_loc2_.time / 1000) - _loc1_.date <= LIMIT_REBOOT)
            {
               _loc1_.isBlockerAndChangeCharacter = true;
            }
         }
      }
      
      public function getSendingType(param1:String) : String
      {
         switch(param1.toLowerCase())
         {
            case "error":
         }
         return "ONE";
      }
      
      public function reset() : void
      {
         this._previousErrorType = "";
         this._exceptionsList = new Vector.<DataExceptionModel>();
      }
   }
}

class PrivateClass
{
    
   
   function PrivateClass()
   {
      super();
   }
}
