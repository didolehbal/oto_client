package com.ankamagames.jerakine.types.zones
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.utils.getQualifiedClassName;
   
   public class Cone implements IZone
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Cone));
       
      
      private var _radius:uint = 0;
      
      private var _minRadius:uint = 0;
      
      private var _nDirection:uint = 1;
      
      private var _dataMapProvider:IDataMapProvider;
      
      private var _diagonalFree:Boolean = false;
      
      public function Cone(param1:uint, param2:uint, param3:IDataMapProvider)
      {
         super();
         this.radius = param2;
         this.minRadius = param1;
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
         this._nDirection = param1;
      }
      
      public function get direction() : uint
      {
         return this._nDirection;
      }
      
      public function get surface() : uint
      {
         return Math.pow(this._radius + 1,2);
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
         if(this._radius == 0)
         {
            if(this._minRadius == 0)
            {
               _loc4_.push(param1);
            }
            return _loc4_;
         }
         var _loc8_:int = 1;
         switch(this._nDirection)
         {
            case DirectionsEnum.UP_LEFT:
               _loc2_ = _loc6_;
               while(_loc2_ >= _loc6_ - this._radius)
               {
                  _loc3_ = -_loc9_;
                  while(_loc3_ <= _loc9_)
                  {
                     if(!this._minRadius || Math.abs(_loc6_ - _loc2_) + Math.abs(_loc3_) >= this._minRadius)
                     {
                        if(MapPoint.isInMap(_loc2_,_loc3_ + _loc7_))
                        {
                           this.addCell(_loc2_,_loc3_ + _loc7_,_loc4_);
                        }
                     }
                     _loc3_++;
                  }
                  _loc9_ = _loc9_ + _loc8_;
                  _loc2_--;
               }
               break;
            case DirectionsEnum.DOWN_LEFT:
               _loc3_ = _loc7_;
               while(_loc3_ >= _loc7_ - this._radius)
               {
                  _loc2_ = -_loc9_;
                  while(_loc2_ <= _loc9_)
                  {
                     if(!this._minRadius || Math.abs(_loc2_) + Math.abs(_loc7_ - _loc3_) >= this._minRadius)
                     {
                        if(MapPoint.isInMap(_loc2_ + _loc6_,_loc3_))
                        {
                           this.addCell(_loc2_ + _loc6_,_loc3_,_loc4_);
                        }
                     }
                     _loc2_++;
                  }
                  _loc9_ = _loc9_ + _loc8_;
                  _loc3_--;
               }
               break;
            case DirectionsEnum.DOWN_RIGHT:
               _loc2_ = _loc6_;
               while(_loc2_ <= _loc6_ + this._radius)
               {
                  _loc3_ = -_loc9_;
                  while(_loc3_ <= _loc9_)
                  {
                     if(!this._minRadius || Math.abs(_loc6_ - _loc2_) + Math.abs(_loc3_) >= this._minRadius)
                     {
                        if(MapPoint.isInMap(_loc2_,_loc3_ + _loc7_))
                        {
                           this.addCell(_loc2_,_loc3_ + _loc7_,_loc4_);
                        }
                     }
                     _loc3_++;
                  }
                  _loc9_ = _loc9_ + _loc8_;
                  _loc2_++;
               }
               break;
            case DirectionsEnum.UP_RIGHT:
               _loc3_ = _loc7_;
               while(_loc3_ <= _loc7_ + this._radius)
               {
                  _loc2_ = -_loc9_;
                  while(_loc2_ <= _loc9_)
                  {
                     if(!this._minRadius || Math.abs(_loc2_) + Math.abs(_loc7_ - _loc3_) >= this._minRadius)
                     {
                        if(MapPoint.isInMap(_loc2_ + _loc6_,_loc3_))
                        {
                           this.addCell(_loc2_ + _loc6_,_loc3_,_loc4_);
                        }
                     }
                     _loc2_++;
                  }
                  _loc9_ = _loc9_ + _loc8_;
                  _loc3_++;
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
