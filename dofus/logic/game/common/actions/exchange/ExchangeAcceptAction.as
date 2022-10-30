package com.ankamagames.dofus.logic.game.common.actions.exchange
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeAcceptAction implements Action
   {
       
      
      public function ExchangeAcceptAction()
      {
         super();
      }
      
      public static function create() : ExchangeAcceptAction
      {
         return new ExchangeAcceptAction();
      }
   }
}
