package com.ankamagames.berilia.api
{
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class ApiBinder
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ApiBinder));
      
      private static var _apiClass:Array = new Array();
      
      private static var _apiInstance:Array = new Array();
      
      private static var _apiData:Array = new Array();
      
      private static var _isComplexFctCache:Dictionary = new Dictionary();
       
      
      public function ApiBinder()
      {
         super();
      }
      
      public static function addApi(param1:String, param2:Class) : void
      {
         _apiClass[param1] = param2;
      }
      
      public static function removeApi(param1:String) : void
      {
         delete _apiClass[param1];
      }
      
      public static function reset() : void
      {
         _apiInstance = [];
         _apiData = [];
      }
      
      public static function addApiData(param1:String, param2:*) : void
      {
         _apiData[param1] = param2;
      }
      
      public static function getApiData(param1:String) : *
      {
         return _apiData[param1];
      }
      
      public static function removeApiData(param1:String) : void
      {
         _apiData[param1] = null;
      }
      
      public static function initApi(param1:Object, param2:UiModule, param3:ApplicationDomain = null) : String
      {
         var _loc4_:Object = null;
         var _loc5_:XML = null;
         var _loc6_:* = undefined;
         var _loc7_:String = null;
         var _loc8_:String = null;
         addApiData("module",param2);
         var _loc9_:XML = DescribeTypeCache.typeDescription(param1);
         for each(_loc5_ in _loc9_..variable)
         {
            for each(_loc6_ in _loc5_.metadata)
            {
               if(_loc6_.@name == "Module" && !UiModuleManager.getInstance().getModules()[_loc6_.arg.@value])
               {
                  return _loc6_.arg.@value;
               }
            }
            if(_loc5_.@type.toString().indexOf("d2api::") == 0)
            {
               _loc7_ = (_loc7_ = _loc5_.@type.toString()).substr(7,_loc7_.length - 10);
               _loc4_ = getApiInstance(_loc7_,param2.trusted,param3);
               param2.apiList.push(_loc4_);
               param1[_loc5_.@name] = _loc4_;
            }
            else
            {
               for each(_loc6_ in _loc5_.metadata)
               {
                  if(_loc6_.@name == "Api")
                  {
                     if(_loc6_.arg.@key != "name")
                     {
                        throw new ApiError(param2.id + " module, unknow property \"" + _loc5_..metadata.arg.@key + "\" in Api tag");
                     }
                     _loc4_ = getApiInstance(_loc6_.arg.@value,param2.trusted,param3);
                     param2.apiList.push(_loc4_);
                     param1[_loc5_.@name] = _loc4_;
                  }
                  if(_loc6_.@name == "Module")
                  {
                     if(_loc6_.arg.@key == "name")
                     {
                        _loc8_ = _loc6_.arg.@value;
                        if(!UiModuleManager.getInstance().getModules()[_loc8_])
                        {
                           throw new ApiError("Module " + _loc8_ + " does not exist (in " + param2.id + ")");
                        }
                        if(param2.trusted || _loc8_ == "Ankama_Common" || _loc8_ == "Ankama_ContextMenu" || !UiModuleManager.getInstance().getModules()[_loc8_].trusted)
                        {
                           param1[_loc5_.@name] = new ModuleReference(UiModule(UiModuleManager.getInstance().getModules()[_loc8_]).mainClass,SecureCenter.ACCESS_KEY);
                           continue;
                        }
                        throw new ApiError(param2.id + ", untrusted module cannot acces to trusted modules " + _loc8_);
                     }
                     throw new ApiError(param2.id + " module, unknow property \"" + _loc6_.arg.@key + "\" in Api tag");
                  }
               }
            }
         }
         return null;
      }
      
      private static function getApiInstance(param1:String, param2:Boolean, param3:ApplicationDomain) : Object
      {
         var apiDesc:XML = null;
         var api:Object = null;
         var instancied:Boolean = false;
         var meta:XML = null;
         var tag:String = null;
         var help:String = null;
         var boxing:Boolean = false;
         var method:XML = null;
         var accessor:XML = null;
         var metaData:XML = null;
         var name:String = param1;
         var trusted:Boolean = param2;
         var sharedDefinition:ApplicationDomain = param3;
         var apiRef:* = undefined;
         var metaData2:* = undefined;
         if(_apiInstance[name] && _apiInstance[name][trusted])
         {
            return _apiInstance[name][trusted];
         }
         if(_apiClass[name])
         {
            apiDesc = DescribeTypeCache.typeDescription(_apiClass[name]);
            api = new (sharedDefinition.getDefinition("d2api::" + name + "Api") as Class)();
            apiRef = _apiClass[name];
            instancied = false;
            for each(meta in apiDesc..metadata)
            {
               if(meta.@name == "InstanciedApi")
               {
                  apiRef = new _apiClass[name]();
                  instancied = true;
                  break;
               }
            }
            for each(method in apiDesc..method)
            {
               boxing = true;
               for each(metaData in method.metadata)
               {
                  if(metaData.@name == "Untrusted" || metaData.@name == "Trusted" || metaData.@name == "Deprecated")
                  {
                     tag = metaData.@name;
                     if(metaData.@name == "Deprecated")
                     {
                        help = metaData.arg.(@key == "help").@value;
                     }
                  }
                  if(metaData.@name == "NoBoxing")
                  {
                     boxing = false;
                  }
               }
               if(tag != "Untrusted" && tag != "Trusted" && tag != "Deprecated")
               {
                  throw new ApiError("Missing tag [Untrusted / Trusted] before function \"" + method.@name + "\" in " + _apiClass[name]);
               }
               if(tag == "Untrusted" || (tag == "Trusted" || tag == "Deprecated") && trusted)
               {
                  if(tag == "Deprecated")
                  {
                     api[method.@name] = createDepreciatedMethod(apiRef[method.@name],method.@name,help);
                  }
                  else if(boxing && !isComplexFct(method))
                  {
                     api[method.@name] = SecureCenter.secure(apiRef[method.@name]);
                  }
                  else
                  {
                     api[method.@name] = apiRef[method.@name];
                  }
               }
               else
               {
                  api[method.@name] = GenericApiFunction.getRestrictedFunctionAccess(apiRef[method.@name]);
               }
            }
            for each(accessor in apiDesc..accessor)
            {
               for each(metaData2 in accessor.metadata)
               {
                  if(metaData2.@name == "ApiData")
                  {
                     apiRef[accessor.@name] = _apiData[metaData2.arg.@value];
                     break;
                  }
               }
            }
            if(!instancied)
            {
               if(!_apiInstance[name])
               {
                  _apiInstance[name] = new Array();
               }
               _apiInstance[name][trusted] = api;
            }
            return api;
         }
         _log.error("Api [" + name + "] is not avaible");
         return null;
      }
      
      private static function isComplexFct(param1:XML) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:String = param1.@declaredBy + "_" + param1.@name;
         if(_isComplexFctCache[_loc3_] != null)
         {
            return _isComplexFctCache[_loc3_];
         }
         var _loc4_:Array;
         if((_loc4_ = ["int","uint","Number","Boolean","String","void"]).indexOf(param1.@returnType.toString()) == -1)
         {
            _isComplexFctCache[_loc3_] = false;
            return false;
         }
         for each(_loc2_ in param1..parameter..@type)
         {
            if(_loc4_.indexOf(_loc2_) == -1)
            {
               _isComplexFctCache[_loc3_] = false;
               return false;
            }
         }
         _isComplexFctCache[_loc3_] = true;
         return true;
      }
      
      private static function createDepreciatedMethod(param1:Function, param2:String, param3:String) : Function
      {
         var fct:Function = param1;
         var fctName:String = param2;
         var help:String = param3;
         return function(... rest):*
         {
            var _loc2_:* = new Error();
            if(_loc2_.getStackTrace())
            {
               _log.fatal(fctName + " is a deprecated api function, called at " + _loc2_.getStackTrace().split("at ")[2] + (!!help.length?help + "\n":""));
            }
            else
            {
               _log.fatal(fctName + " is a deprecated api function. No stack trace available");
            }
            return CallWithParameters.callR(fct,rest);
         };
      }
   }
}
