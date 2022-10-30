package com.ankamagames.dofus.logic.game.approach.managers
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.kernel.updaterv2.IUpdaterMessageHandler;
   import com.ankamagames.dofus.kernel.updaterv2.UpdaterApi;
   import com.ankamagames.dofus.kernel.updaterv2.messages.IUpdaterInputMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.ComponentListMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.ErrorMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.FinishedMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.ProgressMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.StepMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.SystemConfigurationMessage;
   import com.ankamagames.dofus.logic.connection.managers.StoreUserDataManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import d2hooks.UpdateError;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class PartManagerV2 implements IUpdaterMessageHandler
   {
      
      private static const instance:PartManagerV2 = new PartManagerV2();
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(PartManagerV2));
      
      private static const PROJECT_NAME:String = "game";
       
      
      private var api:UpdaterApi;
      
      private var _modules:Dictionary;
      
      private var _init_mode:Boolean;
      
      public function PartManagerV2()
      {
         super();
         if(!this.api)
         {
            this.api = new UpdaterApi(this);
         }
      }
      
      public static function getInstance() : PartManagerV2
      {
         return instance;
      }
      
      public function init() : void
      {
         _log.info("Initializing PartManager");
         this.api.getComponentList(PROJECT_NAME);
      }
      
      public function hasComponent(param1:String) : Boolean
      {
         return !!this._modules?this._modules[param1] != null?Boolean(this._modules[param1].activated as Boolean):false:false;
      }
      
      public function activateComponent(param1:String, param2:Boolean = true, param3:String = "game") : void
      {
         if(!this.hasComponent(param1))
         {
            _log.debug(!!("Ask updater for " + param2)?"activate":"desactivate" + " component : " + param1);
            this.api.activateComponent(param1,param2,param3);
         }
      }
      
      public function getSystemConfiguration(param1:String = "") : void
      {
         this.api.getSystemConfiguration(param1);
      }
      
      public function set installedModules(param1:Dictionary) : void
      {
         this._modules = param1;
      }
      
      public function handleMessage(param1:IUpdaterInputMessage) : void
      {
         var _loc2_:SystemConfigurationMessage = null;
         var _loc3_:ComponentListMessage = null;
         var _loc4_:StepMessage = null;
         var _loc5_:UiModule = null;
         var _loc6_:ProgressMessage = null;
         var _loc7_:FinishedMessage = null;
         var _loc8_:ErrorMessage = null;
         var _loc9_:Hook = null;
         var _loc10_:Array = null;
         _log.info("From updater : " + getQualifiedClassName(param1));
         switch(true)
         {
            case param1 is ComponentListMessage:
               _loc3_ = param1 as ComponentListMessage;
               this._modules = _loc3_.components;
               break;
            case param1 is StepMessage:
               if((_loc4_ = param1 as StepMessage).step == StepMessage.UPDATING_STEP)
               {
                  _loc5_ = UiModuleManager.getInstance().getModule("Ankama_Common");
                  if(!Berilia.getInstance().isUiDisplayed("downloadUiNewUpdaterInstance"))
                  {
                     Berilia.getInstance().loadUi(_loc5_,_loc5_.getUi("downloadUiNewUpdater"),"downloadUiNewUpdaterInstance",null,false,StrataEnum.STRATA_HIGH);
                  }
               }
               _loc10_ = [_loc9_ = HookList.UpdateStepChange,_loc4_.step];
               break;
            case param1 is ProgressMessage:
               _loc6_ = param1 as ProgressMessage;
               _loc10_ = [_loc9_ = HookList.UpdateProgress,_loc6_.step,_loc6_.currentSize,_loc6_.eta,_loc6_.progress,_loc6_.smooth,_loc6_.speed,_loc6_.totalSize];
               break;
            case param1 is FinishedMessage:
               _loc7_ = param1 as FinishedMessage;
               _loc10_ = [_loc9_ = HookList.UpdateFinished,_loc7_.needRestart,_loc7_.needUpdate,_loc7_.newVersion,_loc7_.previousVersion,_loc7_.error];
               setTimeout(Berilia.getInstance().unloadUi,2000,"downloadUiNewUpdaterInstance");
               break;
            case param1 is SystemConfigurationMessage:
               _loc2_ = param1 as SystemConfigurationMessage;
               StoreUserDataManager.getInstance().onSystemConfiguration(_loc2_.config);
               break;
            case param1 is UpdateError:
               _loc8_ = param1 as ErrorMessage;
               _loc10_ = [_loc9_ = HookList.UpdateError,_loc8_.type,_loc8_.message];
         }
         if(_loc9_)
         {
            KernelEventsManager.getInstance().processCallback.apply(null,_loc10_);
         }
      }
      
      public function handleConnectionOpened() : void
      {
         _log.info("Updater is online");
      }
      
      public function handleConnectionClosed() : void
      {
         _log.info("Connexion with updater has been closed");
      }
   }
}
