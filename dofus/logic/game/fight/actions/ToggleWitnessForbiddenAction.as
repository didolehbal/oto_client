package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ToggleWitnessForbiddenAction implements Action
   {
       
      
      public function ToggleWitnessForbiddenAction()
      {
         super();
      }
      
      public static function create() : ToggleWitnessForbiddenAction
      {
         return new ToggleWitnessForbiddenAction();
      }
   }
}
