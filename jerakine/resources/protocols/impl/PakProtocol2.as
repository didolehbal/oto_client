package com.ankamagames.jerakine.resources.protocols.impl
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.resources.IResourceObserver;
   import com.ankamagames.jerakine.resources.ResourceErrorCode;
   import com.ankamagames.jerakine.resources.protocols.AbstractProtocol;
   import com.ankamagames.jerakine.resources.protocols.IProtocol;
   import com.ankamagames.jerakine.types.Uri;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class PakProtocol2 extends AbstractProtocol implements IProtocol
   {
      
      private static var _indexes:Dictionary = new Dictionary();
      
      private static var _properties:Dictionary = new Dictionary();
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(PakProtocol2));
       
      
      public function PakProtocol2()
      {
         super();
      }
      
      public function getFilesIndex(param1:Uri) : Dictionary
      {
         var _loc2_:* = _indexes[param1.path];
         if(!_loc2_)
         {
            _loc2_ = this.initStream(param1);
            if(!_loc2_)
            {
               return null;
            }
         }
         return _indexes[param1.path];
      }
      
      public function load(param1:Uri, param2:IResourceObserver, param3:Boolean, param4:ICache, param5:Class, param6:Boolean) : void
      {
         var fileStream:FileStream = null;
         var uri:Uri = param1;
         var observer:IResourceObserver = param2;
         var dispatchProgress:Boolean = param3;
         var cache:ICache = param4;
         var forcedAdapter:Class = param5;
         var uniqueFile:Boolean = param6;
         if(!_indexes[uri.path])
         {
            fileStream = this.initStream(uri);
            if(!fileStream)
            {
               if(observer)
               {
                  observer.onFailed(uri,"Unable to find container.",ResourceErrorCode.PAK_NOT_FOUND);
               }
               return;
            }
         }
         var index:Object = _indexes[uri.path][uri.subPath];
         if(!index)
         {
            if(observer)
            {
               observer.onFailed(uri,"Unable to find the file in the container.",ResourceErrorCode.FILE_NOT_FOUND_IN_PAK);
            }
            return;
         }
         fileStream = index.stream;
         var data:ByteArray = new ByteArray();
         fileStream.position = index.o;
         fileStream.readBytes(data,0,index.l);
         getAdapter(uri,forcedAdapter);
         try
         {
            _adapter.loadFromData(uri,data,observer,dispatchProgress);
         }
         catch(e:Object)
         {
            observer.onFailed(uri,"Can\'t load byte array from this adapter.",ResourceErrorCode.INCOMPATIBLE_ADAPTER);
            return;
         }
      }
      
      override protected function release() : void
      {
      }
      
      override public function cancel() : void
      {
         if(_adapter)
         {
            _adapter.free();
         }
      }
      
      private function initStream(param1:Uri) : FileStream
      {
         var _loc2_:FileStream = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:uint = 0;
         var _loc14_:String = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Uri;
         var _loc19_:File = (_loc18_ = param1).toFile();
         var _loc20_:Dictionary = new Dictionary();
         var _loc21_:Dictionary = new Dictionary();
         _indexes[param1.path] = _loc20_;
         _properties[param1.path] = _loc21_;
         while(_loc19_ && _loc19_.exists)
         {
            _loc2_ = new FileStream();
            _loc2_.open(_loc19_,FileMode.READ);
            _loc3_ = _loc2_.readUnsignedByte();
            _loc4_ = _loc2_.readUnsignedByte();
            if(_loc3_ != 2 || _loc4_ != 1)
            {
               return null;
            }
            _loc2_.position = _loc19_.size - 24;
            _loc5_ = _loc2_.readUnsignedInt();
            _loc6_ = _loc2_.readUnsignedInt();
            _loc7_ = _loc2_.readUnsignedInt();
            _loc8_ = _loc2_.readUnsignedInt();
            _loc9_ = _loc2_.readUnsignedInt();
            _loc10_ = _loc2_.readUnsignedInt();
            _loc2_.position = _loc9_;
            _loc19_ = null;
            _loc13_ = 0;
            while(_loc13_ < _loc10_)
            {
               _loc11_ = _loc2_.readUTF();
               _loc12_ = _loc2_.readUTF();
               _loc21_[_loc11_] = _loc12_;
               if(_loc11_ == "link")
               {
                  if((_loc17_ = _loc18_.path.lastIndexOf("/")) != -1)
                  {
                     _loc18_ = new Uri(_loc18_.path.substr(0,_loc17_) + "/" + _loc12_);
                  }
                  else
                  {
                     _loc18_ = new Uri(_loc12_);
                  }
                  _loc19_ = _loc18_.toFile();
               }
               _loc13_++;
            }
            _loc2_.position = _loc7_;
            _loc13_ = 0;
            while(_loc13_ < _loc8_)
            {
               _loc14_ = _loc2_.readUTF();
               _loc15_ = _loc2_.readInt();
               _loc16_ = _loc2_.readInt();
               _loc20_[_loc14_] = {
                  "o":_loc15_ + _loc5_,
                  "l":_loc16_,
                  "stream":_loc2_
               };
               _loc13_++;
            }
         }
         return _loc2_;
      }
   }
}
