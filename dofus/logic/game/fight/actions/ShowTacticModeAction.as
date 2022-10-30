package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ShowTacticModeAction implements Action
   {
       
      
      public function ShowTacticModeAction()
      {
         super();
      }
      
      public static function create() : ShowTacticModeAction
      {
         return new ShowTacticModeAction();
      }
   }
}
