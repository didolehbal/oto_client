package com.ankamagames.dofus.logic.connection.managers
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.approach.managers.PartManagerV2;
   import com.ankamagames.dofus.misc.interClient.InterClientManager;
   import com.ankamagames.dofus.misc.utils.RpcServiceCenter;
   import com.ankamagames.dofus.misc.utils.RpcServiceManager;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import com.ankamagames.performance.Benchmark;
   import com.hurlant.util.Base64;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.system.Capabilities;
   import flash.utils.getQualifiedClassName;
   
   public class StoreUserDataManager
   {
      
      private static const INFOS_EXCLUDED_FROM_MD5CHECK:Array = ["CPUFrequencies","FreeSystemMemory"];
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(StoreUserDataManager));
      
      private static var _self:StoreUserDataManager;
       
      
      private var _so:CustomSharedObject;
      
      private var _postMd5CheckInfos:String;
      
      public function StoreUserDataManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("StoreUserDataManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : StoreUserDataManager
      {
         if(_self == null)
         {
            _self = new StoreUserDataManager();
         }
         return _self;
      }
      
      public function savePlayerData() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:Boolean = false;
         if(AirScanner.isStreamingVersion())
         {
            this.savePlayerStreamingData();
            return;
         }
         var _loc9_:* = "";
         var _loc10_:* = "";
         if(CommandLineArguments.getInstance().hasArgument("sysinfos"))
         {
            _loc1_ = (_loc10_ = Base64.decode(CommandLineArguments.getInstance().getArgument("sysinfos"))).split("\n");
            _loc5_ = new Array();
            for each(_loc2_ in _loc1_)
            {
               _loc2_ = _loc2_.replace("\n","");
               if(!(_loc2_ == "" || _loc2_.search(":") == -1))
               {
                  _loc3_ = (_loc7_ = _loc2_.split(":"))[0];
                  if(!((_loc4_ = _loc7_[1]) == "" || _loc3_ == ""))
                  {
                     switch(_loc3_)
                     {
                        case "RAM_FREE":
                        case "DISK_FREE":
                           continue;
                        case "VIDEO_DRIVER_INSTALLATION_DATE":
                           _loc4_ = _loc4_.substr(0,6);
                     }
                     _loc5_.push({
                        "key":_loc3_,
                        "value":_loc4_
                     });
                  }
               }
            }
            _loc5_.sortOn("key");
            for each(_loc6_ in _loc5_)
            {
               _loc9_ = _loc9_ + (_loc6_.key + ":" + _loc6_.value + ";");
            }
            _loc8_ = true;
         }
         else if(CommandLineArguments.getInstance().hasArgument("updater_version") && CommandLineArguments.getInstance().getArgument("updater_version") == "v2")
         {
            PartManagerV2.getInstance().getSystemConfiguration();
            _loc8_ = true;
            return;
         }
         this.savePlayerAirData(_loc9_,_loc8_);
      }
      
      private function savePlayerAirData(param1:String, param2:Boolean) : void
      {
         param1 = param1 + "envType:air;";
         param1 = param1 + ("isAbo:" + (PlayerManager.getInstance().subscriptionEndDate > 0 || PlayerManager.getInstance().hasRights) + ";");
         param1 = param1 + ("creationAbo:" + PlayerManager.getInstance().accountCreation + ";");
         param1 = param1 + ("flashKey:" + InterClientManager.getInstance().flashKey + ";");
         param1 = param1 + ("screenResolution:" + Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY + ";");
         var _loc3_:String = Capabilities.os.toLowerCase();
         param1 = param1 + "os:";
         if(_loc3_.search("windows") != -1)
         {
            param1 = param1 + "windows";
         }
         else if(_loc3_.search("mac") != -1)
         {
            param1 = param1 + "mac";
         }
         else if(_loc3_.search("linux") != -1)
         {
            param1 = param1 + "linux";
         }
         else
         {
            param1 = param1 + "other";
         }
         param1 = param1 + ";";
         param1 = param1 + ("osVersion:" + SystemManager.getSingleton().version + ";");
         param1 = param1 + "supports:";
         if(Capabilities.supports32BitProcesses && !Capabilities.supports64BitProcesses)
         {
            param1 = param1 + "32Bits";
         }
         else if(Capabilities.supports64BitProcesses)
         {
            param1 = param1 + "64Bits";
         }
         else
         {
            param1 = param1 + "none";
         }
         param1 = param1 + ";";
         param1 = param1 + ("isUsingUpdater:" + param2 + ";");
         this.submitData(param1);
      }
      
      private function savePlayerStreamingData() : void
      {
         var _loc1_:* = "";
         _loc1_ = _loc1_ + "envType:streaming;";
         _loc1_ = _loc1_ + ("isAbo:" + (PlayerManager.getInstance().subscriptionEndDate > 0 || PlayerManager.getInstance().hasRights) + ";");
         _loc1_ = _loc1_ + ("creationAbo:" + PlayerManager.getInstance().accountCreation + ";");
         _loc1_ = _loc1_ + ("screenResolution:" + Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY + ";");
         var _loc2_:String = Capabilities.os.toLowerCase();
         _loc1_ = _loc1_ + "os:";
         if(_loc2_.search("windows") != -1)
         {
            _loc1_ = _loc1_ + "windows";
         }
         else if(_loc2_.search("mac") != -1)
         {
            _loc1_ = _loc1_ + "mac";
         }
         else if(Capabilities.manufacturer.toLowerCase().search("android") != -1)
         {
            _loc1_ = _loc1_ + "android";
         }
         else if(_loc2_.search("linux") != -1)
         {
            _loc1_ = _loc1_ + "linux";
         }
         else if(_loc2_.search("ipad") != -1 || _loc2_.search("iphone") != -1)
         {
            _loc1_ = _loc1_ + "ios";
         }
         else
         {
            _loc1_ = _loc1_ + "other";
         }
         _loc1_ = _loc1_ + ";";
         _loc1_ = _loc1_ + ("osVersion:" + SystemManager.getSingleton().version + ";");
         _loc1_ = _loc1_ + "supports:";
         if(Capabilities.supports32BitProcesses && !Capabilities.supports64BitProcesses)
         {
            _loc1_ = _loc1_ + "32Bits";
         }
         else if(Capabilities.supports64BitProcesses)
         {
            _loc1_ = _loc1_ + "64Bits";
         }
         else
         {
            _loc1_ = _loc1_ + "none";
         }
         _loc1_ = _loc1_ + ";";
         _loc1_ = _loc1_ + ("browser:" + SystemManager.getSingleton().browser + ";");
         _loc1_ = _loc1_ + ("browserVersion:" + SystemManager.getSingleton().browserVersion + ";");
         _loc1_ = _loc1_ + ("fpVersion:" + Capabilities.version + ";");
         _loc1_ = _loc1_ + ("fpManufacturer:" + Capabilities.manufacturer + ";");
         this.submitData(_loc1_);
      }
      
      private function submitData(param1:String) : void
      {
         var _loc2_:RpcServiceManager = null;
         var _loc3_:Object = null;
         var _loc4_:String = MD5.hash(param1);
         param1 = param1 + this._postMd5CheckInfos;
         this._postMd5CheckInfos = "";
         var _loc5_:uint = PlayerManager.getInstance().accountId;
         this._so = CustomSharedObject.getLocal("playerData_" + _loc5_);
         if(this._so.data && this._so.data.hasOwnProperty("version") && this._so.data.md5 == _loc4_ && (this._so.data.version.major >= 2 && this._so.data.version.minor >= 23) && Benchmark.hasCachedResults)
         {
            return;
         }
         this._so.data = new Object();
         this._so.data.md5 = _loc4_;
         this._so.data.version = {
            "major":BuildInfos.BUILD_VERSION.major,
            "minor":BuildInfos.BUILD_VERSION.minor
         };
         this._so.flush();
         _loc2_ = new RpcServiceManager(RpcServiceCenter.getInstance().apiDomain + "/dofus/logger.json","json");
         _loc2_.addEventListener(Event.COMPLETE,this.onDataSavedComplete);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onDataSavedError);
         _loc2_.addEventListener(RpcServiceManager.SERVER_ERROR,this.onDataSavedError);
         _loc3_ = {
            "sUid":MD5.hash(_loc5_.toString()),
            "aValues":{
               "config":param1,
               "benchmark":Benchmark.getResults(true)
            }
         };
         _loc2_.callMethod("Log",_loc3_);
      }
      
      private function onDataSavedComplete(param1:Event) : void
      {
         var _loc2_:RpcServiceManager = param1.currentTarget as RpcServiceManager;
         if(this._so != null)
         {
            _log.debug("User data saved.");
            this._so.flush();
         }
         this.clearService(_loc2_);
      }
      
      private function onDataSavedError(param1:Event) : void
      {
         _log.error("Can\'t send player\'s data to server !");
         var _loc2_:RpcServiceManager = param1.currentTarget as RpcServiceManager;
         this.clearService(_loc2_);
      }
      
      private function clearService(param1:RpcServiceManager) : void
      {
         param1.removeEventListener(Event.COMPLETE,this.onDataSavedComplete);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onDataSavedError);
         param1.removeEventListener(RpcServiceManager.SERVER_ERROR,this.onDataSavedError);
         param1.destroy();
      }
      
      public function onSystemConfiguration(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:Object = null;
         var _loc4_:* = "";
         this._postMd5CheckInfos = "";
         var _loc5_:Array = new Array();
         if(param1)
         {
            for(_loc2_ in param1.config)
            {
               _loc5_.push({
                  "key":_loc2_,
                  "value":param1.config[_loc2_]
               });
            }
         }
         _loc5_.sortOn("key");
         for each(_loc3_ in _loc5_)
         {
            if(INFOS_EXCLUDED_FROM_MD5CHECK.indexOf(_loc3_.key) == -1)
            {
               _loc4_ = _loc4_ + (_loc3_.key + ":" + _loc3_.value + ";");
            }
            else
            {
               this._postMd5CheckInfos = this._postMd5CheckInfos + (_loc3_.key + ":" + _loc3_.value + ";");
            }
         }
         this.savePlayerAirData(_loc4_,true);
      }
   }
}
