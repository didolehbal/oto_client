package com.ankamagames.atouin.types.sequences
{
   import com.ankamagames.atouin.utils.CellUtil;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import gs.TweenMax;
   import gs.easing.Linear;
   import gs.events.TweenEvent;
   
   public class ParableGfxMovementStep extends AbstractSequencable
   {
       
      
      private var _gfxEntity:IMovable;
      
      private var _targetPoint:MapPoint;
      
      private var _curvePrc:Number;
      
      private var _yOffset:int;
      
      private var _yOffsetOnHit:int;
      
      private var _waitEnd:Boolean;
      
      private var _speed:uint;
      
      public function ParableGfxMovementStep(param1:IMovable, param2:MapPoint, param3:uint, param4:Number = 0.5, param5:int = 0, param6:Boolean = true, param7:int = 0)
      {
         super();
         this._gfxEntity = param1;
         this._targetPoint = param2;
         this._curvePrc = param4;
         this._waitEnd = param6;
         this._speed = param3;
         this._yOffset = param5;
         this._yOffsetOnHit = param7;
      }
      
      override public function start() : void
      {
         var _loc1_:Number = NaN;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         if(this._targetPoint.equals(this._gfxEntity.position))
         {
            this.onTweenEnd(null);
            return;
         }
         var _loc2_:Point = new Point(CellUtil.getPixelXFromMapPoint((this._gfxEntity as IEntity).position),CellUtil.getPixelYFromMapPoint((this._gfxEntity as IEntity).position) + this._yOffset);
         _loc3_ = new Point(CellUtil.getPixelXFromMapPoint(this._targetPoint),CellUtil.getPixelYFromMapPoint(this._targetPoint) + (this._yOffsetOnHit != 0?this._yOffsetOnHit:this._yOffset));
         _loc1_ = Point.distance(_loc2_,_loc3_);
         _loc4_ = Point.interpolate(_loc2_,_loc3_,0.5);
         _loc4_.y = _loc4_.y - _loc1_ * this._curvePrc;
         DisplayObject(this._gfxEntity).y = DisplayObject(this._gfxEntity).y + this._yOffset;
         var _loc5_:TweenMax;
         (_loc5_ = new TweenMax(this._gfxEntity,_loc1_ / 100 * this._speed / 1000,{
            "x":_loc3_.x,
            "y":_loc3_.y,
            "orientToBezier":true,
            "bezier":[{
               "x":_loc4_.x,
               "y":_loc4_.y
            }],
            "scaleX":1,
            "scaleY":1,
            "rotation":15,
            "alpha":1,
            "ease":Linear.easeNone,
            "renderOnStart":true
         })).addEventListener(TweenEvent.COMPLETE,this.onTweenEnd);
         if(!this._waitEnd)
         {
            executeCallbacks();
         }
      }
      
      private function onTweenEnd(param1:TweenEvent) : void
      {
         if(this._waitEnd)
         {
            executeCallbacks();
         }
      }
   }
}
