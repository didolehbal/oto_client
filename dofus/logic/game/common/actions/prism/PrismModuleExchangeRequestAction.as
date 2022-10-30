package com.ankamagames.dofus.logic.game.common.actions.prism
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PrismModuleExchangeRequestAction implements Action
   {
       
      
      public function PrismModuleExchangeRequestAction()
      {
         super();
      }
      
      public static function create() : PrismModuleExchangeRequestAction
      {
         return new PrismModuleExchangeRequestAction();
      }
   }
}
