package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceInteger;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceMinMax;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.internalDatacenter.items.WeaponWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellZoneManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.logic.game.fight.miscs.DamageUtil;
   import com.ankamagames.dofus.network.enums.CharacterSpellModificationTypeEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.IZone;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SpellDamageInfo
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellDamageInfo));
       
      
      private var _targetId:int;
      
      private var _targetInfos:GameFightFighterInformations;
      
      private var _originalTargetsIds:Vector.<int>;
      
      private var _buffsWithSpellsTriggered:Vector.<uint>;
      
      private var _effectsModifications:Vector.<EffectModification>;
      
      private var _criticalEffectsModifications:Vector.<EffectModification>;
      
      public var isWeapon:Boolean;
      
      public var isHealingSpell:Boolean;
      
      public var casterId:int;
      
      public var casterLevel:int;
      
      public var casterStrength:int;
      
      public var casterChance:int;
      
      public var casterAgility:int;
      
      public var casterIntelligence:int;
      
      public var casterLifePointsAfterNormalMinDamage:uint;
      
      public var casterLifePointsAfterNormalMaxDamage:uint;
      
      public var casterLifePointsAfterCriticalMinDamage:uint;
      
      public var casterLifePointsAfterCriticalMaxDamage:uint;
      
      public var targetLifePointsAfterNormalMinDamage:uint;
      
      public var targetLifePointsAfterNormalMaxDamage:uint;
      
      public var targetLifePointsAfterCriticalMinDamage:uint;
      
      public var targetLifePointsAfterCriticalMaxDamage:uint;
      
      public var casterStrengthBonus:int;
      
      public var casterChanceBonus:int;
      
      public var casterAgilityBonus:int;
      
      public var casterIntelligenceBonus:int;
      
      public var casterCriticalStrengthBonus:int;
      
      public var casterCriticalChanceBonus:int;
      
      public var casterCriticalAgilityBonus:int;
      
      public var casterCriticalIntelligenceBonus:int;
      
      public var casterCriticalHit:int;
      
      public var casterCriticalHitWeapon:int;
      
      public var casterHealBonus:int;
      
      public var casterAllDamagesBonus:int;
      
      public var casterDamagesBonus:int;
      
      public var casterSpellDamagesBonus:int;
      
      public var casterWeaponDamagesBonus:int;
      
      public var casterTrapBonus:int;
      
      public var casterTrapBonusPercent:int;
      
      public var casterGlyphBonusPercent:int;
      
      public var casterPermanentDamagePercent:int;
      
      public var casterPushDamageBonus:int;
      
      public var casterCriticalPushDamageBonus:int;
      
      public var casterCriticalDamageBonus:int;
      
      public var casterNeutralDamageBonus:int;
      
      public var casterEarthDamageBonus:int;
      
      public var casterWaterDamageBonus:int;
      
      public var casterAirDamageBonus:int;
      
      public var casterFireDamageBonus:int;
      
      public var casterDamageBoostPercent:int;
      
      public var casterDamageDeboostPercent:int;
      
      public var casterStates:Array;
      
      public var spellEffects:Vector.<EffectInstance>;
      
      public var spellCriticalEffects:Vector.<EffectInstance>;
      
      public var spellCenterCell:int;
      
      public var neutralDamage:SpellDamage;
      
      public var earthDamage:SpellDamage;
      
      public var fireDamage:SpellDamage;
      
      public var waterDamage:SpellDamage;
      
      public var airDamage:SpellDamage;
      
      public var buffDamage:SpellDamage;
      
      public var fixedDamage:SpellDamage;
      
      public var reflectDamage:SpellDamage;
      
      public var spellWeaponCriticalBonus:int;
      
      public var spellShape:uint;
      
      public var spellShapeSize:Object;
      
      public var spellShapeMinSize:Object;
      
      public var spellShapeEfficiencyPercent:Object;
      
      public var spellShapeMaxEfficiency:Object;
      
      public var healDamage:SpellDamage;
      
      public var spellHasCriticalDamage:Boolean;
      
      public var spellHasCriticalHeal:Boolean;
      
      public var spellHasRandomEffects:Boolean;
      
      public var spellDamageModification:CharacterSpellModification;
      
      public var targetLevel:int;
      
      public var targetIsInvulnerable:Boolean;
      
      public var targetIsUnhealable:Boolean;
      
      public var targetCell:int = -1;
      
      public var targetShieldPoints:uint;
      
      public var targetTriggeredShieldPoints:uint;
      
      public var targetNeutralElementResistPercent:int;
      
      public var targetEarthElementResistPercent:int;
      
      public var targetWaterElementResistPercent:int;
      
      public var targetAirElementResistPercent:int;
      
      public var targetFireElementResistPercent:int;
      
      public var targetBuffs:Array;
      
      public var targetStates:Array;
      
      public var targetNeutralElementReduction:int;
      
      public var targetEarthElementReduction:int;
      
      public var targetWaterElementReduction:int;
      
      public var targetAirElementReduction:int;
      
      public var targetFireElementReduction:int;
      
      public var targetCriticalDamageFixedResist:int;
      
      public var targetPushDamageFixedResist:int;
      
      public var targetErosionLifePoints:int;
      
      public var targetSpellMinErosionLifePoints:int;
      
      public var targetSpellMaxErosionLifePoints:int;
      
      public var targetSpellMinCriticalErosionLifePoints:int;
      
      public var targetSpellMaxCriticalErosionLifePoints:int;
      
      public var targetErosionPercentBonus:int;
      
      public var pushedEntities:Vector.<PushedEntity>;
      
      public var splashDamages:Vector.<SplashDamage>;
      
      public var sharedDamage:SpellDamage;
      
      public var damageSharingTargets:Vector.<int>;
      
      public var portalsSpellEfficiencyBonus:Number;
      
      public var spellTargetEffectsDurationReduction:int;
      
      public var spellTargetEffectsDurationCriticalReduction:int;
      
      public function SpellDamageInfo()
      {
         super();
      }
      
      public static function fromCurrentPlayer(param1:Object, param2:int, param3:int) : SpellDamageInfo
      {
         var _loc4_:SpellDamageInfo = null;
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:AnimatedCharacter = null;
         var _loc8_:EffectInstance = null;
         var _loc9_:EffectInstanceDice = null;
         var _loc10_:EffectDamage = null;
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Array = null;
         var _loc18_:BasicBuff = null;
         var _loc19_:Dictionary = null;
         var _loc20_:Vector.<BasicBuff> = null;
         var _loc21_:* = undefined;
         var _loc22_:SpellWrapper = null;
         var _loc23_:Boolean = false;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:EffectInstance = null;
         var _loc33_:WeaponWrapper = null;
         var _loc34_:FightContextFrame;
         if(!(_loc34_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame))
         {
            return _loc4_;
         }
         (_loc4_ = new SpellDamageInfo())._originalTargetsIds = new Vector.<int>(0);
         _loc4_.targetId = param2;
         _loc4_.casterId = CurrentPlayedFighterManager.getInstance().currentFighterId;
         _loc4_.casterStates = FightersStateManager.getInstance().getStates(_loc4_.casterId);
         _loc4_.casterLevel = _loc34_.getFighterLevel(_loc4_.casterId);
         _loc4_.spellEffects = param1.effects;
         _loc4_.spellCriticalEffects = param1.criticalEffect;
         _loc4_.isWeapon = !(param1 is SpellWrapper);
         var _loc35_:GameFightFighterInformations = _loc34_.entitiesFrame.getEntityInfos(_loc4_.casterId) as GameFightFighterInformations;
         var _loc36_:IZone;
         (_loc36_ = SpellZoneManager.getInstance().getSpellZone(param1,false,false)).direction = MapPoint.fromCellId(_loc35_.disposition.cellId).advancedOrientationTo(MapPoint.fromCellId(FightContextFrame.currentCell),false);
         var _loc37_:Vector.<uint> = _loc36_.getCells(param3);
         for each(_loc5_ in _loc37_)
         {
            _loc6_ = EntitiesManager.getInstance().getEntitiesOnCell(_loc5_,AnimatedCharacter);
            for each(_loc7_ in _loc6_)
            {
               if(_loc34_.entitiesFrame.getEntityInfos(_loc7_.id) && _loc4_._originalTargetsIds.indexOf(_loc7_.id) == -1 && DamageUtil.isDamagedOrHealedBySpell(_loc4_.casterId,_loc7_.id,param1,param3))
               {
                  _loc4_._originalTargetsIds.push(_loc7_.id);
               }
            }
         }
         if(_loc4_._originalTargetsIds.indexOf(_loc4_.casterId) == -1 && param1 is SpellWrapper && (param1 as SpellWrapper).canTargetCasterOutOfZone)
         {
            _loc4_._originalTargetsIds.push(_loc4_.casterId);
         }
         if(param1 is SpellWrapper)
         {
            for each(_loc32_ in param1.effects)
            {
               if(_loc32_.targetMask.indexOf("E263") != -1 && _loc36_.radius == 63 && _loc4_._targetInfos.disposition.cellId == -1)
               {
                  _loc4_._originalTargetsIds.push(param2);
                  break;
               }
            }
         }
         var _loc38_:CharacterCharacteristicsInformations = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations();
         _loc4_.casterStrength = _loc38_.strength.base + _loc38_.strength.additionnal + _loc38_.strength.objectsAndMountBonus + _loc38_.strength.alignGiftBonus + _loc38_.strength.contextModif;
         _loc4_.casterChance = _loc38_.chance.base + _loc38_.chance.additionnal + _loc38_.chance.objectsAndMountBonus + _loc38_.chance.alignGiftBonus + _loc38_.chance.contextModif;
         _loc4_.casterAgility = _loc38_.agility.base + _loc38_.agility.additionnal + _loc38_.agility.objectsAndMountBonus + _loc38_.agility.alignGiftBonus + _loc38_.agility.contextModif;
         _loc4_.casterIntelligence = _loc38_.intelligence.base + _loc38_.intelligence.additionnal + _loc38_.intelligence.objectsAndMountBonus + _loc38_.intelligence.alignGiftBonus + _loc38_.intelligence.contextModif;
         _loc4_.casterCriticalHit = _loc38_.criticalHit.base + _loc38_.criticalHit.additionnal + _loc38_.criticalHit.objectsAndMountBonus + _loc38_.criticalHit.alignGiftBonus + _loc38_.criticalHit.contextModif;
         _loc4_.casterCriticalHitWeapon = _loc38_.criticalHitWeapon;
         _loc4_.casterHealBonus = _loc38_.healBonus.base + _loc38_.healBonus.additionnal + _loc38_.healBonus.objectsAndMountBonus + _loc38_.healBonus.alignGiftBonus + _loc38_.healBonus.contextModif;
         _loc4_.casterAllDamagesBonus = _loc38_.allDamagesBonus.base + _loc38_.allDamagesBonus.additionnal + _loc38_.allDamagesBonus.objectsAndMountBonus + _loc38_.allDamagesBonus.alignGiftBonus + _loc38_.allDamagesBonus.contextModif;
         _loc4_.casterDamagesBonus = _loc38_.damagesBonusPercent.base + _loc38_.damagesBonusPercent.additionnal + _loc38_.damagesBonusPercent.objectsAndMountBonus + _loc38_.damagesBonusPercent.alignGiftBonus + _loc38_.damagesBonusPercent.contextModif;
         _loc4_.casterTrapBonus = _loc38_.trapBonus.base + _loc38_.trapBonus.additionnal + _loc38_.trapBonus.objectsAndMountBonus + _loc38_.trapBonus.alignGiftBonus + _loc38_.trapBonus.contextModif;
         _loc4_.casterTrapBonusPercent = _loc38_.trapBonusPercent.base + _loc38_.trapBonusPercent.additionnal + _loc38_.trapBonusPercent.objectsAndMountBonus + _loc38_.trapBonusPercent.alignGiftBonus + _loc38_.trapBonusPercent.contextModif;
         _loc4_.casterGlyphBonusPercent = _loc38_.glyphBonusPercent.base + _loc38_.glyphBonusPercent.additionnal + _loc38_.glyphBonusPercent.objectsAndMountBonus + _loc38_.glyphBonusPercent.alignGiftBonus + _loc38_.glyphBonusPercent.contextModif;
         _loc4_.casterPermanentDamagePercent = _loc38_.permanentDamagePercent.base + _loc38_.permanentDamagePercent.additionnal + _loc38_.permanentDamagePercent.objectsAndMountBonus + _loc38_.permanentDamagePercent.alignGiftBonus + _loc38_.permanentDamagePercent.contextModif;
         _loc4_.casterPushDamageBonus = _loc38_.pushDamageBonus.base + _loc38_.pushDamageBonus.additionnal + _loc38_.pushDamageBonus.objectsAndMountBonus + _loc38_.pushDamageBonus.alignGiftBonus + _loc38_.pushDamageBonus.contextModif;
         _loc4_.casterCriticalPushDamageBonus = _loc38_.pushDamageBonus.base + _loc38_.pushDamageBonus.additionnal + _loc38_.pushDamageBonus.objectsAndMountBonus + _loc38_.pushDamageBonus.alignGiftBonus;
         _loc4_.casterCriticalDamageBonus = _loc38_.criticalDamageBonus.base + _loc38_.criticalDamageBonus.additionnal + _loc38_.criticalDamageBonus.objectsAndMountBonus + _loc38_.criticalDamageBonus.alignGiftBonus + _loc38_.criticalDamageBonus.contextModif;
         _loc4_.casterNeutralDamageBonus = _loc38_.neutralDamageBonus.base + _loc38_.neutralDamageBonus.additionnal + _loc38_.neutralDamageBonus.objectsAndMountBonus + _loc38_.neutralDamageBonus.alignGiftBonus + _loc38_.neutralDamageBonus.contextModif;
         _loc4_.casterEarthDamageBonus = _loc38_.earthDamageBonus.base + _loc38_.earthDamageBonus.additionnal + _loc38_.earthDamageBonus.objectsAndMountBonus + _loc38_.earthDamageBonus.alignGiftBonus + _loc38_.earthDamageBonus.contextModif;
         _loc4_.casterWaterDamageBonus = _loc38_.waterDamageBonus.base + _loc38_.waterDamageBonus.additionnal + _loc38_.waterDamageBonus.objectsAndMountBonus + _loc38_.waterDamageBonus.alignGiftBonus + _loc38_.waterDamageBonus.contextModif;
         _loc4_.casterAirDamageBonus = _loc38_.airDamageBonus.base + _loc38_.airDamageBonus.additionnal + _loc38_.airDamageBonus.objectsAndMountBonus + _loc38_.airDamageBonus.alignGiftBonus + _loc38_.airDamageBonus.contextModif;
         _loc4_.casterFireDamageBonus = _loc38_.fireDamageBonus.base + _loc38_.fireDamageBonus.additionnal + _loc38_.fireDamageBonus.objectsAndMountBonus + _loc38_.fireDamageBonus.alignGiftBonus + _loc38_.fireDamageBonus.contextModif;
         _loc4_.portalsSpellEfficiencyBonus = DamageUtil.getPortalsSpellEfficiencyBonus(FightContextFrame.currentCell);
         _loc4_.neutralDamage = DamageUtil.getSpellElementDamage(param1,DamageUtil.NEUTRAL_ELEMENT,_loc4_.casterId,param2,param3);
         _loc4_.earthDamage = DamageUtil.getSpellElementDamage(param1,DamageUtil.EARTH_ELEMENT,_loc4_.casterId,param2,param3);
         _loc4_.fireDamage = DamageUtil.getSpellElementDamage(param1,DamageUtil.FIRE_ELEMENT,_loc4_.casterId,param2,param3);
         _loc4_.waterDamage = DamageUtil.getSpellElementDamage(param1,DamageUtil.WATER_ELEMENT,_loc4_.casterId,param2,param3);
         _loc4_.airDamage = DamageUtil.getSpellElementDamage(param1,DamageUtil.AIR_ELEMENT,_loc4_.casterId,param2,param3);
         _loc4_.spellHasCriticalDamage = _loc4_.isWeapon && PlayedCharacterManager.getInstance().currentWeapon.criticalHitProbability > 0 || _loc4_.neutralDamage.hasCriticalDamage || _loc4_.earthDamage.hasCriticalDamage || _loc4_.fireDamage.hasCriticalDamage || _loc4_.waterDamage.hasCriticalDamage || _loc4_.airDamage.hasCriticalDamage;
         _loc4_.reflectDamage = new SpellDamage();
         if(_loc4_.targetId == _loc4_.casterId)
         {
            _loc4_.reflectDamage = _loc4_.getReflectDamage();
         }
         _loc4_.fixedDamage = new SpellDamage();
         _loc4_.healDamage = new SpellDamage();
         for each(_loc8_ in param1.effects)
         {
            if(DamageUtil.HEALING_EFFECTS_IDS.indexOf(_loc8_.effectId) != -1 && (_loc8_.effectId != 90 || param2 != _loc4_.casterId))
            {
               if(DamageUtil.verifySpellEffectMask(_loc4_.casterId,param2,_loc8_,param3))
               {
                  _loc11_ = true;
               }
            }
            else if(_loc8_.category == DamageUtil.DAMAGE_EFFECT_CATEGORY && DamageUtil.verifySpellEffectMask(_loc4_.casterId,param2,_loc8_,param3))
            {
               _loc11_ = false;
               break;
            }
         }
         _loc4_.isHealingSpell = _loc11_;
         _loc12_ = getMinimumDamageEffectOrder(_loc4_.casterId,param2,param1.effects,param3);
         _loc15_ = param1.effects.length;
         _loc13_ = 0;
         while(_loc13_ < _loc15_)
         {
            _loc8_ = param1.effects[_loc13_];
            if(DamageUtil.verifySpellEffectMask(_loc4_.casterId,param2,_loc8_,param3))
            {
               _loc9_ = _loc8_ as EffectInstanceDice;
               if(DamageUtil.HEALING_EFFECTS_IDS.indexOf(_loc8_.effectId) != -1)
               {
                  _loc10_ = new EffectDamage(_loc8_.effectId,-1,_loc8_.random);
                  if(_loc8_.effectId == 90)
                  {
                     if(param2 != _loc4_.casterId)
                     {
                        _loc4_.healDamage.addEffectDamage(_loc10_);
                        _loc10_.lifePointsAddedBasedOnLifePercent = _loc10_.lifePointsAddedBasedOnLifePercent + _loc9_.diceNum * _loc38_.lifePoints / 100;
                     }
                     else
                     {
                        _loc4_.fixedDamage.addEffectDamage(_loc10_);
                        _loc10_.minDamage = _loc10_.maxDamage = _loc9_.diceNum * _loc38_.lifePoints / 100;
                     }
                  }
                  else
                  {
                     _loc4_.healDamage.addEffectDamage(_loc10_);
                     if(_loc8_.effectId == 1109)
                     {
                        if(_loc4_.targetInfos)
                        {
                           _loc10_.lifePointsAddedBasedOnLifePercent = _loc10_.lifePointsAddedBasedOnLifePercent + _loc9_.diceNum * _loc4_.targetInfos.stats.maxLifePoints / 100;
                        }
                     }
                     else
                     {
                        _loc10_.minLifePointsAdded = _loc10_.minLifePointsAdded + _loc9_.diceNum;
                        _loc10_.maxLifePointsAdded = _loc10_.maxLifePointsAdded + (_loc9_.diceSide == 0?_loc9_.diceNum:_loc9_.diceSide);
                     }
                  }
               }
               else if(DamageUtil.IMMEDIATE_BOOST_EFFECTS_IDS.indexOf(_loc8_.effectId) != -1 && _loc13_ < _loc12_)
               {
                  switch(_loc8_.effectId)
                  {
                     case 266:
                        _loc4_.casterChanceBonus = _loc4_.casterChanceBonus + _loc9_.diceNum;
                        break;
                     case 268:
                        _loc4_.casterAgilityBonus = _loc4_.casterAgilityBonus + _loc9_.diceNum;
                        break;
                     case 269:
                        _loc4_.casterIntelligenceBonus = _loc4_.casterIntelligenceBonus + _loc9_.diceNum;
                        break;
                     case 271:
                        _loc4_.casterStrengthBonus = _loc4_.casterStrengthBonus + _loc9_.diceNum;
                        break;
                     case 414:
                        _loc4_.casterPushDamageBonus = _loc4_.casterPushDamageBonus + _loc9_.diceNum;
                  }
               }
               if((_loc12_ == -1 || _loc13_ < _loc12_) && _loc8_.effectId == 1075)
               {
                  _loc4_.spellTargetEffectsDurationReduction = _loc9_.diceNum;
               }
            }
            _loc13_++;
         }
         var _loc39_:int = _loc4_.healDamage.effectDamages.length;
         var _loc41_:int = (_loc40_ = int(!!param1.criticalEffect?int(param1.criticalEffect.length):0)) > 0?int(getMinimumDamageEffectOrder(_loc4_.casterId,param2,param1.criticalEffect,param3)):0;
         _loc13_ = 0;
         while(_loc13_ < _loc40_)
         {
            _loc8_ = param1.criticalEffect[_loc13_];
            if(DamageUtil.verifySpellEffectMask(_loc4_.casterId,param2,_loc8_,param3))
            {
               _loc9_ = _loc8_ as EffectInstanceDice;
               if(DamageUtil.HEALING_EFFECTS_IDS.indexOf(_loc8_.effectId) != -1)
               {
                  if(_loc8_.effectId == 90 && param2 == _loc4_.casterId)
                  {
                     _loc10_ = _loc4_.fixedDamage.effectDamages[_loc14_];
                     _loc14_++;
                  }
                  else if(_loc13_ < _loc39_)
                  {
                     _loc10_ = _loc4_.healDamage.effectDamages[_loc13_];
                  }
                  else
                  {
                     _loc10_ = new EffectDamage(_loc8_.effectId,-1,_loc8_.random);
                     _loc4_.healDamage.addEffectDamage(_loc10_);
                  }
                  if(_loc8_.effectId == 1109)
                  {
                     if(_loc4_.targetInfos)
                     {
                        _loc10_.criticalLifePointsAddedBasedOnLifePercent = _loc10_.criticalLifePointsAddedBasedOnLifePercent + _loc9_.diceNum * _loc4_.targetInfos.stats.maxLifePoints / 100;
                     }
                  }
                  else if(_loc8_.effectId == 90)
                  {
                     if(param2 != _loc4_.casterId)
                     {
                        _loc10_.criticalLifePointsAddedBasedOnLifePercent = _loc10_.criticalLifePointsAddedBasedOnLifePercent + _loc9_.diceNum * _loc38_.lifePoints / 100;
                     }
                     else
                     {
                        _loc10_.minCriticalDamage = _loc10_.maxCriticalDamage = _loc9_.diceNum * _loc38_.lifePoints / 100;
                        _loc4_.spellHasCriticalDamage = _loc4_.fixedDamage.hasCriticalDamage = _loc10_.hasCritical = true;
                     }
                  }
                  else
                  {
                     _loc10_.minCriticalLifePointsAdded = _loc10_.minCriticalLifePointsAdded + _loc9_.diceNum;
                     _loc10_.maxCriticalLifePointsAdded = _loc10_.maxCriticalLifePointsAdded + (_loc9_.diceSide == 0?_loc9_.diceNum:_loc9_.diceSide);
                  }
                  _loc4_.spellHasCriticalHeal = true;
               }
               else if(DamageUtil.IMMEDIATE_BOOST_EFFECTS_IDS.indexOf(_loc8_.effectId) != -1 && _loc13_ < _loc41_)
               {
                  switch(_loc8_.effectId)
                  {
                     case 266:
                        _loc4_.casterCriticalChanceBonus = _loc4_.casterCriticalChanceBonus + _loc9_.diceNum;
                        break;
                     case 268:
                        _loc4_.casterCriticalAgilityBonus = _loc4_.casterCriticalAgilityBonus + _loc9_.diceNum;
                        break;
                     case 269:
                        _loc4_.casterCriticalIntelligenceBonus = _loc4_.casterCriticalIntelligenceBonus + _loc9_.diceNum;
                        break;
                     case 271:
                        _loc4_.casterCriticalStrengthBonus = _loc4_.casterCriticalStrengthBonus + _loc9_.diceNum;
                        break;
                     case 414:
                        _loc4_.casterCriticalPushDamageBonus = _loc4_.casterCriticalPushDamageBonus + _loc9_.diceNum;
                  }
               }
               if((_loc41_ == -1 || _loc13_ < _loc41_) && _loc8_.effectId == 1075)
               {
                  _loc4_.spellTargetEffectsDurationCriticalReduction = _loc9_.diceNum;
               }
            }
            _loc13_++;
         }
         _loc4_.spellHasRandomEffects = _loc4_.neutralDamage.hasRandomEffects || _loc4_.earthDamage.hasRandomEffects || _loc4_.fireDamage.hasRandomEffects || _loc4_.waterDamage.hasRandomEffects || _loc4_.airDamage.hasRandomEffects || _loc4_.healDamage.hasRandomEffects;
         if(_loc4_.isWeapon)
         {
            _loc33_ = PlayedCharacterManager.getInstance().currentWeapon;
            _loc4_.spellWeaponCriticalBonus = _loc33_.criticalHitBonus;
            if(_loc33_.type.id == 7)
            {
               _loc4_.spellShapeEfficiencyPercent = 25;
            }
         }
         _loc4_.spellCenterCell = param3;
         for each(_loc8_ in param1.effects)
         {
            if(_loc8_.category == DamageUtil.DAMAGE_EFFECT_CATEGORY || DamageUtil.HEALING_EFFECTS_IDS.indexOf(_loc8_.effectId) != -1)
            {
               if(_loc8_.rawZone)
               {
                  _loc4_.spellShape = _loc8_.rawZone.charCodeAt(0);
                  _loc4_.spellShapeSize = _loc8_.zoneSize;
                  _loc4_.spellShapeMinSize = _loc8_.zoneMinSize;
                  _loc4_.spellShapeEfficiencyPercent = _loc8_.zoneEfficiencyPercent;
                  _loc4_.spellShapeMaxEfficiency = _loc8_.zoneMaxEfficiency;
                  break;
               }
            }
         }
         _loc17_ = BuffManager.getInstance().getAllBuff(_loc4_.casterId);
         _loc19_ = groupBuffsBySpell(_loc17_);
         _loc25_ = -1;
         _loc26_ = 0;
         for(_loc21_ in _loc19_)
         {
            _loc20_ = _loc19_[_loc21_];
            if(_loc21_ == param1.id)
            {
               _loc22_ = param1 as SpellWrapper;
               _loc23_ = false;
               for each(_loc18_ in _loc20_)
               {
                  if(_loc18_.stack && _loc18_.stack.length == _loc22_.spellLevelInfos.maxStack)
                  {
                     applyBuffModification(_loc4_,_loc18_.stack[0].actionId,-_loc18_.stack[0].param1);
                     _loc23_ = true;
                  }
               }
               if(!_loc23_)
               {
                  _loc26_ = 1;
                  _loc25_ = _loc24_ = _loc20_[0].castingSpell.castingSpellId;
                  for each(_loc18_ in _loc20_)
                  {
                     if(_loc25_ != _loc18_.castingSpell.castingSpellId)
                     {
                        _loc25_ = _loc18_.castingSpell.castingSpellId;
                        _loc26_++;
                     }
                  }
                  if(_loc26_ == _loc22_.spellLevelInfos.maxStack)
                  {
                     for each(_loc18_ in _loc20_)
                     {
                        if(_loc18_.castingSpell.castingSpellId != _loc24_)
                        {
                           break;
                        }
                        applyBuffModification(_loc4_,_loc18_.actionId,-_loc18_.param1);
                     }
                  }
               }
            }
            for each(_loc18_ in _loc20_)
            {
               if(_loc18_.effect.category == DamageUtil.DAMAGE_EFFECT_CATEGORY)
               {
                  if(!_loc4_.buffDamage)
                  {
                     _loc4_.buffDamage = new SpellDamage();
                  }
                  if(_loc18_.castingSpell.spell.id == param1.id)
                  {
                     for each(_loc8_ in param1.effects)
                     {
                        if(_loc8_.effectId == _loc18_.effect.effectId)
                        {
                           break;
                        }
                     }
                  }
                  else
                  {
                     _loc8_ = _loc18_.effect;
                  }
                  if(DamageUtil.verifySpellEffectMask(_loc4_.casterId,param2,_loc8_,param3))
                  {
                     _loc27_ = Effect.getEffectById(_loc8_.effectId).elementId;
                     _loc10_ = new EffectDamage(_loc8_.effectId,_loc27_,_loc8_.random);
                     if(!(_loc8_ is EffectInstanceDice))
                     {
                        if(_loc8_ is EffectInstanceInteger)
                        {
                           _loc10_.minDamage = _loc10_.maxDamage = _loc10_.minCriticalDamage = _loc10_.maxCriticalDamage = (_loc8_ as EffectInstanceInteger).value;
                        }
                        else if(_loc8_ is EffectInstanceMinMax)
                        {
                           _loc10_.minDamage = _loc10_.minCriticalDamage = (_loc8_ as EffectInstanceMinMax).min;
                           _loc10_.maxDamage = _loc10_.maxCriticalDamage = (_loc8_ as EffectInstanceMinMax).max;
                        }
                     }
                     else
                     {
                        _loc9_ = _loc8_ as EffectInstanceDice;
                        _loc10_.minDamage = _loc10_.minCriticalDamage = _loc9_.diceNum;
                        _loc10_.maxDamage = _loc10_.maxCriticalDamage = _loc9_.diceSide == 0?int(_loc9_.diceNum):int(_loc9_.diceSide);
                     }
                     _loc28_ = _loc8_.zoneSize != null?int(int(_loc8_.zoneSize)):int(DamageUtil.EFFECTSHAPE_DEFAULT_AREA_SIZE);
                     _loc29_ = _loc8_.zoneMinSize != null?int(int(_loc8_.zoneMinSize)):int(DamageUtil.EFFECTSHAPE_DEFAULT_MIN_AREA_SIZE);
                     _loc30_ = _loc8_.zoneEfficiencyPercent != null?int(int(_loc8_.zoneEfficiencyPercent)):int(DamageUtil.EFFECTSHAPE_DEFAULT_EFFICIENCY);
                     _loc31_ = _loc8_.zoneMaxEfficiency != null?int(int(_loc8_.zoneMaxEfficiency)):int(DamageUtil.EFFECTSHAPE_DEFAULT_MAX_EFFICIENCY_APPLY);
                     _loc10_.efficiencyMultiplier = DamageUtil.getShapeEfficiency(_loc8_.rawZone.charCodeAt(0),_loc4_.targetCell,_loc4_.targetCell,_loc28_,_loc29_,_loc30_,_loc31_);
                     _loc4_.buffDamage.addEffectDamage(_loc10_);
                  }
                  continue;
               }
               switch(_loc18_.actionId)
               {
                  case 1054:
                     _loc4_.casterSpellDamagesBonus = _loc4_.casterSpellDamagesBonus + _loc18_.param1;
                     continue;
                  case 1144:
                     _loc4_.casterWeaponDamagesBonus = _loc4_.casterWeaponDamagesBonus + _loc18_.param1;
                     continue;
                  case 1171:
                     _loc4_.casterDamageBoostPercent = _loc4_.casterDamageBoostPercent + _loc18_.param1;
                     continue;
                  case 1172:
                     _loc4_.casterDamageDeboostPercent = _loc4_.casterDamageDeboostPercent + _loc18_.param1;
                     continue;
                  default:
                     continue;
               }
            }
         }
         for each(_loc18_ in _loc4_.targetBuffs)
         {
            if(!_loc18_.trigger && _loc18_.effect.effectId == 952)
            {
               if(isInvulnerableState(int(_loc18_.effect.parameter0)))
               {
                  _loc4_.targetIsInvulnerable = false;
               }
               if(isUnhealableState(int(_loc18_.effect.parameter0)))
               {
                  _loc4_.targetIsUnhealable = false;
               }
            }
            if(_loc18_.actionId == 776)
            {
               _loc4_.targetErosionPercentBonus = _loc4_.targetErosionPercentBonus + _loc18_.param1;
            }
         }
         _loc4_.spellDamageModification = CurrentPlayedFighterManager.getInstance().getSpellModifications(param1.id,CharacterSpellModificationTypeEnum.DAMAGE);
         return _loc4_;
      }
      
      private static function isInvulnerableState(param1:int) : Boolean
      {
         var _loc2_:SpellState = SpellState.getSpellStateById(param1);
         if(_loc2_)
         {
            return _loc2_.effectsIds.indexOf(7) != -1;
         }
         return false;
      }
      
      private static function isUnhealableState(param1:int) : Boolean
      {
         var _loc2_:SpellState = SpellState.getSpellStateById(param1);
         if(_loc2_)
         {
            return _loc2_.effectsIds.indexOf(5) != -1;
         }
         return false;
      }
      
      private static function applyBuffModification(param1:SpellDamageInfo, param2:int, param3:int) : void
      {
         switch(param2)
         {
            case 118:
               param1.casterStrength = param1.casterStrength + param3;
               return;
            case 119:
               param1.casterAgility = param1.casterAgility + param3;
               return;
            case 123:
               param1.casterChance = param1.casterChance + param3;
               return;
            case 126:
               param1.casterIntelligence = param1.casterIntelligence + param3;
               return;
            case 414:
               param1.casterPushDamageBonus = param1.casterPushDamageBonus + param3;
               return;
            default:
               return;
         }
      }
      
      private static function groupBuffsBySpell(param1:Array) : Dictionary
      {
         var _loc2_:Dictionary = null;
         var _loc3_:BasicBuff = null;
         for each(_loc3_ in param1)
         {
            if(!_loc2_)
            {
               _loc2_ = new Dictionary();
            }
            if(!_loc2_[_loc3_.castingSpell.spell.id])
            {
               _loc2_[_loc3_.castingSpell.spell.id] = new Vector.<BasicBuff>(0);
            }
            _loc2_[_loc3_.castingSpell.spell.id].push(_loc3_);
         }
         return _loc2_;
      }
      
      private static function getMinimumDamageEffectOrder(param1:int, param2:int, param3:Vector.<EffectInstance>, param4:int) : int
      {
         var _loc5_:EffectInstance = null;
         var _loc6_:int = 0;
         var _loc7_:uint = param3.length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            if(((_loc5_ = param3[_loc6_]).category == 2 || DamageUtil.HEALING_EFFECTS_IDS.indexOf(_loc5_.effectId) != -1 || _loc5_.effectId == 5) && DamageUtil.verifySpellEffectMask(param1,param2,_loc5_,param4))
            {
               return _loc6_;
            }
            _loc6_++;
         }
         return -1;
      }
      
      public function getEffectModification(param1:int, param2:int, param3:Boolean) : EffectModification
      {
         var _loc4_:int = 0;
         var _loc5_:int = !!this._effectsModifications?int(this._effectsModifications.length):0;
         var _loc6_:int = !!this._criticalEffectsModifications?int(this._criticalEffectsModifications.length):0;
         var _loc7_:int = param2;
         if(!param3 && this._effectsModifications)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(this._effectsModifications[_loc4_].effectId == param1)
               {
                  if(_loc7_ == 0)
                  {
                     return this._effectsModifications[_loc4_];
                  }
                  _loc7_--;
               }
               _loc4_++;
            }
         }
         else if(this._criticalEffectsModifications)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               if(this._criticalEffectsModifications[_loc4_].effectId == param1)
               {
                  if(_loc7_ == 0)
                  {
                     return this._criticalEffectsModifications[_loc4_];
                  }
                  _loc7_--;
               }
               _loc4_++;
            }
         }
         return null;
      }
      
      public function get targetId() : int
      {
         return this._targetId;
      }
      
      public function set targetId(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         if(!_loc3_)
         {
            return;
         }
         this._targetId = param1;
         this.targetLevel = _loc3_.getFighterLevel(this._targetId);
         this._targetInfos = _loc3_.entitiesFrame.getEntityInfos(this._targetId) as GameFightFighterInformations;
         if(this.targetInfos)
         {
            this.targetShieldPoints = this.targetInfos.stats.shieldPoints;
            this.targetNeutralElementResistPercent = this.targetInfos.stats.neutralElementResistPercent;
            this.targetEarthElementResistPercent = this.targetInfos.stats.earthElementResistPercent;
            this.targetWaterElementResistPercent = this.targetInfos.stats.waterElementResistPercent;
            this.targetAirElementResistPercent = this.targetInfos.stats.airElementResistPercent;
            this.targetFireElementResistPercent = this.targetInfos.stats.fireElementResistPercent;
            this.targetNeutralElementReduction = this.targetInfos.stats.neutralElementReduction;
            this.targetEarthElementReduction = this.targetInfos.stats.earthElementReduction;
            this.targetWaterElementReduction = this.targetInfos.stats.waterElementReduction;
            this.targetAirElementReduction = this.targetInfos.stats.airElementReduction;
            this.targetFireElementReduction = this.targetInfos.stats.fireElementReduction;
            this.targetCriticalDamageFixedResist = this.targetInfos.stats.criticalDamageFixedResist;
            this.targetPushDamageFixedResist = this.targetInfos.stats.pushDamageFixedResist;
            this.targetErosionLifePoints = this.targetInfos.stats.baseMaxLifePoints - this.targetInfos.stats.maxLifePoints;
            this.targetCell = this.targetInfos.disposition.cellId;
         }
         this.targetBuffs = BuffManager.getInstance().getAllBuff(this._targetId);
         this.targetIsInvulnerable = false;
         this.targetIsUnhealable = false;
         this.targetStates = FightersStateManager.getInstance().getStates(param1);
         if(this.targetStates)
         {
            for each(_loc2_ in this.targetStates)
            {
               if(isInvulnerableState(_loc2_))
               {
                  this.targetIsInvulnerable = true;
               }
               if(isUnhealableState(_loc2_))
               {
                  this.targetIsUnhealable = true;
               }
            }
         }
      }
      
      public function get targetInfos() : GameFightFighterInformations
      {
         return this._targetInfos;
      }
      
      public function get originalTargetsIds() : Vector.<int>
      {
         if(!this._originalTargetsIds)
         {
            this._originalTargetsIds = new Vector.<int>(0);
         }
         return this._originalTargetsIds;
      }
      
      public function get triggeredSpellsByCasterOnTarget() : Vector.<TriggeredSpell>
      {
         var _loc1_:Vector.<TriggeredSpell> = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:EffectInstance = null;
         var _loc5_:EffectInstance = null;
         var _loc6_:int = 0;
         for each(_loc4_ in this.spellEffects)
         {
            if(_loc4_.effectId == 1160 && DamageUtil.verifySpellEffectMask(this.casterId,this.targetId,_loc4_,this.spellCenterCell) && DamageUtil.verifyEffectTrigger(this.casterId,this.targetId,this.spellEffects,_loc4_,false,_loc4_.triggers,this.spellCenterCell))
            {
               if(!_loc1_)
               {
                  _loc1_ = new Vector.<TriggeredSpell>();
               }
               _loc2_ = int(_loc4_.parameter0);
               _loc3_ = int(_loc4_.parameter1);
               _loc6_ = 0;
               for each(_loc5_ in this.spellCriticalEffects)
               {
                  if(_loc5_.effectId == 1160 && int(_loc5_.parameter0) == _loc2_)
                  {
                     _loc6_ = int(_loc5_.parameter1);
                     break;
                  }
               }
               _loc1_.push(TriggeredSpell.create(_loc4_.triggers,_loc2_,_loc3_,_loc6_,this.casterId,this.targetId,false));
            }
         }
         return _loc1_;
      }
      
      public function get targetTriggeredSpells() : Vector.<TriggeredSpell>
      {
         var _loc1_:BasicBuff = null;
         var _loc2_:Vector.<TriggeredSpell> = null;
         var _loc3_:int = 0;
         var _loc4_:EffectInstance = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         for each(_loc1_ in this.targetBuffs)
         {
            if((_loc6_ = !this._buffsWithSpellsTriggered || this._buffsWithSpellsTriggered.indexOf(_loc1_.uid) == -1) && (_loc1_.effect.effectId == ActionIdConverter.ACTION_TARGET_CASTS_SPELL || _loc1_.effect.effectId == ActionIdConverter.ACTION_TARGET_CASTS_SPELL_WITH_ANIM) && DamageUtil.verifyBuffTriggers(this,_loc1_))
            {
               if(!this._buffsWithSpellsTriggered)
               {
                  this._buffsWithSpellsTriggered = new Vector.<uint>(0);
               }
               this._buffsWithSpellsTriggered.push(_loc1_.uid);
               if(!_loc2_)
               {
                  _loc2_ = new Vector.<TriggeredSpell>(0);
               }
               _loc3_ = int(_loc1_.effect.parameter0);
               _loc5_ = 0;
               if(_loc1_.castingSpell.spellRank && _loc1_.castingSpell.spellRank.criticalEffect)
               {
                  for each(_loc4_ in _loc1_.castingSpell.spellRank.criticalEffect)
                  {
                     if((_loc4_.effectId == ActionIdConverter.ACTION_TARGET_CASTS_SPELL || _loc4_.effectId == ActionIdConverter.ACTION_TARGET_CASTS_SPELL_WITH_ANIM) && int(_loc4_.parameter0) == _loc3_)
                     {
                        _loc5_ = int(_loc4_.parameter1);
                        break;
                     }
                  }
               }
               _loc2_.push(TriggeredSpell.create(_loc1_.effect.triggers,_loc3_,int(_loc1_.effect.parameter1),_loc5_,this.targetId,this.targetId,false));
            }
         }
         return _loc2_;
      }
      
      public function addTriggeredSpellsEffects(param1:Vector.<TriggeredSpell>) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:TriggeredSpell = null;
         var _loc4_:EffectInstance = null;
         var _loc5_:EffectInstance = null;
         var _loc6_:int = 0;
         var _loc7_:EffectModification = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:int = this.spellEffects.length;
         var _loc13_:int = !!this.spellCriticalEffects?int(this.spellCriticalEffects.length):0;
         for each(_loc3_ in param1)
         {
            _loc8_ = 0;
            _loc9_ = 0;
            _loc6_ = 0;
            while(_loc6_ < _loc12_)
            {
               if((_loc4_ = this.spellEffects[_loc6_]).random == 0 && DamageUtil.verifyEffectTrigger(this.casterId,this.targetId,this.spellEffects,_loc4_,this.isWeapon,_loc3_.triggers,this.spellCenterCell))
               {
                  for each(_loc5_ in _loc3_.spell.effects)
                  {
                     _loc10_ = DamageUtil.verifySpellEffectMask(_loc3_.spell.playerId,this.casterId,_loc5_,this.spellCenterCell,this.casterId);
                     _loc11_ = DamageUtil.verifySpellEffectMask(_loc3_.spell.playerId,_loc3_.spell.playerId,_loc5_,this.spellCenterCell,this.casterId);
                     if(DamageUtil.TRIGGERED_EFFECTS_IDS.indexOf(_loc5_.effectId) != -1)
                     {
                        if(!this._effectsModifications)
                        {
                           this._effectsModifications = new Vector.<EffectModification>(0);
                        }
                        if(!(_loc7_ = _loc6_ + 1 <= this._effectsModifications.length?this._effectsModifications[_loc6_]:null))
                        {
                           _loc7_ = new EffectModification(_loc4_.effectId);
                           this._effectsModifications.push(_loc7_);
                        }
                        if(Effect.getEffectById(_loc5_.effectId).active && _loc10_)
                        {
                           switch(_loc5_.effectId)
                           {
                              case 138:
                                 _loc7_.damagesBonus = _loc7_.damagesBonus + _loc8_;
                                 _loc8_ = _loc8_ + (_loc5_ as EffectInstanceDice).diceNum;
                           }
                        }
                        if(_loc11_)
                        {
                           switch(_loc5_.effectId)
                           {
                              case 1040:
                                 _loc7_.shieldPoints = _loc7_.shieldPoints + _loc9_;
                                 _loc9_ = _loc9_ + (_loc5_ as EffectInstanceDice).diceNum;
                           }
                        }
                        _loc2_ = true;
                     }
                  }
               }
               _loc6_++;
            }
            _loc8_ = 0;
            _loc9_ = 0;
            _loc6_ = 0;
            while(_loc6_ < _loc13_)
            {
               if((_loc4_ = this.spellCriticalEffects[_loc6_]).random == 0 && DamageUtil.verifyEffectTrigger(this.casterId,this.targetId,this.spellCriticalEffects,_loc4_,this.isWeapon,_loc3_.triggers,this.spellCenterCell))
               {
                  for each(_loc5_ in _loc3_.spell.effects)
                  {
                     _loc10_ = DamageUtil.verifySpellEffectMask(_loc3_.spell.playerId,this.casterId,_loc5_,this.spellCenterCell,this.casterId);
                     _loc11_ = DamageUtil.verifySpellEffectMask(_loc3_.spell.playerId,_loc3_.spell.playerId,_loc5_,this.spellCenterCell,this.casterId);
                     if(DamageUtil.TRIGGERED_EFFECTS_IDS.indexOf(_loc5_.effectId) != -1)
                     {
                        if(!this._criticalEffectsModifications)
                        {
                           this._criticalEffectsModifications = new Vector.<EffectModification>(0);
                        }
                        if(!(_loc7_ = _loc6_ + 1 <= this._criticalEffectsModifications.length?this._criticalEffectsModifications[_loc6_]:null))
                        {
                           _loc7_ = new EffectModification(_loc4_.effectId);
                           this._criticalEffectsModifications.push(_loc7_);
                        }
                        if(Effect.getEffectById(_loc5_.effectId).active && _loc10_)
                        {
                           switch(_loc5_.effectId)
                           {
                              case 138:
                                 _loc7_.damagesBonus = _loc7_.damagesBonus + _loc8_;
                                 _loc8_ = _loc8_ + (_loc5_ as EffectInstanceDice).diceNum;
                           }
                        }
                        if(_loc11_)
                        {
                           switch(_loc5_.effectId)
                           {
                              case 1040:
                                 _loc7_.shieldPoints = _loc7_.shieldPoints + _loc9_;
                                 _loc9_ = _loc9_ + (_loc5_ as EffectInstanceDice).diceNum;
                           }
                        }
                        _loc2_ = true;
                     }
                  }
               }
               _loc6_++;
            }
         }
         return _loc2_;
      }
      
      public function getDamageSharingTargets() : Vector.<int>
      {
         var _loc1_:Vector.<int> = null;
         var _loc2_:BasicBuff = null;
         var _loc3_:BasicBuff = null;
         var _loc4_:Vector.<int> = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         for each(_loc2_ in this.targetBuffs)
         {
            if(_loc2_.actionId == 1061 && DamageUtil.verifyBuffTriggers(this,_loc2_))
            {
               _loc1_ = new Vector.<int>(0);
               _loc1_.push(this.targetId);
               _loc4_ = (Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).getEntitiesIdsList();
               for each(_loc5_ in _loc4_)
               {
                  if(_loc5_ != this.targetId)
                  {
                     _loc6_ = BuffManager.getInstance().getAllBuff(_loc5_);
                     for each(_loc3_ in _loc6_)
                     {
                        if(_loc3_.actionId == 1061)
                        {
                           _loc1_.push(_loc5_);
                           break;
                        }
                     }
                  }
               }
               break;
            }
         }
         return _loc1_;
      }
      
      public function getReflectDamage() : SpellDamage
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:SpellDamage = new SpellDamage();
         for each(_loc2_ in this._originalTargetsIds)
         {
            _loc1_ = DamageUtil.getReflectDamageValue(_loc2_);
            if(_loc2_ != this.casterId && _loc1_ > 0)
            {
               DamageUtil.addReflectDamage(_loc3_,this.neutralDamage,_loc1_);
               DamageUtil.addReflectDamage(_loc3_,this.earthDamage,_loc1_);
               DamageUtil.addReflectDamage(_loc3_,this.fireDamage,_loc1_);
               DamageUtil.addReflectDamage(_loc3_,this.waterDamage,_loc1_);
               DamageUtil.addReflectDamage(_loc3_,this.airDamage,_loc1_);
            }
         }
         return _loc3_;
      }
   }
}
