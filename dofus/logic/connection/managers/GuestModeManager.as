package com.ankamagames.dofus.logic.connection.managers
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAsGuestAction;
   import com.ankamagames.dofus.logic.game.common.frames.ExternalGameFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ProtectPishingFrame;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.utils.RpcServiceCenter;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.enum.WebBrowserEnum;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.crypto.symmetric.ICipher;
   import com.hurlant.crypto.symmetric.PKCS5;
   import flash.events.ErrorEvent;
   import flash.events.IOErrorEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class GuestModeManager implements IDestroyable
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(GuestModeManager));
      
      private static var _self:GuestModeManager;
       
      
      private var _forceGuestMode:Boolean;
      
      private var _domainExtension:String;
      
      private var _locale:String;
      
      public var isLoggingAsGuest:Boolean = false;
      
      public function GuestModeManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("GuestModeManager is a singleton and should not be instanciated directly.");
         }
         this._forceGuestMode = false;
         this._domainExtension = RpcServiceCenter.getInstance().apiDomain.split(".").pop() as String;
         this._locale = XmlConfig.getInstance().getEntry("config.lang.current");
         if(CommandLineArguments.getInstance().hasArgument("guest"))
         {
            this._forceGuestMode = CommandLineArguments.getInstance().getArgument("guest") == "true";
         }
      }
      
      public static function getInstance() : GuestModeManager
      {
         if(_self == null)
         {
            _self = new GuestModeManager();
         }
         return _self;
      }
      
      public function get forceGuestMode() : Boolean
      {
         return this._forceGuestMode;
      }
      
      public function set forceGuestMode(param1:Boolean) : void
      {
         this._forceGuestMode = param1;
      }
      
      public function logAsGuest() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Object = this.getStoredCredentials();
         if(!_loc2_)
         {
            _loc1_ = [this._locale];
            if(CommandLineArguments.getInstance().hasArgument("webParams"))
            {
               _loc1_.push(CommandLineArguments.getInstance().getArgument("webParams"));
            }
            RpcServiceCenter.getInstance().makeRpcCall(RpcServiceCenter.getInstance().apiDomain + "/ankama/guest.json","json","1.0","Create",_loc1_,this.onGuestAccountCreated,true,false);
         }
         else
         {
            Kernel.getWorker().process(LoginValidationAsGuestAction.create(_loc2_.login,_loc2_.password));
         }
      }
      
      public function convertGuestAccount() : void
      {
         var _loc1_:Object = null;
         var _loc2_:ExternalGameFrame = Kernel.getWorker().getFrame(ExternalGameFrame) as ExternalGameFrame;
         if(_loc2_)
         {
            _loc2_.getIceToken(this.onIceTokenReceived);
         }
         else
         {
            _loc1_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
            _loc1_.openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.secureMode.error.default"),[I18n.getUiText("ui.common.ok")]);
         }
      }
      
      public function clearStoredCredentials() : void
      {
         var _loc1_:CustomSharedObject = CustomSharedObject.getLocal("Dofus_Guest");
         if(_loc1_ && _loc1_.data)
         {
            _loc1_.data = new Object();
            _loc1_.flush();
         }
      }
      
      public function hasGuestAccount() : Boolean
      {
         return this.getStoredCredentials() != null;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      private function storeCredentials(param1:String, param2:String) : void
      {
         var _loc4_:ByteArray = null;
         var _loc7_:ByteArray = null;
         var _loc8_:CustomSharedObject = null;
         var _loc3_:String = MD5.hash(param1);
         (_loc4_ = new ByteArray()).writeUTFBytes(_loc3_);
         var _loc5_:PKCS5 = new PKCS5();
         var _loc6_:ICipher = Crypto.getCipher("simple-aes",_loc4_,_loc5_);
         _loc5_.setBlockSize(_loc6_.getBlockSize());
         (_loc7_ = new ByteArray()).writeUTFBytes(param2);
         _loc6_.encrypt(_loc7_);
         if(_loc8_ = CustomSharedObject.getLocal("Dofus_Guest"))
         {
            if(!_loc8_.data)
            {
               _loc8_.data = new Object();
            }
            _loc8_.data.login = param1;
            _loc8_.data.password = _loc7_;
            _loc8_.flush();
         }
      }
      
      private function getStoredCredentials() : Object
      {
         var _loc1_:String = null;
         var _loc2_:ByteArray = null;
         var _loc3_:PKCS5 = null;
         var _loc4_:ICipher = null;
         var _loc5_:ByteArray = null;
         var _loc6_:ByteArray = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:CustomSharedObject;
         if((_loc9_ = CustomSharedObject.getLocal("Dofus_Guest")) && _loc9_.data && _loc9_.data.hasOwnProperty("login") && _loc9_.data.hasOwnProperty("password"))
         {
            _loc1_ = MD5.hash(_loc9_.data.login);
            _loc2_ = new ByteArray();
            _loc2_.writeUTFBytes(_loc1_);
            _loc3_ = new PKCS5();
            _loc4_ = Crypto.getCipher("simple-aes",_loc2_,_loc3_);
            _loc3_.setBlockSize(_loc4_.getBlockSize());
            _loc5_ = _loc9_.data.password as ByteArray;
            (_loc6_ = new ByteArray()).writeBytes(_loc5_);
            _loc4_.decrypt(_loc6_);
            _loc6_.position = 0;
            _loc7_ = _loc9_.data.login;
            _loc8_ = _loc6_.readUTFBytes(_loc6_.length);
            return {
               "login":_loc7_,
               "password":_loc8_
            };
         }
         return null;
      }
      
      private function onGuestAccountCreated(param1:Boolean, param2:*, param3:*) : void
      {
         _log.debug("onGuestAccountCreated - " + param1);
         if(param1)
         {
            if(param2.error)
            {
               this.onGuestAccountError(param2.error);
            }
            else
            {
               this.storeCredentials(param2.login,param2.password);
               if(AirScanner.isStreamingVersion() && ExternalInterface.available)
               {
                  ExternalInterface.call("onGuestAccountCreated");
               }
               Kernel.getWorker().process(LoginValidationAsGuestAction.create(param2.login,param2.password));
            }
         }
         else
         {
            this.onGuestAccountError(param2);
         }
      }
      
      private function onGuestAccountError(param1:*) : void
      {
         var _loc2_:String = null;
         var _loc3_:Frame = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         _log.error(param1);
         var _loc6_:Object = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
         if(param1 is ErrorEvent && param1.type == IOErrorEvent.NETWORK_ERROR || param1 is IOErrorEvent)
         {
            _loc6_.openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.connection.guestAccountCreationTimedOut"),[I18n.getUiText("ui.common.ok")]);
         }
         else if(param1 is String)
         {
            _loc6_.openPopup(I18n.getUiText("ui.common.error"),param1,[I18n.getUiText("ui.common.ok")]);
         }
         else
         {
            _loc2_ = I18n.getUiText("ui.secureMode.error.default");
            if(param1 is ErrorEvent)
            {
               _loc2_ = _loc2_ + (" (#" + (param1 as ErrorEvent).errorID + ")");
            }
            _loc6_.openPopup(I18n.getUiText("ui.common.error"),_loc2_,[I18n.getUiText("ui.common.ok")]);
         }
         KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailed,0);
         if(this._forceGuestMode)
         {
            this._forceGuestMode = false;
            if(Kernel.getWorker().contains(ProtectPishingFrame))
            {
               _log.error("Oh oh ! ProtectPishingFrame is still here, it shoudln\'t be. Who else is in here ?");
               for each(_loc3_ in Kernel.getWorker().framesList)
               {
                  _loc5_ = (_loc4_ = getQualifiedClassName(_loc3_)).split("::");
                  _log.error(" - " + _loc5_[_loc5_.length - 1]);
               }
               Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(ProtectPishingFrame));
            }
            KernelEventsManager.getInstance().processCallback(HookList.AuthentificationStart);
         }
      }
      
      private function onIceTokenReceived(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:URLRequest = null;
         if(!param1)
         {
            (_loc2_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass).openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.secureMode.error.default"),[I18n.getUiText("ui.common.ok")]);
            return;
         }
         var _loc4_:* = "http://go.ankama." + this._domainExtension + "/" + this._locale + "/go/dofus/complete-guest";
         var _loc5_:URLVariables;
         (_loc5_ = new URLVariables()).key = param1;
         if(SystemManager.getSingleton().browser == WebBrowserEnum.CHROME && ExternalInterface.available)
         {
            ExternalInterface.call("window.open",_loc4_ + "?" + _loc5_.toString(),"_blank");
         }
         else
         {
            (_loc3_ = new URLRequest(_loc4_)).method = URLRequestMethod.GET;
            _loc3_.data = _loc5_;
            navigateToURL(_loc3_,"_blank");
         }
      }
   }
}
