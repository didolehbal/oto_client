package com.ankamagames.dofus.logic.game.common.actions.humanVendor
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeStartAsVendorRequestAction implements Action
   {
       
      
      public function ExchangeStartAsVendorRequestAction()
      {
         super();
      }
      
      public static function create() : ExchangeStartAsVendorRequestAction
      {
         return new ExchangeStartAsVendorRequestAction();
      }
   }
}
