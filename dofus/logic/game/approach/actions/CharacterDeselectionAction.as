package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterDeselectionAction implements Action
   {
       
      
      public function CharacterDeselectionAction()
      {
         super();
      }
      
      public static function create() : CharacterDeselectionAction
      {
         return new CharacterDeselectionAction();
      }
   }
}
