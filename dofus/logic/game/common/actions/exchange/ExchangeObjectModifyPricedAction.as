package com.ankamagames.dofus.logic.game.common.actions.exchange
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeObjectModifyPricedAction implements Action
   {
       
      
      public var objectUID:uint;
      
      public var quantity:int;
      
      public var price:int;
      
      public function ExchangeObjectModifyPricedAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:int, param3:int) : ExchangeObjectModifyPricedAction
      {
         var _loc4_:ExchangeObjectModifyPricedAction;
         (_loc4_ = new ExchangeObjectModifyPricedAction()).objectUID = param1;
         _loc4_.quantity = param2;
         _loc4_.price = param3;
         return _loc4_;
      }
   }
}
