package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ShowAllNamesAction implements Action
   {
       
      
      public function ShowAllNamesAction()
      {
         super();
      }
      
      public static function create() : ShowAllNamesAction
      {
         return new ShowAllNamesAction();
      }
   }
}
