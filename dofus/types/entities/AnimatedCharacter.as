package com.ankamagames.dofus.types.entities
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.entities.behaviours.display.AtouinDisplayBehavior;
   import com.ankamagames.atouin.entities.behaviours.movements.MountedMovementBehavior;
   import com.ankamagames.atouin.entities.behaviours.movements.RunningMovementBehavior;
   import com.ankamagames.atouin.entities.behaviours.movements.WalkingMovementBehavior;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.dofus.datacenter.sounds.SoundAnimation;
   import com.ankamagames.dofus.datacenter.sounds.SoundBones;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayHumanoidInformations;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.types.data.Follower;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.jerakine.entities.behaviours.IDisplayBehavior;
   import com.ankamagames.jerakine.entities.behaviours.IMovementBehavior;
   import com.ankamagames.jerakine.entities.interfaces.*;
   import com.ankamagames.jerakine.interfaces.ICustomUnicNameGetter;
   import com.ankamagames.jerakine.interfaces.IObstacle;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.interfaces.ITransparency;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.jerakine.pathfinding.Pathfinding;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.enums.InteractionsEnum;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.types.positions.PathElement;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.display.TiphonAnimation;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.engine.TiphonEventsManager;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.utils.getQualifiedClassName;
   
   public class AnimatedCharacter extends TiphonSprite implements IEntity, IMovable, IDisplayable, IAnimated, IInteractive, IRectangle, IObstacle, ITransparency, ICustomUnicNameGetter
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AnimatedCharacter));
      
      private static const LUMINOSITY_FACTOR:Number = 1.2;
      
      private static const LUMINOSITY_TRANSFORM:ColorTransform = new ColorTransform(LUMINOSITY_FACTOR,LUMINOSITY_FACTOR,LUMINOSITY_FACTOR);
      
      private static const NORMAL_TRANSFORM:ColorTransform = new ColorTransform();
      
      private static const TRANSPARENCY_TRANSFORM:ColorTransform = new ColorTransform(1,1,1,AtouinConstants.OVERLAY_MODE_ALPHA);
       
      
      private var _id:int;
      
      private var _position:MapPoint;
      
      private var _displayed:Boolean;
      
      private var _followers:Vector.<Follower>;
      
      private var _followed:AnimatedCharacter;
      
      private var _followersMovPath:Vector.<MovementPath>;
      
      private var _transparencyAllowed:Boolean = true;
      
      private var _name:String;
      
      private var _canSeeThrough:Boolean = false;
      
      protected var _movementBehavior:IMovementBehavior;
      
      protected var _displayBehavior:IDisplayBehavior;
      
      private var _bmpAlpha:Bitmap;
      
      private var _auraEntity:TiphonSprite;
      
      private var _visibleAura:Boolean = true;
      
      public var speedAdjust:Number = 0;
      
      public var slideOnNextMove:Boolean;
      
      public function AnimatedCharacter(param1:int, param2:TiphonEntityLook, param3:AnimatedCharacter = null)
      {
         this.id = param1;
         name = "AnimatedCharacter" + param1;
         this._followers = new Vector.<Follower>();
         this._followersMovPath = new Vector.<MovementPath>();
         this._followed = param3;
         super(param2);
         this._name = "entity::" + param1;
         this._displayBehavior = AtouinDisplayBehavior.getInstance();
         this._movementBehavior = WalkingMovementBehavior.getInstance();
         addEventListener(TiphonEvent.RENDER_SUCCEED,this.onFirstRender);
         addEventListener(TiphonEvent.RENDER_FAILED,this.onFirstError);
         setAnimationAndDirection(AnimationEnum.ANIM_STATIQUE,DirectionsEnum.DOWN_RIGHT);
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
      
      public function get customUnicName() : String
      {
         return this._name;
      }
      
      public function get position() : MapPoint
      {
         return this._position;
      }
      
      public function set position(param1:MapPoint) : void
      {
         var _loc2_:Follower = null;
         var _loc3_:MapPoint = this._position;
         this._position = param1;
         if(!_loc3_)
         {
            for each(_loc2_ in this._followers)
            {
               if(!_loc2_.entity.position)
               {
                  this.addFollower(_loc2_,true);
               }
            }
         }
      }
      
      public function get movementBehavior() : IMovementBehavior
      {
         return this._movementBehavior;
      }
      
      public function set movementBehavior(param1:IMovementBehavior) : void
      {
         this._movementBehavior = param1;
      }
      
      public function get followed() : AnimatedCharacter
      {
         return this._followed;
      }
      
      public function get displayBehaviors() : IDisplayBehavior
      {
         return this._displayBehavior;
      }
      
      public function set displayBehaviors(param1:IDisplayBehavior) : void
      {
         this._displayBehavior = param1;
      }
      
      public function get displayed() : Boolean
      {
         return this._displayed;
      }
      
      public function get handler() : MessageHandler
      {
         return Kernel.getWorker();
      }
      
      public function get enabledInteractions() : uint
      {
         return InteractionsEnum.CLICK | InteractionsEnum.OUT | InteractionsEnum.OVER;
      }
      
      public function get isMoving() : Boolean
      {
         return this._movementBehavior.isMoving(this);
      }
      
      public function get absoluteBounds() : IRectangle
      {
         return this._displayBehavior.getAbsoluteBounds(this);
      }
      
      override public function get useHandCursor() : Boolean
      {
         return true;
      }
      
      public function get visibleAura() : Boolean
      {
         return this._visibleAura;
      }
      
      public function set visibleAura(param1:Boolean) : void
      {
         var _loc2_:String = null;
         if(this._visibleAura == param1)
         {
            return;
         }
         this._visibleAura = param1;
         if(param1)
         {
            _loc2_ = getAnimation();
            if(this._auraEntity && _loc2_ && _loc2_.indexOf("AnimStatique") != -1)
            {
               this.addSubEntity(this._auraEntity,SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_BASE_FOREGROUND,0);
               this._auraEntity.restartAnimation(0);
               this._auraEntity = null;
            }
         }
         else
         {
            this._auraEntity = getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_BASE_FOREGROUND,0) as TiphonSprite;
            if(this._auraEntity)
            {
               removeSubEntity(this._auraEntity);
               super.finalize();
            }
         }
      }
      
      public function get hasAura() : Boolean
      {
         if(this._auraEntity != null || getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_BASE_FOREGROUND,0) != null)
         {
            return true;
         }
         return false;
      }
      
      public function getIsTransparencyAllowed() : Boolean
      {
         return this._transparencyAllowed;
      }
      
      public function set transparencyAllowed(param1:Boolean) : void
      {
         this._transparencyAllowed = param1;
      }
      
      public function get followers() : Vector.<Follower>
      {
         return this._followers;
      }
      
      private function onFirstError(param1:TiphonEvent) : void
      {
         removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onFirstRender);
         removeEventListener(TiphonEvent.RENDER_FAILED,this.onFirstError);
         var _loc2_:Array = getAvaibleDirection(AnimationEnum.ANIM_STATIQUE);
         var _loc3_:uint = DirectionsEnum.DOWN_RIGHT;
         while(_loc3_ < DirectionsEnum.DOWN_RIGHT + 7)
         {
            if(_loc2_[_loc3_ % 8])
            {
               setAnimationAndDirection(AnimationEnum.ANIM_STATIQUE,_loc3_ % 8);
            }
            _loc3_++;
         }
      }
      
      private function onFirstRender(param1:TiphonEvent) : void
      {
         removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onFirstRender);
         removeEventListener(TiphonEvent.RENDER_FAILED,this.onFirstError);
      }
      
      public function canSeeThrough() : Boolean
      {
         return this._canSeeThrough;
      }
      
      public function setCanSeeThrough(param1:Boolean) : void
      {
         this._canSeeThrough = param1;
      }
      
      public function canWalkThrough() : Boolean
      {
         return this._canSeeThrough;
      }
      
      public function canWalkTo() : Boolean
      {
         return this._canSeeThrough;
      }
      
      public function move(param1:MovementPath, param2:Function = null, param3:IMovementBehavior = null) : void
      {
         var _loc4_:Follower = null;
         var _loc5_:GameContextActorInformations = null;
         var _loc6_:Boolean = false;
         var _loc7_:Array = null;
         var _loc8_:RoleplayContextFrame = null;
         var _loc9_:Vector.<InteractiveElement> = null;
         var _loc10_:InteractiveElement = null;
         var _loc11_:MapPoint = null;
         var _loc12_:int = 0;
         var _loc13_:uint = 0;
         var _loc14_:MapPoint = null;
         var _loc15_:MapPoint = null;
         var _loc16_:uint = 0;
         var _loc17_:MovementPath = null;
         var _loc18_:Array = null;
         var _loc19_:MovementPath = null;
         var _loc20_:uint = 0;
         var _loc21_:MovementPath = null;
         var _loc22_:PathElement = null;
         var _loc23_:PathElement = null;
         if(!param1.start.equals(this.position))
         {
            _log.warn("Unsynchronized position for entity " + this.id + ", jumping from " + this.position + " to " + param1.start + ".");
            this.jump(param1.start);
         }
         var _loc24_:uint = param1.path.length + 1;
         this._movementBehavior = param3;
         if(!this._movementBehavior)
         {
            if(Kernel.getWorker().contains(RoleplayEntitiesFrame))
            {
               if((_loc5_ = (Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame).getEntityInfos(this.id)) is GameRolePlayHumanoidInformations)
               {
                  if((_loc5_ as GameRolePlayHumanoidInformations).humanoidInfo.restrictions.cantRun)
                  {
                     this._movementBehavior = WalkingMovementBehavior.getInstance(this.speedAdjust);
                  }
               }
               else if(_loc5_ is GameRolePlayGroupMonsterInformations)
               {
                  this._movementBehavior = WalkingMovementBehavior.getInstance(this.speedAdjust);
               }
            }
            if(!this._movementBehavior)
            {
               if(_loc24_ > 3)
               {
                  _loc6_ = false;
                  if(Kernel.getWorker().contains(RoleplayEntitiesFrame))
                  {
                     _loc6_ = (Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame).isCreatureMode;
                  }
                  if(!_loc6_ && this.isMounted())
                  {
                     this._movementBehavior = MountedMovementBehavior.getInstance();
                  }
                  else
                  {
                     this._movementBehavior = RunningMovementBehavior.getInstance(this.speedAdjust);
                  }
               }
               else
               {
                  if(_loc24_ <= 0)
                  {
                     return;
                  }
                  this._movementBehavior = WalkingMovementBehavior.getInstance(this.speedAdjust);
               }
            }
         }
         var _loc25_:uint = param1.end.advancedOrientationTo(this.position);
         var _loc26_:IDataMapProvider = DataMapProvider.getInstance();
         if(this._followers.length > 0)
         {
            _loc7_ = new Array();
            if((_loc8_ = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame) != null)
            {
               _loc9_ = _loc8_.entitiesFrame.interactiveElements;
               for each(_loc10_ in _loc9_)
               {
                  if(_loc10_)
                  {
                     if(_loc11_ = Atouin.getInstance().getIdentifiedElementPosition(_loc10_.elementId))
                     {
                        _loc12_ = _loc11_.cellId;
                        _loc7_.push(_loc12_);
                     }
                  }
               }
            }
         }
         this._followersMovPath = new Vector.<MovementPath>();
         for each(_loc4_ in this._followers)
         {
            _loc13_ = this.getFollowerAvailiableDirectionNumber(_loc4_);
            _loc14_ = param1.end;
            _loc7_.push(_loc14_.cellId);
            if(_loc4_.type != Follower.TYPE_MONSTER && (!_loc13_ < 8 && this._followers.indexOf(_loc4_) != 0 && this._followersMovPath.length > 0))
            {
               _loc14_ = this._followersMovPath[this._followersMovPath.length - 1].end;
            }
            _loc25_ = _loc14_.advancedOrientationTo(this.position);
            _loc15_ = null;
            _loc16_ = 0;
            do
            {
               _loc15_ = _loc14_.getNearestFreeCellInDirection(_loc25_,_loc26_,false,false,true,_loc7_);
               _loc25_ = ++_loc25_ % 8;
            }
            while(!_loc15_ && ++_loc16_ < 8);
            
            if(_loc15_)
            {
               if(_loc13_ >= 8 && _loc4_.type != Follower.TYPE_MONSTER)
               {
                  _loc19_ = new MovementPath();
                  if(this._followers.indexOf(_loc4_) == 0 || this._followersMovPath.length <= 0)
                  {
                     _loc18_ = (_loc17_ = param1).path.concat();
                     _loc19_.end = _loc15_;
                     if(_loc18_.length > 0)
                     {
                        _loc18_ = _loc18_.concat(Pathfinding.findPath(_loc26_,_loc18_[_loc18_.length - 1].step,_loc15_).path);
                     }
                     else
                     {
                        _loc18_ = _loc18_.concat(Pathfinding.findPath(_loc26_,param1.start,_loc15_).path);
                     }
                  }
                  else
                  {
                     _loc18_ = (_loc17_ = this._followersMovPath[this._followersMovPath.length - 1]).path.concat();
                     if(_loc17_.length > 0)
                     {
                        _loc19_.end = _loc17_.getPointAtIndex(_loc17_.length - 1).step;
                     }
                     else
                     {
                        _loc19_.end = _loc17_.start;
                     }
                  }
                  if(_loc7_.indexOf(_loc19_.end) != -1)
                  {
                     _loc19_.end = _loc19_.end.getNearestFreeCellInDirection(_loc25_,_loc26_,false,false,true,_loc7_);
                  }
                  _loc7_.push(_loc19_.end.cellId);
                  _loc19_.start = _loc4_.entity.position;
                  if(_loc18_.length > 0)
                  {
                     _loc19_.addPoint(new PathElement(_loc4_.entity.position,_loc4_.entity.position.orientationTo(_loc18_[0].step)));
                  }
                  else
                  {
                     _loc19_.addPoint(new PathElement(_loc4_.entity.position,_loc4_.entity.position.orientationTo(param1.start)));
                  }
                  _loc20_ = 0;
                  while(_loc20_ < _loc18_.length - 1)
                  {
                     (_loc22_ = new PathElement()).step.x = _loc18_[_loc20_].step.x;
                     _loc22_.step.y = _loc18_[_loc20_].step.y;
                     _loc22_.orientation = _loc18_[_loc20_].step.orientationTo(_loc18_[_loc20_ + 1].step);
                     _loc19_.addPoint(_loc22_);
                     _loc20_++;
                  }
                  (_loc21_ = new MovementPath()).path = _loc19_.path.concat();
                  _loc21_.end = _loc19_.end;
                  _loc21_.start = _loc19_.start;
                  this._followersMovPath.push(_loc21_);
                  if(this._followers.indexOf(_loc4_) == 0)
                  {
                     (_loc23_ = _loc19_.getPointAtIndex(_loc19_.length - 1)).orientation = _loc19_.getPointAtIndex(_loc19_.length - 1).step.orientationTo(_loc15_);
                  }
                  this.processMove(_loc19_,new Array(_loc4_.entity,_loc15_));
               }
               else
               {
                  _loc7_.push(_loc15_.cellId);
                  Pathfinding.findPath(_loc26_,_loc4_.entity.position,_loc15_,_loc13_ >= 8,true,this.processMove,new Array(_loc4_.entity,_loc15_));
               }
            }
            else
            {
               _log.warn("Unable to get a proper destination for the follower.");
            }
         }
         this._movementBehavior.move(this,param1,param2);
      }
      
      private function processMove(param1:MovementPath, param2:Array) : void
      {
         var _loc3_:MapPoint = null;
         var _loc4_:IMovable = param2[0];
         if(param1 && param1.path.length > 0)
         {
            _loc4_.movementBehavior = this._movementBehavior;
            _loc4_.move(param1,null,this._movementBehavior);
         }
         else
         {
            _loc3_ = param2[1];
            _log.warn("There was no path from " + _loc4_.position + " to " + _loc3_ + " for a follower. Jumping !");
            _loc4_.jump(_loc3_);
         }
      }
      
      public function jump(param1:MapPoint) : void
      {
         var _loc2_:Follower = null;
         var _loc3_:IDataMapProvider = null;
         var _loc4_:MapPoint = null;
         this._movementBehavior.jump(this,param1);
         for each(_loc2_ in this._followers)
         {
            _loc3_ = DataMapProvider.getInstance();
            if(!(_loc4_ = this.position.getNearestFreeCell(_loc3_,false)))
            {
               if(!(_loc4_ = this.position.getNearestFreeCell(_loc3_,true)))
               {
                  return;
               }
            }
            _loc2_.entity.jump(_loc4_);
         }
      }
      
      public function stop(param1:Boolean = false) : void
      {
         var _loc2_:Follower = null;
         this._movementBehavior.stop(this,param1);
         for each(_loc2_ in this._followers)
         {
            _loc2_.entity.stop(param1);
         }
      }
      
      public function display(param1:uint = 10) : void
      {
         var _loc2_:Follower = null;
         this._displayBehavior.display(this,param1);
         this._displayed = true;
         for each(_loc2_ in this._followers)
         {
            if(_loc2_.entity is IDisplayable && !IDisplayable(_loc2_.entity).displayed)
            {
               IDisplayable(_loc2_.entity).display();
            }
         }
      }
      
      public function remove() : void
      {
         var _loc1_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         if(_loc1_ && _loc1_.justSwitchingCreaturesFightMode)
         {
            this.dispatchEvent(new TiphonEvent(TiphonEvent.ANIMATION_DESTROY,this));
         }
         this.removeAllFollowers();
         this._displayed = false;
         this._movementBehavior.stop(this,true);
         this._displayBehavior.remove(this);
      }
      
      override public function destroy() : void
      {
         this._followed = null;
         this.remove();
         super.destroy();
      }
      
      public function getRootEntity() : AnimatedCharacter
      {
         if(this._followed)
         {
            return this._followed.getRootEntity();
         }
         return this;
      }
      
      public function removeAllFollowers() : void
      {
         var _loc1_:Follower = null;
         var _loc2_:IDisplayable = null;
         var _loc3_:TiphonSprite = null;
         var _loc5_:int = 0;
         var _loc4_:int = this._followers.length;
         while(_loc5_ < _loc4_)
         {
            _loc1_ = this._followers[_loc5_];
            _loc2_ = _loc1_.entity as IDisplayable;
            if(_loc2_)
            {
               _loc2_.remove();
            }
            _loc3_ = _loc1_.entity as TiphonSprite;
            if(_loc3_)
            {
               _loc3_.destroy();
            }
            _loc5_++;
         }
         this._followers = new Vector.<Follower>();
      }
      
      public function removeFollower(param1:Follower) : void
      {
         var _loc2_:Follower = null;
         var _loc3_:IDisplayable = null;
         var _loc4_:TiphonSprite = null;
         var _loc6_:int = 0;
         var _loc5_:int = this._followers.length;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = this._followers[_loc6_];
            if(param1 == _loc2_)
            {
               _loc3_ = _loc2_.entity as IDisplayable;
               if(_loc3_)
               {
                  _loc3_.remove();
               }
               if(_loc4_ = _loc2_.entity as TiphonSprite)
               {
                  _loc4_.destroy();
               }
               this._followers.splice(_loc6_,1);
               return;
            }
            _loc6_++;
         }
      }
      
      public function addFollower(param1:Follower, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Follower = null;
         var _loc5_:uint = 0;
         var _loc6_:IDisplayable = null;
         var _loc7_:Boolean = false;
         for each(_loc4_ in this._followers)
         {
            if(_loc4_.entity.id == param1.entity.id)
            {
               _loc7_ = true;
               break;
            }
         }
         if(!_loc7_)
         {
            if(param1.type == Follower.TYPE_PET)
            {
               this._followers.unshift(param1);
            }
            else if((_loc5_ = this.getFollowerAvailiableDirectionNumber(param1)) < 8 || param1.type == Follower.TYPE_MONSTER)
            {
               this._followers.push(param1);
            }
            else
            {
               if(this._followers.length == 0 || this._followers[0].type != Follower.TYPE_PET)
               {
                  _loc3_ = 0;
               }
               this._followers.splice(_loc3_,0,param1);
            }
         }
         if(!this.position)
         {
            return;
         }
         var _loc8_:IDataMapProvider = DataMapProvider.getInstance();
         var _loc9_:MapPoint;
         if(!(_loc9_ = this.position.getNearestFreeCell(_loc8_,false)))
         {
            if(!(_loc9_ = this.position.getNearestFreeCell(_loc8_,true)))
            {
               return;
            }
         }
         if(param1.entity.position == null)
         {
            param1.entity.position = _loc9_;
         }
         if(param1.entity is IDisplayable)
         {
            _loc6_ = param1.entity as IDisplayable;
            if(this._displayed && !_loc6_.displayed)
            {
               _loc6_.display();
            }
            else if(!this._displayed && _loc6_.displayed)
            {
               _loc6_.remove();
            }
         }
         if(_loc9_.equals(param1.entity.position))
         {
            return;
         }
         if(param2)
         {
            param1.entity.jump(_loc9_);
         }
         else
         {
            param1.entity.move(Pathfinding.findPath(_loc8_,param1.entity.position,_loc9_,false,false));
         }
      }
      
      private function getFollowerAvailiableDirectionNumber(param1:Follower) : uint
      {
         var _loc2_:Boolean = false;
         var _loc4_:uint = 0;
         var _loc3_:Array = [];
         if(param1.entity is TiphonSprite)
         {
            _loc3_ = TiphonSprite(param1.entity).getAvaibleDirection();
         }
         for each(_loc2_ in _loc3_)
         {
            if(_loc2_)
            {
               _loc4_++;
            }
         }
         if(_loc3_[1] && !_loc3_[3])
         {
            _loc4_++;
         }
         if(!_loc3_[1] && _loc3_[3])
         {
            _loc4_++;
         }
         if(_loc3_[7] && !_loc3_[5])
         {
            _loc4_++;
         }
         if(!_loc3_[7] && _loc3_[5])
         {
            _loc4_++;
         }
         if(!_loc3_[0] && _loc3_[4])
         {
            _loc4_++;
         }
         if(_loc3_[0] && !_loc3_[4])
         {
            _loc4_++;
         }
         return _loc4_;
      }
      
      public function followersEqual(param1:Vector.<EntityLook>) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Follower = null;
         var _loc5_:int = 0;
         if(!param1)
         {
            return false;
         }
         var _loc4_:int = param1.length;
         if(this._followers.length != _loc4_)
         {
            return false;
         }
         for each(_loc3_ in this._followers)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               if((_loc3_.entity as AnimatedCharacter).look.equals(EntityLookAdapter.fromNetwork(param1[_loc2_])))
               {
                  _loc5_++;
                  break;
               }
               _loc2_++;
            }
         }
         if(_loc5_ != _loc4_)
         {
            return false;
         }
         return true;
      }
      
      public function isMounted() : Boolean
      {
         var _loc1_:Array = this.look.getSubEntities(true);
         if(!_loc1_)
         {
            return false;
         }
         var _loc2_:Array = _loc1_[SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER];
         if(!_loc2_ || _loc2_.length == 0)
         {
            return false;
         }
         return true;
      }
      
      public function highLightCharacterAndFollower(param1:Boolean) : void
      {
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:AnimatedCharacter = this.getRootEntity();
         var _loc4_:int = _loc3_._followers.length;
         var _loc5_:int = -1;
         while(++_loc5_ < _loc4_)
         {
            _loc2_ = _loc3_._followers[_loc5_].entity as AnimatedCharacter;
            if(_loc2_)
            {
               _loc2_.highLight(param1);
            }
         }
         this.highLight(param1);
      }
      
      public function highLight(param1:Boolean) : void
      {
         if(param1)
         {
            transform.colorTransform = LUMINOSITY_TRANSFORM;
         }
         else if(Atouin.getInstance().options.transparentOverlayMode)
         {
            transform.colorTransform = TRANSPARENCY_TRANSFORM;
         }
         else
         {
            transform.colorTransform = NORMAL_TRANSFORM;
         }
      }
      
      public function showBitmapAlpha(param1:Number) : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Sprite = null;
         if(this._bmpAlpha == null)
         {
            _loc2_ = new BitmapData(width,height,true,16711680);
            _loc2_.draw(this.bitmapData);
            this._bmpAlpha = new Bitmap(_loc2_);
            this._bmpAlpha.alpha = param1;
            _loc3_ = InteractiveCellManager.getInstance().getCell(this.position.cellId);
            this._bmpAlpha.x = _loc3_.x + _loc3_.width / 2 - this.width / 2;
            this._bmpAlpha.y = _loc3_.y + _loc3_.height - this.height;
            this.parent.addChild(this._bmpAlpha);
            visible = false;
         }
      }
      
      public function hideBitmapAlpha() : void
      {
         visible = true;
         if(this._bmpAlpha != null && StageShareManager.stage.contains(this._bmpAlpha))
         {
            this.parent.removeChild(this._bmpAlpha);
            this._bmpAlpha = null;
         }
      }
      
      override public function addSubEntity(param1:DisplayObject, param2:uint, param3:uint) : void
      {
         if(param2 == SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_BASE_FOREGROUND && param3 == 0 && !this._visibleAura)
         {
            this._auraEntity = param1 as TiphonSprite;
            return;
         }
         super.addSubEntity(param1,param2,param3);
      }
      
      override protected function onAdded(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:Vector.<SoundAnimation> = null;
         var _loc4_:SoundAnimation = null;
         var _loc5_:String = null;
         super.onAdded(param1);
         var _loc6_:TiphonAnimation = param1.target as TiphonAnimation;
         var _loc7_:SoundBones;
         if(_loc7_ = SoundBones.getSoundBonesById(look.getBone()))
         {
            _loc2_ = getQualifiedClassName(_loc6_);
            _loc3_ = _loc7_.getSoundAnimations(_loc2_);
            _loc6_.spriteHandler.tiphonEventManager.removeEvents(TiphonEventsManager.BALISE_SOUND,_loc2_);
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = TiphonEventsManager.BALISE_DATASOUND + TiphonEventsManager.BALISE_PARAM_BEGIN + (_loc4_.label != null && _loc4_.label != "null"?_loc4_.label:"") + TiphonEventsManager.BALISE_PARAM_END;
               _loc6_.spriteHandler.tiphonEventManager.addEvent(_loc5_,_loc4_.startFrame,_loc2_);
            }
         }
      }
   }
}
