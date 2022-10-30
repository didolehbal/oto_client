package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildFightLeaveRequestAction implements Action
   {
       
      
      public var taxCollectorId:uint;
      
      public var characterId:uint;
      
      public var warning:Boolean;
      
      public function GuildFightLeaveRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:Boolean = false) : GuildFightLeaveRequestAction
      {
         var _loc4_:GuildFightLeaveRequestAction;
         (_loc4_ = new GuildFightLeaveRequestAction()).taxCollectorId = param1;
         _loc4_.characterId = param2;
         _loc4_.warning = param3;
         return _loc4_;
      }
   }
}
