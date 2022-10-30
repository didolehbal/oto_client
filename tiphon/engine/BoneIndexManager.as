package com.ankamagames.tiphon.engine
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.tiphon.TiphonConstants;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class BoneIndexManager extends EventDispatcher
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(BoneIndexManager));
      
      private static var _self:BoneIndexManager;
       
      
      private var _loader:IResourceLoader;
      
      private var _index:Dictionary;
      
      private var _transitions:Dictionary;
      
      private var _animNameModifier:Function;
      
      public function BoneIndexManager()
      {
         this._index = new Dictionary();
         this._transitions = new Dictionary();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : BoneIndexManager
      {
         if(!_self)
         {
            _self = new BoneIndexManager();
         }
         return _self;
      }
      
      public function init(param1:String) : void
      {
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onXmlLoaded);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onXmlFailed);
         this._loader.load(new Uri(param1));
      }
      
      public function setAnimNameModifier(param1:Function) : void
      {
         this._animNameModifier = param1;
      }
      
      public function addTransition(param1:uint, param2:String, param3:String, param4:uint, param5:String) : void
      {
         if(!this._transitions[param1])
         {
            this._transitions[param1] = new Dictionary();
         }
         this._transitions[param1][param2 + "_" + param3 + "_" + param4] = param5;
      }
      
      public function hasTransition(param1:uint, param2:String, param3:String, param4:uint) : Boolean
      {
         if(this._animNameModifier != null)
         {
            param2 = this._animNameModifier(param1,param2);
            param3 = this._animNameModifier(param1,param3);
         }
         return this._transitions[param1] && (this._transitions[param1][param2 + "_" + param3 + "_" + param4] != null || this._transitions[param1][param2 + "_" + param3 + "_" + TiphonUtility.getFlipDirection(param4)] != null);
      }
      
      public function getTransition(param1:uint, param2:String, param3:String, param4:uint) : String
      {
         if(this._animNameModifier != null)
         {
            param2 = this._animNameModifier(param1,param2);
            param3 = this._animNameModifier(param1,param3);
         }
         if(!this._transitions[param1])
         {
            return null;
         }
         if(this._transitions[param1][param2 + "_" + param3 + "_" + param4])
         {
            return this._transitions[param1][param2 + "_" + param3 + "_" + param4];
         }
         return this._transitions[param1][param2 + "_" + param3 + "_" + TiphonUtility.getFlipDirection(param4)];
      }
      
      public function getBoneFile(param1:uint, param2:String) : Uri
      {
         if(!this._index[param1] || !this._index[param1][param2])
         {
            return new Uri(TiphonConstants.SWF_SKULL_PATH + param1 + ".swl");
         }
         return new Uri(TiphonConstants.SWF_SKULL_PATH + this._index[param1][param2]);
      }
      
      public function hasAnim(param1:uint, param2:String, param3:int) : Boolean
      {
         return this._index[param1] && this._index[param1][param2];
      }
      
      public function hasCustomBone(param1:uint) : Boolean
      {
         return this._index[param1];
      }
      
      public function getAllCustomAnimations(param1:int) : Array
      {
         var _loc2_:* = null;
         var _loc3_:Dictionary = this._index[param1];
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:Array = new Array();
         for(_loc2_ in _loc3_)
         {
            _loc4_.push(_loc2_);
         }
         return _loc4_;
      }
      
      private function onXmlLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:XML = null;
         var _loc3_:Uri = null;
         this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onXmlLoaded);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onSubXmlLoaded);
         this._loader.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.onAllSubXmlLoaded);
         var _loc4_:String = FileUtils.getFilePath(param1.uri.uri);
         var _loc5_:XML = param1.resource as XML;
         var _loc6_:Array = new Array();
         for each(_loc2_ in _loc5_..group)
         {
            _loc3_ = new Uri(_loc4_ + "/" + _loc2_.@id.toString() + ".xml");
            _loc3_.tag = parseInt(_loc2_.@id.toString());
            _loc6_.push(_loc3_);
         }
         this._loader.load(_loc6_);
      }
      
      private function onSubXmlLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:Array = null;
         var _loc6_:XML = param1.resource as XML;
         for each(_loc3_ in _loc6_..file)
         {
            for each(_loc4_ in _loc3_..resource)
            {
               _loc2_ = _loc4_.@name.toString();
               if(_loc2_.indexOf("Anim") != -1)
               {
                  if(!this._index[param1.uri.tag])
                  {
                     this._index[param1.uri.tag] = new Dictionary();
                  }
                  this._index[param1.uri.tag][_loc2_] = _loc3_.@name.toString();
                  if(_loc2_.indexOf("_to_") != -1)
                  {
                     _loc5_ = _loc2_.split("_");
                     _self.addTransition(param1.uri.tag,_loc5_[0],_loc5_[2],parseInt(_loc5_[3]),_loc5_[0] + "_to_" + _loc5_[2]);
                  }
               }
            }
         }
      }
      
      private function onXmlFailed(param1:ResourceErrorEvent) : void
      {
         _log.error("Impossible de charger ou parser le fichier d\'index d\'animation : " + param1.uri);
      }
      
      private function onAllSubXmlLoaded(param1:ResourceLoaderProgressEvent) : void
      {
         this._loader = null;
         dispatchEvent(new Event(Event.INIT));
      }
   }
}
