package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class NumericWhoIsRequestAction implements Action
   {
       
      
      public var playerId:uint;
      
      public function NumericWhoIsRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : NumericWhoIsRequestAction
      {
         var _loc2_:NumericWhoIsRequestAction = new NumericWhoIsRequestAction();
         _loc2_.playerId = param1;
         return _loc2_;
      }
   }
}
