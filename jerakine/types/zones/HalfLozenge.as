package com.ankamagames.jerakine.types.zones
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.utils.getQualifiedClassName;
   
   public class HalfLozenge implements IZone
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HalfLozenge));
       
      
      private var _radius:uint = 0;
      
      private var _minRadius:uint = 2;
      
      private var _direction:uint = 6;
      
      private var _dataMapProvider:IDataMapProvider;
      
      public function HalfLozenge(param1:uint, param2:uint, param3:IDataMapProvider)
      {
         super();
         this.radius = param2;
         this._minRadius = param1;
         this._dataMapProvider = param3;
      }
      
      public function get radius() : uint
      {
         return this._radius;
      }
      
      public function set radius(param1:uint) : void
      {
         this._radius = param1;
      }
      
      public function set minRadius(param1:uint) : void
      {
         this._minRadius = param1;
      }
      
      public function get minRadius() : uint
      {
         return this._minRadius;
      }
      
      public function set direction(param1:uint) : void
      {
         this._direction = param1;
      }
      
      public function get direction() : uint
      {
         return this._direction;
      }
      
      public function get surface() : uint
      {
         return this._radius * 2 + 1;
      }
      
      public function getCells(param1:uint = 0) : Vector.<uint>
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc9_:uint = 0;
         var _loc4_:Vector.<uint> = new Vector.<uint>();
         var _loc5_:MapPoint;
         var _loc6_:int = (_loc5_ = MapPoint.fromCellId(param1)).x;
         var _loc7_:int = _loc5_.y;
         if(this._minRadius == 0)
         {
            _loc4_.push(param1);
         }
         var _loc8_:int = 1;
         _loc2_ = 1;
         for(; _loc2_ <= this._radius; _loc2_++)
         {
            switch(this._direction)
            {
               case DirectionsEnum.UP_LEFT:
                  this.addCell(_loc6_ + _loc2_,_loc7_ + _loc2_,_loc4_);
                  this.addCell(_loc6_ + _loc2_,_loc7_ - _loc2_,_loc4_);
                  continue;
               case DirectionsEnum.UP_RIGHT:
                  this.addCell(_loc6_ - _loc2_,_loc7_ - _loc2_,_loc4_);
                  this.addCell(_loc6_ + _loc2_,_loc7_ - _loc2_,_loc4_);
                  continue;
               case DirectionsEnum.DOWN_RIGHT:
                  this.addCell(_loc6_ - _loc2_,_loc7_ + _loc2_,_loc4_);
                  this.addCell(_loc6_ - _loc2_,_loc7_ - _loc2_,_loc4_);
                  continue;
               case DirectionsEnum.DOWN_LEFT:
                  this.addCell(_loc6_ - _loc2_,_loc7_ + _loc2_,_loc4_);
                  this.addCell(_loc6_ + _loc2_,_loc7_ + _loc2_,_loc4_);
                  continue;
               default:
                  continue;
            }
         }
         return _loc4_;
      }
      
      private function addCell(param1:int, param2:int, param3:Vector.<uint>) : void
      {
         if(this._dataMapProvider == null || this._dataMapProvider.pointMov(param1,param2))
         {
            param3.push(MapPoint.fromCoords(param1,param2).cellId);
         }
      }
   }
}
