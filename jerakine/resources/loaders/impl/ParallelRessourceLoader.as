package com.ankamagames.jerakine.resources.loaders.impl
{
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.resources.IResourceObserver;
   import com.ankamagames.jerakine.resources.events.ResourceProgressEvent;
   import com.ankamagames.jerakine.resources.loaders.AbstractRessourceLoader;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.protocols.IProtocol;
   import com.ankamagames.jerakine.resources.protocols.ProtocolFactory;
   import com.ankamagames.jerakine.types.Uri;
   import flash.utils.Dictionary;
   
   public class ParallelRessourceLoader extends AbstractRessourceLoader implements IResourceLoader, IResourceObserver
   {
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
       
      
      private var _maxParallel:uint;
      
      private var _uris:Array;
      
      private var _currentlyLoading:uint;
      
      private var _loadDictionnary:Dictionary;
      
      public function ParallelRessourceLoader(param1:uint)
      {
         super();
         this._maxParallel = param1;
         this._loadDictionnary = new Dictionary(true);
         MEMORY_LOG[this] = 1;
      }
      
      public function load(param1:*, param2:ICache = null, param3:Class = null, param4:Boolean = false) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Uri = null;
         var _loc7_:Boolean = false;
         if(param1 is Uri)
         {
            _loc5_ = [param1];
         }
         else
         {
            if(!(param1 is Array))
            {
               throw new ArgumentError("URIs must be an array or an Uri instance.");
            }
            _loc5_ = param1;
         }
         if(this._uris != null)
         {
            for each(_loc6_ in _loc5_)
            {
               this._uris.push({
                  "uri":_loc6_,
                  "forcedAdapter":param3,
                  "singleFile":param4
               });
            }
            if(this._currentlyLoading == 0)
            {
               _loc7_ = true;
            }
         }
         else
         {
            this._uris = new Array();
            for each(_loc6_ in _loc5_)
            {
               this._uris.push({
                  "uri":_loc6_,
                  "forcedAdapter":param3,
                  "singleFile":param4
               });
            }
            _loc7_ = true;
         }
         _cache = param2;
         _completed = false;
         _filesTotal = _filesTotal + this._uris.length;
         if(_loc7_)
         {
            this.loadNextUris();
         }
      }
      
      override public function cancel() : void
      {
         var _loc1_:IProtocol = null;
         super.cancel();
         for each(_loc1_ in this._loadDictionnary)
         {
            if(_loc1_)
            {
               _loc1_.free();
               _loc1_.cancel();
               _loc1_ = null;
            }
         }
         this._loadDictionnary = new Dictionary(true);
         this._currentlyLoading = 0;
         this._uris = [];
      }
      
      private function loadNextUris() : void
      {
         var _loc1_:Object = null;
         var _loc2_:IProtocol = null;
         var _loc4_:uint = 0;
         if(this._uris.length == 0)
         {
            this._uris = null;
            return;
         }
         this._currentlyLoading = Math.min(this._maxParallel,this._uris.length);
         var _loc3_:uint = this._currentlyLoading;
         while(_loc4_ < _loc3_)
         {
            _loc1_ = this._uris.shift();
            if(!checkCache(_loc1_.uri))
            {
               _loc2_ = ProtocolFactory.getProtocol(_loc1_.uri);
               this._loadDictionnary[_loc1_.uri] = _loc2_;
               _loc2_.load(_loc1_.uri,this,hasEventListener(ResourceProgressEvent.PROGRESS),_cache,_loc1_.forcedAdapter,_loc1_.singleFile);
            }
            else
            {
               this.decrementLoads();
            }
            _loc4_++;
         }
      }
      
      private function decrementLoads() : void
      {
         --this._currentlyLoading;
         if(this._currentlyLoading == 0)
         {
            this.loadNextUris();
         }
      }
      
      override public function onLoaded(param1:Uri, param2:uint, param3:*) : void
      {
         super.onLoaded(param1,param2,param3);
         delete this._loadDictionnary[param1];
         this.decrementLoads();
      }
      
      override public function onFailed(param1:Uri, param2:String, param3:uint) : void
      {
         super.onFailed(param1,param2,param3);
         delete this._loadDictionnary[param1];
         this.decrementLoads();
      }
   }
}
