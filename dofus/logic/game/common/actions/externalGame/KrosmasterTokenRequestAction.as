package com.ankamagames.dofus.logic.game.common.actions.externalGame
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class KrosmasterTokenRequestAction implements Action
   {
       
      
      public function KrosmasterTokenRequestAction()
      {
         super();
      }
      
      public static function create() : KrosmasterTokenRequestAction
      {
         return new KrosmasterTokenRequestAction();
      }
   }
}
