package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenTeamSearchAction implements Action
   {
       
      
      public function OpenTeamSearchAction()
      {
         super();
      }
      
      public static function create() : OpenTeamSearchAction
      {
         return new OpenTeamSearchAction();
      }
   }
}
