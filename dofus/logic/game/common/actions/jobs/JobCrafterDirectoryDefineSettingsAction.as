package com.ankamagames.dofus.logic.game.common.actions.jobs
{
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectorySettings;
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JobCrafterDirectoryDefineSettingsAction implements Action
   {
       
      
      public var jobId:uint;
      
      public var minLevel:uint;
      
      public var free:Boolean;
      
      public var settings:JobCrafterDirectorySettings;
      
      public function JobCrafterDirectoryDefineSettingsAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:Boolean) : JobCrafterDirectoryDefineSettingsAction
      {
         var _loc4_:KnownJobWrapper = null;
         var _loc7_:uint = 0;
         var _loc5_:JobCrafterDirectoryDefineSettingsAction;
         (_loc5_ = new JobCrafterDirectoryDefineSettingsAction()).jobId = param1;
         _loc5_.minLevel = param2;
         _loc5_.free = param3;
         _loc5_.settings = new JobCrafterDirectorySettings();
         var _loc6_:Array = PlayedCharacterManager.getInstance().jobs;
         while(_loc7_ < _loc6_.length)
         {
            if((_loc4_ = _loc6_[_loc7_]) && _loc4_.id == param1)
            {
               _loc5_.settings.initJobCrafterDirectorySettings(_loc7_,param2,param3);
            }
            _loc7_++;
         }
         return _loc5_;
      }
   }
}
