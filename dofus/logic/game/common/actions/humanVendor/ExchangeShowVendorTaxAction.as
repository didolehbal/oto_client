package com.ankamagames.dofus.logic.game.common.actions.humanVendor
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeShowVendorTaxAction implements Action
   {
       
      
      public function ExchangeShowVendorTaxAction()
      {
         super();
      }
      
      public static function create() : ExchangeShowVendorTaxAction
      {
         return new ExchangeShowVendorTaxAction();
      }
   }
}
