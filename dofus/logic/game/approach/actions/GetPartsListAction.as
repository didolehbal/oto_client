package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GetPartsListAction implements Action
   {
       
      
      public function GetPartsListAction()
      {
         super();
      }
      
      public static function create() : GetPartsListAction
      {
         return new GetPartsListAction();
      }
   }
}
