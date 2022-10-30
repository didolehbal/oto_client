package com.ankamagames.dofus.logic.connection.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.jerakine.messages.IDontLogThisMessage;
   
   public class LoginAsGuestAction implements Action, IDontLogThisMessage
   {
       
      
      public function LoginAsGuestAction()
      {
         super();
      }
      
      public static function create() : LoginAsGuestAction
      {
         return new LoginAsGuestAction();
      }
   }
}
