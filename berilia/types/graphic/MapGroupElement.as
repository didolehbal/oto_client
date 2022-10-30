package com.ankamagames.berilia.types.graphic
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   import gs.TweenMax;
   import gs.events.TweenEvent;
   
   public class MapGroupElement extends Sprite
   {
       
      
      private var _icons:Array;
      
      private var _initialPos:Array;
      
      private var _mapWidth:uint;
      
      private var _mapHeight:uint;
      
      private var _tween:Array;
      
      private var _shape:Shape;
      
      private var _open:Boolean;
      
      public function MapGroupElement(param1:uint, param2:uint)
      {
         this._icons = new Array();
         super();
         this._mapWidth = param1;
         this._mapHeight = param2;
         doubleClickEnabled = true;
      }
      
      public function get opened() : Boolean
      {
         return this._open;
      }
      
      public function open() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc8_:Boolean = false;
         var _loc5_:uint = this._icons.length * 5;
         var _loc6_:Point = new Point(0,0);
         if(_loc5_ < this._mapWidth * 3 / 4)
         {
            _loc5_ = this._mapWidth * 3 / 4;
         }
         if(_loc5_ < this._mapHeight * 3 / 4)
         {
            _loc5_ = this._mapHeight * 3 / 4;
         }
         var _loc7_:Number = Math.min(0.1 * this._icons.length,0.5);
         if(!this._shape)
         {
            this._shape = new Shape();
         }
         else
         {
            this._shape.graphics.clear();
         }
         this._shape.alpha = 0;
         this._shape.graphics.beginGradientFill(GradientType.RADIAL,[16777215,16777215],[0,0.6],[0,127]);
         this._shape.graphics.drawCircle(_loc6_.x,_loc6_.y,_loc5_ + 10);
         this._shape.graphics.beginFill(16777215,0.3);
         this._shape.graphics.drawCircle(_loc6_.x,_loc6_.y,Math.min(this._mapWidth,this._mapHeight) / 3);
         super.addChildAt(this._shape,0);
         this.killAllTween();
         this._tween.push(new TweenMax(this._shape,_loc7_,{"alpha":1}));
         if(!this._initialPos)
         {
            this._initialPos = new Array();
            _loc8_ = true;
         }
         var _loc9_:Number = Math.PI * 2 / this._icons.length;
         var _loc10_:Number = Math.PI / 2 + Math.PI / 4;
         var _loc11_:int = this._icons.length - 1;
         while(_loc11_ >= 0)
         {
            _loc1_ = this._icons[_loc11_];
            if(_loc8_)
            {
               this._initialPos.push({
                  "icon":_loc1_,
                  "x":_loc1_.x,
                  "y":_loc1_.y
               });
            }
            _loc2_ = Math.cos(_loc9_ * _loc11_ + _loc10_) * _loc5_ + _loc6_.x;
            _loc3_ = Math.sin(_loc9_ * _loc11_ + _loc10_) * _loc5_ + _loc6_.y;
            if(_loc1_.parent != this)
            {
               _loc2_ = (_loc4_ = this.getInitialPos(_loc1_)).x + _loc2_;
               _loc3_ = _loc4_.y + _loc3_;
            }
            this._tween.push(new TweenMax(_loc1_,_loc7_,{
               "x":_loc2_,
               "y":_loc3_
            }));
            _loc11_--;
         }
         this._open = true;
      }
      
      private function getInitialPos(param1:Object) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._initialPos)
         {
            if(_loc2_.icon == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function close() : void
      {
         var _loc1_:Object = null;
         graphics.clear();
         this.killAllTween();
         this._tween.push(new TweenMax(this._shape,0.2,{
            "alpha":0,
            "onCompleteListener":this.shapeTweenFinished
         }));
         for each(_loc1_ in this._initialPos)
         {
            this._tween.push(new TweenMax(_loc1_.icon,0.2,{
               "x":_loc1_.x,
               "y":_loc1_.y
            }));
         }
         this._open = false;
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         super.addChild(param1);
         this._icons.push(param1);
         return param1;
      }
      
      public function remove() : void
      {
         while(numChildren)
         {
            removeChildAt(0);
         }
         this._icons = null;
         this.killAllTween();
      }
      
      private function killAllTween() : void
      {
         var _loc1_:TweenMax = null;
         for each(_loc1_ in this._tween)
         {
            _loc1_.clear();
            _loc1_.gc = true;
         }
         this._tween = new Array();
      }
      
      private function shapeTweenFinished(param1:TweenEvent) : void
      {
         this._shape.graphics.clear();
      }
      
      public function get icons() : Array
      {
         return this._icons;
      }
   }
}
