package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildListRequestAction implements Action
   {
       
      
      public function GuildListRequestAction()
      {
         super();
      }
      
      public static function create() : GuildListRequestAction
      {
         return new GuildListRequestAction();
      }
   }
}
