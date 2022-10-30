package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.craft.JobBookSubscribeRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterContactLookRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterDirectoryDefineSettingsAction;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterDirectoryEntryRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterDirectoryListRequestAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.SocialContactCategoryEnum;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobBookSubscriptionMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryDefineSettingsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryEntryRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectorySettingsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobDescriptionMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobExperienceMultiUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobExperienceUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobLevelUpMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkJobIndexMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.JobBookSubscribeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.social.ContactLookRequestByIdMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectorySettings;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobDescription;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobExperience;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class JobsFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(JobsFrame));
       
      
      private var _jobCrafterDirectoryListDialogFrame:JobCrafterDirectoryListDialogFrame;
      
      private var _settings:Array;
      
      public function JobsFrame()
      {
         this._settings = new Array();
         super();
      }
      
      private static function updateJobExperience(param1:JobExperience) : void
      {
         var _loc2_:KnownJobWrapper = PlayedCharacterManager.getInstance().jobs[param1.jobId];
         if(!_loc2_)
         {
            _loc2_ = KnownJobWrapper.create(param1.jobId);
            PlayedCharacterManager.getInstance().jobs[param1.jobId] = _loc2_;
         }
         _loc2_.jobLevel = param1.jobLevel;
         _loc2_.jobXP = param1.jobXP;
         _loc2_.jobXpLevelFloor = param1.jobXpLevelFloor;
         _loc2_.jobXpNextLevelFloor = param1.jobXpNextLevelFloor;
      }
      
      private static function createCrafterDirectorySettings(param1:JobCrafterDirectorySettings) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_.jobId = param1.jobId;
         _loc2_.minLevel = param1.minLevel;
         _loc2_.free = param1.free;
         return _loc2_;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get settings() : Array
      {
         return this._settings;
      }
      
      public function pushed() : Boolean
      {
         this._jobCrafterDirectoryListDialogFrame = new JobCrafterDirectoryListDialogFrame();
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:JobDescriptionMessage = null;
         var _loc3_:JobCrafterDirectorySettingsMessage = null;
         var _loc4_:JobCrafterDirectoryDefineSettingsAction = null;
         var _loc5_:JobCrafterDirectoryDefineSettingsMessage = null;
         var _loc6_:JobExperienceUpdateMessage = null;
         var _loc7_:JobExperienceMultiUpdateMessage = null;
         var _loc8_:JobLevelUpMessage = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:KnownJobWrapper = null;
         var _loc12_:JobBookSubscribeRequestAction = null;
         var _loc13_:JobBookSubscribeRequestMessage = null;
         var _loc14_:JobBookSubscriptionMessage = null;
         var _loc15_:String = null;
         var _loc16_:Job = null;
         var _loc17_:JobCrafterDirectoryListRequestAction = null;
         var _loc18_:JobCrafterDirectoryListRequestMessage = null;
         var _loc19_:JobCrafterDirectoryEntryRequestAction = null;
         var _loc20_:JobCrafterDirectoryEntryRequestMessage = null;
         var _loc21_:JobCrafterContactLookRequestAction = null;
         var _loc22_:ExchangeStartOkJobIndexMessage = null;
         var _loc23_:Array = null;
         var _loc24_:JobDescription = null;
         var _loc25_:JobCrafterDirectorySettings = null;
         var _loc26_:JobExperience = null;
         var _loc27_:ContactLookRequestByIdMessage = null;
         var _loc28_:uint = 0;
         switch(true)
         {
            case param1 is JobDescriptionMessage:
               _loc2_ = param1 as JobDescriptionMessage;
               PlayedCharacterManager.getInstance().jobs = new Array();
               for each(_loc24_ in _loc2_.jobsDescription)
               {
                  if(_loc24_)
                  {
                     (_loc11_ = KnownJobWrapper.create(_loc24_.jobId)).jobDescription = _loc24_;
                     PlayedCharacterManager.getInstance().jobs[_loc24_.jobId] = _loc11_;
                  }
               }
               KernelEventsManager.getInstance().processCallback(HookList.JobsListUpdated);
               return true;
            case param1 is JobCrafterDirectorySettingsMessage:
               _loc3_ = param1 as JobCrafterDirectorySettingsMessage;
               for each(_loc25_ in _loc3_.craftersSettings)
               {
                  this._settings[_loc25_.jobId] = createCrafterDirectorySettings(_loc25_);
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.CrafterDirectorySettings,this._settings);
               return true;
            case param1 is JobCrafterDirectoryDefineSettingsAction:
               _loc4_ = param1 as JobCrafterDirectoryDefineSettingsAction;
               (_loc5_ = new JobCrafterDirectoryDefineSettingsMessage()).initJobCrafterDirectoryDefineSettingsMessage(_loc4_.settings);
               ConnectionsHandler.getConnection().send(_loc5_);
               return true;
            case param1 is JobExperienceUpdateMessage:
               _loc6_ = param1 as JobExperienceUpdateMessage;
               updateJobExperience(_loc6_.experiencesUpdate);
               KernelEventsManager.getInstance().processCallback(CraftHookList.JobsExpUpdated,_loc6_.experiencesUpdate.jobId);
               return true;
            case param1 is JobExperienceMultiUpdateMessage:
               _loc7_ = param1 as JobExperienceMultiUpdateMessage;
               for each(_loc26_ in _loc7_.experiencesUpdate)
               {
                  updateJobExperience(_loc26_);
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.JobsExpUpdated,0);
               return true;
            case param1 is JobLevelUpMessage:
               _loc8_ = param1 as JobLevelUpMessage;
               _loc9_ = Job.getJobById(_loc8_.jobsDescription.jobId).name;
               _loc10_ = I18n.getUiText("ui.craft.newJobLevel",[_loc9_,_loc8_.newLevel]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc10_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               (_loc11_ = PlayedCharacterManager.getInstance().jobs[_loc8_.jobsDescription.jobId]).jobDescription = _loc8_.jobsDescription;
               _loc11_.jobLevel = _loc8_.newLevel;
               KernelEventsManager.getInstance().processCallback(CraftHookList.JobLevelUp,_loc8_.jobsDescription.jobId,_loc9_,_loc8_.newLevel);
               return true;
            case param1 is JobBookSubscribeRequestAction:
               _loc12_ = param1 as JobBookSubscribeRequestAction;
               (_loc13_ = new JobBookSubscribeRequestMessage()).initJobBookSubscribeRequestMessage(_loc12_.jobId);
               ConnectionsHandler.getConnection().send(_loc13_);
               return true;
            case param1 is JobBookSubscriptionMessage:
               _loc14_ = param1 as JobBookSubscriptionMessage;
               _loc16_ = Job.getJobById(_loc14_.jobId);
               if(_loc14_.addedOrDeleted)
               {
                  _loc15_ = I18n.getUiText("ui.craft.referenceAdd",[_loc16_.name]);
               }
               else
               {
                  _loc15_ = I18n.getUiText("ui.craft.referenceRemove",[_loc16_.name]);
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc15_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               PlayedCharacterManager.getInstance().jobs[_loc14_.jobId].jobBookSubscriber = _loc14_.addedOrDeleted;
               KernelEventsManager.getInstance().processCallback(CraftHookList.JobBookSubscription,_loc14_.jobId,_loc14_.addedOrDeleted);
               return true;
            case param1 is JobCrafterDirectoryListRequestAction:
               _loc17_ = param1 as JobCrafterDirectoryListRequestAction;
               (_loc18_ = new JobCrafterDirectoryListRequestMessage()).initJobCrafterDirectoryListRequestMessage(_loc17_.jobId);
               ConnectionsHandler.getConnection().send(_loc18_);
               return true;
            case param1 is JobCrafterDirectoryEntryRequestAction:
               _loc19_ = param1 as JobCrafterDirectoryEntryRequestAction;
               (_loc20_ = new JobCrafterDirectoryEntryRequestMessage()).initJobCrafterDirectoryEntryRequestMessage(_loc19_.playerId);
               ConnectionsHandler.getConnection().send(_loc5_);
               return true;
            case param1 is JobCrafterContactLookRequestAction:
               if((_loc21_ = param1 as JobCrafterContactLookRequestAction).crafterId == PlayedCharacterManager.getInstance().id)
               {
                  KernelEventsManager.getInstance().processCallback(CraftHookList.JobCrafterContactLook,_loc21_.crafterId,PlayedCharacterManager.getInstance().infos.name,EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook));
               }
               else
               {
                  (_loc27_ = new ContactLookRequestByIdMessage()).initContactLookRequestByIdMessage(0,SocialContactCategoryEnum.SOCIAL_CONTACT_CRAFTER,_loc21_.crafterId);
                  ConnectionsHandler.getConnection().send(_loc27_);
               }
               return true;
            case param1 is ExchangeStartOkJobIndexMessage:
               _loc22_ = param1 as ExchangeStartOkJobIndexMessage;
               _loc23_ = new Array();
               for each(_loc28_ in _loc22_.jobs)
               {
                  _loc23_.push(_loc28_);
               }
               Kernel.getWorker().addFrame(this._jobCrafterDirectoryListDialogFrame);
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkJobIndex,_loc23_);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
   }
}
