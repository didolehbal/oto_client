package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.managers.UiSoundManager;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.datacenter.sounds.SoundUiHook;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.manager.ClassicSoundManager;
   import com.ankamagames.dofus.kernel.sound.manager.RegConnectionManager;
   import com.ankamagames.dofus.kernel.sound.manager.RegSoundManager;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.protocolAudio.ProtocolEnum;
   import flash.utils.getQualifiedClassName;
   
   public class SoundInstructionHandler implements ConsoleInstructionHandler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SoundInstructionHandler));
       
      
      public function SoundInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:Boolean = false;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         switch(param2)
         {
            case "playmusic":
               if(param3.length != 2)
               {
                  param1.output("COMMAND FAILED ! playmusic must have followings parameters : \n-id\n-volume");
                  return;
               }
               _loc5_ = param3[0];
               _loc6_ = param3[1];
               _loc7_ = true;
               SoundManager.getInstance().manager.playAdminSound(_loc5_,_loc6_,_loc7_,0);
               return;
               break;
            case "stopmusic":
               SoundManager.getInstance().manager.removeAllSounds();
               return;
            case "playambiance":
               if(param3.length != 2)
               {
                  param1.output("COMMAND FAILED ! playambiance must have followings parameters : \n-id\n-volume");
                  return;
               }
               _loc8_ = param3[0];
               _loc9_ = param3[1];
               _loc10_ = true;
               SoundManager.getInstance().manager.playAdminSound(_loc8_,_loc9_,_loc10_,1);
               return;
               break;
            case "stopambiance":
               SoundManager.getInstance().manager.stopAdminSound(1);
               return;
            case "addsoundinplaylist":
               if(param3.length != 4)
               {
                  param1.output("addSoundInPLaylist must have followings parameters : \n-id\n-volume\n-silenceMin\n-SilenceMax");
                  return;
               }
               _loc4_ = param3[0];
               _loc11_ = param3[1];
               _loc12_ = param3[2];
               _loc13_ = param3[3];
               if(!SoundManager.getInstance().manager.addSoundInPlaylist(_loc4_,_loc11_,_loc12_,_loc13_))
               {
                  param1.output("addSoundInPLaylist failed !");
               }
               return;
               break;
            case "stopplaylist":
               if(param3.length != 0)
               {
                  param1.output("stopplaylist doesn\'t accept any paramter");
                  return;
               }
               SoundManager.getInstance().manager.stopPlaylist();
               return;
               break;
            case "playplaylist":
               if(param3.length != 0)
               {
                  param1.output("removeSoundInPLaylist doesn\'t accept any paramter");
                  return;
               }
               SoundManager.getInstance().manager.playPlaylist();
               return;
               break;
            case "activesounds":
               if(SoundManager.getInstance().manager is ClassicSoundManager)
               {
                  (SoundManager.getInstance().manager as ClassicSoundManager).forceSoundsDebugMode = true;
               }
               if(SoundManager.getInstance().manager is RegSoundManager)
               {
                  (SoundManager.getInstance().manager as RegSoundManager).forceSoundsDebugMode = true;
               }
               return;
            case "clearsoundcache":
               RegConnectionManager.getInstance().send(ProtocolEnum.REMOVE_ALL_SOUNDS);
               RegConnectionManager.getInstance().send(ProtocolEnum.CLEAR_CACHE);
               return;
            case "adduisoundelement":
               if(param3.length < 4)
               {
                  param1.output("4 parameters needed");
                  return;
               }
               if(!UiSoundManager.getInstance().getUi(param3[0]))
               {
                  UiSoundManager.getInstance().registerUi(param3[0]);
               }
               UiSoundManager.getInstance().registerUiElement(param3[0],param3[1],param3[2],param3[3]);
               return;
               break;
            default:
               return;
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "playsound":
               return "Play a sound";
            case "clearsoundcache":
               return "Nettoye les fichiers pré-cachés pour le son afin de les relire directement depuis le disque lors de la prochaine demande de lecture";
            default:
               return "Unknown command \'" + param1 + "\'.";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:SoundUiHook = null;
         switch(param1)
         {
            case "adduisoundelement":
               if(param2 == 0)
               {
                  return this.getUiList(param3 && param3.length?param3[0]:null);
               }
               if(param2 == 2)
               {
                  _loc4_ = param3 && param3.length > 2?param3[2].toLowerCase():"";
                  _loc5_ = [];
                  _loc6_ = SoundUiHook.getSoundUiHooks();
                  for each(_loc7_ in _loc6_)
                  {
                     if(_loc7_.name.toLowerCase().indexOf(_loc4_) != -1)
                     {
                        _loc5_.push(_loc7_.name);
                     }
                  }
                  return _loc5_;
               }
               break;
         }
         return [];
      }
      
      private function getUiList(param1:String = null) : Array
      {
         var _loc2_:UiModule = null;
         var _loc3_:UiData = null;
         param1 = param1.toLowerCase();
         var _loc4_:Array = [];
         var _loc5_:Array = UiModuleManager.getInstance().getModules();
         for each(_loc2_ in _loc5_)
         {
            for each(_loc3_ in _loc2_.uis)
            {
               if(!param1 || _loc3_.name.toLowerCase().indexOf(param1) != -1)
               {
                  _loc4_.push(_loc3_.name);
               }
            }
         }
         _loc4_.sort();
         return _loc4_;
      }
      
      private function getParams(param1:Array, param2:Array) : Array
      {
         var _loc3_:* = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Array = [];
         for(_loc3_ in param1)
         {
            _loc4_ = parseInt(_loc3_);
            _loc5_ = param1[_loc4_];
            _loc6_ = param2[_loc4_];
            _loc7_[_loc4_] = this.getParam(_loc5_,_loc6_);
         }
         return _loc7_;
      }
      
      private function getParam(param1:String, param2:String) : *
      {
         switch(param2)
         {
            case "String":
               return param1;
            case "Boolean":
               return param1 == "true" || param1 == "1";
            case "int":
            case "uint":
               return parseInt(param1);
            default:
               _log.warn("Unsupported parameter type \'" + param2 + "\'.");
               return param1;
         }
      }
   }
}
