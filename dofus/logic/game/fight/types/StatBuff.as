package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightSpellCastFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostEffect;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class StatBuff extends BasicBuff
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(StatBuff));
       
      
      private var _statName:String;
      
      private var _isABoost:Boolean;
      
      private var _zeroDiff:int;
      
      public function StatBuff(param1:FightTemporaryBoostEffect = null, param2:CastingSpell = null, param3:int = 0)
      {
         if(param1)
         {
            super(param1,param2,param3,param1.delta,null,null);
            this._statName = ActionIdConverter.getActionStatName(param3);
            this._isABoost = ActionIdConverter.getIsABoost(param3);
         }
      }
      
      override public function get type() : String
      {
         return "StatBuff";
      }
      
      public function get statName() : String
      {
         return this._statName;
      }
      
      public function get delta() : int
      {
         if(_effect is EffectInstanceDice)
         {
            return !!this._isABoost?int(EffectInstanceDice(_effect).diceNum):int(-EffectInstanceDice(_effect).diceNum);
         }
         return 0;
      }
      
      public function get zeroDiff() : int
      {
         return this._zeroDiff;
      }
      
      override public function onApplyed() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:CharacterCharacteristicsInformations = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations(targetId);
         if(_loc3_)
         {
            if(_loc3_.hasOwnProperty(this._statName))
            {
               CharacterBaseCharacteristic(_loc3_[this._statName]).contextModif = CharacterBaseCharacteristic(_loc3_[this._statName]).contextModif + this.delta;
            }
            switch(this.statName)
            {
               case "vitality":
                  _loc1_ = _loc3_.maxLifePoints;
                  if(_loc1_ + this.delta < 0)
                  {
                     _loc3_.maxLifePoints = 0;
                  }
                  else
                  {
                     _loc3_.maxLifePoints = _loc3_.maxLifePoints + this.delta;
                  }
                  _loc1_ = _loc3_.lifePoints;
                  if(_loc1_ + this.delta < 0)
                  {
                     _loc3_.lifePoints = 0;
                  }
                  else
                  {
                     _loc3_.lifePoints = _loc3_.lifePoints + this.delta;
                  }
                  break;
               case "lifePoints":
               case "lifePointsMalus":
                  _loc1_ = _loc3_.lifePoints;
                  if(_loc1_ + this.delta < 0)
                  {
                     _loc3_.lifePoints = 0;
                  }
                  else
                  {
                     _loc3_.lifePoints = _loc3_.lifePoints + this.delta;
                  }
                  break;
               case "movementPoints":
                  _loc3_.movementPointsCurrent = _loc3_.movementPointsCurrent + this.delta;
                  break;
               case "actionPoints":
                  _loc3_.actionPointsCurrent = _loc3_.actionPointsCurrent + this.delta;
                  break;
               case "summonableCreaturesBoost":
                  SpellWrapper.refreshAllPlayerSpellHolder(targetId);
                  break;
               case "range":
                  FightSpellCastFrame.updateRangeAndTarget();
                  break;
               case "invisibilityState":
            }
         }
         var _loc4_:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(targetId) as GameFightFighterInformations;
         switch(this.statName)
         {
            case "vitality":
               _loc4_.stats["lifePoints"] = _loc4_.stats["lifePoints"] + this.delta;
               _loc4_.stats["maxLifePoints"] = _loc4_.stats["maxLifePoints"] + this.delta;
               break;
            case "lifePointsMalus":
               _loc4_.stats["lifePoints"] = _loc4_.stats["lifePoints"] + this.delta;
               break;
            case "lifePoints":
            case "shieldPoints":
            case "dodgePALostProbability":
            case "dodgePMLostProbability":
               _loc1_ = _loc4_.stats[this._statName];
               if(_loc1_ + this.delta < 0)
               {
                  _loc4_.stats[this._statName] = 0;
               }
               else
               {
                  _loc4_.stats[this._statName] = _loc4_.stats[this._statName] + this.delta;
               }
               break;
            case "agility":
               _loc4_.stats["tackleEvade"] = _loc4_.stats["tackleEvade"] + this.delta / 10;
               _loc4_.stats["tackleBlock"] = _loc4_.stats["tackleBlock"] + this.delta / 10;
               break;
            case "globalResistPercentBonus":
            case "globalResistPercentMalus":
               _loc2_ = this.statName == "globalResistPercentMalus"?-1:1;
               _loc4_.stats["neutralElementResistPercent"] = _loc4_.stats["neutralElementResistPercent"] + this.delta * _loc2_;
               _loc4_.stats["airElementResistPercent"] = _loc4_.stats["airElementResistPercent"] + this.delta * _loc2_;
               _loc4_.stats["waterElementResistPercent"] = _loc4_.stats["waterElementResistPercent"] + this.delta * _loc2_;
               _loc4_.stats["earthElementResistPercent"] = _loc4_.stats["earthElementResistPercent"] + this.delta * _loc2_;
               _loc4_.stats["fireElementResistPercent"] = _loc4_.stats["fireElementResistPercent"] + this.delta * _loc2_;
               break;
            case "actionPoints":
               _loc4_.stats["actionPoints"] = _loc4_.stats["actionPoints"] + this.delta;
               _loc4_.stats["maxActionPoints"] = _loc4_.stats["maxActionPoints"] + this.delta;
               break;
            case "movementPoints":
               _loc4_.stats["movementPoints"] = _loc4_.stats["movementPoints"] + this.delta;
               _loc4_.stats["maxMovementPoints"] = _loc4_.stats["maxMovementPoints"] + this.delta;
               break;
            case "tackleBlock":
            case "tackleEvade":
               if(_loc4_.stats[this._statName] + this.delta < 0)
               {
                  this._zeroDiff = _loc4_.stats[this._statName] + this.delta;
                  _loc4_.stats[this._statName] = 0;
               }
               else
               {
                  _loc4_.stats[this._statName] = _loc4_.stats[this._statName] + this.delta;
               }
               break;
            case "invisibilityState":
               break;
            default:
               if(_loc4_)
               {
                  if(_loc4_.stats.hasOwnProperty(this._statName))
                  {
                     _loc4_.stats[this._statName] = _loc4_.stats[this._statName] + this.delta;
                  }
               }
               else
               {
                  _log.fatal("ATTENTION, le serveur essaye de buffer une entité qui n\'existe plus ! id=" + targetId);
               }
         }
         super.onApplyed();
      }
      
      override public function onRemoved() : void
      {
         var _loc1_:Effect = null;
         if(!_removed)
         {
            _loc1_ = Effect.getEffectById(actionId);
            if(!_loc1_.active)
            {
               this.decrementStats();
            }
         }
         super.onRemoved();
      }
      
      override public function onDisabled() : void
      {
         var _loc1_:Effect = null;
         if(!_disabled)
         {
            _loc1_ = Effect.getEffectById(actionId);
            if(_loc1_.active)
            {
               this.decrementStats();
            }
         }
         super.onDisabled();
      }
      
      private function decrementStats() : void
      {
         var _loc1_:int = 0;
         var _loc2_:CharacterCharacteristicsInformations = null;
         var _loc3_:CharacterCharacteristicsInformations = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc2_ = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations(targetId);
         if(_loc2_)
         {
            if(_loc2_.hasOwnProperty(this._statName))
            {
               CharacterBaseCharacteristic(_loc2_[this._statName]).contextModif = CharacterBaseCharacteristic(_loc2_[this._statName]).contextModif - this.delta;
            }
            switch(this._statName)
            {
               case "movementPoints":
                  _loc2_.movementPointsCurrent = _loc2_.movementPointsCurrent - this.delta;
                  break;
               case "actionPoints":
                  _loc2_.actionPointsCurrent = _loc2_.actionPointsCurrent - this.delta;
                  break;
               case "vitality":
                  _loc2_.maxLifePoints = _loc2_.maxLifePoints - this.delta;
                  if(_loc2_.lifePoints > this.delta)
                  {
                     _loc2_.lifePoints = _loc2_.lifePoints - this.delta;
                  }
                  else
                  {
                     _loc2_.lifePoints = 0;
                  }
                  break;
               case "lifePoints":
               case "lifePointsMalus":
                  _loc3_ = _loc2_;
                  if(_loc3_.lifePoints > this.delta)
                  {
                     if(_loc3_.maxLifePoints >= _loc3_.lifePoints - this.delta)
                     {
                        _loc3_.lifePoints = _loc3_.lifePoints - this.delta;
                     }
                     else
                     {
                        _loc3_.lifePoints = _loc3_.maxLifePoints;
                     }
                  }
                  else
                  {
                     _loc3_.lifePoints = 0;
                  }
                  break;
               case "summonableCreaturesBoost":
               case "range":
               case "invisibilityState":
            }
         }
         var _loc8_:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(targetId) as GameFightFighterInformations;
         switch(this.statName)
         {
            case "vitality":
               _loc8_.stats["lifePoints"] = _loc8_.stats["lifePoints"] - this.delta;
               _loc8_.stats["maxLifePoints"] = _loc8_.stats["maxLifePoints"] - this.delta;
               return;
            case "lifePointsMalus":
               _loc8_.stats["lifePoints"] = _loc8_.stats["lifePoints"] - this.delta;
               if(_loc8_.stats["lifePoints"] > _loc8_.stats["maxLifePoints"])
               {
                  _loc8_.stats["lifePoints"] = _loc8_.stats["maxLifePoints"];
               }
               return;
            case "lifePoints":
            case "shieldPoints":
            case "dodgePALostProbability":
            case "dodgePMLostProbability":
               _loc1_ = _loc8_.stats[this._statName];
               if(_loc1_ - this.delta < 0)
               {
                  _loc8_.stats[this._statName] = 0;
               }
               else
               {
                  _loc8_.stats[this._statName] = _loc8_.stats[this._statName] - this.delta;
               }
               return;
            case "globalResistPercentBonus":
            case "globalResistPercentMalus":
               _loc4_ = this.statName == "globalResistPercentMalus"?-1:1;
               _loc8_.stats["neutralElementResistPercent"] = _loc8_.stats["neutralElementResistPercent"] - this.delta * _loc4_;
               _loc8_.stats["airElementResistPercent"] = _loc8_.stats["airElementResistPercent"] - this.delta * _loc4_;
               _loc8_.stats["waterElementResistPercent"] = _loc8_.stats["waterElementResistPercent"] - this.delta * _loc4_;
               _loc8_.stats["earthElementResistPercent"] = _loc8_.stats["earthElementResistPercent"] - this.delta * _loc4_;
               _loc8_.stats["fireElementResistPercent"] = _loc8_.stats["fireElementResistPercent"] - this.delta * _loc4_;
               return;
            case "agility":
               _loc8_.stats["tackleEvade"] = _loc8_.stats["tackleEvade"] - this.delta / 10;
               _loc8_.stats["tackleBlock"] = _loc8_.stats["tackleBlock"] - this.delta / 10;
               return;
            case "actionPoints":
               _loc8_.stats["actionPoints"] = _loc8_.stats["actionPoints"] - this.delta;
               _loc8_.stats["maxActionPoints"] = _loc8_.stats["maxActionPoints"] - this.delta;
               return;
            case "movementPoints":
               _loc8_.stats["movementPoints"] = _loc8_.stats["movementPoints"] - this.delta;
               _loc8_.stats["maxMovementPoints"] = _loc8_.stats["maxMovementPoints"] - this.delta;
               return;
            case "tackleBlock":
            case "tackleEvade":
               if(_loc8_.stats[this._statName] == 0)
               {
                  _loc5_ = this._zeroDiff;
                  if(stack)
                  {
                     _loc7_ = stack.length;
                     _loc6_ = 1;
                     while(_loc6_ < _loc7_)
                     {
                        _loc5_ = _loc5_ + (stack[_loc6_] as StatBuff).zeroDiff;
                        _loc6_++;
                     }
                  }
                  _loc8_.stats[this._statName] = _loc8_.stats[this._statName] - this.delta + _loc5_;
               }
               else
               {
                  _loc8_.stats[this._statName] = _loc8_.stats[this._statName] - this.delta;
               }
               return;
            case "invisibilityState":
               return;
            default:
               if(_loc8_)
               {
                  if(_loc8_.stats.hasOwnProperty(this._statName))
                  {
                     _loc8_.stats[this._statName] = _loc8_.stats[this._statName] - this.delta;
                  }
                  else
                  {
                     _log.fatal("On essaye de supprimer une stat non prise en compte : " + this.statName);
                  }
               }
               else
               {
                  _log.fatal("ATTENTION, Le serveur essaye de buffer une entité qui n\'existe plus ! id=" + targetId);
               }
               return;
         }
      }
      
      override public function clone(param1:int = 0) : BasicBuff
      {
         var _loc2_:StatBuff = new StatBuff();
         _loc2_._statName = this._statName;
         _loc2_._isABoost = this._isABoost;
         _loc2_.id = uid;
         _loc2_.uid = uid;
         _loc2_.actionId = actionId;
         _loc2_.targetId = targetId;
         _loc2_.castingSpell = castingSpell;
         _loc2_.duration = duration;
         _loc2_.dispelable = dispelable;
         _loc2_.source = source;
         _loc2_.aliveSource = aliveSource;
         _loc2_.parentBoostUid = parentBoostUid;
         _loc2_.initParam(param1,param2,param3);
         return _loc2_;
      }
   }
}
