package com.ankamagames.dofus.logic.game.common.actions.externalGame
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class KrosmasterInventoryRequestAction implements Action
   {
       
      
      public function KrosmasterInventoryRequestAction()
      {
         super();
      }
      
      public static function create() : KrosmasterInventoryRequestAction
      {
         return new KrosmasterInventoryRequestAction();
      }
   }
}
