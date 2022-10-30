package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.SpellInventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.SpellModificator;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.types.castSpellManager.SpellManager;
   import com.ankamagames.dofus.network.enums.CharacterSpellModificationTypeEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightSpellCooldown;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SpellCastInFightManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellCastInFightManager));
       
      
      private var _spells:Dictionary;
      
      private var skipFirstTurn:Boolean = true;
      
      private var _storedSpellCooldowns:Vector.<GameFightSpellCooldown>;
      
      public var currentTurn:int = 0;
      
      public var entityId:int;
      
      public var needCooldownUpdate:Boolean = false;
      
      public function SpellCastInFightManager(param1:int)
      {
         this._spells = new Dictionary();
         super();
         this.entityId = param1;
      }
      
      public function nextTurn() : void
      {
         var _loc1_:SpellManager = null;
         ++this.currentTurn;
         for each(_loc1_ in this._spells)
         {
            _loc1_.newTurn();
         }
      }
      
      public function resetInitialCooldown(param1:Boolean = false) : void
      {
         var _loc2_:SpellManager = null;
         var _loc3_:SpellWrapper = null;
         var _loc4_:SpellInventoryManagementFrame;
         var _loc5_:Array = (_loc4_ = Kernel.getWorker().getFrame(SpellInventoryManagementFrame) as SpellInventoryManagementFrame).getFullSpellListByOwnerId(this.entityId);
         for each(_loc3_ in _loc5_)
         {
            if(_loc3_.spellLevelInfos.initialCooldown != 0)
            {
               if(!(param1 && _loc3_.actualCooldown > _loc3_.spellLevelInfos.initialCooldown))
               {
                  if(this._spells[_loc3_.spellId] == null)
                  {
                     this._spells[_loc3_.spellId] = new SpellManager(this,_loc3_.spellId,_loc3_.spellLevel);
                  }
                  _loc2_ = this._spells[_loc3_.spellId];
                  _loc2_.resetInitialCooldown(this.currentTurn);
               }
            }
         }
      }
      
      public function updateCooldowns(param1:Vector.<GameFightSpellCooldown> = null) : void
      {
         var _loc2_:GameFightSpellCooldown = null;
         var _loc3_:SpellWrapper = null;
         var _loc4_:SpellLevel = null;
         var _loc5_:SpellCastInFightManager = null;
         var _loc6_:int = 0;
         var _loc7_:SpellModificator = null;
         var _loc8_:CharacterCharacteristicsInformations = null;
         var _loc9_:CharacterSpellModification = null;
         var _loc12_:int = 0;
         if(this.needCooldownUpdate && !param1)
         {
            param1 = this._storedSpellCooldowns;
         }
         var _loc10_:CurrentPlayedFighterManager = CurrentPlayedFighterManager.getInstance();
         var _loc11_:int = param1.length;
         while(_loc12_ < _loc11_)
         {
            _loc2_ = param1[_loc12_];
            _loc3_ = SpellWrapper.getFirstSpellWrapperById(_loc2_.spellId,this.entityId);
            if(!_loc3_)
            {
               this.needCooldownUpdate = true;
               this._storedSpellCooldowns = param1;
               return;
            }
            if(_loc3_ && _loc3_.spellLevel > 0)
            {
               _loc4_ = _loc3_.spell.getSpellLevel(_loc3_.spellLevel);
               (_loc5_ = _loc10_.getSpellCastManagerById(this.entityId)).castSpell(_loc3_.id,_loc3_.spellLevel,[],false);
               _loc6_ = _loc4_.minCastInterval;
               if(_loc2_.cooldown != 63)
               {
                  _loc7_ = new SpellModificator();
                  _loc8_ = PlayedCharacterManager.getInstance().characteristics;
                  for each(_loc9_ in _loc8_.spellModifications)
                  {
                     if(_loc9_.spellId != _loc2_.spellId)
                     {
                        continue;
                     }
                     switch(_loc9_.modificationType)
                     {
                        case CharacterSpellModificationTypeEnum.CAST_INTERVAL:
                           _loc7_.castInterval = _loc9_.value;
                           continue;
                        case CharacterSpellModificationTypeEnum.CAST_INTERVAL_SET:
                           _loc7_.castIntervalSet = _loc9_.value;
                           continue;
                        default:
                           continue;
                     }
                  }
                  if(_loc7_.getTotalBonus(_loc7_.castIntervalSet))
                  {
                     _loc6_ = -_loc7_.getTotalBonus(_loc7_.castInterval) + _loc7_.getTotalBonus(_loc7_.castIntervalSet);
                  }
                  else
                  {
                     _loc6_ = _loc6_ - _loc7_.getTotalBonus(_loc7_.castInterval);
                  }
               }
               _loc5_.getSpellManagerBySpellId(_loc3_.id).forceLastCastTurn(this.currentTurn + _loc2_.cooldown - _loc6_);
            }
            _loc12_++;
         }
         this.needCooldownUpdate = false;
      }
      
      public function castSpell(param1:uint, param2:uint, param3:Array, param4:Boolean = true) : void
      {
         if(this._spells[param1] == null)
         {
            this._spells[param1] = new SpellManager(this,param1,param2);
         }
         (this._spells[param1] as SpellManager).cast(this.currentTurn,param3,param4);
      }
      
      public function getSpellManagerBySpellId(param1:uint) : SpellManager
      {
         return this._spells[param1] as SpellManager;
      }
   }
}
