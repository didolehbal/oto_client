package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class SubscribersGiftListRequestAction implements Action
   {
       
      
      public function SubscribersGiftListRequestAction()
      {
         super();
      }
      
      public static function create() : SubscribersGiftListRequestAction
      {
         return new SubscribersGiftListRequestAction();
      }
   }
}
