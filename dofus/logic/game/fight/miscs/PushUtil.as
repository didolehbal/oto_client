package com.ankamagames.dofus.logic.game.fight.miscs
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellZoneManager;
   import com.ankamagames.dofus.logic.game.fight.types.PushedEntity;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class PushUtil
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(PushUtil));
      
      private static const PUSH_EFFECT_ID:uint = 5;
      
      private static const PULL_EFFECT_ID:uint = 6;
      
      private static var _updatedEntitiesPositions:Dictionary = new Dictionary();
      
      private static var _pushSpells:Vector.<int> = new Vector.<int>(0);
       
      
      public function PushUtil()
      {
         super();
      }
      
      public static function reset() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in _updatedEntitiesPositions)
         {
            delete _updatedEntitiesPositions[_loc1_];
         }
         _pushSpells.length = 0;
      }
      
      public static function getPushedEntities(param1:SpellWrapper, param2:int, param3:int) : Vector.<PushedEntity>
      {
         var _loc4_:Vector.<PushedEntity> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:EffectInstance = null;
         var _loc8_:EffectInstanceDice = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:IEntity = null;
         var _loc12_:int = 0;
         var _loc13_:Vector.<IEntity> = null;
         var _loc14_:Boolean = false;
         var _loc15_:int = 0;
         var _loc16_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         for each(_loc7_ in param1.effects)
         {
            if(_loc7_.effectId == PUSH_EFFECT_ID)
            {
               _loc5_ = (_loc8_ = _loc7_ as EffectInstanceDice).diceNum;
               _loc6_ = _loc8_.zoneShape;
               break;
            }
         }
         if(_loc5_ == 0)
         {
            return null;
         }
         var _loc17_:IZone;
         var _loc18_:Vector.<uint> = (_loc17_ = SpellZoneManager.getInstance().getSpellZone(param1)).getCells(param3);
         _loc9_ = !!hasMinSize(_loc6_)?uint(param3):uint(param2);
         var _loc19_:MapPoint = MapPoint.fromCellId(_loc9_);
         var _loc20_:Dictionary = new Dictionary();
         if(_pushSpells.indexOf(param1.id) == -1)
         {
            _pushSpells.push(param1.id);
            _loc14_ = true;
         }
         for each(_loc10_ in _loc18_)
         {
            if(_loc10_ != param2 || param2 != param3)
            {
               if(_loc11_ = EntitiesManager.getInstance().getEntityOnCell(_loc10_,AnimatedCharacter))
               {
                  _loc12_ = _loc19_.advancedOrientationTo(_loc11_.position,false);
                  if(!_loc20_[_loc12_])
                  {
                     _loc11_ = !!(_loc13_ = getEntitiesInDirection(_loc19_.cellId,_loc17_.radius,_loc12_))?_loc13_[0]:_loc11_;
                     _loc20_[_loc12_] = true;
                     if(!_loc4_)
                     {
                        _loc4_ = new Vector.<PushedEntity>(0);
                     }
                     _loc15_ = getPushForce(_loc9_,_loc16_.getEntityInfos(_loc11_.id) as GameFightFighterInformations,param1.effects,_loc8_);
                     _loc4_ = _loc4_.concat(getPushedEntitiesInLine(param1,_loc14_,_loc8_,param3,_loc11_.position.cellId,_loc15_,_loc12_));
                  }
               }
            }
         }
         return _loc4_;
      }
      
      private static function getPushedEntitiesInLine(param1:SpellWrapper, param2:Boolean, param3:EffectInstance, param4:int, param5:int, param6:int, param7:int) : Vector.<PushedEntity>
      {
         var pushedEntities:Vector.<PushedEntity> = null;
         var entity:IEntity = null;
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         var previousCell:MapPoint = null;
         var entities:Vector.<IEntity> = null;
         var entityInfo:GameFightFighterInformations = null;
         var entityPushable:Boolean = false;
         var nextCellEntity:IEntity = null;
         var nextCellEntityInfo:GameFightFighterInformations = null;
         var nextEntityPushable:Boolean = false;
         var pushedIndex:int = 0;
         var pushingEntity:PushedEntity = null;
         var firstPushingEntity:PushedEntity = null;
         var pushedEntity:PushedEntity = null;
         var emptyCells:Vector.<int> = null;
         var entityInSpellZone:Boolean = false;
         var cell:MapPoint = null;
         var entityCell:uint = 0;
         var forceReduction:int = 0;
         var pSpell:SpellWrapper = param1;
         var pNewSpell:Boolean = param2;
         var pPushEffect:EffectInstance = param3;
         var pSpellImpactCell:int = param4;
         var pStartCell:int = param5;
         var pPushForce:int = param6;
         var pDirection:int = param7;
         pushedEntities = new Vector.<PushedEntity>(0);
         var cellMp:MapPoint = MapPoint.fromCellId(pStartCell);
         var nextCell:MapPoint = cellMp.getNearestCellInDirection(pDirection);
         var force:int = pPushForce;
         i = 0;
         while(i < pPushForce)
         {
            if(nextCell)
            {
               if(isBlockingCell(nextCell.cellId,!!previousCell?int(previousCell.cellId):int(cellMp.cellId)))
               {
                  break;
               }
               force--;
               previousCell = nextCell;
               nextCell = nextCell.getNearestCellInDirection(pDirection);
            }
            i = i + 1;
         }
         previousCell = null;
         if(force <= 0)
         {
            return pushedEntities;
         }
         entities = new Vector.<IEntity>(0);
         entities.push(EntitiesManager.getInstance().getEntityOnCell(pStartCell,AnimatedCharacter));
         var spellZone:IZone = SpellZoneManager.getInstance().getSpellZone(pSpell);
         var spellZoneCells:Vector.<uint> = spellZone.getCells(pSpellImpactCell);
         if(force == pPushForce)
         {
            while(cellMp)
            {
               cellMp = cellMp.getNearestCellInDirection(pDirection);
               if(cellMp)
               {
                  entity = EntitiesManager.getInstance().getEntityOnCell(cellMp.cellId,AnimatedCharacter);
                  if(!(entity && spellZoneCells.indexOf(cellMp.cellId) != -1))
                  {
                     break;
                  }
                  entities.push(entity);
               }
            }
         }
         var getPushedEntity:Function = function(param1:int):PushedEntity
         {
            var _loc2_:PushedEntity = null;
            for each(_loc2_ in pushedEntities)
            {
               if(_loc2_.id == param1)
               {
                  return _loc2_;
               }
            }
            return null;
         };
         var isEntityInSpellZone:Function = function(param1:int):Boolean
         {
            var _loc2_:IEntity = null;
            for each(_loc2_ in entities)
            {
               if(_loc2_.id == param1)
               {
                  return true;
               }
            }
            return false;
         };
         var fightEntitiesFrame:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         var nbEntities:int = entities.length;
         var casterInfos:GameFightFighterInformations = fightEntitiesFrame.getEntityInfos(pSpell.playerId) as GameFightFighterInformations;
         i = 0;
         while(i < nbEntities)
         {
            entityCell = pNewSpell && _updatedEntitiesPositions[entities[i].id]?uint(_updatedEntitiesPositions[entities[i].id]):uint(entities[i].position.cellId);
            cellMp = MapPoint.fromCellId(entityCell);
            entityInfo = fightEntitiesFrame.getEntityInfos(entities[i].id) as GameFightFighterInformations;
            entityPushable = isPushableEntity(entityInfo);
            pushedIndex = 0;
            if(entityPushable && DamageUtil.verifySpellEffectZone(entities[i].id,pPushEffect,pSpellImpactCell,casterInfos.disposition.cellId) && DamageUtil.verifySpellEffectMask(pSpell.playerId,entities[i].id,pPushEffect,pSpellImpactCell))
            {
               pushingEntity = getPushedEntity(entities[i].id);
               if(!pushingEntity)
               {
                  pushingEntity = new PushedEntity(entities[i].id,pushedIndex,pPushForce);
                  pushedEntities.push(pushingEntity);
                  if(!firstPushingEntity)
                  {
                     firstPushingEntity = pushingEntity;
                  }
               }
               else
               {
                  pushingEntity.pushedIndexes.push(pushedIndex);
               }
               pushedIndex = pushedIndex + 1;
               j = 0;
               while(j < pPushForce)
               {
                  if(j == 0)
                  {
                     previousCell = cellMp;
                     nextCell = cellMp.getNearestCellInDirection(pDirection);
                  }
                  else if(nextCell)
                  {
                     previousCell = nextCell;
                     nextCell = nextCell.getNearestCellInDirection(pDirection);
                  }
                  if(nextCell)
                  {
                     if(isBlockingCell(nextCell.cellId,previousCell.cellId))
                     {
                        nextCellEntity = EntitiesManager.getInstance().getEntityOnCell(nextCell.cellId,AnimatedCharacter);
                        if(nextCellEntity)
                        {
                           entityInSpellZone = isEntityInSpellZone(nextCellEntity.id);
                           nextCellEntityInfo = fightEntitiesFrame.getEntityInfos(nextCellEntity.id) as GameFightFighterInformations;
                           nextEntityPushable = isPushableEntity(nextCellEntityInfo);
                           if(nextEntityPushable)
                           {
                              if(entityInSpellZone && !isPathBlocked(nextCell.cellId,getCellIdInDirection(nextCell.cellId,pPushForce,pDirection),pDirection))
                              {
                                 pushingEntity.force = 0;
                                 break;
                              }
                           }
                           pushedEntity = getPushedEntity(nextCellEntity.id);
                           if(!pushedEntity)
                           {
                              pushedEntity = new PushedEntity(nextCellEntity.id,pushedIndex,pPushForce);
                              pushedEntity.pushingEntity = firstPushingEntity;
                              pushedEntities.push(pushedEntity);
                           }
                           else
                           {
                              pushedEntity.pushedIndexes.push(pushedIndex);
                           }
                           pushedIndex = pushedIndex + 1;
                        }
                        else if(j == 0)
                        {
                           break;
                        }
                        if(!entityInSpellZone)
                        {
                           cell = nextCell.getNearestCellInDirection(pDirection);
                           if(cell && !isBlockingCell(cell.cellId,nextCell.cellId))
                           {
                              break;
                           }
                        }
                     }
                     else if(j != pPushForce - 1 && (!nextCellEntity || entities.indexOf(nextCellEntity) != -1) && isPathBlocked(nextCell.cellId,getCellIdInDirection(cellMp.cellId,pPushForce,pDirection),pDirection))
                     {
                        if(!emptyCells)
                        {
                           emptyCells = new Vector.<int>(0);
                        }
                        if(emptyCells.indexOf(nextCell.cellId) == -1)
                        {
                           emptyCells.push(nextCell.cellId);
                        }
                     }
                     else if(!isPathBlocked(cellMp.cellId,getCellIdInDirection(cellMp.cellId,pPushForce,pDirection),pDirection))
                     {
                        pushingEntity.force = 0;
                     }
                     if(pushingEntity.force == 0)
                     {
                        break;
                     }
                  }
                  j = j + 1;
               }
               _updatedEntitiesPositions[entities[i].id] = previousCell.cellId;
            }
            i = i + 1;
         }
         if(emptyCells)
         {
            forceReduction = emptyCells.length;
            if(forceReduction > 0)
            {
               for each(pushedEntity in pushedEntities)
               {
                  pushedEntity.force = pushedEntity.force - forceReduction;
               }
            }
         }
         return pushedEntities;
      }
      
      private static function getPushForce(param1:int, param2:GameFightFighterInformations, param3:Vector.<EffectInstance>, param4:EffectInstance) : int
      {
         var _loc5_:int = 0;
         var _loc6_:EffectInstanceDice = null;
         var _loc7_:EffectInstance = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:MapPoint = null;
         var _loc11_:MapPoint = null;
         var _loc12_:MapPoint = null;
         var _loc13_:MapPoint = null;
         var _loc14_:uint = 0;
         var _loc15_:int = 0;
         var _loc16_:uint = 0;
         var _loc17_:int = param3.indexOf(param4);
         var _loc18_:int = -1;
         for each(_loc7_ in param3)
         {
            if(_loc7_.effectId == PULL_EFFECT_ID)
            {
               _loc18_ = param3.indexOf(_loc7_);
               _loc6_ = _loc7_ as EffectInstanceDice;
               break;
            }
         }
         _loc8_ = (param4 as EffectInstanceDice).diceNum;
         if(_loc18_ != -1 && _loc18_ < _loc17_ && isPushableEntity(param2))
         {
            _loc9_ = _loc6_.diceNum;
            _loc10_ = MapPoint.fromCellId(param2.disposition.cellId);
            _loc11_ = MapPoint.fromCellId(param1);
            _loc12_ = _loc10_;
            _loc14_ = _loc10_.advancedOrientationTo(_loc11_);
            _loc16_ = 0;
            _loc15_ = 0;
            while(_loc15_ < _loc9_)
            {
               if(!((_loc13_ = _loc12_.getNearestCellInDirection(_loc14_)) && !isBlockingCell(_loc13_.cellId,_loc12_.cellId)))
               {
                  break;
               }
               _loc16_++;
               _loc12_ = _loc13_;
               _loc15_++;
            }
            _loc5_ = _loc8_ - _loc16_;
         }
         else
         {
            _loc5_ = _loc8_;
         }
         return _loc5_;
      }
      
      private static function hasMinSize(param1:int) : Boolean
      {
         return param1 == SpellShapeEnum.C || param1 == SpellShapeEnum.X || param1 == SpellShapeEnum.Q || param1 == SpellShapeEnum.plus || param1 == SpellShapeEnum.sharp;
      }
      
      public static function hasPushDamages(param1:int, param2:int, param3:Vector.<EffectInstance>, param4:EffectInstance, param5:int) : Boolean
      {
         var _loc6_:GameFightFighterInformations = null;
         var _loc7_:uint = 0;
         var _loc8_:MapPoint = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:MapPoint = null;
         var _loc12_:MapPoint = null;
         var _loc13_:MapPoint = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         if(param4.effectId != PUSH_EFFECT_ID || !_loc16_)
         {
            return false;
         }
         var _loc17_:GameFightFighterInformations;
         if((_loc17_ = _loc16_.getEntityInfos(param2) as GameFightFighterInformations) && isPushableEntity(_loc17_))
         {
            _loc6_ = _loc16_.getEntityInfos(param1) as GameFightFighterInformations;
            _loc7_ = !!hasMinSize(param4.zoneShape)?uint(param5):uint(_loc6_.disposition.cellId);
            _loc9_ = (_loc8_ = MapPoint.fromCellId(_loc7_)).advancedOrientationTo(MapPoint.fromCellId(_loc17_.disposition.cellId),false);
            _loc10_ = getPushForce(_loc7_,_loc17_,param3,param4);
            _loc13_ = (_loc11_ = MapPoint.fromCellId(_loc17_.disposition.cellId)).getNearestCellInDirection(_loc9_);
            _loc14_ = _loc10_;
            _loc15_ = 0;
            while(_loc15_ < _loc10_)
            {
               if(_loc13_)
               {
                  if(isBlockingCell(_loc13_.cellId,!!_loc12_?int(_loc12_.cellId):int(_loc11_.cellId)))
                  {
                     break;
                  }
                  _loc14_--;
                  _loc12_ = _loc13_;
                  _loc13_ = _loc13_.getNearestCellInDirection(_loc9_);
               }
               _loc15_++;
            }
            return _loc14_ > 0;
         }
         return false;
      }
      
      public static function isBlockingCell(param1:int, param2:int, param3:Boolean = true) : Boolean
      {
         var _loc4_:MapPoint = null;
         var _loc5_:MapPoint = null;
         var _loc6_:uint = 0;
         var _loc7_:MapPoint = null;
         var _loc8_:MapPoint = null;
         var _loc10_:Boolean;
         var _loc9_:GraphicCell;
         if(!(_loc10_ = (_loc9_ = InteractiveCellManager.getInstance().getCell(param1)) && !_loc9_.visible || EntitiesManager.getInstance().getEntityOnCell(param1,AnimatedCharacter)) && param3)
         {
            _loc4_ = MapPoint.fromCellId(param2);
            _loc5_ = MapPoint.fromCellId(param1);
            if((_loc6_ = _loc4_.orientationTo(_loc5_)) % 2 == 0)
            {
               switch(_loc6_)
               {
                  case DirectionsEnum.RIGHT:
                     _loc7_ = _loc5_.getNearestCellInDirection(DirectionsEnum.UP_LEFT);
                     _loc8_ = _loc5_.getNearestCellInDirection(DirectionsEnum.DOWN_LEFT);
                     break;
                  case DirectionsEnum.DOWN:
                     _loc7_ = _loc5_.getNearestCellInDirection(DirectionsEnum.UP_LEFT);
                     _loc8_ = _loc5_.getNearestCellInDirection(DirectionsEnum.UP_RIGHT);
                     break;
                  case DirectionsEnum.LEFT:
                     _loc7_ = _loc5_.getNearestCellInDirection(DirectionsEnum.UP_RIGHT);
                     _loc8_ = _loc5_.getNearestCellInDirection(DirectionsEnum.DOWN_RIGHT);
                     break;
                  case DirectionsEnum.UP:
                     _loc7_ = _loc5_.getNearestCellInDirection(DirectionsEnum.DOWN_LEFT);
                     _loc8_ = _loc5_.getNearestCellInDirection(DirectionsEnum.DOWN_RIGHT);
               }
               _loc10_ = _loc7_ && isBlockingCell(_loc7_.cellId,-1,false) || _loc8_ && isBlockingCell(_loc8_.cellId,-1,false);
            }
         }
         return _loc10_;
      }
      
      public static function isPathBlocked(param1:int, param2:int, param3:int) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc5_:MapPoint = null;
         var _loc6_:MapPoint = MapPoint.fromCellId(param1);
         while(_loc6_ && !_loc4_)
         {
            _loc5_ = _loc6_;
            if(_loc6_ = _loc6_.getNearestCellInDirection(param3))
            {
               _loc4_ = isBlockingCell(_loc6_.cellId,_loc5_.cellId);
               if(_loc6_.cellId == param2)
               {
                  break;
               }
               continue;
            }
            return true;
         }
         return _loc4_;
      }
      
      public static function getCellIdInDirection(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:MapPoint = MapPoint.fromCellId(param1);
         _loc5_ = 0;
         while(_loc5_ < param2)
         {
            if(!(_loc6_ = _loc6_.getNearestCellInDirection(param3)))
            {
               return -1;
            }
            _loc5_++;
         }
         return _loc6_.cellId;
      }
      
      public static function getEntitiesInDirection(param1:int, param2:int, param3:int) : Vector.<IEntity>
      {
         var _loc4_:Vector.<IEntity> = null;
         var _loc5_:IEntity = null;
         var _loc8_:int = 0;
         var _loc6_:MapPoint;
         var _loc7_:MapPoint = (_loc6_ = MapPoint.fromCellId(param1)).getNearestCellInDirection(param3);
         while(_loc7_ && _loc8_ < param2)
         {
            if(_loc5_ = EntitiesManager.getInstance().getEntityOnCell(_loc7_.cellId,AnimatedCharacter))
            {
               if(!_loc4_)
               {
                  _loc4_ = new Vector.<IEntity>(0);
               }
               _loc4_.push(_loc5_);
            }
            _loc7_ = _loc7_.getNearestCellInDirection(param3);
            _loc8_++;
         }
         return _loc4_;
      }
      
      public static function isPushableEntity(param1:GameFightFighterInformations) : Boolean
      {
         var _loc2_:Monster = null;
         var _loc3_:Array = FightersStateManager.getInstance().getStates(param1.contextualId);
         var _loc4_:Boolean = _loc3_ && (_loc3_.indexOf(6) != -1 || _loc3_.indexOf(97) != -1);
         var _loc5_:Boolean = true;
         if(param1 is GameFightMonsterInformations)
         {
            _loc2_ = Monster.getMonsterById((param1 as GameFightMonsterInformations).creatureGenericId);
            _loc5_ = _loc2_.canBePushed;
         }
         return !_loc4_ && _loc5_;
      }
   }
}
