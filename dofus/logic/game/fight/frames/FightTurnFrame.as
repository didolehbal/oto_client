package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.messages.EntityMovementCompleteMessage;
   import com.ankamagames.atouin.messages.MapContainerRollOutMessage;
   import com.ankamagames.atouin.renderers.MovementZoneRenderer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.managers.EmbedFontManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.managers.MapMovementAdapter;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightSpellCastAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightTurnFinishAction;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.TackleUtil;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapNoMovementMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnFinishMessage;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.entities.interfaces.*;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.FontManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.pathfinding.Pathfinding;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.types.positions.PathElement;
   import com.ankamagames.jerakine.types.zones.Custom;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class FightTurnFrame implements Frame
   {
      
      private static const TAKLED_CURSOR_NAME:String = "TackledCursor";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightTurnFrame));
      
      public static const SELECTION_PATH:String = "FightMovementPath";
      
      public static const SELECTION_PATH_UNREACHABLE:String = "FightMovementPathUnreachable";
      
      private static const PATH_COLOR:Color = new Color(26112);
      
      private static const PATH_UNREACHABLE_COLOR:Color = new Color(6684672);
      
      private static const REMIND_TURN_DELAY:uint = 15000;
       
      
      private var _movementSelection:Selection;
      
      private var _movementSelectionUnreachable:Selection;
      
      private var _isRequestingMovement:Boolean;
      
      private var _spellCastFrame:Frame;
      
      private var _finishingTurn:Boolean;
      
      private var _remindTurnTimeoutId:uint;
      
      private var _myTurn:Boolean;
      
      private var _turnDuration:uint;
      
      private var _remainingDurationSeconds:uint;
      
      private var _lastCell:MapPoint;
      
      private var _cursorData:LinkedCursorData = null;
      
      private var _tfAP:TextField;
      
      private var _tfMP:TextField;
      
      private var _cells:Vector.<uint>;
      
      private var _cellsUnreachable:Vector.<uint>;
      
      private var _lastPath:MovementPath;
      
      private var _intervalTurn:Number;
      
      public function FightTurnFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function get myTurn() : Boolean
      {
         return this._myTurn;
      }
      
      public function set myTurn(param1:Boolean) : void
      {
         var _loc2_:* = param1 != this._myTurn;
         var _loc3_:* = !this._myTurn;
         this._myTurn = param1;
         if(param1)
         {
            this.startRemindTurn();
         }
         else
         {
            this._isRequestingMovement = false;
            if(this._remindTurnTimeoutId != 0)
            {
               clearTimeout(this._remindTurnTimeoutId);
            }
            this.removePath();
         }
         var _loc4_:FightContextFrame;
         if(_loc4_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame)
         {
            _loc4_.refreshTimelineOverEntityInfos();
         }
         var _loc5_:FightSpellCastFrame;
         if(_loc5_ = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame)
         {
            if(_loc3_)
            {
               _loc5_.drawRange();
            }
            if(_loc2_)
            {
               if(_loc5_)
               {
                  _loc5_.refreshTarget(true);
               }
            }
         }
         if(this._myTurn && !_loc5_)
         {
            this.drawPath();
         }
      }
      
      public function set turnDuration(param1:uint) : void
      {
         this._turnDuration = param1;
         this._remainingDurationSeconds = Math.floor(param1 / 1000);
         if(this._intervalTurn)
         {
            clearInterval(this._intervalTurn);
         }
         this._intervalTurn = setInterval(this.onSecondTick,1000);
      }
      
      public function get lastPath() : MovementPath
      {
         return this._lastPath;
      }
      
      public function freePlayer() : void
      {
         this._isRequestingMovement = false;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:CellOverMessage = null;
         var _loc3_:GameFightSpellCastAction = null;
         var _loc4_:int = 0;
         var _loc5_:GameFightFighterInformations = null;
         var _loc6_:CellClickMessage = null;
         var _loc7_:EntityMovementCompleteMessage = null;
         var _loc8_:FightContextFrame = null;
         var _loc9_:int = 0;
         var _loc10_:FightEntitiesFrame = null;
         var _loc11_:GameFightFighterInformations = null;
         var _loc12_:IMovable = null;
         var _loc13_:Frame = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:String = null;
         switch(true)
         {
            case param1 is CellOverMessage:
               _loc2_ = param1 as CellOverMessage;
               if(this.myTurn)
               {
                  this._lastCell = _loc2_.cell;
                  this.drawPath(this._lastCell);
               }
               return false;
            case param1 is GameFightSpellCastAction:
               _loc3_ = param1 as GameFightSpellCastAction;
               if(this._spellCastFrame != null)
               {
                  Kernel.getWorker().removeFrame(this._spellCastFrame);
               }
               this.removePath();
               if(this._myTurn)
               {
                  this.startRemindTurn();
               }
               _loc4_ = CurrentPlayedFighterManager.getInstance().currentFighterId;
               if((_loc5_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc4_) as GameFightFighterInformations) && _loc5_.alive)
               {
                  Kernel.getWorker().addFrame(this._spellCastFrame = new FightSpellCastFrame(_loc3_.spellId));
               }
               return true;
            case param1 is CellClickMessage:
               if(!this.myTurn)
               {
                  return false;
               }
               _loc6_ = param1 as CellClickMessage;
               this.askMoveTo(_loc6_.cell);
               return true;
               break;
            case param1 is GameMapNoMovementMessage:
               if(!this.myTurn)
               {
                  return false;
               }
               this._isRequestingMovement = false;
               this.removePath();
               return true;
               break;
            case param1 is EntityMovementCompleteMessage:
               _loc7_ = param1 as EntityMovementCompleteMessage;
               if(_loc8_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame)
               {
                  _loc8_.refreshTimelineOverEntityInfos();
               }
               if(!this.myTurn)
               {
                  return true;
               }
               if(_loc7_.entity.id == CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  this._isRequestingMovement = false;
                  if(!(_loc13_ = Kernel.getWorker().getFrame(FightSpellCastFrame)))
                  {
                     this.drawPath();
                  }
                  this.startRemindTurn();
                  if(this._finishingTurn)
                  {
                     this.finishTurn();
                  }
               }
               return true;
               break;
            case param1 is GameFightTurnFinishAction:
               if(!this.myTurn)
               {
                  return false;
               }
               _loc9_ = CurrentPlayedFighterManager.getInstance().currentFighterId;
               _loc11_ = (_loc10_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).getEntityInfos(_loc9_) as GameFightFighterInformations;
               if(this._remainingDurationSeconds > 0 && !_loc11_.stats.summoned)
               {
                  _loc14_ = CurrentPlayedFighterManager.getInstance().getBasicTurnDuration();
                  _loc15_ = Math.floor(this._remainingDurationSeconds / 2);
                  if(_loc14_ + _loc15_ > 60)
                  {
                     _loc15_ = 60 - _loc14_;
                  }
                  if(_loc15_ > 0)
                  {
                     _loc16_ = I18n.getUiText("ui.fight.secondsAdded",[_loc15_]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc16_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
               }
               _loc9_ = CurrentPlayedFighterManager.getInstance().currentFighterId;
               if(!(_loc12_ = DofusEntities.getEntity(_loc9_) as IMovable))
               {
                  return true;
               }
               if(_loc12_.isMoving)
               {
                  this._finishingTurn = true;
               }
               else
               {
                  this.finishTurn();
               }
               return true;
               break;
            case param1 is MapContainerRollOutMessage:
               this.removePath();
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         if(this._remindTurnTimeoutId != 0)
         {
            clearTimeout(this._remindTurnTimeoutId);
         }
         if(this._intervalTurn)
         {
            clearInterval(this._intervalTurn);
         }
         Atouin.getInstance().cellOverEnabled = false;
         this.removePath();
         Kernel.getWorker().removeFrame(this._spellCastFrame);
         return true;
      }
      
      public function drawPath(param1:MapPoint = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:PathElement = null;
         var _loc6_:Selection = null;
         var _loc7_:Sprite = null;
         var _loc8_:TextFormat = null;
         var _loc9_:GlowFilter = null;
         var _loc16_:int = 0;
         var _loc17_:PathElement = null;
         if(Kernel.getWorker().contains(FightSpellCastFrame))
         {
            return;
         }
         if(this._isRequestingMovement)
         {
            return;
         }
         if(!param1)
         {
            if(FightContextFrame.currentCell == -1)
            {
               return;
            }
            param1 = MapPoint.fromCellId(FightContextFrame.currentCell);
         }
         var _loc10_:IEntity;
         if(!(_loc10_ = DofusEntities.getEntity(CurrentPlayedFighterManager.getInstance().currentFighterId)))
         {
            this.removePath();
            return;
         }
         var _loc11_:CharacterCharacteristicsInformations;
         var _loc12_:int = (_loc11_ = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations()).movementPointsCurrent;
         var _loc13_:int = _loc11_.actionPointsCurrent;
         if(IMovable(_loc10_).isMoving || _loc10_.position.distanceToCell(param1) > _loc11_.movementPointsCurrent)
         {
            this.removePath();
            return;
         }
         var _loc14_:MovementPath;
         if((_loc14_ = Pathfinding.findPath(DataMapProvider.getInstance(),_loc10_.position,param1,false,false,null,null,true)).path.length == 0 || _loc14_.path.length > _loc11_.movementPointsCurrent)
         {
            this.removePath();
            return;
         }
         this._lastPath = _loc14_;
         this._cells = new Vector.<uint>();
         this._cellsUnreachable = new Vector.<uint>();
         var _loc15_:Boolean = true;
         var _loc18_:FightEntitiesFrame;
         var _loc19_:GameFightFighterInformations = (_loc18_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).getEntityInfos(_loc10_.id) as GameFightFighterInformations;
         for each(_loc5_ in _loc14_.path)
         {
            if(_loc15_)
            {
               _loc15_ = false;
            }
            else
            {
               _loc2_ = TackleUtil.getTackle(_loc19_,_loc17_.step);
               _loc3_ = _loc3_ + int((_loc12_ - _loc16_) * (1 - _loc2_) + 0.5);
               if(_loc3_ < 0)
               {
                  _loc3_ = 0;
               }
               if((_loc4_ = _loc4_ + int(_loc13_ * (1 - _loc2_) + 0.5)) < 0)
               {
                  _loc4_ = 0;
               }
               _loc12_ = _loc11_.movementPointsCurrent - _loc3_;
               _loc13_ = _loc11_.actionPointsCurrent - _loc4_;
               if(_loc16_ < _loc12_)
               {
                  this._cells.push(_loc5_.step.cellId);
                  _loc16_++;
               }
               else
               {
                  this._cellsUnreachable.push(_loc5_.step.cellId);
               }
            }
            _loc17_ = _loc5_;
         }
         _loc2_ = TackleUtil.getTackle(_loc19_,_loc17_.step);
         _loc3_ = _loc3_ + int((_loc12_ - _loc16_) * (1 - _loc2_) + 0.5);
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         if((_loc4_ = _loc4_ + int(_loc13_ * (1 - _loc2_) + 0.5)) < 0)
         {
            _loc4_ = 0;
         }
         _loc12_ = _loc11_.movementPointsCurrent - _loc3_;
         _loc13_ = _loc11_.actionPointsCurrent - _loc4_;
         if(_loc16_ < _loc12_)
         {
            this._cells.push(_loc14_.end.cellId);
         }
         else
         {
            this._cellsUnreachable.push(_loc14_.end.cellId);
         }
         if(this._movementSelection == null)
         {
            this._movementSelection = new Selection();
            this._movementSelection.renderer = new MovementZoneRenderer(Dofus.getInstance().options.showMovementDistance);
            this._movementSelection.color = PATH_COLOR;
            SelectionManager.getInstance().addSelection(this._movementSelection,SELECTION_PATH);
         }
         if(this._cellsUnreachable.length > 0)
         {
            if(this._movementSelectionUnreachable == null)
            {
               this._movementSelectionUnreachable = new Selection();
               this._movementSelectionUnreachable.renderer = new MovementZoneRenderer(Dofus.getInstance().options.showMovementDistance,_loc12_ + 1);
               this._movementSelectionUnreachable.color = PATH_UNREACHABLE_COLOR;
               SelectionManager.getInstance().addSelection(this._movementSelectionUnreachable,SELECTION_PATH_UNREACHABLE);
            }
            this._movementSelectionUnreachable.zone = new Custom(this._cellsUnreachable);
            SelectionManager.getInstance().update(SELECTION_PATH_UNREACHABLE);
         }
         else if(_loc6_ = SelectionManager.getInstance().getSelection(SELECTION_PATH_UNREACHABLE))
         {
            _loc6_.remove();
            this._movementSelectionUnreachable = null;
         }
         if(_loc3_ > 0 || _loc4_ > 0)
         {
            if(!this._cursorData)
            {
               _loc7_ = new Sprite();
               this._tfAP = new TextField();
               this._tfAP.selectable = false;
               _loc8_ = new TextFormat(FontManager.getInstance().getRealFontName("Verdana"),16,255,true);
               this._tfAP.defaultTextFormat = _loc8_;
               this._tfAP.setTextFormat(_loc8_);
               this._tfAP.text = "-" + _loc4_ + " " + I18n.getUiText("ui.common.ap");
               if(EmbedFontManager.getInstance().isEmbed(_loc8_.font))
               {
                  this._tfAP.embedFonts = true;
               }
               this._tfAP.width = this._tfAP.textWidth + 5;
               this._tfAP.height = this._tfAP.textHeight;
               _loc7_.addChild(this._tfAP);
               this._tfMP = new TextField();
               this._tfMP.selectable = false;
               _loc8_ = new TextFormat(FontManager.getInstance().getRealFontName("Verdana"),16,26112,true);
               this._tfMP.defaultTextFormat = _loc8_;
               this._tfMP.setTextFormat(_loc8_);
               this._tfMP.text = "-" + _loc3_ + " " + I18n.getUiText("ui.common.mp");
               if(EmbedFontManager.getInstance().isEmbed(_loc8_.font))
               {
                  this._tfMP.embedFonts = true;
               }
               this._tfMP.width = this._tfMP.textWidth + 5;
               this._tfMP.height = this._tfMP.textHeight;
               this._tfMP.y = this._tfAP.height;
               _loc7_.addChild(this._tfMP);
               _loc9_ = new GlowFilter(16777215,1,4,4,3,1);
               _loc7_.filters = [_loc9_];
               this._cursorData = new LinkedCursorData();
               this._cursorData.sprite = _loc7_;
               this._cursorData.sprite.cacheAsBitmap = true;
               this._cursorData.offset = new Point(14,14);
            }
            if(_loc4_ > 0)
            {
               this._tfAP.text = "-" + _loc4_ + " " + I18n.getUiText("ui.common.ap");
               this._tfAP.width = this._tfAP.textWidth + 5;
               this._tfAP.visible = true;
               this._tfMP.y = this._tfAP.height;
            }
            else
            {
               this._tfAP.visible = false;
               this._tfMP.y = 0;
            }
            if(_loc3_ > 0)
            {
               this._tfMP.text = "-" + _loc3_ + " " + I18n.getUiText("ui.common.mp");
               this._tfMP.width = this._tfMP.textWidth + 5;
               this._tfMP.visible = true;
            }
            else
            {
               this._tfMP.visible = false;
            }
            LinkedCursorSpriteManager.getInstance().addItem(TAKLED_CURSOR_NAME,this._cursorData,true);
         }
         else if(LinkedCursorSpriteManager.getInstance().getItem(TAKLED_CURSOR_NAME))
         {
            LinkedCursorSpriteManager.getInstance().removeItem(TAKLED_CURSOR_NAME);
         }
         this._movementSelection.zone = new Custom(this._cells);
         SelectionManager.getInstance().update(SELECTION_PATH,0,true);
      }
      
      public function updatePath() : void
      {
         this.drawPath(this._lastCell);
      }
      
      private function removePath() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_PATH);
         if(_loc1_)
         {
            _loc1_.remove();
            this._movementSelection = null;
         }
         _loc1_ = SelectionManager.getInstance().getSelection(SELECTION_PATH_UNREACHABLE);
         if(_loc1_)
         {
            _loc1_.remove();
            this._movementSelectionUnreachable = null;
         }
         if(LinkedCursorSpriteManager.getInstance().getItem(TAKLED_CURSOR_NAME))
         {
            LinkedCursorSpriteManager.getInstance().removeItem(TAKLED_CURSOR_NAME);
         }
      }
      
      private function askMoveTo(param1:MapPoint) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:PathElement = null;
         var _loc10_:int = 0;
         var _loc11_:PathElement = null;
         if(this._isRequestingMovement)
         {
            return false;
         }
         this._isRequestingMovement = true;
         var _loc4_:IEntity;
         if(!(_loc4_ = DofusEntities.getEntity(CurrentPlayedFighterManager.getInstance().currentFighterId)))
         {
            _log.warn("The player tried to move before its character was added to the scene. Aborting.");
            return this._isRequestingMovement = false;
         }
         if(IMovable(_loc4_).isMoving)
         {
            return this._isRequestingMovement = false;
         }
         var _loc5_:MovementPath = Pathfinding.findPath(DataMapProvider.getInstance(),_loc4_.position,param1,false,false,null,null,true);
         var _loc6_:CharacterCharacteristicsInformations = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations();
         if(_loc5_.path.length == 0 || _loc5_.path.length > _loc6_.movementPointsCurrent)
         {
            return this._isRequestingMovement = false;
         }
         var _loc7_:FightEntitiesFrame;
         var _loc8_:GameFightFighterInformations = (_loc7_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).getEntityInfos(_loc4_.id) as GameFightFighterInformations;
         var _loc9_:Number = TackleUtil.getTackle(_loc8_,_loc4_.position);
         var _loc12_:int = _loc6_.movementPointsCurrent;
         this._cells = new Vector.<uint>();
         for each(_loc3_ in _loc5_.path)
         {
            if(_loc11_)
            {
               _loc9_ = TackleUtil.getTackle(_loc8_,_loc11_.step);
               _loc2_ = _loc2_ + int((_loc12_ - _loc10_) * (1 - _loc9_) + 0.5);
               if(_loc2_ < 0)
               {
                  _loc2_ = 0;
               }
               _loc12_ = _loc6_.movementPointsCurrent - _loc2_;
               if(_loc10_ < _loc12_)
               {
                  this._cells.push(_loc3_.step.cellId);
                  _loc10_++;
               }
               else
               {
                  this._cellsUnreachable.push(_loc3_.step.cellId);
               }
            }
            _loc11_ = _loc3_;
         }
         if(_loc12_ < _loc5_.length)
         {
            _loc5_.end = _loc5_.getPointAtIndex(_loc12_).step;
            _loc5_.deletePoint(_loc12_,0);
         }
         var _loc13_:GameMapMovementRequestMessage;
         (_loc13_ = new GameMapMovementRequestMessage()).initGameMapMovementRequestMessage(MapMovementAdapter.getServerMovement(_loc5_),PlayedCharacterManager.getInstance().currentMap.mapId);
         ConnectionsHandler.getConnection().send(_loc13_);
         this.removePath();
         return true;
      }
      
      private function finishTurn() : void
      {
         var _loc1_:GameFightTurnFinishMessage = new GameFightTurnFinishMessage();
         ConnectionsHandler.getConnection().send(_loc1_);
         this._finishingTurn = false;
      }
      
      private function startRemindTurn() : void
      {
         if(!this._myTurn)
         {
            return;
         }
         if(this._turnDuration > 0 && Dofus.getInstance().options.remindTurn)
         {
            if(this._remindTurnTimeoutId != 0)
            {
               clearTimeout(this._remindTurnTimeoutId);
            }
            this._remindTurnTimeoutId = setTimeout(this.remindTurn,REMIND_TURN_DELAY);
         }
      }
      
      private function remindTurn() : void
      {
         var _loc1_:String = I18n.getUiText("ui.fight.inactivity");
         KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc1_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
         KernelEventsManager.getInstance().processCallback(FightHookList.RemindTurn);
         clearTimeout(this._remindTurnTimeoutId);
         this._remindTurnTimeoutId = 0;
      }
      
      public function onSecondTick() : void
      {
         if(this._remainingDurationSeconds > 0)
         {
            --this._remainingDurationSeconds;
         }
         else
         {
            clearInterval(this._intervalTurn);
         }
      }
   }
}
