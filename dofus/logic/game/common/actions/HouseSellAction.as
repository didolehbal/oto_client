package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseSellAction implements Action
   {
       
      
      public var amount:uint;
      
      public function HouseSellAction()
      {
         super();
      }
      
      public static function create(param1:uint) : HouseSellAction
      {
         var _loc2_:HouseSellAction = new HouseSellAction();
         _loc2_.amount = param1;
         return _loc2_;
      }
   }
}
