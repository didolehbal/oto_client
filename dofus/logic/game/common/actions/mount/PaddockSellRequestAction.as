package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PaddockSellRequestAction implements Action
   {
       
      
      public var price:uint;
      
      public function PaddockSellRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : PaddockSellRequestAction
      {
         var _loc2_:PaddockSellRequestAction = new PaddockSellRequestAction();
         _loc2_.price = param1;
         return _loc2_;
      }
   }
}
