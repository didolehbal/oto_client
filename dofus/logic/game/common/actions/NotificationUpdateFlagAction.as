package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class NotificationUpdateFlagAction implements Action
   {
       
      
      public var index:uint;
      
      public function NotificationUpdateFlagAction()
      {
         super();
      }
      
      public static function create(param1:uint) : NotificationUpdateFlagAction
      {
         var _loc2_:NotificationUpdateFlagAction = new NotificationUpdateFlagAction();
         _loc2_.index = param1;
         return _loc2_;
      }
   }
}
