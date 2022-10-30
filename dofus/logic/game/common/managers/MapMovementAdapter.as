package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.types.positions.PathElement;
   import flash.utils.getQualifiedClassName;
   
   public class MapMovementAdapter
   {
      
      private static const DEBUG_ADAPTER:Boolean = false;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MapMovementAdapter));
       
      
      public function MapMovementAdapter()
      {
         super();
      }
      
      public static function getServerMovement(param1:MovementPath) : Vector.<uint>
      {
         var _loc2_:PathElement = null;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         param1.compress();
         var _loc7_:Vector.<uint> = new Vector.<uint>();
         for each(_loc2_ in param1.path)
         {
            _loc4_ = ((_loc8_ = _loc2_.orientation) & 7) << 12 | _loc2_.step.cellId & 4095;
            _loc7_.push(_loc4_);
            _loc9_++;
         }
         _loc3_ = (_loc8_ & 7) << 12 | param1.end.cellId & 4095;
         _loc7_.push(_loc3_);
         if(DEBUG_ADAPTER)
         {
            _loc5_ = "";
            for each(_loc6_ in _loc7_)
            {
               _loc5_ = _loc5_ + ((_loc6_ & 4095) + " > ");
            }
            _log.debug("Sending path : " + _loc5_);
         }
         return _loc7_;
      }
      
      public static function getClientMovement(param1:Vector.<uint>) : MovementPath
      {
         var _loc2_:PathElement = null;
         var _loc3_:int = 0;
         var _loc4_:MapPoint = null;
         var _loc5_:PathElement = null;
         var _loc6_:* = null;
         var _loc7_:PathElement = null;
         var _loc9_:uint = 0;
         var _loc8_:MovementPath = new MovementPath();
         for each(_loc3_ in param1)
         {
            _loc4_ = MapPoint.fromCellId(_loc3_ & 4095);
            (_loc5_ = new PathElement()).step = _loc4_;
            if(_loc9_ == 0)
            {
               _loc8_.start = _loc4_;
            }
            else
            {
               _loc2_.orientation = _loc2_.step.orientationTo(_loc5_.step);
            }
            if(_loc9_ == param1.length - 1)
            {
               _loc8_.end = _loc4_;
               break;
            }
            _loc8_.addPoint(_loc5_);
            _loc2_ = _loc5_;
            _loc9_++;
         }
         _loc8_.fill();
         if(DEBUG_ADAPTER)
         {
            _loc6_ = "Start : " + _loc8_.start.cellId + " | ";
            for each(_loc7_ in _loc8_.path)
            {
               _loc6_ = _loc6_ + (_loc7_.step.cellId + " > ");
            }
            _log.debug("Received path : " + _loc6_ + " | End : " + _loc8_.end.cellId);
         }
         return _loc8_;
      }
   }
}
