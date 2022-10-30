package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.display.DisplayObjectContainer;
   import flash.system.System;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class ClearSceneInstructionHandler implements ConsoleInstructionHandler
   {
       
      
      public function ClearSceneInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Array = null;
         var _loc10_:RoleplayEntitiesFrame = null;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         switch(param2)
         {
            case "clearscene":
               if(param3.length > 0)
               {
                  param1.output("No arguments needed.");
               }
               _loc4_ = Dofus.getInstance().getWorldContainer();
               while(_loc4_.numChildren > 0)
               {
                  _loc4_.removeChildAt(0);
               }
               param1.output("Scene cleared.");
               return;
            case "clearentities":
               _loc5_ = 0;
               for each(_loc11_ in EntitiesManager.getInstance().entities)
               {
                  _loc5_++;
               }
               param1.output("EntitiesManager : " + _loc5_ + " entities");
               Atouin.getInstance().clearEntities();
               Atouin.getInstance().display(PlayedCharacterManager.getInstance().currentMap);
               System.gc();
               setTimeout(this.asynchInfo,2000,param1);
               return;
            case "countentities":
               _loc6_ = 0;
               _loc7_ = 0;
               _loc8_ = 0;
               _loc9_ = EntitiesManager.getInstance().entities;
               for each(_loc12_ in _loc9_)
               {
                  _loc6_++;
                  if(_loc12_ is TiphonSprite)
                  {
                     if(_loc12_.id >= 0)
                     {
                        _loc7_++;
                     }
                     else
                     {
                        _loc8_++;
                     }
                  }
               }
               param1.output(_loc6_ + " entities : " + _loc7_ + " characters, " + _loc8_ + " monsters & npc.");
               if(_loc10_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame)
               {
                  param1.output("Switch to creature mode : " + _loc10_.entitiesNumber + " of " + _loc10_.creaturesLimit + " -> " + _loc10_.creaturesMode);
               }
               return;
            default:
               return;
         }
      }
      
      private function asynchInfo(param1:ConsoleHandler) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Dictionary = TiphonSprite.MEMORY_LOG;
         for(_loc2_ in _loc3_)
         {
            param1.output(_loc2_ + " : " + TiphonSprite(_loc2_).look);
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "clearscene":
               return "Clear the World Scene.";
            case "clearentities":
               return "Clear all entities from the scene.";
            case "countentities":
               return "Count all entities from the scene.";
            default:
               return "No help for command \'" + param1 + "\'";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         return [];
      }
   }
}
