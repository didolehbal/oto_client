package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ToggleHelpWantedAction implements Action
   {
       
      
      public function ToggleHelpWantedAction()
      {
         super();
      }
      
      public static function create() : ToggleHelpWantedAction
      {
         return new ToggleHelpWantedAction();
      }
   }
}
