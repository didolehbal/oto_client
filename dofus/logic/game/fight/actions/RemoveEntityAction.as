package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class RemoveEntityAction implements Action
   {
       
      
      public var actorId:int;
      
      public function RemoveEntityAction()
      {
         super();
      }
      
      public static function create(param1:int) : RemoveEntityAction
      {
         var _loc2_:RemoveEntityAction = new RemoveEntityAction();
         _loc2_.actorId = param1;
         return _loc2_;
      }
   }
}
