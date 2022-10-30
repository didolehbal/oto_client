package com.ankamagames.dofus.logic.game.common.actions.humanVendor
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeShopStockMouvmentAddAction implements Action
   {
       
      
      public var objectUID:uint;
      
      public var quantity:uint;
      
      public var price:uint;
      
      public function ExchangeShopStockMouvmentAddAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint) : ExchangeShopStockMouvmentAddAction
      {
         var _loc4_:ExchangeShopStockMouvmentAddAction;
         (_loc4_ = new ExchangeShopStockMouvmentAddAction()).objectUID = param1;
         _loc4_.quantity = param2;
         _loc4_.price = param3;
         return _loc4_;
      }
   }
}
