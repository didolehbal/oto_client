package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ToggleDematerializationAction implements Action
   {
       
      
      public function ToggleDematerializationAction()
      {
         super();
      }
      
      public static function create() : ToggleDematerializationAction
      {
         return new ToggleDematerializationAction();
      }
   }
}
