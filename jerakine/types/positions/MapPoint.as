package com.ankamagames.jerakine.types.positions
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.utils.errors.JerakineError;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   
   public class MapPoint
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MapPoint));
      
      private static const VECTOR_RIGHT:Point = new Point(1,1);
      
      private static const VECTOR_DOWN_RIGHT:Point = new Point(1,0);
      
      private static const VECTOR_DOWN:Point = new Point(1,-1);
      
      private static const VECTOR_DOWN_LEFT:Point = new Point(0,-1);
      
      private static const VECTOR_LEFT:Point = new Point(-1,-1);
      
      private static const VECTOR_UP_LEFT:Point = new Point(-1,0);
      
      private static const VECTOR_UP:Point = new Point(-1,1);
      
      private static const VECTOR_UP_RIGHT:Point = new Point(0,1);
      
      public static const MAP_WIDTH:uint = 14;
      
      public static const MAP_HEIGHT:uint = 20;
      
      private static var _bInit:Boolean = false;
      
      public static var CELLPOS:Array = new Array();
       
      
      private var _nCellId:uint;
      
      private var _nX:int;
      
      private var _nY:int;
      
      public function MapPoint()
      {
         super();
      }
      
      public static function fromCellId(param1:uint) : MapPoint
      {
         var _loc2_:MapPoint = new MapPoint();
         _loc2_._nCellId = param1;
         _loc2_.setFromCellId();
         return _loc2_;
      }
      
      public static function fromCoords(param1:int, param2:int) : MapPoint
      {
         var _loc3_:MapPoint = new MapPoint();
         _loc3_._nX = param1;
         _loc3_._nY = param2;
         _loc3_.setFromCoords();
         return _loc3_;
      }
      
      public static function getOrientationsDistance(param1:int, param2:int) : int
      {
         return Math.min(Math.abs(param2 - param1),Math.abs(8 - param2 + param1));
      }
      
      public static function isInMap(param1:int, param2:int) : Boolean
      {
         return param1 + param2 >= 0 && param1 - param2 >= 0 && param1 - param2 < MAP_HEIGHT * 2 && param1 + param2 < MAP_WIDTH * 2;
      }
      
      private static function init() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _bInit = true;
         while(_loc5_ < MAP_HEIGHT)
         {
            _loc1_ = 0;
            while(_loc1_ < MAP_WIDTH)
            {
               CELLPOS[_loc4_] = new Point(_loc2_ + _loc1_,_loc3_ + _loc1_);
               _loc4_++;
               _loc1_++;
            }
            _loc2_++;
            _loc1_ = 0;
            while(_loc1_ < MAP_WIDTH)
            {
               CELLPOS[_loc4_] = new Point(_loc2_ + _loc1_,_loc3_ + _loc1_);
               _loc4_++;
               _loc1_++;
            }
            _loc3_--;
            _loc5_++;
         }
      }
      
      public function get cellId() : uint
      {
         return this._nCellId;
      }
      
      public function set cellId(param1:uint) : void
      {
         this._nCellId = param1;
         this.setFromCellId();
      }
      
      public function get x() : int
      {
         return this._nX;
      }
      
      public function set x(param1:int) : void
      {
         this._nX = param1;
         this.setFromCoords();
      }
      
      public function get y() : int
      {
         return this._nY;
      }
      
      public function set y(param1:int) : void
      {
         this._nY = param1;
         this.setFromCoords();
      }
      
      public function get coordinates() : Point
      {
         return new Point(this._nX,this._nY);
      }
      
      public function distanceTo(param1:MapPoint) : uint
      {
         return Math.sqrt(Math.pow(param1.x - this.x,2) + Math.pow(param1.y - this.y,2));
      }
      
      public function distanceToCell(param1:MapPoint) : int
      {
         return Math.abs(this.x - param1.x) + Math.abs(this.y - param1.y);
      }
      
      public function orientationTo(param1:MapPoint) : uint
      {
         var _loc2_:uint = 0;
         if(this.x == param1.x && this.y == param1.y)
         {
            return 1;
         }
         var _loc3_:Point = new Point();
         _loc3_.x = param1.x > this.x?Number(1):param1.x < this.x?Number(-1):Number(0);
         _loc3_.y = param1.y > this.y?Number(1):param1.y < this.y?Number(-1):Number(0);
         if(_loc3_.x == VECTOR_RIGHT.x && _loc3_.y == VECTOR_RIGHT.y)
         {
            _loc2_ = DirectionsEnum.RIGHT;
         }
         else if(_loc3_.x == VECTOR_DOWN_RIGHT.x && _loc3_.y == VECTOR_DOWN_RIGHT.y)
         {
            _loc2_ = DirectionsEnum.DOWN_RIGHT;
         }
         else if(_loc3_.x == VECTOR_DOWN.x && _loc3_.y == VECTOR_DOWN.y)
         {
            _loc2_ = DirectionsEnum.DOWN;
         }
         else if(_loc3_.x == VECTOR_DOWN_LEFT.x && _loc3_.y == VECTOR_DOWN_LEFT.y)
         {
            _loc2_ = DirectionsEnum.DOWN_LEFT;
         }
         else if(_loc3_.x == VECTOR_LEFT.x && _loc3_.y == VECTOR_LEFT.y)
         {
            _loc2_ = DirectionsEnum.LEFT;
         }
         else if(_loc3_.x == VECTOR_UP_LEFT.x && _loc3_.y == VECTOR_UP_LEFT.y)
         {
            _loc2_ = DirectionsEnum.UP_LEFT;
         }
         else if(_loc3_.x == VECTOR_UP.x && _loc3_.y == VECTOR_UP.y)
         {
            _loc2_ = DirectionsEnum.UP;
         }
         else if(_loc3_.x == VECTOR_UP_RIGHT.x && _loc3_.y == VECTOR_UP_RIGHT.y)
         {
            _loc2_ = DirectionsEnum.UP_RIGHT;
         }
         return _loc2_;
      }
      
      public function advancedOrientationTo(param1:MapPoint, param2:Boolean = true) : uint
      {
         if(!param1)
         {
            return 0;
         }
         var _loc3_:int = param1.x - this.x;
         var _loc4_:int = this.y - param1.y;
         var _loc5_:int = Math.acos(_loc3_ / Math.sqrt(Math.pow(_loc3_,2) + Math.pow(_loc4_,2))) * 180 / Math.PI * (param1.y > this.y?-1:1);
         if(param2)
         {
            _loc5_ = Math.round(_loc5_ / 90) * 2 + 1;
         }
         else
         {
            _loc5_ = Math.round(_loc5_ / 45) + 1;
         }
         if(_loc5_ < 0)
         {
            _loc5_ = _loc5_ + 8;
         }
         return _loc5_;
      }
      
      public function getNearestFreeCell(param1:IDataMapProvider, param2:Boolean = true) : MapPoint
      {
         var _loc3_:MapPoint = null;
         var _loc4_:uint = 0;
         while(_loc4_ < 8)
         {
            _loc3_ = this.getNearestFreeCellInDirection(_loc4_,param1,false,param2);
            if(_loc3_)
            {
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getNearestCellInDirection(param1:uint) : MapPoint
      {
         var _loc2_:MapPoint = null;
         switch(param1)
         {
            case 0:
               _loc2_ = MapPoint.fromCoords(this._nX + 1,this._nY + 1);
               break;
            case 1:
               _loc2_ = MapPoint.fromCoords(this._nX + 1,this._nY);
               break;
            case 2:
               _loc2_ = MapPoint.fromCoords(this._nX + 1,this._nY - 1);
               break;
            case 3:
               _loc2_ = MapPoint.fromCoords(this._nX,this._nY - 1);
               break;
            case 4:
               _loc2_ = MapPoint.fromCoords(this._nX - 1,this._nY - 1);
               break;
            case 5:
               _loc2_ = MapPoint.fromCoords(this._nX - 1,this._nY);
               break;
            case 6:
               _loc2_ = MapPoint.fromCoords(this._nX - 1,this._nY + 1);
               break;
            case 7:
               _loc2_ = MapPoint.fromCoords(this._nX,this._nY + 1);
         }
         if(MapPoint.isInMap(_loc2_._nX,_loc2_._nY))
         {
            return _loc2_;
         }
         return null;
      }
      
      public function getNearestFreeCellInDirection(param1:uint, param2:IDataMapProvider, param3:Boolean = true, param4:Boolean = true, param5:Boolean = false, param6:Array = null) : MapPoint
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:MapPoint = null;
         var _loc13_:int = 0;
         if(param6 == null)
         {
            param6 = new Array();
         }
         var _loc11_:Vector.<MapPoint> = new Vector.<MapPoint>(8,true);
         var _loc12_:Vector.<int> = new Vector.<int>(8,true);
         _loc7_ = 0;
         while(_loc7_ < 8)
         {
            if((_loc10_ = this.getNearestCellInDirection(_loc7_)) != null && param6.indexOf(_loc10_.cellId) == -1)
            {
               _loc8_ = param2.getCellSpeed(_loc10_.cellId);
               if(!param2.pointMov(_loc10_._nX,_loc10_._nY,param4,this.cellId))
               {
                  _loc8_ = -100;
               }
               _loc12_[_loc7_] = getOrientationsDistance(_loc7_,param1) + (!!param5?0:_loc8_ >= 0?5 - _loc8_:11 + Math.abs(_loc8_));
            }
            else
            {
               _loc12_[_loc7_] = 1000;
            }
            _loc11_[_loc7_] = _loc10_;
            _loc7_++;
         }
         _loc10_ = null;
         var _loc14_:int = _loc12_[0];
         _loc7_ = 1;
         while(_loc7_ < 8)
         {
            if((_loc9_ = _loc12_[_loc7_]) < _loc14_ && _loc11_[_loc7_] != null)
            {
               _loc14_ = _loc9_;
               _loc13_ = _loc7_;
            }
            _loc7_++;
         }
         if((_loc10_ = _loc11_[_loc13_]) == null && param3 && param2.pointMov(this._nX,this._nY,param4,this.cellId))
         {
            return this;
         }
         return _loc10_;
      }
      
      public function pointSymetry(param1:MapPoint) : MapPoint
      {
         var _loc2_:int = 2 * param1.x - this.x;
         var _loc3_:int = 2 * param1.y - this.y;
         if(isInMap(_loc2_,_loc3_))
         {
            return MapPoint.fromCoords(_loc2_,_loc3_);
         }
         return null;
      }
      
      public function equals(param1:MapPoint) : Boolean
      {
         return param1.cellId == this.cellId;
      }
      
      public function toString() : String
      {
         return "[MapPoint(x:" + this._nX + ", y:" + this._nY + ", id:" + this._nCellId + ")]";
      }
      
      private function setFromCoords() : void
      {
         if(!_bInit)
         {
            init();
         }
         this._nCellId = (this._nX - this._nY) * MAP_WIDTH + this._nY + (this._nX - this._nY) / 2;
      }
      
      private function setFromCellId() : void
      {
         if(!_bInit)
         {
            init();
         }
         if(!CELLPOS[this._nCellId])
         {
            throw new JerakineError("Cell identifier out of bounds (" + this._nCellId + ").");
         }
         var _loc1_:Point = CELLPOS[this._nCellId];
         this._nX = _loc1_.x;
         this._nY = _loc1_.y;
      }
   }
}
