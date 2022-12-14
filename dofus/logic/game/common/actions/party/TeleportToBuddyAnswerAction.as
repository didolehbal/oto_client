package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TeleportToBuddyAnswerAction implements Action
   {
       
      
      public var dungeonId:int;
      
      public var buddyId:int;
      
      public var accept:Boolean;
      
      public function TeleportToBuddyAnswerAction()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:Boolean) : TeleportToBuddyAnswerAction
      {
         var _loc4_:TeleportToBuddyAnswerAction;
         (_loc4_ = new TeleportToBuddyAnswerAction()).dungeonId = param1;
         _loc4_.buddyId = param2;
         _loc4_.accept = param3;
         return _loc4_;
      }
   }
}
