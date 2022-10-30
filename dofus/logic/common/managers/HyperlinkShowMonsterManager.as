package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class HyperlinkShowMonsterManager
   {
       
      
      public function HyperlinkShowMonsterManager()
      {
         super();
      }
      
      public static function showMonster(param1:int, param2:int = 0) : Sprite
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Dictionary = null;
         var _loc6_:Object = null;
         var _loc7_:RoleplayEntitiesFrame;
         if(_loc7_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame)
         {
            _loc5_ = _loc7_.getEntitiesDictionnary();
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_ is GameRolePlayGroupMonsterInformations && (_loc6_.staticInfos.mainCreatureLightInfos.creatureGenericId == param1 || param1 == -1))
               {
                  _loc3_ = DofusEntities.getEntity(GameRolePlayGroupMonsterInformations(_loc6_).contextualId) as DisplayObject;
                  if(_loc3_ && _loc3_.stage)
                  {
                     return HyperlinkDisplayArrowManager.showAbsoluteArrow(new Rectangle(_loc3_.x,_loc3_.y - 80,0,0),0,0,1,param2);
                  }
                  return null;
               }
               if(_loc6_ is GameFightMonsterInformations && (_loc6_.creatureGenericId == param1 || param1 == -1))
               {
                  _loc3_ = DofusEntities.getEntity(GameFightMonsterInformations(_loc6_).contextualId) as DisplayObject;
                  if(_loc3_ && _loc3_.stage)
                  {
                     _loc4_ = _loc3_.getRect(Berilia.getInstance().docMain);
                     return HyperlinkDisplayArrowManager.showAbsoluteArrow(_loc4_,0,0,1,param2);
                  }
                  return null;
               }
            }
         }
         return null;
      }
      
      public static function getMonsterName(param1:uint) : String
      {
         var _loc2_:Monster = Monster.getMonsterById(param1);
         if(_loc2_)
         {
            return _loc2_.name;
         }
         return "[null]";
      }
   }
}
