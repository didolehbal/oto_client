package com.ankamagames.jerakine.resources.protocols.impl
{
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
   
   public class PakProtocol extends AbstractProtocol implements IProtocol
   {
      
      private static var _streams:Dictionary = new Dictionary();
      
      private static var _indexes:Dictionary = new Dictionary();
       
      
      public function PakProtocol()
      {
         super();
      }
      
      public function getFilesIndex(param1:Uri) : Dictionary
      {
         var _loc2_:FileStream = _streams[param1.path];
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
         var uri:Uri = param1;
         var observer:IResourceObserver = param2;
         var dispatchProgress:Boolean = param3;
         var cache:ICache = param4;
         var forcedAdapter:Class = param5;
         var uniqueFile:Boolean = param6;
         var fileStream:FileStream = _streams[uri.path];
         if(!fileStream)
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
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:File;
         if(!(_loc5_ = param1.toFile()).exists)
         {
            return null;
         }
         var _loc6_:FileStream;
         (_loc6_ = new FileStream()).open(_loc5_,FileMode.READ);
         var _loc7_:Dictionary = new Dictionary();
         var _loc8_:int = _loc6_.readInt();
         _loc6_.position = _loc8_;
         while(_loc6_.bytesAvailable > 0)
         {
            _loc2_ = _loc6_.readUTF();
            _loc3_ = _loc6_.readInt();
            _loc4_ = _loc6_.readInt();
            _loc7_[_loc2_] = {
               "o":_loc3_,
               "l":_loc4_
            };
         }
         _indexes[param1.path] = _loc7_;
         _streams[param1.path] = _loc6_;
         return _loc6_;
      }
   }
}
