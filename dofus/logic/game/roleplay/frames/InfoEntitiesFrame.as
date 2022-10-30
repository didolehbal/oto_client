package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.messages.CellOutMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.messages.EntityMovementCompleteMessage;
   import com.ankamagames.atouin.messages.EntityMovementStoppedMessage;
   import com.ankamagames.atouin.messages.MapZoomMessage;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.interactives.StealthBones;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.actions.roleplay.SwitchCreatureModeAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOutAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOverAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleDematerializationAction;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.messages.GameActionFightLeaveMessage;
   import com.ankamagames.dofus.logic.game.roleplay.managers.RoleplayManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDeathMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTeleportOnSameMapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRemoveElementMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightStartingMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightSynchronizeMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.CurrentMapMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.GameRolePlayShowActorMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.TeleportOnSameMapMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionAlliance;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   
   public class InfoEntitiesFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(InfoEntitiesFrame));
       
      
      private var _namesVisible:Boolean = false;
      
      private var _labelContainer:Sprite;
      
      private var _playersNames:Vector.<DisplayedEntity>;
      
      private var _movableEntities:Vector.<uint>;
      
      private var _waitList:Vector.<uint>;
      
      private var _roleplayEntitiesFrame:RoleplayEntitiesFrame;
      
      private var _fightEntitiesFrame:FightEntitiesFrame;
      
      private var _fightContextFrame:FightContextFrame;
      
      public function InfoEntitiesFrame()
      {
         super();
         this._labelContainer = new Sprite();
         this._movableEntities = new Vector.<uint>();
         this._waitList = new Vector.<uint>();
      }
      
      public function pushed() : Boolean
      {
         var _loc1_:int = 0;
         if(!this._namesVisible)
         {
            this._playersNames = new Vector.<DisplayedEntity>();
            if(PlayedCharacterApi.isInFight())
            {
               if(this._fightEntitiesFrame == null)
               {
                  this._fightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
               }
               if(this._fightContextFrame == null)
               {
                  this._fightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               }
               for each(_loc1_ in this._fightEntitiesFrame.getEntitiesIdsList())
               {
                  if(_loc1_ > 0)
                  {
                     this.addEntity(_loc1_,this._fightContextFrame.getFighterName(_loc1_));
                  }
               }
            }
            else
            {
               this.updateEntities();
            }
            this.addListener();
            this._namesVisible = true;
            DisplayObjectContainer(Berilia.getInstance().docMain.getChildAt(StrataEnum.STRATA_WORLD + 1)).addChild(this._labelContainer);
         }
         return true;
      }
      
      public function pulled() : Boolean
      {
         if(this._namesVisible)
         {
            this.removeAllTooltips();
            this._namesVisible = false;
            EnterFrameDispatcher.removeEventListener(this.updateTextsPosition);
            DisplayObjectContainer(Berilia.getInstance().docMain.getChildAt(StrataEnum.STRATA_WORLD + 1)).removeChild(this._labelContainer);
            KernelEventsManager.getInstance().processCallback(HookList.ShowPlayersNames,false);
         }
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:GameMapMovementMessage = null;
         var _loc3_:TeleportOnSameMapMessage = null;
         var _loc4_:GameContextRemoveElementMessage = null;
         var _loc5_:AnimatedCharacter = null;
         var _loc6_:EntityMouseOverMessage = null;
         var _loc7_:CellOverMessage = null;
         var _loc8_:AnimatedCharacter = null;
         var _loc9_:CellOutMessage = null;
         var _loc10_:AnimatedCharacter = null;
         var _loc11_:EntityMouseOutMessage = null;
         var _loc12_:GameActionFightTeleportOnSameMapMessage = null;
         var _loc13_:GameActionFightLeaveMessage = null;
         var _loc14_:GameActionFightDeathMessage = null;
         var _loc15_:IEntity = null;
         var _loc16_:IEntity = null;
         this.addListener();
         switch(true)
         {
            case param1 is CurrentMapMessage:
               this.removeAllTooltips();
               break;
            case param1 is GameMapMovementMessage:
               _loc2_ = param1 as GameMapMovementMessage;
               this.movementHandler(_loc2_.actorId);
               break;
            case param1 is EntityMovementCompleteMessage:
               this.entityMovementCompleteHandler((param1 as EntityMovementCompleteMessage).entity);
               break;
            case param1 is EntityMovementStoppedMessage:
               this.entityMovementCompleteHandler((param1 as EntityMovementStoppedMessage).entity);
               break;
            case param1 is TeleportOnSameMapMessage:
               _loc3_ = param1 as TeleportOnSameMapMessage;
               this.movementHandler(_loc3_.targetId);
               break;
            case param1 is GameRolePlayShowActorMessage:
               this.gameRolePlayShowActorHandler(param1);
               break;
            case param1 is GameContextRemoveElementMessage:
               _loc4_ = param1 as GameContextRemoveElementMessage;
               if(_loc5_ = DofusEntities.getEntity(_loc4_.id) as AnimatedCharacter)
               {
                  _loc5_.removeEventListener(TiphonEvent.RENDER_FAILED,this.onUpdateEntityFail);
                  _loc5_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onUpdateEntitySuccess);
               }
               this.removeElementHandler(_loc4_.id);
               break;
            case param1 is GameFightStartingMessage:
               Kernel.getWorker().removeFrame(this);
               break;
            case param1 is GameFightEndMessage:
               Kernel.getWorker().removeFrame(this);
               break;
            case param1 is EntityMouseOverMessage:
               _loc6_ = param1 as EntityMouseOverMessage;
               this.mouseOverHandler(_loc6_.entity.id);
               break;
            case param1 is CellOverMessage:
               _loc7_ = param1 as CellOverMessage;
               for each(_loc15_ in EntitiesManager.getInstance().getEntitiesOnCell(_loc7_.cellId))
               {
                  if(_loc15_ is AnimatedCharacter && !(_loc15_ as AnimatedCharacter).isMoving)
                  {
                     _loc8_ = _loc15_ as AnimatedCharacter;
                     break;
                  }
               }
               if(_loc8_)
               {
                  this.mouseOverHandler(_loc8_.id);
               }
               break;
            case param1 is CellOutMessage:
               _loc9_ = param1 as CellOutMessage;
               for each(_loc16_ in EntitiesManager.getInstance().getEntitiesOnCell(_loc9_.cellId))
               {
                  if(_loc16_ is AnimatedCharacter)
                  {
                     _loc10_ = _loc16_ as AnimatedCharacter;
                     break;
                  }
               }
               if(_loc10_)
               {
                  this.mouseOutHandler(_loc10_.id);
               }
               break;
            case param1 is TimelineEntityOverAction:
               this.mouseOverHandler((param1 as TimelineEntityOverAction).targetId);
               break;
            case param1 is TimelineEntityOutAction:
               this.mouseOutHandler((param1 as TimelineEntityOutAction).targetId);
               break;
            case param1 is EntityMouseOutMessage:
               _loc11_ = param1 as EntityMouseOutMessage;
               this.mouseOutHandler(_loc11_.entity.id);
               break;
            case param1 is GameActionFightTeleportOnSameMapMessage:
               _loc12_ = param1 as GameActionFightTeleportOnSameMapMessage;
               this.getEntity(_loc12_.targetId).visible = false;
               (DofusEntities.getEntity(_loc12_.targetId) as AnimatedCharacter).addEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
               break;
            case param1 is GameActionFightLeaveMessage:
               _loc13_ = param1 as GameActionFightLeaveMessage;
               this.removeElementHandler(_loc13_.targetId);
               break;
            case param1 is GameActionFightDeathMessage:
               _loc14_ = param1 as GameActionFightDeathMessage;
               this.removeElementHandler(_loc14_.targetId);
               break;
            case param1 is ToggleDematerializationAction:
               this.updateAllTooltipsAfterRender();
               break;
            case param1 is SwitchCreatureModeAction:
               this.updateAllTooltipsAfterRender();
               break;
            case param1 is GameFightSynchronizeMessage:
               this.updateAllTooltips();
               break;
            case param1 is SequenceEndMessage:
               this.updateAllTooltips();
               break;
            case param1 is MapZoomMessage:
               this.updateAllTooltips();
         }
         return false;
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function update() : void
      {
         this.removeAllTooltips();
         this.updateEntities();
         this.updateAllTooltipsAfterRender();
      }
      
      private function movementHandler(param1:int) : void
      {
         var _loc2_:DisplayedEntity = null;
         var _loc3_:IEntity = DofusEntities.getEntity(param1);
         if(!_loc3_)
         {
            _log.warn("The entity " + param1 + " not found.");
         }
         else
         {
            _loc2_ = this.getEntity(_loc3_.id);
            if(_loc2_)
            {
               this._movableEntities.push(this._playersNames.indexOf(_loc2_));
            }
         }
         this.addListener();
      }
      
      private function entityMovementCompleteHandler(param1:IEntity) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayedEntity = this.getEntity(param1.id);
         var _loc4_:int;
         if((_loc4_ = this._playersNames.indexOf(_loc3_)) != -1)
         {
            _loc2_ = this._movableEntities.indexOf(_loc4_);
            this._movableEntities.splice(_loc2_,1);
            _loc3_.target = this.getBounds(param1.id);
            this.updateDisplayedEntityPosition(_loc3_);
         }
      }
      
      private function gameRolePlayShowActorHandler(param1:Object) : void
      {
         var _loc2_:GameRolePlayCharacterInformations = null;
         var _loc3_:int = 0;
         var _loc4_:DisplayedEntity = null;
         var _loc5_:* = null;
         var _loc6_:* = undefined;
         if(param1.informations is GameRolePlayMerchantInformations)
         {
            this.removeElementHandler(param1.informations.contextualId);
         }
         else
         {
            _loc2_ = param1.informations as GameRolePlayCharacterInformations;
            if(_loc2_ == null)
            {
               return;
            }
            _loc3_ = _loc2_.contextualId;
            _loc4_ = this.getEntity(_loc3_);
            _loc5_ = "";
            for each(_loc6_ in _loc2_.humanoidInfo.options)
            {
               if(_loc6_ is HumanOptionAlliance)
               {
                  _loc5_ = "[" + _loc6_.allianceInformations.allianceTag + "]";
               }
            }
            if(_loc4_)
            {
               if(_loc5_ != _loc4_.allianceName)
               {
                  this.removeElementHandler(_loc3_);
                  _loc4_ = null;
               }
               else
               {
                  _loc4_.visible = false;
                  (DofusEntities.getEntity(_loc3_) as AnimatedCharacter).addEventListener(TiphonEvent.RENDER_SUCCEED,this.onAnimationEnd);
               }
            }
            if(!_loc4_)
            {
               this.addEntity(_loc3_,_loc2_.name,_loc5_);
            }
         }
      }
      
      private function removeElementHandler(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DisplayedEntity;
         if((_loc4_ = this.getEntity(param1)) != null)
         {
            _loc2_ = this._playersNames.indexOf(_loc4_);
            if(_loc2_ != -1)
            {
               _loc3_ = this._movableEntities.indexOf(_loc2_);
               if(_loc3_ != -1)
               {
                  this._movableEntities.splice(_loc3_,1);
               }
               this._playersNames.splice(_loc2_,1);
               if(this._labelContainer.contains(_loc4_.text))
               {
                  this._labelContainer.removeChild(_loc4_.text);
               }
               _loc4_.text.removeEventListener(MouseEvent.CLICK,this.onTooltipClicked);
               _loc4_.clear();
               _loc4_ = null;
            }
         }
      }
      
      private function mouseOverHandler(param1:int) : void
      {
         var _loc2_:DisplayedEntity = this.getEntity(param1);
         if(_loc2_ != null)
         {
            _loc2_.visible = false;
         }
      }
      
      private function mouseOutHandler(param1:int) : void
      {
         var _loc2_:DisplayedEntity = this.getEntity(param1);
         if(_loc2_ != null)
         {
            _loc2_.visible = true;
         }
      }
      
      private function onAnimationEnd(param1:TiphonEvent) : void
      {
         var _loc2_:DisplayedEntity = null;
         var _loc3_:AnimatedCharacter = param1.currentTarget as AnimatedCharacter;
         if(_loc3_.hasEventListener(TiphonEvent.ANIMATION_END))
         {
            _loc3_.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
         }
         if(_loc3_.hasEventListener(TiphonEvent.RENDER_SUCCEED))
         {
            _loc3_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onAnimationEnd);
         }
         if(StealthBones.getStealthBonesById((param1.currentTarget as TiphonSprite).look.getBone()))
         {
            this.removeElementHandler(_loc3_.id);
         }
         else
         {
            _loc2_ = this.getEntity(_loc3_.id);
            if(_loc2_)
            {
               _loc2_.visible = true;
               _loc2_.target = this.getBounds(_loc3_.id);
               this.updateDisplayedEntityPosition(_loc2_);
            }
         }
      }
      
      private function updateEntities() : void
      {
         var _loc1_:int = 0;
         var _loc2_:GameRolePlayCharacterInformations = null;
         var _loc3_:* = null;
         var _loc4_:* = undefined;
         if(this._roleplayEntitiesFrame == null)
         {
            this._roleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         }
         var _loc5_:Array = this._roleplayEntitiesFrame.playersId;
         for each(_loc1_ in _loc5_)
         {
            _loc2_ = this._roleplayEntitiesFrame.getEntityInfos(_loc1_) as GameRolePlayCharacterInformations;
            if(_loc2_ != null)
            {
               _loc3_ = "";
               for each(_loc4_ in _loc2_.humanoidInfo.options)
               {
                  if(_loc4_ is HumanOptionAlliance)
                  {
                     _loc3_ = "[" + _loc4_.allianceInformations.allianceTag + "]";
                  }
               }
               this.addEntity(_loc1_,_loc2_.name,_loc3_);
            }
            else
            {
               _log.warn("Entity info for " + _loc1_ + " not found");
            }
         }
      }
      
      private function removeAllTooltips() : void
      {
         var _loc1_:DisplayedEntity = null;
         var _loc2_:int = 0;
         var _loc3_:AnimatedCharacter = null;
         while(this._playersNames.length)
         {
            _loc1_ = this._playersNames.pop();
            if(_loc1_ != null)
            {
               if(this._labelContainer.contains(_loc1_.text))
               {
                  this._labelContainer.removeChild(_loc1_.text);
               }
               _loc3_ = DofusEntities.getEntity(_loc1_.entityId) as AnimatedCharacter;
               if(_loc3_)
               {
                  _loc3_.removeEventListener(TiphonEvent.RENDER_FAILED,this.onUpdateEntityFail);
                  _loc3_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onUpdateEntitySuccess);
               }
               _loc1_.clear();
               _loc1_ = null;
            }
         }
      }
      
      private function getEntity(param1:int) : DisplayedEntity
      {
         var _loc2_:int = 0;
         var _loc3_:int = this._playersNames.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._playersNames[_loc2_].entityId == param1)
            {
               return this._playersNames[_loc2_];
            }
            _loc2_++;
         }
         _log.warn("DisplayedEntity " + param1 + " not found");
         return null;
      }
      
      private function getEntityFromLabel(param1:Label) : DisplayedEntity
      {
         var _loc2_:int = 0;
         var _loc3_:int = this._playersNames.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._playersNames[_loc2_].text == param1)
            {
               return this._playersNames[_loc2_];
            }
            _loc2_++;
         }
         _log.warn("DisplayedEntity not found");
         return null;
      }
      
      private function updateDisplayedEntityPosition(param1:DisplayedEntity) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.target == null || param1.target.width == 0 || param1.target.height == 0)
         {
            this._waitList.push(param1.entityId);
            if(!EnterFrameDispatcher.hasEventListener(this.waitForEntity))
            {
               EnterFrameDispatcher.addEventListener(this.waitForEntity,"wait for entity",5);
            }
         }
         else
         {
            param1.text.x = param1.target.x + (param1.target.width > param1.text.textWidth?(param1.target.width - param1.text.textWidth) / 2:(param1.text.textWidth - param1.target.width) / 2 * -1);
            param1.text.y = param1.target.y - 30;
            if(param1.text.y < 0)
            {
               param1.text.y = 2;
            }
         }
      }
      
      private function addEntity(param1:int, param2:String, param3:String = "") : void
      {
         var _loc4_:Label = null;
         var _loc5_:TiphonSprite = null;
         var _loc6_:DisplayedEntity = null;
         var _loc7_:IEntity = null;
         var _loc8_:int = 0;
         if(this.getEntity(param1) == null)
         {
            (_loc4_ = new Label()).css = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "css/normal.css");
            if(param3 != "")
            {
               _loc4_.text = param2 + " " + param3;
            }
            else
            {
               _loc4_.text = param2;
            }
            _loc4_.mouseEnabled = true;
            _loc4_.bgColor = XmlConfig.getInstance().getEntry("colors.tooltip.bg");
            _loc4_.bgAlpha = XmlConfig.getInstance().getEntry("colors.tooltip.bg.alpha");
            _loc4_.width = _loc4_.textWidth + 7;
            _loc4_.height = _loc4_.height + 4;
            _loc4_.buttonMode = true;
            _loc4_.addEventListener(MouseEvent.CLICK,this.onTooltipClicked);
            if(param1 == PlayedCharacterApi.id())
            {
               _loc4_.colorText = XmlConfig.getInstance().getEntry("colors.tooltip.text.red");
            }
            if((_loc5_ = DofusEntities.getEntity(param1) as TiphonSprite) == null)
            {
               _loc6_ = new DisplayedEntity(param1,_loc4_);
            }
            else
            {
               _loc6_ = new DisplayedEntity(param1,_loc4_,this.getBounds(param1),param3);
               if(StealthBones.getStealthBonesById(_loc5_.look.getBone()))
               {
                  return;
               }
               this._labelContainer.addChild(_loc4_);
            }
            this.updateDisplayedEntityPosition(_loc6_);
            this._playersNames.push(_loc6_);
            if((_loc7_ = DofusEntities.getEntity(param1)) is IMovable)
            {
               if(IMovable(_loc7_).isMoving)
               {
                  this._movableEntities.push(this._playersNames.indexOf(_loc6_));
               }
               else if((_loc8_ = this._movableEntities.indexOf(this._playersNames.indexOf(_loc6_))) != -1)
               {
                  this._movableEntities.splice(_loc8_,1);
               }
            }
         }
      }
      
      public function updateAllTooltips() : void
      {
         var _loc1_:DisplayedEntity = null;
         for each(_loc1_ in this._playersNames)
         {
            _loc1_.target = this.getBounds(_loc1_.entityId);
            this.updateDisplayedEntityPosition(_loc1_);
         }
      }
      
      private function updateAllTooltipsAfterRender() : void
      {
         var _loc1_:DisplayedEntity = null;
         var _loc2_:AnimatedCharacter = null;
         for each(_loc1_ in this._playersNames)
         {
            _loc2_ = DofusEntities.getEntity(_loc1_.entityId) as AnimatedCharacter;
            _loc2_.addEventListener(TiphonEvent.RENDER_FAILED,this.onUpdateEntityFail,false,0,true);
            _loc2_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onUpdateEntitySuccess,false,0,true);
         }
      }
      
      private function onUpdateEntitySuccess(param1:TiphonEvent) : void
      {
         param1.sprite.removeEventListener(TiphonEvent.RENDER_FAILED,this.onUpdateEntityFail);
         param1.sprite.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onUpdateEntitySuccess);
         var _loc2_:DisplayedEntity = this.getEntity(param1.target.id);
         _loc2_.target = this.getBounds(_loc2_.entityId);
         this.updateDisplayedEntityPosition(_loc2_);
      }
      
      private function onUpdateEntityFail(param1:TiphonEvent) : void
      {
         param1.sprite.removeEventListener(TiphonEvent.RENDER_FAILED,this.onUpdateEntityFail);
         param1.sprite.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onUpdateEntitySuccess);
      }
      
      private function onTooltipClicked(param1:MouseEvent) : void
      {
         var _loc2_:DisplayedEntity = null;
         var _loc3_:GameContextActorInformations = null;
         if(!PlayedCharacterManager.getInstance().isFighting)
         {
            _loc2_ = this.getEntityFromLabel(param1.currentTarget as Label);
            _loc3_ = this._roleplayEntitiesFrame.getEntityInfos(_loc2_.entityId);
            if(_loc3_)
            {
               RoleplayManager.getInstance().displayCharacterContextualMenu(_loc3_);
            }
         }
      }
      
      private function updateTextsPosition(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DisplayedEntity = null;
         var _loc5_:int = 0;
         if(!this.removeListener())
         {
            _loc3_ = this._movableEntities.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(!(_loc2_ >= this._movableEntities.length || this._movableEntities[_loc2_] >= this._playersNames.length || this._playersNames[this._movableEntities[_loc2_]] == null))
               {
                  _loc5_ = this._playersNames[this._movableEntities[_loc2_]].entityId;
                  if(_loc4_ = this.getEntity(_loc5_))
                  {
                     _loc4_.target = this.getBounds(_loc5_);
                     this.updateDisplayedEntityPosition(_loc4_);
                  }
               }
               _loc2_ = _loc2_ + 1;
            }
         }
      }
      
      private function addListener() : Boolean
      {
         if(this._movableEntities.length > 0 && !EnterFrameDispatcher.hasEventListener(this.updateTextsPosition))
         {
            EnterFrameDispatcher.addEventListener(this.updateTextsPosition,"Infos Entities",25);
            return true;
         }
         return false;
      }
      
      private function removeListener() : Boolean
      {
         if(this._movableEntities.length <= 0 && EnterFrameDispatcher.hasEventListener(this.updateTextsPosition))
         {
            EnterFrameDispatcher.removeEventListener(this.updateTextsPosition);
            return true;
         }
         return false;
      }
      
      private function waitForEntity(param1:Event) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:DisplayedEntity = null;
         var _loc4_:TiphonSprite = null;
         var _loc5_:DisplayObject = null;
         for each(_loc2_ in this._waitList)
         {
            _loc3_ = this.getEntity(_loc2_);
            if(_loc3_ != null && DofusEntities.getEntity(_loc2_) != null)
            {
               _loc5_ = (_loc4_ = DofusEntities.getEntity(_loc2_) as TiphonSprite).getSlot("Tete");
               _loc3_.target = this.getBounds(_loc2_);
               if(_loc4_ && _loc3_.target.width != 0 && _loc3_.target.height != 0)
               {
                  this._waitList.splice(this._waitList.indexOf(_loc2_),1);
                  if(StealthBones.getStealthBonesById(_loc4_.look.getBone()))
                  {
                     return;
                  }
                  if(!this._labelContainer.contains(_loc3_.text))
                  {
                     this._labelContainer.addChild(_loc3_.text);
                  }
                  this.updateDisplayedEntityPosition(_loc3_);
               }
            }
         }
         if(this._waitList.length <= 0)
         {
            EnterFrameDispatcher.removeEventListener(this.waitForEntity);
         }
      }
      
      private function getBounds(param1:int) : IRectangle
      {
         var _loc2_:IRectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle2 = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:TiphonSprite = null;
         var _loc7_:TiphonSprite;
         if((_loc7_ = DofusEntities.getEntity(param1) as TiphonSprite) == null)
         {
            return null;
         }
         var _loc8_:DisplayObject;
         if(_loc8_ = _loc7_.getSlot("Tete"))
         {
            _loc3_ = _loc8_.getBounds(StageShareManager.stage);
            _loc2_ = _loc4_ = new Rectangle2(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
            if(_loc2_.y <= _loc2_.height)
            {
               if(!(_loc5_ = _loc7_.getSlot("Pied")))
               {
                  if(_loc6_ = _loc7_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite)
                  {
                     _loc5_ = _loc6_.getSlot("Pied");
                  }
               }
               if(_loc5_)
               {
                  _loc3_ = _loc5_.getBounds(StageShareManager.stage);
                  _loc2_ = _loc4_ = new Rectangle2(_loc3_.x,_loc3_.y + _loc2_.height + 30,_loc3_.width,_loc3_.height);
               }
            }
         }
         if(!_loc2_)
         {
            _loc2_ = (_loc7_ as IDisplayable).absoluteBounds;
            if(_loc2_.y <= _loc2_.height)
            {
               _loc2_.y = _loc2_.y + (_loc2_.height + 30);
            }
         }
         return _loc2_;
      }
   }
}

import com.ankamagames.berilia.components.Label;
import com.ankamagames.jerakine.interfaces.IRectangle;

class DisplayedEntity
{
    
   
   public var entityId:int;
   
   public var text:Label;
   
   public var target:IRectangle;
   
   public var allianceName:String;
   
   function DisplayedEntity(param1:int = 0, param2:Label = null, param3:IRectangle = null, param4:String = "")
   {
      super();
      this.entityId = param1;
      this.text = param2;
      this.target = param3;
      this.allianceName = param4;
   }
   
   public function clear() : void
   {
      this.text.remove();
      this.text = null;
      this.target = null;
   }
   
   public function set visible(param1:Boolean) : void
   {
      this.text.visible = param1;
   }
}
