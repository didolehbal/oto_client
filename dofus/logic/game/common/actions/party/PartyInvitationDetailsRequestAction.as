package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyInvitationDetailsRequestAction implements Action
   {
       
      
      public var partyId:int;
      
      public function PartyInvitationDetailsRequestAction()
      {
         super();
      }
      
      public static function create(param1:int) : PartyInvitationDetailsRequestAction
      {
         var _loc2_:PartyInvitationDetailsRequestAction = new PartyInvitationDetailsRequestAction();
         _loc2_.partyId = param1;
         return _loc2_;
      }
   }
}
