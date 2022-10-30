package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class NewsLoginRequestAction implements Action
   {
       
      
      public function NewsLoginRequestAction()
      {
         super();
      }
      
      public static function create() : NewsLoginRequestAction
      {
         return new NewsLoginRequestAction();
      }
   }
}
