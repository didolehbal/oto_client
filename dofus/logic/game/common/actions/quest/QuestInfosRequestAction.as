package com.ankamagames.dofus.logic.game.common.actions.quest
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class QuestInfosRequestAction implements Action
   {
       
      
      public var questId:int;
      
      public function QuestInfosRequestAction()
      {
         super();
      }
      
      public static function create(param1:int) : QuestInfosRequestAction
      {
         var _loc2_:QuestInfosRequestAction = new QuestInfosRequestAction();
         _loc2_.questId = param1;
         return _loc2_;
      }
   }
}
