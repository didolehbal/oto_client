package com.ankamagames.dofus.logic.game.common.actions.bid
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class LeaveBidHouseAction implements Action
   {
       
      
      public function LeaveBidHouseAction()
      {
         super();
      }
      
      public static function create() : LeaveBidHouseAction
      {
         return new LeaveBidHouseAction();
      }
   }
}
