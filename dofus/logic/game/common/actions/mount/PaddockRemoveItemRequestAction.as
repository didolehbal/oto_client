package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PaddockRemoveItemRequestAction implements Action
   {
       
      
      public var cellId:uint;
      
      public function PaddockRemoveItemRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : PaddockRemoveItemRequestAction
      {
         var _loc2_:PaddockRemoveItemRequestAction = new PaddockRemoveItemRequestAction();
         _loc2_.cellId = param1;
         return _loc2_;
      }
   }
}
