package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.network.messages.authorized.AdminQuietCommandMessage;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.utils.Dictionary;
   
   public class TiphonInstructionHandler implements ConsoleInstructionHandler
   {
      
      private static var _monsters:Dictionary;
      
      private static var _monsterNameList:Array;
       
      
      public function TiphonInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:AdminQuietCommandMessage = null;
         switch(param2)
         {
            case "additem":
               if(param3.length != 0)
               {
                  param1.output("need 1 parameter (item ID)");
               }
               (DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as TiphonSprite).look.addSkin(parseInt(param3[0]));
               return;
            case "looklike":
               if(!_monsters)
               {
                  this.parseMonster();
               }
               _loc4_ = param3.join(" ").toLowerCase().split(" {npc}").join("").split(" {monster}").join("");
               if(_monsters[_loc4_])
               {
                  param1.output("look like " + _monsters[_loc4_]);
                  (_loc5_ = new AdminQuietCommandMessage()).initAdminQuietCommandMessage("look * " + _monsters[_loc4_]);
                  if(PlayerManager.getInstance().hasRights)
                  {
                     ConnectionsHandler.getConnection().send(_loc5_);
                  }
               }
               return;
            default:
               return;
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "looklike":
               return "look a npc or monster, param is monser\'s or pnc\'s name, you can use autocompletion";
            default:
               return null;
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         switch(param1)
         {
            case "looklike":
               if(!_monsters)
               {
                  this.parseMonster();
               }
               _loc4_ = [];
               _loc5_ = param3.join(" ").toLowerCase();
               for each(_loc6_ in _monsterNameList)
               {
                  if(_loc6_.indexOf(_loc5_) != -1)
                  {
                     _loc4_.push(_loc6_);
                  }
               }
               return _loc4_;
            default:
               return [];
         }
      }
      
      private function parseMonster() : void
      {
         var _loc1_:Monster = null;
         var _loc2_:Npc = null;
         _monsters = new Dictionary();
         _monsterNameList = [];
         var _loc3_:Array = Monster.getMonsters();
         for each(_loc1_ in _loc3_)
         {
            _monsterNameList.push(_loc1_.name.toLowerCase() + " {monster}");
            _monsters[_loc1_.name.toLowerCase()] = _loc1_.look;
         }
         _loc3_ = Npc.getNpcs();
         for each(_loc2_ in _loc3_)
         {
            _monsterNameList.push(_loc2_.name.toLowerCase() + " {npc}");
            _monsters[_loc2_.name.toLowerCase()] = _loc2_.look;
         }
      }
   }
}
