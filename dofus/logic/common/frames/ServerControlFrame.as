package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.misc.OptionalFeature;
   import com.ankamagames.dofus.datacenter.misc.Url;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.shield.SecureModeManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.messages.game.script.URLOpenMessage;
   import com.ankamagames.dofus.network.messages.secure.TrustStatusMessage;
   import com.ankamagames.dofus.network.messages.security.RawDataMessage;
   import com.ankamagames.dofusModuleLibrary.enum.WebLocationEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.crypto.Signature;
   import com.ankamagames.jerakine.utils.crypto.SignatureKey;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.hurlant.crypto.rsa.RSAKey;
   import com.hurlant.util.der.PEM;
   import flash.display.Loader;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class ServerControlFrame implements Frame
   {
      
      private static const PUBLIC_KEY_V1:Class = ServerControlFrame_PUBLIC_KEY_V1;
      
      private static const SIGNATURE_KEY_V1:SignatureKey = SignatureKey.fromByte(new PUBLIC_KEY_V1() as ByteArray);
      
      private static const PUBLIC_KEY_V2:Class = ServerControlFrame_PUBLIC_KEY_V2;
      
      private static var SIGNATURE_KEY_V2:RSAKey;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ServerControlFrame));
       
      
      public function ServerControlFrame()
      {
         super();
         var _loc1_:ByteArray = new PUBLIC_KEY_V2() as ByteArray;
         SIGNATURE_KEY_V2 = PEM.readRSAPublicKey(_loc1_.readUTFBytes(_loc1_.bytesAvailable));
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:RawDataMessage = null;
         var _loc3_:ByteArray = null;
         var _loc4_:Signature = null;
         var _loc5_:URLOpenMessage = null;
         var _loc6_:Url = null;
         var _loc7_:TrustStatusMessage = null;
         var _loc8_:Loader = null;
         var _loc9_:LoaderContext = null;
         var _loc10_:URLRequest = null;
         var _loc11_:MiscFrame = null;
         var _loc12_:OptionalFeature = null;
         switch(true)
         {
            case param1 is RawDataMessage:
               _loc2_ = param1 as RawDataMessage;
               _loc8_ = new Loader();
               _loc9_ = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
               AirScanner.allowByteCodeExecution(_loc9_,true);
               _loc8_.loadBytes(_loc2_.content,_loc9_);
               return true;
            case param1 is URLOpenMessage:
               _loc5_ = param1 as URLOpenMessage;
               _loc6_ = Url.getUrlById(_loc5_.urlId);
               switch(_loc6_.browserId)
               {
                  case 1:
                     (_loc10_ = new URLRequest(_loc6_.url)).method = _loc6_.method == ""?"GET":_loc6_.method.toUpperCase();
                     _loc10_.data = _loc6_.variables;
                     navigateToURL(_loc10_);
                     return true;
                  case 2:
                     KernelEventsManager.getInstance().processCallback(HookList.OpenWebPortal,WebLocationEnum.WEB_LOCATION_OGRINE);
                     return true;
                  case 3:
                     return true;
                  case 4:
                     if(HookList[_loc6_.url])
                     {
                        _loc11_ = Kernel.getWorker().getFrame(MiscFrame) as MiscFrame;
                        _loc12_ = OptionalFeature.getOptionalFeatureByKeyword("game.krosmasterGameInClient");
                        if(_loc11_ && _loc12_ && !_loc11_.isOptionalFeatureActive(_loc12_.id) && HookList.OpenKrosmaster == HookList[_loc6_.url])
                        {
                           _log.error("Tentative de lancement de Krosmaster, cependant la feature n\'est pas active");
                           return true;
                        }
                        KernelEventsManager.getInstance().processCallback(HookList[_loc6_.url]);
                     }
                     return true;
                  default:
                     return true;
               }
               break;
            case param1 is TrustStatusMessage:
               _loc7_ = param1 as TrustStatusMessage;
               SecureModeManager.getInstance().active = !_loc7_.trusted;
               PlayerManager.getInstance().isSafe = _loc7_.certified;
               return true;
            default:
               return false;
         }
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
   }
}
