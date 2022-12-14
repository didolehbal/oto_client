package com.ankamagames.jerakine.network
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.jerakine.resources.adapters.impl.BinaryAdapter;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class HttpServerConnection
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HttpServerConnection));
       
      
      private var _loader:IResourceLoader;
      
      private var _requestTimestamp:Dictionary;
      
      private var _errorCallback:Dictionary;
      
      private var _whiteList:Dictionary;
      
      private var _whiteListCount:uint;
      
      public var rawParser:RawDataParser;
      
      public var handler:MessageHandler;
      
      public function HttpServerConnection()
      {
         super();
         this.init();
      }
      
      public function resetTime(param1:Uri) : void
      {
         delete this._requestTimestamp[param1.toString()];
      }
      
      public function request(param1:Uri, param2:Function = null, param3:uint = 0) : Boolean
      {
         var _loc4_:Number;
         if((_loc4_ = this._requestTimestamp[param1.toString()]) && getTimer() - _loc4_ < param3)
         {
            return false;
         }
         if(param2 == null)
         {
            this._errorCallback[param1] = param2;
         }
         this._requestTimestamp[param1.toString()] = getTimer();
         this._loader.load(param1,null,BinaryAdapter);
         return true;
      }
      
      public function reset() : void
      {
         this._loader.cancel();
      }
      
      public function addToWhiteList(param1:Class) : void
      {
         if(!this._whiteList[param1])
         {
            this._whiteList[param1] = true;
            ++this._whiteListCount;
         }
      }
      
      public function removeFromWhiteList(param1:Class) : void
      {
         if(this._whiteList[param1])
         {
            delete this._whiteList[param1];
            --this._whiteListCount;
         }
      }
      
      public function get whiteListCount() : uint
      {
         return this._whiteListCount;
      }
      
      private function init() : void
      {
         this._whiteList = new Dictionary();
         this._errorCallback = new Dictionary(true);
         this._requestTimestamp = new Dictionary();
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onError);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onReceive);
      }
      
      private function getMessageId(param1:uint) : uint
      {
         return param1 >> NetworkMessage.BIT_RIGHT_SHIFT_LEN_PACKET_ID;
      }
      
      private function readMessageLength(param1:uint, param2:IDataInput) : uint
      {
         var _loc4_:uint = 0;
         var _loc3_:uint = param1 & NetworkMessage.BIT_MASK;
         switch(_loc3_)
         {
            case 0:
               break;
            case 1:
               _loc4_ = param2.readUnsignedByte();
               break;
            case 2:
               _loc4_ = param2.readUnsignedShort();
               break;
            case 3:
               _loc4_ = ((param2.readByte() & 255) << 16) + ((param2.readByte() & 255) << 8) + (param2.readByte() & 255);
         }
         return _loc4_;
      }
      
      protected function lowReceive(param1:IDataInput) : INetworkMessage
      {
         var _loc2_:uint = 0;
         if(param1.bytesAvailable < 2)
         {
            return null;
         }
         var _loc3_:uint = param1.readUnsignedShort();
         var _loc4_:uint = this.getMessageId(_loc3_);
         if(param1.bytesAvailable >= (_loc3_ & NetworkMessage.BIT_MASK))
         {
            _loc2_ = this.readMessageLength(_loc3_,param1);
            if(param1.bytesAvailable >= _loc2_)
            {
               return this.rawParser.parse(new CustomDataWrapper(param1),_loc4_,_loc2_);
            }
         }
         return null;
      }
      
      protected function receive(param1:IDataInput, param2:Uri) : void
      {
         var _loc3_:INetworkMessage = null;
         var _loc4_:uint = param1.bytesAvailable;
         while(param1.bytesAvailable > 0)
         {
            _loc3_ = this.lowReceive(param1);
            if(!_loc3_)
            {
               if(_loc4_ == param1.bytesAvailable)
               {
                  _log.error("Error while reading " + param2 + " : malformated data");
                  return;
               }
               _log.error("Unknow message from " + param2);
               return;
            }
            _loc4_ = param1.bytesAvailable;
            if(_loc3_ is INetworkDataContainerMessage)
            {
               while(INetworkDataContainerMessage(_loc3_).content.bytesAvailable)
               {
                  this.receive(INetworkDataContainerMessage(_loc3_).content,param2);
               }
            }
            else if(!this._whiteListCount || this._whiteList[Object(_loc3_).constructor])
            {
               _log.info("Dispatch " + _loc3_ + " from " + param2);
               this.handler.process(_loc3_);
            }
            else
            {
               _log.error("Packet " + _loc3_ + " cannot be used from a web server (uri: " + param2.toString() + ")");
            }
         }
      }
      
      private function onReceive(param1:ResourceLoadedEvent) : void
      {
         delete this._errorCallback[param1.uri];
         var _loc2_:Number = getTimer();
         this.receive(param1.resource as ByteArray,param1.uri);
         _log.info("Network packet parsed in " + (getTimer() - _loc2_) + " ms");
      }
      
      private function onError(param1:ResourceErrorEvent) : void
      {
         var _loc2_:* = undefined;
         _log.error("Cannot load " + param1.uri + " : " + param1.errorMsg);
         if(this._errorCallback[param1.uri] != null)
         {
            _loc2_ = this._errorCallback;
            _loc2_[param1.uri](param1.uri);
         }
         delete this._errorCallback[param1.uri];
      }
   }
}
