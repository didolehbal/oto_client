package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class FriendGuildSetWarnOnAchievementCompleteAction implements Action
   {
       
      
      public var enable:Boolean;
      
      public function FriendGuildSetWarnOnAchievementCompleteAction()
      {
         super();
      }
      
      public static function create(param1:Boolean) : FriendGuildSetWarnOnAchievementCompleteAction
      {
         var _loc2_:FriendGuildSetWarnOnAchievementCompleteAction = new FriendGuildSetWarnOnAchievementCompleteAction();
         _loc2_.enable = param1;
         return _loc2_;
      }
   }
}
