package com.ankamagames.dofus.logic.game.fight.managers
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.Weapon;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.misc.SpellModificator;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightReachableCellsMaker;
   import com.ankamagames.dofus.logic.game.fight.types.SpellCastInFightManager;
   import com.ankamagames.dofus.logic.game.fight.types.castSpellManager.SpellManager;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.network.enums.CharacterSpellModificationTypeEnum;
   import com.ankamagames.dofus.network.enums.ShortcutBarEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public final class CurrentPlayedFighterManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(CurrentPlayedFighterManager));
      
      private static var _self:CurrentPlayedFighterManager;
       
      
      private var _currentFighterId:int = 0;
      
      private var _currentFighterIsRealPlayer:Boolean = true;
      
      private var _characteristicsInformationsList:Dictionary;
      
      private var _spellCastInFightManagerList:Dictionary;
      
      private var _currentSummonedCreature:Dictionary;
      
      private var _currentSummonedBomb:Dictionary;
      
      public function CurrentPlayedFighterManager()
      {
         this._characteristicsInformationsList = new Dictionary();
         this._spellCastInFightManagerList = new Dictionary();
         this._currentSummonedCreature = new Dictionary();
         this._currentSummonedBomb = new Dictionary();
         super();
      }
      
      public static function getInstance() : CurrentPlayedFighterManager
      {
         if(_self == null)
         {
            _self = new CurrentPlayedFighterManager();
            _self.currentFighterId = PlayedCharacterManager.getInstance().id;
         }
         return _self;
      }
      
      public function get currentFighterId() : int
      {
         return this._currentFighterId;
      }
      
      public function set currentFighterId(param1:int) : void
      {
         if(param1 == this._currentFighterId)
         {
            return;
         }
         var _loc2_:int = this._currentFighterId;
         this._currentFighterId = param1;
         var _loc3_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         this._currentFighterIsRealPlayer = this._currentFighterId == _loc3_.id;
         var _loc4_:AnimatedCharacter;
         if(_loc4_ = DofusEntities.getEntity(_loc2_) as AnimatedCharacter)
         {
            _loc4_.setCanSeeThrough(false);
         }
         var _loc5_:AnimatedCharacter;
         if(_loc5_ = DofusEntities.getEntity(this._currentFighterId) as AnimatedCharacter)
         {
            _loc5_.setCanSeeThrough(true);
         }
         if(_loc3_.isFighting)
         {
            this.updatePortrait(_loc5_);
            if(_loc3_.id != param1 || _loc2_)
            {
               KernelEventsManager.getInstance().processCallback(FightHookList.SlaveStatsList,this.getCharacteristicsInformations());
            }
         }
      }
      
      public function checkPlayableEntity(param1:int) : Boolean
      {
         if(param1 == PlayedCharacterManager.getInstance().id)
         {
            return true;
         }
         return this._characteristicsInformationsList[param1] != null;
      }
      
      public function isRealPlayer() : Boolean
      {
         return this._currentFighterIsRealPlayer;
      }
      
      public function resetPlayerSpellList() : void
      {
         var _loc1_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         var _loc2_:InventoryManager = InventoryManager.getInstance();
         if(_loc1_.spellsInventory != _loc1_.playerSpellList)
         {
            _loc1_.spellsInventory = _loc1_.playerSpellList;
            KernelEventsManager.getInstance().processCallback(HookList.SpellList,_loc1_.playerSpellList);
         }
         if(_loc2_.shortcutBarSpells != _loc1_.playerShortcutList)
         {
            _loc2_.shortcutBarSpells = _loc1_.playerShortcutList;
            KernelEventsManager.getInstance().processCallback(InventoryHookList.ShortcutBarViewContent,ShortcutBarEnum.SPELL_SHORTCUT_BAR);
         }
      }
      
      public function setCharacteristicsInformations(param1:int, param2:CharacterCharacteristicsInformations) : void
      {
         this._characteristicsInformationsList[param1] = param2;
      }
      
      public function getCharacteristicsInformations(param1:int = 0) : CharacterCharacteristicsInformations
      {
         var _loc2_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         if(param1)
         {
            if(param1 == _loc2_.id)
            {
               return _loc2_.characteristics;
            }
            return this._characteristicsInformationsList[param1];
         }
         if(this._currentFighterIsRealPlayer || !_loc2_.isFighting)
         {
            return _loc2_.characteristics;
         }
         return this._characteristicsInformationsList[this._currentFighterId];
      }
      
      public function getBasicTurnDuration() : int
      {
         var _loc1_:CharacterBaseCharacteristic = this._characteristicsInformationsList[this._currentFighterId].actionPoints;
         var _loc2_:CharacterBaseCharacteristic = this._characteristicsInformationsList[this._currentFighterId].movementPoints;
         return 15 + _loc1_.base + _loc1_.additionnal + _loc1_.objectsAndMountBonus + _loc2_.base + _loc2_.additionnal + _loc2_.objectsAndMountBonus;
      }
      
      public function getSpellById(param1:uint) : SpellWrapper
      {
         var _loc2_:SpellWrapper = null;
         var _loc3_:SpellWrapper = null;
         var _loc4_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         for each(_loc3_ in _loc4_.spellsInventory)
         {
            if(_loc3_.id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function getSpellCastManager() : SpellCastInFightManager
      {
         var _loc1_:SpellCastInFightManager = this._spellCastInFightManagerList[this._currentFighterId];
         if(!_loc1_)
         {
            _loc1_ = new SpellCastInFightManager(this._currentFighterId);
            this._spellCastInFightManagerList[this._currentFighterId] = _loc1_;
         }
         return _loc1_;
      }
      
      public function getSpellCastManagerById(param1:int) : SpellCastInFightManager
      {
         var _loc2_:SpellCastInFightManager = this._spellCastInFightManagerList[param1];
         if(!_loc2_)
         {
            _loc2_ = new SpellCastInFightManager(param1);
            this._spellCastInFightManagerList[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      public function canCastThisSpell(param1:uint, param2:uint, param3:int = 2147483647) : Boolean
      {
         var _loc4_:SpellWrapper = null;
         var _loc5_:SpellWrapper = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:CharacterSpellModification = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Weapon = null;
         var _loc12_:SpellState = null;
         var _loc13_:Weapon = null;
         var _loc14_:uint = 0;
         var _loc16_:SpellLevel;
         var _loc15_:Spell;
         if((_loc16_ = (_loc15_ = Spell.getSpellById(param1)).getSpellLevel(param2)) == null)
         {
            return false;
         }
         var _loc17_:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         if(_loc16_.minPlayerLevel > _loc17_.infos.level)
         {
            return false;
         }
         for each(_loc5_ in _loc17_.spellsInventory)
         {
            if(_loc5_ && _loc5_.id == param1)
            {
               _loc4_ = _loc5_;
            }
         }
         if(!_loc4_)
         {
            return false;
         }
         var _loc18_:CharacterCharacteristicsInformations;
         if(!(_loc18_ = this.getCharacteristicsInformations()))
         {
            return false;
         }
         var _loc19_:int = _loc18_.actionPointsCurrent;
         if(param1 == 0 && _loc17_.currentWeapon != null)
         {
            if(!(_loc11_ = Item.getItemById(_loc17_.currentWeapon.objectGID) as Weapon))
            {
               return false;
            }
            _loc6_ = _loc11_.apCost;
            _loc7_ = _loc11_.maxCastPerTurn;
         }
         else
         {
            _loc6_ = _loc4_.apCost;
            _loc7_ = _loc4_.maxCastPerTurn;
         }
         var _loc20_:SpellModificator = new SpellModificator();
         for each(_loc8_ in _loc18_.spellModifications)
         {
            if(_loc8_.spellId != param1)
            {
               continue;
            }
            switch(_loc8_.modificationType)
            {
               case CharacterSpellModificationTypeEnum.AP_COST:
                  _loc20_.apCost = _loc8_.value;
                  continue;
               case CharacterSpellModificationTypeEnum.CAST_INTERVAL:
                  _loc20_.castInterval = _loc8_.value;
                  continue;
               case CharacterSpellModificationTypeEnum.CAST_INTERVAL_SET:
                  _loc20_.castIntervalSet = _loc8_.value;
                  continue;
               case CharacterSpellModificationTypeEnum.MAX_CAST_PER_TARGET:
                  _loc20_.maxCastPerTarget = _loc8_.value;
                  continue;
               case CharacterSpellModificationTypeEnum.MAX_CAST_PER_TURN:
                  _loc20_.maxCastPerTurn = _loc8_.value;
                  continue;
               default:
                  continue;
            }
         }
         if(_loc6_ > _loc19_)
         {
            return false;
         }
         var _loc21_:Array;
         if(!(_loc21_ = FightersStateManager.getInstance().getStates(this._currentFighterId)))
         {
            _loc21_ = new Array();
         }
         for each(_loc9_ in _loc21_)
         {
            if((_loc12_ = SpellState.getSpellStateById(_loc9_)).preventsFight && param1 == 0)
            {
               return false;
            }
            if(_loc12_.id == 101 && param1 == 0)
            {
               if((_loc13_ = Item.getItemById(_loc17_.currentWeapon.objectGID) as Weapon).typeId != 2)
               {
                  return false;
               }
            }
            if(_loc16_.statesForbidden && _loc16_.statesForbidden.indexOf(_loc9_) != -1)
            {
               return false;
            }
            if(_loc12_.preventsSpellCast)
            {
               if(_loc16_.statesRequired)
               {
                  if(_loc16_.statesRequired.indexOf(_loc9_) == -1)
                  {
                     return false;
                  }
                  continue;
               }
               return false;
            }
         }
         for each(_loc10_ in _loc16_.statesRequired)
         {
            if(_loc21_.indexOf(_loc10_) == -1)
            {
               return false;
            }
         }
         if(_loc16_.canSummon && !this.canSummon())
         {
            return false;
         }
         if(_loc16_.canBomb && !this.canBomb())
         {
            return false;
         }
         if(!_loc17_.isFighting)
         {
            return true;
         }
         var _loc23_:SpellManager;
         var _loc22_:SpellCastInFightManager;
         if((_loc23_ = (_loc22_ = this.getSpellCastManager()).getSpellManagerBySpellId(param1)) == null)
         {
            return true;
         }
         if(_loc7_ <= _loc23_.numberCastThisTurn && _loc7_ > 0)
         {
            return false;
         }
         if(_loc23_.cooldown > 0 || _loc4_.actualCooldown > 0)
         {
            return false;
         }
         _loc14_ = _loc23_.getCastOnEntity(param3);
         if(_loc16_.maxCastPerTarget + _loc20_.getTotalBonus(_loc20_.maxCastPerTarget) <= _loc14_ && _loc16_.maxCastPerTarget > 0)
         {
            return false;
         }
         return true;
      }
      
      public function endFight() : void
      {
         if(PlayedCharacterManager.getInstance().id != this._currentFighterId)
         {
            this.currentFighterId = PlayedCharacterManager.getInstance().id;
            this.resetPlayerSpellList();
            this.updatePortrait(DofusEntities.getEntity(this._currentFighterId) as AnimatedCharacter);
         }
         this._currentFighterId = 0;
         this._characteristicsInformationsList = new Dictionary();
         this._spellCastInFightManagerList = new Dictionary();
         this._currentSummonedCreature = new Dictionary();
         this._currentSummonedBomb = new Dictionary();
      }
      
      public function getSpellModifications(param1:int, param2:int) : CharacterSpellModification
      {
         var _loc3_:CharacterSpellModification = null;
         var _loc4_:CharacterCharacteristicsInformations;
         if(_loc4_ = this.getCharacteristicsInformations())
         {
            for each(_loc3_ in _loc4_.spellModifications)
            {
               if(_loc3_.spellId == param1 && _loc3_.modificationType == param2)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public function canPlay() : Boolean
      {
         var _loc1_:FightEntitiesFrame = null;
         var _loc2_:GameFightFighterInformations = null;
         var _loc3_:FightReachableCellsMaker = null;
         var _loc4_:PlayedCharacterManager = null;
         var _loc5_:SpellWrapper = null;
         var _loc6_:Weapon = null;
         return true;
      }
      
      public function getCurrentSummonedCreature(param1:int = 0) : uint
      {
         if(!param1)
         {
            param1 = this._currentFighterId;
         }
         return this._currentSummonedCreature[param1];
      }
      
      public function setCurrentSummonedCreature(param1:uint, param2:int = 0) : void
      {
         if(!param2)
         {
            param2 = this._currentFighterId;
         }
         this._currentSummonedCreature[param2] = param1;
      }
      
      public function getCurrentSummonedBomb(param1:int = 0) : uint
      {
         if(!param1)
         {
            param1 = this._currentFighterId;
         }
         return this._currentSummonedBomb[param1];
      }
      
      public function setCurrentSummonedBomb(param1:uint, param2:int = 0) : void
      {
         if(!param2)
         {
            param2 = this._currentFighterId;
         }
         this._currentSummonedBomb[param2] = param1;
      }
      
      public function resetSummonedCreature(param1:int = 0) : void
      {
         this.setCurrentSummonedCreature(0,param1);
      }
      
      public function addSummonedCreature(param1:int = 0) : void
      {
         this.setCurrentSummonedCreature(this.getCurrentSummonedCreature(param1) + 1,param1);
      }
      
      public function removeSummonedCreature(param1:int = 0) : void
      {
         if(this.getCurrentSummonedCreature(param1) > 0)
         {
            this.setCurrentSummonedCreature(this.getCurrentSummonedCreature(param1) - 1,param1);
         }
      }
      
      public function getMaxSummonedCreature(param1:int = 0) : uint
      {
         var _loc2_:CharacterCharacteristicsInformations = this.getCharacteristicsInformations(param1);
         return _loc2_.summonableCreaturesBoost.base + _loc2_.summonableCreaturesBoost.objectsAndMountBonus + _loc2_.summonableCreaturesBoost.alignGiftBonus + _loc2_.summonableCreaturesBoost.contextModif;
      }
      
      public function canSummon(param1:int = 0) : Boolean
      {
         return this.getMaxSummonedCreature(param1) > this.getCurrentSummonedCreature(param1);
      }
      
      public function resetSummonedBomb(param1:int = 0) : void
      {
         this.setCurrentSummonedBomb(0,param1);
      }
      
      public function addSummonedBomb(param1:int = 0) : void
      {
         this.setCurrentSummonedBomb(this.getCurrentSummonedBomb(param1) + 1,param1);
      }
      
      public function removeSummonedBomb(param1:int = 0) : void
      {
         if(this.getCurrentSummonedBomb(param1) > 0)
         {
            this.setCurrentSummonedBomb(this.getCurrentSummonedBomb(param1) - 1,param1);
         }
      }
      
      public function canBomb(param1:int = 0) : Boolean
      {
         return this.getMaxSummonedBomb() > this.getCurrentSummonedBomb(param1);
      }
      
      private function getMaxSummonedBomb() : uint
      {
         return 3;
      }
      
      private function updatePortrait(param1:AnimatedCharacter) : void
      {
         if(this._currentFighterIsRealPlayer)
         {
            KernelEventsManager.getInstance().processCallback(FightHookList.ShowMonsterArtwork,0);
         }
         else if(param1)
         {
            KernelEventsManager.getInstance().processCallback(FightHookList.ShowMonsterArtwork,param1.look.getBone());
         }
      }
   }
}
