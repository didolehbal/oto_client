package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ShowMonstersInfoAction implements Action
   {
       
      
      public var fromShortcut:Boolean;
      
      public function ShowMonstersInfoAction()
      {
         super();
      }
      
      public static function create(param1:Boolean = true) : ShowMonstersInfoAction
      {
         var _loc2_:ShowMonstersInfoAction = new ShowMonstersInfoAction();
         _loc2_.fromShortcut = param1;
         return _loc2_;
      }
   }
}
