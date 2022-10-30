package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterNamedInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class AccountManager
   {
      
      private static var _singleton:AccountManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AccountManager));
       
      
      private var _accounts:Dictionary;
      
      public function AccountManager()
      {
         super();
         this._accounts = new Dictionary();
      }
      
      public static function getInstance() : AccountManager
      {
         if(!_singleton)
         {
            _singleton = new AccountManager();
         }
         return _singleton;
      }
      
      public function getIsKnowAccount(param1:String) : Boolean
      {
         return this._accounts.hasOwnProperty(param1);
      }
      
      public function getAccountId(param1:String) : int
      {
         if(this._accounts[param1])
         {
            return this._accounts[param1].id;
         }
         return 0;
      }
      
      public function getAccountName(param1:String) : String
      {
         if(this._accounts[param1])
         {
            return this._accounts[param1].name;
         }
         return "";
      }
      
      public function setAccount(param1:String, param2:int, param3:String = null) : void
      {
         this._accounts[param1] = {
            "id":param2,
            "name":param3
         };
      }
      
      public function setAccountFromId(param1:int, param2:int, param3:String = null) : void
      {
         var _loc4_:GameRolePlayNamedActorInformations = null;
         var _loc5_:FightEntitiesFrame = null;
         var _loc6_:GameFightFighterNamedInformations = null;
         var _loc7_:RoleplayEntitiesFrame;
         if(_loc7_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame)
         {
            if(_loc4_ = _loc7_.getEntityInfos(param1) as GameRolePlayNamedActorInformations)
            {
               this._accounts[_loc4_.name] = {
                  "id":param2,
                  "name":param3
               };
            }
         }
         else if(_loc5_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame)
         {
            if(_loc6_ = _loc5_.getEntityInfos(param1) as GameFightFighterNamedInformations)
            {
               this._accounts[_loc6_.name] = {
                  "id":param2,
                  "name":param3
               };
            }
         }
      }
   }
}
