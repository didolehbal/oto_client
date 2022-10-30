package com.ankamagames.dofus.logic.game.fight.miscs
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.network.enums.GameActionFightInvisibilityStateEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.context.FightEntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.types.positions.PathElement;
   
   public class TackleUtil
   {
       
      
      public function TackleUtil()
      {
         super();
      }
      
      public static function getTackle(param1:GameFightFighterInformations, param2:MapPoint) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:CharacterCharacteristicsInformations = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:Number = NaN;
         var _loc9_:IEntity = null;
         var _loc10_:GameFightFighterInformations = null;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc13_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         if(Constants.DETERMINIST_TACKLE)
         {
            if(!canBeTackled(param1,param2))
            {
               return 1;
            }
            _loc3_ = param2.x;
            _loc4_ = param2.y;
            _loc5_ = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations();
            if((_loc6_ = param1.stats.tackleEvade) < 0)
            {
               _loc6_ = 0;
            }
            _loc7_ = new Array();
            if(MapPoint.isInMap(_loc3_ - 1,_loc4_))
            {
               _loc7_.push(getTacklerOnCell(MapPoint.fromCoords(_loc3_ - 1,_loc4_).cellId));
            }
            if(MapPoint.isInMap(_loc3_ + 1,_loc4_))
            {
               _loc7_.push(getTacklerOnCell(MapPoint.fromCoords(_loc3_ + 1,_loc4_).cellId));
            }
            if(MapPoint.isInMap(_loc3_,_loc4_ - 1))
            {
               _loc7_.push(getTacklerOnCell(MapPoint.fromCoords(_loc3_,_loc4_ - 1).cellId));
            }
            if(MapPoint.isInMap(_loc3_,_loc4_ + 1))
            {
               _loc7_.push(getTacklerOnCell(MapPoint.fromCoords(_loc3_,_loc4_ + 1).cellId));
            }
            _loc8_ = 1;
            for each(_loc9_ in _loc7_)
            {
               if(_loc9_)
               {
                  _loc10_ = _loc13_.getEntityInfos(_loc9_.id) as GameFightFighterInformations;
                  if(canBeTackler(_loc10_,param1))
                  {
                     if((_loc11_ = _loc10_.stats.tackleBlock) < 0)
                     {
                        _loc11_ = 0;
                     }
                     if((_loc12_ = (_loc6_ + 2) / (_loc11_ + 2) / 2) < 1)
                     {
                        _loc8_ = _loc8_ * _loc12_;
                     }
                  }
               }
            }
            return _loc8_;
         }
         return 1;
      }
      
      public static function getTackleForFighter(param1:GameFightFighterInformations, param2:GameFightFighterInformations) : Number
      {
         if(!Constants.DETERMINIST_TACKLE)
         {
            return 1;
         }
         if(!canBeTackled(param2))
         {
            return 1;
         }
         if(!canBeTackler(param1,param2))
         {
            return 1;
         }
         var _loc3_:int = param2.stats.tackleEvade;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         var _loc4_:int;
         if((_loc4_ = param1.stats.tackleBlock) < 0)
         {
            _loc4_ = 0;
         }
         return (_loc3_ + 2) / (_loc4_ + 2) / 2;
      }
      
      public static function getTacklerOnCell(param1:int) : AnimatedCharacter
      {
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:GameFightFighterInformations = null;
         var _loc4_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         var _loc5_:Array = EntitiesManager.getInstance().getEntitiesOnCell(param1,AnimatedCharacter);
         for each(_loc2_ in _loc5_)
         {
            _loc3_ = _loc4_.getEntityInfos(_loc2_.id) as GameFightFighterInformations;
            if(_loc3_.disposition is FightEntityDispositionInformations)
            {
               if(!FightersStateManager.getInstance().hasState(_loc2_.id,8))
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public static function canBeTackled(param1:GameFightFighterInformations, param2:MapPoint = null) : Boolean
      {
         var _loc3_:FightEntityDispositionInformations = null;
         if(FightersStateManager.getInstance().hasState(param1.contextualId,96) || FightersStateManager.getInstance().hasState(param1.contextualId,6) || param1.stats.invisibilityState == GameActionFightInvisibilityStateEnum.INVISIBLE || param1.stats.invisibilityState == GameActionFightInvisibilityStateEnum.DETECTED)
         {
            return false;
         }
         if(param1.disposition is FightEntityDispositionInformations)
         {
            _loc3_ = param1.disposition as FightEntityDispositionInformations;
            if(_loc3_.carryingCharacterId && (!param2 || param1.disposition.cellId == param2.cellId))
            {
               return false;
            }
         }
         return true;
      }
      
      public static function canBeTackler(param1:GameFightFighterInformations, param2:GameFightFighterInformations) : Boolean
      {
         var _loc3_:Monster = null;
         if(FightersStateManager.getInstance().hasState(param1.contextualId,8) || FightersStateManager.getInstance().hasState(param1.contextualId,6) || FightersStateManager.getInstance().hasState(param1.contextualId,95) || param1.stats.invisibilityState == GameActionFightInvisibilityStateEnum.INVISIBLE || param1.stats.invisibilityState == GameActionFightInvisibilityStateEnum.DETECTED)
         {
            return false;
         }
         var _loc5_:GameFightFighterInformations;
         var _loc4_:FightEntitiesFrame;
         if((_loc5_ = (_loc4_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).getEntityInfos(param1.contextualId) as GameFightFighterInformations) && _loc5_.teamId == param2.teamId)
         {
            return false;
         }
         if(param1 is GameFightMonsterInformations)
         {
            _loc3_ = Monster.getMonsterById((param1 as GameFightMonsterInformations).creatureGenericId);
            if(!_loc3_.canTackle)
            {
               return false;
            }
         }
         if(!param1.alive)
         {
            return false;
         }
         return true;
      }
      
      public static function isTackling(param1:GameFightFighterInformations, param2:GameFightFighterInformations, param3:MovementPath) : Boolean
      {
         var _loc4_:PathElement = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:AnimatedCharacter = null;
         var _loc12_:Boolean = false;
         if(param3 && canBeTackler(param2,param1))
         {
            for each(_loc4_ in param3.path)
            {
               if(canBeTackled(param1,_loc4_.step))
               {
                  _loc5_ = _loc4_.step.x;
                  _loc6_ = _loc4_.step.y;
                  _loc9_ = _loc5_ - 1;
                  while(_loc9_ <= _loc5_ + 1)
                  {
                     _loc10_ = _loc6_ - 1;
                     while(_loc10_ <= _loc6_ + 1)
                     {
                        if((_loc11_ = getTacklerOnCell(MapPoint.fromCoords(_loc9_,_loc10_).cellId)) && _loc11_.id == param2.contextualId)
                        {
                           _loc7_ = param1.stats.tackleEvade < 0?0:int(param1.stats.tackleEvade);
                           _loc8_ = param2.stats.tackleBlock < 0?0:int(param2.stats.tackleBlock);
                           return (_loc7_ + 2) / (_loc8_ + 2) / 2 < 1;
                        }
                        _loc10_++;
                     }
                     _loc9_++;
                  }
               }
            }
         }
         return _loc12_;
      }
   }
}
