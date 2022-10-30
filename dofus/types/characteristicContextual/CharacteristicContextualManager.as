package com.ankamagames.dofus.types.characteristicContextual
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.network.enums.GameContextEnum;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class CharacteristicContextualManager extends EventDispatcher
   {
      
      private static const MAX_ENTITY_HEIGHT:uint = 250;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CharacteristicContextualManager));
      
      private static var _self:CharacteristicContextualManager;
      
      private static var _aEntitiesTweening:Array;
       
      
      private var _bEnterFrameNeeded:Boolean;
      
      private var _tweeningCount:uint;
      
      private var _tweenByEntities:Dictionary;
      
      private var _type:uint = 1;
      
      private var _statsIcons:Dictionary;
      
      public function CharacteristicContextualManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError("Warning : CharacteristicContextualManager is a singleton class and shoulnd\'t be instancied directly!");
         }
         _aEntitiesTweening = new Array();
         this._bEnterFrameNeeded = true;
         this._tweeningCount = 0;
         this._tweenByEntities = new Dictionary(true);
         this._statsIcons = new Dictionary(true);
      }
      
      public static function getInstance() : CharacteristicContextualManager
      {
         if(_self == null)
         {
            _self = new CharacteristicContextualManager();
         }
         return _self;
      }
      
      public function addStatContextual(param1:String, param2:IEntity, param3:TextFormat, param4:uint, param5:uint, param6:Number = 1, param7:uint = 2500) : CharacteristicContextual
      {
         var _loc8_:TextContextual = null;
         var _loc9_:StyledTextContextual = null;
         var _loc10_:TweenData = null;
         if(!param2 || param2.position.cellId == -1)
         {
            return null;
         }
         this._type = param4;
         var _loc11_:Array;
         var _loc12_:uint = (_loc11_ = [Math.abs(16711680 - (param3.color as uint)),Math.abs(255 - (param3.color as uint)),Math.abs(26112 - (param3.color as uint)),Math.abs(10053324 - (param3.color as uint))]).indexOf(Math.min(_loc11_[0],_loc11_[1],_loc11_[2],_loc11_[3]));
         switch(this._type)
         {
            case 1:
               (_loc8_ = new TextContextual()).referedEntity = param2;
               _loc8_.text = param1;
               _loc8_.textFormat = param3;
               _loc8_.gameContext = param5;
               _loc8_.finalize();
               if(!this._tweenByEntities[param2])
               {
                  this._tweenByEntities[param2] = new Array();
               }
               _loc10_ = new TweenData(_loc8_,param2,param6,param7);
               (this._tweenByEntities[param2] as Array).unshift(_loc10_);
               if((this._tweenByEntities[param2] as Array).length == 1)
               {
                  _aEntitiesTweening.push(_loc10_);
               }
               ++this._tweeningCount;
               this.beginTween(_loc8_);
               break;
            case 2:
               (_loc9_ = new StyledTextContextual(param1,_loc12_)).referedEntity = param2;
               _loc9_.gameContext = param5;
               if(!this._tweenByEntities[param2])
               {
                  this._tweenByEntities[param2] = new Array();
               }
               _loc10_ = new TweenData(_loc9_,param2,param6,param7);
               (this._tweenByEntities[param2] as Array).unshift(_loc10_);
               if((this._tweenByEntities[param2] as Array).length == 1)
               {
                  _aEntitiesTweening.push(_loc10_);
               }
               ++this._tweeningCount;
               this.beginTween(_loc9_);
         }
         return !!_loc8_?_loc8_:_loc9_;
      }
      
      public function addStatContextualWithIcon(param1:Texture, param2:String, param3:IEntity, param4:TextFormat, param5:uint, param6:uint, param7:Number = 1, param8:Number = 2500) : void
      {
         var _loc9_:Boolean = this._bEnterFrameNeeded;
         var _loc10_:CharacteristicContextual;
         if(_loc10_ = this.addStatContextual(param2,param3,param4,param5,param6,param7,param8))
         {
            this._statsIcons[_loc10_] = param1;
            param1.height = param1.width = _loc10_.height;
            param1.alpha = 0;
            Berilia.getInstance().strataLow.addChild(param1);
            if(_loc9_)
            {
               EnterFrameDispatcher.addEventListener(this.onIconScroll,"CharacteristicContextManagerIcon");
            }
         }
      }
      
      private function isIconDisplayed(param1:Texture, param2:CharacteristicContextual) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc4_:Boolean = false;
         for(_loc3_ in this._statsIcons)
         {
            if(this._statsIcons[_loc3_] == param1 && _loc3_ != param2)
            {
               _loc4_ = true;
               break;
            }
         }
         return _loc4_;
      }
      
      private function removeStatContextual(param1:Number) : void
      {
         var _loc2_:CharacteristicContextual = null;
         if(_aEntitiesTweening[param1] != null)
         {
            _loc2_ = _aEntitiesTweening[param1].context;
            _loc2_.remove();
            Berilia.getInstance().strataLow.removeChild(_loc2_);
            _aEntitiesTweening[param1] = null;
            delete _aEntitiesTweening[param1];
            if(this._statsIcons[_loc2_])
            {
               if(!this.isIconDisplayed(this._statsIcons[_loc2_],_loc2_))
               {
                  Berilia.getInstance().strataLow.removeChild(this._statsIcons[_loc2_]);
               }
               delete this._statsIcons[_loc2_];
            }
         }
      }
      
      private function removeTween(param1:int) : void
      {
         this.removeStatContextual(param1);
         --this._tweeningCount;
         if(this._tweeningCount == 0)
         {
            this._bEnterFrameNeeded = true;
            EnterFrameDispatcher.removeEventListener(this.onScroll);
            EnterFrameDispatcher.removeEventListener(this.onIconScroll);
         }
      }
      
      private function beginTween(param1:CharacteristicContextual) : void
      {
         Berilia.getInstance().strataLow.addChild(param1);
         var _loc2_:IRectangle = IDisplayable(param1.referedEntity).absoluteBounds;
         param1.x = (_loc2_.x + _loc2_.width / 2 - param1.width / 2 - StageShareManager.stageOffsetX) / StageShareManager.stageScaleX;
         param1.y = (_loc2_.y - param1.height - StageShareManager.stageOffsetY) / StageShareManager.stageScaleY;
         param1.alpha = 0;
         if(this._bEnterFrameNeeded)
         {
            EnterFrameDispatcher.addEventListener(this.onScroll,"CharacteristicContextManager");
            this._bEnterFrameNeeded = false;
         }
      }
      
      private function onScroll(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:TweenData = null;
         var _loc4_:CharacteristicContextual = null;
         var _loc5_:Array = null;
         var _loc6_:IRectangle = null;
         var _loc7_:Array = [];
         var _loc8_:uint = !!Kernel.getWorker().getFrame(RoleplayContextFrame)?uint(GameContextEnum.ROLE_PLAY):uint(GameContextEnum.FIGHT);
         for(_loc2_ in _aEntitiesTweening)
         {
            _loc3_ = _aEntitiesTweening[_loc2_];
            if(_loc3_)
            {
               _loc4_ = _loc3_.context;
               _loc4_.y = _loc4_.y - _loc3_.scrollSpeed;
               _loc3_._tweeningCurrentDistance = (getTimer() - _loc3_.startTime) / _loc3_.scrollDuration;
               if((_loc5_ = this._tweenByEntities[_loc3_.entity]) && _loc5_[_loc5_.length - 1] == _loc3_ && _loc3_._tweeningCurrentDistance > 0.5)
               {
                  _loc5_.pop();
                  if(_loc5_.length)
                  {
                     _loc5_[_loc5_.length - 1].startTime = getTimer();
                     _loc7_.push(_loc5_[_loc5_.length - 1]);
                  }
                  else
                  {
                     delete this._tweenByEntities[_loc3_.entity];
                  }
               }
               if(_loc4_.gameContext != _loc8_)
               {
                  this.removeTween(int(_loc2_));
               }
               else if(_loc3_._tweeningCurrentDistance < 1 / 8)
               {
                  _loc4_.alpha = _loc3_._tweeningCurrentDistance * 4;
                  if(this._type == 2)
                  {
                     _loc4_.scaleX = _loc3_._tweeningCurrentDistance * 24;
                     _loc4_.scaleY = _loc3_._tweeningCurrentDistance * 24;
                     _loc6_ = IDisplayable(_loc4_.referedEntity).absoluteBounds;
                     if(!(_loc4_.referedEntity is DisplayObject) || DisplayObject(_loc4_.referedEntity).parent)
                     {
                        _loc4_.x = (_loc6_.x + _loc6_.width / 2 - _loc4_.width / 2 - StageShareManager.stageOffsetX) / StageShareManager.stageScaleX;
                     }
                  }
               }
               else if(_loc3_._tweeningCurrentDistance < 1 / 4)
               {
                  _loc4_.alpha = _loc3_._tweeningCurrentDistance * 4;
                  if(this._type == 2)
                  {
                     _loc4_.scaleX = 3 - _loc3_._tweeningCurrentDistance * 8;
                     _loc4_.scaleY = 3 - _loc3_._tweeningCurrentDistance * 8;
                     _loc6_ = IDisplayable(_loc4_.referedEntity).absoluteBounds;
                     if(!(_loc4_.referedEntity is DisplayObject) || DisplayObject(_loc4_.referedEntity).parent)
                     {
                        _loc4_.x = (_loc6_.x + _loc6_.width / 2 - _loc4_.width / 2 - StageShareManager.stageOffsetX) / StageShareManager.stageScaleX;
                     }
                  }
               }
               else if(_loc3_._tweeningCurrentDistance >= 3 / 4 && _loc3_._tweeningCurrentDistance < 1)
               {
                  _loc4_.alpha = 1 - _loc3_._tweeningCurrentDistance;
               }
               else if(_loc3_._tweeningCurrentDistance >= 1)
               {
                  this.removeTween(int(_loc2_));
               }
               else
               {
                  _loc4_.alpha = 1;
               }
            }
         }
         _aEntitiesTweening = _aEntitiesTweening.concat(_loc7_);
      }
      
      private function onIconScroll(param1:Event) : void
      {
         var _loc2_:Texture = null;
         var _loc3_:CharacteristicContextual = null;
         var _loc4_:* = null;
         var _loc5_:TweenData = null;
         for(_loc4_ in _aEntitiesTweening)
         {
            if(_loc5_ = _aEntitiesTweening[_loc4_])
            {
               _loc3_ = _loc5_.context;
               _loc2_ = this._statsIcons[_loc3_];
               if(_loc2_)
               {
                  _loc2_.alpha = _loc3_.alpha;
                  _loc2_.y = _loc3_.y;
                  _loc2_.x = _loc3_.x - _loc2_.width;
               }
            }
         }
      }
   }
}

import com.ankamagames.dofus.types.characteristicContextual.CharacteristicContextual;
import com.ankamagames.jerakine.entities.interfaces.IEntity;
import flash.utils.getTimer;

class TweenData
{
    
   
   public var entity:IEntity;
   
   public var context:CharacteristicContextual;
   
   public var scrollSpeed:Number;
   
   public var scrollDuration:uint;
   
   public var _tweeningTotalDistance:uint = 40;
   
   public var _tweeningCurrentDistance:Number = 0;
   
   public var alpha:Number = 0;
   
   public var startTime:int;
   
   function TweenData(param1:CharacteristicContextual, param2:IEntity, param3:Number, param4:uint)
   {
      this.startTime = getTimer();
      super();
      this.context = param1;
      this.entity = param2;
      this.scrollSpeed = param3;
      this.scrollDuration = param4;
   }
}
