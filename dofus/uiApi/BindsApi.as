package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.frames.ShortcutsFrame;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.managers.BindsManager;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.shortcut.Bind;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   
   [InstanciedApi]
   public class BindsApi implements IApi
   {
       
      
      private var _module:UiModule;
      
      public function BindsApi()
      {
         super();
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
      }
      
      [Untrusted]
      public function getBindList() : Array
      {
         return BindsManager.getInstance().binds;
      }
      
      [Untrusted]
      public function getShortcut() : Array
      {
         var _loc1_:Shortcut = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = Shortcut.getShortcuts();
         for each(_loc1_ in _loc3_)
         {
            if(_loc1_.visible)
            {
               _loc2_.push(_loc1_);
            }
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getShortcutBind(param1:String, param2:Boolean = false) : Bind
      {
         return BindsManager.getInstance().getBindFromShortcut(param1,param2);
      }
      
      [Untrusted]
      public function setShortcutBind(param1:String, param2:String, param3:Boolean, param4:Boolean, param5:Boolean) : void
      {
         BindsManager.getInstance().addBind(new Bind(param2,param1,param3,param4,param5));
      }
      
      [Untrusted]
      public function removeShortcutBind(param1:String) : void
      {
         BindsManager.getInstance().removeBind(BindsManager.getInstance().getBindFromShortcut(param1));
      }
      
      [Untrusted]
      public function getShortcutBindStr(param1:String, param2:Boolean = false) : String
      {
         var _loc3_:Bind = this.getShortcutBind(param1,param2);
         if(_loc3_ != null && _loc3_.key != null)
         {
            return _loc3_.toString();
         }
         return "";
      }
      
      [Trusted]
      public function resetAllBinds() : void
      {
         BindsManager.getInstance().reset();
      }
      
      [Untrusted]
      public function availableKeyboards() : Array
      {
         return BindsManager.getInstance().availableKeyboards.concat();
      }
      
      [Trusted]
      public function changeKeyboard(param1:String) : void
      {
         BindsManager.getInstance().changeKeyboard(param1,true);
      }
      
      [Untrusted]
      public function getCurrentLocale() : String
      {
         return BindsManager.getInstance().currentLocale;
      }
      
      [Untrusted]
      public function bindIsRegister(param1:Bind) : Boolean
      {
         return BindsManager.getInstance().isRegister(param1);
      }
      
      [Untrusted]
      public function bindIsPermanent(param1:Bind) : Boolean
      {
         return BindsManager.getInstance().isPermanent(param1);
      }
      
      [Untrusted]
      public function bindIsDisabled(param1:Bind) : Boolean
      {
         return BindsManager.getInstance().isDisabled(param1);
      }
      
      [Trusted]
      public function setBindDisabled(param1:Bind, param2:Boolean) : void
      {
         BindsManager.getInstance().setDisabled(param1,param2);
      }
      
      [Untrusted]
      public function getRegisteredBind(param1:Bind) : Bind
      {
         return BindsManager.getInstance().getRegisteredBind(param1);
      }
      
      [Untrusted]
      public function getShortcutByName(param1:String) : Shortcut
      {
         return Shortcut.getShortcutByName(param1);
      }
      
      [Trusted]
      public function setShortcutEnabled(param1:Boolean) : void
      {
         ShortcutsFrame.shortcutsEnabled = param1;
      }
      
      [Untrusted]
      public function getIsShortcutEnabled() : Boolean
      {
         return ShortcutsFrame.shortcutsEnabled;
      }
      
      [Untrusted]
      public function disableShortcut(param1:String, param2:Boolean) : void
      {
         var _loc3_:Shortcut = Shortcut.getShortcutByName(param1);
         if(_loc3_ != null)
         {
            _loc3_.disable = param2;
         }
      }
      
      [Untrusted]
      public function enableShortcutKey(param1:uint, param2:uint, param3:Boolean) : void
      {
         BindsManager.getInstance().setDisabled(new Bind(BindsManager.getInstance().getShortcutString(param1,param2)),!param3);
      }
   }
}
