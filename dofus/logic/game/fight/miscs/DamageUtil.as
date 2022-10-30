package com.ankamagames.dofus.logic.game.fight.miscs
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceInteger;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceMinMax;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.monsters.MonsterGrade;
   import com.ankamagames.dofus.datacenter.spells.SpellBomb;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.logic.game.fight.managers.LinkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellZoneManager;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.EffectDamage;
   import com.ankamagames.dofus.logic.game.fight.types.EffectModification;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.logic.game.fight.types.PushedEntity;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamage;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamageInfo;
   import com.ankamagames.dofus.logic.game.fight.types.SplashDamage;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.logic.game.fight.types.TriggeredSpell;
   import com.ankamagames.dofus.network.enums.CharacterSpellModificationTypeEnum;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class DamageUtil
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(DamageUtil));
      
      private static const exclusiveTargetMasks:RegExp = /\*?[bBeEfFzZKoOPpTWUvV][0-9]*/g;
      
      public static const NEUTRAL_ELEMENT:int = 0;
      
      public static const EARTH_ELEMENT:int = 1;
      
      public static const FIRE_ELEMENT:int = 2;
      
      public static const WATER_ELEMENT:int = 3;
      
      public static const AIR_ELEMENT:int = 4;
      
      public static const NONE_ELEMENT:int = 5;
      
      public static const EFFECTSHAPE_DEFAULT_AREA_SIZE:int = 1;
      
      public static const EFFECTSHAPE_DEFAULT_MIN_AREA_SIZE:int = 0;
      
      public static const EFFECTSHAPE_DEFAULT_EFFICIENCY:int = 10;
      
      public static const EFFECTSHAPE_DEFAULT_MAX_EFFICIENCY_APPLY:int = 4;
      
      private static const DAMAGE_NOT_BOOSTED:int = 1;
      
      private static const UNLIMITED_ZONE_SIZE:int = 50;
      
      private static const AT_LEAST_MASK_TYPES:Array = ["B","F","Z"];
      
      public static const DAMAGE_EFFECT_CATEGORY:int = 2;
      
      public static const EROSION_DAMAGE_EFFECTS_IDS:Array = [1092,1093,1094,1095,1096];
      
      public static const HEALING_EFFECTS_IDS:Array = [81,108,1109,90];
      
      public static const IMMEDIATE_BOOST_EFFECTS_IDS:Array = [266,268,269,271,414];
      
      public static const BOMB_SPELLS_IDS:Array = [2796,2797,2808];
      
      public static const SPLASH_EFFECTS_IDS:Array = [1123,1124,1125,1126,1127,1128];
      
      public static const MP_BASED_DAMAGE_EFFECTS_IDS:Array = [1012,1013,1014,1015,1016];
      
      public static const HP_BASED_DAMAGE_EFFECTS_IDS:Array = [672,85,86,87,88,89];
      
      public static const TARGET_HP_BASED_DAMAGE_EFFECTS_IDS:Array = [1067,1068,1069,1070,1071];
      
      public static const TRIGGERED_EFFECTS_IDS:Array = [138,1040];
      
      public static const NO_BOOST_EFFECTS_IDS:Array = [144,82];
       
      
      public function DamageUtil()
      {
         super();
      }
      
      public static function isDamagedOrHealedBySpell(param1:int, param2:int, param3:Object, param4:int) : Boolean
      {
         var _loc5_:Boolean = false;
         var _loc6_:EffectInstance = null;
         var _loc7_:Array = null;
         var _loc8_:BasicBuff = null;
         var _loc9_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         if(!param3 || !_loc9_)
         {
            return false;
         }
         var _loc10_:GameFightFighterInformations;
         if(!(_loc10_ = _loc9_.getEntityInfos(param2) as GameFightFighterInformations))
         {
            return false;
         }
         var _loc11_:TiphonSprite = DofusEntities.getEntity(param2) as AnimatedCharacter;
         var _loc12_:* = param2 == param1;
         var _loc13_:Boolean = _loc11_ && _loc11_.parentSprite && _loc11_.parentSprite.carriedEntity == _loc11_;
         if(!(param3 is SpellWrapper) || param3.id == 0)
         {
            if(!_loc12_ && !_loc13_)
            {
               return true;
            }
            return false;
         }
         var _loc14_:Boolean = PushUtil.isPushableEntity(_loc10_);
         if(BOMB_SPELLS_IDS.indexOf(param3.id) != -1)
         {
            param3 = getBombDirectDamageSpellWrapper(param3 as SpellWrapper);
         }
         var _loc15_:GameFightFighterInformations = _loc9_.getEntityInfos(param1) as GameFightFighterInformations;
         for each(_loc6_ in param3.effects)
         {
            if(_loc6_.triggers == "I" && (_loc6_.category == 2 || HEALING_EFFECTS_IDS.indexOf(_loc6_.effectId) != -1 || _loc6_.effectId == 5 && _loc14_) && verifySpellEffectMask(param1,param2,_loc6_,param4) && (_loc6_.targetMask.indexOf("C") != -1 && _loc12_ || verifySpellEffectZone(param2,_loc6_,param4,_loc15_.disposition.cellId)))
            {
               _loc5_ = true;
               break;
            }
         }
         if(!_loc5_)
         {
            for each(_loc6_ in param3.criticalEffect)
            {
               if(_loc6_.triggers == "I" && (_loc6_.category == 2 || HEALING_EFFECTS_IDS.indexOf(_loc6_.effectId) != -1 || _loc6_.effectId == 5 && _loc14_) && verifySpellEffectMask(param1,param2,_loc6_,param4) && verifySpellEffectZone(param2,_loc6_,param4,_loc15_.disposition.cellId))
               {
                  _loc5_ = true;
                  break;
               }
            }
         }
         if(!_loc5_)
         {
            if(_loc7_ = BuffManager.getInstance().getAllBuff(param2))
            {
               for each(_loc8_ in _loc7_)
               {
                  if(_loc8_.effect.category == DAMAGE_EFFECT_CATEGORY)
                  {
                     for each(_loc6_ in param3.effects)
                     {
                        if(verifyEffectTrigger(param1,param2,param3.effects,_loc6_,param3 is SpellWrapper,_loc8_.effect.triggers,param4))
                        {
                           _loc5_ = true;
                           break;
                        }
                     }
                     for each(_loc6_ in param3.criticalEffect)
                     {
                        if(verifyEffectTrigger(param1,param2,param3.criticalEffect,_loc6_,param3 is SpellWrapper,_loc8_.effect.triggers,param4))
                        {
                           _loc5_ = true;
                           break;
                        }
                     }
                  }
               }
            }
         }
         return _loc5_;
      }
      
      public static function getBombDirectDamageSpellWrapper(param1:SpellWrapper) : SpellWrapper
      {
         return SpellWrapper.create(0,SpellBomb.getSpellBombById((param1.effects[0] as EffectInstanceDice).diceNum).instantSpellId,param1.spellLevel,true,param1.playerId);
      }
      
      public static function getBuffEffectElements(param1:BasicBuff) : Vector.<int>
      {
         var _loc2_:Vector.<int> = null;
         var _loc3_:EffectInstance = null;
         var _loc4_:SpellLevel = null;
         var _loc5_:Effect;
         if((_loc5_ = Effect.getEffectById(param1.effect.effectId)).elementId == -1)
         {
            if(!(_loc4_ = param1.castingSpell.spellRank))
            {
               _loc4_ = SpellLevel.getLevelById(param1.castingSpell.spell.spellLevels[0]);
            }
            for each(_loc3_ in _loc4_.effects)
            {
               if(_loc3_.effectId == param1.effect.effectId)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = new Vector.<int>(0);
                  }
                  if(_loc3_.triggers.indexOf("DA") != -1 && _loc2_.indexOf(AIR_ELEMENT) == -1)
                  {
                     _loc2_.push(AIR_ELEMENT);
                  }
                  if(_loc3_.triggers.indexOf("DE") != -1 && _loc2_.indexOf(EARTH_ELEMENT) == -1)
                  {
                     _loc2_.push(EARTH_ELEMENT);
                  }
                  if(_loc3_.triggers.indexOf("DF") != -1 && _loc2_.indexOf(FIRE_ELEMENT) == -1)
                  {
                     _loc2_.push(FIRE_ELEMENT);
                  }
                  if(_loc3_.triggers.indexOf("DN") != -1 && _loc2_.indexOf(NEUTRAL_ELEMENT) == -1)
                  {
                     _loc2_.push(NEUTRAL_ELEMENT);
                  }
                  if(_loc3_.triggers.indexOf("DW") != -1 && _loc2_.indexOf(WATER_ELEMENT) == -1)
                  {
                     _loc2_.push(WATER_ELEMENT);
                  }
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public static function verifyBuffTriggers(param1:SpellDamageInfo, param2:BasicBuff) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:EffectInstance = null;
         var _loc6_:String;
         if(_loc6_ = param2.effect.triggers)
         {
            _loc3_ = _loc6_.split("|");
            for each(_loc4_ in _loc3_)
            {
               for each(_loc5_ in param1.spellEffects)
               {
                  if(verifyEffectTrigger(param1.casterId,param1.targetId,param1.spellEffects,_loc5_,param1.isWeapon,_loc4_,param1.spellCenterCell))
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public static function verifyEffectTrigger(param1:int, param2:int, param3:Vector.<EffectInstance>, param4:EffectInstance, param5:Boolean, param6:String, param7:int) : Boolean
      {
         var _loc8_:String = null;
         var _loc9_:* = false;
         var _loc10_:FightEntitiesFrame;
         if(!(_loc10_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame))
         {
            return false;
         }
         var _loc11_:Array = param6.split("|");
         var _loc12_:GameFightFighterInformations = _loc10_.getEntityInfos(param1) as GameFightFighterInformations;
         var _loc13_:GameFightFighterInformations;
         var _loc14_:* = (_loc13_ = _loc10_.getEntityInfos(param2) as GameFightFighterInformations).teamId == (_loc10_.getEntityInfos(param1) as GameFightFighterInformations).teamId;
         var _loc15_:int = _loc13_.disposition.cellId != -1?int(MapPoint.fromCellId(_loc12_.disposition.cellId).distanceTo(MapPoint.fromCellId(_loc13_.disposition.cellId))):-1;
         for each(_loc8_ in _loc11_)
         {
            switch(_loc8_)
            {
               case "I":
                  _loc9_ = true;
                  break;
               case "D":
                  _loc9_ = param4.category == DAMAGE_EFFECT_CATEGORY;
                  break;
               case "DA":
                  _loc9_ = Boolean(param4.category == DAMAGE_EFFECT_CATEGORY && Effect.getEffectById(param4.effectId).elementId == AIR_ELEMENT);
                  break;
               case "DBA":
                  _loc9_ = Boolean(_loc14_);
                  break;
               case "DBE":
                  _loc9_ = !_loc14_;
                  break;
               case "DC":
                  _loc9_ = Boolean(param5);
                  break;
               case "DE":
                  _loc9_ = Boolean(param4.category == DAMAGE_EFFECT_CATEGORY && Effect.getEffectById(param4.effectId).elementId == EARTH_ELEMENT);
                  break;
               case "DF":
                  _loc9_ = Boolean(param4.category == DAMAGE_EFFECT_CATEGORY && Effect.getEffectById(param4.effectId).elementId == FIRE_ELEMENT);
                  break;
               case "DG":
                  break;
               case "DI":
                  break;
               case "DM":
                  _loc9_ = Boolean(_loc15_ == -1?false:_loc15_ <= 1);
                  break;
               case "DN":
                  _loc9_ = Boolean(param4.category == DAMAGE_EFFECT_CATEGORY && Effect.getEffectById(param4.effectId).elementId == NEUTRAL_ELEMENT);
                  break;
               case "DP":
                  break;
               case "DR":
                  _loc9_ = Boolean(_loc15_ == -1?false:_loc15_ > 1);
                  break;
               case "Dr":
                  break;
               case "DS":
                  _loc9_ = !param5;
                  break;
               case "DTB":
                  break;
               case "DTE":
                  break;
               case "DW":
                  _loc9_ = Boolean(param4.category == DAMAGE_EFFECT_CATEGORY && Effect.getEffectById(param4.effectId).elementId == WATER_ELEMENT);
                  break;
               case "MD":
                  _loc9_ = Boolean(PushUtil.hasPushDamages(param1,param2,param3,param4,param7));
                  break;
               case "MDM":
                  break;
               case "MDP":
                  break;
               case "A":
                  _loc9_ = param4.effectId == 101;
                  break;
               case "m":
                  _loc9_ = param4.effectId == 127;
            }
            if(_loc9_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function verifySpellEffectMask(param1:int, param2:int, param3:EffectInstance, param4:int, param5:int = 0) : Boolean
      {
         var _loc6_:RegExp = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:Boolean = false;
         var _loc12_:* = false;
         var _loc13_:int = 0;
         var _loc14_:Dictionary = null;
         var _loc15_:Vector.<String> = null;
         var _loc16_:String = null;
         var _loc17_:Vector.<String> = null;
         var _loc18_:Boolean = false;
         var _loc19_:String = null;
         var _loc20_:int = 0;
         var _loc21_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         if(!param3 || !_loc21_ || param3.delay > 0 || !param3.targetMask)
         {
            return false;
         }
         var _loc22_:TiphonSprite = DofusEntities.getEntity(param2) as AnimatedCharacter;
         var _loc23_:* = param2 == param1;
         var _loc24_:Boolean = _loc22_ && _loc22_.parentSprite && _loc22_.parentSprite.carriedEntity == _loc22_;
         var _loc25_:GameFightFighterInformations;
         var _loc26_:GameFightMonsterInformations = (_loc25_ = _loc21_.getEntityInfos(param2) as GameFightFighterInformations) as GameFightMonsterInformations;
         var _loc27_:Array = FightersStateManager.getInstance().getStates(param1);
         var _loc28_:Array = FightersStateManager.getInstance().getStates(param2);
         var _loc29_:* = _loc25_.teamId == (_loc21_.getEntityInfos(param1) as GameFightFighterInformations).teamId;
         if(param1 == CurrentPlayedFighterManager.getInstance().currentFighterId && param3.category == 0 && param3.targetMask == "C")
         {
            return true;
         }
         if(_loc23_)
         {
            if(param3.effectId == 90)
            {
               return true;
            }
            if(param3.targetMask.indexOf("g") != -1)
            {
               return false;
            }
            if(verifySpellEffectZone(param1,param3,param4,_loc25_.disposition.cellId))
            {
               _loc7_ = "ca";
            }
            else
            {
               _loc7_ = "C";
            }
         }
         else
         {
            if(_loc24_ && param3.zoneShape != SpellShapeEnum.A && param3.zoneShape != SpellShapeEnum.a)
            {
               return false;
            }
            if(_loc25_.stats.summoned && _loc26_ && !Monster.getMonsterById(_loc26_.creatureGenericId).canPlay)
            {
               _loc7_ = !!_loc29_?"agsj":"ASJ";
            }
            else if(_loc25_.stats.summoned)
            {
               _loc7_ = !!_loc29_?"agij":"AIJ";
            }
            else if(_loc25_ is GameFightCompanionInformations)
            {
               _loc7_ = !!_loc29_?"agdl":"ADL";
            }
            else if(_loc25_ is GameFightMonsterInformations)
            {
               _loc7_ = !!_loc29_?"agm":"AM";
            }
            else
            {
               _loc7_ = !!_loc29_?"gahl":"AHL";
            }
         }
         _loc6_ = new RegExp("[" + _loc7_ + "]","g");
         if(_loc12_ = param3.targetMask.match(_loc6_).length > 0)
         {
            if((_loc8_ = param3.targetMask.match(exclusiveTargetMasks)).length > 0)
            {
               _loc12_ = false;
               _loc14_ = new Dictionary();
               _loc15_ = new Vector.<String>(0);
               for each(_loc9_ in _loc8_)
               {
                  if((_loc16_ = _loc9_.charAt(0)) == "*")
                  {
                     _loc16_ = _loc9_.substr(0,2);
                  }
                  if(AT_LEAST_MASK_TYPES.indexOf(_loc16_) != -1)
                  {
                     if(_loc15_.indexOf(_loc16_) != -1)
                     {
                        if(!_loc14_[_loc16_])
                        {
                           _loc14_[_loc16_] = 2;
                        }
                        else
                        {
                           ++_loc14_[_loc16_];
                        }
                     }
                     else
                     {
                        _loc15_.push(_loc16_);
                     }
                  }
               }
               _loc17_ = new Vector.<String>(0);
               for each(_loc9_ in _loc8_)
               {
                  _loc10_ = (_loc9_ = !!(_loc11_ = _loc9_.charAt(0) == "*")?_loc9_.substr(1,_loc9_.length - 1):_loc9_).length > 1?_loc9_.substr(1,_loc9_.length - 1):null;
                  _loc9_ = _loc9_.charAt(0);
                  switch(_loc9_)
                  {
                     case "b":
                        break;
                     case "B":
                        break;
                     case "e":
                        _loc13_ = parseInt(_loc10_);
                        if(_loc11_)
                        {
                           _loc12_ = Boolean(!_loc27_ || _loc27_.indexOf(_loc13_) == -1);
                        }
                        else
                        {
                           _loc12_ = Boolean(!_loc28_ || _loc28_.indexOf(_loc13_) == -1);
                        }
                        break;
                     case "E":
                        _loc13_ = parseInt(_loc10_);
                        if(_loc11_)
                        {
                           _loc12_ = Boolean(_loc27_ && _loc27_.indexOf(_loc13_) != -1);
                        }
                        else
                        {
                           _loc12_ = Boolean(_loc28_ && _loc28_.indexOf(_loc13_) != -1);
                        }
                        break;
                     case "f":
                        _loc12_ = Boolean(!_loc26_ || _loc26_.creatureGenericId != parseInt(_loc10_));
                        break;
                     case "F":
                        _loc12_ = Boolean(_loc26_ && _loc26_.creatureGenericId == parseInt(_loc10_));
                        break;
                     case "z":
                        break;
                     case "Z":
                        break;
                     case "K":
                        break;
                     case "o":
                        break;
                     case "O":
                        _loc12_ = Boolean(param5 != 0 && param2 == param5);
                        break;
                     case "p":
                        break;
                     case "P":
                        break;
                     case "T":
                        break;
                     case "W":
                        break;
                     case "U":
                        break;
                     case "v":
                        _loc12_ = _loc25_.stats.lifePoints / _loc25_.stats.maxLifePoints * 100 > parseInt(_loc10_);
                        break;
                     case "V":
                        _loc12_ = _loc25_.stats.lifePoints / _loc25_.stats.maxLifePoints * 100 <= parseInt(_loc10_);
                  }
                  _loc16_ = !!_loc11_?"*" + _loc9_:_loc9_;
                  _loc18_ = _loc14_[_loc16_];
                  if(!_loc19_ || _loc16_ == _loc19_)
                  {
                     _loc20_++;
                  }
                  else
                  {
                     _loc20_ = 0;
                  }
                  _loc19_ = _loc16_;
                  if(_loc12_ && _loc18_ && _loc17_.indexOf(_loc16_) == -1)
                  {
                     _loc17_.push(_loc16_);
                  }
                  if(!_loc12_)
                  {
                     if(!_loc18_)
                     {
                        return false;
                     }
                     if(_loc17_.indexOf(_loc16_) != -1)
                     {
                        _loc12_ = true;
                     }
                     else if(_loc14_[_loc16_] == _loc20_)
                     {
                        return false;
                     }
                  }
               }
            }
         }
         return _loc12_;
      }
      
      public static function verifySpellEffectZone(param1:int, param2:EffectInstance, param3:int, param4:int) : Boolean
      {
         var _loc5_:Boolean = false;
         var _loc6_:FightEntitiesFrame;
         if(!(_loc6_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame))
         {
            return false;
         }
         var _loc7_:GameFightFighterInformations = _loc6_.getEntityInfos(param1) as GameFightFighterInformations;
         var _loc8_:IZone;
         (_loc8_ = SpellZoneManager.getInstance().getZone(param2.zoneShape,uint(param2.zoneSize),uint(param2.zoneMinSize))).direction = MapPoint(MapPoint.fromCellId(param4)).advancedOrientationTo(MapPoint.fromCellId(FightContextFrame.currentCell),false);
         var _loc9_:Vector.<uint> = _loc8_.getCells(param3);
         if(_loc7_.disposition.cellId != -1)
         {
            _loc5_ = !!_loc9_?_loc9_.indexOf(_loc7_.disposition.cellId) != -1:false;
         }
         else if(param2.targetMask.indexOf("E263") != -1 && _loc8_.radius == 63)
         {
            _loc5_ = true;
         }
         return _loc5_;
      }
      
      public static function getSpellElementDamage(param1:Object, param2:int, param3:int, param4:int, param5:int) : SpellDamage
      {
         var _loc6_:EffectDamage = null;
         var _loc7_:EffectInstance = null;
         var _loc8_:EffectInstanceDice = null;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:FightEntitiesFrame;
         if(!(_loc12_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame))
         {
            return null;
         }
         var _loc13_:GameFightFighterInformations = _loc12_.getEntityInfos(param4) as GameFightFighterInformations;
         var _loc14_:SpellDamage = new SpellDamage();
         var _loc15_:int = param1.effects.length;
         var _loc16_:Boolean = !(param1 is SpellWrapper) || param1.id == 0;
         _loc9_ = 0;
         while(_loc9_ < _loc15_)
         {
            _loc7_ = param1.effects[_loc9_];
            _loc10_ = HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc7_.effectId) != -1 && _loc7_.targetMask == "C" && _loc7_.triggers != "I";
            if(_loc7_.category == DAMAGE_EFFECT_CATEGORY && (_loc16_ || _loc7_.triggers == "I") && HEALING_EFFECTS_IDS.indexOf(_loc7_.effectId) == -1 && Effect.getEffectById(_loc7_.effectId).elementId == param2 && (!_loc7_.targetMask || _loc16_ || _loc7_.targetMask && DamageUtil.verifySpellEffectMask(param3,param4,_loc7_,param5)) && !_loc10_)
            {
               _loc6_ = new EffectDamage(_loc7_.effectId,param2,_loc7_.random);
               _loc14_.addEffectDamage(_loc6_);
               if(EROSION_DAMAGE_EFFECTS_IDS.indexOf(_loc7_.effectId) != -1)
               {
                  _loc8_ = _loc7_ as EffectInstanceDice;
                  _loc6_.minErosionPercent = _loc6_.maxErosionPercent = _loc8_.diceNum;
               }
               else if(!(_loc7_ is EffectInstanceDice))
               {
                  if(_loc7_ is EffectInstanceInteger)
                  {
                     _loc6_.minDamage = _loc6_.minDamage + (_loc7_ as EffectInstanceInteger).value;
                     _loc6_.maxDamage = _loc6_.maxDamage + (_loc7_ as EffectInstanceInteger).value;
                  }
                  else if(_loc7_ is EffectInstanceMinMax)
                  {
                     _loc6_.minDamage = _loc6_.minDamage + (_loc7_ as EffectInstanceMinMax).min;
                     _loc6_.maxDamage = _loc6_.maxDamage + (_loc7_ as EffectInstanceMinMax).max;
                  }
               }
               else
               {
                  _loc8_ = _loc7_ as EffectInstanceDice;
                  _loc6_.minDamage = _loc6_.minDamage + _loc8_.diceNum;
                  _loc6_.maxDamage = _loc6_.maxDamage + (_loc8_.diceSide == 0?_loc8_.diceNum:_loc8_.diceSide);
               }
            }
            _loc9_++;
         }
         var _loc17_:int = _loc14_.effectDamages.length;
         var _loc18_:int = !!param1.criticalEffect?int(param1.criticalEffect.length):0;
         _loc9_ = 0;
         while(_loc9_ < _loc18_)
         {
            _loc7_ = param1.criticalEffect[_loc9_];
            _loc10_ = HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc7_.effectId) != -1 && _loc7_.targetMask == "C" && _loc7_.triggers != "I";
            if(_loc7_.category == DAMAGE_EFFECT_CATEGORY && (_loc16_ || _loc7_.triggers == "I") && HEALING_EFFECTS_IDS.indexOf(_loc7_.effectId) == -1 && Effect.getEffectById(_loc7_.effectId).elementId == param2 && (!_loc7_.targetMask || _loc16_ || _loc7_.targetMask && DamageUtil.verifySpellEffectMask(param3,param4,_loc7_,param5)) && !_loc10_)
            {
               if(_loc11_ < _loc17_)
               {
                  _loc6_ = _loc14_.effectDamages[_loc11_];
               }
               else
               {
                  _loc6_ = new EffectDamage(_loc7_.effectId,param2,_loc7_.random);
                  _loc14_.addEffectDamage(_loc6_);
               }
               if(EROSION_DAMAGE_EFFECTS_IDS.indexOf(_loc7_.effectId) != -1)
               {
                  _loc8_ = _loc7_ as EffectInstanceDice;
                  _loc6_.minCriticalErosionPercent = _loc6_.maxCriticalErosionPercent = _loc8_.diceNum;
               }
               else if(!(_loc7_ is EffectInstanceDice))
               {
                  if(_loc7_ is EffectInstanceInteger)
                  {
                     _loc6_.minCriticalDamage = _loc6_.minCriticalDamage + (_loc7_ as EffectInstanceInteger).value;
                     _loc6_.maxCriticalDamage = _loc6_.maxCriticalDamage + (_loc7_ as EffectInstanceInteger).value;
                  }
                  else if(_loc7_ is EffectInstanceMinMax)
                  {
                     _loc6_.minCriticalDamage = _loc6_.minCriticalDamage + (_loc7_ as EffectInstanceMinMax).min;
                     _loc6_.maxCriticalDamage = _loc6_.maxCriticalDamage + (_loc7_ as EffectInstanceMinMax).max;
                  }
               }
               else
               {
                  _loc8_ = _loc7_ as EffectInstanceDice;
                  _loc6_.minCriticalDamage = _loc6_.minCriticalDamage + _loc8_.diceNum;
                  _loc6_.maxCriticalDamage = _loc6_.maxCriticalDamage + (_loc8_.diceSide == 0?_loc8_.diceNum:_loc8_.diceSide);
               }
               _loc14_.hasCriticalDamage = _loc6_.hasCritical = true;
               _loc11_++;
            }
            _loc9_++;
         }
         return _loc14_;
      }
      
      public static function applySpellModificationsOnEffect(param1:EffectDamage, param2:SpellWrapper) : void
      {
         if(!param2)
         {
            return;
         }
         var _loc3_:CharacterSpellModification = CurrentPlayedFighterManager.getInstance().getSpellModifications(param2.id,CharacterSpellModificationTypeEnum.BASE_DAMAGE);
         if(_loc3_)
         {
            param1.minDamage = param1.minDamage + (param1.minDamage > 0?_loc3_.value.contextModif:0);
            param1.maxDamage = param1.maxDamage + (param1.maxDamage > 0?_loc3_.value.contextModif:0);
            if(param1.hasCritical)
            {
               param1.minCriticalDamage = param1.minCriticalDamage + (param1.minCriticalDamage > 0?_loc3_.value.contextModif:0);
               param1.maxCriticalDamage = param1.maxCriticalDamage + (param1.maxCriticalDamage > 0?_loc3_.value.contextModif:0);
            }
         }
      }
      
      public static function getReflectDamageValue(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Monster = null;
         var _loc4_:MonsterGrade = null;
         var _loc5_:FightContextFrame;
         if(!(_loc5_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame))
         {
            return 0;
         }
         var _loc6_:GameFightMonsterInformations;
         if(_loc6_ = _loc5_.entitiesFrame.getEntityInfos(param1) as GameFightMonsterInformations)
         {
            _loc3_ = Monster.getMonsterById(_loc6_.creatureGenericId);
            for each(_loc4_ in _loc3_.grades)
            {
               if(_loc4_.grade == _loc6_.creatureGrade)
               {
                  _loc2_ = _loc4_.damageReflect;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public static function addReflectDamage(param1:SpellDamage, param2:SpellDamage, param3:int) : void
      {
         var _loc4_:EffectDamage = null;
         var _loc5_:EffectDamage = null;
         for each(_loc4_ in param2.effectDamages)
         {
            _loc5_ = new EffectDamage(-1,_loc4_.element,_loc4_.random);
            _loc5_.minDamage = _loc5_.maxDamage = _loc5_.minCriticalDamage = _loc5_.maxCriticalDamage = param3;
            _loc5_.hasCritical = _loc4_.hasCritical;
            param1.addEffectDamage(_loc5_);
         }
      }
      
      public static function getSpellDamage(param1:SpellDamageInfo, param2:Boolean = true, param3:Boolean = true) : SpellDamage
      {
         var efficiencyMultiplier:Number = NaN;
         var splashEffectDamages:Vector.<EffectDamage> = null;
         var finalNeutralDmg:EffectDamage = null;
         var finalEarthDmg:EffectDamage = null;
         var finalWaterDmg:EffectDamage = null;
         var finalAirDmg:EffectDamage = null;
         var finalFireDmg:EffectDamage = null;
         var reflectSpellDmg:SpellDamage = null;
         var reflectEffectDmg:EffectDamage = null;
         var totalMinErosionDamage:int = 0;
         var totalMaxErosionDamage:int = 0;
         var totalMinCriticaErosionDamage:int = 0;
         var totalMaxCriticaErosionlDamage:int = 0;
         var casterIntelligence:int = 0;
         var erosion:EffectDamage = null;
         var targetHpBasedBuffDamages:Vector.<SpellDamage> = null;
         var dmgMultiplier:Number = NaN;
         var splashEffectDmg:EffectDamage = null;
         var splashDmg:SplashDamage = null;
         var splashCasterCell:uint = 0;
         var pushDamages:EffectDamage = null;
         var pushedEntity:PushedEntity = null;
         var pushIndex:uint = 0;
         var hasPushedDamage:Boolean = false;
         var pushDmg:int = 0;
         var criticalPushDmg:int = 0;
         var buff:BasicBuff = null;
         var buffDamage:EffectDamage = null;
         var buffEffectDamage:EffectDamage = null;
         var buffSpellDamage:SpellDamage = null;
         var effid:EffectInstanceDice = null;
         var buffEffectMinDamage:int = 0;
         var buffEffectMaxDamage:int = 0;
         var buffEffectDispelled:Boolean = false;
         var isTargetHpBasedDamage:Boolean = false;
         var buffSpellEffectDmg:EffectDamage = null;
         var ed:EffectDamage = null;
         var finalBuffDmg:EffectDamage = null;
         var currentTargetLifePoints:int = 0;
         var targetHpBasedBuffDamage:SpellDamage = null;
         var finalTargetHpBasedBuffDmg:EffectDamage = null;
         var minShieldDiff:int = 0;
         var maxShieldDiff:int = 0;
         var minCriticalShieldDiff:int = 0;
         var maxCriticalShieldDiff:int = 0;
         var pSpellDamageInfo:SpellDamageInfo = param1;
         var pWithTargetBuffs:Boolean = param2;
         var pWithTargetResists:Boolean = param3;
         var finalDamage:SpellDamage = new SpellDamage();
         if(pSpellDamageInfo.sharedDamage)
         {
            pSpellDamageInfo.sharedDamage.invulnerableState = pSpellDamageInfo.targetIsInvulnerable;
            pSpellDamageInfo.sharedDamage.hasCriticalDamage = pSpellDamageInfo.spellHasCriticalDamage;
            return pSpellDamageInfo.sharedDamage;
         }
         var currentCasterLifePoints:int = ((Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).getEntityInfos(pSpellDamageInfo.casterId) as GameFightFighterInformations).stats.lifePoints;
         if(pSpellDamageInfo.splashDamages)
         {
            splashEffectDamages = new Vector.<EffectDamage>(0);
            for each(splashDmg in pSpellDamageInfo.splashDamages)
            {
               if(splashDmg.targets.indexOf(pSpellDamageInfo.targetId) != -1)
               {
                  splashCasterCell = EntitiesManager.getInstance().getEntity(splashDmg.casterId).position.cellId;
                  efficiencyMultiplier = getShapeEfficiency(splashDmg.spellShape,splashCasterCell,pSpellDamageInfo.targetCell,splashDmg.spellShapeSize != null?int(int(splashDmg.spellShapeSize)):int(EFFECTSHAPE_DEFAULT_AREA_SIZE),splashDmg.spellShapeMinSize != null?int(int(splashDmg.spellShapeMinSize)):int(EFFECTSHAPE_DEFAULT_MIN_AREA_SIZE),splashDmg.spellShapeEfficiencyPercent != null?int(int(splashDmg.spellShapeEfficiencyPercent)):int(EFFECTSHAPE_DEFAULT_EFFICIENCY),splashDmg.spellShapeMaxEfficiency != null?int(int(splashDmg.spellShapeMaxEfficiency)):int(EFFECTSHAPE_DEFAULT_MAX_EFFICIENCY_APPLY));
                  splashEffectDmg = computeDamage(splashDmg.damage,pSpellDamageInfo,efficiencyMultiplier,true,!splashDmg.hasCritical);
                  splashEffectDamages.push(splashEffectDmg);
                  finalDamage.addEffectDamage(splashEffectDmg);
                  if(pSpellDamageInfo.targetId == pSpellDamageInfo.casterId)
                  {
                     if(pSpellDamageInfo.casterLifePointsAfterNormalMinDamage == 0)
                     {
                        pSpellDamageInfo.casterLifePointsAfterNormalMinDamage = currentCasterLifePoints - splashEffectDmg.minDamage;
                     }
                     else
                     {
                        pSpellDamageInfo.casterLifePointsAfterNormalMinDamage = pSpellDamageInfo.casterLifePointsAfterNormalMinDamage - splashEffectDmg.minDamage;
                     }
                     if(pSpellDamageInfo.casterLifePointsAfterNormalMaxDamage == 0)
                     {
                        pSpellDamageInfo.casterLifePointsAfterNormalMaxDamage = currentCasterLifePoints - splashEffectDmg.maxDamage;
                     }
                     else
                     {
                        pSpellDamageInfo.casterLifePointsAfterNormalMaxDamage = pSpellDamageInfo.casterLifePointsAfterNormalMaxDamage - splashEffectDmg.maxDamage;
                     }
                     if(pSpellDamageInfo.casterLifePointsAfterCriticalMinDamage == 0)
                     {
                        pSpellDamageInfo.casterLifePointsAfterCriticalMinDamage = currentCasterLifePoints - splashEffectDmg.minCriticalDamage;
                     }
                     else
                     {
                        pSpellDamageInfo.casterLifePointsAfterCriticalMinDamage = pSpellDamageInfo.casterLifePointsAfterCriticalMinDamage - splashEffectDmg.minCriticalDamage;
                     }
                     if(pSpellDamageInfo.casterLifePointsAfterCriticalMaxDamage == 0)
                     {
                        pSpellDamageInfo.casterLifePointsAfterCriticalMaxDamage = currentCasterLifePoints - splashEffectDmg.maxCriticalDamage;
                     }
                     else
                     {
                        pSpellDamageInfo.casterLifePointsAfterCriticalMaxDamage = pSpellDamageInfo.casterLifePointsAfterCriticalMaxDamage - splashEffectDmg.maxCriticalDamage;
                     }
                  }
               }
            }
         }
         var shapeSize:int = pSpellDamageInfo.spellShapeSize != null?int(int(pSpellDamageInfo.spellShapeSize)):int(EFFECTSHAPE_DEFAULT_AREA_SIZE);
         var shapeMinSize:int = pSpellDamageInfo.spellShapeMinSize != null?int(int(pSpellDamageInfo.spellShapeMinSize)):int(EFFECTSHAPE_DEFAULT_MIN_AREA_SIZE);
         var shapeEfficiencyPercent:int = pSpellDamageInfo.spellShapeEfficiencyPercent != null?int(int(pSpellDamageInfo.spellShapeEfficiencyPercent)):int(EFFECTSHAPE_DEFAULT_EFFICIENCY);
         var shapeMaxEfficiency:int = pSpellDamageInfo.spellShapeMaxEfficiency != null?int(int(pSpellDamageInfo.spellShapeMaxEfficiency)):int(EFFECTSHAPE_DEFAULT_MAX_EFFICIENCY_APPLY);
         if(shapeEfficiencyPercent == 0 || shapeMaxEfficiency == 0)
         {
            efficiencyMultiplier = DAMAGE_NOT_BOOSTED;
         }
         else
         {
            efficiencyMultiplier = getShapeEfficiency(pSpellDamageInfo.spellShape,pSpellDamageInfo.spellCenterCell,pSpellDamageInfo.targetCell,shapeSize,shapeMinSize,shapeEfficiencyPercent,shapeMaxEfficiency);
         }
         efficiencyMultiplier = efficiencyMultiplier * pSpellDamageInfo.portalsSpellEfficiencyBonus;
         finalNeutralDmg = computeDamage(pSpellDamageInfo.neutralDamage,pSpellDamageInfo,efficiencyMultiplier,false,!pWithTargetResists,!pWithTargetResists);
         finalEarthDmg = computeDamage(pSpellDamageInfo.earthDamage,pSpellDamageInfo,efficiencyMultiplier,false,!pWithTargetResists,!pWithTargetResists);
         finalWaterDmg = computeDamage(pSpellDamageInfo.waterDamage,pSpellDamageInfo,efficiencyMultiplier,false,!pWithTargetResists,!pWithTargetResists);
         finalAirDmg = computeDamage(pSpellDamageInfo.airDamage,pSpellDamageInfo,efficiencyMultiplier,false,!pWithTargetResists,!pWithTargetResists);
         finalFireDmg = computeDamage(pSpellDamageInfo.fireDamage,pSpellDamageInfo,efficiencyMultiplier,false,!pWithTargetResists,!pWithTargetResists);
         var finalFixedDmg:EffectDamage = computeDamage(pSpellDamageInfo.fixedDamage,pSpellDamageInfo,1,true,true,true);
         var finalReflectDmg:Vector.<EffectDamage> = new Vector.<EffectDamage>(0);
         for each(reflectEffectDmg in pSpellDamageInfo.reflectDamage.effectDamages)
         {
            reflectSpellDmg = new SpellDamage();
            reflectSpellDmg.addEffectDamage(reflectEffectDmg);
            reflectSpellDmg.hasCriticalDamage = reflectEffectDmg.hasCritical;
            finalReflectDmg.push(computeDamage(reflectSpellDmg,pSpellDamageInfo,1,true));
         }
         pSpellDamageInfo.casterLifePointsAfterNormalMinDamage = 0;
         pSpellDamageInfo.casterLifePointsAfterNormalMaxDamage = 0;
         pSpellDamageInfo.casterLifePointsAfterCriticalMinDamage = 0;
         pSpellDamageInfo.casterLifePointsAfterCriticalMaxDamage = 0;
         totalMinErosionDamage = finalNeutralDmg.minErosionDamage + finalEarthDmg.minErosionDamage + finalWaterDmg.minErosionDamage + finalAirDmg.minErosionDamage + finalFireDmg.minErosionDamage;
         totalMaxErosionDamage = finalNeutralDmg.maxErosionDamage + finalEarthDmg.maxErosionDamage + finalWaterDmg.maxErosionDamage + finalAirDmg.maxErosionDamage + finalFireDmg.maxErosionDamage;
         totalMinCriticaErosionDamage = finalNeutralDmg.minCriticalErosionDamage + finalEarthDmg.minCriticalErosionDamage + finalWaterDmg.minCriticalErosionDamage + finalAirDmg.minCriticalErosionDamage + finalFireDmg.minCriticalErosionDamage;
         totalMaxCriticaErosionlDamage = finalNeutralDmg.maxCriticalErosionDamage + finalEarthDmg.maxCriticalErosionDamage + finalWaterDmg.maxCriticalErosionDamage + finalAirDmg.maxCriticalErosionDamage + finalFireDmg.maxCriticalErosionDamage;
         casterIntelligence = pSpellDamageInfo.casterIntelligence <= 0?1:int(pSpellDamageInfo.casterIntelligence);
         var totalMinLifePointsAdded:int = Math.floor(pSpellDamageInfo.healDamage.minLifePointsAdded * (100 + casterIntelligence) / 100) + (pSpellDamageInfo.healDamage.minLifePointsAdded > 0?pSpellDamageInfo.casterHealBonus:0);
         var totalMaxLifePointsAdded:int = Math.floor(pSpellDamageInfo.healDamage.maxLifePointsAdded * (100 + casterIntelligence) / 100) + (pSpellDamageInfo.healDamage.maxLifePointsAdded > 0?pSpellDamageInfo.casterHealBonus:0);
         var totalMinCriticalLifePointsAdded:int = Math.floor(pSpellDamageInfo.healDamage.minCriticalLifePointsAdded * (100 + casterIntelligence) / 100) + (pSpellDamageInfo.healDamage.minCriticalLifePointsAdded > 0?pSpellDamageInfo.casterHealBonus:0);
         var totalMaxCriticalLifePointsAdded:int = Math.floor(pSpellDamageInfo.healDamage.maxCriticalLifePointsAdded * (100 + casterIntelligence) / 100) + (pSpellDamageInfo.healDamage.maxCriticalLifePointsAdded > 0?pSpellDamageInfo.casterHealBonus:0);
         totalMinLifePointsAdded = totalMinLifePointsAdded + pSpellDamageInfo.healDamage.lifePointsAddedBasedOnLifePercent;
         totalMaxLifePointsAdded = totalMaxLifePointsAdded + pSpellDamageInfo.healDamage.lifePointsAddedBasedOnLifePercent;
         totalMinCriticalLifePointsAdded = totalMinCriticalLifePointsAdded + pSpellDamageInfo.healDamage.criticalLifePointsAddedBasedOnLifePercent;
         totalMaxCriticalLifePointsAdded = totalMaxCriticalLifePointsAdded + pSpellDamageInfo.healDamage.criticalLifePointsAddedBasedOnLifePercent;
         finalDamage.hasHeal = totalMinLifePointsAdded > 0 || totalMaxLifePointsAdded > 0 || totalMinCriticalLifePointsAdded > 0 || totalMaxCriticalLifePointsAdded > 0;
         var targetLostLifePoints:int = pSpellDamageInfo.targetInfos.stats.maxLifePoints - pSpellDamageInfo.targetInfos.stats.lifePoints;
         if(targetLostLifePoints > 0 || pSpellDamageInfo.isHealingSpell)
         {
            totalMinLifePointsAdded = totalMinLifePointsAdded > targetLostLifePoints?int(targetLostLifePoints):int(totalMinLifePointsAdded);
            totalMaxLifePointsAdded = totalMaxLifePointsAdded > targetLostLifePoints?int(targetLostLifePoints):int(totalMaxLifePointsAdded);
            totalMinCriticalLifePointsAdded = totalMinCriticalLifePointsAdded > targetLostLifePoints?int(targetLostLifePoints):int(totalMinCriticalLifePointsAdded);
            totalMaxCriticalLifePointsAdded = totalMaxCriticalLifePointsAdded > targetLostLifePoints?int(targetLostLifePoints):int(totalMaxCriticalLifePointsAdded);
         }
         var heal:EffectDamage = new EffectDamage(-1,-1,-1);
         heal.minLifePointsAdded = totalMinLifePointsAdded * efficiencyMultiplier;
         heal.maxLifePointsAdded = totalMaxLifePointsAdded * efficiencyMultiplier;
         heal.minCriticalLifePointsAdded = totalMinCriticalLifePointsAdded * efficiencyMultiplier;
         heal.maxCriticalLifePointsAdded = totalMaxCriticalLifePointsAdded * efficiencyMultiplier;
         erosion = new EffectDamage(-1,-1,-1);
         erosion.minDamage = totalMinErosionDamage;
         erosion.maxDamage = totalMaxErosionDamage;
         erosion.minCriticalDamage = totalMinCriticaErosionDamage;
         erosion.maxCriticalDamage = totalMaxCriticaErosionlDamage;
         if(pSpellDamageInfo.pushedEntities && pSpellDamageInfo.pushedEntities.length > 0)
         {
            pushDamages = new EffectDamage(5,-1,-1);
            for each(pushedEntity in pSpellDamageInfo.pushedEntities)
            {
               if(pushedEntity.id == pSpellDamageInfo.targetId)
               {
                  pushedEntity.damage = 0;
                  for each(pushIndex in pushedEntity.pushedIndexes)
                  {
                     pushDmg = (pSpellDamageInfo.casterLevel / 2 + (pSpellDamageInfo.casterPushDamageBonus - pSpellDamageInfo.targetPushDamageFixedResist) + 32) * pushedEntity.force / (4 * Math.pow(2,pushIndex));
                     pushedEntity.damage = pushedEntity.damage + (pushDmg > 0?pushDmg:0);
                     criticalPushDmg = (pSpellDamageInfo.casterLevel / 2 + (pSpellDamageInfo.casterCriticalPushDamageBonus - pSpellDamageInfo.targetPushDamageFixedResist) + 32) * pushedEntity.force / (4 * Math.pow(2,pushIndex));
                     pushedEntity.criticalDamage = pushedEntity.criticalDamage + (criticalPushDmg > 0?criticalPushDmg:0);
                  }
                  hasPushedDamage = true;
                  break;
               }
            }
            if(hasPushedDamage)
            {
               pushDamages.minDamage = pushDamages.maxDamage = pushedEntity.damage;
               if(pSpellDamageInfo.spellHasCriticalDamage)
               {
                  pushDamages.minCriticalDamage = pushDamages.maxCriticalDamage = pushedEntity.criticalDamage;
               }
            }
            finalDamage.addEffectDamage(pushDamages);
         }
         var applyDamageMultiplier:Function = function(param1:Number):void
         {
            var _loc2_:EffectDamage = null;
            erosion.applyDamageMultiplier(param1);
            finalNeutralDmg.applyDamageMultiplier(param1);
            finalEarthDmg.applyDamageMultiplier(param1);
            finalWaterDmg.applyDamageMultiplier(param1);
            finalAirDmg.applyDamageMultiplier(param1);
            finalFireDmg.applyDamageMultiplier(param1);
            if(splashEffectDamages)
            {
               for each(_loc2_ in splashEffectDamages)
               {
                  _loc2_.applyDamageMultiplier(param1);
               }
            }
         };
         if(pWithTargetBuffs)
         {
            for each(buff in pSpellDamageInfo.targetBuffs)
            {
               buffEffectDispelled = buff.canBeDispell() && buff.effect.duration - pSpellDamageInfo.spellTargetEffectsDurationReduction <= 0;
               if((!buff.hasOwnProperty("delay") || buff["delay"] == 0) && (!(buff is StatBuff) || !(buff as StatBuff).statName) && verifyBuffTriggers(pSpellDamageInfo,buff) && !buffEffectDispelled)
               {
                  switch(buff.actionId)
                  {
                     case 1163:
                        applyDamageMultiplier(buff.param1 / 100);
                        break;
                     case 1164:
                        erosion.convertDamageToHeal();
                        finalNeutralDmg.convertDamageToHeal();
                        finalEarthDmg.convertDamageToHeal();
                        finalWaterDmg.convertDamageToHeal();
                        finalAirDmg.convertDamageToHeal();
                        finalFireDmg.convertDamageToHeal();
                        pSpellDamageInfo.spellHasCriticalHeal = pSpellDamageInfo.spellHasCriticalDamage;
                  }
                  if(buff.targetId != pSpellDamageInfo.casterId && buff.effect.category == DAMAGE_EFFECT_CATEGORY && HEALING_EFFECTS_IDS.indexOf(buff.effect.effectId) == -1)
                  {
                     buffSpellDamage = new SpellDamage();
                     buffEffectDamage = new EffectDamage(buff.effect.effectId,Effect.getEffectById(buff.effect.effectId).elementId,-1);
                     if(buff.effect is EffectInstanceDice)
                     {
                        effid = buff.effect as EffectInstanceDice;
                        buffEffectMinDamage = effid.value + effid.diceNum;
                        buffEffectMaxDamage = effid.value + effid.diceSide;
                     }
                     else if(buff.effect is EffectInstanceMinMax)
                     {
                        buffEffectMinDamage = (buff.effect as EffectInstanceMinMax).min;
                        buffEffectMaxDamage = (buff.effect as EffectInstanceMinMax).max;
                     }
                     else if(buff.effect is EffectInstanceInteger)
                     {
                        buffEffectMinDamage = buffEffectMaxDamage = int((buff.effect as EffectInstanceInteger).value);
                     }
                     buffEffectDamage.minDamage = buff.effect.duration - pSpellDamageInfo.spellTargetEffectsDurationReduction > 0?int(buffEffectMinDamage):0;
                     buffEffectDamage.maxDamage = buff.effect.duration - pSpellDamageInfo.spellTargetEffectsDurationReduction > 0?int(buffEffectMaxDamage):0;
                     buffEffectDamage.minCriticalDamage = buff.effect.duration - pSpellDamageInfo.spellTargetEffectsDurationCriticalReduction > 0?int(buffEffectMinDamage):0;
                     buffEffectDamage.maxCriticalDamage = buff.effect.duration - pSpellDamageInfo.spellTargetEffectsDurationCriticalReduction > 0?int(buffEffectMaxDamage):0;
                     buffSpellDamage.addEffectDamage(buffEffectDamage);
                     isTargetHpBasedDamage = TARGET_HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(buff.actionId) != -1;
                     if(HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(buff.actionId) != -1)
                     {
                        for each(buffSpellEffectDmg in buffSpellDamage.effectDamages)
                        {
                           switch(buffSpellEffectDmg.effectId)
                           {
                              case 85:
                                 buffSpellEffectDmg.effectId = 1068;
                                 continue;
                              case 86:
                                 buffSpellEffectDmg.effectId = 1070;
                                 continue;
                              case 87:
                                 buffSpellEffectDmg.effectId = 1067;
                                 continue;
                              case 88:
                                 buffSpellEffectDmg.effectId = 1069;
                                 continue;
                              case 89:
                                 buffSpellEffectDmg.effectId = 1071;
                                 continue;
                              default:
                                 continue;
                           }
                        }
                        isTargetHpBasedDamage = true;
                     }
                     if(!isTargetHpBasedDamage)
                     {
                        buffDamage = computeDamage(buffSpellDamage,pSpellDamageInfo,1);
                        finalDamage.addEffectDamage(buffDamage);
                     }
                     else
                     {
                        if(!targetHpBasedBuffDamages)
                        {
                           targetHpBasedBuffDamages = new Vector.<SpellDamage>(0);
                        }
                        targetHpBasedBuffDamages.push(buffSpellDamage);
                     }
                  }
               }
            }
         }
         if(pSpellDamageInfo.casterDamageBoostPercent > 0)
         {
            applyDamageMultiplier((100 + pSpellDamageInfo.casterDamageBoostPercent) / 100);
         }
         if(pSpellDamageInfo.casterDamageDeboostPercent > 0)
         {
            dmgMultiplier = 100 - pSpellDamageInfo.casterDamageDeboostPercent;
            applyDamageMultiplier(dmgMultiplier < 0?0:dmgMultiplier / 100);
         }
         if(pSpellDamageInfo.targetId == pSpellDamageInfo.casterId)
         {
            for each(ed in finalReflectDmg)
            {
               finalDamage.addEffectDamage(ed);
               if(ed.hasCritical)
               {
                  pSpellDamageInfo.spellHasCriticalDamage = true;
               }
            }
         }
         if(pSpellDamageInfo.originalTargetsIds.indexOf(pSpellDamageInfo.targetId) != -1)
         {
            finalDamage.addEffectDamage(heal);
            finalDamage.addEffectDamage(erosion);
            finalDamage.addEffectDamage(finalNeutralDmg);
            finalDamage.addEffectDamage(finalEarthDmg);
            finalDamage.addEffectDamage(finalWaterDmg);
            finalDamage.addEffectDamage(finalAirDmg);
            finalDamage.addEffectDamage(finalFireDmg);
            finalDamage.addEffectDamage(finalFixedDmg);
            if(pSpellDamageInfo.buffDamage)
            {
               finalDamage.updateDamage();
               pSpellDamageInfo.casterLifePointsAfterNormalMinDamage = currentCasterLifePoints - finalDamage.minDamage;
               pSpellDamageInfo.casterLifePointsAfterNormalMaxDamage = currentCasterLifePoints - finalDamage.maxDamage;
               pSpellDamageInfo.casterLifePointsAfterCriticalMinDamage = currentCasterLifePoints - finalDamage.minCriticalDamage;
               pSpellDamageInfo.casterLifePointsAfterCriticalMaxDamage = currentCasterLifePoints - finalDamage.maxCriticalDamage;
               finalBuffDmg = computeDamage(pSpellDamageInfo.buffDamage,pSpellDamageInfo,efficiencyMultiplier,false,!pWithTargetResists,!pWithTargetResists);
            }
            if(finalBuffDmg)
            {
               finalDamage.addEffectDamage(finalBuffDmg);
            }
            if(targetHpBasedBuffDamages)
            {
               finalDamage.updateDamage();
               currentTargetLifePoints = ((Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).getEntityInfos(pSpellDamageInfo.targetId) as GameFightFighterInformations).stats.lifePoints;
               pSpellDamageInfo.targetLifePointsAfterNormalMinDamage = currentTargetLifePoints - finalDamage.minDamage < 0?uint(0):uint(currentTargetLifePoints - finalDamage.minDamage);
               pSpellDamageInfo.targetLifePointsAfterNormalMaxDamage = currentTargetLifePoints - finalDamage.maxDamage < 0?uint(0):uint(currentTargetLifePoints - finalDamage.maxDamage);
               pSpellDamageInfo.targetLifePointsAfterCriticalMinDamage = currentTargetLifePoints - finalDamage.minCriticalDamage < 0?uint(0):uint(currentTargetLifePoints - finalDamage.minCriticalDamage);
               pSpellDamageInfo.targetLifePointsAfterCriticalMaxDamage = currentTargetLifePoints - finalDamage.maxCriticalDamage < 0?uint(0):uint(currentTargetLifePoints - finalDamage.maxCriticalDamage);
               for each(targetHpBasedBuffDamage in targetHpBasedBuffDamages)
               {
                  finalTargetHpBasedBuffDmg = computeDamage(targetHpBasedBuffDamage,pSpellDamageInfo,efficiencyMultiplier,false,!pWithTargetResists,!pWithTargetResists);
                  finalDamage.addEffectDamage(finalTargetHpBasedBuffDmg);
               }
            }
         }
         finalDamage.hasCriticalDamage = pSpellDamageInfo.spellHasCriticalDamage;
         finalDamage.updateDamage();
         pSpellDamageInfo.targetShieldPoints = pSpellDamageInfo.targetShieldPoints + pSpellDamageInfo.targetTriggeredShieldPoints;
         if(pSpellDamageInfo.targetShieldPoints > 0)
         {
            minShieldDiff = finalDamage.minDamage - pSpellDamageInfo.targetShieldPoints;
            if(minShieldDiff < 0)
            {
               finalDamage.minShieldPointsRemoved = finalDamage.minDamage;
               finalDamage.minDamage = 0;
            }
            else
            {
               finalDamage.minDamage = finalDamage.minDamage - pSpellDamageInfo.targetShieldPoints;
               finalDamage.minShieldPointsRemoved = pSpellDamageInfo.targetShieldPoints;
            }
            maxShieldDiff = finalDamage.maxDamage - pSpellDamageInfo.targetShieldPoints;
            if(maxShieldDiff < 0)
            {
               finalDamage.maxShieldPointsRemoved = finalDamage.maxDamage;
               finalDamage.maxDamage = 0;
            }
            else
            {
               finalDamage.maxDamage = finalDamage.maxDamage - pSpellDamageInfo.targetShieldPoints;
               finalDamage.maxShieldPointsRemoved = pSpellDamageInfo.targetShieldPoints;
            }
            minCriticalShieldDiff = finalDamage.minCriticalDamage - pSpellDamageInfo.targetShieldPoints;
            if(minCriticalShieldDiff < 0)
            {
               finalDamage.minCriticalShieldPointsRemoved = finalDamage.minCriticalDamage;
               finalDamage.minCriticalDamage = 0;
            }
            else
            {
               finalDamage.minCriticalDamage = finalDamage.minCriticalDamage - pSpellDamageInfo.targetShieldPoints;
               finalDamage.minCriticalShieldPointsRemoved = pSpellDamageInfo.targetShieldPoints;
            }
            maxCriticalShieldDiff = finalDamage.maxCriticalDamage - pSpellDamageInfo.targetShieldPoints;
            if(maxCriticalShieldDiff < 0)
            {
               finalDamage.maxCriticalShieldPointsRemoved = finalDamage.maxCriticalDamage;
               finalDamage.maxCriticalDamage = 0;
            }
            else
            {
               finalDamage.maxCriticalDamage = finalDamage.maxCriticalDamage - pSpellDamageInfo.targetShieldPoints;
               finalDamage.maxCriticalShieldPointsRemoved = pSpellDamageInfo.targetShieldPoints;
            }
            if(pSpellDamageInfo.spellHasCriticalDamage)
            {
               finalDamage.hasCriticalShieldPointsRemoved = true;
            }
         }
         if(pSpellDamageInfo.casterStates && pSpellDamageInfo.casterStates.indexOf(218) != -1)
         {
            finalDamage.minDamage = finalDamage.maxDamage = finalDamage.minCriticalDamage = finalDamage.maxCriticalDamage = 0;
         }
         finalDamage.hasCriticalLifePointsAdded = pSpellDamageInfo.spellHasCriticalHeal;
         finalDamage.invulnerableState = pSpellDamageInfo.targetIsInvulnerable;
         finalDamage.unhealableState = pSpellDamageInfo.targetIsUnhealable;
         finalDamage.isHealingSpell = pSpellDamageInfo.isHealingSpell;
         return finalDamage;
      }
      
      private static function computeDamage(param1:SpellDamage, param2:SpellDamageInfo, param3:Number, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false) : EffectDamage
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:EffectModification = null;
         var _loc15_:int = 0;
         var _loc16_:EffectDamage = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:FightEntitiesFrame;
         if(!(_loc30_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame))
         {
            return null;
         }
         var _loc31_:int = param2.casterAllDamagesBonus;
         var _loc32_:int = param2.casterCriticalDamageBonus;
         var _loc33_:int = param2.targetCriticalDamageFixedResist;
         var _loc34_:int = -1;
         var _loc35_:GameFightFighterInformations;
         var _loc36_:Number = (_loc35_ = _loc30_.getEntityInfos(param2.casterId) as GameFightFighterInformations).stats.movementPoints / _loc35_.stats.maxMovementPoints;
         var _loc37_:uint = param2.casterLifePointsAfterNormalMinDamage > 0?uint(param2.casterLifePointsAfterNormalMinDamage):uint(_loc35_.stats.lifePoints);
         var _loc38_:uint = param2.casterLifePointsAfterNormalMaxDamage > 0?uint(param2.casterLifePointsAfterNormalMaxDamage):uint(_loc35_.stats.lifePoints);
         var _loc39_:uint = param2.casterLifePointsAfterCriticalMinDamage > 0?uint(param2.casterLifePointsAfterCriticalMinDamage):uint(_loc35_.stats.lifePoints);
         var _loc40_:uint = param2.casterLifePointsAfterCriticalMaxDamage > 0?uint(param2.casterLifePointsAfterCriticalMaxDamage):uint(_loc35_.stats.lifePoints);
         var _loc41_:uint = param2.targetLifePointsAfterNormalMinDamage > 0?uint(param2.targetLifePointsAfterNormalMinDamage):uint(param2.targetInfos.stats.lifePoints);
         var _loc42_:uint = param2.targetLifePointsAfterNormalMaxDamage > 0?uint(param2.targetLifePointsAfterNormalMaxDamage):uint(param2.targetInfos.stats.lifePoints);
         var _loc43_:uint = param2.targetLifePointsAfterCriticalMinDamage > 0?uint(param2.targetLifePointsAfterCriticalMinDamage):uint(param2.targetInfos.stats.lifePoints);
         var _loc44_:uint = param2.targetLifePointsAfterCriticalMaxDamage > 0?uint(param2.targetLifePointsAfterCriticalMaxDamage):uint(param2.targetInfos.stats.lifePoints);
         var _loc45_:int = param1.effectDamages.length;
         _loc25_ = 0;
         for(; _loc25_ < _loc45_; _loc21_ = _loc21_ < 0?0:int(_loc21_),_loc23_ = _loc23_ < 0?0:int(_loc23_),_loc22_ = _loc22_ < 0?0:int(_loc22_),_loc24_ = _loc24_ < 0?0:int(_loc24_),if(MP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc16_.effectId) != -1)
         {
            _loc21_ = _loc21_ * _loc36_;
            _loc23_ = _loc23_ * _loc36_;
            _loc22_ = _loc22_ * _loc36_;
            _loc24_ = _loc24_ * _loc36_;
         },if(DamageUtil.EROSION_DAMAGE_EFFECTS_IDS.indexOf(_loc16_.effectId) != -1)
         {
            _loc16_.minErosionDamage = _loc16_.minErosionDamage + (param2.targetErosionLifePoints + param2.targetSpellMinErosionLifePoints) * _loc16_.minErosionPercent / 100;
            _loc16_.maxErosionDamage = _loc16_.maxErosionDamage + (param2.targetErosionLifePoints + param2.targetSpellMaxErosionLifePoints) * _loc16_.maxErosionPercent / 100;
            if(_loc16_.hasCritical)
            {
               _loc16_.minCriticalErosionDamage = _loc16_.minCriticalErosionDamage + (param2.targetErosionLifePoints + param2.targetSpellMinCriticalErosionLifePoints) * _loc16_.minCriticalErosionPercent / 100;
               _loc16_.maxCriticalErosionDamage = _loc16_.maxCriticalErosionDamage + (param2.targetErosionLifePoints + param2.targetSpellMaxCriticalErosionLifePoints) * _loc16_.maxCriticalErosionPercent / 100;
            }
         }
         else
         {
            param2.targetSpellMinErosionLifePoints = param2.targetSpellMinErosionLifePoints + _loc21_ * (10 + param2.targetErosionPercentBonus) / 100;
            param2.targetSpellMaxErosionLifePoints = param2.targetSpellMaxErosionLifePoints + _loc23_ * (10 + param2.targetErosionPercentBonus) / 100;
            param2.targetSpellMinCriticalErosionLifePoints = param2.targetSpellMinCriticalErosionLifePoints + _loc22_ * (10 + param2.targetErosionPercentBonus) / 100;
            param2.targetSpellMaxCriticalErosionLifePoints = param2.targetSpellMaxCriticalErosionLifePoints + _loc24_ * (10 + param2.targetErosionPercentBonus) / 100;
         },_loc17_ = _loc17_ + _loc21_,_loc19_ = _loc19_ + _loc23_,_loc18_ = _loc18_ + _loc22_,_loc20_ = _loc20_ + _loc24_,_loc25_++)
         {
            _loc34_ = (_loc16_ = param1.effectDamages[_loc25_]).effectId;
            _loc10_ = 0;
            if(NO_BOOST_EFFECTS_IDS.indexOf(_loc16_.effectId) != -1)
            {
               param4 = true;
            }
            if(_loc14_ = param2.getEffectModification(_loc16_.effectId,_loc25_,_loc16_.hasCritical))
            {
               _loc15_ = _loc14_.damagesBonus;
               if(_loc14_.shieldPoints > param2.targetTriggeredShieldPoints)
               {
                  param2.targetTriggeredShieldPoints = _loc14_.shieldPoints;
               }
            }
            switch(_loc16_.element)
            {
               case NEUTRAL_ELEMENT:
                  if(!param4)
                  {
                     _loc7_ = (_loc26_ = param2.casterStrength) + param2.casterDamagesBonus + _loc15_ + (!!param2.isWeapon?param2.casterWeaponDamagesBonus:param2.casterSpellDamagesBonus);
                     _loc8_ = param2.casterStrengthBonus;
                     _loc9_ = param2.casterCriticalStrengthBonus;
                  }
                  if(!param6)
                  {
                     _loc10_ = param2.targetNeutralElementResistPercent;
                     _loc12_ = param2.targetNeutralElementReduction;
                  }
                  _loc13_ = param2.casterNeutralDamageBonus;
                  break;
               case EARTH_ELEMENT:
                  if(!param4)
                  {
                     _loc7_ = (_loc26_ = param2.casterStrength) + param2.casterDamagesBonus + _loc15_ + (!!param2.isWeapon?param2.casterWeaponDamagesBonus:param2.casterSpellDamagesBonus);
                     _loc8_ = param2.casterStrengthBonus;
                     _loc9_ = param2.casterCriticalStrengthBonus;
                  }
                  if(!param6)
                  {
                     _loc10_ = param2.targetEarthElementResistPercent;
                     _loc12_ = param2.targetEarthElementReduction;
                  }
                  _loc13_ = param2.casterEarthDamageBonus;
                  break;
               case FIRE_ELEMENT:
                  if(!param4)
                  {
                     _loc7_ = (_loc26_ = param2.casterIntelligence) + param2.casterDamagesBonus + _loc15_ + (!!param2.isWeapon?param2.casterWeaponDamagesBonus:param2.casterSpellDamagesBonus);
                     _loc8_ = param2.casterIntelligenceBonus;
                     _loc9_ = param2.casterCriticalIntelligenceBonus;
                  }
                  if(!param6)
                  {
                     _loc10_ = param2.targetFireElementResistPercent;
                     _loc12_ = param2.targetFireElementReduction;
                  }
                  _loc13_ = param2.casterFireDamageBonus;
                  break;
               case WATER_ELEMENT:
                  if(!param4)
                  {
                     _loc7_ = (_loc26_ = param2.casterChance) + param2.casterDamagesBonus + _loc15_ + (!!param2.isWeapon?param2.casterWeaponDamagesBonus:param2.casterSpellDamagesBonus);
                     _loc8_ = param2.casterChanceBonus;
                     _loc9_ = param2.casterCriticalChanceBonus;
                  }
                  if(!param6)
                  {
                     _loc10_ = param2.targetWaterElementResistPercent;
                     _loc12_ = param2.targetWaterElementReduction;
                  }
                  _loc13_ = param2.casterWaterDamageBonus;
                  break;
               case AIR_ELEMENT:
                  if(!param4)
                  {
                     _loc7_ = (_loc26_ = param2.casterAgility) + param2.casterDamagesBonus + _loc15_ + (!!param2.isWeapon?param2.casterWeaponDamagesBonus:param2.casterSpellDamagesBonus);
                     _loc8_ = param2.casterAgilityBonus;
                     _loc9_ = param2.casterCriticalAgilityBonus;
                  }
                  if(!param6)
                  {
                     _loc10_ = param2.targetAirElementResistPercent;
                     _loc12_ = param2.targetAirElementReduction;
                  }
                  _loc13_ = param2.casterAirDamageBonus;
            }
            _loc7_ = Math.max(0,_loc7_);
            if(!param6)
            {
               _loc12_ = _loc12_ + getBuffElementReduction(param2,_loc16_,param2.targetId);
            }
            _loc10_ = 100 - _loc10_;
            _loc11_ = (!!isNaN(_loc16_.efficiencyMultiplier)?param3:_loc16_.efficiencyMultiplier) * 100;
            if(HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc16_.effectId) == -1 && TARGET_HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc16_.effectId) == -1)
            {
               if(param4)
               {
                  _loc13_ = _loc31_ = _loc32_ = 0;
               }
               if(param5)
               {
                  _loc33_ = 0;
               }
               _loc27_ = !!param2.spellDamageModification?int(param2.spellDamageModification.value.objectsAndMountBonus):0;
               _loc21_ = getDamage(_loc16_.minDamage,param4,_loc7_,_loc8_,_loc13_,_loc31_,_loc27_,_loc12_,_loc10_,_loc11_);
               _loc22_ = getDamage(!param4 && param2.spellWeaponCriticalBonus != 0?_loc16_.minDamage > 0?int(_loc16_.minDamage + param2.spellWeaponCriticalBonus):0:int(_loc16_.minCriticalDamage),param4,_loc7_,_loc9_,_loc13_ + _loc32_,_loc31_,_loc27_,_loc12_ + _loc33_,_loc10_,_loc11_);
               _loc23_ = getDamage(_loc16_.maxDamage,param4,_loc7_,_loc8_,_loc13_,_loc31_,_loc27_,_loc12_,_loc10_,_loc11_);
               _loc24_ = getDamage(!param4 && param2.spellWeaponCriticalBonus != 0?_loc16_.maxDamage > 0?int(_loc16_.maxDamage + param2.spellWeaponCriticalBonus):0:int(_loc16_.maxCriticalDamage),param4,_loc7_,_loc9_,_loc13_ + _loc32_,_loc31_,_loc27_,_loc12_ + _loc33_,_loc10_,_loc11_);
               continue;
            }
            switch(_loc16_.effectId)
            {
               case 672:
                  _loc21_ = _loc23_ = ((_loc28_ = _loc16_.maxDamage * _loc35_.stats.baseMaxLifePoints * getMidLifeDamageMultiplier(Math.min(100,Math.max(0,100 * _loc35_.stats.lifePoints / _loc35_.stats.maxLifePoints))) / 100 * _loc11_ / 100) - _loc12_) * _loc10_ / 100;
                  _loc22_ = _loc24_ = ((_loc29_ = _loc16_.maxCriticalDamage * _loc35_.stats.baseMaxLifePoints * getMidLifeDamageMultiplier(Math.min(100,Math.max(0,100 * _loc35_.stats.lifePoints / _loc35_.stats.maxLifePoints))) / 100 * _loc11_ / 100) - _loc12_) * _loc10_ / 100;
                  continue;
               case 85:
               case 86:
               case 87:
               case 88:
               case 89:
                  _loc21_ = ((_loc28_ = _loc16_.minDamage * _loc37_ / 100 * _loc11_ / 100) - _loc12_) * _loc10_ / 100;
                  _loc23_ = ((_loc28_ = _loc16_.maxDamage * _loc38_ / 100 * _loc11_ / 100) - _loc12_) * _loc10_ / 100;
                  _loc22_ = ((_loc29_ = _loc16_.minCriticalDamage * _loc39_ / 100 * _loc11_ / 100) - _loc12_) * _loc10_ / 100;
                  _loc24_ = ((_loc29_ = _loc16_.maxCriticalDamage * _loc40_ / 100 * _loc11_ / 100) - _loc12_) * _loc10_ / 100;
                  _loc37_ = _loc37_ - _loc21_;
                  _loc38_ = _loc38_ - _loc23_;
                  _loc39_ = _loc39_ - _loc22_;
                  _loc40_ = _loc40_ - _loc24_;
                  continue;
               case 1067:
               case 1068:
               case 1069:
               case 1070:
               case 1071:
                  _loc21_ = ((_loc28_ = _loc16_.minDamage * _loc41_ / 100 * _loc11_ / 100) - _loc12_) * _loc10_ / 100;
                  _loc23_ = ((_loc28_ = _loc16_.maxDamage * _loc42_ / 100 * _loc11_ / 100) - _loc12_) * _loc10_ / 100;
                  _loc22_ = ((_loc29_ = _loc16_.minCriticalDamage * _loc43_ / 100 * _loc11_ / 100) - _loc12_) * _loc10_ / 100;
                  _loc24_ = ((_loc29_ = _loc16_.maxCriticalDamage * _loc44_ / 100 * _loc11_ / 100) - _loc12_) * _loc10_ / 100;
                  _loc41_ = _loc41_ - _loc21_;
                  _loc42_ = _loc42_ - _loc23_;
                  _loc43_ = _loc43_ - _loc22_;
                  _loc44_ = _loc44_ - _loc24_;
                  continue;
               default:
                  continue;
            }
         }
         var _loc46_:EffectDamage;
         (_loc46_ = new EffectDamage(_loc34_,param1.element,param1.random)).minDamage = _loc17_;
         _loc46_.maxDamage = _loc19_;
         _loc46_.minCriticalDamage = _loc18_;
         _loc46_.maxCriticalDamage = _loc20_;
         _loc46_.minErosionDamage = param1.minErosionDamage * _loc11_ / 100;
         _loc46_.minErosionDamage = _loc46_.minErosionDamage * _loc10_ / 100;
         _loc46_.maxErosionDamage = param1.maxErosionDamage * _loc11_ / 100;
         _loc46_.maxErosionDamage = _loc46_.maxErosionDamage * _loc10_ / 100;
         _loc46_.minCriticalErosionDamage = param1.minCriticalErosionDamage * _loc11_ / 100;
         _loc46_.minCriticalErosionDamage = _loc46_.minCriticalErosionDamage * _loc10_ / 100;
         _loc46_.maxCriticalErosionDamage = param1.maxCriticalErosionDamage * _loc11_ / 100;
         _loc46_.maxCriticalErosionDamage = _loc46_.maxCriticalErosionDamage * _loc10_ / 100;
         _loc46_.hasCritical = param1.hasCriticalDamage;
         return _loc46_;
      }
      
      private static function getDamage(param1:int, param2:Boolean, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int) : int
      {
         if(!param2 && param3 + param4 <= 0)
         {
            param3 = param4 = 0;
         }
         var _loc13_:int;
         return (_loc13_ = (_loc13_ = int((_loc12_ = int((_loc11_ = int(param1 > 0?int(Math.floor(param1 * (100 + param3 + param4) / 100) + param5 + param6):0)) > 0?int((_loc11_ + param7) * param10 / 100):0)) > 0?int(_loc12_ - param8):0)) < 0?0:int(_loc13_)) * param9 / 100;
      }
      
      private static function getMidLifeDamageMultiplier(param1:int) : Number
      {
         return Math.pow(Math.cos(2 * Math.PI * (param1 * 0.01 - 0.5)) + 1,2) / 4;
      }
      
      private static function getDistance(param1:uint, param2:uint) : int
      {
         return MapPoint.fromCellId(param1).distanceToCell(MapPoint.fromCellId(param2));
      }
      
      private static function getSquareDistance(param1:uint, param2:uint) : int
      {
         var _loc3_:MapPoint = MapPoint.fromCellId(param1);
         var _loc4_:MapPoint = MapPoint.fromCellId(param2);
         return Math.max(Math.abs(_loc3_.x - _loc4_.x),Math.abs(_loc3_.y - _loc4_.y));
      }
      
      public static function getShapeEfficiency(param1:uint, param2:uint, param3:uint, param4:int, param5:int, param6:int, param7:int) : Number
      {
         var _loc8_:int = 0;
         switch(param1)
         {
            case SpellShapeEnum.A:
            case SpellShapeEnum.a:
            case SpellShapeEnum.Z:
            case SpellShapeEnum.I:
            case SpellShapeEnum.O:
            case SpellShapeEnum.semicolon:
            case SpellShapeEnum.empty:
            case SpellShapeEnum.P:
               return DAMAGE_NOT_BOOSTED;
            case SpellShapeEnum.B:
            case SpellShapeEnum.V:
            case SpellShapeEnum.G:
            case SpellShapeEnum.W:
               _loc8_ = getSquareDistance(param2,param3);
               break;
            case SpellShapeEnum.minus:
            case SpellShapeEnum.plus:
            case SpellShapeEnum.U:
               _loc8_ = getDistance(param2,param3) / 2;
               break;
            default:
               _loc8_ = getDistance(param2,param3);
         }
         return getSimpleEfficiency(_loc8_,param4,param5,param6,param7);
      }
      
      public static function getSimpleEfficiency(param1:int, param2:int, param3:int, param4:int, param5:int) : Number
      {
         if(param4 == 0)
         {
            return DAMAGE_NOT_BOOSTED;
         }
         if(param2 <= 0 || param2 >= UNLIMITED_ZONE_SIZE)
         {
            return DAMAGE_NOT_BOOSTED;
         }
         if(param1 > param2)
         {
            return DAMAGE_NOT_BOOSTED;
         }
         if(param4 <= 0)
         {
            return DAMAGE_NOT_BOOSTED;
         }
         if(param3 != 0)
         {
            if(param1 <= param3)
            {
               return DAMAGE_NOT_BOOSTED;
            }
            return Math.max(0,DAMAGE_NOT_BOOSTED - 0.01 * Math.min(param1 - param3,param5) * param4);
         }
         return Math.max(0,DAMAGE_NOT_BOOSTED - 0.01 * Math.min(param1,param5) * param4);
      }
      
      public static function getPortalsSpellEfficiencyBonus(param1:int) : Number
      {
         var _loc2_:Boolean = false;
         var _loc3_:MapPoint = null;
         var _loc4_:Vector.<MarkInstance> = null;
         var _loc5_:int = 0;
         var _loc6_:MarkInstance = null;
         var _loc7_:MarkInstance = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = 1;
         var _loc11_:Vector.<MapPoint> = MarkedCellsManager.getInstance().getMarksMapPoint(GameActionMarkTypeEnum.PORTAL);
         for each(_loc3_ in _loc11_)
         {
            if(_loc3_.cellId == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         if(!_loc2_)
         {
            return _loc10_;
         }
         var _loc13_:int;
         var _loc12_:Vector.<uint>;
         if((_loc13_ = (_loc12_ = LinkedCellsManager.getInstance().getLinks(MapPoint.fromCellId(param1),_loc11_)).length) > 1)
         {
            _loc4_ = new Vector.<MarkInstance>(0);
            _loc5_ = 0;
            while(_loc5_ < _loc13_)
            {
               _loc4_.push(MarkedCellsManager.getInstance().getMarkAtCellId(_loc12_[_loc5_],GameActionMarkTypeEnum.PORTAL));
               _loc5_++;
            }
            _loc5_ = 0;
            while(_loc5_ < _loc13_)
            {
               _loc6_ = _loc4_[_loc5_];
               _loc8_ = Math.max(_loc8_,int(_loc6_.associatedSpellLevel.effects[0].parameter2));
               if(_loc7_)
               {
                  _loc9_ = _loc9_ + MapPoint.fromCellId(_loc6_.cells[0]).distanceToCell(MapPoint.fromCellId(_loc7_.cells[0]));
               }
               _loc7_ = _loc6_;
               _loc5_++;
            }
            _loc10_ = 1 + (_loc8_ + _loc4_.length * _loc9_) / 100;
         }
         return _loc10_;
      }
      
      public static function getSplashDamages(param1:Vector.<TriggeredSpell>, param2:SpellDamageInfo) : Vector.<SplashDamage>
      {
         var _loc3_:Vector.<SplashDamage> = null;
         var _loc4_:TriggeredSpell = null;
         var _loc5_:SpellWrapper = null;
         var _loc6_:EffectInstance = null;
         var _loc7_:IZone = null;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:uint = 0;
         var _loc10_:Vector.<int> = null;
         var _loc11_:Array = null;
         var _loc12_:IEntity = null;
         var _loc13_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         var _loc14_:uint = EntitiesManager.getInstance().getEntity(param2.casterId).position.cellId;
         for each(_loc4_ in param1)
         {
            _loc5_ = _loc4_.spell;
            for each(_loc6_ in _loc5_.effects)
            {
               if(SPLASH_EFFECTS_IDS.indexOf(_loc6_.effectId) != -1)
               {
                  _loc8_ = (_loc7_ = SpellZoneManager.getInstance().getSpellZone(_loc5_,false,false)).getCells(param2.targetCell);
                  _loc10_ = null;
                  if(_loc6_.targetMask && _loc6_.targetMask.indexOf("O") != -1 && _loc8_.indexOf(_loc14_) == -1)
                  {
                     _loc8_.push(_loc14_);
                  }
                  for each(_loc9_ in _loc8_)
                  {
                     _loc11_ = EntitiesManager.getInstance().getEntitiesOnCell(_loc9_,AnimatedCharacter);
                     for each(_loc12_ in _loc11_)
                     {
                        if(_loc13_.getEntityInfos(_loc12_.id) && verifySpellEffectMask(_loc5_.playerId,_loc12_.id,_loc6_,param2.targetCell,param2.casterId))
                        {
                           if(!_loc3_)
                           {
                              _loc3_ = new Vector.<SplashDamage>(0);
                           }
                           if(!_loc10_)
                           {
                              _loc10_ = new Vector.<int>(0);
                           }
                           _loc10_.push(_loc12_.id);
                        }
                     }
                  }
                  if(_loc10_)
                  {
                     _loc3_.push(new SplashDamage(_loc5_.id,_loc5_.playerId,_loc10_,DamageUtil.getSpellDamage(param2,false,false),_loc6_.effectId,(_loc6_ as EffectInstanceDice).diceNum,Effect.getEffectById(_loc6_.effectId).elementId,_loc6_.random,_loc6_.rawZone.charCodeAt(0),_loc6_.zoneSize,_loc6_.zoneMinSize,_loc6_.zoneEfficiencyPercent,_loc6_.zoneMaxEfficiency,_loc4_.hasCritical));
                  }
               }
            }
         }
         return _loc3_;
      }
      
      public static function getAverageElementResistance(param1:uint, param2:Vector.<int>) : int
      {
         var _loc3_:String = null;
         switch(param1)
         {
            case NEUTRAL_ELEMENT:
               _loc3_ = "neutralElementResistPercent";
               break;
            case EARTH_ELEMENT:
               _loc3_ = "earthElementResistPercent";
               break;
            case FIRE_ELEMENT:
               _loc3_ = "fireElementResistPercent";
               break;
            case WATER_ELEMENT:
               _loc3_ = "waterElementResistPercent";
               break;
            case AIR_ELEMENT:
               _loc3_ = "airElementResistPercent";
         }
         return getAverageStat(_loc3_,param2);
      }
      
      public static function getAverageElementReduction(param1:uint, param2:Vector.<int>) : int
      {
         var _loc3_:String = null;
         switch(param1)
         {
            case NEUTRAL_ELEMENT:
               _loc3_ = "neutralElementReduction";
               break;
            case EARTH_ELEMENT:
               _loc3_ = "earthElementReduction";
               break;
            case FIRE_ELEMENT:
               _loc3_ = "fireElementReduction";
               break;
            case WATER_ELEMENT:
               _loc3_ = "waterElementReduction";
               break;
            case AIR_ELEMENT:
               _loc3_ = "airElementReduction";
         }
         return getAverageStat(_loc3_,param2);
      }
      
      public static function getAverageBuffElementReduction(param1:SpellDamageInfo, param2:EffectDamage, param3:Vector.<int>) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for each(_loc5_ in param3)
         {
            _loc4_ = _loc4_ + getBuffElementReduction(param1,param2,_loc5_);
         }
         return _loc4_ / param3.length;
      }
      
      public static function getBuffElementReduction(param1:SpellDamageInfo, param2:EffectDamage, param3:int) : int
      {
         var _loc4_:BasicBuff = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:EffectInstance = null;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:Array = BuffManager.getInstance().getAllBuff(param3);
         var _loc12_:Dictionary = new Dictionary(true);
         (_loc8_ = new EffectInstance()).effectId = param2.effectId;
         for each(_loc4_ in _loc11_)
         {
            _loc6_ = _loc4_.effect.triggers;
            if(!(_loc10_ = _loc4_.canBeDispell() && _loc4_.effect.duration - param1.spellTargetEffectsDurationReduction <= 0) && _loc6_)
            {
               _loc7_ = _loc6_.split("|");
               if(!_loc12_[_loc4_.castingSpell.spell.id])
               {
                  _loc12_[_loc4_.castingSpell.spell.id] = new Vector.<int>(0);
               }
               for each(_loc5_ in _loc7_)
               {
                  if(_loc4_.actionId == 265 && verifyEffectTrigger(param1.casterId,param3,null,_loc8_,param1.isWeapon,_loc5_,param1.spellCenterCell))
                  {
                     if(_loc12_[_loc4_.castingSpell.spell.id].indexOf(param2.element) == -1)
                     {
                        _loc9_ = _loc9_ + (param1.targetLevel / 20 + 1) * (_loc4_.effect as EffectInstanceInteger).value;
                        if(_loc12_[_loc4_.castingSpell.spell.id].indexOf(param2.element) == -1)
                        {
                           _loc12_[_loc4_.castingSpell.spell.id].push(param2.element);
                        }
                     }
                  }
               }
            }
         }
         return _loc9_;
      }
      
      public static function getAverageStat(param1:String, param2:Vector.<int>) : int
      {
         var _loc3_:int = 0;
         var _loc4_:GameFightFighterInformations = null;
         var _loc5_:int = 0;
         var _loc6_:FightEntitiesFrame;
         if(!(_loc6_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame) || !param2 || param2.length == 0)
         {
            return -1;
         }
         if(param1)
         {
            for each(_loc3_ in param2)
            {
               _loc4_ = _loc6_.getEntityInfos(_loc3_) as GameFightFighterInformations;
               _loc5_ = _loc5_ + _loc4_.stats[param1];
            }
         }
         return _loc5_ / param2.length;
      }
   }
}
