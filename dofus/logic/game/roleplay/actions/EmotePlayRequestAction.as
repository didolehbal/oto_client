package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class EmotePlayRequestAction implements Action
   {
       
      
      public var emoteId:uint;
      
      public function EmotePlayRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : EmotePlayRequestAction
      {
         var _loc2_:EmotePlayRequestAction = new EmotePlayRequestAction();
         _loc2_.emoteId = param1;
         return _loc2_;
      }
   }
}
