package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class LeaveDialogAction implements Action
   {
       
      
      public function LeaveDialogAction()
      {
         super();
      }
      
      public static function create() : LeaveDialogAction
      {
         return new LeaveDialogAction();
      }
   }
}
