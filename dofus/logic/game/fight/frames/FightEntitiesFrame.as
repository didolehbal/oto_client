package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.enum.UISoundEnum;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.common.frames.AbstractEntitiesFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.RemoveEntityAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ShowMountsInFightAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleDematerializationAction;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.CarrierAnimationModifier;
   import com.ankamagames.dofus.logic.game.fight.miscs.CustomAnimStatiqueAnimationModifier;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightEntitiesHolder;
   import com.ankamagames.dofus.logic.game.fight.steps.FightCarryCharacterStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightChangeVisibilityStep;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.utils.EmbedAssets;
   import com.ankamagames.dofus.misc.utils.LookCleaner;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.GameActionFightInvisibilityStateEnum;
   import com.ankamagames.dofus.network.enums.MapObstacleStateEnum;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCarryCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDropCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightThrowCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.character.status.PlayerStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRefreshEntityLookMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameEntitiesDispositionMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameEntityDispositionMessage;
   import com.ankamagames.dofus.network.messages.game.context.ShowCellMessage;
   import com.ankamagames.dofus.network.messages.game.context.ShowCellSpectatorMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightHumanReadyStateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementSwapPositionsMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightRefreshFighterMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterRandomStaticPoseMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataInHouseMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsWithCoordsMessage;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.FightEntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.IdentifiedEntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMinimalStatsPreparation;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.dofus.network.types.game.interactive.StatedElement;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   
   public class FightEntitiesFrame extends AbstractEntitiesFrame implements Frame
   {
      
      private static const TEAM_CIRCLE_COLOR_1:uint = 255;
      
      private static const TEAM_CIRCLE_COLOR_2:uint = 16711680;
       
      
      private var _showCellStart:Number = 0;
      
      private var arrowId:uint;
      
      private var _ie:Dictionary;
      
      private var _tempFighterList:Array;
      
      private var _illusionEntities:Dictionary;
      
      private var _entitiesNumber:Dictionary;
      
      private var _lastKnownPosition:Dictionary;
      
      private var _lastKnownMovementPoint:Dictionary;
      
      private var _lastKnownPlayerStatus:Dictionary;
      
      private var _realFightersLooks:Dictionary;
      
      private var _mountsVisible:Boolean;
      
      private var _numCreatureSwitchingEntities:int;
      
      public function FightEntitiesFrame()
      {
         this._ie = new Dictionary(true);
         this._tempFighterList = new Array();
         super();
      }
      
      public static function getCurrentInstance() : FightEntitiesFrame
      {
         return Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
      }
      
      override public function pushed() : Boolean
      {
         Atouin.getInstance().cellOverEnabled = true;
         Dofus.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         this._entitiesNumber = new Dictionary();
         this._illusionEntities = new Dictionary();
         this._lastKnownPosition = new Dictionary();
         this._lastKnownMovementPoint = new Dictionary();
         this._lastKnownPlayerStatus = new Dictionary();
         this._realFightersLooks = new Dictionary();
         _creaturesFightMode = OptionManager.getOptionManager("dofus")["creaturesFightMode"];
         this._mountsVisible = OptionManager.getOptionManager("dofus")["showMountsInFight"];
         return super.pushed();
      }
      
      override public function addOrUpdateActor(param1:GameContextActorInformations, param2:IAnimationModifier = null) : AnimatedCharacter
      {
         var _loc3_:AnimatedCharacter = super.addOrUpdateActor(param1,param2);
         if(param1.disposition.cellId != -1)
         {
            this.setLastKnownEntityPosition(param1.contextualId,param1.disposition.cellId);
         }
         if(param1.contextualId > 0)
         {
            _loc3_.disableMouseEventWhenAnimated = true;
         }
         if(CurrentPlayedFighterManager.getInstance().currentFighterId == param1.contextualId)
         {
            _loc3_.setCanSeeThrough(true);
         }
         if(param1 is GameFightCharacterInformations)
         {
            this._lastKnownPlayerStatus[param1.contextualId] = GameFightCharacterInformations(param1).status.statusId;
         }
         return _loc3_;
      }
      
      override public function process(param1:Message) : Boolean
      {
         var _loc2_:GameFightRefreshFighterMessage = null;
         var _loc3_:int = 0;
         var _loc4_:GameContextActorInformations = null;
         var _loc5_:GameFightShowFighterMessage = null;
         var _loc6_:FightContextFrame = null;
         var _loc7_:GameFightHumanReadyStateMessage = null;
         var _loc8_:AnimatedCharacter = null;
         var _loc9_:FightPreparationFrame = null;
         var _loc10_:GameEntityDispositionMessage = null;
         var _loc11_:GameFightPlacementSwapPositionsMessage = null;
         var _loc12_:IdentifiedEntityDispositionInformations = null;
         var _loc13_:GameEntitiesDispositionMessage = null;
         var _loc14_:GameContextRefreshEntityLookMessage = null;
         var _loc15_:TiphonSprite = null;
         var _loc16_:int = 0;
         var _loc17_:ShowCellSpectatorMessage = null;
         var _loc18_:String = null;
         var _loc19_:ShowCellMessage = null;
         var _loc20_:FightContextFrame = null;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:MapComplementaryInformationsDataMessage = null;
         var _loc24_:GameActionFightCarryCharacterMessage = null;
         var _loc25_:GameActionFightThrowCharacterMessage = null;
         var _loc26_:GameActionFightDropCharacterMessage = null;
         var _loc27_:PlayerStatusUpdateMessage = null;
         var _loc28_:ShowMountsInFightAction = null;
         var _loc29_:IAnimationModifier = null;
         var _loc30_:Sprite = null;
         var _loc31_:IdentifiedEntityDispositionInformations = null;
         var _loc32_:MapComplementaryInformationsWithCoordsMessage = null;
         var _loc33_:MapComplementaryInformationsDataInHouseMessage = null;
         var _loc34_:* = false;
         var _loc35_:MapObstacle = null;
         var _loc36_:InteractiveElement = null;
         var _loc37_:StatedElement = null;
         var _loc38_:GameFightFighterInformations = null;
         switch(true)
         {
            case param1 is GameFightRefreshFighterMessage:
               _loc2_ = param1 as GameFightRefreshFighterMessage;
               _loc3_ = _loc2_.informations.contextualId;
               if((_loc4_ = _entities[_loc3_]) != null)
               {
                  _loc4_.disposition = _loc2_.informations.disposition;
                  _loc4_.look = _loc2_.informations.look;
                  this._realFightersLooks[_loc2_.informations.contextualId] = _loc2_.informations.look;
                  this.updateActor(_loc4_,true);
               }
               if(Kernel.getWorker().getFrame(FightPreparationFrame))
               {
                  KernelEventsManager.getInstance().processCallback(FightHookList.UpdatePreFightersList,_loc3_);
                  if(Dofus.getInstance().options.orderFighters)
                  {
                     this.updateAllEntitiesNumber(this.getOrdonnedPreFighters());
                  }
               }
               return true;
            case param1 is GameFightShowFighterMessage:
               _loc5_ = param1 as GameFightShowFighterMessage;
               this._realFightersLooks[_loc5_.informations.contextualId] = _loc5_.informations.look;
               if(param1 is GameFightShowFighterRandomStaticPoseMessage)
               {
                  ((_loc29_ = new CustomAnimStatiqueAnimationModifier()) as CustomAnimStatiqueAnimationModifier).randomStatique = true;
                  this.updateFighter(_loc5_.informations,_loc29_);
                  this._illusionEntities[_loc5_.informations.contextualId] = true;
               }
               else
               {
                  this.updateFighter(_loc5_.informations);
                  this._illusionEntities[_loc5_.informations.contextualId] = false;
                  if(Kernel.getWorker().getFrame(FightPreparationFrame))
                  {
                     KernelEventsManager.getInstance().processCallback(FightHookList.UpdatePreFightersList,_loc5_.informations.contextualId);
                     if(Dofus.getInstance().options.orderFighters)
                     {
                        this.updateAllEntitiesNumber(this.getOrdonnedPreFighters());
                     }
                  }
               }
               if((_loc6_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame).fightersPositionsHistory[_loc5_.informations.contextualId])
               {
               }
               return true;
            case param1 is GameFightHumanReadyStateMessage:
               _loc7_ = param1 as GameFightHumanReadyStateMessage;
               _loc8_ = this.addOrUpdateActor(getEntityInfos(_loc7_.characterId) as GameFightFighterInformations);
               if(_loc7_.isReady)
               {
                  _loc30_ = EmbedAssets.getSprite("SWORDS_CLIP");
                  _loc8_.addBackground("readySwords",_loc30_);
               }
               else
               {
                  _loc8_.removeBackground("readySwords");
                  if(_loc7_.characterId == PlayedCharacterManager.getInstance().id)
                  {
                     KernelEventsManager.getInstance().processCallback(FightHookList.NotReadyToFight);
                  }
               }
               if(_loc9_ = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame)
               {
                  _loc9_.updateSwapPositionRequestsIcons();
               }
               return true;
            case param1 is GameEntityDispositionMessage:
               if((_loc10_ = param1 as GameEntityDispositionMessage).disposition.id == CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  SoundManager.getInstance().manager.playUISound(UISoundEnum.FIGHT_POSITION);
               }
               this.updateActorDisposition(_loc10_.disposition.id,_loc10_.disposition);
               KernelEventsManager.getInstance().processCallback(FightHookList.GameEntityDisposition,_loc10_.disposition.id,_loc10_.disposition.cellId,_loc10_.disposition.direction);
               return true;
            case param1 is GameFightPlacementSwapPositionsMessage:
               _loc11_ = param1 as GameFightPlacementSwapPositionsMessage;
               for each(_loc12_ in _loc11_.dispositions)
               {
                  this.updateActorDisposition(_loc12_.id,_loc12_);
                  KernelEventsManager.getInstance().processCallback(FightHookList.GameEntityDisposition,_loc12_.id,_loc12_.cellId,_loc12_.direction);
               }
               return true;
            case param1 is GameEntitiesDispositionMessage:
               _loc13_ = param1 as GameEntitiesDispositionMessage;
               for each(_loc31_ in _loc13_.dispositions)
               {
                  if(getEntityInfos(_loc31_.id) && GameFightFighterInformations(getEntityInfos(_loc31_.id)).stats.invisibilityState != GameActionFightInvisibilityStateEnum.INVISIBLE)
                  {
                     this.updateActorDisposition(_loc31_.id,_loc31_);
                  }
                  KernelEventsManager.getInstance().processCallback(FightHookList.GameEntityDisposition,_loc31_.id,_loc31_.cellId,_loc31_.direction);
               }
               return true;
            case param1 is GameContextRefreshEntityLookMessage:
               _loc14_ = param1 as GameContextRefreshEntityLookMessage;
               if(_loc15_ = DofusEntities.getEntity(_loc14_.id) as TiphonSprite)
               {
                  _loc15_.setAnimation(AnimationEnum.ANIM_STATIQUE);
               }
               this.updateActorLook(_loc14_.id,_loc14_.look);
               return true;
            case param1 is ToggleDematerializationAction:
               this.showCreaturesInFight(!_creaturesFightMode);
               KernelEventsManager.getInstance().processCallback(FightHookList.DematerializationChanged,_creaturesFightMode);
               return true;
            case param1 is RemoveEntityAction:
               _loc16_ = RemoveEntityAction(param1).actorId;
               this._entitiesNumber[_loc16_] = null;
               removeActor(_loc16_);
               KernelEventsManager.getInstance().processCallback(FightHookList.UpdatePreFightersList,_loc16_);
               delete this._realFightersLooks[_loc16_];
               return true;
            case param1 is ShowCellSpectatorMessage:
               _loc17_ = param1 as ShowCellSpectatorMessage;
               HyperlinkShowCellManager.showCell(_loc17_.cellId);
               _loc18_ = I18n.getUiText("ui.fight.showCell",[_loc17_.playerName,"{cell," + _loc17_.cellId + "::" + _loc17_.cellId + "}"]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc18_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is ShowCellMessage:
               _loc19_ = param1 as ShowCellMessage;
               HyperlinkShowCellManager.showCell(_loc19_.cellId);
               _loc21_ = !!(_loc20_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame)?_loc20_.getFighterName(_loc19_.sourceId):"???";
               _loc22_ = I18n.getUiText("ui.fight.showCell",[_loc21_,"{cell," + _loc19_.cellId + "::" + _loc19_.cellId + "}"]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc22_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is MapComplementaryInformationsDataMessage:
               _loc23_ = param1 as MapComplementaryInformationsDataMessage;
               _interactiveElements = _loc23_.interactiveElements;
               if(param1 is MapComplementaryInformationsWithCoordsMessage)
               {
                  _loc32_ = param1 as MapComplementaryInformationsWithCoordsMessage;
                  if(PlayedCharacterManager.getInstance().isInHouse)
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.HouseExit);
                  }
                  PlayedCharacterManager.getInstance().isInHouse = false;
                  PlayedCharacterManager.getInstance().isInHisHouse = false;
                  PlayedCharacterManager.getInstance().currentMap.setOutdoorCoords(_loc32_.worldX,_loc32_.worldY);
                  _worldPoint = new WorldPointWrapper(_loc32_.mapId,true,_loc32_.worldX,_loc32_.worldY);
               }
               else if(param1 is MapComplementaryInformationsDataInHouseMessage)
               {
                  _loc33_ = param1 as MapComplementaryInformationsDataInHouseMessage;
                  _loc34_ = PlayerManager.getInstance().nickname == _loc33_.currentHouse.ownerName;
                  PlayedCharacterManager.getInstance().isInHouse = true;
                  if(_loc34_)
                  {
                     PlayedCharacterManager.getInstance().isInHisHouse = true;
                  }
                  PlayedCharacterManager.getInstance().currentMap.setOutdoorCoords(_loc33_.currentHouse.worldX,_loc33_.currentHouse.worldY);
                  KernelEventsManager.getInstance().processCallback(HookList.HouseEntered,_loc34_,_loc33_.currentHouse.ownerId,_loc33_.currentHouse.ownerName,_loc33_.currentHouse.price,_loc33_.currentHouse.isLocked,_loc33_.currentHouse.worldX,_loc33_.currentHouse.worldY,HouseWrapper.manualCreate(_loc33_.currentHouse.modelId,-1,_loc33_.currentHouse.ownerName,_loc33_.currentHouse.price != 0));
                  _worldPoint = new WorldPointWrapper(_loc33_.mapId,true,_loc33_.currentHouse.worldX,_loc33_.currentHouse.worldY);
               }
               else
               {
                  _worldPoint = new WorldPointWrapper(_loc23_.mapId);
                  if(PlayedCharacterManager.getInstance().isInHouse)
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.HouseExit);
                  }
                  PlayedCharacterManager.getInstance().isInHouse = false;
                  PlayedCharacterManager.getInstance().isInHisHouse = false;
               }
               _currentSubAreaId = _loc23_.subAreaId;
               PlayedCharacterManager.getInstance().currentMap = _worldPoint;
               PlayedCharacterManager.getInstance().currentSubArea = SubArea.getSubAreaById(_currentSubAreaId);
               TooltipManager.hide();
               for each(_loc35_ in _loc23_.obstacles)
               {
                  InteractiveCellManager.getInstance().updateCell(_loc35_.obstacleCellId,_loc35_.state == MapObstacleStateEnum.OBSTACLE_OPENED);
               }
               for each(_loc36_ in _loc23_.interactiveElements)
               {
                  if(_loc36_.enabledSkills.length)
                  {
                     this.registerInteractive(_loc36_,_loc36_.enabledSkills[0].skillId);
                  }
                  else if(_loc36_.disabledSkills.length)
                  {
                     this.registerInteractive(_loc36_,_loc36_.disabledSkills[0].skillId);
                  }
               }
               for each(_loc37_ in _loc23_.statedElements)
               {
                  this.updateStatedElement(_loc37_);
               }
               KernelEventsManager.getInstance().processCallback(HookList.MapComplementaryInformationsData,PlayedCharacterManager.getInstance().currentMap,_currentSubAreaId,Dofus.getInstance().options.mapCoordinates);
               KernelEventsManager.getInstance().processCallback(HookList.MapFightCount,0);
               return true;
            case param1 is GameActionFightCarryCharacterMessage:
               if((_loc24_ = param1 as GameActionFightCarryCharacterMessage).cellId != -1)
               {
                  for each(_loc38_ in _entities)
                  {
                     if(_loc38_.contextualId == _loc24_.targetId)
                     {
                        (_loc38_.disposition as FightEntityDispositionInformations).carryingCharacterId = _loc24_.sourceId;
                        this._tempFighterList.push(new TmpFighterInfos(_loc38_.contextualId,_loc24_.sourceId));
                        break;
                     }
                  }
               }
               return true;
            case param1 is GameActionFightThrowCharacterMessage:
               _loc25_ = param1 as GameActionFightThrowCharacterMessage;
               this.dropEntity(_loc25_.targetId);
               return true;
            case param1 is GameActionFightDropCharacterMessage:
               _loc26_ = param1 as GameActionFightDropCharacterMessage;
               this.dropEntity(_loc26_.targetId);
               return true;
            case param1 is PlayerStatusUpdateMessage:
               _loc27_ = param1 as PlayerStatusUpdateMessage;
               this._lastKnownPlayerStatus[_loc27_.playerId] = _loc27_.status.statusId;
               return false;
            case param1 is ShowMountsInFightAction:
               _loc28_ = param1 as ShowMountsInFightAction;
               OptionManager.getOptionManager("dofus")["showMountsInFight"] = _loc28_.visibility;
               this.switchMountsVisibility(_loc28_.visibility);
               return true;
            default:
               return false;
         }
      }
      
      private function dropEntity(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GameFightFighterInformations = null;
         for each(_loc3_ in _entities)
         {
            if(_loc3_.contextualId == param1)
            {
               (_loc3_.disposition as FightEntityDispositionInformations).carryingCharacterId = NaN;
               _loc2_ = this.getTmpFighterInfoIndex(_loc3_.contextualId);
               if(this._tempFighterList != null && this._tempFighterList.length != 0 && _loc2_ != -1)
               {
                  this._tempFighterList.splice(_loc2_,1);
               }
               return;
            }
         }
      }
      
      public function showCreaturesInFight(param1:Boolean = false) : void
      {
         var _loc2_:GameFightFighterInformations = null;
         var _loc3_:AnimatedCharacter = null;
         _creaturesFightMode = param1;
         _justSwitchingCreaturesFightMode = true;
         this._numCreatureSwitchingEntities = 0;
         for each(_loc2_ in _entities)
         {
            this.updateFighter(_loc2_);
            _loc3_ = DofusEntities.getEntity(_loc2_.contextualId) as AnimatedCharacter;
            if(_loc3_ && !_loc3_.rendered)
            {
               ++this._numCreatureSwitchingEntities;
               _loc3_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onCreatureSwitchEnd);
            }
         }
         _justSwitchingCreaturesFightMode = false;
         if(this._numCreatureSwitchingEntities == 0)
         {
            this.onCreatureSwitchEnd(null);
         }
      }
      
      public function switchMountsVisibility(param1:Boolean) : void
      {
         var _loc2_:GameFightFighterInformations = null;
         this._mountsVisible = param1;
         for each(_loc2_ in _entities)
         {
            this.updateFighter(_loc2_);
         }
      }
      
      public function entityIsIllusion(param1:int) : Boolean
      {
         return this._illusionEntities[param1];
      }
      
      public function getLastKnownEntityPosition(param1:int) : int
      {
         return this._lastKnownPosition[param1] != null?int(this._lastKnownPosition[param1]):-1;
      }
      
      public function setLastKnownEntityPosition(param1:int, param2:int) : void
      {
         this._lastKnownPosition[param1] = param2;
      }
      
      public function getLastKnownEntityMovementPoint(param1:int) : int
      {
         return this._lastKnownMovementPoint[param1] != null?int(this._lastKnownMovementPoint[param1]):0;
      }
      
      public function setLastKnownEntityMovementPoint(param1:int, param2:int, param3:Boolean = false) : void
      {
         if(this._lastKnownMovementPoint[param1] == null)
         {
            this._lastKnownMovementPoint[param1] = 0;
         }
         if(!param3)
         {
            this._lastKnownMovementPoint[param1] = param2;
         }
         else
         {
            this._lastKnownMovementPoint[param1] = this._lastKnownMovementPoint[param1] + param2;
         }
      }
      
      override public function pulled() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         Dofus.getInstance().options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         this._tempFighterList = null;
         for each(_loc1_ in this._ie)
         {
            this.removeInteractive(_loc1_.element as InteractiveElement);
         }
         for(_loc2_ in this._realFightersLooks)
         {
            delete this._realFightersLooks[_loc2_];
         }
         return super.pulled();
      }
      
      private function onTimeOut() : void
      {
         clearTimeout(this._showCellStart);
         removeActor(this.arrowId);
         this._showCellStart = 0;
      }
      
      private function registerInteractive(param1:InteractiveElement, param2:int) : void
      {
         var _loc3_:* = null;
         var _loc4_:InteractiveElement = null;
         var _loc6_:Boolean = false;
         var _loc5_:InteractiveObject;
         if(!(_loc5_ = Atouin.getInstance().getIdentifiedElement(param1.elementId)))
         {
            _log.error("Unknown identified element " + param1.elementId + ", unable to register it as interactive.");
            return;
         }
         for(_loc3_ in interactiveElements)
         {
            if((_loc4_ = interactiveElements[int(_loc3_)]).elementId == param1.elementId)
            {
               _loc6_ = true;
               interactiveElements[int(_loc3_)] = param1;
               break;
            }
         }
         if(!_loc6_)
         {
            interactiveElements.push(param1);
         }
         var _loc7_:MapPoint = Atouin.getInstance().getIdentifiedElementPosition(param1.elementId);
         this._ie[_loc5_] = {
            "element":param1,
            "position":_loc7_,
            "firstSkill":param2
         };
      }
      
      private function updateStatedElement(param1:StatedElement) : void
      {
         var _loc2_:InteractiveObject = Atouin.getInstance().getIdentifiedElement(param1.elementId);
         if(!_loc2_)
         {
            _log.error("Unknown identified element " + param1.elementId + "; unable to change its state to " + param1.elementState + " !");
            return;
         }
         var _loc3_:TiphonSprite = _loc2_ is DisplayObjectContainer?this.findTiphonSprite(_loc2_ as DisplayObjectContainer):null;
         if(!_loc3_)
         {
            _log.warn("Unable to find an animated element for the stated element " + param1.elementId + " on cell " + param1.elementCellId + ", this element is probably invisible or is not configured as an animated element.");
            return;
         }
         _loc3_.setAnimationAndDirection("AnimState1",0);
      }
      
      private function findTiphonSprite(param1:DisplayObjectContainer) : TiphonSprite
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:uint = 0;
         if(param1 is TiphonSprite)
         {
            return param1 as TiphonSprite;
         }
         if(!param1.numChildren)
         {
            return null;
         }
         while(_loc3_ < param1.numChildren)
         {
            _loc2_ = param1.getChildAt(_loc3_);
            if(_loc2_ is TiphonSprite)
            {
               return _loc2_ as TiphonSprite;
            }
            if(_loc2_ is DisplayObjectContainer)
            {
               return this.findTiphonSprite(_loc2_ as DisplayObjectContainer);
            }
            _loc3_++;
         }
         return null;
      }
      
      private function removeInteractive(param1:InteractiveElement) : void
      {
         var _loc2_:InteractiveObject = Atouin.getInstance().getIdentifiedElement(param1.elementId);
         delete this._ie[_loc2_];
      }
      
      private function onCreatureSwitchEnd(param1:TiphonEvent) : void
      {
         var _loc2_:FightPreparationFrame = null;
         if(param1)
         {
            param1.currentTarget.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onCreatureSwitchEnd);
            --this._numCreatureSwitchingEntities;
         }
         if(this._numCreatureSwitchingEntities == 0)
         {
            _loc2_ = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame;
            if(_loc2_)
            {
               _loc2_.updateSwapPositionRequestsIcons();
            }
         }
      }
      
      public function getOrdonnedPreFighters() : Vector.<int>
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:GameFightFighterInformations = null;
         var _loc6_:GameFightMinimalStatsPreparation = null;
         var _loc12_:int = 0;
         var _loc7_:Vector.<int> = getEntitiesIdsList();
         var _loc8_:Vector.<int> = new Vector.<int>();
         if(!_loc7_ || _loc7_.length <= 1)
         {
            return _loc8_;
         }
         var _loc9_:Array = new Array();
         var _loc10_:Array = new Array();
         for each(_loc3_ in _loc7_)
         {
            if(_loc5_ = getEntityInfos(_loc3_) as GameFightFighterInformations)
            {
               if(_loc6_ = _loc5_.stats as GameFightMinimalStatsPreparation)
               {
                  if(_loc5_.teamId == 0)
                  {
                     _loc10_.push({
                        "fighter":_loc3_,
                        "init":_loc6_.initiative * _loc6_.lifePoints / _loc6_.maxLifePoints
                     });
                     _loc1_ = _loc1_ + _loc6_.initiative * _loc6_.lifePoints / _loc6_.maxLifePoints;
                  }
                  else
                  {
                     _loc9_.push({
                        "fighter":_loc3_,
                        "init":_loc6_.initiative * _loc6_.lifePoints / _loc6_.maxLifePoints
                     });
                     _loc2_ = _loc2_ + _loc6_.initiative * _loc6_.lifePoints / _loc6_.maxLifePoints;
                  }
               }
            }
         }
         _loc10_.sortOn(["init","fighter"],Array.DESCENDING | Array.NUMERIC);
         _loc9_.sortOn(["init","fighter"],Array.DESCENDING | Array.NUMERIC);
         _loc4_ = true;
         if(_loc10_.length == 0 || _loc9_.length == 0 || _loc1_ / _loc10_.length < _loc2_ / _loc9_.length)
         {
            _loc4_ = false;
         }
         var _loc11_:int = Math.max(_loc10_.length,_loc9_.length);
         while(_loc12_ < _loc11_)
         {
            if(_loc4_)
            {
               if(_loc10_[_loc12_])
               {
                  _loc8_.push(_loc10_[_loc12_].fighter);
               }
               if(_loc9_[_loc12_])
               {
                  _loc8_.push(_loc9_[_loc12_].fighter);
               }
            }
            else
            {
               if(_loc9_[_loc12_])
               {
                  _loc8_.push(_loc9_[_loc12_].fighter);
               }
               if(_loc10_[_loc12_])
               {
                  _loc8_.push(_loc10_[_loc12_].fighter);
               }
            }
            _loc12_++;
         }
         return _loc8_;
      }
      
      public function removeSwords() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:AnimatedCharacter = null;
         for each(_loc1_ in _entities)
         {
            if(!(_loc1_ is GameFightCharacterInformations && !GameFightCharacterInformations(_loc1_).alive))
            {
               _loc2_ = this.addOrUpdateActor(_loc1_);
               _loc2_.removeBackground("readySwords");
            }
         }
      }
      
      public function updateFighter(param1:GameFightFighterInformations, param2:IAnimationModifier = null, param3:Array = null) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:BasicBuff = null;
         var _loc7_:StatBuff = null;
         var _loc8_:String = null;
         var _loc9_:Effect = null;
         var _loc10_:int = 0;
         var _loc11_:GameFightFighterInformations = null;
         var _loc12_:AnimatedCharacter = null;
         var _loc13_:FightChangeVisibilityStep = null;
         var _loc14_:int = param1.contextualId;
         if(param3)
         {
            _loc4_ = 0;
            while(_loc4_ < param3.length)
            {
               _loc5_ = BuffManager.getInstance().getAllBuff(_loc14_);
               for each(_loc6_ in _loc5_)
               {
                  if(_loc6_.id == param3[_loc4_].id)
                  {
                     _loc8_ = (_loc7_ = param3[_loc4_] as StatBuff).statName;
                     _loc9_ = Effect.getEffectById(_loc7_.actionId);
                     if(_loc8_ && param1.stats.hasOwnProperty(_loc8_) && _loc9_.active)
                     {
                        if(_loc8_ == "actionPoints")
                        {
                           param1.stats["maxActionPoints"] = param1.stats["maxActionPoints"] - param3[_loc4_].delta;
                        }
                        param1.stats[_loc8_] = param1.stats[_loc8_] - param3[_loc4_].delta;
                     }
                  }
               }
               _loc4_++;
            }
         }
         if(param1.alive)
         {
            _loc10_ = -1;
            if(_loc11_ = _entities[param1.contextualId] as GameFightFighterInformations)
            {
               _loc10_ = _loc11_.stats.invisibilityState;
            }
            if(_loc10_ == GameActionFightInvisibilityStateEnum.INVISIBLE && param1.stats.invisibilityState == _loc10_)
            {
               registerActor(param1);
               return;
            }
            _loc12_ = this.addOrUpdateActor(param1,param2);
            if(_loc11_ != param1)
            {
               if(param1.contextualId == CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.CharacterStatsList);
               }
            }
            if(param1.stats.invisibilityState != GameActionFightInvisibilityStateEnum.VISIBLE && param1.stats.invisibilityState != _loc10_)
            {
               (_loc13_ = new FightChangeVisibilityStep(_loc14_,param1.stats.invisibilityState)).start();
            }
            this.addCircleToFighter(_loc12_,param1.teamId == TeamEnum.TEAM_DEFENDER?uint(TEAM_CIRCLE_COLOR_1):uint(TEAM_CIRCLE_COLOR_2));
         }
         else
         {
            this.updateActor(param1,false);
         }
         this.updateCarriedEntities(param1);
      }
      
      public function updateActor(param1:GameContextActorInformations, param2:Boolean = true, param3:IAnimationModifier = null) : void
      {
         if(param2)
         {
            this.addOrUpdateActor(param1,param3);
         }
         else
         {
            if(_entities[param1.contextualId])
            {
               hideActor(param1.contextualId);
            }
            registerActor(param1);
         }
      }
      
      override protected function updateActorLook(param1:int, param2:EntityLook, param3:Boolean = false) : AnimatedCharacter
      {
         var _loc4_:AnimatedCharacter;
         if((_loc4_ = super.updateActorLook(param1,param2,param3)) && param1 != PlayedCharacterManager.getInstance().id)
         {
            KernelEventsManager.getInstance().processCallback(HookList.FighterLookChange,param1,LookCleaner.clean(_loc4_.look));
         }
         return _loc4_;
      }
      
      public function addCircleToFighter(param1:TiphonSprite, param2:uint) : void
      {
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Sprite = EmbedAssets.getSprite("TEAM_CIRCLE_CLIP");
         _loc3_.addChild(_loc4_);
         var _loc5_:ColorTransform;
         (_loc5_ = new ColorTransform()).color = param2;
         _loc3_.filters = [new GlowFilter(16777215,0.5,2,2,3,3)];
         _loc4_.transform.colorTransform = _loc5_;
         param1.addBackground("teamCircle",_loc3_);
      }
      
      private function updateCarriedEntities(param1:GameContextActorInformations) : void
      {
         var _loc2_:TmpFighterInfos = null;
         var _loc3_:int = 0;
         var _loc4_:FightEntityDispositionInformations = null;
         var _loc5_:IEntity = null;
         var _loc6_:IEntity = null;
         var _loc7_:Boolean = false;
         var _loc8_:TiphonSprite = null;
         var _loc9_:IAnimationModifier = null;
         var _loc12_:int = 0;
         var _loc10_:int = param1.contextualId;
         var _loc11_:int = this._tempFighterList.length;
         while(_loc12_ < _loc11_)
         {
            _loc2_ = this._tempFighterList[_loc12_];
            _loc3_ = _loc2_.carryingCharacterId;
            if(_loc10_ == _loc3_)
            {
               this._tempFighterList.splice(_loc12_,1);
               this.startCarryStep(_loc3_,_loc2_.contextualId);
               break;
            }
            _loc12_++;
         }
         if(param1.disposition is FightEntityDispositionInformations)
         {
            if((_loc4_ = param1.disposition as FightEntityDispositionInformations).carryingCharacterId)
            {
               if(!(_loc5_ = DofusEntities.getEntity(_loc4_.carryingCharacterId)))
               {
                  this._tempFighterList.push(new TmpFighterInfos(param1.contextualId,_loc4_.carryingCharacterId));
               }
               else if(_loc6_ = DofusEntities.getEntity(param1.contextualId))
               {
                  _loc7_ = false;
                  if((_loc5_ as AnimatedCharacter).isMounted())
                  {
                     _loc8_ = (_loc5_ as TiphonSprite).getSubEntitySlot(2,0) as TiphonSprite;
                  }
                  else
                  {
                     _loc8_ = _loc5_ as TiphonSprite;
                  }
                  if(_loc8_)
                  {
                     _loc8_.removeAnimationModifierByClass(CustomAnimStatiqueAnimationModifier);
                     for each(_loc9_ in _loc8_.animationModifiers)
                     {
                        if(_loc9_ is CarrierAnimationModifier)
                        {
                           _loc7_ = true;
                           break;
                        }
                     }
                     if(!_loc7_)
                     {
                        _loc8_.addAnimationModifier(CarrierAnimationModifier.getInstance());
                     }
                  }
                  if(!_loc7_ || !(_loc5_ is TiphonSprite && _loc6_ is TiphonSprite && TiphonSprite(_loc6_).parentSprite == _loc5_))
                  {
                     this.startCarryStep(_loc4_.carryingCharacterId,param1.contextualId);
                  }
               }
            }
         }
      }
      
      private function startCarryStep(param1:int, param2:int) : void
      {
         var _loc3_:FightCarryCharacterStep = new FightCarryCharacterStep(param1,param2,-1,true);
         _loc3_.start();
         FightEventsHelper.sendAllFightEvent();
      }
      
      public function updateAllEntitiesNumber(param1:Vector.<int>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 1;
         for each(_loc2_ in param1)
         {
            if(_entities[_loc2_] && _entities[_loc2_].alive)
            {
               this.updateEntityNumber(_loc2_,_loc3_);
               _loc3_++;
            }
         }
      }
      
      public function updateEntityNumber(param1:int, param2:uint) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:Label = null;
         var _loc5_:AnimatedCharacter = null;
         if(_entities[param1] && (!(_entities[param1] is GameFightCharacterInformations) || GameFightCharacterInformations(_entities[param1]).alive))
         {
            if(!this._entitiesNumber[param1] || this._entitiesNumber[param1] == null)
            {
               _loc3_ = new Sprite();
               (_loc4_ = new Label()).width = 30;
               _loc4_.height = 20;
               _loc4_.x = -45;
               _loc4_.y = -15;
               _loc4_.css = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "css/normal.css");
               _loc4_.text = param2.toString();
               _loc3_.addChild(_loc4_);
               _loc3_.filters = [new GlowFilter(XmlConfig.getInstance().getEntry("colors.text.glow"),1,4,4,6,3)];
               this._entitiesNumber[param1] = _loc4_;
               if(_loc5_ = DofusEntities.getEntity(param1) as AnimatedCharacter)
               {
                  _loc5_.addBackground("fighterNumber",_loc3_);
               }
            }
            else
            {
               this._entitiesNumber[param1].text = param2.toString();
            }
         }
      }
      
      public function updateRemovedEntity(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:FightBattleFrame = null;
         var _loc4_:int = 0;
         this._entitiesNumber[param1] = null;
         if(Dofus.getInstance().options.orderFighters)
         {
            _loc2_ = 1;
            _loc3_ = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame;
            for each(_loc4_ in _loc3_.fightersList)
            {
               if(_loc4_ != param1 && (getEntityInfos(_loc4_) as GameFightFighterInformations).alive)
               {
                  this.updateEntityNumber(_loc4_,_loc2_);
                  _loc2_++;
               }
            }
         }
      }
      
      override protected function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:AnimatedCharacter = null;
         var _loc4_:uint = 0;
         var _loc5_:FightBattleFrame = null;
         var _loc6_:int = 0;
         if(!_worldPoint)
         {
            _worldPoint = PlayedCharacterManager.getInstance().currentMap;
         }
         if(!_currentSubAreaId)
         {
            _currentSubAreaId = PlayedCharacterManager.getInstance().currentSubArea.id;
         }
         super.onPropertyChanged(param1);
         if(param1.propertyName == "cellSelectionOnly")
         {
            untargetableEntities = param1.propertyValue || Kernel.getWorker().getFrame(FightPreparationFrame);
         }
         else if(param1.propertyName == "orderFighters")
         {
            if(!param1.propertyValue)
            {
               for(_loc2_ in this._entitiesNumber)
               {
                  if(this._entitiesNumber[int(_loc2_)])
                  {
                     this._entitiesNumber[int(_loc2_)] = null;
                     _loc3_ = DofusEntities.getEntity(int(_loc2_)) as AnimatedCharacter;
                     if(_loc3_)
                     {
                        _loc3_.removeBackground("fighterNumber");
                     }
                  }
               }
            }
            else
            {
               _loc4_ = 1;
               if(_loc5_ = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame)
               {
                  for each(_loc6_ in _loc5_.fightersList)
                  {
                     if((getEntityInfos(_loc6_) as GameFightFighterInformations).alive)
                     {
                        this.updateEntityNumber(_loc6_,_loc4_);
                        _loc4_++;
                     }
                  }
               }
            }
         }
         else if(param1.propertyName == "showMountsInFight")
         {
            this.switchMountsVisibility(param1.propertyValue);
         }
      }
      
      public function set cellSelectionOnly(param1:Boolean) : void
      {
         var _loc2_:GameContextActorInformations = null;
         var _loc3_:AnimatedCharacter = null;
         for each(_loc2_ in _entities)
         {
            _loc3_ = DofusEntities.getEntity(_loc2_.contextualId) as AnimatedCharacter;
            if(_loc3_)
            {
               _loc3_.mouseEnabled = !param1;
            }
         }
      }
      
      public function get dematerialization() : Boolean
      {
         return _creaturesFightMode;
      }
      
      public function get lastKnownPlayerStatus() : Dictionary
      {
         return this._lastKnownPlayerStatus;
      }
      
      public function getRealFighterLook(param1:int) : EntityLook
      {
         return this._realFightersLooks[param1];
      }
      
      public function setRealFighterLook(param1:int, param2:EntityLook) : void
      {
         this._realFightersLooks[param1] = param2;
      }
      
      public function get charactersMountsVisible() : Boolean
      {
         return this._mountsVisible;
      }
      
      override protected function updateActorDisposition(param1:int, param2:EntityDispositionInformations) : void
      {
         var _loc3_:IEntity = null;
         super.updateActorDisposition(param1,param2);
         if(param2.cellId == -1)
         {
            _loc3_ = DofusEntities.getEntity(param1);
            if(_loc3_)
            {
               FightEntitiesHolder.getInstance().holdEntity(_loc3_);
            }
         }
         else
         {
            FightEntitiesHolder.getInstance().unholdEntity(param1);
         }
      }
      
      private function getTmpFighterInfoIndex(param1:int) : int
      {
         var _loc2_:TmpFighterInfos = null;
         for each(_loc2_ in this._tempFighterList)
         {
            if(_loc2_.contextualId == param1)
            {
               return this._tempFighterList.indexOf(_loc2_);
            }
         }
         return -1;
      }
   }
}

class TmpFighterInfos
{
    
   
   public var contextualId:int;
   
   public var carryingCharacterId:int;
   
   function TmpFighterInfos(param1:int, param2:int)
   {
      super();
      this.contextualId = param1;
      this.carryingCharacterId = param2;
   }
}
