package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JoinSpouseAction implements Action
   {
       
      
      public function JoinSpouseAction()
      {
         super();
      }
      
      public static function create() : JoinSpouseAction
      {
         return new JoinSpouseAction();
      }
   }
}
