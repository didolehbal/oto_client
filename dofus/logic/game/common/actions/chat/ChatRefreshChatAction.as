package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChatRefreshChatAction implements Action
   {
       
      
      public var currentTab:uint;
      
      public function ChatRefreshChatAction()
      {
         super();
      }
      
      public static function create(param1:uint) : ChatRefreshChatAction
      {
         var _loc2_:ChatRefreshChatAction = new ChatRefreshChatAction();
         _loc2_.currentTab = param1;
         return _loc2_;
      }
   }
}
