package com.ankamagames.dofus.logic.game.common.actions.bid
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeBidHouseBuyAction implements Action
   {
       
      
      public var uid:uint;
      
      public var qty:uint;
      
      public var price:uint;
      
      public function ExchangeBidHouseBuyAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint) : ExchangeBidHouseBuyAction
      {
         var _loc4_:ExchangeBidHouseBuyAction;
         (_loc4_ = new ExchangeBidHouseBuyAction()).uid = param1;
         _loc4_.qty = param2;
         _loc4_.price = param3;
         return _loc4_;
      }
   }
}
