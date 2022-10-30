package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.types.AtouinOptions;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.ThemeManager;
   import com.ankamagames.berilia.types.BeriliaOptions;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.dofus.externalnotification.ExternalNotificationManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.frames.MiscFrame;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.options.ChatOptions;
   import com.ankamagames.dofus.misc.utils.errormanager.DofusErrorHandler;
   import com.ankamagames.dofus.types.DofusOptions;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.tiphon.engine.Tiphon;
   import com.ankamagames.tiphon.types.TiphonOptions;
   import com.ankamagames.tubul.types.TubulOptions;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class ConfigApi implements IApi
   {
      
      private static var _init:Boolean = false;
       
      
      private var _module:UiModule;
      
      public function ConfigApi()
      {
         super();
         this.init();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
         _init = false;
      }
      
      [Untrusted]
      public function getConfigProperty(param1:String, param2:String) : *
      {
         var _loc3_:* = OptionManager.getOptionManager(param1);
         if(!_loc3_)
         {
            throw new ApiError("Config module [" + param1 + "] does not exist.");
         }
         if(_loc3_ && this.isSimpleConfigType(_loc3_[param2]))
         {
            return _loc3_[param2];
         }
         return null;
      }
      
      [Untrusted]
      public function setConfigProperty(param1:String, param2:String, param3:*) : void
      {
         var _loc4_:OptionManager;
         if(!(_loc4_ = OptionManager.getOptionManager(param1)))
         {
            throw new ApiError("Config module [" + param1 + "] does not exist.");
         }
         if(this.isSimpleConfigType(_loc4_.getDefaultValue(param2)))
         {
            _loc4_[param2] = param3;
            return;
         }
         throw new ApiError(param2 + " cannot be set in config module " + param1 + ".");
      }
      
      [Untrusted]
      public function resetConfigProperty(param1:String, param2:String) : void
      {
         if(!OptionManager.getOptionManager(param1))
         {
            throw ApiError("Config module [" + param1 + "] does not exist.");
         }
         OptionManager.getOptionManager(param1).restaureDefaultValue(param2);
      }
      
      [NoBoxing]
      [Untrusted]
      public function createOptionManager(param1:String) : OptionManager
      {
         return new OptionManager(param1);
      }
      
      [Trusted]
      public function getAllThemes() : Array
      {
         return ThemeManager.getInstance().getThemes();
      }
      
      [Untrusted]
      public function getCurrentTheme() : String
      {
         return ThemeManager.getInstance().currentTheme;
      }
      
      [Trusted]
      public function isOptionalFeatureActive(param1:int) : Boolean
      {
         var _loc2_:MiscFrame = Kernel.getWorker().getFrame(MiscFrame) as MiscFrame;
         return _loc2_.isOptionalFeatureActive(param1);
      }
      
      [Trusted]
      public function getServerConstant(param1:int) : Object
      {
         return MiscFrame.getInstance().getServerSessionConstant(param1);
      }
      
      [Untrusted]
      public function getExternalNotificationOptions(param1:int) : Object
      {
         return ExternalNotificationManager.getInstance().getNotificationOptions(param1);
      }
      
      [Untrusted]
      public function setExternalNotificationOptions(param1:int, param2:Object) : void
      {
         ExternalNotificationManager.getInstance().setNotificationOptions(param1,param2);
      }
      
      [Untrusted]
      public function setDebugMode(param1:Boolean) : void
      {
         DofusErrorHandler.manualActivation = param1;
         if(param1)
         {
            DofusErrorHandler.activateDebugMode();
         }
      }
      
      [Untrusted]
      public function getDebugMode() : Boolean
      {
         return DofusErrorHandler.manualActivation;
      }
      
      [Untrusted]
      public function debugFileExists() : Boolean
      {
         return DofusErrorHandler.debugFileExists;
      }
      
      private function init() : void
      {
         if(_init)
         {
            return;
         }
         _init = true;
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         Dofus.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         Tiphon.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
      }
      
      private function isSimpleConfigType(param1:*) : Boolean
      {
         switch(true)
         {
            case param1 is int:
            case param1 is uint:
            case param1 is Number:
            case param1 is Boolean:
            case param1 is String:
            case param1 is Point:
               return true;
            default:
               return false;
         }
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = param1.propertyValue;
         if(_loc3_ is DisplayObject)
         {
            _loc3_ = SecureCenter.secure(_loc3_,this._module.trusted);
         }
         var _loc4_:*;
         if((_loc4_ = param1.propertyOldValue) is DisplayObject)
         {
            _loc3_ = SecureCenter.secure(_loc3_,this._module.trusted);
         }
         switch(true)
         {
            case param1.watchedClassInstance is AtouinOptions:
               _loc2_ = "atouin";
               break;
            case param1.watchedClassInstance is DofusOptions:
               _loc2_ = "dofus";
               break;
            case param1.watchedClassInstance is BeriliaOptions:
               _loc2_ = "berilia";
               break;
            case param1.watchedClassInstance is TiphonOptions:
               _loc2_ = "tiphon";
               break;
            case param1.watchedClassInstance is TubulOptions:
               _loc2_ = "soundmanager";
               break;
            case param1.watchedClassInstance is ChatOptions:
               _loc2_ = "chat";
               break;
            default:
               _loc2_ = getQualifiedClassName(param1.watchedClassInstance);
         }
         KernelEventsManager.getInstance().processCallback(HookList.ConfigPropertyChange,_loc2_,param1.propertyName,_loc3_,_loc4_);
      }
   }
}
