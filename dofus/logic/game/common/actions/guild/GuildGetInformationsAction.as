package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildGetInformationsAction implements Action
   {
       
      
      public var infoType:uint;
      
      public function GuildGetInformationsAction()
      {
         super();
      }
      
      public static function create(param1:uint) : GuildGetInformationsAction
      {
         var _loc2_:GuildGetInformationsAction = new GuildGetInformationsAction();
         _loc2_.infoType = param1;
         return _loc2_;
      }
   }
}
