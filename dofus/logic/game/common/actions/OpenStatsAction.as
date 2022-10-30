package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenStatsAction implements Action
   {
       
      
      public function OpenStatsAction()
      {
         super();
      }
      
      public static function create() : OpenStatsAction
      {
         return new OpenStatsAction();
      }
   }
}
