package com.ankamagames.dofus.logic.game.fight.managers
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.logic.game.fight.types.SpellBuff;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.logic.game.fight.types.StateBuff;
   import com.ankamagames.dofus.logic.game.fight.types.TriggeredBuff;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.utils.GameDataQuery;
   import com.ankamagames.dofus.network.types.game.actions.fight.AbstractFightDispellableEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostStateEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostWeaponDamagesEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporarySpellBoostEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporarySpellImmunityEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTriggeredEffect;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class BuffManager
   {
      
      public static const INCREMENT_MODE_SOURCE:int = 1;
      
      public static const INCREMENT_MODE_TARGET:int = 2;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(BuffManager));
      
      private static var _self:BuffManager;
       
      
      private var _buffs:Array;
      
      private var _finishingBuffs:Dictionary;
      
      private var _updateStatList:Boolean = false;
      
      public var spellBuffsToIgnore:Vector.<CastingSpell>;
      
      public function BuffManager()
      {
         this._buffs = new Array();
         this._finishingBuffs = new Dictionary();
         this.spellBuffsToIgnore = new Vector.<CastingSpell>();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : BuffManager
      {
         if(!_self)
         {
            _self = new BuffManager();
         }
         return _self;
      }
      
      public static function makeBuffFromEffect(param1:AbstractFightDispellableEffect, param2:CastingSpell, param3:uint) : BasicBuff
      {
         var _loc4_:BasicBuff = null;
         var _loc5_:Boolean = false;
         var _loc6_:FightTemporaryBoostWeaponDamagesEffect = null;
         var _loc7_:FightTemporarySpellImmunityEffect = null;
         var _loc8_:SpellLevel = null;
         var _loc9_:Vector.<EffectInstanceDice> = null;
         var _loc10_:EffectInstanceDice = null;
         switch(true)
         {
            case param1 is FightTemporarySpellBoostEffect:
               _loc4_ = new SpellBuff(param1 as FightTemporarySpellBoostEffect,param2,param3);
               break;
            case param1 is FightTriggeredEffect:
               _loc4_ = new TriggeredBuff(param1 as FightTriggeredEffect,param2,param3);
               break;
            case param1 is FightTemporaryBoostWeaponDamagesEffect:
               _loc6_ = param1 as FightTemporaryBoostWeaponDamagesEffect;
               _loc4_ = new BasicBuff(param1,param2,param3,_loc6_.weaponTypeId,_loc6_.delta,_loc6_.weaponTypeId);
               break;
            case param1 is FightTemporaryBoostStateEffect:
               _loc4_ = new StateBuff(param1 as FightTemporaryBoostStateEffect,param2,param3);
               break;
            case param1 is FightTemporarySpellImmunityEffect:
               _loc7_ = param1 as FightTemporarySpellImmunityEffect;
               _loc4_ = new BasicBuff(param1,param2,param3,_loc7_.immuneSpellId,null,null);
               break;
            case param1 is FightTemporaryBoostEffect:
               _loc4_ = new StatBuff(param1 as FightTemporaryBoostEffect,param2,param3);
         }
         _loc4_.id = param1.uid;
         var _loc11_:Vector.<uint>;
         if((_loc11_ = GameDataQuery.queryEquals(SpellLevel,"effects.effectUid",param1.effectId)).length == 0)
         {
            _loc11_ = GameDataQuery.queryEquals(SpellLevel,"criticalEffect.effectUid",param1.effectId);
            _loc5_ = true;
         }
         if(_loc11_.length > 0)
         {
            _loc8_ = SpellLevel.getLevelById(_loc11_[0]);
            _loc9_ = !!_loc5_?_loc8_.criticalEffect:_loc8_.effects;
            for each(_loc10_ in _loc9_)
            {
               if(_loc10_.effectUid == param1.effectId)
               {
                  _loc4_.effect.triggers = _loc10_.triggers;
                  break;
               }
            }
         }
         return _loc4_;
      }
      
      public function destroy() : void
      {
         _self = null;
         this.spellBuffsToIgnore.length = 0;
      }
      
      public function decrementDuration(param1:int) : void
      {
         this.incrementDuration(param1,-1);
      }
      
      public function synchronize(param1:int = 0) : void
      {
         var _loc2_:* = null;
         var _loc3_:BasicBuff = null;
         for(_loc2_ in this._buffs)
         {
            if(!(param1 && _loc2_ == param1.toString()))
            {
               for each(_loc3_ in this._buffs[_loc2_])
               {
                  _loc3_.undisable();
               }
            }
         }
      }
      
      public function incrementDuration(param1:int, param2:int, param3:Boolean = false, param4:int = 1) : void
      {
         var _loc5_:Array = null;
         var _loc6_:BasicBuff = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:CastingSpell = null;
         var _loc10_:int = 0;
         var _loc11_:Array = new Array();
         this._updateStatList = false;
         for each(_loc5_ in this._buffs)
         {
            for each(_loc6_ in _loc5_)
            {
               if(param3 && _loc6_ is TriggeredBuff && TriggeredBuff(_loc6_).delay > 0)
               {
                  if(!_loc11_.hasOwnProperty(String(_loc6_.targetId)))
                  {
                     _loc11_[_loc6_.targetId] = new Array();
                  }
                  _loc11_[_loc6_.targetId].push(_loc6_);
               }
               else if(param4 == INCREMENT_MODE_SOURCE && _loc6_.aliveSource == param1 || param4 == INCREMENT_MODE_TARGET && _loc6_.targetId == param1)
               {
                  if(param4 == INCREMENT_MODE_SOURCE && this.spellBuffsToIgnore.length)
                  {
                     _loc8_ = false;
                     for each(_loc9_ in this.spellBuffsToIgnore)
                     {
                        if(_loc9_.castingSpellId == _loc6_.castingSpell.castingSpellId && _loc9_.casterId == param1)
                        {
                           _loc8_ = true;
                           break;
                        }
                     }
                     if(_loc8_)
                     {
                        if(!_loc11_.hasOwnProperty(String(_loc6_.targetId)))
                        {
                           _loc11_[_loc6_.targetId] = new Array();
                        }
                        _loc11_[_loc6_.targetId].push(_loc6_);
                        continue;
                     }
                  }
                  _loc7_ = _loc6_.incrementDuration(param2,param3);
                  if(_loc6_.active)
                  {
                     if(!_loc11_.hasOwnProperty(String(_loc6_.targetId)))
                     {
                        _loc11_[_loc6_.targetId] = new Array();
                     }
                     _loc11_[_loc6_.targetId].push(_loc6_);
                     if(_loc7_)
                     {
                        KernelEventsManager.getInstance().processCallback(FightHookList.BuffUpdate,_loc6_.id,_loc6_.targetId);
                     }
                  }
                  else
                  {
                     BasicBuff(_loc6_).onRemoved();
                     KernelEventsManager.getInstance().processCallback(FightHookList.BuffRemove,_loc6_,_loc6_.targetId,"CoolDown");
                     _loc10_ = CurrentPlayedFighterManager.getInstance().currentFighterId;
                     if(param1 == _loc10_ || _loc6_.targetId == _loc10_)
                     {
                        this._updateStatList = true;
                     }
                  }
               }
               else
               {
                  if(!_loc11_.hasOwnProperty(String(_loc6_.targetId)))
                  {
                     _loc11_[_loc6_.targetId] = new Array();
                  }
                  _loc11_[_loc6_.targetId].push(_loc6_);
               }
            }
         }
         if(this._updateStatList)
         {
            KernelEventsManager.getInstance().processCallback(HookList.CharacterStatsList);
         }
         this._buffs = _loc11_;
         FightEventsHelper.sendAllFightEvent(true);
      }
      
      public function markFinishingBuffs(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:BasicBuff = null;
         var _loc4_:Boolean = false;
         var _loc5_:FightBattleFrame = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:StatBuff = null;
         if(this._buffs.hasOwnProperty(String(param1)))
         {
            this._updateStatList = false;
            for each(_loc3_ in this._buffs[param1])
            {
               _loc4_ = false;
               if(_loc3_.duration == 1)
               {
                  if((_loc5_ = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame) == null)
                  {
                     return;
                  }
                  _loc6_ = 0;
                  _loc7_ = false;
                  for each(_loc8_ in _loc5_.fightersList)
                  {
                     if(_loc8_ == _loc3_.aliveSource)
                     {
                        _loc7_ = true;
                     }
                     if(_loc8_ == _loc5_.currentPlayerId)
                     {
                        _loc6_ = 1;
                     }
                     if(_loc6_ == 1)
                     {
                        if(_loc7_ && (_loc8_ != _loc5_.currentPlayerId || !param2))
                        {
                           _loc6_ = 2;
                           _loc4_ = true;
                        }
                        else if(_loc8_ == param1 && _loc8_ != _loc5_.currentPlayerId)
                        {
                           _loc6_ = 2;
                           _loc4_ = false;
                        }
                     }
                  }
                  if(_loc4_ && !param2)
                  {
                     _loc3_.finishing = true;
                     if(_loc3_ is StatBuff && param1 != PlayedCharacterManager.getInstance().id)
                     {
                        if((_loc9_ = _loc3_ as StatBuff).statName)
                        {
                           param1 = _loc9_.targetId;
                           if(!this._finishingBuffs[param1])
                           {
                              this._finishingBuffs[param1] = new Array();
                           }
                           this._finishingBuffs[param1].push(_loc3_);
                        }
                     }
                     BasicBuff(_loc3_).onDisabled();
                     if(param1 == CurrentPlayedFighterManager.getInstance().currentFighterId)
                     {
                        this._updateStatList = true;
                     }
                  }
               }
            }
            if(this._updateStatList)
            {
               KernelEventsManager.getInstance().processCallback(HookList.CharacterStatsList);
            }
         }
      }
      
      public function addBuff(param1:BasicBuff, param2:Boolean = true) : void
      {
         var _loc3_:BasicBuff = null;
         var _loc4_:BasicBuff = null;
         if(!this._buffs[param1.targetId])
         {
            this._buffs[param1.targetId] = new Array();
         }
         for each(_loc4_ in this._buffs[param1.targetId])
         {
            if(param1.equals(_loc4_))
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         if(!_loc3_)
         {
            this._buffs[param1.targetId].push(param1);
         }
         else
         {
            if(_loc3_ is TriggeredBuff && _loc3_.effect.triggers.indexOf("|") != -1 || _loc3_.castingSpell.spellRank && _loc3_.castingSpell.spellRank.maxStack > 0 && _loc3_.stack && _loc3_.stack.length == _loc3_.castingSpell.spellRank.maxStack)
            {
               return;
            }
            _loc3_.add(param1);
         }
         if(param2)
         {
            param1.onApplyed();
         }
         if(!_loc3_)
         {
            KernelEventsManager.getInstance().processCallback(FightHookList.BuffAdd,param1.id,param1.targetId);
         }
         else
         {
            KernelEventsManager.getInstance().processCallback(FightHookList.BuffUpdate,_loc3_.id,_loc3_.targetId);
         }
      }
      
      public function updateBuff(param1:BasicBuff) : Boolean
      {
         var _loc2_:BasicBuff = null;
         var _loc3_:int = param1.targetId;
         if(!this._buffs[_loc3_])
         {
            return false;
         }
         var _loc4_:int;
         if((_loc4_ = this.getBuffIndex(_loc3_,param1.id)) == -1)
         {
            return false;
         }
         (this._buffs[_loc3_][_loc4_] as BasicBuff).onRemoved();
         (this._buffs[_loc3_][_loc4_] as BasicBuff).updateParam(param1.param1,param1.param2,param1.param3,param1.id);
         _loc2_ = this._buffs[_loc3_][_loc4_];
         if(!_loc2_)
         {
            return false;
         }
         _loc2_.onApplyed();
         KernelEventsManager.getInstance().processCallback(FightHookList.BuffUpdate,_loc2_.id,_loc3_);
         return true;
      }
      
      public function dispell(param1:int, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:BasicBuff = null;
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         for each(_loc5_ in this._buffs[param1])
         {
            if(_loc5_.canBeDispell(param2,int.MIN_VALUE,param4))
            {
               KernelEventsManager.getInstance().processCallback(FightHookList.BuffRemove,_loc5_.id,param1,"Dispell");
               _loc5_.onRemoved();
               _loc6_.push(_loc5_);
            }
            else
            {
               _loc7_.push(_loc5_);
            }
         }
         this._buffs[param1] = _loc7_;
      }
      
      public function dispellSpell(param1:int, param2:uint, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc6_:BasicBuff = null;
         var _loc7_:int = 0;
         var _loc8_:BasicBuff = null;
         var _loc9_:Array = new Array();
         var _loc10_:Array = new Array();
         for each(_loc6_ in this._buffs[param1])
         {
            if(param2 == _loc6_.castingSpell.spell.id && _loc6_.canBeDispell(param3,int.MIN_VALUE,param5))
            {
               if(!_loc6_.stack)
               {
                  _loc6_.onRemoved();
               }
               _loc9_.push(_loc6_);
            }
            else
            {
               _loc10_.push(_loc6_);
            }
         }
         this._buffs[param1] = _loc10_;
         _loc7_ = CurrentPlayedFighterManager.getInstance().currentFighterId;
         this._updateStatList = false;
         for each(_loc8_ in _loc9_)
         {
            if(param1 == _loc7_ || _loc8_.targetId == _loc7_)
            {
               this._updateStatList = true;
            }
            if(_loc8_.stack)
            {
               while(_loc8_.stack.length)
               {
                  _loc8_.stack.shift().onRemoved();
               }
            }
            KernelEventsManager.getInstance().processCallback(FightHookList.BuffRemove,_loc8_,param1,"Dispell");
         }
         if(this._updateStatList)
         {
            KernelEventsManager.getInstance().processCallback(HookList.CharacterStatsList);
         }
      }
      
      public function dispellUniqueBuff(param1:int, param2:int, param3:Boolean = false, param4:Boolean = false, param5:Boolean = true) : void
      {
         var _loc6_:int;
         if((_loc6_ = this.getBuffIndex(param1,param2)) == -1)
         {
            return;
         }
         var _loc7_:BasicBuff;
         if((_loc7_ = this._buffs[param1][_loc6_]).canBeDispell(param3,!!param5?int(param2):int(int.MIN_VALUE),param4))
         {
            if(_loc7_.stack && _loc7_.stack.length > 1 && !param4)
            {
               _loc7_.onRemoved();
               switch(_loc7_.actionId)
               {
                  case 293:
                     _loc7_.param1 = _loc7_.stack[0].param1;
                     _loc7_.param2 = _loc7_.param2 - _loc7_.stack[0].param2;
                     _loc7_.param3 = _loc7_.param3 - _loc7_.stack[0].param3;
                     break;
                  case 788:
                     _loc7_.param1 = _loc7_.param1 - _loc7_.stack[0].param2;
                     break;
                  case 950:
                  case 951:
                     break;
                  default:
                     _loc7_.param1 = _loc7_.param1 - _loc7_.stack[0].param1;
                     _loc7_.param2 = _loc7_.param2 - _loc7_.stack[0].param2;
                     _loc7_.param3 = _loc7_.param3 - _loc7_.stack[0].param3;
               }
               _loc7_.stack.shift();
               _loc7_.refreshDescription();
               _loc7_.onApplyed();
               KernelEventsManager.getInstance().processCallback(FightHookList.BuffUpdate,_loc7_.id,_loc7_.targetId);
            }
            else
            {
               KernelEventsManager.getInstance().processCallback(FightHookList.BuffRemove,_loc7_.id,param1,"Dispell");
               this._buffs[param1].splice(this._buffs[param1].indexOf(_loc7_),1);
               _loc7_.onRemoved();
               if(param1 == CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.CharacterStatsList);
                  SpellWrapper.refreshAllPlayerSpellHolder(param1);
               }
            }
         }
      }
      
      public function removeLinkedBuff(param1:int, param2:Boolean = false, param3:Boolean = false) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:BasicBuff = null;
         var _loc7_:Array = [];
         var _loc8_:FightEntitiesFrame;
         var _loc9_:GameFightFighterInformations = (_loc8_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).getEntityInfos(param1) as GameFightFighterInformations;
         for each(_loc4_ in this._buffs)
         {
            _loc5_ = new Array();
            for each(_loc6_ in _loc4_)
            {
               _loc5_.push(_loc6_);
            }
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.source == param1)
               {
                  this.dispellUniqueBuff(_loc6_.targetId,_loc6_.id,param2,param3,false);
                  if(_loc7_.indexOf(_loc6_.targetId) == -1)
                  {
                     _loc7_.push(_loc6_.targetId);
                  }
                  if(param3 && _loc9_.stats.summoned)
                  {
                     _loc6_.aliveSource = _loc9_.stats.summoner;
                  }
               }
            }
         }
         return _loc7_;
      }
      
      public function reaffectBuffs(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:BasicBuff = null;
         var _loc5_:GameFightFighterInformations;
         if((_loc5_ = this.fightEntitiesFrame.getEntityInfos(param1) as GameFightFighterInformations).stats.summoned)
         {
            _loc2_ = this.getNextFighter(param1);
            if(_loc2_ == -1)
            {
               return;
            }
            for each(_loc3_ in this._buffs)
            {
               for each(_loc4_ in _loc3_)
               {
                  if(_loc4_.aliveSource == param1)
                  {
                     _loc4_.aliveSource = _loc2_;
                  }
               }
            }
         }
      }
      
      private function getNextFighter(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc4_:Boolean = false;
         var _loc3_:FightBattleFrame = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame;
         if(_loc3_ == null)
         {
            return -1;
         }
         for each(_loc2_ in _loc3_.fightersList)
         {
            if(_loc4_)
            {
               return _loc2_;
            }
            if(_loc2_ == param1)
            {
               _loc4_ = true;
            }
         }
         if(_loc4_)
         {
            return _loc3_.fightersList[0];
         }
         return -1;
      }
      
      public function getFighterInfo(param1:int) : GameFightFighterInformations
      {
         return this.fightEntitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
      }
      
      public function getAllBuff(param1:int) : Array
      {
         return this._buffs[param1];
      }
      
      public function getBuff(param1:uint, param2:int) : BasicBuff
      {
         var _loc3_:BasicBuff = null;
         for each(_loc3_ in this._buffs[param2])
         {
            if(param1 == _loc3_.id)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getFinishingBuffs(param1:int) : Array
      {
         var _loc2_:Array = this._finishingBuffs[param1];
         delete this._finishingBuffs[param1];
         return _loc2_;
      }
      
      private function get fightEntitiesFrame() : FightEntitiesFrame
      {
         return Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
      }
      
      private function getBuffIndex(param1:int, param2:int) : int
      {
         var _loc3_:* = null;
         var _loc4_:BasicBuff = null;
         for(_loc3_ in this._buffs[param1])
         {
            if(param2 == this._buffs[param1][_loc3_].id)
            {
               return int(_loc3_);
            }
            for each(_loc4_ in (this._buffs[param1][_loc3_] as BasicBuff).stack)
            {
               if(param2 == _loc4_.id)
               {
                  return int(_loc3_);
               }
            }
         }
         return -1;
      }
   }
}
