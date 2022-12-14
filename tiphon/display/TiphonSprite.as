package com.ankamagames.tiphon.display
{
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.DefaultableColor;
   import com.ankamagames.jerakine.types.Swl;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManager;
   import com.ankamagames.jerakine.utils.display.FpsControler;
   import com.ankamagames.jerakine.utils.display.MovieClipUtils;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.tiphon.TiphonConstants;
   import com.ankamagames.tiphon.engine.BoneIndexManager;
   import com.ankamagames.tiphon.engine.SubstituteAnimationManager;
   import com.ankamagames.tiphon.engine.Tiphon;
   import com.ankamagames.tiphon.engine.TiphonCacheManager;
   import com.ankamagames.tiphon.engine.TiphonDebugManager;
   import com.ankamagames.tiphon.engine.TiphonEventsManager;
   import com.ankamagames.tiphon.engine.TiphonFpsManager;
   import com.ankamagames.tiphon.error.TiphonError;
   import com.ankamagames.tiphon.events.AnimationEvent;
   import com.ankamagames.tiphon.events.SwlEvent;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.types.BehaviorData;
   import com.ankamagames.tiphon.types.CarriedSprite;
   import com.ankamagames.tiphon.types.ColoredSprite;
   import com.ankamagames.tiphon.types.DisplayInfoSprite;
   import com.ankamagames.tiphon.types.EquipmentSprite;
   import com.ankamagames.tiphon.types.EventListener;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.IAnimationSpriteHandler;
   import com.ankamagames.tiphon.types.ISkinModifier;
   import com.ankamagames.tiphon.types.ISubEntityBehavior;
   import com.ankamagames.tiphon.types.ISubEntityHandler;
   import com.ankamagames.tiphon.types.ScriptedAnimation;
   import com.ankamagames.tiphon.types.Skin;
   import com.ankamagames.tiphon.types.SubEntityTempInfo;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.TransformData;
   import com.ankamagames.tiphon.types.look.EntityLookObserver;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class TiphonSprite extends Sprite implements IAnimated, IAnimationSpriteHandler, IDestroyable, EntityLookObserver
   {
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      public static var MEMORY_LOG2:Dictionary = new Dictionary(true);
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(TiphonSprite));
      
      private static var _cache:Dictionary = new Dictionary();
      
      private static var _point:Point = new Point(0,0);
      
      public static var subEntityHandler:ISubEntityHandler;
       
      
      protected var _useCacheIfPossible:Boolean = false;
      
      private var _init:Boolean = false;
      
      private var _currentAnimation:String;
      
      private var _rawAnimation:String;
      
      private var _lastAnimation:String;
      
      private var _targetAnimation:String;
      
      private var _currentDirection:int;
      
      private var _animMovieClip:TiphonAnimation;
      
      private var _customColoredParts:Array;
      
      private var _displayInfoParts:Dictionary;
      
      private var _customView:String;
      
      private var _aTransformColors:Array;
      
      private var _skin:Skin;
      
      private var _aSubEntities:Array;
      
      private var _subEntitiesList:Array;
      
      private var _look:TiphonEntityLook;
      
      private var _lookCode:String;
      
      private var _rasterize:Boolean = false;
      
      private var _parentSprite:TiphonSprite;
      
      private var _rendered:Boolean = false;
      
      private var _libReady:Boolean = false;
      
      private var _subEntityBehaviors:Array;
      
      private var _backgroundTemp:Array;
      
      private var _subEntitiesTemp:Vector.<SubEntityTempInfo>;
      
      private var _lastClassName:String;
      
      private var _alternativeSkinIndex:int = -1;
      
      private var _recursiveAlternativeSkinIndex:Boolean = false;
      
      private var _background:Array;
      
      private var _deactivatedSubEntityCategory:Array;
      
      private var _waitingEventInitList:Vector.<Event>;
      
      private var _backgroundOnly:Boolean = false;
      
      private var _tiphonEventManager:TiphonEventsManager;
      
      private var _animationModifier:Array;
      
      private var _skinModifier:ISkinModifier;
      
      private var _savedMouseEnabled:Boolean = true;
      
      private var _carriedEntity:TiphonSprite;
      
      private var _isCarrying:Boolean;
      
      private var _changeDispatched:Boolean;
      
      private var _newAnimationStartFrame:int = -1;
      
      public var destroyed:Boolean = false;
      
      public var overrideNextAnimation:Boolean = false;
      
      public var disableMouseEventWhenAnimated:Boolean = false;
      
      public var useProgressiveLoading:Boolean;
      
      public var allowMovementThrough:Boolean = false;
      
      private var _lastRenderRequest:uint;
      
      public function TiphonSprite(param1:TiphonEntityLook)
      {
         var _loc2_:int = 0;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:TiphonSprite = null;
         this._backgroundTemp = new Array();
         this._deactivatedSubEntityCategory = new Array();
         this._waitingEventInitList = new Vector.<Event>();
         this._animationModifier = [];
         this.useProgressiveLoading = AirScanner.isStreamingVersion();
         this._lastRenderRequest = getTimer();
         super();
         FpsManager.getInstance().watchObject(this,true);
         this._libReady = false;
         this._background = new Array();
         this.initializeLibrary(param1.getBone());
         this._subEntityBehaviors = new Array();
         this._currentAnimation = null;
         this._currentDirection = -1;
         this._customColoredParts = new Array();
         this._displayInfoParts = new Dictionary();
         this._aTransformColors = new Array();
         this._aSubEntities = new Array();
         this._subEntitiesList = new Array();
         this._subEntitiesTemp = new Vector.<SubEntityTempInfo>();
         this._look = param1;
         this._lookCode = this._look.toString();
         this._skin = new Skin();
         this._skin.addEventListener(Event.COMPLETE,this.checkRessourceState);
         var _loc9_:Vector.<uint>;
         if(_loc9_ = this._look.getSkins(true))
         {
            _loc2_ = _loc9_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc5_ = _loc9_[_loc4_];
               _loc5_ = this._skin.add(_loc5_,this._alternativeSkinIndex);
               _loc4_++;
            }
         }
         var _loc10_:Array = this._look.getSubEntities(true);
         for(_loc3_ in _loc10_)
         {
            _loc6_ = int(_loc3_);
            for(_loc7_ in _loc10_[_loc6_])
            {
               if(subEntityHandler != null)
               {
                  if(!subEntityHandler.onSubEntityAdded(this,this._look.getSubEntity(_loc6_,_loc7_),_loc6_,_loc7_))
                  {
                     continue;
                  }
               }
               (_loc8_ = new TiphonSprite(this._look.getSubEntity(_loc6_,_loc7_))).addEventListener(TiphonEvent.RENDER_SUCCEED,this.onSubEntityRendered,false,0,true);
               this.addSubEntity(_loc8_,_loc6_,_loc7_);
            }
         }
         this._look.addObserver(this);
         this.mouseChildren = false;
         this._tiphonEventManager = new TiphonEventsManager(this);
         this._init = true;
         if(this._waitingEventInitList.length)
         {
            StageShareManager.stage.addEventListener(Event.ENTER_FRAME,this.dispatchWaitingEvents);
         }
      }
      
      public function get tiphonEventManager() : TiphonEventsManager
      {
         if(this._tiphonEventManager == null)
         {
            throw new TiphonError("_tiphonEventManager is null, can\'t access so");
         }
         return this._tiphonEventManager;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
      }
      
      override public function set alpha(param1:Number) : void
      {
         super.alpha = param1;
      }
      
      override public function set mouseEnabled(param1:Boolean) : void
      {
         this._savedMouseEnabled = param1;
         super.mouseEnabled = param1;
      }
      
      override public function get mouseEnabled() : Boolean
      {
         return this._savedMouseEnabled;
      }
      
      public function get carriedEntity() : TiphonSprite
      {
         return this._carriedEntity;
      }
      
      public function set carriedEntity(param1:TiphonSprite) : void
      {
         this._carriedEntity = param1;
      }
      
      public function set isCarrying(param1:Boolean) : void
      {
         this._isCarrying = param1;
      }
      
      public function get bitmapData() : BitmapData
      {
         var _loc1_:Rectangle = getBounds(this);
         if(_loc1_.height * _loc1_.width == 0)
         {
            return null;
         }
         var _loc2_:BitmapData = new BitmapData(_loc1_.right - _loc1_.left,_loc1_.bottom - _loc1_.top,true,22015);
         var _loc3_:Matrix = new Matrix();
         _loc3_.translate(-_loc1_.left,-_loc1_.top);
         _loc2_.draw(this,_loc3_);
         return _loc2_;
      }
      
      public function get look() : TiphonEntityLook
      {
         return this._look;
      }
      
      public function get rasterize() : Boolean
      {
         return this._rasterize;
      }
      
      public function set rasterize(param1:Boolean) : void
      {
         this._rasterize = param1;
      }
      
      public function get rawAnimation() : TiphonAnimation
      {
         return this._animMovieClip;
      }
      
      public function get libraryIsAvaible() : Boolean
      {
         return this._libReady;
      }
      
      public function get skinIsAvailable() : Boolean
      {
         return this._skin.complete;
      }
      
      public function get parentSprite() : TiphonSprite
      {
         return this._parentSprite;
      }
      
      public function get rootEntity() : TiphonSprite
      {
         var _loc1_:TiphonSprite = this;
         while(_loc1_._parentSprite)
         {
            _loc1_ = _loc1_._parentSprite;
         }
         return _loc1_;
      }
      
      public function get maxFrame() : uint
      {
         if(this._animMovieClip)
         {
            return this._animMovieClip.totalFrames;
         }
         return 0;
      }
      
      public function get animationModifiers() : Array
      {
         return this._animationModifier;
      }
      
      public function get animationList() : Array
      {
         if(BoneIndexManager.getInstance().hasCustomBone(this._look.getBone()))
         {
            return BoneIndexManager.getInstance().getAllCustomAnimations(this._look.getBone());
         }
         var _loc1_:Swl = Tiphon.skullLibrary.getResourceById(this._look.getBone());
         return !!_loc1_?_loc1_.getDefinitions():null;
      }
      
      public function set skinModifier(param1:ISkinModifier) : void
      {
         this._skinModifier = param1;
      }
      
      public function get skinModifier() : ISkinModifier
      {
         return this._skinModifier;
      }
      
      public function get rendered() : Boolean
      {
         return this._rendered;
      }
      
      public function isPlayingAnimation() : Boolean
      {
         var _loc1_:* = false;
         if(this._animMovieClip)
         {
            _loc1_ = this._animMovieClip.currentFrame != this._animMovieClip.totalFrames;
         }
         return _loc1_;
      }
      
      public function stopAnimation(param1:int = 0) : void
      {
         if(this._animMovieClip)
         {
            if(param1)
            {
               this._animMovieClip.gotoAndStop(param1);
            }
            else
            {
               this._animMovieClip.stop();
            }
            FpsControler.uncontrolFps(this._animMovieClip);
         }
      }
      
      public function stopAnimationAtLastFrame() : void
      {
         if(this._animMovieClip && this._rendered && this._lastAnimation == this._currentAnimation)
         {
            this.stopAnimationAtEnd();
            this.restartAnimation();
         }
         else
         {
            addEventListener(TiphonEvent.RENDER_SUCCEED,this.onLoadComplete);
         }
      }
      
      protected function onLoadComplete(param1:TiphonEvent) : void
      {
         removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onLoadComplete);
         var _loc2_:String = this._currentAnimation.indexOf("_Statique_") == -1?this._currentAnimation.replace("_","_Statique_"):null;
         var _loc3_:TiphonSprite = this.getSubEntitySlot(2,0) as TiphonSprite;
         if(this._currentAnimation != "AnimStatique")
         {
            if(_loc2_ && this.hasAnimation(_loc2_,this._currentDirection) || _loc3_ && _loc3_.hasAnimation(_loc2_,_loc3_.getDirection()))
            {
               this.setAnimation(_loc2_);
            }
            else
            {
               this.stopAnimation(this.maxFrame);
            }
         }
         this.visible = true;
         if(this.parentSprite)
         {
            this.parentSprite.visible = true;
         }
      }
      
      public function restartAnimation(param1:int = -1) : void
      {
         var _loc2_:Swl = Tiphon.skullLibrary.getResourceById(this._look.getBone(),this._currentAnimation);
         if(this._animMovieClip && _loc2_)
         {
            if(param1 != -1)
            {
               this._animMovieClip.gotoAndStop(param1);
            }
            FpsControler.controlFps(this._animMovieClip,_loc2_.frameRate);
         }
      }
      
      public function stopAnimationAtEnd() : void
      {
         var _loc1_:MovieClip = null;
         if(this._animMovieClip)
         {
            this._animMovieClip.gotoAndStop(this._animMovieClip.totalFrames);
            if(this._animMovieClip.numChildren)
            {
               _loc1_ = this._animMovieClip.getChildAt(0) as MovieClip;
               if(_loc1_)
               {
                  _loc1_.gotoAndStop(_loc1_.totalFrames);
               }
            }
            FpsControler.uncontrolFps(this._animMovieClip);
            this._animMovieClip.cacheAsBitmap = true;
         }
      }
      
      public function setDirection(param1:uint) : void
      {
         if(this._currentAnimation)
         {
            this.setAnimationAndDirection(this._rawAnimation,param1);
         }
         else
         {
            this._currentDirection = param1;
         }
      }
      
      public function getDirection() : uint
      {
         return this._currentDirection > 0?uint(this._currentDirection):uint(0);
      }
      
      public function setAnimation(param1:String, param2:int = -1) : void
      {
         this._newAnimationStartFrame = param2;
         this.setAnimationAndDirection(param1,this._currentDirection);
      }
      
      public function getAnimation() : String
      {
         return this._currentAnimation;
      }
      
      public function addAnimationModifier(param1:IAnimationModifier, param2:Boolean = true) : void
      {
         if(!param2 || this._animationModifier.indexOf(param1) == -1)
         {
            this._animationModifier.push(param1);
         }
         this._animationModifier.sortOn("priority");
      }
      
      public function removeAnimationModifier(param1:IAnimationModifier) : void
      {
         var _loc2_:IAnimationModifier = null;
         var _loc3_:Array = [];
         for each(_loc2_ in this._animationModifier)
         {
            if(param1 != _loc2_)
            {
               _loc3_.push(_loc2_);
            }
         }
         this._animationModifier = _loc3_;
      }
      
      public function removeAnimationModifierByClass(param1:Class) : void
      {
         var _loc2_:IAnimationModifier = null;
         var _loc3_:Array = [];
         for each(_loc2_ in this._animationModifier)
         {
            if(!(_loc2_ is param1))
            {
               _loc3_.push(_loc2_);
            }
         }
         this._animationModifier = _loc3_;
      }
      
      public function setAnimationAndDirection(param1:String, param2:uint, param3:Boolean = false) : void
      {
         var _loc4_:* = null;
         var _loc5_:EventListener = null;
         var _loc6_:Array = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:IAnimationModifier = null;
         var _loc9_:TiphonEvent = null;
         var _loc10_:String = null;
         var _loc11_:Uri = null;
         if(this.destroyed)
         {
            return;
         }
         FpsManager.getInstance().startTracking("animation",40277);
         this._rawAnimation = param1;
         if(!param1)
         {
            param1 = this._currentAnimation;
         }
         if(this is IEntity)
         {
            if((this._currentAnimation == "AnimMarche" || this._currentAnimation == "AnimCourse") && param1 == "AnimStatique")
            {
               for each(_loc5_ in TiphonEventsManager.listeners)
               {
                  _loc5_.listener.removeEntitySound(this as IEntity);
               }
            }
         }
         var _loc12_:BehaviorData = new BehaviorData(param1,param2,this);
         for(_loc4_ in this._aSubEntities)
         {
            if(_loc6_ = this._aSubEntities[_loc4_])
            {
               for each(_loc7_ in _loc6_)
               {
                  if(_loc7_ is TiphonSprite)
                  {
                     if(this._subEntityBehaviors[_loc4_])
                     {
                        (this._subEntityBehaviors[_loc4_] as ISubEntityBehavior).updateFromParentEntity(TiphonSprite(_loc7_),_loc12_);
                     }
                     else
                     {
                        this.updateFromParentEntity(TiphonSprite(_loc7_),_loc12_);
                     }
                  }
               }
            }
         }
         if(this._animationModifier)
         {
            for each(_loc8_ in this._animationModifier)
            {
               _loc12_.animation = _loc8_.getModifiedAnimation(_loc12_.animation,this.look);
            }
         }
         if(param3)
         {
            this._currentAnimation = param1;
            this.overrideNextAnimation = true;
         }
         if(!this.overrideNextAnimation && _loc12_.animation == this._currentAnimation && param2 == this._currentDirection && this._rendered)
         {
            if(this._animMovieClip && this._animMovieClip.totalFrames > 1)
            {
               this.restartAnimation();
            }
            this._changeDispatched = true;
            if(this._subEntitiesList.length)
            {
               this.dispatchEvent(new TiphonEvent(TiphonEvent.RENDER_FATHER_SUCCEED,this));
            }
            (_loc9_ = new TiphonEvent(TiphonEvent.RENDER_SUCCEED,this)).animationName = this._currentAnimation + "_" + this._currentDirection;
            this.dispatchEvent(_loc9_);
            return;
         }
         this.overrideNextAnimation = false;
         this._changeDispatched = false;
         this._lastAnimation = this._currentAnimation;
         this._currentDirection = param2;
         if(!param3)
         {
            if(BoneIndexManager.getInstance().hasTransition(this._look.getBone(),this._lastAnimation,_loc12_.animation,this._currentDirection))
            {
               _loc10_ = BoneIndexManager.getInstance().getTransition(this._look.getBone(),this._lastAnimation,_loc12_.animation,this._currentDirection);
               this._currentAnimation = _loc10_;
               this._targetAnimation = _loc12_.animation;
            }
            else
            {
               this._currentAnimation = _loc12_.animation;
            }
         }
         if(BoneIndexManager.getInstance().hasCustomBone(this._look.getBone()))
         {
            if((_loc11_ = BoneIndexManager.getInstance().getBoneFile(this._look.getBone(),this._currentAnimation)).fileName != this._look.getBone() + ".swl" || BoneIndexManager.getInstance().hasAnim(this._look.getBone(),this._currentAnimation,this._currentDirection))
            {
               this.initializeLibrary(this._look.getBone(),_loc11_);
            }
            else
            {
               this._currentAnimation = "AnimStatique";
            }
         }
         this._rendered = false;
         this.finalize();
         FpsManager.getInstance().stopTracking("animation");
      }
      
      public function setView(param1:String) : void
      {
         this._customView = param1;
         var _loc2_:DisplayInfoSprite = this.getDisplayInfoSprite(param1);
         if(_loc2_)
         {
            if(this.mask != null && this.mask.parent)
            {
               this.mask.parent.removeChild(this.mask);
            }
            if(!_loc2_.parent)
            {
               addChild(_loc2_);
            }
            this.mask = _loc2_;
         }
      }
      
      public function getSubEntityBehavior(param1:int) : ISubEntityBehavior
      {
         return this._subEntityBehaviors[param1];
      }
      
      public function setSubEntityBehaviour(param1:int, param2:ISubEntityBehavior) : void
      {
         this._subEntityBehaviors[param1] = param2;
      }
      
      public function updateFromParentEntity(param1:TiphonSprite, param2:BehaviorData) : void
      {
         var _loc3_:Boolean = false;
         var _loc5_:int = 0;
         if(!param1)
         {
            return;
         }
         var _loc4_:Array = param1.getAvaibleDirection(param2.animation);
         while(_loc5_ < 8)
         {
            _loc3_ = _loc4_[_loc5_] || _loc3_;
            _loc5_++;
         }
         if(_loc3_ || !this._libReady)
         {
            param1.setAnimationAndDirection(param2.animation,param2.direction);
         }
      }
      
      public function destroy() : void
      {
         var i:int = 0;
         var num:int = 0;
         var subEntity:TiphonSprite = null;
         var isCarriedEntity:Boolean = false;
         try
         {
            if(!this.destroyed)
            {
               if(parent)
               {
                  parent.removeChild(this);
               }
               this.destroyed = true;
               this._parentSprite = null;
               if(this._look)
               {
                  this._look.removeObserver(this);
               }
               this.clearAnimation();
               if(this._tiphonEventManager)
               {
                  this._tiphonEventManager.destroy();
                  this._tiphonEventManager = null;
               }
               if(this._subEntitiesList)
               {
                  i = -1;
                  num = this._subEntitiesList.length;
                  while(++i < num)
                  {
                     subEntity = this._subEntitiesList[i] as TiphonSprite;
                     if(subEntity)
                     {
                        isCarriedEntity = this._aSubEntities["3"] && subEntity == this._aSubEntities["3"]["0"];
                        this.removeSubEntity(subEntity);
                        if(!isCarriedEntity)
                        {
                           subEntity.destroy();
                        }
                     }
                  }
               }
               if(this._subEntitiesTemp)
               {
                  i = -1;
                  num = this._subEntitiesTemp.length;
                  while(++i < num)
                  {
                     subEntity = this._subEntitiesList[i].entity as TiphonSprite;
                     if(subEntity)
                     {
                        subEntity.destroy();
                     }
                  }
                  this._subEntitiesTemp = null;
               }
               if(this._skin)
               {
                  this._skin.reset();
                  this._skin.removeEventListener(Event.COMPLETE,this.checkRessourceState);
                  this._skin = null;
               }
               this._subEntitiesList = null;
               this._aSubEntities = null;
               this._subEntityBehaviors = null;
               this._customColoredParts = null;
               this._displayInfoParts = null;
               this._aTransformColors = null;
               this._backgroundTemp = null;
               this._subEntitiesTemp = null;
               this._background = null;
               this._animationModifier = null;
            }
         }
         catch(e:Error)
         {
            _log.fatal("TiphonSprite impossible ?? d??truire !");
         }
      }
      
      public function getAvaibleDirection(param1:String = null, param2:Boolean = false) : Array
      {
         var _loc5_:uint = 0;
         var _loc3_:Swl = Tiphon.skullLibrary.getResourceById(this._look.getBone());
         var _loc4_:Array = new Array();
         if(!_loc3_)
         {
            return [];
         }
         while(_loc5_ < 8)
         {
            _loc4_[_loc5_] = _loc3_.getDefinitions().indexOf((!!param1?param1:this._currentAnimation) + "_" + _loc5_) != -1;
            if(param2 && !_loc4_[_loc5_])
            {
               _loc4_[_loc5_] = _loc3_.getDefinitions().indexOf((!!param1?param1:this._currentAnimation) + "_" + TiphonUtility.getFlipDirection(_loc5_)) != -1;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function hasAnimation(param1:String, param2:int = -1) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:uint = this._look.getBone();
         if(param2 != -1)
         {
            _loc4_ = Tiphon.skullLibrary.hasAnim(_loc5_,param1,param2) || Tiphon.skullLibrary.hasAnim(_loc5_,param1,TiphonUtility.getFlipDirection(param2));
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < 8)
            {
               Tiphon.skullLibrary.hasAnim(_loc5_,(!!param1?param1:this._currentAnimation) + "_" + _loc3_);
               if(param2)
               {
                  _loc4_ = true;
               }
               _loc3_++;
            }
         }
         if(!_loc4_ && this._look.getSubEntity(2,0))
         {
            _loc5_ = this._look.getSubEntity(2,0).getBone();
            if(param2 != -1)
            {
               _loc4_ = Tiphon.skullLibrary.hasAnim(_loc5_,param1,param2) || Tiphon.skullLibrary.hasAnim(_loc5_,param1,TiphonUtility.getFlipDirection(param2));
            }
            else
            {
               _loc3_ = 0;
               while(_loc3_ < 8)
               {
                  Tiphon.skullLibrary.hasAnim(_loc5_,(!!param1?param1:this._currentAnimation) + "_" + _loc3_);
                  if(param2)
                  {
                     _loc4_ = true;
                  }
                  _loc3_++;
               }
            }
         }
         return _loc4_;
      }
      
      public function getSlot(param1:String = "") : DisplayObject
      {
         var _loc2_:uint = 0;
         if(numChildren && this._animMovieClip)
         {
            _loc2_ = 0;
            while(_loc2_ < this._animMovieClip.numChildren)
            {
               if(getQualifiedClassName(this._animMovieClip.getChildAt(_loc2_)).indexOf(param1) == 0)
               {
                  return this._animMovieClip.getChildAt(_loc2_);
               }
               _loc2_++;
            }
         }
         return null;
      }
      
      public function getColorTransform(param1:uint) : ColorTransform
      {
         var _loc2_:ColorTransform = null;
         if(this._aTransformColors[param1])
         {
            return this._aTransformColors[param1];
         }
         var _loc3_:DefaultableColor = this._look.getColor(param1);
         if(!_loc3_.isDefault)
         {
            _loc2_ = new ColorTransform();
            _loc2_.color = _loc3_.color;
            this._aTransformColors[param1] = _loc2_;
            return _loc2_;
         }
         return null;
      }
      
      public function getSkinSprite(param1:EquipmentSprite) : Sprite
      {
         if(!this._skin)
         {
            return null;
         }
         var _loc2_:String = getQualifiedClassName(param1);
         if(this._skinModifier != null)
         {
            _loc2_ = this._skinModifier.getModifiedSkin(this._skin,_loc2_,this._look);
         }
         return this._skin.getPart(_loc2_);
      }
      
      public function getPartTransformData(param1:String) : TransformData
      {
         return !!this._skin?this._skin.getTransformData(param1):null;
      }
      
      public function addSubEntity(param1:DisplayObject, param2:uint, param3:uint) : void
      {
         var _loc4_:TiphonSprite = null;
         if(param2 == 3 && param3 == 0)
         {
            this._carriedEntity = param1 as TiphonSprite;
         }
         if(this._rendered)
         {
            param1.x = 0;
            param1.y = 0;
            if(_loc4_ = param1 as TiphonSprite)
            {
               _loc4_._parentSprite = this;
               _loc4_.overrideNextAnimation = true;
               _loc4_.setDirection(this._currentDirection);
            }
            if(!this._aSubEntities[param2])
            {
               this._aSubEntities[param2] = new Array();
            }
            this._aSubEntities[param2][param3] = param1;
            this.dispatchEvent(new TiphonEvent(TiphonEvent.SUB_ENTITY_ADDED,this));
            this._subEntitiesList.push(param1);
            _log.info("Add subentity " + param1.name + " to " + name + " (cat: " + param2 + ")");
            if(this._recursiveAlternativeSkinIndex && _loc4_)
            {
               _loc4_.setAlternativeSkinIndex(this._alternativeSkinIndex);
            }
            this.finalize();
         }
         else
         {
            this._subEntitiesTemp.push(new SubEntityTempInfo(param1,param2,param3));
         }
      }
      
      public function removeSubEntity(param1:DisplayObject) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:* = null;
         if(param1 == this._carriedEntity)
         {
            this._carriedEntity = null;
            this._isCarrying = false;
         }
         if(this.destroyed)
         {
            return;
         }
         for(_loc3_ in this._aSubEntities)
         {
            for(_loc5_ in this._aSubEntities[_loc3_])
            {
               if(param1 === this._aSubEntities[_loc3_][_loc5_])
               {
                  if(this._subEntityBehaviors[_loc3_] is ISubEntityBehavior)
                  {
                     ISubEntityBehavior(this._subEntityBehaviors[_loc3_]).remove();
                  }
                  delete this._subEntityBehaviors[_loc3_];
                  delete this._aSubEntities[_loc3_][_loc5_];
                  _loc2_ = true;
                  break;
               }
            }
            if(_loc2_)
            {
               break;
            }
         }
         if((_loc4_ = this._subEntitiesList.indexOf(param1)) != -1)
         {
            this._subEntitiesList.splice(_loc4_,1);
         }
         var _loc6_:TiphonSprite;
         if(_loc6_ = param1 as TiphonSprite)
         {
            _loc6_._parentSprite = null;
            _loc6_.overrideNextAnimation = true;
         }
      }
      
      public function getSubEntitySlot(param1:uint, param2:uint) : DisplayObjectContainer
      {
         if(this.destroyed)
         {
            return null;
         }
         if(this._aSubEntities[param1] && this._aSubEntities[param1][param2])
         {
            if(this._aSubEntities[param1][param2] is TiphonSprite)
            {
               (this._aSubEntities[param1][param2] as TiphonSprite)._parentSprite = this;
            }
            return this._aSubEntities[param1][param2];
         }
         return null;
      }
      
      public function getSubEntitiesList() : Array
      {
         return this._subEntitiesList;
      }
      
      public function getTmpSubEntitiesNb() : uint
      {
         return this._subEntitiesTemp.length;
      }
      
      public function registerColoredSprite(param1:ColoredSprite, param2:uint) : void
      {
         if(!this._customColoredParts[param2])
         {
            this._customColoredParts[param2] = new Dictionary(true);
         }
         this._customColoredParts[param2][param1] = 1;
      }
      
      public function registerInfoSprite(param1:DisplayInfoSprite, param2:String) : void
      {
         this._displayInfoParts[param2] = param1;
         if(param2 == this._customView)
         {
            this.setView(param2);
         }
      }
      
      public function getDisplayInfoSprite(param1:String) : DisplayInfoSprite
      {
         return this._displayInfoParts[param1];
      }
      
      public function addBackground(param1:String, param2:DisplayObject, param3:Boolean = false) : void
      {
         var _loc4_:Rectangle = null;
         if(!this._background[param1])
         {
            this._background[param1] = param2;
            if(this._rendered)
            {
               if(param1 == "teamCircle")
               {
               }
               if(param3)
               {
                  _loc4_ = this.getRect(this);
                  param2.y = _loc4_.y - 10;
               }
               addChildAt(param2,0);
               this.updateScale();
            }
            else
            {
               if(param1 == "teamCircle")
               {
               }
               this._backgroundTemp.push(param2,param3);
            }
         }
      }
      
      public function removeBackground(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this._rendered && this._background[param1])
         {
            removeChild(this._background[param1]);
         }
         var _loc3_:int = this._backgroundTemp.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._backgroundTemp[_loc2_] == this._background[param1])
            {
               this._backgroundTemp.splice(_loc2_,2);
               break;
            }
            _loc2_ = _loc2_ + 2;
         }
         this._background[param1] = null;
      }
      
      public function getBackground(param1:String) : DisplayObject
      {
         return this._background[param1];
      }
      
      public function showOnlyBackground(param1:Boolean) : void
      {
         this._backgroundOnly = param1;
         if(param1 && this._animMovieClip && contains(this._animMovieClip))
         {
            removeChild(this._animMovieClip);
         }
         else if(!param1 && this._animMovieClip)
         {
            addChild(this._animMovieClip);
         }
      }
      
      public function isShowingOnlyBackground() : Boolean
      {
         return this._backgroundOnly;
      }
      
      public function setAlternativeSkinIndex(param1:int = -1, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TiphonSprite = null;
         this._recursiveAlternativeSkinIndex = param2;
         if(this._recursiveAlternativeSkinIndex)
         {
            _loc3_ = -1;
            _loc4_ = this._subEntitiesList.length;
            while(++_loc3_ < _loc4_)
            {
               if(_loc5_ = this._subEntitiesList[_loc3_] as TiphonSprite)
               {
                  _loc5_.setAlternativeSkinIndex(param1);
               }
            }
         }
         if(param1 != this._alternativeSkinIndex)
         {
            this._alternativeSkinIndex = param1;
            this.resetSkins();
         }
      }
      
      public function getAlternativeSkinIndex() : int
      {
         return this._alternativeSkinIndex;
      }
      
      public function getGlobalScale() : Number
      {
         var _loc1_:Number = 1;
         var _loc2_:TiphonSprite = this.parentSprite;
         while(_loc2_)
         {
            _loc1_ = _loc1_ * (!!_loc2_._animMovieClip?_loc2_._animMovieClip.scaleX:1);
            _loc2_ = _loc2_.parentSprite;
         }
         return _loc1_;
      }
      
      public function reprocessSkin() : void
      {
         if(this._skin)
         {
            this._skin.reprocess();
         }
      }
      
      private function initializeLibrary(param1:uint, param2:Uri = null) : void
      {
         if(!param2)
         {
            if(BoneIndexManager.getInstance().hasCustomBone(param1))
            {
               return;
            }
            param2 = new Uri(TiphonConstants.SWF_SKULL_PATH + param1 + ".swl");
         }
         this._libReady = false;
         Tiphon.skullLibrary.addResource(param1,param2);
         Tiphon.skullLibrary.askResource(param1,this._currentAnimation,new Callback(this.onSkullLibraryReady,param1),new Callback(this.onSkullLibraryError));
      }
      
      private function applyColor(param1:uint) : void
      {
         var _loc2_:* = undefined;
         if(this._customColoredParts[param1])
         {
            for(_loc2_ in this._customColoredParts[param1])
            {
               _loc2_.colorize(this.getColorTransform(param1));
            }
         }
      }
      
      private function resetSkins() : void
      {
         var _loc1_:uint = 0;
         this._skin.validate = false;
         this._skin.reset();
         for each(_loc1_ in this._look.getSkins(true))
         {
            _loc1_ = this._skin.add(_loc1_,this._alternativeSkinIndex);
         }
         this._skin.validate = true;
      }
      
      private function resetSubEntities() : void
      {
         var _loc1_:TiphonSprite = null;
         var _loc2_:* = null;
         var _loc3_:TiphonSprite = null;
         var _loc4_:* = null;
         var _loc5_:TiphonEntityLook = null;
         var _loc6_:TiphonSprite = null;
         while(this._subEntitiesList.length)
         {
            _loc3_ = this._subEntitiesList.shift() as TiphonSprite;
            if(_loc3_ && !(this._carriedEntity && _loc3_ == this._carriedEntity))
            {
               if(this._aSubEntities["2"] && this._aSubEntities["2"]["0"] && _loc3_ == this._aSubEntities["2"]["0"])
               {
                  if(this._deactivatedSubEntityCategory.indexOf("2") != -1 && _loc3_.carriedEntity)
                  {
                     this._carriedEntity = _loc3_.carriedEntity;
                  }
                  else
                  {
                     _loc1_ = _loc3_.getSubEntitySlot(3,0) as TiphonSprite;
                  }
               }
               _loc3_.destroy();
            }
         }
         this._aSubEntities = [];
         var _loc7_:Array = this._look.getSubEntities(true);
         for(_loc2_ in _loc7_)
         {
            if(this._deactivatedSubEntityCategory.indexOf(_loc2_) == -1)
            {
               if(_loc2_ == "2" && this._carriedEntity)
               {
                  _loc1_ = this._carriedEntity;
                  this.removeSubEntity(this._carriedEntity);
               }
               for(_loc4_ in _loc7_[_loc2_])
               {
                  _loc5_ = _loc7_[_loc2_][_loc4_];
                  if(subEntityHandler != null)
                  {
                     if(!subEntityHandler.onSubEntityAdded(this,_loc5_,parseInt(_loc2_),parseInt(_loc4_)))
                     {
                        continue;
                     }
                  }
                  (_loc6_ = new TiphonSprite(_loc5_)).setAnimationAndDirection("AnimStatique",this._currentDirection);
                  if(!_loc6_.rendered)
                  {
                     _loc6_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onSubEntityRendered,false,0,true);
                  }
                  this.addSubEntity(_loc6_,parseInt(_loc2_),parseInt(_loc4_));
                  if(parseInt(_loc2_) == 2 && parseInt(_loc4_) == 0 && _loc1_)
                  {
                     _loc6_.isCarrying = true;
                     _loc6_.addSubEntity(_loc1_,3,0);
                  }
               }
            }
         }
         if(this._carriedEntity)
         {
            if(!this._aSubEntities["3"])
            {
               this._aSubEntities["3"] = new Array();
            }
            this._aSubEntities["3"]["0"] = this._carriedEntity;
            this._subEntitiesList.push(_loc3_);
         }
      }
      
      protected function finalize() : void
      {
         if(this.destroyed)
         {
            return;
         }
         Tiphon.skullLibrary.askResource(this._look.getBone(),this._currentAnimation,new Callback(this.checkRessourceState),new Callback(this.onRenderFail));
      }
      
      private function checkRessourceState(param1:Event = null) : void
      {
         if(this.destroyed)
         {
            return;
         }
         if((this._skin.complete || this.useProgressiveLoading && this._lastRenderRequest > 60) && Tiphon.skullLibrary.isLoaded(this._look.getBone(),this._currentAnimation) && this._currentAnimation != null && this._currentDirection >= 0)
         {
            this.render();
         }
         this._lastRenderRequest = getTimer();
      }
      
      private function render() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:* = undefined;
         var _loc9_:RasterizedSyncAnimation = null;
         var _loc10_:Sprite = null;
         var _loc11_:Rectangle = null;
         var _loc12_:SubEntityTempInfo = null;
         var _loc13_:TiphonSprite = null;
         var _loc14_:Class = null;
         var _loc17_:Boolean = false;
         var _loc22_:int = 0;
         if(this.destroyed)
         {
            return;
         }
         FpsManager.getInstance().startTracking("animation",40277);
         var _loc15_:Swl = Tiphon.skullLibrary.getResourceById(this._look.getBone(),this._currentAnimation);
         var _loc16_:int = this._currentDirection;
         if(this.parentSprite)
         {
            if(this.getGlobalScale() < 0)
            {
               _loc16_ = TiphonUtility.getFlipDirection(_loc16_);
            }
         }
         var _loc18_:String = this._currentAnimation + "_" + _loc16_;
         if(_loc15_.hasDefinition(_loc18_))
         {
            _loc14_ = _loc15_.getDefinition(_loc18_) as Class;
         }
         else
         {
            _loc18_ = this._currentAnimation + "_" + TiphonUtility.getFlipDirection(_loc16_);
            if(_loc15_.hasDefinition(_loc18_))
            {
               _loc14_ = _loc15_.getDefinition(_loc18_) as Class;
               _loc17_ = true;
            }
         }
         if(_loc14_ == null)
         {
            _loc3_ = "Class [" + this._currentAnimation + "_" + _loc16_ + "] or [" + this._currentAnimation + "_" + TiphonUtility.getFlipDirection(_loc16_) + "] cannot be found in library " + this._look.getBone();
            _log.error(_loc3_);
            _loc4_ = SubstituteAnimationManager.getDefaultAnimation(this._currentAnimation);
            _loc5_ = this._currentDirection;
            if(_loc4_)
            {
               _loc7_ = this.getAvaibleDirection(_loc4_,true);
               for(_loc8_ in _loc7_)
               {
                  if(_loc7_[_loc8_])
                  {
                     _loc5_ = int(_loc8_);
                     break;
                  }
               }
            }
            _loc6_ = this._currentAnimation.indexOf("Carrying");
            if(!_loc4_ && _loc6_ != -1)
            {
               _loc4_ = this._currentAnimation.substring(0,_loc6_);
            }
            if(_loc4_ && this._currentAnimation != _loc4_)
            {
               _log.error("On ne trouve cette animation, on va jouer l\'animation " + _loc4_ + "_" + this._currentDirection + " ?? la place.");
               this.setAnimationAndDirection(_loc4_,this._currentDirection,true);
            }
            else if(_loc4_ && this._currentAnimation == _loc4_ && this._currentDirection != _loc5_)
            {
               _log.error("On ne trouve pas cette animation dans cette direction, on va jouer l\'animation " + _loc4_ + "_" + _loc5_ + " ?? la place.");
               this.setAnimationAndDirection(_loc4_,_loc5_,true);
            }
            else
            {
               this.onRenderFail();
            }
            return;
         }
         if((this._lastAnimation == "AnimPickup" || this._lastAnimation == "AnimStatiqueCarrying") && this._currentAnimation == "AnimStatiqueCarrying")
         {
            this._isCarrying = true;
         }
         var _loc19_:int = -1;
         if(this._currentAnimation == this._lastClassName && this._animMovieClip)
         {
            _loc19_ = this._animMovieClip.currentFrame;
         }
         else if(this._newAnimationStartFrame != -1)
         {
            _loc19_ = this._newAnimationStartFrame;
            this._newAnimationStartFrame = -1;
         }
         this._lastClassName = this._currentAnimation;
         this.clearAnimation();
         for each(_loc1_ in this._background)
         {
            if(_loc1_)
            {
               addChild(_loc1_);
            }
         }
         this._customColoredParts = new Array();
         this._displayInfoParts = new Dictionary();
         ScriptedAnimation.currentSpriteHandler = this;
         _loc2_ = this._look.getBone();
         if(this._useCacheIfPossible && TiphonCacheManager.hasCache(_loc2_,this._currentAnimation))
         {
            this._animMovieClip = TiphonCacheManager.getScriptedAnimation(_loc2_,this._currentAnimation,this._currentDirection);
         }
         else
         {
            this._animMovieClip = new _loc14_() as ScriptedAnimation;
         }
         ScriptedAnimation.currentSpriteHandler = null;
         MEMORY_LOG2[this._animMovieClip] = 1;
         if(!this._animMovieClip)
         {
            _log.error("Class [" + this._currentAnimation + "_" + _loc16_ + "] is not a ScriptedAnimation");
            return;
         }
         this._animMovieClip.addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         if(_loc17_ && this._animMovieClip.scaleX > 0)
         {
            this._animMovieClip.scaleX = this._animMovieClip.scaleX * -1;
         }
         else if(!_loc17_ && this._animMovieClip.scaleX < 0)
         {
            this._animMovieClip.scaleX = this._animMovieClip.scaleX * -1;
         }
         var _loc20_:Boolean = MovieClipUtils.isSingleFrame(this._animMovieClip);
         this._animMovieClip.cacheAsBitmap = _loc20_;
         if(this.disableMouseEventWhenAnimated)
         {
            super.mouseEnabled = _loc20_ && this.mouseEnabled;
         }
         if(!this._backgroundOnly)
         {
            this.addChild(this._animMovieClip);
         }
         if(_loc20_ || !this._rasterize && !Tiphon.getInstance().isRasterizeAnimation(this._currentAnimation))
         {
            if((this._currentAnimation.indexOf("AnimStatique") != -1 || this._currentAnimation.indexOf("AnimState") != -1) && this._currentAnimation.indexOf("_to_") == -1 && !_loc20_)
            {
               _log.error("/!\\ ATTENTION, l\'animation [" + this._currentAnimation + "_" + _loc16_ + "] sur le squelette [" + this._look.getBone() + "] contient un clip qui contient plusieurs frames. C\'est mal.");
            }
            if(!_loc20_)
            {
               FpsControler.controlFps(this._animMovieClip,_loc15_.frameRate);
            }
            this._animMovieClip.addEventListener(AnimationEvent.EVENT,this.animEventHandler);
            this._animMovieClip.addEventListener(AnimationEvent.ANIM,this.animSwitchHandler);
         }
         else
         {
            this._animMovieClip.visible = false;
            _loc9_ = new RasterizedSyncAnimation(this._animMovieClip,this._lookCode);
            FpsControler.controlFps(_loc9_,_loc15_.frameRate);
            _loc9_.addEventListener(AnimationEvent.EVENT,this.animEventHandler);
            _loc9_.addEventListener(AnimationEvent.ANIM,this.animSwitchHandler);
            if(!this._backgroundOnly)
            {
               this.addChild(_loc9_);
            }
            this._animMovieClip = _loc9_;
         }
         if(!_loc20_ && _loc19_ != -1)
         {
            this._animMovieClip.gotoAndStop(_loc19_);
            if(this._animMovieClip is ScriptedAnimation)
            {
               (this._animMovieClip as ScriptedAnimation).playEventAtFrame(_loc19_);
            }
         }
         this._rendered = true;
         if(this._subEntitiesList.length)
         {
            this.dispatchEvent(new TiphonEvent(TiphonEvent.RENDER_FATHER_SUCCEED,this));
         }
         var _loc21_:int = this._backgroundTemp.length;
         while(_loc22_ < _loc21_)
         {
            _loc10_ = this._backgroundTemp.shift();
            if(this._backgroundTemp.shift())
            {
               _loc11_ = this.getRect(this);
               _loc10_.y = _loc11_.y - 10;
            }
            addChildAt(_loc10_,0);
            _loc22_ = _loc22_ + 2;
         }
         FpsManager.getInstance().stopTracking("animation");
         if(this._subEntitiesTemp)
         {
            while(this._subEntitiesTemp.length)
            {
               if((_loc13_ = (_loc12_ = this._subEntitiesTemp.shift()).entity as TiphonSprite) && !_loc13_._currentAnimation)
               {
                  if(_loc13_.animationList && _loc13_.animationList.indexOf(this._currentAnimation) != -1)
                  {
                     _loc13_._currentAnimation = this._currentAnimation;
                  }
                  else
                  {
                     _loc13_._currentAnimation = "AnimStatique";
                  }
               }
               this.addSubEntity(_loc12_.entity,_loc12_.category,_loc12_.slot);
            }
         }
         this.checkRenderState();
      }
      
      public function forceRender() : void
      {
         var _loc1_:int = this._currentDirection;
         if(this.parentSprite && this.getGlobalScale() < 0)
         {
            _loc1_ = TiphonUtility.getFlipDirection(_loc1_);
         }
         var _loc2_:String = this._currentAnimation + "_" + _loc1_;
         var _loc3_:Swl = Tiphon.skullLibrary.getResourceById(this._look.getBone(),this._currentAnimation,true);
         if(_loc3_ == null)
         {
            Tiphon.skullLibrary.addEventListener(SwlEvent.SWL_LOADED,this.checkRessourceState);
         }
         else
         {
            this.checkRessourceState();
         }
      }
      
      protected function clearAnimation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this._animMovieClip)
         {
            this._animMovieClip.removeEventListener(AnimationEvent.EVENT,this.animEventHandler);
            this._animMovieClip.removeEventListener(AnimationEvent.ANIM,this.animSwitchHandler);
            this._animMovieClip.removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
            FpsControler.uncontrolFps(this._animMovieClip);
            if(this._animMovieClip.parent)
            {
               removeChild(this._animMovieClip);
            }
            if(this._useCacheIfPossible && (this._animMovieClip as MovieClip).inCache)
            {
               TiphonCacheManager.pushScriptedAnimation(this._animMovieClip as ScriptedAnimation);
            }
            else
            {
               TiphonFpsManager.addOldScriptedAnimation(this._animMovieClip as ScriptedAnimation,true);
            }
            (this._animMovieClip as MovieClip).destroy();
            _loc1_ = this._animMovieClip.numChildren;
            _loc2_ = -1;
            while(++_loc2_ < _loc1_)
            {
               this._animMovieClip.removeChildAt(0);
            }
            this._animMovieClip = null;
         }
         while(numChildren)
         {
            this.removeChildAt(0);
         }
      }
      
      private function animEventHandler(param1:AnimationEvent) : void
      {
         this.dispatchEvent(new TiphonEvent(param1.id,this));
         this.dispatchEvent(new TiphonEvent(TiphonEvent.ANIMATION_EVENT,this));
      }
      
      private function animSwitchHandler(param1:AnimationEvent) : void
      {
         this.setAnimation(param1.id);
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         var _loc2_:String = null;
         if(param1.type == TiphonEvent.ANIMATION_END && this._targetAnimation)
         {
            _loc2_ = this._targetAnimation;
            this._targetAnimation = null;
            this.setAnimation(_loc2_);
            return false;
         }
         return super.dispatchEvent(param1);
      }
      
      private function checkRenderState() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this._subEntitiesList)
         {
            if(_loc1_ is TiphonSprite && !TiphonSprite(_loc1_)._rendered)
            {
               return;
            }
         }
         if(!this._skin || !this._skin.complete)
         {
            return;
         }
         var _loc2_:TiphonEvent = new TiphonEvent(TiphonEvent.RENDER_SUCCEED,this);
         _loc2_.animationName = this._currentAnimation + "_" + this._currentDirection;
         if(!this._changeDispatched)
         {
            this._changeDispatched = true;
            setTimeout(this.dispatchEvent,1,_loc2_);
         }
      }
      
      private function updateScale() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:TiphonSprite = null;
         var _loc4_:TiphonSprite = null;
         if(!this._animMovieClip)
         {
            return;
         }
         var _loc5_:int = this._animMovieClip.scaleX >= 0?1:-1;
         var _loc6_:int = this._animMovieClip.scaleY >= 0?1:-1;
         var _loc7_:DisplayObject = this;
         while(_loc7_.parent)
         {
            _loc5_ = _loc5_ * (_loc7_.parent.scaleX >= 0?1:-1);
            _loc6_ = _loc6_ * (_loc7_.parent.scaleY >= 0?1:-1);
            if(_loc7_.parent is TiphonSprite && _loc1_ == null)
            {
               _loc1_ = _loc7_.parent;
            }
            _loc7_ = _loc7_.parent;
         }
         if(_loc1_ is TiphonSprite && (TiphonSprite(_loc1_).look.getScaleX() != 1 || TiphonSprite(_loc1_).look.getScaleY() != 1))
         {
            _loc3_ = _loc1_ as TiphonSprite;
            this._animMovieClip.scaleX = this.look.getScaleX() / _loc3_.look.getScaleX() * (this._animMovieClip.scaleX < 0?-1:1);
            this._animMovieClip.scaleY = this.look.getScaleY() / _loc3_.look.getScaleY();
         }
         else
         {
            this._animMovieClip.scaleX = this.look.getScaleX() * (this._animMovieClip.scaleX < 0?-1:1);
            this._animMovieClip.scaleY = this.look.getScaleY();
         }
         for each(_loc2_ in this._background)
         {
            if(_loc2_)
            {
               if(_loc1_ is TiphonSprite)
               {
                  _loc4_ = _loc1_ as TiphonSprite;
                  _loc2_.scaleX = 1 / _loc4_.look.getScaleX() * _loc5_;
                  _loc2_.scaleY = 1 / _loc4_.look.getScaleY() * _loc6_;
               }
               else
               {
                  _loc2_.scaleX = _loc2_.scaleY = 1;
               }
            }
         }
      }
      
      private function dispatchWaitingEvents(param1:Event) : void
      {
         StageShareManager.stage.removeEventListener(Event.ENTER_FRAME,this.dispatchWaitingEvents);
         while(this._waitingEventInitList.length)
         {
            this.dispatchEvent(this._waitingEventInitList.shift());
         }
      }
      
      public function onAnimationEvent(param1:String, param2:String = "") : void
      {
         if(param1 == TiphonEvent.PLAYER_STOP)
         {
            this.stopAnimation();
         }
         var _loc3_:TiphonEvent = new TiphonEvent(param1,this,param2);
         var _loc4_:TiphonEvent = new TiphonEvent(TiphonEvent.ANIMATION_EVENT,this);
         if(this._init)
         {
            this.dispatchEvent(_loc3_);
            this.dispatchEvent(_loc4_);
         }
         else
         {
            this._waitingEventInitList.push(_loc3_,_loc4_);
         }
         if(param1 != TiphonEvent.PLAYER_STOP && this.parentSprite)
         {
            this.parentSprite.onAnimationEvent(param1);
         }
      }
      
      private function onRenderFail() : void
      {
         var _loc1_:TiphonEvent = new TiphonEvent(TiphonEvent.RENDER_FAILED,this);
         if(this._init)
         {
            this.dispatchEvent(_loc1_);
         }
         else
         {
            this._waitingEventInitList.push(_loc1_);
         }
         TiphonDebugManager.displayDofusScriptError("Rendu impossible : " + this._currentAnimation + ", " + this._currentDirection,this);
      }
      
      private function onSubEntityRendered(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onSubEntityRendered);
         this.checkRenderState();
      }
      
      private function onSkullLibraryReady(param1:uint) : void
      {
         this._libReady = true;
         var _loc2_:TiphonEvent = new TiphonEvent(TiphonEvent.SPRITE_INIT,this,param1);
         if(this._init)
         {
            this.dispatchEvent(_loc2_);
         }
         else
         {
            this._waitingEventInitList.push(_loc2_);
         }
      }
      
      private function onSkullLibraryError() : void
      {
         var _loc1_:TiphonEvent = new TiphonEvent(TiphonEvent.SPRITE_INIT_FAILED,this);
         if(this._init)
         {
            this.dispatchEvent(_loc1_);
         }
         else
         {
            this._waitingEventInitList.push(_loc1_);
         }
         TiphonDebugManager.displayDofusScriptError("Initialisation impossible : " + this._currentAnimation + ", " + this._currentDirection,this);
      }
      
      protected function onAdded(param1:Event) : void
      {
         var _loc2_:CarriedSprite = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Array = null;
         var _loc6_:int = 0;
         this.updateScale();
         var _loc5_:int = this._animMovieClip.numChildren;
         while(_loc6_ < _loc5_)
         {
            _loc3_ = this._animMovieClip.getChildAt(_loc6_);
            if(_loc3_ is CarriedSprite)
            {
               if((_loc4_ = getQualifiedClassName(_loc3_).split("_"))[1] == "3" && _loc4_[2] == "0")
               {
                  _loc2_ = this._animMovieClip.getChildAt(_loc6_) as CarriedSprite;
               }
            }
            _loc6_++;
         }
         if(this._isCarrying && this._carriedEntity)
         {
            if(_loc2_)
            {
               this._carriedEntity.y = this._carriedEntity.x = 0;
               this._carriedEntity.setDirection(this._currentDirection);
               _loc2_.addChild(this._carriedEntity);
            }
            else if(this._animMovieClip.width > 0 && this._animMovieClip.height > 0)
            {
               if(this._carriedEntity.parent == this._animMovieClip)
               {
                  this._animMovieClip.removeChild(this._carriedEntity);
               }
               this._carriedEntity.y = -(this._animMovieClip.localToGlobal(_point).y - this._animMovieClip.getBounds(StageShareManager.stage).y);
               this._animMovieClip.addChild(this._carriedEntity);
            }
         }
         this.dispatchEvent(new TiphonEvent(TiphonEvent.ANIMATION_ADDED,this));
      }
      
      public function boneChanged(param1:TiphonEntityLook) : void
      {
         this._look = param1;
         this._lookCode = this._look.toString();
         this._tiphonEventManager = new TiphonEventsManager(this);
         this._rendered = false;
         var _loc2_:Uri = BoneIndexManager.getInstance().getBoneFile(this._look.getBone(),this._currentAnimation);
         if(BoneIndexManager.getInstance().hasCustomBone(this._look.getBone()))
         {
            if(_loc2_.fileName != this._look.getBone() + ".swl" || BoneIndexManager.getInstance().hasAnim(this._look.getBone(),this._currentAnimation,this._currentDirection))
            {
               this.initializeLibrary(param1.getBone(),_loc2_);
               this.setAnimation(this._rawAnimation);
            }
            else
            {
               this.setAnimationAndDirection("AnimStatique",this._currentDirection,true);
            }
         }
         else
         {
            this.initializeLibrary(param1.getBone(),_loc2_);
            this.setAnimation(this._rawAnimation);
         }
      }
      
      public function skinsChanged(param1:TiphonEntityLook) : void
      {
         this._look = param1;
         this._lookCode = this._look.toString();
         this._rendered = false;
         this.resetSkins();
         this.finalize();
      }
      
      public function colorsChanged(param1:TiphonEntityLook) : void
      {
         var _loc2_:* = null;
         this._look = param1;
         this._lookCode = this._look.toString();
         this._aTransformColors = new Array();
         if(this._rasterize)
         {
            this.finalize();
         }
         else
         {
            for(_loc2_ in this._customColoredParts)
            {
               this.applyColor(uint(_loc2_));
            }
         }
      }
      
      public function scalesChanged(param1:TiphonEntityLook) : void
      {
         this._look = param1;
         this._lookCode = this._look.toString();
         if(this._rasterize)
         {
            this.finalize();
         }
         else if(this._animMovieClip != null)
         {
            this.updateScale();
         }
      }
      
      public function subEntitiesChanged(param1:TiphonEntityLook) : void
      {
         this._look = param1;
         this._lookCode = this._look.toString();
         this.resetSubEntities();
         this.finalize();
      }
      
      public function enableSubCategory(param1:int, param2:Boolean = true) : void
      {
         if(param2)
         {
            this._deactivatedSubEntityCategory.splice(this._deactivatedSubEntityCategory.indexOf(param1.toString()),1);
         }
         else if(this._deactivatedSubEntityCategory.indexOf(param1.toString()) == -1)
         {
            this._deactivatedSubEntityCategory.push(param1.toString());
         }
      }
      
      override public function toString() : String
      {
         return "[TiphonSprite] " + this._look.toString();
      }
   }
}
