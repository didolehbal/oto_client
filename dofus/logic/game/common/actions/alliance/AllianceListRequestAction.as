package com.ankamagames.dofus.logic.game.common.actions.alliance
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AllianceListRequestAction implements Action
   {
       
      
      public function AllianceListRequestAction()
      {
         super();
      }
      
      public static function create() : AllianceListRequestAction
      {
         return new AllianceListRequestAction();
      }
   }
}
