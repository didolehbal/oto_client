package com.ankamagames.dofus.logic.game.common.actions.alliance
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AllianceInsiderInfoRequestAction implements Action
   {
       
      
      public function AllianceInsiderInfoRequestAction()
      {
         super();
      }
      
      public static function create() : AllianceInsiderInfoRequestAction
      {
         return new AllianceInsiderInfoRequestAction();
      }
   }
}
