package com.ankamagames.dofus.logic.game.common.actions.alliance
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AllianceFactsRequestAction implements Action
   {
       
      
      public var allianceId:uint;
      
      public function AllianceFactsRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : AllianceFactsRequestAction
      {
         var _loc2_:AllianceFactsRequestAction = new AllianceFactsRequestAction();
         _loc2_.allianceId = param1;
         return _loc2_;
      }
   }
}
