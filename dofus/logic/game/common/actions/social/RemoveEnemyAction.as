package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class RemoveEnemyAction implements Action
   {
       
      
      public var accountId:int;
      
      public function RemoveEnemyAction()
      {
         super();
      }
      
      public static function create(param1:int) : RemoveEnemyAction
      {
         var _loc2_:RemoveEnemyAction = new RemoveEnemyAction();
         _loc2_.accountId = param1;
         return _loc2_;
      }
   }
}
