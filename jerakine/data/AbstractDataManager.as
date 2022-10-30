package com.ankamagames.jerakine.data
{
   import com.ankamagames.jerakine.JerakineConstants;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.newCache.impl.InfiniteCache;
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import flash.utils.getQualifiedClassName;
   
   public class AbstractDataManager
   {
      
      static const DATA_KEY:String = "data";
       
      
      protected const _log:Logger = Log.getLogger(getQualifiedClassName(AbstractDataManager));
      
      protected var _cacheSO:ICache;
      
      protected var _cacheKey:ICache;
      
      protected var _soPrefix:String = "";
      
      public function AbstractDataManager()
      {
         super();
      }
      
      public function getObject(param1:uint) : Object
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:CustomSharedObject = null;
         var _loc5_:String = this._soPrefix + param1;
         if(this._cacheKey.contains(_loc5_))
         {
            return this._cacheKey.peek(_loc5_);
         }
         var _loc6_:uint = StoreDataManager.getInstance().getData(JerakineConstants.DATASTORE_FILES_INFO,this._soPrefix + "_chunkLength");
         var _loc7_:String = this._soPrefix + Math.floor(param1 / _loc6_);
         if(this._cacheSO.contains(_loc7_))
         {
            _loc3_ = this._cacheSO.peek(_loc7_);
            _loc2_ = CustomSharedObject(this._cacheSO.peek(_loc7_)).data[DATA_KEY][param1];
            this._cacheKey.store(_loc5_,_loc2_);
            return _loc2_;
         }
         if(!(_loc4_ = CustomSharedObject.getLocal(_loc7_)) || !_loc4_.data[DATA_KEY])
         {
            return null;
         }
         this._cacheSO.store(_loc7_,_loc4_);
         _loc2_ = _loc4_.data[DATA_KEY][param1];
         this._cacheKey.store(_loc5_,_loc2_);
         return _loc2_;
      }
      
      public function getObjects() : Array
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         var _loc3_:CustomSharedObject = null;
         var _loc4_:Array;
         if(!(_loc4_ = StoreDataManager.getInstance().getData(JerakineConstants.DATASTORE_FILES_INFO,this._soPrefix + "_filelist")))
         {
            return null;
         }
         var _loc5_:Array = new Array();
         for each(_loc2_ in _loc4_)
         {
            _loc1_ = this._soPrefix + _loc2_;
            if(this._cacheSO.contains(_loc1_))
            {
               _loc5_ = _loc5_.concat(CustomSharedObject(this._cacheSO.peek(_loc1_)).data[DATA_KEY]);
            }
            else
            {
               _loc3_ = CustomSharedObject.getLocal(_loc1_);
               if(!(!_loc3_ || !_loc3_.data[DATA_KEY]))
               {
                  this._cacheSO.store(_loc1_,_loc3_);
                  _loc5_ = _loc5_.concat(_loc3_.data[DATA_KEY]);
               }
            }
         }
         return _loc5_;
      }
      
      function init(param1:uint, param2:uint, param3:String = "") : void
      {
         if(param2 == uint.MAX_VALUE)
         {
            this._cacheKey = new InfiniteCache();
         }
         else
         {
            this._cacheKey = Cache.create(param2,new LruGarbageCollector(),getQualifiedClassName(this) + "_key");
         }
         this._cacheSO = Cache.create(param1,new LruGarbageCollector(),getQualifiedClassName(this) + "_so");
         this._soPrefix = param3;
      }
   }
}
