package com.ankamagames.jerakine.types.zones
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.utils.getQualifiedClassName;
   
   public class Line implements IZone
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Line));
       
      
      private var _radius:uint = 0;
      
      private var _minRadius:uint = 0;
      
      private var _nDirection:uint = 1;
      
      private var _dataMapProvider:IDataMapProvider;
      
      public function Line(param1:uint, param2:IDataMapProvider)
      {
         super();
         this.radius = param1;
         this._dataMapProvider = param2;
      }
      
      public function get radius() : uint
      {
         return this._radius;
      }
      
      public function set radius(param1:uint) : void
      {
         this._radius = param1;
      }
      
      public function get surface() : uint
      {
         return this._radius + 1;
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
         this._nDirection = param1;
      }
      
      public function get direction() : uint
      {
         return this._nDirection;
      }
      
      public function getCells(param1:uint = 0) : Vector.<uint>
      {
         var _loc2_:Boolean = false;
         var _loc3_:Vector.<uint> = new Vector.<uint>();
         var _loc4_:MapPoint;
         var _loc5_:int = (_loc4_ = MapPoint.fromCellId(param1)).x;
         var _loc6_:int = _loc4_.y;
         var _loc7_:int = this._minRadius;
         for(; _loc7_ <= this._radius; _loc7_++)
         {
            switch(this._nDirection)
            {
               case DirectionsEnum.LEFT:
                  if(MapPoint.isInMap(_loc5_ - _loc7_,_loc6_ - _loc7_))
                  {
                     _loc2_ = this.addCell(_loc5_ - _loc7_,_loc6_ - _loc7_,_loc3_);
                  }
                  continue;
               case DirectionsEnum.UP:
                  if(MapPoint.isInMap(_loc5_ - _loc7_,_loc6_ + _loc7_))
                  {
                     _loc2_ = this.addCell(_loc5_ - _loc7_,_loc6_ + _loc7_,_loc3_);
                  }
                  continue;
               case DirectionsEnum.RIGHT:
                  if(MapPoint.isInMap(_loc5_ + _loc7_,_loc6_ + _loc7_))
                  {
                     _loc2_ = this.addCell(_loc5_ + _loc7_,_loc6_ + _loc7_,_loc3_);
                  }
                  continue;
               case DirectionsEnum.DOWN:
                  if(MapPoint.isInMap(_loc5_ + _loc7_,_loc6_ - _loc7_))
                  {
                     _loc2_ = this.addCell(_loc5_ + _loc7_,_loc6_ - _loc7_,_loc3_);
                  }
                  continue;
               case DirectionsEnum.UP_LEFT:
                  if(MapPoint.isInMap(_loc5_ - _loc7_,_loc6_))
                  {
                     _loc2_ = this.addCell(_loc5_ - _loc7_,_loc6_,_loc3_);
                  }
                  continue;
               case DirectionsEnum.DOWN_LEFT:
                  if(MapPoint.isInMap(_loc5_,_loc6_ - _loc7_))
                  {
                     _loc2_ = this.addCell(_loc5_,_loc6_ - _loc7_,_loc3_);
                  }
                  continue;
               case DirectionsEnum.DOWN_RIGHT:
                  if(MapPoint.isInMap(_loc5_ + _loc7_,_loc6_))
                  {
                     _loc2_ = this.addCell(_loc5_ + _loc7_,_loc6_,_loc3_);
                  }
                  continue;
               case DirectionsEnum.UP_RIGHT:
                  if(MapPoint.isInMap(_loc5_,_loc6_ + _loc7_))
                  {
                     _loc2_ = this.addCell(_loc5_,_loc6_ + _loc7_,_loc3_);
                  }
                  continue;
               default:
                  continue;
            }
         }
         return _loc3_;
      }
      
      private function addCell(param1:int, param2:int, param3:Vector.<uint>) : Boolean
      {
         if(this._dataMapProvider == null || this._dataMapProvider.pointMov(param1,param2))
         {
            param3.push(MapPoint.fromCoords(param1,param2).cellId);
            return true;
         }
         return false;
      }
   }
}
