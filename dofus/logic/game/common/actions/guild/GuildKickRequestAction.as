package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildKickRequestAction implements Action
   {
       
      
      public var targetId:uint;
      
      public function GuildKickRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : GuildKickRequestAction
      {
         var _loc2_:GuildKickRequestAction = new GuildKickRequestAction();
         _loc2_.targetId = param1;
         return _loc2_;
      }
   }
}
