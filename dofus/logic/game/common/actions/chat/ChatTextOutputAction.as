package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChatTextOutputAction implements Action
   {
       
      
      public var content:String;
      
      public var channel:uint;
      
      public var receiverName:String;
      
      public var objects:Array;
      
      public function ChatTextOutputAction()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint = 0, param3:String = "", param4:Array = null) : ChatTextOutputAction
      {
         var _loc5_:ChatTextOutputAction;
         (_loc5_ = new ChatTextOutputAction()).content = param1;
         _loc5_.channel = param2;
         _loc5_.receiverName = param3;
         _loc5_.objects = param4;
         return _loc5_;
      }
   }
}
