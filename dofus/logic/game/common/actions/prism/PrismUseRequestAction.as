package com.ankamagames.dofus.logic.game.common.actions.prism
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PrismUseRequestAction implements Action
   {
       
      
      public function PrismUseRequestAction()
      {
         super();
      }
      
      public static function create() : PrismUseRequestAction
      {
         return new PrismUseRequestAction();
      }
   }
}
