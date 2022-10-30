package com.ankamagames.dofus.logic.game.common.actions.tinsel
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TitlesAndOrnamentsListRequestAction implements Action
   {
       
      
      public function TitlesAndOrnamentsListRequestAction()
      {
         super();
      }
      
      public static function create() : TitlesAndOrnamentsListRequestAction
      {
         return new TitlesAndOrnamentsListRequestAction();
      }
   }
}
