package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.berilia.frames.ShortcutsFrame;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.dofus.datacenter.interactives.Interactive;
   import com.ankamagames.dofus.datacenter.interactives.SkillName;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.actions.ChangeWorldInteractionAction;
   import com.ankamagames.dofus.logic.common.managers.NotificationManager;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementActivationMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementMouseOutMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementMouseOverMessage;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.CompassTypeEnum;
   import com.ankamagames.dofus.network.enums.MapObstacleStateEnum;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapObstacleUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveElementUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveMapUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUseEndedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUseErrorMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUsedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.StatedElementUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.StatedMapUpdateMessage;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElementNamedSkill;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElementSkill;
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.dofus.network.types.game.interactive.StatedElement;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.enums.NotificationTypeEnum;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.enum.OperatingSystem;
   import com.ankamagames.jerakine.handlers.FocusHandler;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyDownMessage;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyUpMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.FiltersManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.managers.PerformanceManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.SetDirectionStep;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   
   public class RoleplayInteractivesFrame implements Frame
   {
      
      private static const INTERACTIVE_CURSOR_0:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_0;
      
      private static const INTERACTIVE_CURSOR_1:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_1;
      
      private static const INTERACTIVE_CURSOR_2:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_2;
      
      private static const INTERACTIVE_CURSOR_3:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_3;
      
      private static const INTERACTIVE_CURSOR_4:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_4;
      
      private static const INTERACTIVE_CURSOR_5:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_5;
      
      private static const INTERACTIVE_CURSOR_6:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_6;
      
      private static const INTERACTIVE_CURSOR_7:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_7;
      
      private static const INTERACTIVE_CURSOR_8:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_8;
      
      private static const INTERACTIVE_CURSOR_9:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_9;
      
      private static const INTERACTIVE_CURSOR_10:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_10;
      
      private static const INTERACTIVE_CURSOR_DISABLED:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_DISABLED;
      
      private static var cursorList:Array = new Array();
      
      private static var cursorClassList:Array;
      
      private static const INTERACTIVE_CURSOR_OFFSET:Point = new Point(0,0);
      
      private static const INTERACTIVE_CURSOR_NAME:String = "interactiveCursor";
      
      private static const LUMINOSITY_FACTOR:Number = 1.2;
      
      private static const LUMINOSITY_EFFECTS:ColorMatrixFilter = new ColorMatrixFilter([LUMINOSITY_FACTOR,0,0,0,0,0,LUMINOSITY_FACTOR,0,0,0,0,0,LUMINOSITY_FACTOR,0,0,0,0,0,1,0]);
      
      private static const HIGHLIGHT_HINT_FILTER:GlowFilter = new GlowFilter(16777215,0.8,6,6,4,1);
      
      private static const ALPHA_MODIFICATOR:Number = 0.2;
      
      private static const COLLECTABLE_COLLECTING_STATE_ID:uint = 2;
      
      private static const COLLECTABLE_CUT_STATE_ID:uint = 1;
      
      private static const ACTION_COLLECTABLE_RESOURCES:uint = 1;
      
      public static var currentlyHighlighted:Sprite;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayInteractivesFrame));
       
      
      private var _modContextMenu:Object;
      
      private var _ie:Dictionary;
      
      private var _currentUsages:Array;
      
      private var _baseAlpha:Number;
      
      private var i:int;
      
      private var _entities:Dictionary;
      
      private var _usingInteractive:Boolean = false;
      
      private var _nextInteractiveUsed:Object;
      
      private var _interactiveActionTimers:Dictionary;
      
      private var _enableWorldInteraction:Boolean = true;
      
      private var _collectableSpritesToBeStopped:Dictionary;
      
      private var _currentRequestedElementId:int = -1;
      
      private var _currentUsedElementId:int = -1;
      
      private var _statedElementsTargetAnimation:Dictionary;
      
      private var dirmov:uint = 666;
      
      private var isElementsHighLighted = false;
      
      public function RoleplayInteractivesFrame()
      {
         this._ie = new Dictionary(true);
         this._currentUsages = new Array();
         this._entities = new Dictionary();
         this._interactiveActionTimers = new Dictionary(true);
         this._collectableSpritesToBeStopped = new Dictionary(true);
         this._statedElementsTargetAnimation = new Dictionary(true);
         super();
         this._modContextMenu = UiModuleManager.getInstance().getModule("Ankama_ContextMenu").mainClass;
         if(!cursorClassList)
         {
            cursorClassList = new Array();
            cursorClassList[0] = INTERACTIVE_CURSOR_0;
            cursorClassList[1] = INTERACTIVE_CURSOR_1;
            cursorClassList[2] = INTERACTIVE_CURSOR_2;
            cursorClassList[3] = INTERACTIVE_CURSOR_3;
            cursorClassList[4] = INTERACTIVE_CURSOR_4;
            cursorClassList[5] = INTERACTIVE_CURSOR_5;
            cursorClassList[6] = INTERACTIVE_CURSOR_6;
            cursorClassList[7] = INTERACTIVE_CURSOR_7;
            cursorClassList[8] = INTERACTIVE_CURSOR_8;
            cursorClassList[9] = INTERACTIVE_CURSOR_9;
            cursorClassList[10] = INTERACTIVE_CURSOR_10;
            cursorClassList[11] = INTERACTIVE_CURSOR_DISABLED;
         }
      }
      
      public static function getCursor(param1:int, param2:Boolean = true, param3:Boolean = true) : Sprite
      {
         var _loc4_:Sprite = null;
         var _loc5_:Sprite = null;
         var _loc6_:Class = null;
         if(!param2)
         {
            if(cursorList[11])
            {
               _loc4_ = cursorList[11];
            }
            else if(_loc6_ = cursorClassList[11])
            {
               _loc4_ = new _loc6_();
               cursorList[11] = _loc4_;
            }
         }
         if(cursorList[param1] && param3)
         {
            _loc5_ = cursorList[param1];
         }
         if(_loc6_ = cursorClassList[param1])
         {
            _loc5_ = new _loc6_();
            if(param3)
            {
               cursorList[param1] = _loc5_;
            }
            _loc5_.cacheAsBitmap = true;
            if(_loc4_ != null)
            {
               _loc5_.addChild(_loc4_);
            }
         }
         if(_loc5_)
         {
            if(_loc4_ != null)
            {
               _loc5_.addChild(_loc4_);
            }
            else if(_loc5_.numChildren > 1)
            {
               _loc5_.removeChildAt(0);
            }
            return _loc5_;
         }
         return new INTERACTIVE_CURSOR_0();
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      private function get roleplayContextFrame() : RoleplayContextFrame
      {
         return Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
      }
      
      private function get roleplayWorldFrame() : RoleplayWorldFrame
      {
         return Kernel.getWorker().getFrame(RoleplayWorldFrame) as RoleplayWorldFrame;
      }
      
      public function get currentRequestedElementId() : int
      {
         return this._currentRequestedElementId;
      }
      
      public function set currentRequestedElementId(param1:int) : void
      {
         this._currentRequestedElementId = param1;
      }
      
      public function get usingInteractive() : Boolean
      {
         return this._usingInteractive;
      }
      
      public function get nextInteractiveUsed() : Object
      {
         return this._nextInteractiveUsed;
      }
      
      public function set nextInteractiveUsed(param1:Object) : void
      {
         this._nextInteractiveUsed = param1;
      }
      
      public function get worldInteractionIsEnable() : Boolean
      {
         return this._enableWorldInteraction;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var imumsg:InteractiveMapUpdateMessage = null;
         var mousePos:Point = null;
         var objectsUnder:Array = null;
         var o:DisplayObject = null;
         var ieumsg:InteractiveElementUpdatedMessage = null;
         var iumsg:InteractiveUsedMessage = null;
         var worldPos:MapPoint = null;
         var user:IEntity = null;
         var iuem:InteractiveUseErrorMessage = null;
         var smumsg:StatedMapUpdateMessage = null;
         var seumsg:StatedElementUpdatedMessage = null;
         var moumsg:MapObstacleUpdateMessage = null;
         var iuemsg:InteractiveUseEndedMessage = null;
         var iemimsg:InteractiveElementMouseOverMessage = null;
         var kkdm:KeyboardKeyDownMessage = null;
         var kkum:KeyboardKeyUpMessage = null;
         var iel:Object = null;
         var ie:InteractiveElement = null;
         var useAnimation:String = null;
         var useDirection:uint = 0;
         var t:Timer = null;
         var tiphonSprite:TiphonSprite = null;
         var currentSpriteAnimation:String = null;
         var fct:Function = null;
         var seq:SerialSequencer = null;
         var sprite:TiphonSprite = null;
         var rwf:RoleplayWorldFrame = null;
         var se:StatedElement = null;
         var mo:MapObstacle = null;
         var msg:Message = param1;
         var ieObj:* = undefined;
         switch(true)
         {
            case msg is InteractiveMapUpdateMessage:
               imumsg = msg as InteractiveMapUpdateMessage;
               this.clear();
               for each(ie in imumsg.interactiveElements)
               {
                  if(ie.enabledSkills.length)
                  {
                     this.registerInteractive(ie,ie.enabledSkills[0].skillId);
                  }
                  else if(ie.disabledSkills.length)
                  {
                     this.registerInteractive(ie,ie.disabledSkills[0].skillId);
                  }
               }
               mousePos = new Point(StageShareManager.stage.mouseX,StageShareManager.stage.mouseY);
               objectsUnder = StageShareManager.stage.getObjectsUnderPoint(mousePos);
               for each(o in objectsUnder)
               {
                  for(ieObj in this._ie)
                  {
                     if(ieObj.contains(o))
                     {
                        Kernel.getWorker().process(new InteractiveElementMouseOverMessage(this._ie[ieObj].element,ieObj));
                        return true;
                     }
                  }
               }
               return true;
            case msg is InteractiveElementUpdatedMessage:
               ieumsg = msg as InteractiveElementUpdatedMessage;
               if(ieumsg.interactiveElement.enabledSkills.length)
               {
                  this.registerInteractive(ieumsg.interactiveElement,ieumsg.interactiveElement.enabledSkills[0].skillId);
               }
               else if(ieumsg.interactiveElement.disabledSkills.length)
               {
                  this.registerInteractive(ieumsg.interactiveElement,ieumsg.interactiveElement.disabledSkills[0].skillId);
               }
               else
               {
                  this.removeInteractive(ieumsg.interactiveElement);
               }
               return true;
            case msg is InteractiveUsedMessage:
               iumsg = msg as InteractiveUsedMessage;
               if(PlayedCharacterManager.getInstance().id == iumsg.entityId)
               {
                  this._currentUsedElementId = iumsg.elemId;
               }
               if(this._currentRequestedElementId == iumsg.elemId)
               {
                  this._currentRequestedElementId = -1;
               }
               worldPos = Atouin.getInstance().getIdentifiedElementPosition(iumsg.elemId);
               user = DofusEntities.getEntity(iumsg.entityId);
               if(user is IAnimated)
               {
                  useAnimation = Skill.getSkillById(iumsg.skillId).useAnimation;
                  useDirection = this.getUseDirection(user as TiphonSprite,useAnimation,worldPos);
                  if(iumsg.duration > 0)
                  {
                     if(!this._interactiveActionTimers[user])
                     {
                        this._interactiveActionTimers[user] = new Timer(1,1);
                     }
                     t = this._interactiveActionTimers[user];
                     if(t.running)
                     {
                        t.stop();
                        t.dispatchEvent(new TimerEvent(TimerEvent.TIMER));
                     }
                     tiphonSprite = user as TiphonSprite;
                     tiphonSprite.setAnimationAndDirection(useAnimation,useDirection);
                     currentSpriteAnimation = tiphonSprite.getAnimation();
                     t.delay = iumsg.duration * 100;
                     fct = function():void
                     {
                        var _loc1_:TiphonSprite = null;
                        t.removeEventListener(TimerEvent.TIMER,fct);
                        if(currentSpriteAnimation.indexOf((user as TiphonSprite).getAnimation()) != -1)
                        {
                           _loc1_ = user as TiphonSprite;
                           if(_loc1_ is AnimatedCharacter && _loc1_.getDirection() != DirectionsEnum.DOWN)
                           {
                              (_loc1_ as AnimatedCharacter).visibleAura = false;
                           }
                           _loc1_.setAnimation(AnimationEnum.ANIM_STATIQUE);
                        }
                     };
                     if(!t.hasEventListener(TimerEvent.TIMER))
                     {
                        t.addEventListener(TimerEvent.TIMER,fct);
                     }
                     t.start();
                  }
                  else
                  {
                     seq = new SerialSequencer();
                     sprite = user as TiphonSprite;
                     seq.addStep(new SetDirectionStep(sprite,useDirection));
                     seq.addStep(new PlayAnimationStep(sprite,useAnimation));
                     seq.start();
                  }
               }
               if(iumsg.duration > 0)
               {
                  if(PlayedCharacterManager.getInstance().id == iumsg.entityId)
                  {
                     this._usingInteractive = true;
                     this.resetInteractiveApparence(false);
                     rwf = this.roleplayWorldFrame;
                     if(rwf)
                     {
                        rwf.cellClickEnabled = false;
                     }
                  }
                  this._entities[iumsg.elemId] = iumsg.entityId;
               }
               return true;
            case msg is InteractiveUseErrorMessage:
               iuem = msg as InteractiveUseErrorMessage;
               if(iuem.elemId == this._currentRequestedElementId)
               {
                  this._currentRequestedElementId = -1;
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.popup.impossible_action"),ChatFrame.RED_CHANNEL_ID);
               return true;
            case msg is StatedMapUpdateMessage:
               smumsg = msg as StatedMapUpdateMessage;
               this._usingInteractive = false;
               for each(se in smumsg.statedElements)
               {
                  this.updateStatedElement(se,true);
               }
               return true;
            case msg is StatedElementUpdatedMessage:
               seumsg = msg as StatedElementUpdatedMessage;
               this.updateStatedElement(seumsg.statedElement);
               return true;
            case msg is MapObstacleUpdateMessage:
               moumsg = msg as MapObstacleUpdateMessage;
               for each(mo in moumsg.obstacles)
               {
                  InteractiveCellManager.getInstance().updateCell(mo.obstacleCellId,mo.state == MapObstacleStateEnum.OBSTACLE_OPENED);
               }
               return true;
            case msg is InteractiveUseEndedMessage:
               iuemsg = InteractiveUseEndedMessage(msg);
               this.interactiveUsageFinished(this._entities[iuemsg.elemId],iuemsg.elemId,iuemsg.skillId);
               delete this._entities[iuemsg.elemId];
               return true;
            case msg is InteractiveElementMouseOverMessage:
               if(!AirScanner.isStreamingVersion() && OptionManager.getOptionManager("dofus")["enableForceWalk"] == true && (ShortcutsFrame.ctrlKeyDown || SystemManager.getSingleton().os == OperatingSystem.MAC_OS && ShortcutsFrame.altKeyDown))
               {
                  return false;
               }
               iemimsg = msg as InteractiveElementMouseOverMessage;
               iel = this._ie[iemimsg.sprite];
               if(iel && iel.element)
               {
                  this.highlightInteractiveApparence(iemimsg.sprite,iel.firstSkill,iel.element.enabledSkills.length > 0);
               }
               return false;
               break;
            case msg is InteractiveElementMouseOutMessage:
               this.resetInteractiveApparence();
               currentlyHighlighted = null;
               return false;
            case msg is KeyboardKeyDownMessage:
               kkdm = msg as KeyboardKeyDownMessage;
               if(kkdm.keyboardEvent.keyCode == Keyboard.Y && !this.isElementsHighLighted && !(FocusHandler.getInstance().getFocus() is TextField))
               {
                  this.highlightInteractiveElements(true);
                  this.isElementsHighLighted = true;
               }
               return false;
            case msg is KeyboardKeyUpMessage:
               kkum = msg as KeyboardKeyUpMessage;
               if(kkum.keyboardEvent.keyCode == Keyboard.Y)
               {
                  this.highlightInteractiveElements(false);
                  this.isElementsHighLighted = false;
               }
               return false;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         var _loc1_:* = undefined;
         var _loc2_:TiphonSprite = null;
         for(_loc1_ in this._collectableSpritesToBeStopped)
         {
            _loc2_ = _loc1_ as TiphonSprite;
            if(_loc2_)
            {
               _loc2_.setAnimationAndDirection("AnimState" + COLLECTABLE_CUT_STATE_ID,0);
            }
         }
         this._collectableSpritesToBeStopped = new Dictionary(true);
         this._entities = new Dictionary();
         this._ie = new Dictionary(true);
         this._modContextMenu = null;
         this._currentUsages = new Array();
         this._nextInteractiveUsed = null;
         this._interactiveActionTimers = new Dictionary(true);
         return true;
      }
      
      public function enableWorldInteraction(param1:Boolean) : void
      {
         this._enableWorldInteraction = param1;
      }
      
      public function clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         for each(_loc1_ in this._currentUsages)
         {
            clearTimeout(_loc1_);
         }
         for each(_loc2_ in this._ie)
         {
            this.removeInteractive(_loc2_.element as InteractiveElement);
         }
      }
      
      public function getInteractiveElementsCells() : Vector.<uint>
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = new Vector.<uint>();
         for each(_loc1_ in this._ie)
         {
            if(_loc1_ != null)
            {
               _loc2_.push(_loc1_.position.cellId);
            }
         }
         return _loc2_;
      }
      
      public function getInteractiveActionTimer(param1:*) : Timer
      {
         return this._interactiveActionTimers[param1];
      }
      
      public function isElementChangingState(param1:int) : Boolean
      {
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         for each(_loc2_ in this._statedElementsTargetAnimation)
         {
            if(_loc2_.elemId == param1)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public function getUseDirection(param1:TiphonSprite, param2:String, param3:MapPoint) : uint
      {
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:MapPoint;
         if((_loc6_ = (param1 as IMovable).position).x == param3.x && _loc6_.y == param3.y)
         {
            _loc4_ = param1.getDirection();
         }
         else
         {
            _loc4_ = (param1 as IMovable).position.advancedOrientationTo(param3,true);
         }
         var _loc7_:Array;
         if((_loc7_ = param1.getAvaibleDirection(param2))[5])
         {
            _loc7_[7] = true;
         }
         if(_loc7_[1])
         {
            _loc7_[3] = true;
         }
         if(_loc7_[7])
         {
            _loc7_[5] = true;
         }
         if(_loc7_[3])
         {
            _loc7_[1] = true;
         }
         if(_loc7_[_loc4_] == false)
         {
            _loc5_ = 0;
            while(_loc5_ < 8)
            {
               if(_loc4_ == 7)
               {
                  _loc4_ = 0;
               }
               else
               {
                  _loc4_++;
               }
               if(_loc7_[_loc4_] == true)
               {
                  break;
               }
               _loc5_++;
            }
         }
         return _loc4_;
      }
      
      private function registerInteractive(param1:InteractiveElement, param2:int) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:* = null;
         var _loc5_:InteractiveElement = null;
         var _loc6_:InteractiveObject;
         if(!(_loc6_ = Atouin.getInstance().getIdentifiedElement(param1.elementId)))
         {
            _log.error("Unknown identified element " + param1.elementId + ", unable to register it as interactive.");
            return;
         }
         var _loc7_:RoleplayEntitiesFrame;
         if(_loc7_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame)
         {
            _loc3_ = false;
            for(_loc4_ in _loc7_.interactiveElements)
            {
               if((_loc5_ = _loc7_.interactiveElements[int(_loc4_)]).elementId == param1.elementId)
               {
                  _loc3_ = true;
                  _loc7_.interactiveElements[int(_loc4_)] = param1;
                  break;
               }
            }
            if(!_loc3_)
            {
               _loc7_.interactiveElements.push(param1);
            }
         }
         var _loc8_:MapPoint = Atouin.getInstance().getIdentifiedElementPosition(param1.elementId);
         if(!_loc6_.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            _loc6_.addEventListener(MouseEvent.MOUSE_OVER,this.over,false,0,true);
            _loc6_.addEventListener(MouseEvent.MOUSE_OUT,this.out,false,0,true);
            _loc6_.addEventListener(MouseEvent.CLICK,this.click,false,0,true);
            _log.debug("Add interaction for element " + param1.elementId + " on cell " + _loc8_.cellId + " with " + (!!param1.enabledSkills?param1.enabledSkills.length:0) + " skill actifs");
         }
         if(_loc6_ is Sprite)
         {
            (_loc6_ as Sprite).useHandCursor = true;
            (_loc6_ as Sprite).buttonMode = true;
         }
         this._ie[_loc6_] = {
            "element":param1,
            "position":_loc8_,
            "firstSkill":param2
         };
      }
      
      private function removeInteractive(param1:InteractiveElement) : void
      {
         var _loc2_:InteractiveObject = Atouin.getInstance().getIdentifiedElement(param1.elementId);
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
            _loc2_.removeEventListener(MouseEvent.CLICK,this.click);
            if(_loc2_ is Sprite)
            {
               (_loc2_ as Sprite).useHandCursor = false;
               (_loc2_ as Sprite).buttonMode = false;
            }
         }
         if(currentlyHighlighted == _loc2_ as Sprite)
         {
            this.resetInteractiveApparence();
         }
         delete this._ie[_loc2_];
      }
      
      private function updateStatedElement(param1:StatedElement, param2:Boolean = false) : void
      {
         var _loc3_:Interactive = null;
         var _loc4_:Boolean = false;
         var _loc5_:Skill = null;
         var _loc6_:InteractiveElementSkill = null;
         var _loc7_:InteractiveObject;
         if(!(_loc7_ = Atouin.getInstance().getIdentifiedElement(param1.elementId)))
         {
            _log.error("Unknown identified element " + param1.elementId + "; unable to change its state to " + param1.elementState + " !");
            return;
         }
         var _loc8_:TiphonSprite;
         if(!(_loc8_ = _loc7_ is DisplayObjectContainer?this.findTiphonSprite(_loc7_ as DisplayObjectContainer):null))
         {
            _log.warn("Unable to find an animated element for the stated element " + param1.elementId + " on cell " + param1.elementCellId + ", this element is probably invisible or is not configured as an animated element.");
            return;
         }
         if(param1.elementId == this._currentUsedElementId)
         {
            this._usingInteractive = true;
            this.resetInteractiveApparence();
         }
         if(this._ie[_loc7_] && this._ie[_loc7_].element && this._ie[_loc7_].element.elementId == param1.elementId)
         {
            _loc3_ = Interactive.getInteractiveById(this._ie[_loc7_].element.elementTypeId);
            if(_loc3_)
            {
               _loc4_ = false;
               for each(_loc6_ in this._ie[_loc7_].element.enabledSkills)
               {
                  if((_loc5_ = Skill.getSkillById(_loc6_.skillId)).elementActionId == ACTION_COLLECTABLE_RESOURCES)
                  {
                     _loc4_ = true;
                  }
               }
               for each(_loc6_ in this._ie[_loc7_].element.disabledSkills)
               {
                  if((_loc5_ = Skill.getSkillById(_loc6_.skillId)).elementActionId == ACTION_COLLECTABLE_RESOURCES)
                  {
                     _loc4_ = true;
                  }
               }
               if(_loc4_)
               {
                  this._collectableSpritesToBeStopped[_loc8_] = null;
               }
               else
               {
                  this._statedElementsTargetAnimation[_loc8_] = {
                     "elemId":param1.elementId,
                     "animation":"AnimState" + param1.elementState
                  };
                  _loc8_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onAnimRendered);
               }
            }
         }
         else
         {
            delete this._collectableSpritesToBeStopped[_loc8_];
         }
         _loc8_.setAnimationAndDirection("AnimState" + param1.elementState,0,param2);
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
      
      private function highlightInteractiveApparence(param1:Sprite, param2:int, param3:Boolean = true) : void
      {
         var _loc4_:LinkedCursorData = null;
         var _loc5_:Object;
         if(!(_loc5_ = this._ie[param1]))
         {
            return;
         }
         if(currentlyHighlighted != null)
         {
            this.resetInteractiveApparence(false);
         }
         if(param1.getChildAt(0) is TiphonSprite)
         {
            FiltersManager.getInstance().addEffect((param1.getChildAt(0) as TiphonSprite).rawAnimation,LUMINOSITY_EFFECTS);
         }
         else
         {
            FiltersManager.getInstance().addEffect(param1,LUMINOSITY_EFFECTS);
         }
         if(MapDisplayManager.getInstance().isBoundingBox(_loc5_.element.elementId))
         {
            param1.alpha = ALPHA_MODIFICATOR;
         }
         if(PlayedCharacterManager.getInstance().state == PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING && !PerformanceManager.optimize)
         {
            (_loc4_ = new LinkedCursorData()).sprite = getCursor(Skill.getSkillById(param2).cursor,param3);
            Mouse.hide();
            _loc4_.offset = INTERACTIVE_CURSOR_OFFSET;
            LinkedCursorSpriteManager.getInstance().addItem(INTERACTIVE_CURSOR_NAME,_loc4_);
         }
         currentlyHighlighted = param1;
      }
      
      private function resetInteractiveApparence(param1:Boolean = true) : void
      {
         if(currentlyHighlighted == null)
         {
            return;
         }
         if(param1 && currentlyHighlighted.getChildAt(0) is TiphonSprite)
         {
            FiltersManager.getInstance().removeEffect((currentlyHighlighted.getChildAt(0) as TiphonSprite).rawAnimation,LUMINOSITY_EFFECTS);
         }
         else if(param1)
         {
            FiltersManager.getInstance().removeEffect(currentlyHighlighted,LUMINOSITY_EFFECTS);
         }
         if(param1)
         {
            LinkedCursorSpriteManager.getInstance().removeItem(INTERACTIVE_CURSOR_NAME);
            Mouse.show();
         }
         var _loc2_:Object = this._ie[currentlyHighlighted];
         if(!_loc2_)
         {
            return;
         }
         if(MapDisplayManager.getInstance().isBoundingBox(_loc2_.element.elementId))
         {
            currentlyHighlighted.alpha = 0;
            currentlyHighlighted = null;
         }
      }
      
      private function over(param1:MouseEvent) : void
      {
         if(!this.roleplayWorldFrame || !this.roleplayContextFrame.hasWorldInteraction)
         {
            return;
         }
         var _loc2_:Object = this._ie[param1.target as Sprite];
         if(_loc2_ && param1)
         {
            Kernel.getWorker().process(new InteractiveElementMouseOverMessage(_loc2_.element,param1.target));
         }
      }
      
      private function out(param1:Object) : void
      {
         var _loc2_:Object = this._ie[param1.target as Sprite];
         if(_loc2_)
         {
            Kernel.getWorker().process(new InteractiveElementMouseOutMessage(_loc2_.element));
         }
      }
      
      private function click(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:InteractiveElementSkill = null;
         var _loc4_:Skill = null;
         var _loc5_:Array = null;
         var _loc6_:InteractiveElementSkill = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:KnownJobWrapper = null;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:Object = null;
         var _loc16_:Interactive = null;
         if(!this.roleplayWorldFrame || !this.roleplayContextFrame.hasWorldInteraction)
         {
            return;
         }
         TooltipManager.hide();
         var _loc15_:Object;
         if((_loc15_ = this._ie[param1.target as Sprite]).element.elementTypeId > 0)
         {
            _loc16_ = Interactive.getInteractiveById(_loc15_.element.elementTypeId);
         }
         if(!AirScanner.isStreamingVersion() && OptionManager.getOptionManager("dofus")["enableForceWalk"] == true && (ShortcutsFrame.ctrlKeyDown || SystemManager.getSingleton().os == OperatingSystem.MAC_OS && ShortcutsFrame.altKeyDown))
         {
            this.out(param1);
            InteractiveCellManager.getInstance().getCell(_loc15_.position.cellId).dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            return;
         }
         var _loc17_:Array = [];
         for each(_loc3_ in _loc15_.element.enabledSkills)
         {
            if(_loc3_ is InteractiveElementNamedSkill)
            {
               _loc2_ = SkillName.getSkillNameById((_loc3_ as InteractiveElementNamedSkill).nameId).name;
            }
            else
            {
               _loc2_ = Skill.getSkillById(_loc3_.skillId).name;
            }
            _loc17_.push({
               "id":_loc3_.skillId,
               "instanceId":_loc3_.skillInstanceUid,
               "name":_loc2_,
               "enabled":true
            });
         }
         _loc5_ = new Array();
         for each(_loc6_ in _loc15_.element.disabledSkills)
         {
            if(_loc6_ is InteractiveElementNamedSkill)
            {
               _loc2_ = SkillName.getSkillNameById((_loc6_ as InteractiveElementNamedSkill).nameId).name;
            }
            else
            {
               _loc2_ = Skill.getSkillById(_loc6_.skillId).name;
            }
            _loc2_ = (_loc4_ = Skill.getSkillById(_loc6_.skillId)).name;
            if(_loc4_.parentJobId != 1)
            {
               if((_loc11_ = PlayedCharacterManager.getInstance().jobs[_loc4_.parentJobId]) == null)
               {
                  (_loc10_ = new Object()).job = _loc4_.parentJob.name;
                  _loc10_.jobId = _loc4_.parentJob.id;
                  _loc10_.type = "job";
                  _loc10_.value = [_loc4_.parentJob.name];
               }
               else if((_loc12_ = _loc11_.jobLevel) < _loc4_.levelMin)
               {
                  (_loc10_ = new Object()).job = _loc4_.parentJob.name;
                  _loc10_.jobId = _loc4_.parentJob.id;
                  _loc10_.type = "level";
                  _loc10_.value = [_loc4_.parentJob.name,_loc4_.levelMin,_loc12_];
               }
               if(_loc10_ != null)
               {
                  _loc13_ = false;
                  for each(_loc14_ in _loc5_)
                  {
                     if(_loc14_.jobId == _loc10_.jobId)
                     {
                        _loc13_ = true;
                        break;
                     }
                  }
                  if(!_loc13_)
                  {
                     _loc5_.push(_loc10_);
                  }
               }
               _loc17_.push({
                  "id":_loc6_.skillId,
                  "instanceId":_loc6_.skillInstanceUid,
                  "name":_loc2_,
                  "enabled":false
               });
            }
         }
         _loc7_ = 0;
         for each(_loc9_ in _loc17_)
         {
            if(_loc9_.enabled)
            {
               _loc8_ = _loc17_.indexOf(_loc9_);
               _loc7_++;
            }
         }
         if(_loc7_ == 1)
         {
            this.skillClicked(_loc15_,_loc17_[_loc8_].instanceId);
            return;
         }
         if(_loc7_ > 0 && _loc17_.length > 1)
         {
            this._modContextMenu = UiModuleManager.getInstance().getModule("Ankama_ContextMenu").mainClass;
            this._modContextMenu.createContextMenu(MenusFactory.create(_loc17_,"skill",[_loc15_,_loc16_]));
         }
         if(_loc7_ == 0)
         {
            this.showInteractiveElementNotification(_loc5_);
         }
      }
      
      private function showInteractiveElementNotification(param1:Array) : void
      {
         var _loc2_:* = null;
         var _loc3_:Boolean = false;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Npc = null;
         var _loc10_:Point = null;
         var _loc11_:MapApi = null;
         var _loc12_:String = null;
         var _loc13_:uint = 0;
         if(param1.length > 0)
         {
            _loc2_ = "";
            _loc3_ = false;
            if((_loc6_ = this.getJobKnown(param1)).length > 0)
            {
               _loc7_ = "";
               _loc8_ = "";
               for each(_loc4_ in _loc6_)
               {
                  if(_loc4_.type == "level")
                  {
                     _loc8_ = (_loc8_ = (_loc8_ = _loc8_ + (_loc6_.length > 1?"<li>":"")) + I18n.getUiText("ui.skill.levelLowJob",_loc4_.value)) + (_loc6_.length > 1?"</li>":"");
                  }
                  else if(_loc4_.type == "tool")
                  {
                     _loc7_ = (_loc7_ = (_loc7_ = _loc7_ + (_loc6_.length > 1?"<li>":"")) + _loc4_.value[0]) + (_loc6_.length > 1?"</li>":"");
                  }
               }
               if(_loc8_ != "")
               {
                  _loc2_ = _loc2_ + I18n.getUiText("ui.skill.levelLow",[(_loc6_.length > 1?"<ul>":"") + _loc8_ + (_loc6_.length > 1?"</ul>":".")]);
               }
               if(_loc7_ != "")
               {
                  _loc2_ = _loc2_ + I18n.getUiText("ui.skill.toolNeeded",[(_loc6_.length > 1?"<ul>":"") + _loc7_ + (_loc6_.length > 1?"</ul>":".")]);
               }
            }
            else
            {
               if((_loc11_ = new MapApi()).isInIncarnam())
               {
                  _loc9_ = Npc.getNpcById(849);
                  _loc10_ = _loc11_.getMapCoords(80218116);
               }
               else
               {
                  _loc9_ = Npc.getNpcById(601);
                  _loc10_ = _loc11_.getMapCoords(83889152);
               }
               _loc12_ = "";
               for each(_loc4_ in param1)
               {
                  _loc12_ = _loc12_ + ((param1.length > 1?"<li>":"") + _loc4_.value[0] + (param1.length > 1?"</li>":""));
               }
               _loc2_ = I18n.getUiText("ui.skill.jobNotKnown",[(param1.length > 1?"<ul>":"") + _loc12_ + (param1.length > 1?"</ul>":".")]);
               _loc2_ = _loc2_ + "\n";
               _loc2_ = _loc2_ + I18n.getUiText("ui.npc.learnJobs",[_loc9_.name,_loc10_.x,_loc10_.y]);
               _loc5_ = _loc9_.name;
               _loc3_ = true;
            }
            if(_loc2_ != "")
            {
               _loc13_ = NotificationManager.getInstance().prepareNotification(I18n.getUiText("ui.skill.disabled"),_loc2_,NotificationTypeEnum.INFORMATION,"interactiveElementDisabled");
               if(_loc3_)
               {
                  NotificationManager.getInstance().addButtonToNotification(_loc13_,I18n.getUiText("ui.npc.location"),"AddMapFlag",["flag_srv" + CompassTypeEnum.COMPASS_TYPE_SIMPLE + "_job",_loc5_ + " (" + _loc10_.x + "," + _loc10_.y + ")",PlayedCharacterManager.getInstance().currentWorldMap.id,_loc10_.x,_loc10_.y,5605376,false,true],false,150,0,"hook");
               }
               NotificationManager.getInstance().addTimerToNotification(_loc13_,30,true);
               NotificationManager.getInstance().sendNotification(_loc13_);
            }
         }
      }
      
      private function getJobKnown(param1:Array) : Array
      {
         var _loc2_:Object = null;
         var _loc3_:Array = new Array();
         for each(_loc2_ in param1)
         {
            if(_loc2_.type != "job")
            {
               _loc3_.push(_loc2_);
            }
         }
         return _loc3_;
      }
      
      private function formateInteractiveElementProblem(param1:String, param2:Array) : String
      {
         switch(param1)
         {
            case "job":
               return I18n.getUiText("ui.skill.jobNotKnown",param2);
            case "level":
               return I18n.getUiText("ui.skill.levelLow",param2);
            case "tool":
               return I18n.getUiText("ui.skill.toolNeeded",param2);
            default:
               return null;
         }
      }
      
      private function skillClicked(param1:Object, param2:int) : void
      {
         var _loc3_:InteractiveElementActivationMessage = new InteractiveElementActivationMessage(param1.element,param1.position,param2);
         Kernel.getWorker().process(_loc3_);
      }
      
      private function interactiveUsageFinished(param1:int, param2:uint, param3:uint) : void
      {
         var _loc4_:InteractiveElementActivationMessage = null;
         if(param1 == PlayedCharacterManager.getInstance().id)
         {
            Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
            if(this.roleplayWorldFrame)
            {
               this.roleplayWorldFrame.cellClickEnabled = true;
            }
            this._usingInteractive = false;
            this._currentUsedElementId = -1;
            if(this._nextInteractiveUsed)
            {
               _loc4_ = new InteractiveElementActivationMessage(this._nextInteractiveUsed.ie,this._nextInteractiveUsed.position,this._nextInteractiveUsed.skillInstanceId);
               this._nextInteractiveUsed = null;
               Kernel.getWorker().process(_loc4_);
            }
         }
      }
      
      private function highlightInteractiveElements(param1:Boolean) : void
      {
         var _loc2_:* = undefined;
         for(_loc2_ in this._ie)
         {
            if(!(_loc2_ is DisplayObject && !_loc2_.hasEventListener(MouseEvent.MOUSE_OVER)))
            {
               this.highlightInteractiveElement(_loc2_,param1);
            }
         }
      }
      
      private function highlightInteractiveElement(param1:Sprite, param2:Boolean) : void
      {
         if(param2)
         {
            FiltersManager.getInstance().addEffect(param1,HIGHLIGHT_HINT_FILTER);
         }
         else
         {
            FiltersManager.getInstance().removeEffect(param1,HIGHLIGHT_HINT_FILTER);
         }
         if(MapDisplayManager.getInstance().isBoundingBox(this._ie[param1].element.elementId))
         {
            param1.alpha = param1.filters.length > 0?Number(ALPHA_MODIFICATOR):Number(0);
         }
      }
      
      private function onAnimRendered(param1:TiphonEvent) : void
      {
         var _loc2_:TiphonSprite = param1.currentTarget as TiphonSprite;
         if(param1.animationType == this._statedElementsTargetAnimation[_loc2_].animation)
         {
            _loc2_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onAnimRendered);
            if(this._statedElementsTargetAnimation[_loc2_].elemId == this._currentUsedElementId)
            {
               this._usingInteractive = false;
               this._currentUsedElementId = -1;
            }
            if(_loc2_.getBounds(StageShareManager.stage).contains(StageShareManager.stage.mouseX,StageShareManager.stage.mouseY) && this._ie[currentlyHighlighted] && this._ie[currentlyHighlighted].element.elementId == this._statedElementsTargetAnimation[_loc2_].elemId)
            {
               Kernel.getWorker().process(new InteractiveElementMouseOverMessage(this._ie[currentlyHighlighted].element,currentlyHighlighted));
            }
            delete this._statedElementsTargetAnimation[_loc2_];
         }
      }
   }
}
