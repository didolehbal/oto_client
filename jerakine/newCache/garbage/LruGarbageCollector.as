package com.ankamagames.jerakine.newCache.garbage
{
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.newCache.ICacheGarbageCollector;
   import com.ankamagames.jerakine.pools.Pool;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class LruGarbageCollector implements ICacheGarbageCollector
   {
      
      private static var _pool:Pool;
       
      
      protected var _usageCount:Dictionary;
      
      private var _cache:ICache;
      
      public function LruGarbageCollector()
      {
         this._usageCount = new Dictionary(true);
         super();
         if(!_pool)
         {
            _pool = new Pool(UsageCountHelper,500,50);
         }
      }
      
      public function set cache(param1:ICache) : void
      {
         this._cache = param1;
      }
      
      public function used(param1:*) : void
      {
         if(this._usageCount[param1])
         {
            ++this._usageCount[param1];
         }
         else
         {
            this._usageCount[param1] = 1;
         }
      }
      
      public function purge(param1:uint) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:UsageCountHelper = null;
         var _loc4_:* = undefined;
         var _loc5_:Array = new Array();
         for(_loc2_ in this._usageCount)
         {
            _loc5_.push((_pool.checkOut() as UsageCountHelper).init(_loc2_,this._usageCount[_loc2_]));
         }
         _loc5_.sortOn("count",Array.NUMERIC | Array.DESCENDING);
         for each(_loc3_ in _loc5_)
         {
            _loc3_.free();
            _pool.checkIn(_loc3_);
         }
         while(this._cache.size > param1 && _loc5_.length)
         {
            if((_loc4_ = this._cache.extract(_loc5_.pop().ref)) is IDestroyable)
            {
               (_loc4_ as IDestroyable).destroy();
            }
            if(_loc4_ is BitmapData)
            {
               (_loc4_ as BitmapData).dispose();
            }
            if(_loc4_ is ByteArray)
            {
               (_loc4_ as ByteArray).clear();
            }
         }
      }
   }
}

import com.ankamagames.jerakine.pools.Poolable;

class UsageCountHelper implements Poolable
{
    
   
   public var ref:Object;
   
   public var count:uint;
   
   function UsageCountHelper()
   {
      super();
   }
   
   public function init(param1:Object, param2:uint) : UsageCountHelper
   {
      this.ref = param1;
      this.count = param2;
      return this;
   }
   
   public function free() : void
   {
      this.ref = null;
      this.count = 0;
   }
}
