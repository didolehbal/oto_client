package com.ankamagames.jerakine.newCache.impl
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.resources.CacheableResource;
   import com.ankamagames.jerakine.types.ASwf;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class DisplayObjectCache implements ICache
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(DisplayObjectCache));
       
      
      private var _cache:Dictionary;
      
      private var _size:uint = 0;
      
      private var _bounds:uint;
      
      private var _useCount:Dictionary;
      
      public function DisplayObjectCache(param1:uint)
      {
         this._cache = new Dictionary(true);
         this._useCount = new Dictionary(true);
         super();
         this._bounds = param1;
      }
      
      public function get size() : uint
      {
         return this._size;
      }
      
      public function contains(param1:*) : Boolean
      {
         var _loc2_:CacheableResource = null;
         var _loc3_:Array = this._cache[param1];
         for each(_loc2_ in _loc3_)
         {
            if(_loc2_.resource && (_loc2_.resource is ASwf || _loc2_.resource.hasOwnProperty("parent") && !_loc2_.resource.parent))
            {
               return true;
            }
         }
         return false;
      }
      
      public function extract(param1:*) : *
      {
         var _loc2_:* = this.peek(param1);
         if(_loc2_)
         {
            delete this._cache[param1];
            delete this._useCount[param1];
            --this._size;
         }
         return _loc2_;
      }
      
      public function peek(param1:*) : *
      {
         var _loc2_:CacheableResource = null;
         var _loc3_:Array = this._cache[param1];
         for each(_loc2_ in _loc3_)
         {
            if(_loc2_.resource && (_loc2_.resource is ASwf || _loc2_.resource.hasOwnProperty("parent") && !_loc2_.resource.parent))
            {
               ++this._useCount[param1];
               return _loc2_;
            }
         }
         return null;
      }
      
      public function store(param1:*, param2:*) : Boolean
      {
         if(!(param2 is CacheableResource))
         {
            _log.error("Tried to store something which is not a CacheableResource... Caching file " + param1 + " failed.");
            return false;
         }
         var _loc3_:* = param2.resource is ASwf;
         if(!this._cache[param1])
         {
            this._cache[param1] = new Array();
            this._useCount[param1] = 0;
            ++this._size;
            if(this._size > this._bounds)
            {
               this.garbage();
            }
         }
         ++this._useCount[param1];
         this._cache[param1].push(param2);
         return true;
      }
      
      public function destroy() : void
      {
         this._cache = new Dictionary(true);
         this._size = 0;
         this._bounds = 0;
         this._useCount = new Dictionary(true);
      }
      
      private function garbage() : void
      {
         var _loc1_:* = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc7_:CacheableResource = null;
         var _loc8_:Array = new Array();
         for(_loc1_ in this._cache)
         {
            if(this._cache[_loc1_] != null && this._useCount[_loc1_])
            {
               _loc8_.push({
                  "ref":_loc1_,
                  "useCount":this._useCount[_loc1_]
               });
            }
         }
         _loc8_.sortOn("useCount",Array.NUMERIC);
         _loc2_ = this._bounds * 0.1;
         _loc3_ = _loc8_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc3_ && this._size > _loc2_)
         {
            _loc5_ = false;
            _loc4_ = this._cache[_loc8_[_loc6_].ref];
            for each(_loc7_ in _loc4_)
            {
               if(_loc7_ && _loc7_.resource && (_loc7_.resource is ASwf || _loc7_.resource.hasOwnProperty("parent") && _loc7_.resource.parent))
               {
                  _loc5_ = true;
                  break;
               }
            }
            if(!_loc5_)
            {
               delete this._cache[_loc8_[_loc6_].ref];
               delete this._useCount[_loc8_[_loc6_].ref];
               --this._size;
            }
            _loc6_++;
         }
      }
   }
}
