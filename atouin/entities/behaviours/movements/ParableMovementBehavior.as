package com.ankamagames.atouin.entities.behaviours.movements
{
   import com.ankamagames.atouin.managers.EntitiesDisplayManager;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.types.TweenEntityData;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class ParableMovementBehavior extends AnimatedMovementBehavior
   {
      
      private static const LINEAR_VELOCITY:Number = 1 / 400;
      
      private static const HORIZONTAL_DIAGONAL_VELOCITY:Number = 1 / 500;
      
      private static const VERTICAL_DIAGONAL_VELOCITY:Number = 1 / 450;
      
      private static const ANIMATION:String = "FX";
      
      private static var _curvePoint:Point;
      
      private static var _velocity:Number;
      
      private static var _angle:Number;
      
      private static var _self:ParableMovementBehavior;
       
      
      public function ParableMovementBehavior()
      {
         super();
         if(_self)
         {
            throw new SingletonError("Warning : ParableMovementBehavior is a singleton class and shoulnd\'t be instancied directly!");
         }
      }
      
      public static function getInstance() : ParableMovementBehavior
      {
         if(!_self)
         {
            _self = new ParableMovementBehavior();
         }
         return _self;
      }
      
      override protected function getLinearVelocity() : Number
      {
         return LINEAR_VELOCITY;
      }
      
      override protected function getHorizontalDiagonalVelocity() : Number
      {
         return HORIZONTAL_DIAGONAL_VELOCITY;
      }
      
      override protected function getVerticalDiagonalVelocity() : Number
      {
         return VERTICAL_DIAGONAL_VELOCITY;
      }
      
      override protected function getAnimation() : String
      {
         return ANIMATION;
      }
      
      override public function move(param1:IMovable, param2:MovementPath, param3:Function = null) : void
      {
         var _loc4_:TweenEntityData;
         (_loc4_ = new TweenEntityData()).path = param2;
         _loc4_.entity = param1;
         var _loc5_:Sprite = InteractiveCellManager.getInstance().getCell(_loc4_.path.start.cellId);
         var _loc6_:Sprite = InteractiveCellManager.getInstance().getCell(_loc4_.path.end.cellId);
         var _loc7_:Point = new Point(_loc5_.x,_loc5_.y);
         var _loc8_:Point = new Point(_loc6_.x,_loc6_.y);
         var _loc9_:Number = Point.distance(_loc7_,_loc8_);
         _curvePoint = Point.interpolate(_loc7_,_loc8_,0.5);
         _curvePoint.y = _curvePoint.y - _loc9_ / 2;
         _velocity = 1 / (500 + param2.start.distanceTo(param2.end) * 50);
         _angle = this.checkAngle(_loc7_,_loc8_);
         var _loc10_:DisplayObject = DisplayObject(_loc4_.entity);
         _loc10_.rotation = _loc10_.rotation - (_angle + (90 - _angle) / 2);
         initMovement(param1,_loc4_);
      }
      
      override protected function processMovement(param1:TweenEntityData, param2:uint) : void
      {
         var _loc3_:Number = NaN;
         var _loc5_:Sprite = null;
         param1.barycentre = _velocity * (param2 - param1.start);
         if(param1.barycentre > 1)
         {
            param1.barycentre = 1;
         }
         var _loc4_:DisplayObject = DisplayObject(param1.entity);
         _loc5_ = InteractiveCellManager.getInstance().getCell(param1.currentCell.cellId);
         var _loc6_:Sprite = InteractiveCellManager.getInstance().getCell(param1.nextCell.cellId);
         _loc4_.x = (1 - param1.barycentre) * (1 - param1.barycentre) * _loc5_.x + 2 * (1 - param1.barycentre) * param1.barycentre * _curvePoint.x + param1.barycentre * param1.barycentre * _loc6_.x;
         _loc4_.y = (1 - param1.barycentre) * (1 - param1.barycentre) * _loc5_.y + 2 * (1 - param1.barycentre) * param1.barycentre * _curvePoint.y + param1.barycentre * param1.barycentre * _loc6_.y;
         var _loc7_:Number = -(_angle + (90 - _angle) / 2);
         var _loc8_:Number = 2.5 * (90 + _loc7_) * param1.barycentre;
         _loc4_.rotation = _loc7_ + _loc8_;
         if(_loc6_.y > _loc5_.y)
         {
            _loc3_ = 2 * (90 + _loc7_) * (1 - param1.barycentre);
            _loc4_.rotation = -_loc7_ - _loc3_;
         }
         _loc4_.scaleX = 1 - param1.barycentre * (90 - Math.abs(90 - _angle)) / 90;
         if(!param1.wasOrdered && param1.barycentre > 0.5)
         {
            EntitiesDisplayManager.getInstance().orderEntity(_loc4_,_loc6_);
         }
         if(param1.barycentre >= 1)
         {
            IEntity(param1.entity).position = param1.nextCell;
            goNextCell(IMovable(param1.entity));
            EntitiesManager.getInstance().removeEntity(IEntity(param1.entity).id);
         }
      }
      
      private function checkAngle(param1:Point, param2:Point) : Number
      {
         var _loc3_:Number = Point.distance(param1,new Point(param2.x,param1.y));
         var _loc4_:Number = Point.distance(param1,param2);
         var _loc5_:Number = Math.acos(_loc3_ / _loc4_) * 180 / Math.PI;
         if(param1.x > param2.x)
         {
            _loc5_ = 180 - _loc5_;
         }
         return _loc5_;
      }
   }
}
