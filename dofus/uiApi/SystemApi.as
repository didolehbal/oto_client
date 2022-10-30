package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.managers.DataGroundMapManager;
   import com.ankamagames.berilia.components.ComponentInternalAccessor;
   import com.ankamagames.berilia.components.WebBrowser;
   import com.ankamagames.berilia.frames.ShortcutsFrame;
   import com.ankamagames.berilia.frames.UIInteractionFrame;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.listener.GenericListener;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.berilia.utils.errors.UntrustedApiCallError;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.updater.UpdaterConnexionHandler;
   import com.ankamagames.dofus.logic.common.actions.ChangeWorldInteractionAction;
   import com.ankamagames.dofus.logic.common.frames.MiscFrame;
   import com.ankamagames.dofus.logic.common.managers.AccountManager;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.frames.AuthentificationFrame;
   import com.ankamagames.dofus.logic.connection.frames.InitializationFrame;
   import com.ankamagames.dofus.logic.connection.frames.ServerSelectionFrame;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.connection.managers.GuestModeManager;
   import com.ankamagames.dofus.logic.game.approach.frames.GameServerApproachFrame;
   import com.ankamagames.dofus.logic.game.approach.managers.PartManager;
   import com.ankamagames.dofus.logic.game.common.frames.CameraControlFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ExternalGameFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightPreparationFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.MonstersInfoFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.misc.interClient.InterClientManager;
   import com.ankamagames.dofus.misc.lists.ApiActionList;
   import com.ankamagames.dofus.misc.utils.DofusApiAction;
   import com.ankamagames.dofus.misc.utils.StatisticReportingManager;
   import com.ankamagames.dofus.misc.utils.frames.LuaScriptRecorderFrame;
   import com.ankamagames.dofus.modules.utils.ModuleInstallerFrame;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.enums.PartStateEnum;
   import com.ankamagames.dofus.network.messages.authorized.AdminQuietCommandMessage;
   import com.ankamagames.dofus.network.types.updater.ContentPart;
   import com.ankamagames.dofus.types.data.ServerCommand;
   import com.ankamagames.jerakine.console.ConsolesManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.handlers.HumanInputHandler;
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.interfaces.IModuleUtil;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.ModuleLogger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.managers.PerformanceManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.messages.Worker;
   import com.ankamagames.jerakine.replay.LogFrame;
   import com.ankamagames.jerakine.replay.LogTypeEnum;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.types.DynamicSecureObject;
   import com.ankamagames.jerakine.types.Version;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import com.ankamagames.jerakine.utils.crypto.AdvancedMd5;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.FrameIdManager;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import com.ankamagames.jerakine.utils.misc.Chrono;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   [InstanciedApi]
   public class SystemApi implements IApi
   {
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      private static var _actionCountRef:Dictionary = new Dictionary();
      
      private static var _actionTsRef:Dictionary = new Dictionary();
      
      private static var _wordInteractionEnable:Boolean = true;
      
      private static var _lastFrameId:uint;
       
      
      private var _module:UiModule;
      
      private var _currentUi:UiRootContainer;
      
      protected var _log:Logger;
      
      private var _characterDataStore:DataStoreType;
      
      private var _accountDataStore:DataStoreType;
      
      private var _moduleActionDataStore:DataStoreType;
      
      private var _hooks:Dictionary;
      
      private var _listener:Dictionary;
      
      private var _listenerCount:uint;
      
      private var _running:Boolean;
      
      public function SystemApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(SystemApi));
         this._hooks = new Dictionary();
         this._listener = new Dictionary();
         super();
         MEMORY_LOG[this] = 1;
      }
      
      public static function get wordInteractionEnable() : Boolean
      {
         return _wordInteractionEnable;
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [ApiData(name="currentUi")]
      public function set currentUi(param1:UiRootContainer) : void
      {
         this._currentUi = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         var _loc1_:* = undefined;
         EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
         this._listener = null;
         this._module = null;
         this._currentUi = null;
         this._characterDataStore = null;
         this._accountDataStore = null;
         for(_loc1_ in this._hooks)
         {
            this.removeHook(_loc1_);
         }
         this._hooks = new Dictionary();
      }
      
      [Untrusted]
      public function isInGame() : Boolean
      {
         var _loc1_:Boolean = Kernel.getWorker().contains(AuthentificationFrame);
         var _loc2_:Boolean = Kernel.getWorker().contains(InitializationFrame);
         var _loc3_:Boolean = Kernel.getWorker().contains(GameServerApproachFrame);
         var _loc4_:Boolean = Kernel.getWorker().contains(ServerSelectionFrame);
         var _loc5_:Worker = Kernel.getWorker();
         return !(_loc1_ || _loc2_ || _loc3_ || _loc4_);
      }
      
      [Trusted]
      public function isLoggingWithTicket() : Boolean
      {
         return AuthentificationManager.getInstance().isLoggingWithTicket;
      }
      
      [Untrusted]
      public function addHook(param1:Class, param2:Function) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = getQualifiedClassName(param1).split("::");
         _loc3_ = _loc4_[_loc4_.length - 1];
         var _loc5_:Hook;
         if(!(_loc5_ = Hook.getHookByName(_loc3_)))
         {
            throw new BeriliaError("Hook [" + _loc3_ + "] does not exists.");
         }
         if(_loc5_.trusted && !this._module.trusted)
         {
            throw new UntrustedApiCallError("Hook " + _loc3_ + " cannot be listen from an untrusted module");
         }
         var _loc6_:GenericListener = new GenericListener(_loc3_,!!this._currentUi?this._currentUi.name:"__module_" + this._module.id,param2,0,!!this._currentUi?uint(GenericListener.LISTENER_TYPE_UI):uint(GenericListener.LISTENER_TYPE_MODULE));
         this._hooks[param1] = _loc6_;
         KernelEventsManager.getInstance().registerEvent(_loc6_);
      }
      
      [Untrusted]
      public function removeHook(param1:Class) : void
      {
         if(param1)
         {
            KernelEventsManager.getInstance().removeEventListener(this._hooks[param1]);
            delete this._hooks[param1];
         }
      }
      
      [Untrusted]
      public function createHook(param1:String) : void
      {
         new Hook(param1,false,false);
      }
      
      [NoBoxing]
      [Untrusted]
      public function dispatchHook(param1:Class, ... rest) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = getQualifiedClassName(param1).split("::");
         _loc3_ = _loc4_[_loc4_.length - 1];
         var _loc5_:Hook;
         if(!(_loc5_ = Hook.getHookByName(_loc3_)))
         {
            throw new ApiError("Hook [" + _loc3_ + "] does not exist");
         }
         if(_loc5_.nativeHook)
         {
            throw new UntrustedApiCallError("Hook " + _loc3_ + " is a native hook. Native hooks cannot be dispatch by module");
         }
         CallWithParameters.call(KernelEventsManager.getInstance().processCallback,new Array(_loc5_).concat(rest));
      }
      
      [Untrusted]
      public function sendAction(param1:Object) : uint
      {
         var _loc2_:DofusApiAction = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         if(param1.hasOwnProperty("parameters"))
         {
            _loc3_ = getQualifiedClassName(param1).split("::");
            _loc2_ = DofusApiAction.getApiActionByName(_loc3_[_loc3_.length - 1]);
            if(!_loc2_)
            {
               throw new ApiError("Action [" + param1 + "] does not exist");
            }
            if(_loc2_.trusted && !this._module.trusted)
            {
               throw new UntrustedApiCallError("Action " + param1 + " cannot be launch from an untrusted module");
            }
            if(!this._module.trusted && _loc2_.needInteraction && !(UIInteractionFrame(Kernel.getWorker().getFrame(UIInteractionFrame)).isProcessingDirectInteraction || ShortcutsFrame(Kernel.getWorker().getFrame(ShortcutsFrame)).isProcessingDirectInteraction))
            {
               return 0;
            }
            if(!this._module.trusted && _loc2_.maxUsePerFrame)
            {
               if(_lastFrameId != FrameIdManager.frameId)
               {
                  _actionCountRef = new Dictionary();
                  _lastFrameId = FrameIdManager.frameId;
               }
               if(_actionCountRef[_loc2_] != undefined)
               {
                  if(_actionCountRef[_loc2_] == 0)
                  {
                     return 0;
                  }
                  --_actionCountRef[_loc2_];
               }
               else
               {
                  _actionCountRef[_loc2_] = _loc2_.maxUsePerFrame - 1;
               }
            }
            if(!this._module.trusted && _loc2_.minimalUseInterval)
            {
               _loc4_ = getTimer() - _actionTsRef[_loc2_];
               if(_actionTsRef[_loc2_] && _loc4_ <= _loc2_.minimalUseInterval)
               {
                  return 0;
               }
               _actionTsRef[_loc2_] = getTimer();
            }
            var _loc7_:Action = CallWithParameters.callR(_loc2_.actionClass["create"],SecureCenter.unsecureContent(param1.parameters));
            if(_loc2_.needConfirmation)
            {
               if(!this._moduleActionDataStore)
               {
                  this.initModuleActionDataStore();
               }
               _loc5_ = StoreDataManager.getInstance().getSetData(this._moduleActionDataStore,"needConfirm",new Array());
               if(!this._module.trusted && _loc5_[_loc2_.name] !== false)
               {
                  _loc6_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
                  if(_loc7_ is ApiActionList.DeleteObject.actionClass)
                  {
                     _loc6_.openPopup(I18n.getUiText("ui.popup.warning"),I18n.getUiText("ui.module.action.confirm",[this._module.name,_loc2_.description]),[I18n.getUiText("ui.common.ok"),I18n.getUiText("ui.common.no")],[this.onActionConfirm(_loc7_,_loc2_)],this.onActionConfirm(_loc7_,_loc2_));
                  }
                  else
                  {
                     _loc6_.openCheckboxPopup(I18n.getUiText("ui.popup.warning"),I18n.getUiText("ui.module.action.confirm",[this._module.name,_loc2_.description]),this.onActionConfirm(_loc7_,_loc2_),null,I18n.getUiText("ui.common.rememberMyChoice"));
                  }
                  return 2;
               }
            }
            LogFrame.log(LogTypeEnum.ACTION,_loc7_);
            ModuleLogger.log(_loc7_);
            Kernel.getWorker().process(_loc7_);
            return 1;
         }
         throw new ApiError("Action [" + param1 + "] don\'t implement IAction");
      }
      
      private function onActionConfirm(param1:Action, param2:DofusApiAction) : Function
      {
         var actionToSend:Action = param1;
         var apiAction:DofusApiAction = param2;
         return function(... rest):void
         {
            var _loc2_:* = undefined;
            if(rest.length && rest[0])
            {
               _loc2_ = StoreDataManager.getInstance().getSetData(_moduleActionDataStore,"needConfirm",new Array());
               _loc2_[apiAction.name] = !rest[0];
               StoreDataManager.getInstance().setData(_moduleActionDataStore,"needConfirm",_loc2_);
            }
            LogFrame.log(LogTypeEnum.ACTION,actionToSend);
            ModuleLogger.log(actionToSend);
            Kernel.getWorker().process(actionToSend);
         };
      }
      
      [Untrusted]
      public function log(param1:uint, param2:*) : void
      {
         var _loc3_:String = !!this._currentUi?this._currentUi.uiModule.name + "/" + this._currentUi.uiClass:"?";
         this._log.log(param1,"[" + _loc3_ + "] " + param2);
         if(this._module && !this._module.trusted || BuildInfos.BUILD_TYPE >= BuildTypeEnum.TESTING)
         {
            ModuleLogger.log("[" + _loc3_ + "] " + param2,param1);
         }
      }
      
      [Untrusted]
      public function getClientId() : uint
      {
         return InterClientManager.getInstance().clientId;
      }
      
      [Untrusted]
      public function getNumberOfClients() : uint
      {
         return InterClientManager.getInstance().numClients;
      }
      
      [Trusted]
      public function setConfigEntry(param1:String, param2:*) : void
      {
         XmlConfig.getInstance().setEntry(param1,param2);
      }
      
      [Untrusted]
      public function getConfigEntry(param1:String) : *
      {
         return XmlConfig.getInstance().getEntry(param1);
      }
      
      [Trusted]
      public function getEnum(param1:String) : Class
      {
         return getDefinitionByName(param1) as Class;
      }
      
      [Trusted]
      public function isEventMode() : Boolean
      {
         return Constants.EVENT_MODE;
      }
      
      [Trusted]
      public function isCharacterCreationAllowed() : Boolean
      {
         return Constants.CHARACTER_CREATION_ALLOWED;
      }
      
      [Trusted]
      public function getConfigKey(param1:String) : *
      {
         return XmlConfig.getInstance().getEntry("config." + param1);
      }
      
      [Trusted]
      public function goToUrl(param1:String) : void
      {
         navigateToURL(new URLRequest(param1));
      }
      
      [Trusted]
      public function getPlayerManager() : PlayerManager
      {
         return PlayerManager.getInstance();
      }
      
      [Trusted]
      public function getPort() : uint
      {
         var _loc1_:DataStoreType = new DataStoreType("Dofus_ComputerOptions",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
         return StoreDataManager.getInstance().getData(_loc1_,"connectionPortDefault");
      }
      
      [Trusted]
      public function setPort(param1:uint) : Boolean
      {
         var _loc2_:DataStoreType = new DataStoreType("Dofus_ComputerOptions",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
         return StoreDataManager.getInstance().setData(_loc2_,"connectionPortDefault",param1);
      }
      
      [Untrusted]
      public function setData(param1:String, param2:*, param3:Boolean = false) : Boolean
      {
         var _loc4_:DataStoreType = null;
         if(param3)
         {
            if(!this._accountDataStore)
            {
               this.initAccountDataStore();
            }
            _loc4_ = this._accountDataStore;
         }
         else
         {
            if(!this._characterDataStore)
            {
               this.initCharacterDataStore();
            }
            _loc4_ = this._characterDataStore;
         }
         return StoreDataManager.getInstance().setData(_loc4_,param1,param2);
      }
      
      [Untrusted]
      public function getSetData(param1:String, param2:*, param3:Boolean = false) : *
      {
         var _loc4_:DataStoreType = null;
         if(param3)
         {
            if(!this._accountDataStore)
            {
               this.initAccountDataStore();
            }
            _loc4_ = this._accountDataStore;
         }
         else
         {
            if(!this._characterDataStore)
            {
               this.initCharacterDataStore();
            }
            _loc4_ = this._characterDataStore;
         }
         return StoreDataManager.getInstance().getSetData(_loc4_,param1,param2);
      }
      
      [Untrusted]
      public function setQualityIsEnable() : Boolean
      {
         return StageShareManager.setQualityIsEnable;
      }
      
      [Untrusted]
      public function hasAir() : Boolean
      {
         return AirScanner.hasAir();
      }
      
      [Untrusted]
      public function getAirVersion() : uint
      {
         return Capabilities.version.indexOf(" 10,0") != -1?uint(1):uint(2);
      }
      
      [Untrusted]
      public function isAirVersionAvailable(param1:uint) : Boolean
      {
         return this.setQualityIsEnable();
      }
      
      [Untrusted]
      public function setAirVersion(param1:uint) : Boolean
      {
         var fs:FileStream = null;
         var fs2:FileStream = null;
         var version:uint = param1;
         if(!this.isAirVersionAvailable(version))
         {
            return false;
         }
         var file_air1:File = new File(File.applicationDirectory.nativePath + File.separator + "useOldAir");
         var file_air2:File = new File(File.applicationDirectory.nativePath + File.separator + "useNewAir");
         if(version == 1)
         {
            try
            {
               if(file_air2.exists)
               {
                  file_air2.deleteFile();
               }
               fs = new FileStream();
               fs.open(file_air1,FileMode.WRITE);
               fs.close();
            }
            catch(e:Error)
            {
               return false;
            }
         }
         else
         {
            try
            {
               if(file_air1.exists)
               {
                  file_air1.deleteFile();
               }
               fs2 = new FileStream();
               fs2.open(file_air2,FileMode.WRITE);
               fs2.close();
            }
            catch(e:Error)
            {
               return false;
            }
         }
         return true;
      }
      
      [Untrusted]
      public function getOs() : String
      {
         return SystemManager.getSingleton().os;
      }
      
      [Untrusted]
      public function getOsVersion() : String
      {
         return SystemManager.getSingleton().version;
      }
      
      [Untrusted]
      public function getCpu() : String
      {
         return SystemManager.getSingleton().cpu;
      }
      
      [Untrusted]
      public function getBrowser() : String
      {
         return SystemManager.getSingleton().browser;
      }
      
      [NoBoxing]
      [Untrusted]
      public function getData(param1:String, param2:Boolean = false) : *
      {
         var _loc3_:DataStoreType = null;
         if(param2)
         {
            if(!this._accountDataStore)
            {
               this.initAccountDataStore();
            }
            _loc3_ = this._accountDataStore;
         }
         else
         {
            if(!this._characterDataStore)
            {
               this.initCharacterDataStore();
            }
            _loc3_ = this._characterDataStore;
         }
         var _loc4_:* = StoreDataManager.getInstance().getData(_loc3_,param1);
         switch(true)
         {
            case _loc4_ is IModuleUtil:
            case _loc4_ is IDataCenter:
               return SecureCenter.secure(_loc4_);
            default:
               return _loc4_;
         }
      }
      
      [Untrusted]
      public function getOption(param1:String, param2:String) : *
      {
         return OptionManager.getOptionManager(param2)[param1];
      }
      
      [Untrusted]
      public function callbackHook(param1:Hook, ... rest) : void
      {
         KernelEventsManager.getInstance().processCallback(param1,rest);
      }
      
      [Untrusted]
      public function showWorld(param1:Boolean) : void
      {
         Atouin.getInstance().showWorld(param1);
      }
      
      [Untrusted]
      public function worldIsVisible() : Boolean
      {
         return Atouin.getInstance().worldIsVisible;
      }
      
      [Untrusted]
      public function getServerStatus() : uint
      {
         var _loc1_:MiscFrame = Kernel.getWorker().getFrame(MiscFrame) as MiscFrame;
         return _loc1_.getServerStatus();
      }
      
      [Trusted]
      [Deprecated(help="debugApi")]
      public function getConsoleAutoCompletion(param1:String, param2:Boolean) : String
      {
         if(param2)
         {
            return ServerCommand.autoComplete(param1);
         }
         return ConsolesManager.getConsole("debug").autoComplete(param1);
      }
      
      [Trusted]
      [Deprecated(help="debugApi")]
      public function getAutoCompletePossibilities(param1:String, param2:Boolean = false) : Array
      {
         if(param2)
         {
            return ServerCommand.getAutoCompletePossibilities(param1).sort();
         }
         return ConsolesManager.getConsole("debug").getAutoCompletePossibilities(param1).sort();
      }
      
      [Trusted]
      [Deprecated(help="debugApi")]
      public function getAutoCompletePossibilitiesOnParam(param1:String, param2:Boolean = false, param3:uint = 0, param4:Array = null) : Array
      {
         return ConsolesManager.getConsole("debug").getAutoCompletePossibilitiesOnParam(param1,param3,param4).sort();
      }
      
      [Trusted]
      [Deprecated(help="debugApi")]
      public function getCmdHelp(param1:String, param2:Boolean = false) : String
      {
         if(param2)
         {
            return ServerCommand.getHelp(param1);
         }
         return ConsolesManager.getConsole("debug").getCmdHelp(param1);
      }
      
      [Untrusted]
      public function startChrono(param1:String) : void
      {
         Chrono.start(param1);
      }
      
      [Untrusted]
      public function stopChrono() : void
      {
         Chrono.stop();
      }
      
      [Trusted]
      public function hasAdminCommand(param1:String) : Boolean
      {
         return ServerCommand.hasCommand(param1);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Function = null;
         for each(_loc2_ in this._listener)
         {
            if(_loc2_ != null)
            {
               _loc2_();
            }
         }
      }
      
      [Trusted]
      [NoBoxing]
      public function addEventListener(param1:Function, param2:String, param3:uint = 25) : void
      {
         ++this._listenerCount;
         this._listener[param2] = param1;
         if(!this._running)
         {
            EnterFrameDispatcher.addEventListener(this.onEnterFrame,this._module.id + ".enterframe" + Math.random(),param3);
            this._running = true;
         }
      }
      
      [Trusted]
      [NoBoxing]
      public function removeEventListener(param1:Function) : void
      {
         var _loc2_:* = null;
         var _loc3_:Array = [];
         for(_loc2_ in this._listener)
         {
            if(param1 == this._listener[_loc2_])
            {
               --this._listenerCount;
               _loc3_.push(_loc2_);
            }
         }
         for each(_loc2_ in _loc3_)
         {
            delete this._listener[_loc2_];
         }
         if(!this._listenerCount)
         {
            this._running = false;
            EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
         }
      }
      
      [Trusted]
      public function disableWorldInteraction(param1:Boolean = true) : void
      {
         _wordInteractionEnable = false;
         TooltipManager.hideAll();
         Kernel.getWorker().process(ChangeWorldInteractionAction.create(false,param1));
      }
      
      [Trusted]
      public function enableWorldInteraction() : void
      {
         _wordInteractionEnable = true;
         Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
      }
      
      [Trusted]
      public function setFrameRate(param1:uint) : void
      {
         StageShareManager.stage.frameRate = param1;
      }
      
      [Trusted]
      public function hasWorldInteraction() : Boolean
      {
         var _loc1_:RoleplayContextFrame = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
         if(!_loc1_)
         {
            return false;
         }
         return _loc1_.hasWorldInteraction;
      }
      
      [Trusted]
      public function hasRight() : Boolean
      {
         return PlayerManager.getInstance().hasRights;
      }
      
      [Untrusted]
      public function isFightContext() : Boolean
      {
         return Kernel.getWorker().contains(FightContextFrame);
      }
      
      [Untrusted]
      public function getEntityLookFromString(param1:String) : TiphonEntityLook
      {
         return TiphonEntityLook.fromString(param1);
      }
      
      [Untrusted]
      public function getCurrentVersion() : Version
      {
         return BuildInfos.BUILD_VERSION;
      }
      
      [Untrusted]
      public function getBuildType() : uint
      {
         return BuildInfos.BUILD_TYPE;
      }
      
      [Untrusted]
      public function getCurrentLanguage() : String
      {
         return XmlConfig.getInstance().getEntry("config.lang.current");
      }
      
      [Trusted]
      public function clearCache(param1:Boolean = false) : void
      {
         Dofus.getInstance().clearCache(param1,true);
      }
      
      [Trusted]
      public function reset() : void
      {
         Dofus.getInstance().reboot();
      }
      
      [Untrusted]
      public function getCurrentServer() : Server
      {
         return PlayerManager.getInstance().server;
      }
      
      [Trusted]
      public function getGroundCacheSize() : Number
      {
         return DataGroundMapManager.getCurrentDiskUsed();
      }
      
      [Trusted]
      public function clearGroundCache() : void
      {
         DataGroundMapManager.clearGroundCache();
      }
      
      [Trusted]
      public function zoom(param1:Number) : void
      {
         var _loc2_:CameraControlFrame = Kernel.getWorker().getFrame(CameraControlFrame) as CameraControlFrame;
         if(_loc2_.dragging)
         {
            return;
         }
         this.luaZoom(param1);
         Atouin.getInstance().zoom(param1);
      }
      
      [Trusted]
      public function getCurrentZoom() : Number
      {
         return Atouin.getInstance().currentZoom;
      }
      
      [Trusted]
      public function goToThirdPartyLogin(param1:WebBrowser) : void
      {
         var _loc2_:URLRequest = null;
         if(BuildInfos.BUILD_TYPE == BuildTypeEnum.DEBUG)
         {
            _loc2_ = new URLRequest("http://127.0.0.1/login.php");
         }
         else
         {
            _loc2_ = new URLRequest(I18n.getUiText("ui.link.thirdparty.login"));
         }
         ComponentInternalAccessor.access(param1,"load")(_loc2_);
      }
      
      [Trusted]
      public function goToOgrinePortal(param1:WebBrowser) : void
      {
         var _loc2_:URLRequest = null;
         if(BuildInfos.BUILD_TYPE == BuildTypeEnum.RELEASE || BuildInfos.BUILD_TYPE == BuildTypeEnum.BETA)
         {
            _loc2_ = new URLRequest(I18n.getUiText("ui.link.ogrinePortal"));
         }
         else if(BuildInfos.BUILD_TYPE == BuildTypeEnum.DEBUG || BuildInfos.BUILD_TYPE == BuildTypeEnum.INTERNAL)
         {
            _loc2_ = new URLRequest(I18n.getUiText("ui.link.ogrinePortalTest"));
         }
         else
         {
            _loc2_ = new URLRequest(I18n.getUiText("ui.link.ogrinePortalLocal"));
         }
         _loc2_.data = this.getAnkamaPortalUrlParams();
         _loc2_.method = URLRequestMethod.POST;
         ComponentInternalAccessor.access(param1,"load")(_loc2_);
      }
      
      [Trusted]
      public function goToWebAuthentification(param1:WebBrowser, param2:String) : String
      {
         var _loc3_:URLRequest = null;
         if(BuildInfos.BUILD_TYPE == BuildTypeEnum.RELEASE || BuildInfos.BUILD_TYPE == BuildTypeEnum.BETA)
         {
            _loc3_ = new URLRequest(I18n.getUiText("ui.link.ankamaOauth",[param2]));
         }
         else if(BuildInfos.BUILD_TYPE == BuildTypeEnum.DEBUG || BuildInfos.BUILD_TYPE == BuildTypeEnum.INTERNAL)
         {
            _loc3_ = new URLRequest(I18n.getUiText("ui.link.ankamaOauthTest",[param2]));
         }
         else
         {
            _loc3_ = new URLRequest(I18n.getUiText("ui.link.ankamaOauthLocal",[param2]));
         }
         if(!this.isStreaming())
         {
            ComponentInternalAccessor.access(param1,"load")(_loc3_);
         }
         else if(ExternalInterface.available)
         {
            ExternalInterface.call("requestOauth",param2);
         }
         return _loc3_.url.substring(0,_loc3_.url.indexOf(param2)) + param2;
      }
      
      [Trusted]
      public function openWebModalOgrinePortal(param1:Function = null, param2:Function = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(BuildInfos.BUILD_TYPE == BuildTypeEnum.RELEASE || BuildInfos.BUILD_TYPE == BuildTypeEnum.BETA)
         {
            _loc3_ = I18n.getUiText("ui.link.ogrinePortal");
         }
         else if(BuildInfos.BUILD_TYPE == BuildTypeEnum.DEBUG || BuildInfos.BUILD_TYPE == BuildTypeEnum.INTERNAL)
         {
            _loc3_ = I18n.getUiText("ui.link.ogrinePortalTest");
         }
         else
         {
            _loc3_ = I18n.getUiText("ui.link.ogrinePortalLocal");
         }
         var _loc5_:Object;
         (_loc5_ = new Object()).username = AuthentificationManager.getInstance().username;
         _loc5_.passkey = AuthentificationManager.getInstance().ankamaPortalKey;
         _loc5_.server = PlayerManager.getInstance().server.id;
         _loc5_.serverName = PlayerManager.getInstance().server.name;
         _loc5_.language = XmlConfig.getInstance().getEntry("config.lang.current");
         _loc5_.character = PlayedCharacterManager.getInstance().id;
         _loc5_.theme = OptionManager.getOptionManager("dofus").switchUiSkin;
         if(ExternalInterface.available)
         {
            if(param1 != null)
            {
               ExternalInterface.addCallback("goToShopArticle",param1);
            }
            if(param2 != null)
            {
               ExternalInterface.addCallback("openUnlockSecureModeUi",param2);
            }
            ExternalInterface.call("openModal",_loc3_,_loc5_);
            _loc4_ = String(<![CDATA[
					var streamingModalDiv = document.getElementsByClassName("ak-playstreaming-modal")[0];
					streamingModalDiv.style.padding = "0px";
					
					var popupDiv = streamingModalDiv.parentNode;
					popupDiv.style.background = "none";
					popupDiv.style.top = "250px";
					popupDiv.style.left = document.getElementById("streaming_swf").getBoundingClientRect().left + 86 + "px";
					popupDiv.style.width = "680px";
					if (popupDiv.children && popupDiv.children.length > 1) {
						popupDiv.removeChild(popupDiv.children[0]);
					}
					
					var popupIFrame = document.getElementById("ak-openmodal").getElementsByTagName("iframe")[0];
					popupIFrame.setAttribute("height", "470");
					popupIFrame.setAttribute("frameborder", "0");
					
					document.getElementsByClassName("ui-widget-overlay ui-front")[0].style.visibility = "hidden";
				]]>);
            ExternalInterface.call("eval",_loc4_);
         }
      }
      
      [Trusted]
      public function goToAnkaBoxPortal(param1:WebBrowser) : void
      {
         var _loc2_:URLRequest = null;
         if(BuildInfos.BUILD_TYPE == BuildTypeEnum.RELEASE || BuildInfos.BUILD_TYPE == BuildTypeEnum.BETA)
         {
            _loc2_ = new URLRequest(I18n.getUiText("ui.link.ankaboxPortal"));
         }
         else
         {
            _loc2_ = new URLRequest(I18n.getUiText("ui.link.ankaboxPortalLocal"));
         }
         _loc2_.data = this.getAnkamaPortalUrlParams();
         _loc2_.data.idbar = 0;
         _loc2_.data.game = 1;
         _loc2_.method = URLRequestMethod.POST;
         if(param1)
         {
            ComponentInternalAccessor.access(param1,"load")(_loc2_);
         }
         else
         {
            navigateToURL(_loc2_);
         }
      }
      
      [Trusted]
      public function goToAnkaBoxLastMessage(param1:WebBrowser) : void
      {
         var _loc2_:URLRequest = null;
         if(BuildInfos.BUILD_TYPE == BuildTypeEnum.RELEASE || BuildInfos.BUILD_TYPE == BuildTypeEnum.BETA)
         {
            _loc2_ = new URLRequest(I18n.getUiText("ui.link.ankaboxLastMessage"));
         }
         else
         {
            _loc2_ = new URLRequest(I18n.getUiText("ui.link.ankaboxLastMessageLocal"));
         }
         _loc2_.data = this.getAnkamaPortalUrlParams();
         _loc2_.data.idbar = 0;
         _loc2_.data.game = 1;
         _loc2_.method = URLRequestMethod.POST;
         if(param1)
         {
            ComponentInternalAccessor.access(param1,"load")(_loc2_);
         }
         else
         {
            navigateToURL(_loc2_);
         }
      }
      
      [Trusted]
      public function goToAnkaBoxSend(param1:WebBrowser, param2:int) : void
      {
         var _loc3_:URLRequest = null;
         if(BuildInfos.BUILD_TYPE == BuildTypeEnum.RELEASE || BuildInfos.BUILD_TYPE == BuildTypeEnum.BETA)
         {
            _loc3_ = new URLRequest(I18n.getUiText("ui.link.ankaboxSend"));
         }
         else
         {
            _loc3_ = new URLRequest(I18n.getUiText("ui.link.ankaboxSendLocal"));
         }
         _loc3_.data = this.getAnkamaPortalUrlParams();
         _loc3_.data.i = String(param2);
         _loc3_.data.idbar = 0;
         _loc3_.data.game = 1;
         _loc3_.method = URLRequestMethod.POST;
         if(param1)
         {
            ComponentInternalAccessor.access(param1,"load")(_loc3_);
         }
         else
         {
            navigateToURL(_loc3_);
         }
      }
      
      [Trusted]
      public function goToSupportFAQ(param1:String) : void
      {
         var _loc2_:URLRequest = new URLRequest(param1);
         navigateToURL(_loc2_);
      }
      
      [Trusted]
      public function goToChangelogPortal(param1:WebBrowser) : void
      {
      }
      
      [Trusted]
      public function goToCheckLink(param1:String, param2:uint, param3:String) : void
      {
         var _loc4_:* = null;
         if(BuildInfos.BUILD_TYPE == BuildTypeEnum.RELEASE || BuildInfos.BUILD_TYPE == BuildTypeEnum.BETA || BuildInfos.BUILD_TYPE == BuildTypeEnum.TESTING)
         {
            _loc4_ = I18n.getUiText("ui.link.checklink");
         }
         else
         {
            _loc4_ = "http://go.ankama.lan/" + this.getCurrentLanguage() + "/check";
         }
         if(param1.indexOf("www") == 0)
         {
            param1 = "http://" + param1;
         }
         var _loc5_:uint = PlayerManager.getInstance().accountId;
         var _loc6_:String = PlayedCharacterManager.getInstance().infos.name;
         var _loc7_:uint = param2;
         var _loc8_:String = param3;
         var _loc9_:int = 1;
         var _loc10_:int = PlayerManager.getInstance().server.id;
         this._log.debug("goToCheckLink : " + param1 + " " + _loc5_ + " " + _loc7_ + " " + _loc9_ + " " + _loc10_);
         var _loc11_:String = param1 + _loc5_ + "" + _loc7_ + "" + _loc6_ + param3 + _loc9_.toString() + _loc10_.toString();
         var _loc12_:String = AdvancedMd5.hex_hmac_md5(">:fIZ?vfU0sDM_9j",_loc11_);
         var _loc13_:* = "{\"url\":\"" + param1 + "\",\"click_account\":" + _loc5_ + ",\"from_account\":" + _loc7_ + ",\"click_name\":\"" + _loc6_ + "\",\"from_name\":\"" + _loc8_ + "\",\"game\":" + _loc9_ + ",\"server\":" + _loc10_ + ",\"hmac\":\"" + _loc12_ + "\"}";
         var _loc14_:ByteArray;
         (_loc14_ = new ByteArray()).writeUTFBytes(_loc13_);
         _loc14_.position = 0;
         var _loc15_:* = "";
         _loc14_.position = 0;
         while(_loc14_.bytesAvailable)
         {
            _loc15_ = _loc15_ + _loc14_.readUnsignedByte().toString(16);
         }
         _loc15_ = _loc15_.toUpperCase();
         _loc4_ = _loc4_ + ("?s=" + _loc15_);
         var _loc16_:URLRequest = new URLRequest(_loc4_);
         var _loc17_:URLVariables;
         (_loc17_ = new URLVariables()).s = _loc15_;
         _loc16_.method = URLRequestMethod.POST;
         navigateToURL(_loc16_);
      }
      
      [Trusted]
      public function goToWebReader(param1:WebBrowser, param2:String) : void
      {
         var target:WebBrowser = param1;
         var comicRef:String = param2;
         var egf:ExternalGameFrame = Kernel.getWorker().getFrame(ExternalGameFrame) as ExternalGameFrame;
         if(egf)
         {
            egf.getIceToken(function(param1:String):void
            {
               var _loc2_:URLRequest = null;
               if(BuildInfos.BUILD_TYPE == BuildTypeEnum.RELEASE || BuildInfos.BUILD_TYPE == BuildTypeEnum.BETA)
               {
                  _loc2_ = new URLRequest(I18n.getUiText("ui.link.webReader"));
               }
               else
               {
                  _loc2_ = new URLRequest(I18n.getUiText("ui.link.webReaderLocal"));
               }
               var _loc3_:URLVariables = new URLVariables();
               _loc3_.token = param1;
               _loc3_.key = comicRef;
               _loc3_.lang = XmlConfig.getInstance().getEntry("config.lang.current");
               _loc2_.data = _loc3_;
               _loc2_.method = URLRequestMethod.GET;
               if(target)
               {
                  ComponentInternalAccessor.access(target,"load")(_loc2_);
               }
               else
               {
                  navigateToURL(_loc2_);
               }
            });
         }
      }
      
      [Trusted]
      public function refreshUrl(param1:WebBrowser, param2:uint = 0) : void
      {
         var _loc3_:URLVariables = null;
         var _loc4_:URLRequest = new URLRequest(param1.location);
         if(param2 == 0)
         {
            _loc4_.data = this.getAnkamaPortalUrlParams();
            _loc4_.method = URLRequestMethod.POST;
         }
         else if(param2 == 1)
         {
            _loc3_ = new URLVariables();
            _loc3_.tags = BuildInfos.BUILD_VERSION.major + "." + BuildInfos.BUILD_VERSION.minor + "." + BuildInfos.BUILD_VERSION.release;
            _loc3_.theme = OptionManager.getOptionManager("dofus").switchUiSkin;
            _loc4_.data = _loc3_;
            _loc4_.method = URLRequestMethod.GET;
         }
         ComponentInternalAccessor.access(param1,"load")(_loc4_);
      }
      
      [Trusted]
      public function execServerCmd(param1:String) : void
      {
         var _loc2_:AdminQuietCommandMessage = new AdminQuietCommandMessage();
         _loc2_.initAdminQuietCommandMessage(param1);
         if(PlayerManager.getInstance().hasRights)
         {
            ConnectionsHandler.getConnection().send(_loc2_);
         }
      }
      
      [Trusted]
      public function mouseZoom(param1:Boolean = true) : void
      {
         var _loc2_:CameraControlFrame = Kernel.getWorker().getFrame(CameraControlFrame) as CameraControlFrame;
         if(_loc2_.dragging)
         {
            return;
         }
         var _loc3_:Number = Atouin.getInstance().currentZoom + (!!param1?1:-1);
         this.luaZoom(_loc3_);
         Atouin.getInstance().zoom(_loc3_,Atouin.getInstance().worldContainer.mouseX,Atouin.getInstance().worldContainer.mouseY);
         var _loc4_:RoleplayEntitiesFrame;
         if(_loc4_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame)
         {
            _loc4_.updateAllIcons();
         }
         var _loc5_:MonstersInfoFrame;
         if(_loc5_ = Kernel.getWorker().getFrame(MonstersInfoFrame) as MonstersInfoFrame)
         {
            _loc5_.update(true);
         }
         if(_loc3_ <= AtouinConstants.MAX_ZOOM && _loc3_ >= 1)
         {
            TooltipManager.hideAll();
         }
         var _loc6_:FightPreparationFrame;
         if(_loc6_ = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame)
         {
            _loc6_.updateSwapPositionRequestsIcons();
         }
      }
      
      [Trusted]
      public function resetZoom() : void
      {
         Atouin.getInstance().zoom(1);
         var _loc1_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         if(_loc1_)
         {
            _loc1_.updateAllIcons();
         }
         var _loc2_:FightPreparationFrame = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame;
         if(_loc2_)
         {
            _loc2_.updateSwapPositionRequestsIcons();
         }
      }
      
      [Trusted]
      public function getMaxZoom() : uint
      {
         return AtouinConstants.MAX_ZOOM;
      }
      
      [Trusted]
      public function optimize() : Boolean
      {
         return PerformanceManager.optimize;
      }
      
      [Untrusted]
      public function hasPart(param1:String) : Boolean
      {
         var _loc2_:ContentPart = PartManager.getInstance().getPart(param1);
         if(_loc2_)
         {
            return _loc2_.state == PartStateEnum.PART_UP_TO_DATE;
         }
         return true;
      }
      
      [Untrusted]
      public function hasUpdaterConnection() : Boolean
      {
         return UpdaterConnexionHandler.getConnection() && UpdaterConnexionHandler.getConnection().connected;
      }
      
      [Untrusted]
      public function isDownloading() : Boolean
      {
         return PartManager.getInstance().isDownloading;
      }
      
      [Untrusted]
      public function isStreaming() : Boolean
      {
         return AirScanner.isStreamingVersion();
      }
      
      [Untrusted]
      public function isDevMode() : Boolean
      {
         return UiModuleManager.getInstance().isDevMode;
      }
      
      [Untrusted]
      public function isDownloadFinished() : Boolean
      {
         return PartManager.getInstance().isFinished;
      }
      
      [Untrusted]
      public function notifyUser(param1:Boolean) : void
      {
         return SystemManager.getSingleton().notifyUser(param1);
      }
      
      [Untrusted]
      public function setGameAlign(param1:String) : void
      {
         StageShareManager.stage.align = param1;
      }
      
      [Untrusted]
      public function getGameAlign() : String
      {
         return StageShareManager.stage.align;
      }
      
      [Untrusted]
      public function getDirectoryContent(param1:String = ".") : Array
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:File = null;
         do
         {
            _loc2_ = param1.length;
            param1 = param1.replace("..",".");
         }
         while(param1.length != _loc2_);
         
         param1 = param1.replace(":","");
         var _loc6_:File;
         if((_loc6_ = new File(unescape(this._module.rootPath.replace("file://",""))).resolvePath(param1)).isDirectory)
         {
            _loc3_ = [];
            _loc4_ = _loc6_.getDirectoryListing();
            for each(_loc5_ in _loc4_)
            {
               _loc3_.push({
                  "name":_loc5_.name,
                  "type":(!!_loc5_.isDirectory?"folder":"file")
               });
            }
            return _loc3_;
         }
         return [];
      }
      
      [Trusted]
      public function getAccountId(param1:String) : int
      {
         try
         {
            return AccountManager.getInstance().getAccountId(param1);
         }
         catch(error:Error)
         {
            return 0;
         }
      }
      
      [Untrusted]
      public function getIsAnkaBoxEnabled() : Boolean
      {
         var _loc1_:ChatFrame = Kernel.getWorker().getFrame(ChatFrame) as ChatFrame;
         if(GuestModeManager.getInstance().isLoggingAsGuest)
         {
            return false;
         }
         if(_loc1_)
         {
            return _loc1_.ankaboxEnabled;
         }
         return false;
      }
      
      [Trusted]
      public function getAdminStatus() : int
      {
         return PlayerManager.getInstance().adminStatus;
      }
      
      [Untrusted]
      public function getObjectVariables(param1:Object, param2:Boolean = false, param3:Boolean = false) : Array
      {
         return DescribeTypeCache.getVariables(param1,param2,param3);
      }
      
      [Untrusted]
      public function getNewDynamicSecureObject() : DynamicSecureObject
      {
         return new DynamicSecureObject();
      }
      
      [Trusted]
      public function sendStatisticReport(param1:String, param2:String) : Boolean
      {
         return StatisticReportingManager.getInstance().report(param1,param2);
      }
      
      [Trusted]
      public function isStatisticReported(param1:String) : Boolean
      {
         return StatisticReportingManager.getInstance().isReported(param1);
      }
      
      [Trusted]
      public function getNickname() : String
      {
         return PlayerManager.getInstance().nickname;
      }
      
      [Trusted]
      public function copyToClipboard(param1:String) : void
      {
         Clipboard.generalClipboard.clear();
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,param1);
      }
      
      [Trusted]
      public function getLaunchArgs() : String
      {
         return CommandLineArguments.getInstance().toString();
      }
      
      [Trusted]
      public function getPartnerInfo() : String
      {
         var _loc1_:FileStream = null;
         var _loc2_:String = null;
         var _loc3_:File = File.applicationDirectory.resolvePath("partner");
         if(_loc3_.exists)
         {
            _loc1_ = new FileStream();
            _loc1_.open(_loc3_,FileMode.READ);
            _loc2_ = _loc1_.readUTFBytes(_loc1_.bytesAvailable);
            _loc1_.close();
            return _loc2_;
         }
         return "";
      }
      
      [Trusted]
      public function toggleModuleInstaller() : void
      {
         var _loc1_:ModuleInstallerFrame = Kernel.getWorker().getFrame(ModuleInstallerFrame) as ModuleInstallerFrame;
         if(_loc1_)
         {
            Kernel.getWorker().removeFrame(_loc1_);
         }
         else
         {
            Kernel.getWorker().addFrame(new ModuleInstallerFrame());
         }
      }
      
      [Trusted]
      public function isUpdaterVersion2OrUnknown() : Boolean
      {
         if(!CommandLineArguments.getInstance() || !CommandLineArguments.getInstance().hasArgument("lang"))
         {
            this._log.debug("Updater version : pas d\'updater");
            return true;
         }
         if(!CommandLineArguments.getInstance().hasArgument("updater_version"))
         {
            this._log.debug("Updater version : pas de version connue");
            return false;
         }
         this._log.debug("Updater version : " + CommandLineArguments.getInstance().getArgument("updater_version"));
         return CommandLineArguments.getInstance().getArgument("updater_version") == "v2";
      }
      
      [Untrusted]
      public function isKeyDown(param1:uint) : Boolean
      {
         return HumanInputHandler.getInstance().getKeyboardPoll().isDown(param1);
      }
      
      [Trusted]
      public function isGuest() : Boolean
      {
         return GuestModeManager.getInstance().isLoggingAsGuest;
      }
      
      [Trusted]
      public function isInForcedGuestMode() : Boolean
      {
         return GuestModeManager.getInstance().forceGuestMode;
      }
      
      [Trusted]
      public function convertGuestAccount() : void
      {
         GuestModeManager.getInstance().convertGuestAccount();
      }
      
      [Trusted]
      public function getGiftList() : Array
      {
         var _loc1_:GameServerApproachFrame = Kernel.getWorker().getFrame(GameServerApproachFrame) as GameServerApproachFrame;
         return _loc1_.giftList;
      }
      
      [Trusted]
      public function getCharaListMinusDeadPeople() : Array
      {
         var _loc1_:GameServerApproachFrame = Kernel.getWorker().getFrame(GameServerApproachFrame) as GameServerApproachFrame;
         return _loc1_.charaListMinusDeadPeople;
      }
      
      private function getAnkamaPortalUrlParams() : URLVariables
      {
         var _loc1_:URLVariables = new URLVariables();
         _loc1_.username = AuthentificationManager.getInstance().username;
         _loc1_.passkey = AuthentificationManager.getInstance().ankamaPortalKey;
         _loc1_.server = !!PlayerManager.getInstance().server?PlayerManager.getInstance().server.id:0;
         _loc1_.serverName = !!PlayerManager.getInstance().server?PlayerManager.getInstance().server.name:"";
         _loc1_.language = XmlConfig.getInstance().getEntry("config.lang.current");
         _loc1_.character = !!PlayedCharacterManager.getInstance()?PlayedCharacterManager.getInstance().id:0;
         _loc1_.theme = OptionManager.getOptionManager("dofus").switchUiSkin;
         return _loc1_;
      }
      
      private function initAccountDataStore() : void
      {
         this._accountDataStore = new DataStoreType("AccountModule_" + this._module.id,true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_ACCOUNT);
      }
      
      private function initCharacterDataStore() : void
      {
         this._characterDataStore = new DataStoreType("Module_" + this._module.id,true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_CHARACTER);
      }
      
      private function initModuleActionDataStore() : void
      {
         this._moduleActionDataStore = new DataStoreType("ModuleAction_" + this._module.id,true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_CHARACTER);
      }
      
      private function luaZoom(param1:Number) : void
      {
         var _loc2_:LuaScriptRecorderFrame = Kernel.getWorker().getFrame(LuaScriptRecorderFrame) as LuaScriptRecorderFrame;
         if(_loc2_)
         {
            _loc2_.cameraZoom(param1);
         }
      }
   }
}
