package com.ankamagames.jerakine.resources.protocols.impl
{
   import com.ankamagames.jerakine.enum.OperatingSystem;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.resources.IResourceObserver;
   import com.ankamagames.jerakine.resources.protocols.AbstractFileProtocol;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import flash.filesystem.File;
   import flash.utils.getQualifiedClassName;
   
   public class FileProtocol extends AbstractFileProtocol
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FileProtocol));
      
      public static var localDirectory:String;
       
      
      public function FileProtocol()
      {
         super();
      }
      
      override public function load(param1:Uri, param2:IResourceObserver, param3:Boolean, param4:ICache, param5:Class, param6:Boolean) : void
      {
         if(param6 && (param1.fileType != "swf" || !param1.subPath || param1.subPath.length == 0))
         {
            _singleFileObserver = param2;
            this.loadDirectly(param1,this,param3,param5);
         }
         else if(loadingFile[getUrl(param1)])
         {
            loadingFile[getUrl(param1)].push(param2);
         }
         else
         {
            loadingFile[getUrl(param1)] = [param2];
            this.loadDirectly(param1,this,param3,param5);
         }
      }
      
      override protected function loadDirectly(param1:Uri, param2:IResourceObserver, param3:Boolean, param4:Class) : void
      {
         getAdapter(param1,param4);
         _adapter.loadDirectly(param1,this.extractPath(param1.path),param2,param3);
      }
      
      override protected function extractPath(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:File = null;
         var _loc4_:String = param1;
         if(param1.indexOf("..") != -1)
         {
            if(param1.indexOf("./") == 0)
            {
               _loc2_ = File.applicationDirectory.nativePath + File.separator + param1;
            }
            else if(param1.indexOf("/./") != -1)
            {
               _loc2_ = File.applicationDirectory.nativePath + File.separator + param1.substr(param1.indexOf("/./") + 3);
            }
            else
            {
               _loc2_ = param1;
            }
            _loc3_ = new File(_loc2_);
            param1 = _loc3_.url.replace("file:///","");
         }
         if(param1.indexOf("\\\\") != -1)
         {
            param1 = "file://" + param1.substr(param1.indexOf("\\\\"));
         }
         if(localDirectory != null && param1.indexOf("./") == 0)
         {
            param1 = localDirectory + param1.substr(2);
         }
         if(SystemManager.getSingleton().os != OperatingSystem.WINDOWS && param1.charAt(0) == "/" && param1.charAt(1) != "/")
         {
            param1 = "/" + param1;
         }
         return param1;
      }
      
      override public function onLoaded(param1:Uri, param2:uint, param3:*) : void
      {
         var _loc4_:Array = null;
         var _loc5_:IResourceObserver;
         if(_loc5_ = _singleFileObserver)
         {
            _loc5_.onLoaded(param1,param2,param3);
            _singleFileObserver = null;
         }
         else if(loadingFile[getUrl(param1)] && loadingFile[getUrl(param1)].length)
         {
            _loc4_ = loadingFile[getUrl(param1)];
            delete loadingFile[getUrl(param1)];
            for each(_loc5_ in _loc4_)
            {
               IResourceObserver(_loc5_).onLoaded(param1,param2,param3);
            }
         }
      }
      
      override public function onFailed(param1:Uri, param2:String, param3:uint) : void
      {
         var _loc4_:Array = null;
         _log.warn("onFailed " + param1);
         var _loc5_:IResourceObserver;
         if(_loc5_ = _singleFileObserver)
         {
            _loc5_.onFailed(param1,param2,param3);
            _singleFileObserver = null;
         }
         else if(loadingFile[getUrl(param1)] && loadingFile[getUrl(param1)].length)
         {
            _loc4_ = loadingFile[getUrl(param1)];
            delete loadingFile[getUrl(param1)];
            for each(_loc5_ in _loc4_)
            {
               IResourceObserver(_loc5_).onFailed(param1,param2,param3);
            }
         }
      }
      
      override public function onProgress(param1:Uri, param2:uint, param3:uint) : void
      {
         var _loc4_:Array = null;
         var _loc5_:IResourceObserver;
         if(_loc5_ = _singleFileObserver)
         {
            _loc5_.onProgress(param1,param2,param3);
            _singleFileObserver = null;
         }
         else if(loadingFile[getUrl(param1)] && loadingFile[getUrl(param1)] && loadingFile[getUrl(param1)].length)
         {
            _loc4_ = loadingFile[getUrl(param1)];
            delete loadingFile[getUrl(param1)];
            for each(_loc5_ in _loc4_)
            {
               IResourceObserver(_loc5_).onProgress(param1,param2,param3);
            }
         }
      }
   }
}
