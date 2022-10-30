package com.ankamagames.jerakine.script
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.newCache.impl.InfiniteCache;
   import com.ankamagames.jerakine.resources.ResourceObserverWrapper;
   import com.ankamagames.jerakine.resources.ResourceType;
   import com.ankamagames.jerakine.resources.adapters.AdapterFactory;
   import com.ankamagames.jerakine.resources.adapters.IAdapter;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.script.runners.IRunner;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Uri;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class ScriptExec
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ScriptExec));
      
      private static var _prepared:Boolean;
      
      private static var _scriptCache:ICache;
      
      private static var _rld:IResourceLoader;
      
      private static var _runners:Dictionary;
       
      
      public function ScriptExec()
      {
         super();
      }
      
      public static function exec(param1:*, param2:IRunner, param3:Boolean = true, param4:Callback = null, param5:Callback = null) : void
      {
         var _loc6_:Uri = null;
         var _loc7_:IAdapter = null;
         if(param1 is Uri)
         {
            _loc6_ = param1;
         }
         else if(param1 is BinaryScript)
         {
            _loc6_ = new Uri("file://fake_script_url/" + BinaryScript(param1).path);
         }
         if(!_prepared)
         {
            prepare();
         }
         var _loc8_:Object;
         (_loc8_ = new Object()).runner = param2;
         _loc8_.success = param4;
         _loc8_.error = param5;
         var _loc9_:String = _loc6_.toSum();
         if(!_loc6_.loaderContext)
         {
            _loc6_.loaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
         }
         if(_runners[_loc9_])
         {
            (_runners[_loc9_] as Array).push(_loc8_);
         }
         else
         {
            _runners[_loc9_] = [_loc8_];
         }
         if(param1 is Uri)
         {
            _rld.load(_loc6_,!!param3?_scriptCache:null);
         }
         else
         {
            (_loc7_ = AdapterFactory.getAdapter(_loc6_)).loadFromData(_loc6_,BinaryScript(param1).data,new ResourceObserverWrapper(onLoadedWrapper,onFailedWrapper),false);
         }
      }
      
      private static function prepare() : void
      {
         _rld = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         _rld.addEventListener(ResourceLoadedEvent.LOADED,onLoaded);
         _rld.addEventListener(ResourceErrorEvent.ERROR,onError);
         _scriptCache = new InfiniteCache();
         _runners = new Dictionary(true);
         _prepared = true;
      }
      
      private static function onLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc5_:Boolean = false;
         var _loc4_:String = param1.uri.toSum();
         if(param1.resourceType != ResourceType.RESOURCE_DX)
         {
            _log.error("Cannot execute " + param1.uri + "; not a script.");
            _loc5_ = true;
         }
         for each(_loc2_ in _runners[_loc4_])
         {
            if(_loc5_)
            {
               if(_loc2_.error)
               {
                  Callback(_loc2_.error).exec();
               }
            }
            else
            {
               _loc3_ = (_loc2_.runner as IRunner).run(param1.resource as Class);
               if(_loc3_)
               {
                  if(_loc2_.error)
                  {
                     Callback(_loc2_.error).exec();
                  }
               }
               else if(_loc2_.success)
               {
                  Callback(_loc2_.success).exec();
               }
            }
         }
         delete _runners[_loc4_];
      }
      
      private static function onError(param1:ResourceErrorEvent) : void
      {
         var _loc2_:Object = null;
         _log.error("Cannot execute " + param1.uri + "; script not found (" + param1.errorMsg + ").");
         var _loc3_:String = param1.uri.toSum();
         for each(_loc2_ in _runners[_loc3_])
         {
            if(_loc2_.error)
            {
               Callback(_loc2_.error).exec();
            }
         }
         delete _runners[_loc3_];
      }
      
      private static function onLoadedWrapper(param1:Uri, param2:uint, param3:*) : void
      {
         var _loc4_:ResourceLoadedEvent;
         (_loc4_ = new ResourceLoadedEvent(ResourceLoadedEvent.LOADED)).uri = param1;
         _loc4_.resource = param3;
         _loc4_.resourceType = param2;
         onLoaded(_loc4_);
      }
      
      private static function onFailedWrapper(param1:Uri, param2:String, param3:uint) : void
      {
         var _loc4_:ResourceErrorEvent;
         (_loc4_ = new ResourceErrorEvent(ResourceErrorEvent.ERROR)).uri = param1;
         _loc4_.errorMsg = param2;
         _loc4_.errorCode = param3;
         onError(_loc4_);
      }
   }
}
