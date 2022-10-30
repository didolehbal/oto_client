package com.ankamagames.dofus.logic.game.common.actions.humanVendor
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeRequestOnShopStockAction implements Action
   {
       
      
      public function ExchangeRequestOnShopStockAction()
      {
         super();
      }
      
      public static function create() : ExchangeRequestOnShopStockAction
      {
         return new ExchangeRequestOnShopStockAction();
      }
   }
}
