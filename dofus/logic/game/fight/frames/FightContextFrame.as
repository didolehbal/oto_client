package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.*;
   import com.ankamagames.atouin.messages.CellOutMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.messages.MapLoadedMessage;
   import com.ankamagames.atouin.messages.MapsLoadingCompleteMessage;
   import com.ankamagames.atouin.renderers.*;
   import com.ankamagames.atouin.types.*;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.event.UiUnloadEvent;
   import com.ankamagames.berilia.types.tooltip.TooltipPlacer;
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.fight.ChallengeWrapper;
   import com.ankamagames.dofus.internalDatacenter.fight.FightResultEntryWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.enum.UISoundEnum;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.game.common.frames.PartyManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SpellInventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.messages.FightEndingMessage;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.ChallengeTargetsListRequestAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ShowTacticModeAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOutAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOverAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TogglePointCellAction;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.LinkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellZoneManager;
   import com.ankamagames.dofus.logic.game.fight.managers.TacticModeManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.DamageUtil;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightReachableCellsMaker;
   import com.ankamagames.dofus.logic.game.fight.miscs.PushUtil;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.logic.game.fight.types.EffectDamage;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.logic.game.fight.types.PushedEntity;
   import com.ankamagames.dofus.logic.game.fight.types.SpellCastInFightManager;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamage;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamageInfo;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamageList;
   import com.ankamagames.dofus.logic.game.fight.types.SplashDamage;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.logic.game.fight.types.TriggeredSpell;
   import com.ankamagames.dofus.logic.game.roleplay.frames.MonstersInfoFrame;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.network.enums.FightOutcomeEnum;
   import com.ankamagames.dofus.network.enums.GameActionFightInvisibilityStateEnum;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   import com.ankamagames.dofus.network.enums.MapObstacleStateEnum;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCarryCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightNoSpellCastMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextDestroyMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextReadyMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightResumeMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightResumeWithSlavesMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightSpectateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightSpectatorJoinMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightStartMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightStartingMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightUpdateTeamMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeInfoMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeResultMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetsListMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetsListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.CurrentMapMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapObstacleUpdateMessage;
   import com.ankamagames.dofus.network.types.game.action.fight.FightDispellableEffectExtendedInformations;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMark;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMarkedCell;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultFighterListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultPlayerListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultTaxCollectorListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterNamedInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightResumeSlaveInfo;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.NamedPartyTeam;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.NamedPartyTeamWithOutcome;
   import com.ankamagames.dofus.network.types.game.idol.Idol;
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.Glyph;
   import com.ankamagames.dofus.types.sequences.AddGlyphGfxStep;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.*;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.utils.memory.WeakReference;
   import com.hurlant.util.Hex;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class FightContextFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightContextFrame));
      
      public static var preFightIsActive:Boolean = true;
      
      public static var fighterEntityTooltipId:int;
      
      public static var currentCell:int = -1;
       
      
      private const TYPE_LOG_FIGHT:uint = 30000;
      
      private const INVISIBLE_POSITION_SELECTION:String = "invisible_position";
      
      private var _entitiesFrame:FightEntitiesFrame;
      
      private var _preparationFrame:FightPreparationFrame;
      
      private var _battleFrame:FightBattleFrame;
      
      private var _pointCellFrame:FightPointCellFrame;
      
      private var _overEffectOk:GlowFilter;
      
      private var _overEffectKo:GlowFilter;
      
      private var _linkedEffect:ColorMatrixFilter;
      
      private var _linkedMainEffect:ColorMatrixFilter;
      
      private var _lastEffectEntity:WeakReference;
      
      private var _reachableRangeSelection:Selection;
      
      private var _unreachableRangeSelection:Selection;
      
      private var _timerFighterInfo:Timer;
      
      private var _timerMovementRange:Timer;
      
      private var _currentFighterInfo:GameFightFighterInformations;
      
      private var _currentMapRenderId:int = -1;
      
      private var _timelineOverEntity:Boolean;
      
      private var _timelineOverEntityId:int;
      
      private var _showPermanentTooltips:Boolean;
      
      private var _hideTooltipTimer:Timer;
      
      private var _hideTooltipEntityId:int;
      
      private var _hideTooltipsTimer:Timer;
      
      private var _hideTooltips:Boolean;
      
      public var _challengesList:Array;
      
      private var _fightType:uint;
      
      private var _fightAttackerId:uint;
      
      private var _spellTargetsTooltips:Dictionary;
      
      private var _spellDamages:Dictionary;
      
      private var _spellAlreadyTriggered:Boolean;
      
      private var _namedPartyTeams:Vector.<NamedPartyTeam>;
      
      private var _fightersPositionsHistory:Dictionary;
      
      private var _fightIdols:Vector.<Idol>;
      
      public var isFightLeader:Boolean;
      
      public function FightContextFrame()
      {
         this._spellTargetsTooltips = new Dictionary();
         this._spellDamages = new Dictionary();
         this._fightersPositionsHistory = new Dictionary();
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get entitiesFrame() : FightEntitiesFrame
      {
         return this._entitiesFrame;
      }
      
      public function get battleFrame() : FightBattleFrame
      {
         return this._battleFrame;
      }
      
      public function get challengesList() : Array
      {
         return this._challengesList;
      }
      
      public function get fightType() : uint
      {
         return this._fightType;
      }
      
      public function set fightType(param1:uint) : void
      {
         this._fightType = param1;
         var _loc2_:PartyManagementFrame = Kernel.getWorker().getFrame(PartyManagementFrame) as PartyManagementFrame;
         _loc2_.lastFightType = param1;
      }
      
      public function get timelineOverEntity() : Boolean
      {
         return this._timelineOverEntity;
      }
      
      public function get timelineOverEntityId() : int
      {
         return this._timelineOverEntityId;
      }
      
      public function get showPermanentTooltips() : Boolean
      {
         return this._showPermanentTooltips;
      }
      
      public function get fightersPositionsHistory() : Dictionary
      {
         return this._fightersPositionsHistory;
      }
      
      public function pushed() : Boolean
      {
         if(!Kernel.beingInReconection)
         {
            Atouin.getInstance().displayGrid(true,true);
         }
         currentCell = -1;
         this._overEffectOk = new GlowFilter(16777215,1,4,4,3,1);
         this._overEffectKo = new GlowFilter(14090240,1,4,4,3,1);
         var _loc1_:Array = new Array();
         _loc1_ = _loc1_.concat([0.5,0,0,0,100]);
         _loc1_ = _loc1_.concat([0,0.5,0,0,100]);
         _loc1_ = _loc1_.concat([0,0,0.5,0,100]);
         _loc1_ = _loc1_.concat([0,0,0,1,0]);
         this._linkedEffect = new ColorMatrixFilter(_loc1_);
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([0.5,0,0,0,0]);
         _loc2_ = _loc2_.concat([0,0.5,0,0,0]);
         _loc2_ = _loc2_.concat([0,0,0.5,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         this._linkedMainEffect = new ColorMatrixFilter(_loc2_);
         this._entitiesFrame = new FightEntitiesFrame();
         this._preparationFrame = new FightPreparationFrame(this);
         this._battleFrame = new FightBattleFrame();
         this._pointCellFrame = new FightPointCellFrame();
         this._challengesList = new Array();
         this._timerFighterInfo = new Timer(100,1);
         this._timerFighterInfo.addEventListener(TimerEvent.TIMER,this.showFighterInfo,false,0,true);
         this._timerMovementRange = new Timer(200,1);
         this._timerMovementRange.addEventListener(TimerEvent.TIMER,this.showMovementRange,false,0,true);
         if(MapDisplayManager.getInstance().getDataMapContainer())
         {
            MapDisplayManager.getInstance().getDataMapContainer().setTemporaryAnimatedElementState(false);
         }
         if(Kernel.getWorker().contains(MonstersInfoFrame))
         {
            Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(MonstersInfoFrame) as MonstersInfoFrame);
         }
         this._showPermanentTooltips = OptionManager.getOptionManager("dofus")["showPermanentTargetsTooltips"];
         OptionManager.getOptionManager("dofus").addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         Berilia.getInstance().addEventListener(UiUnloadEvent.UNLOAD_UI_COMPLETE,this.onUiUnloaded);
         return true;
      }
      
      private function onUiUnloaded(param1:UiUnloadEvent) : void
      {
         var _loc2_:int = 0;
         if(this._showPermanentTooltips && this.battleFrame)
         {
            for each(_loc2_ in this.battleFrame.targetedEntities)
            {
               this.displayEntityTooltip(_loc2_);
            }
         }
      }
      
      public function getFighterName(param1:int) : String
      {
         var _loc2_:GameFightFighterInformations = null;
         var _loc3_:GameFightCompanionInformations = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:GameFightTaxCollectorInformations = null;
         var _loc7_:String = null;
         _loc2_ = this.getFighterInfos(param1);
         if(!_loc2_)
         {
            return "Unknown Fighter";
         }
         switch(true)
         {
            case _loc2_ is GameFightFighterNamedInformations:
               return (_loc2_ as GameFightFighterNamedInformations).name;
            case _loc2_ is GameFightMonsterInformations:
               return Monster.getMonsterById((_loc2_ as GameFightMonsterInformations).creatureGenericId).name;
            case _loc2_ is GameFightCompanionInformations:
               _loc3_ = _loc2_ as GameFightCompanionInformations;
               _loc5_ = Companion.getCompanionById(_loc3_.companionGenericId).name;
               if(_loc3_.masterId != PlayedCharacterManager.getInstance().id)
               {
                  _loc7_ = this.getFighterName(_loc3_.masterId);
                  _loc4_ = I18n.getUiText("ui.common.belonging",[_loc5_,_loc7_]);
               }
               else
               {
                  _loc4_ = _loc5_;
               }
               return _loc4_;
            case _loc2_ is GameFightTaxCollectorInformations:
               _loc6_ = _loc2_ as GameFightTaxCollectorInformations;
               return TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc6_.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc6_.lastNameId).name;
            default:
               return "Unknown Fighter Type";
         }
      }
      
      public function getFighterStatus(param1:int) : uint
      {
         var _loc2_:GameFightFighterInformations = this.getFighterInfos(param1);
         if(!_loc2_)
         {
            return 1;
         }
         switch(true)
         {
            case _loc2_ is GameFightFighterNamedInformations:
               return (_loc2_ as GameFightFighterNamedInformations).status.statusId;
            default:
               return 1;
         }
      }
      
      public function getFighterLevel(param1:int) : uint
      {
         var _loc2_:GameFightFighterInformations = null;
         var _loc3_:Monster = null;
         _loc2_ = this.getFighterInfos(param1);
         if(!_loc2_)
         {
            return 0;
         }
         switch(true)
         {
            case _loc2_ is GameFightMutantInformations:
               return (_loc2_ as GameFightMutantInformations).powerLevel;
            case _loc2_ is GameFightCharacterInformations:
               return (_loc2_ as GameFightCharacterInformations).level;
            case _loc2_ is GameFightCompanionInformations:
               return (_loc2_ as GameFightCompanionInformations).level;
            case _loc2_ is GameFightMonsterInformations:
               _loc3_ = Monster.getMonsterById((_loc2_ as GameFightMonsterInformations).creatureGenericId);
               return _loc3_.getMonsterGrade((_loc2_ as GameFightMonsterInformations).creatureGrade).level;
            case _loc2_ is GameFightTaxCollectorInformations:
               return (_loc2_ as GameFightTaxCollectorInformations).level;
            default:
               return 0;
         }
      }
      
      public function getChallengeById(param1:uint) : ChallengeWrapper
      {
         var _loc2_:ChallengeWrapper = null;
         for each(_loc2_ in this._challengesList)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:GameFightStartingMessage = null;
         var _loc4_:CurrentMapMessage = null;
         var _loc5_:WorldPointWrapper = null;
         var _loc6_:ByteArray = null;
         var _loc7_:GameContextReadyMessage = null;
         var _loc8_:MapsLoadingCompleteMessage = null;
         var _loc9_:GameFightResumeMessage = null;
         var _loc10_:int = 0;
         var _loc11_:Vector.<GameFightResumeSlaveInfo> = null;
         var _loc12_:GameFightResumeSlaveInfo = null;
         var _loc13_:CurrentPlayedFighterManager = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:GameFightResumeSlaveInfo = null;
         var _loc17_:SpellCastInFightManager = null;
         var _loc18_:Array = null;
         var _loc19_:Array = null;
         var _loc20_:Array = null;
         var _loc21_:CastingSpell = null;
         var _loc22_:uint = 0;
         var _loc23_:FightDispellableEffectExtendedInformations = null;
         var _loc24_:GameFightUpdateTeamMessage = null;
         var _loc25_:GameFightSpectateMessage = null;
         var _loc26_:Number = NaN;
         var _loc27_:String = null;
         var _loc28_:String = null;
         var _loc29_:Array = null;
         var _loc30_:Array = null;
         var _loc31_:Array = null;
         var _loc32_:CastingSpell = null;
         var _loc33_:GameFightSpectatorJoinMessage = null;
         var _loc34_:int = 0;
         var _loc35_:String = null;
         var _loc36_:String = null;
         var _loc37_:GameFightJoinMessage = null;
         var _loc38_:int = 0;
         var _loc39_:GameActionFightCarryCharacterMessage = null;
         var _loc40_:GameFightStartMessage = null;
         var _loc41_:CellOverMessage = null;
         var _loc42_:AnimatedCharacter = null;
         var _loc43_:MarkedCellsManager = null;
         var _loc44_:MarkInstance = null;
         var _loc45_:CellOutMessage = null;
         var _loc46_:AnimatedCharacter = null;
         var _loc47_:MarkedCellsManager = null;
         var _loc48_:MarkInstance = null;
         var _loc49_:EntityMouseOverMessage = null;
         var _loc50_:EntityMouseOutMessage = null;
         var _loc51_:GameFightLeaveMessage = null;
         var _loc52_:TimelineEntityOverAction = null;
         var _loc53_:FightSpellCastFrame = null;
         var _loc54_:TimelineEntityOutAction = null;
         var _loc55_:int = 0;
         var _loc56_:Vector.<int> = null;
         var _loc57_:TogglePointCellAction = null;
         var _loc58_:GameFightEndMessage = null;
         var _loc59_:ChallengeTargetsListRequestAction = null;
         var _loc60_:ChallengeTargetsListRequestMessage = null;
         var _loc61_:ChallengeTargetsListMessage = null;
         var _loc62_:ChallengeInfoMessage = null;
         var _loc63_:ChallengeWrapper = null;
         var _loc64_:ChallengeTargetUpdateMessage = null;
         var _loc65_:ChallengeResultMessage = null;
         var _loc66_:MapObstacleUpdateMessage = null;
         var _loc67_:GameActionFightNoSpellCastMessage = null;
         var _loc68_:uint = 0;
         var _loc69_:String = null;
         var _loc70_:GameFightResumeWithSlavesMessage = null;
         var _loc71_:BasicBuff = null;
         var _loc72_:NamedPartyTeam = null;
         var _loc73_:FightDispellableEffectExtendedInformations = null;
         var _loc74_:BasicBuff = null;
         var _loc75_:NamedPartyTeam = null;
         var _loc76_:IEntity = null;
         var _loc77_:MarkInstance = null;
         var _loc78_:Glyph = null;
         var _loc79_:Vector.<MapPoint> = null;
         var _loc80_:Vector.<uint> = null;
         var _loc81_:IEntity = null;
         var _loc82_:MarkInstance = null;
         var _loc83_:Glyph = null;
         var _loc84_:FightEndingMessage = null;
         var _loc85_:Vector.<FightResultEntryWrapper> = null;
         var _loc86_:uint = 0;
         var _loc87_:FightResultEntryWrapper = null;
         var _loc88_:Vector.<FightResultEntryWrapper> = null;
         var _loc89_:Array = null;
         var _loc90_:FightResultListEntry = null;
         var _loc91_:String = null;
         var _loc92_:String = null;
         var _loc93_:NamedPartyTeamWithOutcome = null;
         var _loc94_:Object = null;
         var _loc95_:Vector.<uint> = null;
         var _loc96_:FightResultEntryWrapper = null;
         var _loc97_:int = 0;
         var _loc98_:FightResultListEntry = null;
         var _loc99_:uint = 0;
         var _loc100_:ItemWrapper = null;
         var _loc101_:int = 0;
         var _loc102_:int = 0;
         var _loc103_:FightResultEntryWrapper = null;
         var _loc104_:uint = 0;
         var _loc105_:int = 0;
         var _loc106_:Number = NaN;
         var _loc107_:MapObstacle = null;
         var _loc108_:SpellLevel = null;
         var _loc109_:* = undefined;
         switch(true)
         {
            case param1 is MapLoadedMessage:
               MapDisplayManager.getInstance().getDataMapContainer().setTemporaryAnimatedElementState(false);
               return true;
            case param1 is GameFightStartingMessage:
               _loc3_ = param1 as GameFightStartingMessage;
               TooltipManager.hideAll();
               Atouin.getInstance().cancelZoom();
               KernelEventsManager.getInstance().processCallback(HookList.StartZoom,false);
               MapDisplayManager.getInstance().activeIdentifiedElements(false);
               FightEventsHelper.reset();
               KernelEventsManager.getInstance().processCallback(HookList.GameFightStarting,_loc3_.fightType);
               this.fightType = _loc3_.fightType;
               this._fightAttackerId = _loc3_.attackerId;
               CurrentPlayedFighterManager.getInstance().currentFighterId = PlayedCharacterManager.getInstance().id;
               CurrentPlayedFighterManager.getInstance().getSpellCastManager().currentTurn = 0;
               SoundManager.getInstance().manager.playFightMusic();
               SoundManager.getInstance().manager.playUISound(UISoundEnum.INTRO_FIGHT);
               return true;
            case param1 is CurrentMapMessage:
               _loc4_ = param1 as CurrentMapMessage;
               ConnectionsHandler.pause();
               Kernel.getWorker().pause();
               if(TacticModeManager.getInstance().tacticModeActivated)
               {
                  TacticModeManager.getInstance().hide();
               }
               _loc5_ = new WorldPointWrapper(_loc4_.mapId);
               KernelEventsManager.getInstance().processCallback(HookList.StartZoom,false);
               Atouin.getInstance().initPreDisplay(_loc5_);
               Atouin.getInstance().clearEntities();
               if(_loc4_.mapKey && _loc4_.mapKey.length)
               {
                  if(!(_loc69_ = XmlConfig.getInstance().getEntry("config.maps.encryptionKey")))
                  {
                     _loc69_ = _loc4_.mapKey;
                  }
                  _loc6_ = Hex.toArray(Hex.fromString(_loc69_));
               }
               this._currentMapRenderId = Atouin.getInstance().display(_loc5_,_loc6_);
               _log.info("Ask map render for fight #" + this._currentMapRenderId);
               PlayedCharacterManager.getInstance().currentMap = _loc5_;
               KernelEventsManager.getInstance().processCallback(HookList.CurrentMap,_loc4_.mapId);
               return true;
            case param1 is MapsLoadingCompleteMessage:
               _log.info("MapsLoadingCompleteMessage #" + MapsLoadingCompleteMessage(param1).renderRequestId);
               if(this._currentMapRenderId != MapsLoadingCompleteMessage(param1).renderRequestId)
               {
                  return false;
               }
               Atouin.getInstance().showWorld(true);
               Atouin.getInstance().displayGrid(true,true);
               Atouin.getInstance().cellOverEnabled = true;
               (_loc7_ = new GameContextReadyMessage()).initGameContextReadyMessage(MapDisplayManager.getInstance().currentMapPoint.mapId);
               ConnectionsHandler.getConnection().send(_loc7_);
               _loc8_ = param1 as MapsLoadingCompleteMessage;
               SoundManager.getInstance().manager.setSubArea(_loc8_.mapData);
               Kernel.getWorker().resume();
               ConnectionsHandler.resume();
               return true;
               break;
            case param1 is GameFightResumeMessage:
               _loc9_ = param1 as GameFightResumeMessage;
               _loc10_ = PlayedCharacterManager.getInstance().id;
               this.tacticModeHandler();
               CurrentPlayedFighterManager.getInstance().setCurrentSummonedCreature(_loc9_.summonCount,_loc10_);
               CurrentPlayedFighterManager.getInstance().setCurrentSummonedBomb(_loc9_.bombCount,_loc10_);
               this._battleFrame.turnsCount = _loc9_.gameTurn - 1;
               KernelEventsManager.getInstance().processCallback(FightHookList.TurnCountUpdated,_loc9_.gameTurn - 1);
               this._fightIdols = _loc9_.idols;
               KernelEventsManager.getInstance().processCallback(FightHookList.FightIdolList,_loc9_.idols);
               if(param1 is GameFightResumeWithSlavesMessage)
               {
                  _loc11_ = (_loc70_ = param1 as GameFightResumeWithSlavesMessage).slavesInfo;
               }
               else
               {
                  _loc11_ = new Vector.<GameFightResumeSlaveInfo>();
               }
               (_loc12_ = new GameFightResumeSlaveInfo()).spellCooldowns = _loc9_.spellCooldowns;
               _loc12_.slaveId = PlayedCharacterManager.getInstance().id;
               _loc11_.unshift(_loc12_);
               _loc13_ = CurrentPlayedFighterManager.getInstance();
               _loc15_ = _loc11_.length;
               _loc14_ = 0;
               while(_loc14_ < _loc15_)
               {
                  _loc16_ = _loc11_[_loc14_];
                  (_loc17_ = _loc13_.getSpellCastManagerById(_loc16_.slaveId)).currentTurn = _loc9_.gameTurn - 1;
                  _loc17_.updateCooldowns(_loc11_[_loc14_].spellCooldowns);
                  if(_loc16_.slaveId != _loc10_)
                  {
                     CurrentPlayedFighterManager.getInstance().setCurrentSummonedCreature(_loc16_.summonCount,_loc16_.slaveId);
                     CurrentPlayedFighterManager.getInstance().setCurrentSummonedBomb(_loc16_.bombCount,_loc16_.slaveId);
                  }
                  _loc14_++;
               }
               _loc18_ = [];
               _loc22_ = _loc9_.effects.length;
               _loc14_ = 0;
               while(_loc14_ < _loc22_)
               {
                  _loc23_ = _loc9_.effects[_loc14_];
                  if(!_loc18_[_loc23_.effect.targetId])
                  {
                     _loc18_[_loc23_.effect.targetId] = [];
                  }
                  if(!(_loc19_ = _loc18_[_loc23_.effect.targetId])[_loc23_.effect.turnDuration])
                  {
                     _loc19_[_loc23_.effect.turnDuration] = [];
                  }
                  if(!(_loc21_ = (_loc20_ = _loc19_[_loc23_.effect.turnDuration])[_loc23_.effect.spellId]))
                  {
                     (_loc21_ = new CastingSpell()).casterId = _loc23_.sourceId;
                     _loc21_.spell = Spell.getSpellById(_loc23_.effect.spellId);
                     _loc20_[_loc23_.effect.spellId] = _loc21_;
                  }
                  _loc71_ = BuffManager.makeBuffFromEffect(_loc23_.effect,_loc21_,_loc23_.actionId);
                  BuffManager.getInstance().addBuff(_loc71_);
                  _loc14_++;
               }
               this.addMarks(_loc9_.marks);
               Kernel.beingInReconection = false;
               return true;
            case param1 is GameFightUpdateTeamMessage:
               _loc24_ = param1 as GameFightUpdateTeamMessage;
               PlayedCharacterManager.getInstance().teamId = _loc24_.team.teamId;
               return true;
            case param1 is GameFightSpectateMessage:
               _loc25_ = param1 as GameFightSpectateMessage;
               this.tacticModeHandler();
               this._battleFrame.turnsCount = _loc25_.gameTurn - 1;
               KernelEventsManager.getInstance().processCallback(FightHookList.TurnCountUpdated,_loc25_.gameTurn - 1);
               this._fightIdols = _loc25_.idols;
               KernelEventsManager.getInstance().processCallback(FightHookList.FightIdolList,_loc25_.idols);
               _loc26_ = _loc25_.fightStart;
               _loc27_ = "";
               _loc28_ = "";
               for each(_loc72_ in this._namedPartyTeams)
               {
                  if(_loc72_.partyName && _loc72_.partyName != "")
                  {
                     if(_loc72_.teamId == TeamEnum.TEAM_CHALLENGER)
                     {
                        _loc27_ = _loc72_.partyName;
                     }
                     else if(_loc72_.teamId == TeamEnum.TEAM_DEFENDER)
                     {
                        _loc28_ = _loc72_.partyName;
                     }
                  }
               }
               KernelEventsManager.getInstance().processCallback(FightHookList.SpectateUpdate,_loc26_,_loc27_,_loc28_);
               _loc29_ = [];
               for each(_loc73_ in _loc25_.effects)
               {
                  if(!_loc29_[_loc73_.effect.targetId])
                  {
                     _loc29_[_loc73_.effect.targetId] = [];
                  }
                  if(!(_loc30_ = _loc29_[_loc73_.effect.targetId])[_loc73_.effect.turnDuration])
                  {
                     _loc30_[_loc73_.effect.turnDuration] = [];
                  }
                  if(!(_loc32_ = (_loc31_ = _loc30_[_loc73_.effect.turnDuration])[_loc73_.effect.spellId]))
                  {
                     (_loc32_ = new CastingSpell()).casterId = _loc73_.sourceId;
                     _loc32_.spell = Spell.getSpellById(_loc73_.effect.spellId);
                     _loc31_[_loc73_.effect.spellId] = _loc32_;
                  }
                  _loc74_ = BuffManager.makeBuffFromEffect(_loc73_.effect,_loc32_,_loc73_.actionId);
                  BuffManager.getInstance().addBuff(_loc74_,!(_loc74_ is StatBuff));
               }
               this.addMarks(_loc25_.marks);
               FightEventsHelper.sendAllFightEvent();
               return true;
            case param1 is GameFightSpectatorJoinMessage:
               _loc33_ = param1 as GameFightSpectatorJoinMessage;
               preFightIsActive = !_loc33_.isFightStarted;
               this.fightType = _loc33_.fightType;
               Kernel.getWorker().addFrame(this._entitiesFrame);
               if(preFightIsActive)
               {
                  Kernel.getWorker().addFrame(this._preparationFrame);
               }
               else
               {
                  Kernel.getWorker().removeFrame(this._preparationFrame);
                  Kernel.getWorker().addFrame(this._battleFrame);
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightStart);
               }
               PlayedCharacterManager.getInstance().isSpectator = true;
               PlayedCharacterManager.getInstance().isFighting = true;
               if((_loc34_ = _loc33_.timeMaxBeforeFightStart * 100) == 0 && preFightIsActive)
               {
                  _loc34_ = -1;
               }
               KernelEventsManager.getInstance().processCallback(HookList.GameFightJoin,_loc33_.canBeCancelled,_loc33_.canSayReady,true,_loc34_,_loc33_.fightType);
               this._namedPartyTeams = _loc33_.namedPartyTeams;
               _loc35_ = "";
               _loc36_ = "";
               for each(_loc75_ in _loc33_.namedPartyTeams)
               {
                  if(_loc75_.partyName && _loc75_.partyName != "")
                  {
                     if(_loc75_.teamId == TeamEnum.TEAM_CHALLENGER)
                     {
                        _loc35_ = _loc75_.partyName;
                     }
                     else if(_loc75_.teamId == TeamEnum.TEAM_DEFENDER)
                     {
                        _loc36_ = _loc75_.partyName;
                     }
                  }
               }
               KernelEventsManager.getInstance().processCallback(FightHookList.SpectateUpdate,0,_loc35_,_loc36_);
               return true;
            case param1 is INetworkMessage && INetworkMessage(param1).getMessageId() == GameFightJoinMessage.protocolId:
               _loc37_ = param1 as GameFightJoinMessage;
               preFightIsActive = !_loc37_.isFightStarted;
               this.fightType = _loc37_.fightType;
               Kernel.getWorker().addFrame(this._entitiesFrame);
               if(preFightIsActive)
               {
                  Kernel.getWorker().addFrame(this._preparationFrame);
               }
               else
               {
                  Kernel.getWorker().removeFrame(this._preparationFrame);
                  Kernel.getWorker().addFrame(this._battleFrame);
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightStart);
               }
               PlayedCharacterManager.getInstance().isSpectator = false;
               PlayedCharacterManager.getInstance().isFighting = true;
               if((_loc38_ = _loc37_.timeMaxBeforeFightStart * 100) == 0 && preFightIsActive)
               {
                  _loc38_ = -1;
               }
               KernelEventsManager.getInstance().processCallback(HookList.GameFightJoin,_loc37_.canBeCancelled,_loc37_.canSayReady,false,_loc38_,_loc37_.fightType);
               return true;
            case param1 is GameActionFightCarryCharacterMessage:
               _loc39_ = param1 as GameActionFightCarryCharacterMessage;
               if(this._lastEffectEntity && this._lastEffectEntity.object.id == _loc39_.targetId)
               {
                  this.process(new EntityMouseOutMessage(this._lastEffectEntity.object as IInteractive));
               }
               return false;
            case param1 is GameFightStartMessage:
               _loc40_ = param1 as GameFightStartMessage;
               preFightIsActive = false;
               Kernel.getWorker().removeFrame(this._preparationFrame);
               this._entitiesFrame.removeSwords();
               CurrentPlayedFighterManager.getInstance().getSpellCastManager().resetInitialCooldown();
               Kernel.getWorker().addFrame(this._battleFrame);
               KernelEventsManager.getInstance().processCallback(HookList.GameFightStart);
               this._fightIdols = _loc40_.idols;
               KernelEventsManager.getInstance().processCallback(FightHookList.FightIdolList,_loc40_.idols);
               return true;
            case param1 is GameContextDestroyMessage:
               TooltipManager.hide();
               Kernel.getWorker().removeFrame(this);
               return true;
            case param1 is CellOverMessage:
               _loc41_ = param1 as CellOverMessage;
               for each(_loc76_ in EntitiesManager.getInstance().getEntitiesOnCell(_loc41_.cellId))
               {
                  if(_loc76_ is AnimatedCharacter && !(_loc76_ as AnimatedCharacter).isMoving)
                  {
                     _loc42_ = _loc76_ as AnimatedCharacter;
                     break;
                  }
               }
               currentCell = _loc41_.cellId;
               if(_loc42_)
               {
                  this.overEntity(_loc42_.id);
               }
               if(_loc44_ = (_loc43_ = MarkedCellsManager.getInstance()).getMarkAtCellId(_loc41_.cellId,GameActionMarkTypeEnum.PORTAL))
               {
                  for each(_loc77_ in _loc43_.getMarks(_loc44_.markType,_loc44_.teamId,false))
                  {
                     if((_loc78_ = _loc43_.getGlyph(_loc77_.markId)) && _loc78_.lbl_number)
                     {
                        _loc78_.lbl_number.visible = true;
                     }
                  }
                  if(_loc44_.active && _loc43_.getActivePortalsCount(_loc44_.teamId) >= 2)
                  {
                     _loc79_ = _loc43_.getMarksMapPoint(GameActionMarkTypeEnum.PORTAL,_loc44_.teamId);
                     if(_loc80_ = LinkedCellsManager.getInstance().getLinks(MapPoint.fromCellId(_loc41_.cellId),_loc79_))
                     {
                        LinkedCellsManager.getInstance().drawPortalLinks(_loc80_);
                     }
                  }
               }
               return true;
            case param1 is CellOutMessage:
               _loc45_ = param1 as CellOutMessage;
               for each(_loc81_ in EntitiesManager.getInstance().getEntitiesOnCell(_loc45_.cellId))
               {
                  if(_loc81_ is AnimatedCharacter)
                  {
                     _loc46_ = _loc81_ as AnimatedCharacter;
                     break;
                  }
               }
               currentCell = -1;
               if(_loc46_)
               {
                  TooltipManager.hide();
                  TooltipManager.hide("fighter");
                  this.outEntity(_loc46_.id);
               }
               if(_loc48_ = (_loc47_ = MarkedCellsManager.getInstance()).getMarkAtCellId(_loc45_.cellId,GameActionMarkTypeEnum.PORTAL))
               {
                  for each(_loc82_ in _loc47_.getMarks(_loc48_.markType,_loc48_.teamId,false))
                  {
                     if((_loc83_ = _loc47_.getGlyph(_loc82_.markId)) && _loc83_.lbl_number)
                     {
                        _loc83_.lbl_number.visible = false;
                     }
                  }
               }
               LinkedCellsManager.getInstance().clearLinks();
               return true;
            case param1 is EntityMouseOverMessage:
               _loc49_ = param1 as EntityMouseOverMessage;
               currentCell = _loc49_.entity.position.cellId;
               this.overEntity(_loc49_.entity.id);
               return true;
            case param1 is EntityMouseOutMessage:
               _loc50_ = param1 as EntityMouseOutMessage;
               currentCell = -1;
               this.outEntity(_loc50_.entity.id);
               return true;
            case param1 is GameFightLeaveMessage:
               _loc51_ = param1 as GameFightLeaveMessage;
               if(TooltipManager.isVisible("tooltipOverEntity_" + _loc51_.charId))
               {
                  currentCell = -1;
                  this.outEntity(_loc51_.charId);
               }
               return false;
            case param1 is TimelineEntityOverAction:
               _loc52_ = param1 as TimelineEntityOverAction;
               this._timelineOverEntity = true;
               this._timelineOverEntityId = _loc52_.targetId;
               if(!(_loc53_ = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame))
               {
                  this.removeSpellTargetsTooltips();
               }
               this.overEntity(_loc52_.targetId,_loc52_.showRange,_loc52_.highlightTimelineFighter);
               return true;
            case param1 is TimelineEntityOutAction:
               _loc54_ = param1 as TimelineEntityOutAction;
               _loc56_ = this._entitiesFrame.getEntitiesIdsList();
               for each(_loc55_ in _loc56_)
               {
                  if((!this._showPermanentTooltips || this._showPermanentTooltips && this._battleFrame.targetedEntities.indexOf(_loc55_) == -1) && _loc55_ != _loc54_.targetId)
                  {
                     TooltipManager.hide("tooltipOverEntity_" + _loc55_);
                  }
               }
               this._timelineOverEntity = false;
               this.outEntity(_loc54_.targetId);
               this.removeSpellTargetsTooltips();
               return true;
            case param1 is TogglePointCellAction:
               _loc57_ = param1 as TogglePointCellAction;
               if(Kernel.getWorker().contains(FightPointCellFrame))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.ShowCell);
                  Kernel.getWorker().removeFrame(this._pointCellFrame);
               }
               else
               {
                  Kernel.getWorker().addFrame(this._pointCellFrame);
               }
               return true;
            case param1 is GameFightEndMessage:
               _loc58_ = param1 as GameFightEndMessage;
               if(TacticModeManager.getInstance().tacticModeActivated)
               {
                  TacticModeManager.getInstance().hide(true);
               }
               if(this._entitiesFrame.isInCreaturesFightMode())
               {
                  this._entitiesFrame.showCreaturesInFight(false);
               }
               TooltipManager.hide();
               TooltipManager.hide("fighter");
               this.hideMovementRange();
               CurrentPlayedFighterManager.getInstance().resetPlayerSpellList();
               MapDisplayManager.getInstance().activeIdentifiedElements(true);
               FightEventsHelper.sendAllFightEvent(true);
               if(!PlayedCharacterManager.getInstance().isSpectator)
               {
                  FightEventsHelper.sendFightEvent(FightEventEnum.FIGHT_END,[],0,-1,true);
               }
               SoundManager.getInstance().manager.stopFightMusic();
               PlayedCharacterManager.getInstance().isFighting = false;
               SpellWrapper.removeAllSpellWrapperBut(PlayedCharacterManager.getInstance().id,SecureCenter.ACCESS_KEY);
               SpellWrapper.resetAllCoolDown(PlayedCharacterManager.getInstance().id,SecureCenter.ACCESS_KEY);
               if(_loc58_.results == null)
               {
                  KernelEventsManager.getInstance().processCallback(FightHookList.SpectatorWantLeave);
               }
               else
               {
                  (_loc84_ = new FightEndingMessage()).initFightEndingMessage();
                  Kernel.getWorker().process(_loc84_);
                  _loc85_ = new Vector.<FightResultEntryWrapper>();
                  _loc86_ = 0;
                  _loc88_ = new Vector.<FightResultEntryWrapper>();
                  _loc89_ = new Array();
                  for each(_loc90_ in _loc58_.results)
                  {
                     _loc89_.push(_loc90_);
                  }
                  _loc14_ = 0;
                  while(_loc14_ < _loc89_.length)
                  {
                     _loc98_ = _loc89_[_loc14_];
                     switch(true)
                     {
                        case _loc98_ is FightResultPlayerListEntry:
                           _loc97_ = (_loc98_ as FightResultPlayerListEntry).id;
                           (_loc96_ = new FightResultEntryWrapper(_loc98_,this._entitiesFrame.getEntityInfos(_loc97_) as GameFightFighterInformations)).alive = FightResultPlayerListEntry(_loc98_).alive;
                           break;
                        case _loc98_ is FightResultTaxCollectorListEntry:
                           _loc97_ = (_loc98_ as FightResultTaxCollectorListEntry).id;
                           (_loc96_ = new FightResultEntryWrapper(_loc98_,this._entitiesFrame.getEntityInfos(_loc97_) as GameFightFighterInformations)).alive = FightResultTaxCollectorListEntry(_loc98_).alive;
                           break;
                        case _loc98_ is FightResultFighterListEntry:
                           _loc97_ = (_loc98_ as FightResultFighterListEntry).id;
                           (_loc96_ = new FightResultEntryWrapper(_loc98_,this._entitiesFrame.getEntityInfos(_loc97_) as GameFightFighterInformations)).alive = FightResultFighterListEntry(_loc98_).alive;
                           break;
                        case _loc98_ is FightResultListEntry:
                           _loc96_ = new FightResultEntryWrapper(_loc98_);
                     }
                     if(this._fightAttackerId == _loc97_)
                     {
                        _loc96_.fightInitiator = true;
                     }
                     else
                     {
                        _loc96_.fightInitiator = false;
                     }
                     _loc96_.wave = _loc98_.wave;
                     if(_loc14_ + 1 < _loc89_.length && _loc89_[_loc14_ + 1] && _loc89_[_loc14_ + 1].outcome == _loc98_.outcome && _loc89_[_loc14_ + 1].wave != _loc98_.wave)
                     {
                        _loc96_.isLastOfHisWave = true;
                     }
                     if(_loc98_.outcome == FightOutcomeEnum.RESULT_DEFENDER_GROUP)
                     {
                        _loc87_ = _loc96_;
                     }
                     else
                     {
                        if(_loc98_.outcome == FightOutcomeEnum.RESULT_VICTORY)
                        {
                           _loc88_.push(_loc96_);
                        }
                        _loc109_ = _loc86_++;
                        _loc85_[_loc109_] = _loc96_;
                     }
                     if(_loc96_.id == PlayedCharacterManager.getInstance().id)
                     {
                        switch(_loc98_.outcome)
                        {
                           case FightOutcomeEnum.RESULT_VICTORY:
                              KernelEventsManager.getInstance().processCallback(TriggerHookList.FightResultVictory);
                              SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_FIGHT_WON);
                              break;
                           case FightOutcomeEnum.RESULT_LOST:
                              SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_FIGHT_LOST);
                        }
                        if(_loc96_.rewards.objects.length >= SpeakingItemManager.GREAT_DROP_LIMIT)
                        {
                           SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_GREAT_DROP);
                        }
                     }
                     _loc14_++;
                  }
                  if(_loc87_)
                  {
                     _loc99_ = 0;
                     for each(_loc100_ in _loc87_.rewards.objects)
                     {
                        _loc88_[_loc99_].rewards.objects.push(_loc100_);
                        _loc99_ = ++_loc99_ % _loc88_.length;
                     }
                     _loc102_ = (_loc101_ = _loc87_.rewards.kamas) / _loc88_.length;
                     if(_loc101_ % _loc88_.length != 0)
                     {
                        _loc102_++;
                     }
                     for each(_loc103_ in _loc88_)
                     {
                        if(_loc101_ < _loc102_)
                        {
                           _loc103_.rewards.kamas = _loc101_;
                        }
                        else
                        {
                           _loc103_.rewards.kamas = _loc102_;
                        }
                        _loc101_ = _loc101_ - _loc103_.rewards.kamas;
                     }
                  }
                  _loc91_ = "";
                  _loc92_ = "";
                  for each(_loc93_ in _loc58_.namedPartyTeamsOutcomes)
                  {
                     if(_loc93_.team.partyName && _loc93_.team.partyName != "")
                     {
                        if(_loc93_.outcome == FightOutcomeEnum.RESULT_VICTORY)
                        {
                           _loc91_ = _loc93_.team.partyName;
                        }
                        else if(_loc93_.outcome == FightOutcomeEnum.RESULT_LOST)
                        {
                           _loc92_ = _loc93_.team.partyName;
                        }
                     }
                  }
                  (_loc94_ = new Object()).results = _loc85_;
                  _loc94_.ageBonus = _loc58_.ageBonus;
                  _loc94_.sizeMalus = _loc58_.lootShareLimitMalus;
                  _loc94_.duration = _loc58_.duration;
                  _loc94_.challenges = this.challengesList;
                  _loc94_.turns = this._battleFrame.turnsCount;
                  _loc94_.fightType = this._fightType;
                  _loc94_.winnersName = _loc91_;
                  _loc94_.losersName = _loc92_;
                  _loc95_ = new Vector.<uint>();
                  if(this._fightIdols)
                  {
                     _loc104_ = this._fightIdols.length;
                     _loc105_ = 0;
                     while(_loc105_ < _loc104_)
                     {
                        _loc95_.push(this._fightIdols[_loc105_].id);
                        _loc105_++;
                     }
                  }
                  _loc94_.idols = _loc95_;
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightEnd,_loc94_);
               }
               Kernel.getWorker().removeFrame(this);
               return true;
            case param1 is ChallengeTargetsListRequestAction:
               _loc59_ = param1 as ChallengeTargetsListRequestAction;
               (_loc60_ = new ChallengeTargetsListRequestMessage()).initChallengeTargetsListRequestMessage(_loc59_.challengeId);
               ConnectionsHandler.getConnection().send(_loc60_);
               return true;
            case param1 is ChallengeTargetsListMessage:
               _loc61_ = param1 as ChallengeTargetsListMessage;
               for each(_loc106_ in _loc61_.targetCells)
               {
                  if(_loc106_ != -1)
                  {
                     HyperlinkShowCellManager.showCell(_loc106_);
                  }
               }
               return true;
            case param1 is ChallengeInfoMessage:
               _loc62_ = param1 as ChallengeInfoMessage;
               if(!(_loc63_ = this.getChallengeById(_loc62_.challengeId)))
               {
                  _loc63_ = new ChallengeWrapper();
                  this.challengesList.push(_loc63_);
               }
               _loc63_.id = _loc62_.challengeId;
               _loc63_.targetId = _loc62_.targetId;
               _loc63_.xpBonus = _loc62_.xpBonus;
               _loc63_.dropBonus = _loc62_.dropBonus;
               _loc63_.result = 0;
               KernelEventsManager.getInstance().processCallback(FightHookList.ChallengeInfoUpdate,this.challengesList);
               return true;
            case param1 is ChallengeTargetUpdateMessage:
               _loc64_ = param1 as ChallengeTargetUpdateMessage;
               if((_loc63_ = this.getChallengeById(_loc64_.challengeId)) == null)
               {
                  _log.warn("Got a challenge result with no corresponding challenge (challenge id " + _loc64_.challengeId + "), skipping.");
                  return false;
               }
               _loc63_.targetId = _loc64_.targetId;
               KernelEventsManager.getInstance().processCallback(FightHookList.ChallengeInfoUpdate,this.challengesList);
               return true;
               break;
            case param1 is ChallengeResultMessage:
               _loc65_ = param1 as ChallengeResultMessage;
               if(!(_loc63_ = this.getChallengeById(_loc65_.challengeId)))
               {
                  _log.warn("Got a challenge result with no corresponding challenge (challenge id " + _loc65_.challengeId + "), skipping.");
                  return false;
               }
               _loc63_.result = !!_loc65_.success?uint(1):uint(2);
               KernelEventsManager.getInstance().processCallback(FightHookList.ChallengeInfoUpdate,this.challengesList);
               return true;
               break;
            case param1 is MapObstacleUpdateMessage:
               _loc66_ = param1 as MapObstacleUpdateMessage;
               for each(_loc107_ in _loc66_.obstacles)
               {
                  InteractiveCellManager.getInstance().updateCell(_loc107_.obstacleCellId,_loc107_.state == MapObstacleStateEnum.OBSTACLE_OPENED);
               }
               return true;
            case param1 is GameActionFightNoSpellCastMessage:
               if((_loc67_ = param1 as GameActionFightNoSpellCastMessage).spellLevelId != 0 || !PlayedCharacterManager.getInstance().currentWeapon)
               {
                  if(_loc67_.spellLevelId == 0)
                  {
                     _loc108_ = Spell.getSpellById(0).getSpellLevel(1);
                  }
                  else
                  {
                     _loc108_ = SpellLevel.getLevelById(_loc67_.spellLevelId);
                  }
                  _loc68_ = _loc108_.apCost;
               }
               else
               {
                  _loc68_ = PlayedCharacterManager.getInstance().currentWeapon.apCost;
               }
               CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent + _loc68_;
               return true;
            case param1 is ShowTacticModeAction:
               if(PlayedCharacterApi.isInPreFight())
               {
                  return false;
               }
               if(PlayedCharacterApi.isInFight() || PlayedCharacterManager.getInstance().isSpectator)
               {
                  this.tacticModeHandler(true);
               }
               return true;
               break;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         if(TacticModeManager.getInstance().tacticModeActivated)
         {
            TacticModeManager.getInstance().hide(true);
         }
         if(this._entitiesFrame)
         {
            Kernel.getWorker().removeFrame(this._entitiesFrame);
         }
         if(this._preparationFrame)
         {
            Kernel.getWorker().removeFrame(this._preparationFrame);
         }
         if(this._battleFrame)
         {
            Kernel.getWorker().removeFrame(this._battleFrame);
         }
         if(this._pointCellFrame)
         {
            Kernel.getWorker().removeFrame(this._pointCellFrame);
         }
         SerialSequencer.clearByType(FightSequenceFrame.FIGHT_SEQUENCERS_CATEGORY);
         this._preparationFrame = null;
         this._battleFrame = null;
         this._pointCellFrame = null;
         this._lastEffectEntity = null;
         TooltipManager.hideAll();
         this._timerFighterInfo.reset();
         this._timerFighterInfo.removeEventListener(TimerEvent.TIMER,this.showFighterInfo);
         this._timerFighterInfo = null;
         this._timerMovementRange.reset();
         this._timerMovementRange.removeEventListener(TimerEvent.TIMER,this.showMovementRange);
         this._timerMovementRange = null;
         this._currentFighterInfo = null;
         if(MapDisplayManager.getInstance().getDataMapContainer())
         {
            MapDisplayManager.getInstance().getDataMapContainer().setTemporaryAnimatedElementState(true);
         }
         Atouin.getInstance().displayGrid(false);
         OptionManager.getOptionManager("dofus").removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         Berilia.getInstance().removeEventListener(UiUnloadEvent.UNLOAD_UI_COMPLETE,this.onUiUnloaded);
         if(this._hideTooltipsTimer)
         {
            this._hideTooltipsTimer.removeEventListener(TimerEvent.TIMER,this.onShowPermanentTooltips);
            this._hideTooltipsTimer.stop();
         }
         if(this._hideTooltipTimer)
         {
            this._hideTooltipTimer.removeEventListener(TimerEvent.TIMER,this.onShowTooltip);
            this._hideTooltipTimer.stop();
         }
         var _loc1_:SpellInventoryManagementFrame = Kernel.getWorker().getFrame(SpellInventoryManagementFrame) as SpellInventoryManagementFrame;
         _loc1_.deleteSpellsGlobalCoolDownsData();
         PlayedCharacterManager.getInstance().isSpectator = false;
         return true;
      }
      
      public function outEntity(param1:int) : void
      {
         var _loc2_:int = 0;
         this._timerFighterInfo.reset();
         this._timerMovementRange.reset();
         var _loc3_:Vector.<int> = this._entitiesFrame.getEntitiesIdsList();
         fighterEntityTooltipId = param1;
         var _loc4_:IEntity;
         if(!(_loc4_ = DofusEntities.getEntity(fighterEntityTooltipId)))
         {
            if(_loc3_.indexOf(fighterEntityTooltipId) == -1)
            {
               _log.warn("Mouse over an unknown entity : " + param1);
               return;
            }
         }
         if(this._lastEffectEntity && this._lastEffectEntity.object)
         {
            Sprite(this._lastEffectEntity.object).filters = [];
         }
         this._lastEffectEntity = null;
         var _loc5_:String = "tooltipOverEntity_" + param1;
         if((!this._showPermanentTooltips || this._showPermanentTooltips && this.battleFrame.targetedEntities.indexOf(param1) == -1) && TooltipManager.isVisible(_loc5_))
         {
            TooltipManager.hide(_loc5_);
         }
         if(this._showPermanentTooltips)
         {
            for each(_loc2_ in this.battleFrame.targetedEntities)
            {
               this.displayEntityTooltip(_loc2_);
            }
         }
         if(_loc4_ != null)
         {
            Sprite(_loc4_).filters = [];
         }
         this.hideMovementRange();
         var _loc6_:Selection;
         if(_loc6_ = SelectionManager.getInstance().getSelection(this.INVISIBLE_POSITION_SELECTION))
         {
            _loc6_.remove();
         }
         this.removeAsLinkEntityEffect();
         if(this._currentFighterInfo && this._currentFighterInfo.contextualId == param1)
         {
            KernelEventsManager.getInstance().processCallback(FightHookList.FighterInfoUpdate,null);
            if(PlayedCharacterManager.getInstance().isSpectator && OptionManager.getOptionManager("dofus")["spectatorAutoShowCurrentFighterInfo"] == true)
            {
               KernelEventsManager.getInstance().processCallback(FightHookList.FighterInfoUpdate,FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._battleFrame.currentPlayerId) as GameFightFighterInformations);
            }
         }
         var _loc7_:FightPreparationFrame;
         if(_loc7_ = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame)
         {
            _loc7_.updateSwapPositionRequestsIcons();
         }
      }
      
      public function removeSpellTargetsTooltips() : void
      {
         var _loc1_:* = undefined;
         PushUtil.reset();
         this._spellAlreadyTriggered = false;
         for(_loc1_ in this._spellTargetsTooltips)
         {
            TooltipPlacer.removeTooltipPositionByName("tooltip_tooltipOverEntity_" + _loc1_);
            delete this._spellTargetsTooltips[_loc1_];
            TooltipManager.hide("tooltipOverEntity_" + _loc1_);
            delete this._spellDamages[_loc1_];
            if(this._showPermanentTooltips && this._battleFrame.targetedEntities.indexOf(_loc1_) != -1)
            {
               this.displayEntityTooltip(_loc1_);
            }
         }
      }
      
      public function displayEntityTooltip(param1:int, param2:Object = null, param3:SpellDamageInfo = null, param4:Boolean = false, param5:int = -1, param6:Object = null) : void
      {
         var _loc7_:Boolean = false;
         var _loc8_:AnimatedCharacter = null;
         var _loc9_:SpellDamageInfo = null;
         var _loc10_:SpellDamage = null;
         var _loc11_:EffectDamage = null;
         var _loc12_:IZone = null;
         var _loc13_:Vector.<uint> = null;
         var _loc14_:int = 0;
         var _loc15_:SpellWrapper = null;
         var _loc16_:uint = 0;
         var _loc17_:PushedEntity = null;
         var _loc18_:int = 0;
         var _loc19_:* = false;
         var _loc20_:SpellDamageInfo = null;
         var _loc21_:Boolean = false;
         var _loc22_:TriggeredSpell = null;
         var _loc23_:Boolean = false;
         var _loc24_:Vector.<TriggeredSpell> = null;
         var _loc25_:Vector.<TriggeredSpell> = null;
         var _loc26_:Vector.<int> = null;
         var _loc27_:int = 0;
         var _loc28_:Number = NaN;
         var _loc29_:SpellDamage = null;
         var _loc30_:SpellDamage = null;
         var _loc31_:EffectDamage = null;
         var _loc32_:Vector.<int> = null;
         var _loc33_:Vector.<SplashDamage> = null;
         var _loc34_:Boolean = false;
         var _loc35_:SplashDamage = null;
         var _loc36_:SpellDamageInfo = null;
         var _loc37_:* = undefined;
         var _loc38_:int = 0;
         var _loc39_:Object = null;
         var _loc40_:Boolean = false;
         var _loc41_:SpellDamage = null;
         var _loc42_:Vector.<SpellDamage> = null;
         var _loc43_:int = 0;
         var _loc44_:int = 0;
         var _loc45_:IDisplayable = DofusEntities.getEntity(param1) as IDisplayable;
         var _loc46_:GameFightFighterInformations = this._entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
         if(!_loc45_ || !_loc46_ || this._battleFrame.targetedEntities.indexOf(param1) != -1 && this._hideTooltips)
         {
            return;
         }
         var _loc47_:Object = param6;
         if(_loc46_.disposition.cellId != currentCell && !(this._timelineOverEntity && param1 == this.timelineOverEntityId))
         {
            if(!_loc47_)
            {
               _loc47_ = new Object();
            }
            _loc47_.showName = false;
         }
         var _loc48_:uint = param5 != -1?uint(param5):uint(currentCell);
         if(param2 && !param3)
         {
            _loc8_ = _loc45_ as AnimatedCharacter;
            _loc7_ = param2 && DamageUtil.isDamagedOrHealedBySpell(CurrentPlayedFighterManager.getInstance().currentFighterId,param1,param2,_loc48_);
            if(_loc8_ && _loc8_.parentSprite && _loc8_.parentSprite.carriedEntity == _loc8_ && !_loc7_)
            {
               TooltipPlacer.removeTooltipPositionByName("tooltip_tooltipOverEntity_" + param1);
               return;
            }
         }
         var _loc49_:Boolean;
         if(_loc49_ = param2 && OptionManager.getOptionManager("dofus")["showDamagesPreview"] == true && FightSpellCastFrame.isCurrentTargetTargetable())
         {
            if(!param4 && this._spellTargetsTooltips[param1])
            {
               return;
            }
            _loc13_ = (_loc12_ = SpellZoneManager.getInstance().getSpellZone(param2)).getCells(_loc48_);
            if(!param3)
            {
               if(_loc7_)
               {
                  if(DamageUtil.BOMB_SPELLS_IDS.indexOf(param2.id) != -1)
                  {
                     _loc15_ = DamageUtil.getBombDirectDamageSpellWrapper(param2 as SpellWrapper);
                     _loc9_ = SpellDamageInfo.fromCurrentPlayer(_loc15_,param1,_loc48_);
                     for each(_loc14_ in _loc9_.originalTargetsIds)
                     {
                        this.displayEntityTooltip(_loc14_,_loc15_,_loc9_);
                     }
                     return;
                  }
                  _loc9_ = SpellDamageInfo.fromCurrentPlayer(param2,param1,_loc48_);
                  if(param2 is SpellWrapper)
                  {
                     _loc9_.pushedEntities = PushUtil.getPushedEntities(param2 as SpellWrapper,this.entitiesFrame.getEntityInfos(param2.playerId).disposition.cellId,_loc48_);
                     if((_loc16_ = !!_loc9_.pushedEntities?uint(_loc9_.pushedEntities.length):uint(0)) > 0)
                     {
                        _loc18_ = 0;
                        while(_loc18_ < _loc16_)
                        {
                           _loc17_ = _loc9_.pushedEntities[_loc18_];
                           if(!_loc19_)
                           {
                              _loc19_ = param1 == _loc17_.id;
                           }
                           if(_loc17_.id == param1)
                           {
                              this.displayEntityTooltip(_loc17_.id,param2,_loc9_,true);
                           }
                           else
                           {
                              (_loc20_ = SpellDamageInfo.fromCurrentPlayer(param2,_loc17_.id,_loc48_)).pushedEntities = _loc9_.pushedEntities;
                              this.displayEntityTooltip(_loc17_.id,param2,_loc20_,true);
                           }
                           _loc18_++;
                        }
                        if(_loc19_)
                        {
                           return;
                        }
                     }
                  }
               }
            }
            else
            {
               _loc9_ = param3;
            }
            this._spellTargetsTooltips[param1] = true;
            if(_loc9_)
            {
               if(!_loc47_)
               {
                  _loc47_ = new Object();
               }
               if(_loc9_.targetId != param1)
               {
                  _loc9_.targetId = param1;
               }
               if(!_loc9_.damageSharingTargets)
               {
                  _loc26_ = _loc9_.getDamageSharingTargets();
                  _loc9_.damageSharingTargets = _loc26_;
                  if(_loc26_ && _loc26_.length > 1)
                  {
                     _loc28_ = 1 / _loc26_.length;
                     _loc29_ = new SpellDamage();
                     for each(_loc27_ in _loc9_.originalTargetsIds)
                     {
                        _loc9_.targetId = _loc27_;
                        _loc30_ = DamageUtil.getSpellDamage(_loc9_);
                        for each(_loc31_ in _loc30_.effectDamages)
                        {
                           _loc31_.applyDamageMultiplier(_loc28_);
                           _loc29_.addEffectDamage(_loc31_);
                        }
                     }
                     _loc29_.updateDamage();
                     _loc9_.sharedDamage = _loc29_;
                     for each(_loc14_ in _loc26_)
                     {
                        _loc21_ = !this._spellDamages[_loc14_] && _loc13_.indexOf(this.entitiesFrame.getEntityInfos(_loc14_).disposition.cellId) != -1;
                        this.displayEntityTooltip(_loc14_,param2,_loc9_,true);
                        if(_loc21_)
                        {
                           this._spellTargetsTooltips[_loc14_] = false;
                        }
                     }
                     return;
                  }
               }
               _loc24_ = !!(_loc23_ = Boolean(!_loc9_.damageSharingTargets || _loc9_.damageSharingTargets.indexOf(param1) != -1 && _loc9_.originalTargetsIds.indexOf(param1) != -1))?_loc9_.triggeredSpellsByCasterOnTarget:null;
               if(!this._spellAlreadyTriggered && _loc24_)
               {
                  for each(_loc22_ in _loc24_)
                  {
                     if(_loc22_.triggers != "I")
                     {
                        this._spellAlreadyTriggered = true;
                     }
                     for each(_loc14_ in _loc22_.targets)
                     {
                        _loc21_ = !this._spellDamages[_loc14_] && _loc13_.indexOf(this.entitiesFrame.getEntityInfos(_loc14_).disposition.cellId) != -1;
                        this.displayEntityTooltip(_loc14_,_loc22_.spell,null,true,this.entitiesFrame.getEntityInfos(_loc22_.targetId).disposition.cellId);
                        if(_loc21_)
                        {
                           this._spellTargetsTooltips[_loc14_] = false;
                        }
                     }
                  }
               }
               _loc25_ = !!_loc23_?_loc9_.targetTriggeredSpells:null;
               if(!this._spellAlreadyTriggered && _loc25_)
               {
                  if(_loc33_ = DamageUtil.getSplashDamages(_loc25_,_loc9_))
                  {
                     if(!_loc9_.splashDamages)
                     {
                        _loc9_.splashDamages = new Vector.<SplashDamage>(0);
                     }
                     for each(_loc35_ in _loc33_)
                     {
                        _loc9_.splashDamages.push(_loc35_);
                        if(!_loc32_)
                        {
                           _loc32_ = new Vector.<int>(0);
                        }
                        for each(_loc14_ in _loc35_.targets)
                        {
                           if(_loc32_.indexOf(_loc14_) == -1)
                           {
                              _loc32_.push(_loc14_);
                           }
                        }
                     }
                  }
                  if((_loc34_ = _loc9_.addTriggeredSpellsEffects(_loc25_)) && !_loc32_)
                  {
                     _loc32_ = new Vector.<int>(0);
                  }
                  if(_loc32_)
                  {
                     for each(_loc22_ in _loc25_)
                     {
                        if(_loc22_.triggers != "I")
                        {
                           this._spellAlreadyTriggered = true;
                           break;
                        }
                     }
                     if(_loc32_.indexOf(param1) == -1)
                     {
                        _loc32_.push(param1);
                     }
                     for each(_loc14_ in _loc32_)
                     {
                        this.displayEntityTooltip(_loc14_,param2,_loc9_,true);
                     }
                     return;
                  }
               }
               if(_loc9_.originalTargetsIds.indexOf(_loc9_.casterId) == -1 && !this._spellTargetsTooltips[_loc9_.casterId])
               {
                  (_loc36_ = SpellDamageInfo.fromCurrentPlayer(param2,_loc9_.casterId,_loc48_)).reflectDamage = _loc9_.getReflectDamage();
                  if(_loc36_.reflectDamage.effectDamages.length > 0)
                  {
                     this.displayEntityTooltip(_loc9_.casterId,param2,_loc36_);
                  }
               }
               _loc10_ = DamageUtil.getSpellDamage(_loc9_);
            }
            if(_loc10_)
            {
               if(!this._spellDamages[param1])
               {
                  this._spellDamages[param1] = new Array();
               }
               for each(_loc39_ in this._spellDamages[param1])
               {
                  if(_loc39_.spellId == param2.id)
                  {
                     _loc38_++;
                     if(!_loc9_.damageSharingTargets)
                     {
                        break;
                     }
                  }
               }
               if(_loc38_ == 0 || _loc9_.damageSharingTargets && _loc38_ + 1 < _loc9_.originalTargetsIds.length)
               {
                  this._spellDamages[param1].push({
                     "spellId":param2.id,
                     "spellDamage":_loc10_
                  });
               }
               if(this._spellDamages[param1].length > 1)
               {
                  if(_loc40_ = true)
                  {
                     _loc37_ = new SpellDamage();
                     for each(_loc39_ in this._spellDamages[param1])
                     {
                        _loc41_ = _loc39_.spellDamage;
                        for each(_loc11_ in _loc41_.effectDamages)
                        {
                           _loc37_.addEffectDamage(_loc11_);
                        }
                        if(_loc41_.invulnerableState)
                        {
                           _loc37_.invulnerableState = true;
                        }
                        if(_loc41_.unhealableState)
                        {
                           _loc37_.unhealableState = true;
                        }
                        if(_loc41_.hasCriticalDamage)
                        {
                           _loc37_.hasCriticalDamage = true;
                        }
                        if(_loc41_.hasCriticalShieldPointsRemoved)
                        {
                           _loc37_.hasCriticalShieldPointsRemoved = true;
                        }
                        if(_loc41_.hasCriticalLifePointsAdded)
                        {
                           _loc37_.hasCriticalLifePointsAdded = true;
                        }
                        if(_loc41_.isHealingSpell)
                        {
                           _loc37_.isHealingSpell = true;
                        }
                        if(_loc41_.hasHeal)
                        {
                           _loc37_.hasHeal = true;
                        }
                     }
                     _loc37_.updateDamage();
                  }
                  else
                  {
                     _loc42_ = new Vector.<SpellDamage>(0);
                     _loc44_ = this._spellDamages[param1].length;
                     _loc43_ = 0;
                     while(_loc43_ < _loc44_)
                     {
                        _loc42_.push(this._spellDamages[param1][_loc43_].spellDamage);
                        _loc43_++;
                     }
                     _loc37_ = new SpellDamageList(_loc42_);
                  }
               }
               else
               {
                  _loc37_ = _loc10_;
               }
               _loc47_.spellDamage = _loc37_;
            }
         }
         if(_loc46_.disposition.cellId == -1)
         {
            return;
         }
         var _loc50_:IRectangle = _loc47_ && _loc47_.target?_loc47_.target:_loc45_.absoluteBounds;
         if(_loc46_ is GameFightCharacterInformations)
         {
            TooltipManager.show(_loc46_,_loc50_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"tooltipOverEntity_" + _loc46_.contextualId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,null,_loc47_,"PlayerShortInfos" + _loc46_.contextualId,false,StrataEnum.STRATA_WORLD);
         }
         else if(_loc46_ is GameFightCompanionInformations)
         {
            TooltipManager.show(_loc46_,_loc50_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"tooltipOverEntity_" + _loc46_.contextualId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,"companionFighter",null,_loc47_,"EntityShortInfos" + _loc46_.contextualId);
         }
         else
         {
            TooltipManager.show(_loc46_,_loc50_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"tooltipOverEntity_" + _loc46_.contextualId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,"monsterFighter",null,_loc47_,"EntityShortInfos" + _loc46_.contextualId,false,StrataEnum.STRATA_WORLD);
         }
         var _loc51_:FightPreparationFrame;
         if(_loc51_ = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame)
         {
            _loc51_.updateSwapPositionRequestsIcons();
         }
      }
      
      public function hideEntityTooltip(param1:int, param2:uint) : void
      {
         if(!(this._showPermanentTooltips && this._battleFrame.targetedEntities.indexOf(param1) != -1) && TooltipManager.isVisible("tooltipOverEntity_" + param1))
         {
            TooltipManager.hide("tooltipOverEntity_" + param1);
            this._hideTooltipEntityId = param1;
            if(!this._hideTooltipTimer)
            {
               this._hideTooltipTimer = new Timer(param2);
            }
            this._hideTooltipTimer.stop();
            this._hideTooltipTimer.delay = param2;
            this._hideTooltipTimer.removeEventListener(TimerEvent.TIMER,this.onShowTooltip);
            this._hideTooltipTimer.addEventListener(TimerEvent.TIMER,this.onShowTooltip);
            this._hideTooltipTimer.start();
         }
      }
      
      public function hidePermanentTooltips(param1:uint) : void
      {
         var _loc2_:int = 0;
         this._hideTooltips = true;
         if(this._battleFrame.targetedEntities.length > 0)
         {
            for each(_loc2_ in this._battleFrame.targetedEntities)
            {
               TooltipManager.hide("tooltipOverEntity_" + _loc2_);
            }
            if(!this._hideTooltipsTimer)
            {
               this._hideTooltipsTimer = new Timer(param1);
            }
            this._hideTooltipsTimer.stop();
            this._hideTooltipsTimer.delay = param1;
            this._hideTooltipsTimer.removeEventListener(TimerEvent.TIMER,this.onShowPermanentTooltips);
            this._hideTooltipsTimer.addEventListener(TimerEvent.TIMER,this.onShowPermanentTooltips);
            this._hideTooltipsTimer.start();
         }
      }
      
      public function getFighterPreviousPosition(param1:int) : int
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         if(this._fightersPositionsHistory[param1])
         {
            _loc3_ = this._fightersPositionsHistory[param1];
            _loc2_ = _loc3_.length > 0?_loc3_[_loc3_.length - 1]:null;
         }
         return !!_loc2_?int(_loc2_.cellId):-1;
      }
      
      public function deleteFighterPreviousPosition(param1:int) : void
      {
         if(this._fightersPositionsHistory[param1])
         {
            this._fightersPositionsHistory[param1].pop();
         }
      }
      
      public function saveFighterPosition(param1:int, param2:uint) : void
      {
         if(!this._fightersPositionsHistory[param1])
         {
            this._fightersPositionsHistory[param1] = new Array();
         }
         this._fightersPositionsHistory[param1].push({
            "cellId":param2,
            "lives":2
         });
      }
      
      public function refreshTimelineOverEntityInfos() : void
      {
         var _loc1_:IEntity = null;
         if(this._timelineOverEntity && this._timelineOverEntityId)
         {
            _loc1_ = DofusEntities.getEntity(this._timelineOverEntityId);
            if(_loc1_ && _loc1_.position)
            {
               FightContextFrame.currentCell = _loc1_.position.cellId;
               this.overEntity(this._timelineOverEntityId);
            }
         }
      }
      
      private function getFighterInfos(param1:int) : GameFightFighterInformations
      {
         return this.entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
      }
      
      private function showFighterInfo(param1:TimerEvent) : void
      {
         this._timerFighterInfo.reset();
         KernelEventsManager.getInstance().processCallback(FightHookList.FighterInfoUpdate,this._currentFighterInfo);
      }
      
      private function showMovementRange(param1:TimerEvent) : void
      {
         this._timerMovementRange.reset();
         this._reachableRangeSelection = new Selection();
         this._reachableRangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
         this._reachableRangeSelection.color = new Color(52326);
         this._unreachableRangeSelection = new Selection();
         this._unreachableRangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
         this._unreachableRangeSelection.color = new Color(6684672);
         var _loc2_:FightReachableCellsMaker = new FightReachableCellsMaker(this._currentFighterInfo);
         this._reachableRangeSelection.zone = new Custom(_loc2_.reachableCells);
         this._unreachableRangeSelection.zone = new Custom(_loc2_.unreachableCells);
         SelectionManager.getInstance().addSelection(this._reachableRangeSelection,"movementReachableRange",this._currentFighterInfo.disposition.cellId);
         SelectionManager.getInstance().addSelection(this._unreachableRangeSelection,"movementUnreachableRange",this._currentFighterInfo.disposition.cellId);
      }
      
      private function hideMovementRange() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection("movementReachableRange");
         if(_loc1_)
         {
            _loc1_.remove();
            this._reachableRangeSelection = null;
         }
         _loc1_ = SelectionManager.getInstance().getSelection("movementUnreachableRange");
         if(_loc1_)
         {
            _loc1_.remove();
            this._unreachableRangeSelection = null;
         }
      }
      
      private function addMarks(param1:Vector.<GameActionMark>) : void
      {
         var _loc2_:GameActionMark = null;
         var _loc3_:Spell = null;
         var _loc4_:AddGlyphGfxStep = null;
         var _loc5_:GameActionMarkedCell = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = Spell.getSpellById(_loc2_.markSpellId);
            if(_loc2_.markType == GameActionMarkTypeEnum.WALL)
            {
               if(_loc3_.getParamByName("glyphGfxId"))
               {
                  for each(_loc5_ in _loc2_.cells)
                  {
                     (_loc4_ = new AddGlyphGfxStep(_loc3_.getParamByName("glyphGfxId"),_loc5_.cellId,_loc2_.markId,_loc2_.markType,_loc2_.markTeamId,_loc2_.active)).start();
                  }
               }
            }
            else if(_loc3_.getParamByName("glyphGfxId") && !MarkedCellsManager.getInstance().getGlyph(_loc2_.markId) && _loc2_.markimpactCell != -1)
            {
               (_loc4_ = new AddGlyphGfxStep(_loc3_.getParamByName("glyphGfxId"),_loc2_.markimpactCell,_loc2_.markId,_loc2_.markType,_loc2_.markTeamId,_loc2_.active)).start();
            }
            MarkedCellsManager.getInstance().addMark(_loc2_.markId,_loc2_.markType,_loc3_,_loc3_.getSpellLevel(_loc2_.markSpellLevel),_loc2_.cells,_loc2_.markTeamId,_loc2_.active,_loc2_.markimpactCell);
         }
      }
      
      private function removeAsLinkEntityEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         for each(_loc1_ in this._entitiesFrame.getEntitiesIdsList())
         {
            _loc2_ = DofusEntities.getEntity(_loc1_) as DisplayObject;
            if(_loc2_ && _loc2_.filters && _loc2_.filters.length)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.filters.length)
               {
                  if(_loc2_.filters[_loc3_] is ColorMatrixFilter)
                  {
                     _loc2_.filters = _loc2_.filters.splice(_loc3_,_loc3_);
                     break;
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      private function highlightAsLinkedEntity(param1:int, param2:Boolean) : void
      {
         var _loc3_:ColorMatrixFilter = null;
         var _loc4_:IEntity;
         if(!(_loc4_ = DofusEntities.getEntity(param1)))
         {
            return;
         }
         var _loc5_:Sprite;
         if(_loc5_ = _loc4_ as Sprite)
         {
            _loc3_ = !!param2?this._linkedMainEffect:this._linkedEffect;
            if(_loc5_.filters.length)
            {
               if(_loc5_.filters[0] != _loc3_)
               {
                  _loc5_.filters = [_loc3_];
               }
            }
            else
            {
               _loc5_.filters = [_loc3_];
            }
         }
      }
      
      private function overEntity(param1:int, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc4_:int = 0;
         var _loc5_:* = false;
         var _loc6_:GameFightFighterInformations = null;
         var _loc7_:Selection = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:FightReachableCellsMaker = null;
         var _loc11_:GlowFilter = null;
         var _loc12_:FightTurnFrame = null;
         var _loc13_:Boolean = false;
         var _loc19_:Object = null;
         var _loc14_:Vector.<int> = this._entitiesFrame.getEntitiesIdsList();
         fighterEntityTooltipId = param1;
         var _loc15_:IEntity;
         if(!(_loc15_ = DofusEntities.getEntity(fighterEntityTooltipId)))
         {
            if(_loc14_.indexOf(fighterEntityTooltipId) == -1)
            {
               _log.warn("Mouse over an unknown entity : " + param1);
               return;
            }
            param2 = false;
         }
         var _loc16_:GameFightFighterInformations;
         if(!(_loc16_ = this._entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations))
         {
            _log.warn("Mouse over an unknown entity : " + param1);
            return;
         }
         var _loc17_:int = _loc16_.stats.summoner;
         if(_loc16_ is GameFightCompanionInformations)
         {
            _loc17_ = (_loc16_ as GameFightCompanionInformations).masterId;
         }
         for each(_loc4_ in _loc14_)
         {
            if(_loc4_ != param1)
            {
               if((_loc6_ = this._entitiesFrame.getEntityInfos(_loc4_) as GameFightFighterInformations).stats.summoner == param1 || _loc17_ == _loc4_ || _loc6_.stats.summoner == _loc17_ && _loc17_ || _loc6_ is GameFightCompanionInformations && (_loc6_ as GameFightCompanionInformations).masterId == param1)
               {
                  this.highlightAsLinkedEntity(_loc4_,_loc17_ == _loc4_);
               }
            }
         }
         this._currentFighterInfo = _loc16_;
         _loc5_ = true;
         if(PlayedCharacterManager.getInstance().isSpectator && OptionManager.getOptionManager("dofus")["spectatorAutoShowCurrentFighterInfo"] == true)
         {
            _loc5_ = this._battleFrame.currentPlayerId != param1;
         }
         if(_loc5_ && param3)
         {
            this._timerFighterInfo.reset();
            this._timerFighterInfo.start();
         }
         if(_loc16_.stats.invisibilityState == GameActionFightInvisibilityStateEnum.INVISIBLE)
         {
            _log.info("Mouse over an invisible entity in timeline");
            if(!(_loc7_ = SelectionManager.getInstance().getSelection(this.INVISIBLE_POSITION_SELECTION)))
            {
               (_loc7_ = new Selection()).color = new Color(52326);
               _loc7_.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
               SelectionManager.getInstance().addSelection(_loc7_,this.INVISIBLE_POSITION_SELECTION);
            }
            if((_loc8_ = FightEntitiesFrame.getCurrentInstance().getLastKnownEntityPosition(_loc16_.contextualId)) > -1)
            {
               _loc9_ = FightEntitiesFrame.getCurrentInstance().getLastKnownEntityMovementPoint(_loc16_.contextualId);
               _loc10_ = new FightReachableCellsMaker(this._currentFighterInfo,_loc8_,_loc9_);
               _loc7_.zone = new Custom(_loc10_.reachableCells);
               SelectionManager.getInstance().update(this.INVISIBLE_POSITION_SELECTION,_loc8_);
            }
            return;
         }
         var _loc18_:FightSpellCastFrame;
         if((_loc18_ = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame) && (SelectionManager.getInstance().isInside(currentCell,"SpellCastTarget") || this._spellTargetsTooltips[param1]))
         {
            _loc19_ = _loc18_.currentSpell;
         }
         this.displayEntityTooltip(param1,_loc19_);
         var _loc20_:Selection;
         if(_loc20_ = SelectionManager.getInstance().getSelection(FightTurnFrame.SELECTION_PATH))
         {
            _loc20_.remove();
         }
         if(param2)
         {
            if(Kernel.getWorker().contains(FightBattleFrame) && !Kernel.getWorker().contains(FightSpellCastFrame))
            {
               this._timerMovementRange.reset();
               this._timerMovementRange.start();
            }
         }
         if(this._lastEffectEntity && this._lastEffectEntity.object is Sprite && this._lastEffectEntity.object != _loc15_)
         {
            Sprite(this._lastEffectEntity.object).filters = [];
         }
         var _loc21_:Sprite;
         if(_loc21_ = _loc15_ as Sprite)
         {
            _loc13_ = !!(_loc12_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame)?Boolean(_loc12_.myTurn):true;
            if((!_loc18_ || FightSpellCastFrame.isCurrentTargetTargetable()) && _loc13_)
            {
               _loc11_ = this._overEffectOk;
            }
            else
            {
               _loc11_ = this._overEffectKo;
            }
            if(_loc21_.filters.length)
            {
               if(_loc21_.filters[0] != _loc11_)
               {
                  _loc21_.filters = [_loc11_];
               }
            }
            else
            {
               _loc21_.filters = [_loc11_];
            }
            this._lastEffectEntity = new WeakReference(_loc15_);
         }
      }
      
      private function tacticModeHandler(param1:Boolean = false) : void
      {
         if(param1 && !TacticModeManager.getInstance().tacticModeActivated)
         {
            TacticModeManager.getInstance().show(PlayedCharacterManager.getInstance().currentMap);
         }
         else if(TacticModeManager.getInstance().tacticModeActivated)
         {
            TacticModeManager.getInstance().hide();
         }
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         switch(param1.propertyName)
         {
            case "showPermanentTargetsTooltips":
               this._showPermanentTooltips = param1.propertyValue as Boolean;
               for each(_loc2_ in this._battleFrame.targetedEntities)
               {
                  if(!this._showPermanentTooltips)
                  {
                     TooltipManager.hide("tooltipOverEntity_" + _loc2_);
                  }
                  else
                  {
                     this.displayEntityTooltip(_loc2_);
                  }
               }
               return;
            case "spectatorAutoShowCurrentFighterInfo":
               if(PlayedCharacterManager.getInstance().isSpectator)
               {
                  _loc3_ = param1.propertyValue as Boolean;
                  if(!_loc3_)
                  {
                     KernelEventsManager.getInstance().processCallback(FightHookList.FighterInfoUpdate,null);
                  }
                  else
                  {
                     KernelEventsManager.getInstance().processCallback(FightHookList.FighterInfoUpdate,FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._battleFrame.currentPlayerId) as GameFightFighterInformations);
                  }
               }
               return;
            default:
               return;
         }
      }
      
      private function onShowPermanentTooltips(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         this._hideTooltips = false;
         this._hideTooltipsTimer.removeEventListener(TimerEvent.TIMER,this.onShowPermanentTooltips);
         this._hideTooltipsTimer.stop();
         for each(_loc2_ in this._battleFrame.targetedEntities)
         {
            this.displayEntityTooltip(_loc2_);
         }
      }
      
      private function onShowTooltip(param1:TimerEvent) : void
      {
         this._hideTooltipTimer.removeEventListener(TimerEvent.TIMER,this.onShowTooltip);
         this._hideTooltipTimer.stop();
         var _loc2_:GameContextActorInformations = this._entitiesFrame.getEntityInfos(this._hideTooltipEntityId);
         if(_loc2_ && (_loc2_.disposition.cellId == currentCell || this.timelineOverEntity && this._hideTooltipEntityId == this.timelineOverEntityId))
         {
            this.displayEntityTooltip(this._hideTooltipEntityId);
         }
      }
   }
}
