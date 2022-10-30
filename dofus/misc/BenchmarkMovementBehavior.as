package com.ankamagames.dofus.misc
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.entities.behaviours.movements.AnimatedMovementBehavior;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.types.positions.PathElement;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.utils.getQualifiedClassName;
   
   public class BenchmarkMovementBehavior extends AnimatedMovementBehavior
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(BenchmarkMovementBehavior));
      
      private static var _self:BenchmarkMovementBehavior;
      
      private static const RUN_LINEAR_VELOCITY:Number = 1 / 170;
      
      private static const RUN_HORIZONTAL_DIAGONAL_VELOCITY:Number = 1 / 255;
      
      private static const RUN_VERTICAL_DIAGONAL_VELOCITY:Number = 1 / 212.5;
      
      private static const RUN_ANIMATION:String = AnimationEnum.ANIM_COURSE;
       
      
      public function BenchmarkMovementBehavior()
      {
         super();
         if(_self)
         {
            throw new SingletonError("Warning : RunningMovementBehavior is a singleton class and shoulnd\'t be instancied directly!");
         }
      }
      
      public static function getInstance() : BenchmarkMovementBehavior
      {
         if(!_self)
         {
            _self = new BenchmarkMovementBehavior();
         }
         return _self;
      }
      
      public static function getRandomCell() : MapPoint
      {
         var _loc1_:uint = 40;
         var _loc2_:MapPoint = MapPoint.fromCellId(Math.floor(Math.random() * AtouinConstants.MAP_CELLS_COUNT));
         while(!MapPoint.isInMap(_loc2_.x,_loc2_.y) && --_loc1_)
         {
            _loc2_ = MapPoint.fromCellId(Math.floor(Math.random() * AtouinConstants.MAP_CELLS_COUNT));
         }
         return _loc2_;
      }
      
      public static function getRandomPath(param1:IMovable) : MovementPath
      {
         var _loc2_:int = 0;
         var _loc3_:MovementPath = new MovementPath();
         _loc3_.start = param1.position;
         var _loc4_:Array = new Array();
         var _loc5_:int = -1;
         while(_loc5_ < 2)
         {
            _loc2_ = -1;
            while(_loc2_ < 2)
            {
               if(MapPoint.isInMap(_loc3_.start.x + _loc5_,_loc3_.start.y + _loc2_) && (_loc5_ != 0 || _loc2_ != 0) && DataMapProvider.getInstance().pointMov(_loc3_.start.x + _loc5_,_loc3_.start.y + _loc2_))
               {
                  _loc4_.push(MapPoint.fromCoords(_loc3_.start.x + _loc5_,_loc3_.start.y + _loc2_));
               }
               _loc2_++;
            }
            _loc5_++;
         }
         _loc3_.end = _loc4_[Math.floor(Math.random() * _loc4_.length)];
         var _loc6_:PathElement;
         (_loc6_ = new PathElement()).step = _loc3_.start;
         _loc6_.orientation = _loc3_.start.orientationTo(_loc3_.end);
         _loc3_.addPoint(_loc6_);
         return _loc3_;
      }
      
      override protected function getLinearVelocity() : Number
      {
         return RUN_LINEAR_VELOCITY;
      }
      
      override protected function getHorizontalDiagonalVelocity() : Number
      {
         return RUN_HORIZONTAL_DIAGONAL_VELOCITY;
      }
      
      override protected function getVerticalDiagonalVelocity() : Number
      {
         return RUN_VERTICAL_DIAGONAL_VELOCITY;
      }
      
      override protected function getAnimation() : String
      {
         return RUN_ANIMATION;
      }
      
      override protected function stopMovement(param1:IMovable) : void
      {
         super.stopMovement(param1);
         var _loc2_:MovementPath = getRandomPath(param1);
         if(_loc2_.path.length > 0)
         {
            param1.move(_loc2_);
         }
         else
         {
            stop(param1,true);
            AnimatedCharacter(param1).remove();
         }
      }
   }
}
