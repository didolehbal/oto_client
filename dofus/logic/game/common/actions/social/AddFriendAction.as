package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AddFriendAction implements Action
   {
       
      
      public var name:String;
      
      public function AddFriendAction()
      {
         super();
      }
      
      public static function create(param1:String) : AddFriendAction
      {
         var _loc2_:AddFriendAction = new AddFriendAction();
         _loc2_.name = param1;
         return _loc2_;
      }
   }
}
