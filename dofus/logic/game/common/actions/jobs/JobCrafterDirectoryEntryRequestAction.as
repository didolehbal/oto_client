package com.ankamagames.dofus.logic.game.common.actions.jobs
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JobCrafterDirectoryEntryRequestAction implements Action
   {
       
      
      public var playerId:uint;
      
      public function JobCrafterDirectoryEntryRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : JobCrafterDirectoryEntryRequestAction
      {
         var _loc2_:JobCrafterDirectoryEntryRequestAction = new JobCrafterDirectoryEntryRequestAction();
         _loc2_.playerId = param1;
         return _loc2_;
      }
   }
}
