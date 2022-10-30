package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.*;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.CellOutMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.renderers.*;
   import com.ankamagames.atouin.types.*;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.berilia.types.tooltip.TooltipPlacer;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.BannerEmptySlotClickAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityClickAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOutAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOverAction;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.logic.game.fight.managers.LinkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellZoneManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.logic.game.fight.miscs.DamageUtil;
   import com.ankamagames.dofus.logic.game.fight.types.FightTeleportationPreview;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.GameActionFightInvisibilityStateEnum;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCastOnTargetRequestMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCastRequestMessage;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.Glyph;
   import com.ankamagames.dofus.types.entities.RiderBehavior;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.map.*;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.utils.display.Dofus2Line;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class FightSpellCastFrame implements Frame
   {
      
      private static const FORBIDDEN_CURSOR:Class = FightSpellCastFrame_FORBIDDEN_CURSOR;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightSpellCastFrame));
      
      private static const RANGE_COLOR:Color = new Color(5533093);
      
      private static const LOS_COLOR:Color = new Color(2241433);
      
      private static const PORTAL_COLOR:Color = new Color(251623);
      
      private static const TARGET_COLOR:Color = new Color(14487842);
      
      private static const SELECTION_RANGE:String = "SpellCastRange";
      
      private static const SELECTION_PORTALS:String = "SpellCastPortals";
      
      private static const SELECTION_LOS:String = "SpellCastLos";
      
      private static const SELECTION_TARGET:String = "SpellCastTarget";
      
      private static const FORBIDDEN_CURSOR_NAME:String = "SpellCastForbiddenCusror";
      
      private static const TELEPORTATION_EFFECTS:Array = [1100,1104,1105,1106];
      
      private static var _currentTargetIsTargetable:Boolean;
       
      
      private var _spellLevel:Object;
      
      private var _spellId:uint;
      
      private var _rangeSelection:Selection;
      
      private var _losSelection:Selection;
      
      private var _portalsSelection:Selection;
      
      private var _targetSelection:Selection;
      
      private var _currentCell:int = -1;
      
      private var _virtualCast:Boolean;
      
      private var _cancelTimer:Timer;
      
      private var _cursorData:LinkedCursorData;
      
      private var _lastTargetStatus:Boolean = true;
      
      private var _isInfiniteTarget:Boolean;
      
      private var _usedWrapper;
      
      private var _targetingThroughPortal:Boolean;
      
      private var _clearTargetTimer:Timer;
      
      private var _spellmaximumRange:uint;
      
      private var _invocationPreview:Array;
      
      private var _fightTeleportationPreview:FightTeleportationPreview;
      
      private var _replacementInvocationPreview:AnimatedCharacter;
      
      private var _currentCellEntity:AnimatedCharacter;
      
      public function FightSpellCastFrame(param1:uint)
      {
         var _loc2_:SpellWrapper = null;
         var _loc3_:EffectInstance = null;
         var _loc4_:TiphonEntityLook = null;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:Monster = null;
         var _loc8_:int = 0;
         var _loc9_:IEntity = null;
         var _loc10_:* = undefined;
         this._invocationPreview = new Array();
         super();
         this._spellId = param1;
         this._cursorData = new LinkedCursorData();
         this._cursorData.sprite = new FORBIDDEN_CURSOR();
         this._cursorData.sprite.cacheAsBitmap = true;
         this._cursorData.offset = new Point(14,14);
         this._cancelTimer = new Timer(50);
         this._cancelTimer.addEventListener(TimerEvent.TIMER,this.cancelCast);
         if(param1 || !PlayedCharacterManager.getInstance().currentWeapon)
         {
            for each(_loc2_ in PlayedCharacterManager.getInstance().spellsInventory)
            {
               if(_loc2_.spellId == this._spellId)
               {
                  this._spellLevel = _loc2_;
                  if(this._spellId == 74)
                  {
                     _loc4_ = EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook);
                     _loc5_ = 1;
                  }
                  else if(this._spellId == 2763)
                  {
                     _loc4_ = EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook);
                     _loc5_ = 4;
                  }
                  else
                  {
                     for each(_loc3_ in this.currentSpell.effects)
                     {
                        if(_loc3_.effectId == 181 || _loc3_.effectId == 1008 || _loc3_.effectId == 1011)
                        {
                           _loc6_ = _loc3_.parameter0;
                           _loc7_ = Monster.getMonsterById(_loc6_);
                           _loc4_ = new TiphonEntityLook(_loc7_.look);
                           _loc5_ = 1;
                           break;
                        }
                     }
                  }
                  if(_loc4_)
                  {
                     _loc8_ = 0;
                     while(_loc8_ < _loc5_)
                     {
                        ((_loc9_ = new AnimatedCharacter(EntitiesManager.getInstance().getFreeEntityId(),_loc4_)) as AnimatedCharacter).setCanSeeThrough(true);
                        (_loc9_ as AnimatedCharacter).transparencyAllowed = true;
                        (_loc9_ as AnimatedCharacter).alpha = 0.65;
                        (_loc9_ as AnimatedCharacter).mouseEnabled = false;
                        this._invocationPreview.push(_loc9_);
                        _loc8_++;
                     }
                  }
                  else
                  {
                     this.removeInvocationPreview();
                  }
                  break;
               }
            }
         }
         else
         {
            _loc10_ = PlayedCharacterManager.getInstance().currentWeapon;
            this._spellLevel = {
               "effects":_loc10_.effects,
               "castTestLos":_loc10_.castTestLos,
               "castInLine":_loc10_.castInLine,
               "castInDiagonal":_loc10_.castInDiagonal,
               "minRange":_loc10_.minRange,
               "range":_loc10_.range,
               "apCost":_loc10_.apCost,
               "needFreeCell":false,
               "needTakenCell":false,
               "needFreeTrapCell":false
            };
         }
         this._clearTargetTimer = new Timer(50,1);
         this._clearTargetTimer.addEventListener(TimerEvent.TIMER,this.onClearTarget);
      }
      
      public static function isCurrentTargetTargetable() : Boolean
      {
         return _currentTargetIsTargetable;
      }
      
      public static function updateRangeAndTarget() : void
      {
         var _loc1_:FightSpellCastFrame = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame;
         if(_loc1_)
         {
            _loc1_.removeRange();
            _loc1_.drawRange();
            _loc1_.refreshTarget(true);
         }
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function get currentSpell() : Object
      {
         return this._spellLevel;
      }
      
      public function pushed() : Boolean
      {
         var _loc1_:FightEntitiesFrame = null;
         var _loc2_:Dictionary = null;
         var _loc3_:GameContextActorInformations = null;
         var _loc4_:GameFightFighterInformations = null;
         var _loc5_:AnimatedCharacter = null;
         var _loc6_:FightBattleFrame;
         if((_loc6_ = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame).playingSlaveEntity)
         {
            _loc1_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
            _loc2_ = _loc1_.getEntitiesDictionnary();
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = _loc3_ as GameFightFighterInformations;
               if((_loc5_ = DofusEntities.getEntity(_loc4_.contextualId) as AnimatedCharacter) && _loc4_.contextualId != CurrentPlayedFighterManager.getInstance().currentFighterId && _loc4_.stats.invisibilityState == GameActionFightInvisibilityStateEnum.DETECTED)
               {
                  _loc5_.setCanSeeThrough(true);
               }
            }
         }
         this._cancelTimer.reset();
         this._lastTargetStatus = true;
         if(this._spellId == 0)
         {
            if(PlayedCharacterManager.getInstance().currentWeapon)
            {
               this._usedWrapper = PlayedCharacterManager.getInstance().currentWeapon;
            }
            else
            {
               this._usedWrapper = SpellWrapper.create(-1,0,1,false,PlayedCharacterManager.getInstance().id);
            }
         }
         else
         {
            this._usedWrapper = SpellWrapper.getFirstSpellWrapperById(this._spellId,CurrentPlayedFighterManager.getInstance().currentFighterId);
         }
         KernelEventsManager.getInstance().processCallback(HookList.CastSpellMode,this._usedWrapper);
         this.drawRange();
         this.refreshTarget();
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:CellOverMessage = null;
         var _loc3_:CellOutMessage = null;
         var _loc4_:IEntity = null;
         var _loc5_:EntityMouseOverMessage = null;
         var _loc6_:TimelineEntityOverAction = null;
         var _loc7_:IEntity = null;
         var _loc8_:TimelineEntityOutAction = null;
         var _loc9_:IEntity = null;
         var _loc10_:CellClickMessage = null;
         var _loc11_:EntityClickMessage = null;
         var _loc12_:TimelineEntityClickAction = null;
         var _loc13_:IEntity = null;
         switch(true)
         {
            case param1 is CellOverMessage:
               _loc2_ = param1 as CellOverMessage;
               FightContextFrame.currentCell = _loc2_.cellId;
               this.refreshTarget();
               return false;
            case param1 is EntityMouseOutMessage:
               this.clearTarget();
               return false;
            case param1 is CellOutMessage:
               _loc3_ = param1 as CellOutMessage;
               if((_loc4_ = EntitiesManager.getInstance().getEntityOnCell(_loc3_.cellId,AnimatedCharacter)) && this._fightTeleportationPreview && FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc4_.id))
               {
                  this.removeTeleportationPreview();
               }
               if(!this._fightTeleportationPreview)
               {
                  this.removeReplacementInvocationPreview();
               }
               this.clearTarget();
               return false;
            case param1 is EntityMouseOverMessage:
               _loc5_ = param1 as EntityMouseOverMessage;
               FightContextFrame.currentCell = _loc5_.entity.position.cellId;
               this.refreshTarget();
               return false;
            case param1 is TimelineEntityOverAction:
               _loc6_ = param1 as TimelineEntityOverAction;
               if((_loc7_ = DofusEntities.getEntity(_loc6_.targetId)) && _loc7_.position && _loc7_.position.cellId > -1)
               {
                  FightContextFrame.currentCell = _loc7_.position.cellId;
                  this.refreshTarget();
               }
               return false;
            case param1 is TimelineEntityOutAction:
               _loc8_ = param1 as TimelineEntityOutAction;
               if((_loc9_ = DofusEntities.getEntity(_loc8_.targetId)) && _loc9_.position && _loc9_.position.cellId == this._currentCell)
               {
                  this.removeTeleportationPreview();
                  this.removeReplacementInvocationPreview();
               }
               return false;
            case param1 is CellClickMessage:
               _loc10_ = param1 as CellClickMessage;
               this.castSpell(_loc10_.cellId);
               return true;
            case param1 is EntityClickMessage:
               _loc11_ = param1 as EntityClickMessage;
               if(this._invocationPreview.length > 0)
               {
                  for each(_loc13_ in this._invocationPreview)
                  {
                     if(_loc13_.id == _loc11_.entity.id)
                     {
                        this.castSpell(_loc11_.entity.position.cellId);
                        return true;
                     }
                  }
               }
               this.castSpell(_loc11_.entity.position.cellId,_loc11_.entity.id);
               return true;
            case param1 is TimelineEntityClickAction:
               _loc12_ = param1 as TimelineEntityClickAction;
               this.castSpell(0,_loc12_.fighterId);
               return true;
            case param1 is AdjacentMapClickMessage:
            case param1 is MouseRightClickMessage:
               this.cancelCast();
               return true;
            case param1 is BannerEmptySlotClickAction:
               this.cancelCast();
               return true;
            case param1 is MouseUpMessage:
               this._cancelTimer.start();
               return false;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         var _loc1_:FightEntitiesFrame = null;
         var _loc2_:Dictionary = null;
         var _loc3_:GameContextActorInformations = null;
         var _loc4_:AnimatedCharacter = null;
         var _loc5_:FightBattleFrame;
         if((_loc5_ = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame) && _loc5_.playingSlaveEntity)
         {
            _loc1_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
            _loc2_ = _loc1_.getEntitiesDictionnary();
            for each(_loc3_ in _loc2_)
            {
               if((_loc4_ = DofusEntities.getEntity(_loc3_.contextualId) as AnimatedCharacter) && _loc3_.contextualId != CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  _loc4_.setCanSeeThrough(false);
               }
            }
         }
         this._clearTargetTimer.stop();
         this._clearTargetTimer.removeEventListener(TimerEvent.TIMER,this.onClearTarget);
         this._cancelTimer.stop();
         this._cancelTimer.removeEventListener(TimerEvent.TIMER,this.cancelCast);
         this.hideTargetsTooltips();
         this.removeRange();
         this.removeTarget();
         this.removeInvocationPreview();
         LinkedCursorSpriteManager.getInstance().removeItem(FORBIDDEN_CURSOR_NAME);
         this.removeTeleportationPreview();
         this.removeReplacementInvocationPreview();
         try
         {
            KernelEventsManager.getInstance().processCallback(HookList.CancelCastSpell,SpellWrapper.getFirstSpellWrapperById(this._spellId,CurrentPlayedFighterManager.getInstance().currentFighterId));
         }
         catch(e:Error)
         {
         }
         return true;
      }
      
      public function entityMovement(param1:int) : void
      {
         if(this._currentCellEntity && this._currentCellEntity.id == param1)
         {
            this.removeReplacementInvocationPreview();
            if(this._fightTeleportationPreview)
            {
               this.removeTeleportationPreview();
            }
         }
         else if(this._fightTeleportationPreview && (this._fightTeleportationPreview.getEntitiesIds().indexOf(param1) != -1 || this._fightTeleportationPreview.getTelefraggedEntitiesIds().indexOf(param1) != -1))
         {
            this.removeTeleportationPreview();
         }
      }
      
      public function refreshTarget(param1:Boolean = false) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:GameFightFighterInformations = null;
         var _loc5_:ZoneDARenderer = null;
         var _loc6_:IZone = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:TiphonSprite = null;
         var _loc14_:IEntity = null;
         var _loc15_:IEntity = null;
         if(this._clearTargetTimer.running)
         {
            this._clearTargetTimer.reset();
         }
         var _loc16_:int;
         if((_loc16_ = FightContextFrame.currentCell) == -1)
         {
            return;
         }
         this._targetingThroughPortal = false;
         if(SelectionManager.getInstance().isInside(_loc16_,SELECTION_PORTALS) && SelectionManager.getInstance().isInside(_loc16_,SELECTION_LOS) && this._spellId != 0)
         {
            _loc2_ = -1;
            _loc2_ = this.getTargetThroughPortal(_loc16_,true);
            if(_loc2_ != _loc16_)
            {
               this._targetingThroughPortal = true;
               _loc16_ = _loc2_;
            }
         }
         this.removeReplacementInvocationPreview();
         if(!param1 && this._currentCell == _loc16_)
         {
            if(this._targetSelection && this.isValidCell(_loc16_))
            {
               this.showTargetsTooltips(this._targetSelection);
               this.showReplacementInvocationPreview();
               this.showTeleportationPreview();
            }
            return;
         }
         this._currentCell = _loc16_;
         var _loc17_:Array = EntitiesManager.getInstance().getEntitiesOnCell(this._currentCell,AnimatedCharacter);
         this._currentCellEntity = _loc17_.length > 0?this.getParentEntity(_loc17_[0]) as AnimatedCharacter:null;
         var _loc18_:FightTurnFrame;
         if(!(_loc18_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame))
         {
            return;
         }
         var _loc19_:Boolean = _loc18_.myTurn;
         _currentTargetIsTargetable = this.isValidCell(_loc16_);
         if(_currentTargetIsTargetable)
         {
            if(!this._targetSelection)
            {
               this._targetSelection = new Selection();
               this._targetSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA,1,true);
               (this._targetSelection.renderer as ZoneDARenderer).showFarmCell = false;
               this._targetSelection.color = TARGET_COLOR;
               _loc6_ = SpellZoneManager.getInstance().getSpellZone(this._spellLevel,true);
               this._spellmaximumRange = _loc6_.radius;
               this._targetSelection.zone = _loc6_;
               SelectionManager.getInstance().addSelection(this._targetSelection,SELECTION_TARGET);
            }
            _loc3_ = CurrentPlayedFighterManager.getInstance().currentFighterId;
            if(_loc4_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc3_) as GameFightFighterInformations)
            {
               if(this._targetingThroughPortal)
               {
                  this._targetSelection.zone.direction = MapPoint(MapPoint.fromCellId(_loc4_.disposition.cellId)).advancedOrientationTo(MapPoint.fromCellId(FightContextFrame.currentCell),false);
               }
               else
               {
                  this._targetSelection.zone.direction = MapPoint(MapPoint.fromCellId(_loc4_.disposition.cellId)).advancedOrientationTo(MapPoint.fromCellId(_loc16_),false);
               }
            }
            _loc5_ = this._targetSelection.renderer as ZoneDARenderer;
            if(Atouin.getInstance().options.transparentOverlayMode && this._spellmaximumRange != 63)
            {
               _loc5_.currentStrata = PlacementStrataEnums.STRATA_NO_Z_ORDER;
               SelectionManager.getInstance().update(SELECTION_TARGET,_loc16_,true);
            }
            else
            {
               if(_loc5_.currentStrata == PlacementStrataEnums.STRATA_NO_Z_ORDER)
               {
                  _loc5_.currentStrata = PlacementStrataEnums.STRATA_AREA;
                  _loc7_ = true;
               }
               SelectionManager.getInstance().update(SELECTION_TARGET,_loc16_,_loc7_);
            }
            if(_loc19_)
            {
               LinkedCursorSpriteManager.getInstance().removeItem(FORBIDDEN_CURSOR_NAME);
               this._lastTargetStatus = true;
            }
            else
            {
               if(this._lastTargetStatus)
               {
                  LinkedCursorSpriteManager.getInstance().addItem(FORBIDDEN_CURSOR_NAME,this._cursorData,true);
               }
               this._lastTargetStatus = false;
            }
            if(this._invocationPreview.length > 0)
            {
               if(this._spellId == 2763)
               {
                  _loc8_ = MapPoint.fromCellId(_loc4_.disposition.cellId).x;
                  _loc9_ = MapPoint.fromCellId(_loc4_.disposition.cellId).y;
                  _loc10_ = MapPoint.fromCellId(_loc4_.disposition.cellId).distanceTo(MapPoint.fromCellId(this._currentCell));
                  _loc11_ = [MapPoint.fromCoords(_loc8_ + _loc10_,_loc9_),MapPoint.fromCoords(_loc8_ - _loc10_,_loc9_),MapPoint.fromCoords(_loc8_,_loc9_ + _loc10_),MapPoint.fromCoords(_loc8_,_loc9_ - _loc10_)];
                  _loc12_ = 0;
                  while(_loc12_ < 4)
                  {
                     if((_loc13_ = (_loc15_ = this._invocationPreview[_loc12_]) as TiphonSprite) && _loc13_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) && !_loc13_.getSubEntityBehavior(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER))
                     {
                        _loc13_.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,new RiderBehavior());
                     }
                     (_loc15_ as AnimatedCharacter).visible = true;
                     _loc15_.position = _loc11_[_loc12_];
                     (_loc15_ as AnimatedCharacter).setDirection(MapPoint.fromCellId(_loc4_.disposition.cellId).advancedOrientationTo(_loc15_.position,true));
                     if(this.isValidCell(_loc15_.position.cellId) && _loc15_.position.cellId != this._currentCell)
                     {
                        (_loc15_ as AnimatedCharacter).display(PlacementStrataEnums.STRATA_PLAYER);
                        (_loc15_ as AnimatedCharacter).visible = true;
                     }
                     else
                     {
                        (_loc15_ as AnimatedCharacter).visible = false;
                     }
                     _loc12_++;
                  }
               }
               else
               {
                  ((_loc14_ = this._invocationPreview[0]) as AnimatedCharacter).visible = true;
                  _loc14_.position = MapPoint.fromCellId(this._currentCell);
                  (_loc14_ as AnimatedCharacter).setDirection(MapPoint.fromCellId(_loc4_.disposition.cellId).advancedOrientationTo(MapPoint.fromCellId(this._currentCell),true));
                  if((_loc13_ = _loc14_ as TiphonSprite) && _loc13_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) && !_loc13_.getSubEntityBehavior(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER))
                  {
                     _loc13_.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,new RiderBehavior());
                  }
                  (_loc14_ as AnimatedCharacter).display(PlacementStrataEnums.STRATA_PLAYER);
               }
            }
            this.showTargetsTooltips(this._targetSelection);
            this.showReplacementInvocationPreview();
            this.showTeleportationPreview();
         }
         else
         {
            if(this._invocationPreview.length > 0)
            {
               for each(_loc15_ in this._invocationPreview)
               {
                  (_loc15_ as AnimatedCharacter).visible = false;
               }
            }
            if(this._lastTargetStatus)
            {
               LinkedCursorSpriteManager.getInstance().addItem(FORBIDDEN_CURSOR_NAME,this._cursorData,true);
            }
            this.removeTarget();
            this._lastTargetStatus = false;
            this.hideTargetsTooltips();
            this.removeTeleportationPreview();
            this.removeReplacementInvocationPreview();
         }
      }
      
      private function removeInvocationPreview() : void
      {
         var _loc1_:IEntity = null;
         for each(_loc1_ in this._invocationPreview)
         {
            (_loc1_ as AnimatedCharacter).remove();
            (_loc1_ as AnimatedCharacter).destroy();
            _loc1_ = null;
         }
      }
      
      private function showReplacementInvocationPreview() : void
      {
         var _loc1_:EffectInstance = null;
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:Monster = null;
         var _loc4_:AnimatedCharacter = null;
         var _loc5_:SpellWrapper;
         if(!(_loc5_ = this._usedWrapper as SpellWrapper))
         {
            return;
         }
         var _loc6_:Vector.<EffectInstance> = _loc5_.effects.concat(_loc5_.criticalEffect);
         var _loc7_:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(CurrentPlayedFighterManager.getInstance().currentFighterId) as GameFightFighterInformations;
         for each(_loc1_ in _loc6_)
         {
            if(_loc1_.effectId == 405 || _loc1_.effectId == 2796)
            {
               if(this._currentCellEntity && DamageUtil.verifySpellEffectMask(PlayedCharacterManager.getInstance().id,this._currentCellEntity.id,_loc1_,this._currentCell))
               {
                  this._currentCellEntity.visible = false;
                  TooltipManager.hide("tooltipOverEntity_" + this._currentCellEntity.id);
                  _loc3_ = Monster.getMonsterById(_loc1_.parameter0 as uint);
                  this._replacementInvocationPreview = new AnimatedCharacter(EntitiesManager.getInstance().getFreeEntityId(),new TiphonEntityLook(_loc3_.look));
                  this._replacementInvocationPreview.setCanSeeThrough(true);
                  this._replacementInvocationPreview.transparencyAllowed = true;
                  this._replacementInvocationPreview.alpha = 0.65;
                  this._replacementInvocationPreview.mouseEnabled = false;
                  this._replacementInvocationPreview.visible = true;
                  this._replacementInvocationPreview.position = MapPoint.fromCellId(this._currentCell);
                  this._replacementInvocationPreview.setDirection(MapPoint.fromCellId(_loc7_.disposition.cellId).advancedOrientationTo(MapPoint.fromCellId(this._currentCell),true));
                  this._replacementInvocationPreview.display(PlacementStrataEnums.STRATA_PLAYER);
                  break;
               }
            }
         }
      }
      
      private function removeReplacementInvocationPreview() : void
      {
         if(this._replacementInvocationPreview)
         {
            this._replacementInvocationPreview.destroy();
            this._replacementInvocationPreview = null;
         }
         if(this._currentCellEntity)
         {
            this._currentCellEntity.visible = true;
         }
      }
      
      public function drawRange() : void
      {
         var _loc1_:Cross = null;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         var _loc11_:MarkInstance = null;
         var _loc12_:Vector.<MapPoint> = null;
         var _loc13_:Vector.<uint> = null;
         var _loc14_:MapPoint = null;
         var _loc15_:MapPoint = null;
         var _loc16_:* = undefined;
         var _loc17_:MapPoint = null;
         var _loc18_:Point = null;
         var _loc19_:Vector.<uint> = null;
         var _loc20_:int = CurrentPlayedFighterManager.getInstance().currentFighterId;
         var _loc21_:GameFightFighterInformations;
         var _loc22_:uint = (_loc21_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc20_) as GameFightFighterInformations).disposition.cellId;
         var _loc23_:CharacterBaseCharacteristic = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().range;
         var _loc24_:int = this._spellLevel.range;
         if(!this._spellLevel.castInLine && !this._spellLevel.castInDiagonal && !this._spellLevel.castTestLos && _loc24_ == 63)
         {
            this._isInfiniteTarget = true;
            return;
         }
         this._isInfiniteTarget = false;
         if(this._spellLevel["rangeCanBeBoosted"])
         {
            if((_loc24_ = _loc24_ + (_loc23_.base + _loc23_.objectsAndMountBonus + _loc23_.alignGiftBonus + _loc23_.contextModif)) < this._spellLevel.minRange)
            {
               _loc24_ = this._spellLevel.minRange;
            }
         }
         if((_loc24_ = Math.min(_loc24_,AtouinConstants.MAP_WIDTH * AtouinConstants.MAP_HEIGHT)) < 0)
         {
            _loc24_ = 0;
         }
         this._rangeSelection = new Selection();
         this._rangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
         (this._rangeSelection.renderer as ZoneDARenderer).showFarmCell = false;
         this._rangeSelection.color = RANGE_COLOR;
         this._rangeSelection.alpha = true;
         if(this._spellLevel.castInLine && this._spellLevel.castInDiagonal)
         {
            _loc1_ = new Cross(this._spellLevel.minRange,_loc24_,DataMapProvider.getInstance());
            _loc1_.allDirections = true;
            this._rangeSelection.zone = _loc1_;
         }
         else if(this._spellLevel.castInLine)
         {
            this._rangeSelection.zone = new Cross(this._spellLevel.minRange,_loc24_,DataMapProvider.getInstance());
         }
         else if(this._spellLevel.castInDiagonal)
         {
            _loc1_ = new Cross(this._spellLevel.minRange,_loc24_,DataMapProvider.getInstance());
            _loc1_.diagonal = true;
            this._rangeSelection.zone = _loc1_;
         }
         else
         {
            this._rangeSelection.zone = new Lozenge(this._spellLevel.minRange,_loc24_,DataMapProvider.getInstance());
         }
         var _loc25_:Vector.<uint> = new Vector.<uint>();
         this._losSelection = new Selection();
         this._losSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
         (this._losSelection.renderer as ZoneDARenderer).showFarmCell = false;
         this._losSelection.color = LOS_COLOR;
         var _loc26_:Vector.<uint> = this._rangeSelection.zone.getCells(_loc22_);
         if(!this._spellLevel.castTestLos)
         {
            this._losSelection.zone = new Custom(_loc26_);
         }
         else
         {
            this._losSelection.zone = new Custom(LosDetector.getCell(DataMapProvider.getInstance(),_loc26_,MapPoint.fromCellId(_loc22_)));
            this._rangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA,0.5);
            (this._rangeSelection.renderer as ZoneDARenderer).showFarmCell = false;
            _loc3_ = this._rangeSelection.zone.getCells(_loc22_);
            _loc4_ = this._losSelection.zone.getCells(_loc22_);
            _loc5_ = _loc3_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc3_[_loc6_];
               if(_loc4_.indexOf(_loc7_) == -1)
               {
                  _loc25_.push(_loc7_);
               }
               _loc6_++;
            }
         }
         var _loc27_:Vector.<MapPoint> = MarkedCellsManager.getInstance().getMarksMapPoint(GameActionMarkTypeEnum.PORTAL);
         var _loc28_:Vector.<uint> = new Vector.<uint>();
         var _loc29_:Vector.<uint> = new Vector.<uint>();
         if(_loc27_ && _loc27_.length >= 2)
         {
            for each(_loc10_ in this._losSelection.zone.getCells(_loc22_))
            {
               if((_loc8_ = this.getTargetThroughPortal(_loc10_)) != _loc10_)
               {
                  this._targetingThroughPortal = true;
                  if(this.isValidCell(_loc8_,true))
                  {
                     if(this._spellLevel.castTestLos)
                     {
                        _loc11_ = MarkedCellsManager.getInstance().getMarkAtCellId(_loc10_,GameActionMarkTypeEnum.PORTAL);
                        _loc12_ = MarkedCellsManager.getInstance().getMarksMapPoint(GameActionMarkTypeEnum.PORTAL,_loc11_.teamId);
                        _loc9_ = (_loc13_ = LinkedCellsManager.getInstance().getLinks(MapPoint.fromCellId(_loc10_),_loc12_)).pop();
                        _loc14_ = MapPoint.fromCellId(_loc9_);
                        _loc15_ = MapPoint.fromCellId(_loc8_);
                        _loc16_ = Dofus2Line.getLine(_loc14_.cellId,_loc15_.cellId);
                        for each(_loc18_ in _loc16_)
                        {
                           _loc17_ = MapPoint.fromCoords(_loc18_.x,_loc18_.y);
                           _loc29_.push(_loc17_.cellId);
                        }
                        if((_loc19_ = LosDetector.getCell(DataMapProvider.getInstance(),_loc29_,_loc14_)).indexOf(_loc8_) > -1)
                        {
                           _loc28_.push(_loc10_);
                        }
                        else
                        {
                           _loc25_.push(_loc10_);
                        }
                     }
                     else
                     {
                        _loc28_.push(_loc10_);
                     }
                  }
                  else
                  {
                     _loc25_.push(_loc10_);
                  }
                  this._targetingThroughPortal = false;
               }
            }
         }
         var _loc30_:Vector.<uint> = new Vector.<uint>();
         var _loc31_:Vector.<uint> = this._losSelection.zone.getCells(_loc22_);
         for each(_loc2_ in _loc31_)
         {
            if(_loc28_.indexOf(_loc2_) != -1)
            {
               _loc30_.push(_loc2_);
            }
            else if(this._usedWrapper is SpellWrapper && this._usedWrapper.spellLevelInfos && (this._usedWrapper.spellLevelInfos.needFreeCell && this.cellHasEntity(_loc2_) || this._usedWrapper.spellLevelInfos.needFreeTrapCell && MarkedCellsManager.getInstance().cellHasTrap(_loc2_)))
            {
               _loc25_.push(_loc2_);
            }
            else if(_loc25_.indexOf(_loc2_) == -1)
            {
               _loc30_.push(_loc2_);
            }
         }
         this._losSelection.zone = new Custom(_loc30_);
         SelectionManager.getInstance().addSelection(this._losSelection,SELECTION_LOS,_loc22_);
         if(_loc25_.length > 0)
         {
            this._rangeSelection.zone = new Custom(_loc25_);
            SelectionManager.getInstance().addSelection(this._rangeSelection,SELECTION_RANGE,_loc22_);
         }
         if(_loc28_.length > 0)
         {
            this._portalsSelection = new Selection();
            this._portalsSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
            this._portalsSelection.color = PORTAL_COLOR;
            this._portalsSelection.alpha = true;
            this._portalsSelection.zone = new Custom(_loc28_);
            SelectionManager.getInstance().addSelection(this._portalsSelection,SELECTION_PORTALS,_loc22_);
         }
      }
      
      private function showTeleportationPreview() : void
      {
         var _loc1_:Vector.<EffectInstance> = null;
         var _loc2_:EffectInstance = null;
         var _loc3_:FightContextFrame = null;
         var _loc4_:IZone = null;
         var _loc5_:Vector.<uint> = null;
         var _loc6_:uint = 0;
         var _loc7_:Vector.<int> = null;
         var _loc8_:int = 0;
         var _loc9_:GameFightFighterInformations = null;
         var _loc10_:Vector.<int> = null;
         var _loc11_:int = 0;
         var _loc12_:SpellWrapper = null;
         var _loc13_:uint = 0;
         var _loc14_:int = 0;
         var _loc15_:uint = 0;
         var _loc16_:MarkInstance = null;
         var _loc17_:Vector.<MapPoint> = null;
         var _loc18_:Vector.<uint> = null;
         var _loc19_:SpellWrapper;
         if((_loc19_ = this._usedWrapper as SpellWrapper) && (!_loc19_.spellLevelInfos.needTakenCell || this._currentCellEntity))
         {
            _loc1_ = _loc19_.effects.concat(_loc19_.criticalEffect);
            _loc3_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
            _loc6_ = this._currentCell;
            _loc7_ = _loc3_.entitiesFrame.getEntitiesIdsList();
            _loc10_ = new Vector.<int>(0);
            _loc11_ = PlayedCharacterManager.getInstance().id;
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_.effectId == 1160)
               {
                  _loc12_ = SpellWrapper.create(0,_loc2_.parameter0 as uint,_loc19_.spellLevel);
                  if(this.hasTeleportation(_loc12_))
                  {
                     for each(_loc8_ in _loc7_)
                     {
                        if((_loc9_ = _loc3_.entitiesFrame.getEntityInfos(_loc8_) as GameFightFighterInformations).alive && DamageUtil.verifySpellEffectMask(_loc11_,_loc8_,_loc2_,_loc6_))
                        {
                           _loc6_ = _loc9_.disposition.cellId;
                           _loc1_ = _loc12_.effects.concat(_loc12_.criticalEffect);
                           break;
                        }
                     }
                     break;
                  }
               }
            }
            for each(_loc2_ in _loc1_)
            {
               if(TELEPORTATION_EFFECTS.indexOf(_loc2_.effectId) != -1)
               {
                  _loc13_ = _loc2_.effectId;
                  _loc5_ = (_loc4_ = SpellZoneManager.getInstance().getZone(_loc2_.zoneShape,_loc2_.zoneSize as uint,_loc2_.zoneMinSize as uint)).getCells(_loc6_);
                  for each(_loc8_ in _loc7_)
                  {
                     if((_loc9_ = _loc3_.entitiesFrame.getEntityInfos(_loc8_) as GameFightFighterInformations).alive && _loc5_.indexOf(_loc9_.disposition.cellId) != -1 && DofusEntities.getEntity(_loc8_) && _loc10_.indexOf(_loc8_) == -1 && DamageUtil.verifySpellEffectMask(_loc11_,_loc8_,_loc2_,_loc6_) && !(_loc6_ == _loc9_.disposition.cellId && (_loc13_ == 1104 || _loc13_ == 1106)) && this.canTeleport(_loc9_.contextualId))
                     {
                        _loc10_.push(_loc8_);
                     }
                  }
                  _loc14_++;
               }
            }
            if(_loc10_.length == 0 && _loc13_ == 1104 && this.canTeleport(_loc11_))
            {
               _loc10_.push(_loc11_);
            }
            this.removeTeleportationPreview();
            if(_loc10_.length > 0)
            {
               if(this._targetingThroughPortal)
               {
                  _loc16_ = MarkedCellsManager.getInstance().getMarkAtCellId(FightContextFrame.currentCell,GameActionMarkTypeEnum.PORTAL);
                  _loc17_ = MarkedCellsManager.getInstance().getMarksMapPoint(GameActionMarkTypeEnum.PORTAL,_loc16_.teamId);
                  _loc15_ = (_loc18_ = LinkedCellsManager.getInstance().getLinks(MapPoint.fromCellId(_loc16_.markImpactCellId),_loc17_)).pop();
               }
               else
               {
                  _loc15_ = _loc3_.entitiesFrame.getEntityInfos(_loc11_).disposition.cellId;
               }
               this._fightTeleportationPreview = new FightTeleportationPreview(this._usedWrapper,_loc10_,_loc13_,_loc6_,_loc15_,_loc14_ > 1,_loc10_.length == _loc7_.length);
               this._fightTeleportationPreview.show();
            }
         }
      }
      
      private function canTeleport(param1:int) : Boolean
      {
         var _loc2_:Monster = null;
         var _loc3_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc4_:GameFightFighterInformations;
         if((_loc4_ = _loc3_.entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations) is GameFightMonsterInformations)
         {
            _loc2_ = Monster.getMonsterById((_loc4_ as GameFightMonsterInformations).creatureGenericId);
            if(!_loc2_.canSwitchPos)
            {
               return false;
            }
         }
         var _loc5_:Array;
         return !(_loc5_ = FightersStateManager.getInstance().getStates(param1)) || _loc5_.indexOf(6) == -1 && _loc5_.indexOf(97) == -1;
      }
      
      private function hasTeleportation(param1:SpellWrapper) : Boolean
      {
         var _loc2_:EffectInstance = null;
         for each(_loc2_ in param1.effects)
         {
            if(TELEPORTATION_EFFECTS.indexOf(_loc2_.effectId) != -1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function removeTeleportationPreview() : void
      {
         if(this._fightTeleportationPreview)
         {
            this._fightTeleportationPreview.remove();
            this._fightTeleportationPreview = null;
         }
      }
      
      private function getParentEntity(param1:TiphonSprite) : TiphonSprite
      {
         var _loc2_:TiphonSprite = null;
         var _loc3_:TiphonSprite = param1.parentSprite;
         while(_loc3_)
         {
            _loc2_ = _loc3_;
            _loc3_ = _loc3_.parentSprite;
         }
         return !!_loc2_?_loc2_:param1;
      }
      
      private function showTargetsTooltips(param1:Selection) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GameFightFighterInformations = null;
         var _loc4_:FightContextFrame;
         var _loc5_:Vector.<int> = (_loc4_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame).entitiesFrame.getEntitiesIdsList();
         var _loc6_:Vector.<uint> = param1.zone.getCells(this._currentCell);
         var _loc7_:Vector.<int> = new Vector.<int>(0);
         for each(_loc2_ in _loc5_)
         {
            _loc3_ = _loc4_.entitiesFrame.getEntityInfos(_loc2_) as GameFightFighterInformations;
            if(_loc6_.indexOf(_loc3_.disposition.cellId) != -1 && DofusEntities.getEntity(_loc2_))
            {
               _loc7_.push(_loc2_);
               TooltipPlacer.waitBeforeOrder("tooltip_tooltipOverEntity_" + _loc2_);
            }
            else if(!_loc4_.showPermanentTooltips || _loc4_.showPermanentTooltips && _loc4_.battleFrame.targetedEntities.indexOf(_loc2_) == -1)
            {
               TooltipManager.hide("tooltipOverEntity_" + _loc2_);
            }
         }
         if(_loc7_.length > 0 && _loc7_.indexOf(CurrentPlayedFighterManager.getInstance().currentFighterId) == -1 && this._usedWrapper is SpellWrapper && (this._usedWrapper as SpellWrapper).canTargetCasterOutOfZone)
         {
            _loc7_.push(CurrentPlayedFighterManager.getInstance().currentFighterId);
         }
         _loc4_.removeSpellTargetsTooltips();
         for each(_loc2_ in _loc7_)
         {
            _loc3_ = _loc4_.entitiesFrame.getEntityInfos(_loc2_) as GameFightFighterInformations;
            if(_loc3_.alive)
            {
               _loc4_.displayEntityTooltip(_loc2_,this._spellLevel,null,false,this._currentCell);
            }
         }
      }
      
      private function hideTargetsTooltips() : void
      {
         var _loc1_:int = 0;
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc4_:Vector.<int> = _loc3_.entitiesFrame.getEntitiesIdsList();
         var _loc5_:IEntity;
         if(_loc5_ = EntitiesManager.getInstance().getEntityOnCell(FightContextFrame.currentCell,AnimatedCharacter))
         {
            _loc2_ = _loc5_ as AnimatedCharacter;
            if(_loc2_ && _loc2_.parentSprite && _loc2_.parentSprite.carriedEntity == _loc2_)
            {
               _loc5_ = _loc2_.parentSprite as AnimatedCharacter;
            }
         }
         for each(_loc1_ in _loc4_)
         {
            if(!_loc3_.showPermanentTooltips || _loc3_.showPermanentTooltips && _loc3_.battleFrame.targetedEntities.indexOf(_loc1_) == -1)
            {
               TooltipManager.hide("tooltipOverEntity_" + _loc1_);
            }
         }
         if(_loc3_.showPermanentTooltips && _loc3_.battleFrame.targetedEntities.length > 0)
         {
            for each(_loc1_ in _loc3_.battleFrame.targetedEntities)
            {
               if(!_loc5_ || _loc1_ != _loc5_.id)
               {
                  _loc3_.displayEntityTooltip(_loc1_);
               }
            }
         }
         if(_loc5_)
         {
            _loc3_.displayEntityTooltip(_loc5_.id);
         }
      }
      
      private function clearTarget() : void
      {
         if(!this._clearTargetTimer.running)
         {
            this._clearTargetTimer.start();
         }
      }
      
      private function onClearTarget(param1:TimerEvent) : void
      {
         this.refreshTarget();
      }
      
      private function getTargetThroughPortal(param1:int, param2:Boolean = false) : int
      {
         var _loc3_:MapPoint = null;
         var _loc4_:MarkInstance = null;
         var _loc5_:MapPoint = null;
         var _loc6_:EffectInstance = null;
         var _loc7_:MapPoint = null;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:Vector.<uint> = null;
         if(this._spellLevel && this._spellLevel.effects)
         {
            for each(_loc6_ in this._spellLevel.effects)
            {
               if(_loc6_.effectId == ActionIdConverter.ACTION_FIGHT_DISABLE_PORTAL)
               {
                  return param1;
               }
            }
         }
         var _loc10_:int = CurrentPlayedFighterManager.getInstance().currentFighterId;
         var _loc11_:GameFightFighterInformations;
         if(!(_loc11_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc10_) as GameFightFighterInformations))
         {
            return param1;
         }
         var _loc13_:Vector.<MapPoint>;
         var _loc12_:MarkedCellsManager;
         if(!(_loc13_ = (_loc12_ = MarkedCellsManager.getInstance()).getMarksMapPoint(GameActionMarkTypeEnum.PORTAL)) || _loc13_.length < 2)
         {
            return param1;
         }
         for each(_loc5_ in _loc13_)
         {
            if((_loc4_ = _loc12_.getMarkAtCellId(_loc5_.cellId,GameActionMarkTypeEnum.PORTAL)) && _loc4_.active)
            {
               if(_loc5_.cellId == param1)
               {
                  _loc3_ = _loc5_;
                  break;
               }
            }
         }
         if(!_loc3_)
         {
            return param1;
         }
         _loc13_ = _loc12_.getMarksMapPoint(GameActionMarkTypeEnum.PORTAL,_loc4_.teamId);
         var _loc14_:Vector.<uint> = LinkedCellsManager.getInstance().getLinks(_loc3_,_loc13_);
         var _loc15_:MapPoint = MapPoint.fromCellId(_loc14_.pop());
         var _loc16_:MapPoint;
         if(!(_loc16_ = MapPoint.fromCellId(_loc11_.disposition.cellId)))
         {
            return param1;
         }
         var _loc17_:int = _loc3_.x - _loc16_.x + _loc15_.x;
         var _loc18_:int = _loc3_.y - _loc16_.y + _loc15_.y;
         if(!MapPoint.isInMap(_loc17_,_loc18_))
         {
            return AtouinConstants.MAP_CELLS_COUNT + 1;
         }
         _loc7_ = MapPoint.fromCoords(_loc17_,_loc18_);
         if(param2)
         {
            (_loc8_ = new Vector.<uint>()).push(_loc16_.cellId);
            _loc8_.push(_loc3_.cellId);
            LinkedCellsManager.getInstance().drawLinks("spellEntryLink",_loc8_,10,TARGET_COLOR.color,1);
            if(_loc7_.cellId < AtouinConstants.MAP_CELLS_COUNT)
            {
               (_loc9_ = new Vector.<uint>()).push(_loc15_.cellId);
               _loc9_.push(_loc7_.cellId);
               LinkedCellsManager.getInstance().drawLinks("spellExitLink",_loc9_,6,TARGET_COLOR.color,1);
            }
         }
         return _loc7_.cellId;
      }
      
      private function castSpell(param1:uint, param2:int = 0) : void
      {
         var _loc3_:GameActionFightCastOnTargetRequestMessage = null;
         var _loc4_:GameActionFightCastRequestMessage = null;
         var _loc5_:FightTurnFrame;
         if(!(_loc5_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame) || !_loc5_.myTurn)
         {
            return;
         }
         if(CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent < this._spellLevel.apCost)
         {
            return;
         }
         if(param2 != 0 && !FightEntitiesFrame.getCurrentInstance().entityIsIllusion(param2))
         {
            CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent - this._spellLevel.apCost;
            _loc3_ = new GameActionFightCastOnTargetRequestMessage();
            _loc3_.initGameActionFightCastOnTargetRequestMessage(this._spellId,param2);
            ConnectionsHandler.getConnection().send(_loc3_);
         }
         else if(this.isValidCell(param1))
         {
            if(this._invocationPreview.length > 0)
            {
               this.removeInvocationPreview();
            }
            CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent - this._spellLevel.apCost;
            (_loc4_ = new GameActionFightCastRequestMessage()).initGameActionFightCastRequestMessage(this._spellId,param1);
            ConnectionsHandler.getConnection().send(_loc4_);
         }
         this.cancelCast();
      }
      
      private function cancelCast(... rest) : void
      {
         this.removeInvocationPreview();
         this._cancelTimer.reset();
         Kernel.getWorker().removeFrame(this);
      }
      
      private function removeRange() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_RANGE);
         if(_loc1_)
         {
            _loc1_.remove();
            this._rangeSelection = null;
         }
         var _loc2_:Selection = SelectionManager.getInstance().getSelection(SELECTION_LOS);
         if(_loc2_)
         {
            _loc2_.remove();
            this._losSelection = null;
         }
         var _loc3_:Selection = SelectionManager.getInstance().getSelection(SELECTION_PORTALS);
         if(_loc3_)
         {
            _loc3_.remove();
            this._portalsSelection = null;
         }
         this._isInfiniteTarget = false;
      }
      
      private function removeTarget() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_TARGET);
         if(_loc1_)
         {
            _loc1_.remove();
            this._rangeSelection = null;
         }
      }
      
      private function cellHasEntity(param1:uint) : Boolean
      {
         var _loc2_:IEntity = null;
         var _loc3_:IEntity = null;
         var _loc4_:Boolean = false;
         var _loc6_:int;
         if((_loc6_ = !!(_loc5_ = EntitiesManager.getInstance().getEntitiesOnCell(param1,AnimatedCharacter))?int(_loc5_.length):0) && this._invocationPreview.length > 0)
         {
            var _loc7_:int = 0;
            var _loc8_:* = _loc5_;
            do
            {
               for each(_loc2_ in _loc8_)
               {
                  _loc4_ = false;
                  for each(_loc3_ in this._invocationPreview)
                  {
                     if(_loc2_.id == _loc3_.id)
                     {
                        _loc6_--;
                        _loc4_ = true;
                        break;
                     }
                  }
                  continue;
               }
            }
            while(_loc4_);
            
            return true;
         }
         return _loc6_ > 0;
      }
      
      private function isValidCell(param1:uint, param2:Boolean = false) : Boolean
      {
         var _loc3_:SpellLevel = null;
         var _loc4_:Array = null;
         var _loc5_:IEntity = null;
         var _loc6_:* = false;
         var _loc7_:Boolean = false;
         var _loc8_:IEntity = null;
         var _loc9_:Boolean = false;
         var _loc10_:CellData;
         if(!(_loc10_ = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param1]) || _loc10_.farmCell)
         {
            return false;
         }
         if(this._isInfiniteTarget)
         {
            return true;
         }
         if(this._spellId)
         {
            _loc3_ = this._spellLevel.spellLevelInfos;
            _loc4_ = EntitiesManager.getInstance().getEntitiesOnCell(param1);
            for each(_loc5_ in _loc4_)
            {
               if(this._invocationPreview.length > 0)
               {
                  _loc7_ = false;
                  for each(_loc8_ in this._invocationPreview)
                  {
                     if(_loc5_.id == _loc8_.id)
                     {
                        _loc7_ = true;
                        break;
                     }
                  }
                  if(_loc7_)
                  {
                     continue;
                  }
               }
               if(!CurrentPlayedFighterManager.getInstance().canCastThisSpell(this._spellLevel.spellId,this._spellLevel.spellLevel,_loc5_.id))
               {
                  return false;
               }
               _loc6_ = _loc5_ is Glyph;
               if(_loc3_.needFreeTrapCell && _loc6_ && (_loc5_ as Glyph).glyphType == GameActionMarkTypeEnum.TRAP)
               {
                  return false;
               }
               if(this._spellLevel.needFreeCell && !_loc6_)
               {
                  return false;
               }
            }
         }
         if(this._targetingThroughPortal && !param2)
         {
            if(!(_loc9_ = this.isValidCell(this.getTargetThroughPortal(param1),true)))
            {
               return false;
            }
         }
         if(this._targetingThroughPortal)
         {
            if(_loc10_.nonWalkableDuringFight)
            {
               return false;
            }
            if(_loc10_.mov)
            {
               return true;
            }
            return false;
         }
         return SelectionManager.getInstance().isInside(param1,SELECTION_LOS);
      }
   }
}
