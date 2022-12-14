package com.ankamagames.dofus.logic.game.fight.types.castSpellManager
{
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.SpellModificator;
   import com.ankamagames.dofus.logic.game.fight.types.SpellCastInFightManager;
   import com.ankamagames.dofus.network.enums.CharacterSpellModificationTypeEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SpellManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellManager));
       
      
      private var _spellId:uint;
      
      private var _spellLevel:uint;
      
      private var _lastCastTurn:int;
      
      private var _lastInitialCooldownReset:int;
      
      private var _castThisTurn:uint;
      
      private var _targetsThisTurn:Dictionary;
      
      private var _spellCastManager:SpellCastInFightManager;
      
      public function SpellManager(param1:SpellCastInFightManager, param2:uint, param3:uint)
      {
         super();
         this._spellCastManager = param1;
         this._spellId = param2;
         this._spellLevel = param3;
         this._targetsThisTurn = new Dictionary();
      }
      
      public function get lastCastTurn() : int
      {
         return this._lastCastTurn;
      }
      
      public function get numberCastThisTurn() : uint
      {
         return this._castThisTurn;
      }
      
      public function set spellLevel(param1:uint) : void
      {
         this._spellLevel = param1;
      }
      
      public function get spellLevel() : uint
      {
         return this._spellLevel;
      }
      
      public function get spell() : Spell
      {
         return Spell.getSpellById(this._spellId);
      }
      
      public function get spellLevelObject() : SpellLevel
      {
         return Spell.getSpellById(this._spellId).getSpellLevel(this._spellLevel);
      }
      
      public function cast(param1:int, param2:Array, param3:Boolean = true) : void
      {
         var _loc4_:int = 0;
         this._lastCastTurn = param1;
         for each(_loc4_ in param2)
         {
            if(this._targetsThisTurn[_loc4_] == null)
            {
               this._targetsThisTurn[_loc4_] = 0;
            }
            this._targetsThisTurn[_loc4_] = this._targetsThisTurn[_loc4_] + 1;
         }
         if(param3)
         {
            ++this._castThisTurn;
         }
         this.updateSpellWrapper();
      }
      
      public function resetInitialCooldown(param1:int) : void
      {
         this._lastInitialCooldownReset = param1;
         this.updateSpellWrapper();
      }
      
      public function getCastOnEntity(param1:int) : uint
      {
         if(this._targetsThisTurn[param1] == null)
         {
            return 0;
         }
         return this._targetsThisTurn[param1];
      }
      
      public function newTurn() : void
      {
         this._castThisTurn = 0;
         this._targetsThisTurn = new Dictionary();
         this.updateSpellWrapper();
      }
      
      public function get cooldown() : int
      {
         var _loc1_:CharacterSpellModification = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Spell;
         var _loc5_:SpellLevel = (_loc4_ = Spell.getSpellById(this._spellId)).getSpellLevel(this._spellLevel);
         var _loc6_:SpellModificator = new SpellModificator();
         var _loc7_:CharacterCharacteristicsInformations = PlayedCharacterManager.getInstance().characteristics;
         for each(_loc1_ in _loc7_.spellModifications)
         {
            if(_loc1_.spellId != this._spellId)
            {
               continue;
            }
            switch(_loc1_.modificationType)
            {
               case CharacterSpellModificationTypeEnum.CAST_INTERVAL:
                  _loc6_.castInterval = _loc1_.value;
                  continue;
               case CharacterSpellModificationTypeEnum.CAST_INTERVAL_SET:
                  _loc6_.castIntervalSet = _loc1_.value;
                  continue;
               default:
                  continue;
            }
         }
         if(_loc6_.getTotalBonus(_loc6_.castIntervalSet))
         {
            _loc2_ = -_loc6_.getTotalBonus(_loc6_.castInterval) + _loc6_.getTotalBonus(_loc6_.castIntervalSet);
         }
         else
         {
            _loc2_ = _loc5_.minCastInterval - _loc6_.getTotalBonus(_loc6_.castInterval);
         }
         if(_loc2_ == 63)
         {
            return 63;
         }
         var _loc8_:int = this._lastInitialCooldownReset + _loc5_.initialCooldown - this._spellCastManager.currentTurn;
         if(this._lastCastTurn >= this._lastInitialCooldownReset + _loc5_.initialCooldown || _loc5_.initialCooldown == 0)
         {
            _loc3_ = _loc2_ + this._lastCastTurn - this._spellCastManager.currentTurn;
         }
         else
         {
            _loc3_ = _loc8_;
         }
         if(_loc3_ <= 0)
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      public function forceCooldown(param1:int) : void
      {
         var _loc2_:SpellWrapper = null;
         var _loc3_:Spell = Spell.getSpellById(this._spellId);
         var _loc4_:SpellLevel = _loc3_.getSpellLevel(this._spellLevel);
         this._lastCastTurn = param1 + this._spellCastManager.currentTurn - _loc4_.minCastInterval;
         var _loc5_:Array = SpellWrapper.getSpellWrappersById(this._spellId,this._spellCastManager.entityId);
         for each(_loc2_ in _loc5_)
         {
            _loc2_.actualCooldown = param1;
         }
      }
      
      public function forceLastCastTurn(param1:int, param2:Boolean = false) : void
      {
         this._lastCastTurn = param1;
         this.updateSpellWrapper(param2);
      }
      
      private function updateSpellWrapper(param1:Boolean = false) : void
      {
         var _loc2_:SpellWrapper = null;
         var _loc3_:Array = SpellWrapper.getSpellWrappersById(this._spellId,this._spellCastManager.entityId);
         var _loc4_:Spell;
         var _loc5_:SpellLevel = (_loc4_ = Spell.getSpellById(this._spellId)).getSpellLevel(this._spellLevel);
         for each(_loc2_ in _loc3_)
         {
            if(_loc2_.actualCooldown != 63)
            {
               _loc2_.actualCooldown = this.cooldown;
            }
         }
      }
   }
}
