package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class NotificationResetAction implements Action
   {
       
      
      public function NotificationResetAction()
      {
         super();
      }
      
      public static function create() : NotificationResetAction
      {
         return new NotificationResetAction();
      }
   }
}
