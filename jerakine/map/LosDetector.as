package com.ankamagames.jerakine.map
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.display.Dofus1Line;
   import com.ankamagames.jerakine.utils.display.Dofus2Line;
   import flash.utils.getQualifiedClassName;
   
   public class LosDetector
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(LosDetector));
       
      
      public function LosDetector()
      {
         super();
      }
      
      public static function getCell(param1:IDataMapProvider, param2:Vector.<uint>, param3:MapPoint) : Vector.<uint>
      {
         var _loc4_:uint = 0;
         var _loc5_:* = undefined;
         var _loc6_:Boolean = false;
         var _loc7_:String = null;
         var _loc8_:MapPoint = null;
         var _loc9_:int = 0;
         var _loc11_:MapPoint = null;
         var _loc10_:Array = new Array();
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            _loc11_ = MapPoint.fromCellId(param2[_loc4_]);
            _loc10_.push({
               "p":_loc11_,
               "dist":param3.distanceToCell(_loc11_)
            });
            _loc4_++;
         }
         _loc10_.sortOn("dist",Array.DESCENDING | Array.NUMERIC);
         var _loc12_:Object = new Object();
         var _loc13_:Vector.<uint> = new Vector.<uint>();
         _loc4_ = 0;
         while(_loc4_ < _loc10_.length)
         {
            _loc8_ = MapPoint(_loc10_[_loc4_].p);
            if(!(_loc12_[_loc8_.x + "_" + _loc8_.y] != null && param3.x + param3.y != _loc8_.x + _loc8_.y && param3.x - param3.y != _loc8_.x - _loc8_.y))
            {
               if(Dofus1Line.useDofus2Line)
               {
                  _loc5_ = Dofus2Line.getLine(param3.cellId,_loc8_.cellId);
               }
               else
               {
                  _loc5_ = Dofus1Line.getLine(param3.x,param3.y,0,_loc8_.x,_loc8_.y,0);
               }
               if(_loc5_.length == 0)
               {
                  _loc13_.push(_loc8_.cellId);
               }
               else
               {
                  _loc6_ = true;
                  _loc9_ = 0;
                  while(_loc9_ < _loc5_.length)
                  {
                     _loc7_ = Math.floor(_loc5_[_loc9_].x) + "_" + Math.floor(_loc5_[_loc9_].y);
                     if(MapPoint.isInMap(_loc5_[_loc9_].x,_loc5_[_loc9_].y))
                     {
                        if(_loc9_ > 0 && param1.hasEntity(Math.floor(_loc5_[_loc9_ - 1].x),Math.floor(_loc5_[_loc9_ - 1].y)))
                        {
                           _loc6_ = false;
                        }
                        else if(_loc5_[_loc9_].x + _loc5_[_loc9_].y == param3.x + param3.y || _loc5_[_loc9_].x - _loc5_[_loc9_].y == param3.x - param3.y)
                        {
                           _loc6_ = _loc6_ && param1.pointLos(Math.floor(_loc5_[_loc9_].x),Math.floor(_loc5_[_loc9_].y),true);
                        }
                        else if(_loc12_[_loc7_] == null)
                        {
                           _loc6_ = _loc6_ && param1.pointLos(Math.floor(_loc5_[_loc9_].x),Math.floor(_loc5_[_loc9_].y),true);
                        }
                        else
                        {
                           _loc6_ = _loc6_ && _loc12_[_loc7_];
                        }
                     }
                     _loc9_++;
                  }
                  _loc12_[_loc7_] = _loc6_;
               }
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            _loc11_ = MapPoint.fromCellId(param2[_loc4_]);
            if(_loc12_[_loc11_.x + "_" + _loc11_.y])
            {
               _loc13_.push(_loc11_.cellId);
            }
            _loc4_++;
         }
         return _loc13_;
      }
   }
}
