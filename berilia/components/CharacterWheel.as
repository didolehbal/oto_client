package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.enums.EventEnums;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.UIEventManager;
   import com.ankamagames.berilia.types.event.InstanceEvent;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.interfaces.IInterfaceListener;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.SetAnimationStep;
   import com.ankamagames.tiphon.sequence.SetDirectionStep;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.ISkinModifier;
   import com.ankamagames.tiphon.types.ISubEntityBehavior;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class CharacterWheel extends GraphicContainer implements FinalizableUIComponent
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CharacterWheel));
      
      private static const _animationModifier:Dictionary = new Dictionary();
      
      private static const _skinModifier:Dictionary = new Dictionary();
      
      private static const _subEntitiesBehaviors:Dictionary = new Dictionary();
       
      
      private var _nSelectedChara:int;
      
      private var _nNbCharacters:uint = 1;
      
      private var _aCharactersList:Object;
      
      private var _aEntitiesLook:Array;
      
      private var _ctrDepth:Array;
      
      private var _uiClass:UiRootContainer;
      
      private var _aMountainsCtr:Array;
      
      private var _aSprites:Array;
      
      private var _charaSelCtr:Object;
      
      private var _midZCtr:Object;
      
      private var _frontZCtr:Object;
      
      private var _sMountainUri:String;
      
      private var _nWidthEllipsis:int = 390;
      
      private var _nHeightEllipsis:int = 200;
      
      private var _nXCenterEllipsis:int = 540;
      
      private var _nYCenterEllipsis:int = 360;
      
      private var _nRotationStep:Number = 0;
      
      private var _nRotation:Number = 0;
      
      private var _nRotationPieceTrg:Number;
      
      private var _sens:int;
      
      private var _bMovingMountains:Boolean = false;
      
      private var _finalized:Boolean = false;
      
      private var _aRenderePartNames:Array;
      
      public function CharacterWheel()
      {
         super();
         this._aEntitiesLook = new Array();
         this._aMountainsCtr = new Array();
         this._aSprites = new Array();
         this._ctrDepth = new Array();
      }
      
      public static function setSubEntityDefaultBehavior(param1:uint, param2:ISubEntityBehavior) : void
      {
         _subEntitiesBehaviors[param1] = param2;
      }
      
      public static function setAnimationModifier(param1:uint, param2:IAnimationModifier) : void
      {
         _animationModifier[param1] = param2;
      }
      
      public static function setSkinModifier(param1:uint, param2:ISkinModifier) : void
      {
         _skinModifier[param1] = param2;
      }
      
      public function get widthEllipsis() : int
      {
         return this._nWidthEllipsis;
      }
      
      public function set widthEllipsis(param1:int) : void
      {
         this._nWidthEllipsis = param1;
      }
      
      public function get heightEllipsis() : int
      {
         return this._nHeightEllipsis;
      }
      
      public function set heightEllipsis(param1:int) : void
      {
         this._nHeightEllipsis = param1;
      }
      
      public function get xEllipsis() : int
      {
         return this._nXCenterEllipsis;
      }
      
      public function set xEllipsis(param1:int) : void
      {
         this._nXCenterEllipsis = param1;
      }
      
      public function get yEllipsis() : int
      {
         return this._nYCenterEllipsis;
      }
      
      public function set yEllipsis(param1:int) : void
      {
         this._nYCenterEllipsis = param1;
      }
      
      public function get charaCtr() : Object
      {
         return this._charaSelCtr;
      }
      
      public function set charaCtr(param1:Object) : void
      {
         this._charaSelCtr = param1;
      }
      
      public function get frontCtr() : Object
      {
         return this._frontZCtr;
      }
      
      public function set frontCtr(param1:Object) : void
      {
         this._frontZCtr = param1;
      }
      
      public function get midCtr() : Object
      {
         return this._midZCtr;
      }
      
      public function set midCtr(param1:Object) : void
      {
         this._midZCtr = param1;
      }
      
      public function get mountainUri() : String
      {
         return this._sMountainUri;
      }
      
      public function set mountainUri(param1:String) : void
      {
         this._sMountainUri = param1;
      }
      
      public function get selectedChara() : int
      {
         return this._nSelectedChara;
      }
      
      public function set selectedChara(param1:int) : void
      {
         this._nSelectedChara = param1;
      }
      
      public function get isWheeling() : Boolean
      {
         return this._bMovingMountains;
      }
      
      public function set entities(param1:*) : void
      {
         if(!this.isIterable(param1))
         {
            throw new ArgumentError("entities must be either Array or Vector.");
         }
         this._aEntitiesLook = SecureCenter.unsecure(param1);
      }
      
      public function get entities() : *
      {
         return SecureCenter.secure(this._aEntitiesLook);
      }
      
      public function set dataProvider(param1:*) : void
      {
         if(!this.isIterable(param1))
         {
            throw new ArgumentError("dataProvider must be either Array or Vector.");
         }
         this._aCharactersList = param1;
         this.finalize();
      }
      
      public function get dataProvider() : *
      {
         return this._aCharactersList;
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      public function set finalized(param1:Boolean) : void
      {
         this._finalized = param1;
      }
      
      public function finalize() : void
      {
         this._uiClass = getUi();
         if(this._aCharactersList)
         {
            this._nNbCharacters = this._aCharactersList.length;
            this._nSelectedChara = 0;
            if(this._nNbCharacters > 0)
            {
               this.charactersDisplay();
            }
         }
         this._finalized = true;
         if(getUi())
         {
            getUi().iAmFinalized(this);
         }
      }
      
      override public function remove() : void
      {
         var _loc1_:GraphicContainer = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ISubEntityBehavior = null;
         var _loc5_:TiphonEntity = null;
         var _loc6_:uint = 0;
         if(!__removed)
         {
            for each(_loc1_ in this._aMountainsCtr)
            {
               _loc1_.remove();
            }
            _loc2_ = this._aSprites.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               (_loc5_ = this._aSprites[_loc3_]).destroy();
               _loc3_++;
            }
            if(this._charaSelCtr)
            {
               _loc6_ = this._charaSelCtr.numChildren;
               while(_loc6_ > 0)
               {
                  this._charaSelCtr.removeChildAt(0);
                  _loc6_--;
               }
            }
            this._aCharactersList = null;
            this._aEntitiesLook = null;
            this._ctrDepth = null;
            this._uiClass = null;
            this._aMountainsCtr = null;
            this._aSprites = null;
            this._charaSelCtr = null;
            this._midZCtr = null;
            this._frontZCtr = null;
            for each(_loc4_ in _subEntitiesBehaviors)
            {
               if(_loc4_)
               {
                  _loc4_.remove();
               }
            }
         }
         super.remove();
      }
      
      public function wheel(param1:int) : void
      {
         this.rotateMountains(param1);
      }
      
      public function wheelChara(param1:int) : void
      {
         var _loc2_:int = IAnimated(this._aSprites[this._nSelectedChara]).getDirection() + param1;
         _loc2_ = _loc2_ == 8?0:int(_loc2_);
         _loc2_ = _loc2_ < 0?7:int(_loc2_);
         IAnimated(this._aSprites[this._nSelectedChara]).setDirection(_loc2_);
         this.createMountainsCtrBitmap(this._aSprites[this._nSelectedChara].parent,this._nSelectedChara);
      }
      
      public function setAnimation(param1:String, param2:int = 0) : void
      {
         var _loc3_:SerialSequencer = new SerialSequencer();
         var _loc4_:TiphonSprite = this._aSprites[this._nSelectedChara];
         if(param1 == "AnimStatique")
         {
            _loc4_.setAnimationAndDirection("AnimStatique",param2);
         }
         else
         {
            _loc3_.addStep(new SetDirectionStep(_loc4_,param2));
            _loc3_.addStep(new PlayAnimationStep(_loc4_,param1,false));
            _loc3_.addStep(new SetAnimationStep(_loc4_,"AnimStatique"));
            _loc3_.start();
         }
      }
      
      public function equipCharacter(param1:Array, param2:int = 0) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:TiphonSprite;
         var _loc6_:Array = (_loc5_ = this._aSprites[this._nSelectedChara]).look.toString().split("|");
         if(param1.length)
         {
            param1.unshift(_loc6_[1].split(","));
            _loc6_[1] = param1.join(",");
         }
         else
         {
            _loc3_ = _loc6_[1].split(",");
            _loc4_ = 0;
            while(_loc4_ < param2)
            {
               _loc3_.pop();
               _loc4_++;
            }
            _loc6_[1] = _loc3_.join(",");
         }
         var _loc7_:TiphonEntityLook = TiphonEntityLook.fromString(_loc6_.join("|"));
         _loc5_.look.updateFrom(_loc7_);
      }
      
      public function getMountainCtr(param1:int) : Object
      {
         return this._aMountainsCtr[param1];
      }
      
      private function charactersDisplay() : void
      {
         var _loc1_:GraphicContainer = null;
         var _loc2_:TiphonEntity = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:GraphicContainer = null;
         var _loc10_:CBI = null;
         var _loc11_:TiphonEntity = null;
         var _loc12_:* = undefined;
         var _loc13_:Texture = null;
         var _loc14_:InstanceEvent = null;
         var _loc16_:int = 0;
         var _loc15_:int = this._aSprites.length;
         while(_loc16_ < _loc15_)
         {
            _loc2_ = this._aSprites.shift();
            _loc2_.destroy();
            _loc16_++;
         }
         for each(_loc1_ in this._aMountainsCtr)
         {
            _loc1_.remove();
         }
         if(this._aMountainsCtr.length > 0)
         {
            _loc3_ = this._aMountainsCtr.numChildren;
            _loc4_ = _loc3_ - 1;
            while(_loc4_ >= 0)
            {
               this._aMountainsCtr.removeChild(this._aMountainsCtr.getChildAt(_loc4_));
               _loc4_--;
            }
            this._aMountainsCtr = new Array();
            this._ctrDepth = new Array();
         }
         if(this._nNbCharacters == 0)
         {
            _log.error("Error : The character list is empty.");
         }
         else
         {
            _loc5_ = 2 * Math.PI / this._nNbCharacters;
            this._nRotation = 0;
            this._nRotationPieceTrg = 0;
            this._aRenderePartNames = new Array();
            _loc6_ = 0;
            while(_loc6_ < this._nNbCharacters)
            {
               if(this._aCharactersList[_loc6_])
               {
                  _loc7_ = _loc5_ * _loc6_ % (2 * Math.PI);
                  _loc8_ = Math.abs(_loc7_ - Math.PI) / Math.PI;
                  (_loc9_ = new GraphicContainer()).x = this._nWidthEllipsis * Math.cos(_loc7_ + Math.PI / 2) + this._nXCenterEllipsis;
                  _loc9_.y = this._nHeightEllipsis * Math.sin(_loc7_ + Math.PI / 2) + this._nYCenterEllipsis;
                  _loc10_ = new CBI(this._aCharactersList[_loc6_].id,this._aCharactersList[_loc6_].breedId,new Array());
                  this._aEntitiesLook[_loc6_].look = SecureCenter.unsecure(this._aEntitiesLook[_loc6_].look);
                  _loc11_ = new TiphonEntity(this._aEntitiesLook[_loc6_].id,this._aEntitiesLook[_loc6_].look);
                  _loc9_.addChild(_loc11_);
                  _loc11_.name = "char" + _loc6_;
                  _loc11_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onMoutainPartRendered);
                  if(_animationModifier[_loc11_.look.getBone()])
                  {
                     _loc11_.addAnimationModifier(_animationModifier[_loc11_.look.getBone()]);
                  }
                  if(_skinModifier[_loc11_.look.getBone()])
                  {
                     _loc11_.skinModifier = _skinModifier[_loc11_.look.getBone()];
                  }
                  for(_loc12_ in _subEntitiesBehaviors)
                  {
                     if(_subEntitiesBehaviors[_loc12_])
                     {
                        _loc11_.setSubEntityBehaviour(_loc12_,_subEntitiesBehaviors[_loc12_]);
                     }
                  }
                  if(_loc11_.look.getBone() == 1)
                  {
                     _loc11_.setAnimationAndDirection("AnimStatique",2);
                  }
                  else
                  {
                     _loc11_.setAnimationAndDirection("AnimStatique",3);
                  }
                  _loc11_.x = -5;
                  _loc11_.y = -64;
                  _loc11_.scaleX = 2.2;
                  _loc11_.scaleY = 2.2;
                  _loc11_.cacheAsBitmap = true;
                  this._aSprites[_loc6_] = _loc11_;
                  _loc9_.scaleX = _loc9_.scaleY = Math.max(0.3,_loc8_);
                  _loc9_.alpha = Math.max(0.3,_loc8_);
                  _loc9_.useHandCursor = true;
                  _loc9_.buttonMode = true;
                  if(this._nNbCharacters == 2)
                  {
                     if(_loc6_ == 1)
                     {
                        _loc9_.x = this._nWidthEllipsis * Math.cos(_loc7_ + Math.PI / 6 + Math.PI / 2) + this._nXCenterEllipsis;
                        _loc9_.y = this._nHeightEllipsis * Math.sin(_loc7_ + Math.PI / 6 + Math.PI / 2) + this._nYCenterEllipsis;
                     }
                  }
                  if(this._nNbCharacters == 4)
                  {
                     if(_loc6_ == 2)
                     {
                        _loc9_.x = this._nWidthEllipsis * Math.cos(_loc7_ + Math.PI / 6 + Math.PI / 2) + this._nXCenterEllipsis;
                        _loc9_.y = this._nHeightEllipsis * Math.sin(_loc7_ + Math.PI / 6 + Math.PI / 2) + this._nYCenterEllipsis;
                     }
                  }
                  _loc13_ = new Texture();
                  _loc9_.addChildAt(_loc13_,0);
                  _loc13_.name = "char" + _loc6_;
                  _loc13_.dispatchMessages = true;
                  _loc13_.addEventListener(Event.COMPLETE,this.onMoutainPartRendered);
                  _loc13_.scale = 1.2;
                  _loc13_.y = -62;
                  _loc13_.uri = new Uri(this._sMountainUri + "assets.swf|base_" + _loc10_.breed);
                  _loc13_.finalize();
                  (_loc14_ = new InstanceEvent(_loc9_,this._uiClass.uiClass)).push(EventEnums.EVENT_ONRELEASE_MSG);
                  _loc14_.push(EventEnums.EVENT_ONDOUBLECLICK_MSG);
                  UIEventManager.getInstance().registerInstance(_loc14_);
                  if(_loc6_ == 0)
                  {
                     this._charaSelCtr.addChild(this._midZCtr);
                  }
                  if(this._aEntitiesLook[_loc6_].disabled)
                  {
                     _loc9_.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1);
                  }
                  this._charaSelCtr.addChild(_loc9_);
                  this._ctrDepth.push(this._charaSelCtr.getChildIndex(_loc9_));
                  this._aMountainsCtr[_loc6_] = _loc9_;
               }
               _loc6_++;
            }
            this._charaSelCtr.addChild(this._frontZCtr);
         }
      }
      
      private function onMoutainPartRendered(param1:Event) : void
      {
         if(param1.type == TiphonEvent.RENDER_SUCCEED)
         {
            param1.target.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onMoutainPartRendered);
         }
         else if(param1.type == Event.COMPLETE)
         {
            param1.target.removeEventListener(Event.COMPLETE,this.onMoutainPartRendered);
         }
         if(this._aRenderePartNames[param1.target.name] && param1.target.stage)
         {
            this.createMountainsCtrBitmap(this._aRenderePartNames[param1.target.name],int(param1.target.name.replace("char","")));
         }
         else
         {
            this._aRenderePartNames[param1.target.name] = param1.target.parent;
         }
      }
      
      private function createMountainsCtrBitmap(param1:GraphicContainer, param2:int) : void
      {
         var _loc3_:Bitmap = null;
         var _loc4_:Number = param1.alpha;
         param1.alpha = 1;
         var _loc5_:Number = param1.scaleX;
         param1.scaleX = param1.scaleY = 1;
         if(param1.numChildren > 2)
         {
            _loc3_ = param1.getChildAt(2) as Bitmap;
            if(_loc3_ && _loc3_.bitmapData)
            {
               _loc3_.bitmapData.dispose();
            }
         }
         var _loc6_:Rectangle = param1.getBounds(param1);
         var _loc7_:BitmapData;
         (_loc7_ = new BitmapData(_loc6_.width,_loc6_.height,true,5596808)).draw(param1,new Matrix(1,0,0,1,-_loc6_.x,-_loc6_.y));
         if(!_loc3_)
         {
            _loc3_ = new Bitmap(_loc7_,"auto",true);
         }
         else
         {
            _loc3_.bitmapData = _loc7_;
         }
         _loc3_.x = _loc6_.x;
         _loc3_.y = _loc6_.y;
         param1.alpha = _loc4_;
         param1.scaleX = param1.scaleY = _loc5_;
         param1.addChild(_loc3_);
         if(param1.numChildren == 3)
         {
            param1.getChildAt(0).visible = param1.getChildAt(1).visible = param2 == this._nSelectedChara;
            param1.getChildAt(2).visible = param2 != this._nSelectedChara;
         }
      }
      
      private function endRotationMountains() : void
      {
         EnterFrameDispatcher.removeEventListener(this.onRotateMountains);
         this._bMovingMountains = false;
      }
      
      private function rotateMountains(param1:int) : void
      {
         var _loc2_:IInterfaceListener = null;
         var _loc3_:IInterfaceListener = null;
         this._nSelectedChara = this._nSelectedChara - param1;
         if(this._nSelectedChara >= this._aCharactersList.length)
         {
            this._nSelectedChara = this._nSelectedChara - this._aCharactersList.length;
         }
         if(this._nSelectedChara < 0)
         {
            this._nSelectedChara = this._aCharactersList.length + this._nSelectedChara;
         }
         var _loc4_:Number = 2 * Math.PI / this._nNbCharacters;
         this._sens = param1;
         this._nRotationStep = _loc4_;
         if(isNaN(this._nRotationPieceTrg))
         {
            this._nRotationPieceTrg = this._nRotation + this._nRotationStep * this._sens;
         }
         else
         {
            this._nRotationPieceTrg = this._nRotationPieceTrg + this._nRotationStep * this._sens;
         }
         if(param1 == 1)
         {
            for each(_loc2_ in Berilia.getInstance().UISoundListeners)
            {
               _loc2_.playUISound("16079");
            }
         }
         else
         {
            for each(_loc3_ in Berilia.getInstance().UISoundListeners)
            {
               _loc3_.playUISound("16080");
            }
         }
         EnterFrameDispatcher.addEventListener(this.onRotateMountains,"mountainsRotation",StageShareManager.stage.frameRate);
      }
      
      private function isIterable(param1:*) : Boolean
      {
         if(param1 is Array)
         {
            return true;
         }
         if(param1["length"] != null && param1["length"] != 0 && !isNaN(param1["length"]) && param1[0] != null && !(param1 is String))
         {
            return true;
         }
         return false;
      }
      
      override public function process(param1:Message) : Boolean
      {
         return false;
      }
      
      public function eventOnRelease(param1:DisplayObject) : void
      {
      }
      
      public function eventOnDoubleClick(param1:DisplayObject) : void
      {
         if(this._bMovingMountains)
         {
         }
      }
      
      public function eventOnRollOver(param1:DisplayObject) : void
      {
      }
      
      public function eventOnRollOut(param1:DisplayObject) : void
      {
      }
      
      public function eventOnShortcut(param1:String) : Boolean
      {
         return false;
      }
      
      private function onRotateMountains(param1:Event) : void
      {
         var _loc2_:GraphicContainer = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc6_:int = 0;
         this._bMovingMountains = true;
         if(this._nRotationStep == 0)
         {
            this.endRotationMountains();
         }
         if(Math.abs(this._nRotationPieceTrg - this._nRotation) < 0.01)
         {
            this._nRotation = this._nRotationPieceTrg;
         }
         else
         {
            this._nRotation = this._nRotation + (this._nRotationPieceTrg - this._nRotation) / 3;
         }
         var _loc5_:Array = new Array();
         for each(_loc2_ in this._aMountainsCtr)
         {
            _loc3_ = (this._nRotation + this._nRotationStep * _loc6_) % (2 * Math.PI);
            _loc4_ = Math.abs(Math.PI - (_loc3_ < 0?_loc3_ + 2 * Math.PI:_loc3_) % (2 * Math.PI)) / Math.PI;
            _loc5_.push({
               "ctr":_loc2_,
               "z":_loc4_
            });
            _loc2_.x = this._nWidthEllipsis * Math.cos(_loc3_ + Math.PI / 2) + this._nXCenterEllipsis;
            _loc2_.y = this._nHeightEllipsis * Math.sin(_loc3_ + Math.PI / 2) + this._nYCenterEllipsis;
            if(this._nNbCharacters == 2)
            {
               if(_loc2_.y < 300)
               {
                  _loc2_.x = this._nWidthEllipsis * Math.cos(_loc3_ + Math.PI / 6 + Math.PI / 2) + this._nXCenterEllipsis;
                  _loc2_.y = this._nHeightEllipsis * Math.sin(_loc3_ + Math.PI / 6 + Math.PI / 2) + this._nYCenterEllipsis;
               }
            }
            if(this._nNbCharacters == 4)
            {
               if(_loc2_.y < 300)
               {
                  _loc2_.x = this._nWidthEllipsis * Math.cos(_loc3_ + Math.PI / 6 + Math.PI / 2) + this._nXCenterEllipsis;
                  _loc2_.y = this._nHeightEllipsis * Math.sin(_loc3_ + Math.PI / 6 + Math.PI / 2) + this._nYCenterEllipsis;
               }
            }
            _loc2_.scaleX = _loc2_.scaleY = Math.max(0.3,_loc4_);
            _loc2_.alpha = Math.max(0.3,_loc4_);
            if(_loc2_.numChildren == 3)
            {
               _loc2_.getChildAt(0).visible = _loc2_.getChildAt(1).visible = _loc6_ == this._nSelectedChara;
               _loc2_.getChildAt(2).visible = _loc6_ != this._nSelectedChara;
            }
            _loc6_++;
         }
         _loc5_.sortOn("z",Array.NUMERIC);
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc5_[_loc6_].ctr.parent.addChildAt(_loc5_[_loc6_].ctr,this._ctrDepth[_loc6_]);
            _loc6_++;
         }
         if(this._charaSelCtr)
         {
            this._charaSelCtr.setChildIndex(this._frontZCtr,this._charaSelCtr.numChildren - 1);
         }
         if(this._nRotationPieceTrg == this._nRotation)
         {
            this.endRotationMountains();
         }
      }
   }
}

import com.ankamagames.jerakine.entities.interfaces.IEntity;
import com.ankamagames.jerakine.types.positions.MapPoint;
import com.ankamagames.tiphon.display.TiphonSprite;
import com.ankamagames.tiphon.types.look.TiphonEntityLook;

class TiphonEntity extends TiphonSprite implements IEntity
{
    
   
   private var _id:uint;
   
   function TiphonEntity(param1:uint, param2:TiphonEntityLook)
   {
      super(param2);
      this._id = param1;
      mouseEnabled = false;
      mouseChildren = false;
   }
   
   public function get id() : int
   {
      return this._id;
   }
   
   public function set id(param1:int) : void
   {
      this._id = param1;
   }
   
   public function get position() : MapPoint
   {
      return null;
   }
   
   public function set position(param1:MapPoint) : void
   {
   }
}

class CBI
{
    
   
   public var id:int;
   
   public var gfxId:int;
   
   public var breed:int;
   
   public var colors:Array;
   
   function CBI(param1:uint, param2:int, param3:Array)
   {
      this.colors = new Array();
      super();
      this.id = param1;
      this.breed = param2;
      this.colors = param3;
   }
}
