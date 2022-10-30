package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceInteger;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.internalDatacenter.fight.FighterInformations;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsListWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightPreparationFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightSpellCastFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.network.enums.FightTypeEnum;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class FightApi implements IApi
   {
      
      private static var UNKNOWN_FIGHTER_NAME:String = "???";
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function FightApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(FightApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getFighterInformations(param1:int) : FighterInformations
      {
         return new FighterInformations(param1);
      }
      
      [Untrusted]
      public function getFighterName(param1:int) : String
      {
         var fighterId:int = param1;
         try
         {
            return this.getFightFrame().getFighterName(fighterId);
         }
         catch(apiErr:ApiError)
         {
            return UNKNOWN_FIGHTER_NAME;
         }
      }
      
      [Untrusted]
      public function getFighterLevel(param1:int) : uint
      {
         return this.getFightFrame().getFighterLevel(param1);
      }
      
      [Untrusted]
      public function getFighters() : Vector.<int>
      {
         if(Kernel.getWorker().getFrame(FightBattleFrame) && !Kernel.getWorker().getFrame(FightPreparationFrame))
         {
            return this.getFightFrame().battleFrame.fightersList;
         }
         return this.getFightFrame().entitiesFrame.getOrdonnedPreFighters();
      }
      
      [Untrusted]
      public function getMonsterId(param1:int) : int
      {
         var _loc2_:GameFightFighterInformations = this.getFighterInfos(param1);
         if(_loc2_ is GameFightMonsterInformations)
         {
            return GameFightMonsterInformations(_loc2_).creatureGenericId;
         }
         return -1;
      }
      
      [Untrusted]
      public function getDeadFighters() : Vector.<int>
      {
         if(Kernel.getWorker().getFrame(FightBattleFrame))
         {
            return this.getFightFrame().battleFrame.deadFightersList;
         }
         return new Vector.<int>();
      }
      
      [Untrusted]
      public function getFightType() : uint
      {
         return this.getFightFrame().fightType;
      }
      
      [Untrusted]
      public function getBuffList(param1:int) : Array
      {
         return BuffManager.getInstance().getAllBuff(param1);
      }
      
      [Untrusted]
      public function getBuffById(param1:uint, param2:int) : BasicBuff
      {
         return BuffManager.getInstance().getBuff(param1,param2);
      }
      
      [Untrusted]
      public function createEffectsWrapper(param1:Spell, param2:Array, param3:String) : EffectsWrapper
      {
         return new EffectsWrapper(param2,param1,param3);
      }
      
      [Untrusted]
      public function getCastingSpellBuffEffects(param1:int, param2:uint) : EffectsWrapper
      {
         var _loc3_:Spell = null;
         var _loc4_:BasicBuff = null;
         var _loc5_:EffectsWrapper = null;
         var _loc6_:EffectInstance = null;
         var _loc7_:EffectInstanceInteger = null;
         var _loc8_:Array = new Array();
         var _loc9_:Array = BuffManager.getInstance().getAllBuff(param1);
         var _loc10_:Array = new Array();
         for each(_loc4_ in _loc9_)
         {
            if(_loc4_.castingSpell.castingSpellId == param2)
            {
               if((_loc6_ = _loc4_.effect).trigger && _loc6_ is EffectInstanceInteger)
               {
                  _loc7_ = _loc6_ as EffectInstanceInteger;
                  if(_loc10_[_loc7_.effectId + "," + _loc7_.value])
                  {
                     continue;
                  }
                  _loc10_[_loc7_.effectId + "," + _loc7_.value] = true;
                  _loc8_.push(_loc6_);
               }
               else
               {
                  _loc8_.push(_loc6_);
               }
               if(!_loc3_)
               {
                  _loc3_ = _loc4_.castingSpell.spell;
               }
            }
         }
         return new EffectsWrapper(_loc8_,_loc3_,"");
      }
      
      [Untrusted]
      public function getAllBuffEffects(param1:int) : EffectsListWrapper
      {
         return new EffectsListWrapper(BuffManager.getInstance().getAllBuff(param1));
      }
      
      [Untrusted]
      public function isCastingSpell() : Boolean
      {
         return Kernel.getWorker().contains(FightSpellCastFrame);
      }
      
      [Untrusted]
      public function cancelSpell() : void
      {
         if(Kernel.getWorker().contains(FightSpellCastFrame))
         {
            Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(FightSpellCastFrame));
         }
      }
      
      [Untrusted]
      public function getChallengeList() : Array
      {
         return this.getFightFrame().challengesList;
      }
      
      [Untrusted]
      public function getCurrentPlayedFighterId() : int
      {
         return CurrentPlayedFighterManager.getInstance().currentFighterId;
      }
      
      [Untrusted]
      public function getPlayingFighterId() : int
      {
         return this.getFightFrame().battleFrame.currentPlayerId;
      }
      
      [Untrusted]
      public function isCompanion(param1:int) : Boolean
      {
         return this.getFightFrame().entitiesFrame.getEntityInfos(param1) is GameFightCompanionInformations;
      }
      
      [Untrusted]
      public function getCurrentPlayedCharacteristicsInformations() : CharacterCharacteristicsInformations
      {
         return CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations();
      }
      
      [Untrusted]
      public function preFightIsActive() : Boolean
      {
         return FightContextFrame.preFightIsActive;
      }
      
      [Untrusted]
      public function isWaitingBeforeFight() : Boolean
      {
         if(this.getFightFrame().fightType == FightTypeEnum.FIGHT_TYPE_PvMA || this.getFightFrame().fightType == FightTypeEnum.FIGHT_TYPE_PvT)
         {
            return true;
         }
         return false;
      }
      
      [Untrusted]
      public function isFightLeader() : Boolean
      {
         return this.getFightFrame().isFightLeader;
      }
      
      [Untrusted]
      public function isSpectator() : Boolean
      {
         return PlayedCharacterManager.getInstance().isSpectator;
      }
      
      [Untrusted]
      public function isDematerializated() : Boolean
      {
         return this.getFightFrame().entitiesFrame.dematerialization;
      }
      
      [Untrusted]
      public function getTurnsCount() : int
      {
         return this.getFightFrame().battleFrame.turnsCount;
      }
      
      [Untrusted]
      public function getFighterStatus(param1:uint) : int
      {
         var _loc2_:Frame = Kernel.getWorker().getFrame(FightEntitiesFrame);
         var _loc3_:Dictionary = FightEntitiesFrame(_loc2_).lastKnownPlayerStatus;
         if(_loc3_[param1])
         {
            return _loc3_[param1];
         }
         return -1;
      }
      
      [Untrusted]
      public function isMouseOverFighter(param1:int) : Boolean
      {
         var _loc2_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         return this.getFighterInfos(param1).disposition.cellId == FightContextFrame.currentCell || _loc2_.timelineOverEntity && param1 == _loc2_.timelineOverEntityId;
      }
      
      [Untrusted]
      public function updateSwapPositionRequestsIcons() : void
      {
         var _loc1_:FightPreparationFrame = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame;
         if(_loc1_)
         {
            _loc1_.updateSwapPositionRequestsIcons();
         }
      }
      
      [Untrusted]
      public function setSwapPositionRequestsIconsVisibility(param1:Boolean) : void
      {
         var _loc2_:FightPreparationFrame = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame;
         if(_loc2_)
         {
            _loc2_.setSwapPositionRequestsIconsVisibility(param1);
         }
      }
      
      private function getFighterInfos(param1:int) : GameFightFighterInformations
      {
         return this.getFightFrame().entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
      }
      
      private function getFightFrame() : FightContextFrame
      {
         var _loc1_:Frame = Kernel.getWorker().getFrame(FightContextFrame);
         if(!_loc1_)
         {
            throw new ApiError("Unallowed call of FightApi method while not fighting.");
         }
         return _loc1_ as FightContextFrame;
      }
      
      private function getFighterTeam(param1:GameFightFighterInformations) : String
      {
         switch(param1.teamId)
         {
            case TeamEnum.TEAM_CHALLENGER:
               return "challenger";
            case TeamEnum.TEAM_DEFENDER:
               return "defender";
            case TeamEnum.TEAM_SPECTATOR:
               return "spectator";
            default:
               this._log.warn("Unknown teamId " + param1.teamId + " ?!");
               return "unknown";
         }
      }
   }
}
