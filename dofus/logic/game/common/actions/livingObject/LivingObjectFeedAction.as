package com.ankamagames.dofus.logic.game.common.actions.livingObject
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class LivingObjectFeedAction implements Action
   {
       
      
      public var objectUID:uint;
      
      public var foodUID:uint;
      
      public var foodQuantity:uint;
      
      public function LivingObjectFeedAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint) : LivingObjectFeedAction
      {
         var _loc4_:LivingObjectFeedAction;
         (_loc4_ = new LivingObjectFeedAction()).objectUID = param1;
         _loc4_.foodUID = param2;
         _loc4_.foodQuantity = param3;
         return _loc4_;
      }
   }
}
