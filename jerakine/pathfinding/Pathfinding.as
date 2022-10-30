package com.ankamagames.jerakine.pathfinding
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.types.positions.PathElement;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class Pathfinding
   {
      
      private static var _minX:int;
      
      private static var _maxX:int;
      
      private static var _minY:int;
      
      private static var _maxY:int;
      
      protected static var _log:Logger = Log.getLogger(getQualifiedClassName(Pathfinding));
      
      private static var _self:Pathfinding;
       
      
      private var _mapStatus:Array;
      
      private var _openList:Array;
      
      private var _movPath:MovementPath;
      
      private var _nHVCost:uint = 10;
      
      private var _nDCost:uint = 15;
      
      private var _nHeuristicCost:uint = 10;
      
      private var _bAllowDiagCornering:Boolean = false;
      
      private var _bAllowTroughEntity:Boolean;
      
      private var _bIsFighting:Boolean;
      
      private var _callBackFunction:Function;
      
      private var _argsFunction:Array;
      
      private var _enterFrameIsActive:Boolean = false;
      
      private var _map:IDataMapProvider;
      
      private var _start:MapPoint;
      
      private var _end:MapPoint;
      
      private var _allowDiag:Boolean;
      
      private var _endX:int;
      
      private var _endY:int;
      
      private var _endPoint:MapPoint;
      
      private var _startPoint:MapPoint;
      
      private var _startX:int;
      
      private var _startY:int;
      
      private var _endPointAux:MapPoint;
      
      private var _endAuxX:int;
      
      private var _endAuxY:int;
      
      private var _distanceToEnd:int;
      
      private var _nowY:int;
      
      private var _nowX:int;
      
      private var _currentTime:int;
      
      private var _maxTime:int = 30;
      
      private var _previousCellId:int;
      
      public function Pathfinding()
      {
         super();
      }
      
      public static function init(param1:int, param2:int, param3:int, param4:int) : void
      {
         _minX = param1;
         _maxX = param2;
         _minY = param3;
         _maxY = param4;
      }
      
      public static function findPath(param1:IDataMapProvider, param2:MapPoint, param3:MapPoint, param4:Boolean = true, param5:Boolean = true, param6:Function = null, param7:Array = null, param8:Boolean = false) : MovementPath
      {
         return new Pathfinding().processFindPath(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public function processFindPath(param1:IDataMapProvider, param2:MapPoint, param3:MapPoint, param4:Boolean = true, param5:Boolean = true, param6:Function = null, param7:Array = null, param8:Boolean = false) : MovementPath
      {
         this._callBackFunction = param6;
         this._argsFunction = param7;
         this._movPath = new MovementPath();
         this._movPath.start = param2;
         this._movPath.end = param3;
         this._bAllowTroughEntity = param5;
         this._bIsFighting = param8;
         this._bAllowDiagCornering = param4;
         if(param1.height == 0 || param1.width == 0 || param2 == null)
         {
            return this._movPath;
         }
         this.findPathInternal(param1,param2,param3,param4);
         if(this._callBackFunction == null)
         {
            return this._movPath;
         }
         return null;
      }
      
      private function isOpened(param1:int, param2:int) : Boolean
      {
         return this._mapStatus[param1][param2].opened;
      }
      
      private function isClosed(param1:int, param2:int) : Boolean
      {
         var _loc3_:CellInfo = this._mapStatus[param1][param2];
         if(!_loc3_ || !_loc3_.closed)
         {
            return false;
         }
         return _loc3_.closed;
      }
      
      private function nearerSquare() : uint
      {
         var _loc1_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc2_:Number = 9999999;
         var _loc4_:int = -1;
         var _loc5_:int = this._openList.length;
         while(++_loc4_ < _loc5_)
         {
            _loc1_ = this._mapStatus[this._openList[_loc4_][0]][this._openList[_loc4_][1]].heuristic + this._mapStatus[this._openList[_loc4_][0]][this._openList[_loc4_][1]].movementCost;
            _loc1_ = this._mapStatus[this._openList[_loc4_][0]][this._openList[_loc4_][1]].heuristic + this._mapStatus[this._openList[_loc4_][0]][this._openList[_loc4_][1]].movementCost;
            if(_loc1_ <= _loc2_)
            {
               _loc2_ = _loc1_;
               _loc3_ = _loc4_;
            }
         }
         return _loc3_;
      }
      
      private function closeSquare(param1:int, param2:int) : void
      {
         var _loc3_:uint = this._openList.length;
         var _loc4_:int = -1;
         while(++_loc4_ < _loc3_)
         {
            if(this._openList[_loc4_][0] == param1)
            {
               if(this._openList[_loc4_][1] == param2)
               {
                  this._openList.splice(_loc4_,1);
                  break;
               }
            }
         }
         var _loc5_:CellInfo;
         (_loc5_ = this._mapStatus[param1][param2]).opened = false;
         _loc5_.closed = true;
      }
      
      private function openSquare(param1:int, param2:int, param3:Array, param4:uint, param5:Number, param6:Boolean) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(!param6)
         {
            _loc7_ = this._openList.length;
            _loc8_ = -1;
            while(++_loc8_ < _loc7_)
            {
               if(this._openList[_loc8_][0] == param1 && this._openList[_loc8_][1] == param2)
               {
                  param6 = true;
                  break;
               }
            }
         }
         if(!param6)
         {
            this._openList.push([param1,param2]);
            this._mapStatus[param1][param2] = new CellInfo(param5,null,true,false);
         }
         var _loc9_:CellInfo;
         (_loc9_ = this._mapStatus[param1][param2]).parent = param3;
         _loc9_.movementCost = param4;
      }
      
      private function movementPathFromArray(param1:Array) : void
      {
         var _loc2_:PathElement = null;
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length - 1)
         {
            _loc2_ = new PathElement();
            _loc2_.step.x = param1[_loc3_].x;
            _loc2_.step.y = param1[_loc3_].y;
            _loc2_.orientation = param1[_loc3_].orientationTo(param1[_loc3_ + 1]);
            this._movPath.addPoint(_loc2_);
            _loc3_++;
         }
         this._movPath.compress();
         this._movPath.fill();
      }
      
      private function initFindPath() : void
      {
         this._currentTime = 0;
         if(this._callBackFunction == null)
         {
            this._maxTime = 2000000;
            this.pathFrame(null);
         }
         else
         {
            if(!this._enterFrameIsActive)
            {
               this._enterFrameIsActive = true;
               EnterFrameDispatcher.addEventListener(this.pathFrame,"pathFrame");
            }
            this._maxTime = 20;
         }
      }
      
      private function pathFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:* = false;
         var _loc9_:* = false;
         var _loc10_:* = false;
         var _loc11_:* = false;
         var _loc12_:MapPoint = null;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         if(this._currentTime == 0)
         {
            this._currentTime = getTimer();
         }
         if(this._openList.length > 0 && !this.isClosed(this._endY,this._endX))
         {
            _loc2_ = this.nearerSquare();
            this._nowY = this._openList[_loc2_][0];
            this._nowX = this._openList[_loc2_][1];
            this._previousCellId = MapPoint.fromCoords(this._nowX,this._nowY).cellId;
            this.closeSquare(this._nowY,this._nowX);
            _loc3_ = this._nowY - 1;
            while(_loc3_ < this._nowY + 2)
            {
               _loc5_ = this._nowX - 1;
               while(_loc5_ < this._nowX + 2)
               {
                  if(_loc3_ >= _minY && _loc3_ < _maxY && _loc5_ >= _minX && _loc5_ < _maxX && !(_loc3_ == this._nowY && _loc5_ == this._nowX) && (this._allowDiag || _loc3_ == this._nowY || _loc5_ == this._nowX && (this._bAllowDiagCornering || _loc3_ == this._nowY || _loc5_ == this._nowX || (this._map.pointMov(this._nowX,_loc3_,this._bAllowTroughEntity,this._previousCellId,this._endPoint.cellId) || this._map.pointMov(_loc5_,this._nowY,this._bAllowTroughEntity,this._previousCellId,this._endPoint.cellId)))))
                  {
                     if(!(!this._map.pointMov(this._nowX,_loc3_,this._bAllowTroughEntity,this._previousCellId,this._endPoint.cellId) && !this._map.pointMov(_loc5_,this._nowY,this._bAllowTroughEntity,this._previousCellId,this._endPoint.cellId) && !this._bIsFighting && this._allowDiag))
                     {
                        if(this._map.pointMov(_loc5_,_loc3_,this._bAllowTroughEntity,this._previousCellId,this._endPoint.cellId))
                        {
                           if(!this.isClosed(_loc3_,_loc5_))
                           {
                              if(_loc5_ == this._endX && _loc3_ == this._endY)
                              {
                                 _loc6_ = 1;
                              }
                              else
                              {
                                 _loc6_ = this._map.pointWeight(_loc5_,_loc3_,this._bAllowTroughEntity);
                              }
                              _loc7_ = this._mapStatus[this._nowY][this._nowX].movementCost + (_loc3_ == this._nowY || _loc5_ == this._nowX?this._nHVCost:this._nDCost) * _loc6_;
                              if(this._bAllowTroughEntity)
                              {
                                 _loc8_ = _loc5_ + _loc3_ == this._endX + this._endY;
                                 _loc9_ = _loc5_ + _loc3_ == this._startX + this._startY;
                                 _loc10_ = _loc5_ - _loc3_ == this._endX - this._endY;
                                 _loc11_ = _loc5_ - _loc3_ == this._startX - this._startY;
                                 _loc12_ = MapPoint.fromCoords(_loc5_,_loc3_);
                                 if(!_loc8_ && !_loc10_ || !_loc9_ && !_loc11_)
                                 {
                                    _loc7_ = (_loc7_ = _loc7_ + _loc12_.distanceToCell(this._endPoint)) + _loc12_.distanceToCell(this._startPoint);
                                 }
                                 if(_loc5_ == this._endX || _loc3_ == this._endY)
                                 {
                                    _loc7_ = _loc7_ - 3;
                                 }
                                 if(_loc8_ || _loc10_ || _loc5_ + _loc3_ == this._nowX + this._nowY || _loc5_ - _loc3_ == this._nowX - this._nowY)
                                 {
                                    _loc7_ = _loc7_ - 2;
                                 }
                                 if(_loc5_ == this._startX || _loc3_ == this._startY)
                                 {
                                    _loc7_ = _loc7_ - 3;
                                 }
                                 if(_loc9_ || _loc11_)
                                 {
                                    _loc7_ = _loc7_ - 2;
                                 }
                                 if((_loc13_ = _loc12_.distanceToCell(this._endPoint)) < this._distanceToEnd)
                                 {
                                    this._endPointAux = _loc12_;
                                    this._endAuxX = _loc5_;
                                    this._endAuxY = _loc3_;
                                    this._distanceToEnd = _loc13_;
                                 }
                              }
                              if(this.isOpened(_loc3_,_loc5_))
                              {
                                 if(_loc7_ < this._mapStatus[_loc3_][_loc5_].movementCost)
                                 {
                                    this.openSquare(_loc3_,_loc5_,[this._nowY,this._nowX],_loc7_,undefined,true);
                                 }
                              }
                              else
                              {
                                 _loc14_ = this._nHeuristicCost * Math.sqrt((this._endY - _loc3_) * (this._endY - _loc3_) + (this._endX - _loc5_) * (this._endX - _loc5_));
                                 this.openSquare(_loc3_,_loc5_,[this._nowY,this._nowX],_loc7_,_loc14_,false);
                              }
                           }
                        }
                     }
                  }
                  _loc5_++;
               }
               _loc3_++;
            }
            if((_loc4_ = getTimer()) - this._currentTime < this._maxTime)
            {
               this.pathFrame(null);
            }
            else
            {
               this._currentTime = 0;
            }
         }
         else
         {
            this.endPathFrame();
         }
      }
      
      private function endPathFrame() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MapPoint = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         this._enterFrameIsActive = false;
         EnterFrameDispatcher.removeEventListener(this.pathFrame);
         var _loc13_:Boolean;
         if(!(_loc13_ = this.isClosed(this._endY,this._endX)))
         {
            this._endY = this._endAuxY;
            this._endX = this._endAuxX;
            this._endPoint = this._endPointAux;
            _loc13_ = true;
            this._movPath.replaceEnd(this._endPoint);
         }
         this._previousCellId = -1;
         if(_loc13_)
         {
            _loc1_ = new Array();
            this._nowY = this._endY;
            this._nowX = this._endX;
            while(this._nowY != this._startY || this._nowX != this._startX)
            {
               _loc1_.push(MapPoint.fromCoords(this._nowX,this._nowY));
               _loc2_ = this._mapStatus[this._nowY][this._nowX].parent[0];
               _loc3_ = this._mapStatus[this._nowY][this._nowX].parent[1];
               this._nowY = _loc2_;
               this._nowX = _loc3_;
            }
            _loc1_.push(this._startPoint);
            if(this._allowDiag)
            {
               _loc5_ = new Array();
               _loc6_ = 0;
               while(_loc6_ < _loc1_.length)
               {
                  _loc5_.push(_loc1_[_loc6_]);
                  this._previousCellId = _loc1_[_loc6_].cellId;
                  if(_loc1_[_loc6_ + 2] && MapPoint(_loc1_[_loc6_]).distanceToCell(_loc1_[_loc6_ + 2]) == 1 && !this._map.isChangeZone(_loc1_[_loc6_].cellId,_loc1_[_loc6_ + 1].cellId) && !this._map.isChangeZone(_loc1_[_loc6_ + 1].cellId,_loc1_[_loc6_ + 2].cellId))
                  {
                     _loc6_++;
                  }
                  else if(_loc1_[_loc6_ + 3] && MapPoint(_loc1_[_loc6_]).distanceToCell(_loc1_[_loc6_ + 3]) == 2)
                  {
                     _loc7_ = _loc1_[_loc6_].x;
                     _loc8_ = _loc1_[_loc6_].y;
                     _loc9_ = _loc1_[_loc6_ + 3].x;
                     _loc10_ = _loc1_[_loc6_ + 3].y;
                     _loc11_ = _loc7_ + Math.round((_loc9_ - _loc7_) / 2);
                     _loc12_ = _loc8_ + Math.round((_loc10_ - _loc8_) / 2);
                     if(this._map.pointMov(_loc11_,_loc12_,true,this._previousCellId,this._endPoint.cellId) && this._map.pointWeight(_loc11_,_loc12_) < 2)
                     {
                        _loc4_ = MapPoint.fromCoords(_loc11_,_loc12_);
                        _loc5_.push(_loc4_);
                        this._previousCellId = _loc4_.cellId;
                        _loc6_ = ++_loc6_ + 1;
                     }
                  }
                  else if(_loc1_[_loc6_ + 2] && MapPoint(_loc1_[_loc6_]).distanceToCell(_loc1_[_loc6_ + 2]) == 2)
                  {
                     _loc7_ = _loc1_[_loc6_].x;
                     _loc8_ = _loc1_[_loc6_].y;
                     _loc9_ = _loc1_[_loc6_ + 2].x;
                     _loc10_ = _loc1_[_loc6_ + 2].y;
                     _loc11_ = _loc1_[_loc6_ + 1].x;
                     _loc12_ = _loc1_[_loc6_ + 1].y;
                     if(_loc7_ + _loc8_ == _loc9_ + _loc10_ && _loc7_ - _loc8_ != _loc11_ - _loc12_ && !this._map.isChangeZone(MapPoint.fromCoords(_loc7_,_loc8_).cellId,MapPoint.fromCoords(_loc11_,_loc12_).cellId) && !this._map.isChangeZone(MapPoint.fromCoords(_loc11_,_loc12_).cellId,MapPoint.fromCoords(_loc9_,_loc10_).cellId))
                     {
                        _loc6_++;
                     }
                     else if(_loc7_ - _loc8_ == _loc9_ - _loc10_ && _loc7_ - _loc8_ != _loc11_ - _loc12_ && !this._map.isChangeZone(MapPoint.fromCoords(_loc7_,_loc8_).cellId,MapPoint.fromCoords(_loc11_,_loc12_).cellId) && !this._map.isChangeZone(MapPoint.fromCoords(_loc11_,_loc12_).cellId,MapPoint.fromCoords(_loc9_,_loc10_).cellId))
                     {
                        _loc6_++;
                     }
                     else if(_loc7_ == _loc9_ && _loc7_ != _loc11_ && this._map.pointWeight(_loc7_,_loc12_) < 2 && this._map.pointMov(_loc7_,_loc12_,this._bAllowTroughEntity,this._previousCellId,this._endPoint.cellId))
                     {
                        _loc4_ = MapPoint.fromCoords(_loc7_,_loc12_);
                        _loc5_.push(_loc4_);
                        this._previousCellId = _loc4_.cellId;
                        _loc6_++;
                     }
                     else if(_loc8_ == _loc10_ && _loc8_ != _loc12_ && this._map.pointWeight(_loc11_,_loc8_) < 2 && this._map.pointMov(_loc11_,_loc8_,this._bAllowTroughEntity,this._previousCellId,this._endPoint.cellId))
                     {
                        _loc4_ = MapPoint.fromCoords(_loc11_,_loc8_);
                        _loc5_.push(_loc4_);
                        this._previousCellId = _loc4_.cellId;
                        _loc6_++;
                     }
                  }
                  _loc6_++;
               }
               _loc1_ = _loc5_;
            }
            if(_loc1_.length == 1)
            {
               _loc1_ = new Array();
            }
            _loc1_.reverse();
            this.movementPathFromArray(_loc1_);
         }
         if(this._callBackFunction != null)
         {
            if(this._argsFunction)
            {
               this._callBackFunction(this._movPath,this._argsFunction);
            }
            else
            {
               this._callBackFunction(this._movPath);
            }
         }
      }
      
      private function findPathInternal(param1:IDataMapProvider, param2:MapPoint, param3:MapPoint, param4:Boolean) : void
      {
         var _loc5_:uint = 0;
         this._map = param1;
         this._start = param2;
         this._end = param3;
         this._allowDiag = param4;
         this._endPoint = MapPoint.fromCoords(param3.x,param3.y);
         this._startPoint = MapPoint.fromCoords(param2.x,param2.y);
         this._endX = param3.x;
         this._endY = param3.y;
         this._startX = param2.x;
         this._startY = param2.y;
         this._endPointAux = this._startPoint;
         this._endAuxX = this._startX;
         this._endAuxY = this._startY;
         this._distanceToEnd = this._startPoint.distanceToCell(this._endPoint);
         this._mapStatus = new Array();
         var _loc6_:int = _minY;
         while(_loc6_ < _maxY)
         {
            this._mapStatus[_loc6_] = new Array();
            _loc5_ = _minX;
            while(_loc5_ <= _maxX)
            {
               this._mapStatus[_loc6_][_loc5_] = new CellInfo(0,new Array(),false,false);
               _loc5_++;
            }
            _loc6_++;
         }
         this._openList = new Array();
         this.openSquare(this._startY,this._startX,undefined,0,undefined,false);
         this.initFindPath();
      }
      
      private function tracePath(param1:Array) : void
      {
         var _loc2_:MapPoint = null;
         var _loc4_:uint = 0;
         var _loc3_:String = new String("");
         while(_loc4_ < param1.length)
         {
            _loc2_ = param1[_loc4_] as MapPoint;
            _loc3_ = _loc3_.concat(" " + _loc2_.cellId);
            _loc4_++;
         }
      }
      
      private function nearObstacle(param1:int, param2:int, param3:IDataMapProvider) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 2;
         var _loc6_:int = 42;
         var _loc7_:int = -_loc5_;
         while(_loc7_ < _loc5_)
         {
            _loc4_ = -_loc5_;
            while(_loc4_ < _loc5_)
            {
               if(!param3.pointMov(param1 + _loc7_,param2 + _loc4_,true,this._previousCellId,this._endPoint.cellId))
               {
                  _loc6_ = Math.min(_loc6_,MapPoint(MapPoint.fromCoords(param1,param2)).distanceToCell(MapPoint.fromCoords(param1 + _loc7_,param2 + _loc4_)));
               }
               _loc4_++;
            }
            _loc7_++;
         }
         return _loc6_;
      }
   }
}
