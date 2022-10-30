package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   import com.ankamagames.dofus.datacenter.quest.AchievementObjective;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.QuestFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.types.game.achievement.AchievementRewardable;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestActiveInformations;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class QuestApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function QuestApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(QuestApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getQuestInformations(param1:int) : Object
      {
         return this.getQuestFrame().getQuestInformations(param1);
      }
      
      [Untrusted]
      public function getAllQuests() : Vector.<Object>
      {
         var _loc1_:QuestActiveInformations = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:uint = 0;
         var _loc4_:Vector.<Object> = new Vector.<Object>(0,false);
         var _loc5_:Vector.<QuestActiveInformations> = this.getQuestFrame().getActiveQuests();
         for each(_loc1_ in _loc5_)
         {
            _loc4_.push({
               "id":_loc1_.questId,
               "status":true
            });
         }
         _loc2_ = this.getQuestFrame().getCompletedQuests();
         for each(_loc3_ in _loc2_)
         {
            _loc4_.push({
               "id":_loc3_,
               "status":false
            });
         }
         return _loc4_;
      }
      
      [Untrusted]
      public function getActiveQuests() : Vector.<uint>
      {
         var _loc1_:QuestActiveInformations = null;
         var _loc2_:Vector.<uint> = new Vector.<uint>();
         var _loc3_:Vector.<QuestActiveInformations> = this.getQuestFrame().getActiveQuests();
         for each(_loc1_ in _loc3_)
         {
            _loc2_.push(_loc1_.questId);
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getCompletedQuests() : Vector.<uint>
      {
         return this.getQuestFrame().getCompletedQuests();
      }
      
      [Untrusted]
      public function getAllQuestsOrderByCategory(param1:Boolean = false) : Array
      {
         var _loc2_:Quest = null;
         var _loc3_:QuestActiveInformations = null;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<uint> = null;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc7_:Array = new Array();
         var _loc10_:Vector.<QuestActiveInformations> = this.getQuestFrame().getActiveQuests();
         _loc8_ = _loc8_ + _loc10_.length;
         for each(_loc3_ in _loc10_)
         {
            _loc2_ = Quest.getQuestById(_loc3_.questId);
            if((_loc9_ = _loc2_.category.order) > _loc7_.length || !_loc7_[_loc9_])
            {
               (_loc4_ = new Object()).data = new Array();
               _loc4_.id = _loc2_.categoryId;
               _loc7_[_loc9_] = _loc4_;
            }
            _loc7_[_loc9_].data.push({
               "id":_loc3_.questId,
               "status":true
            });
         }
         if(param1)
         {
            _loc6_ = this.getQuestFrame().getCompletedQuests();
            _loc8_ = _loc8_ + _loc6_.length;
            for each(_loc5_ in _loc6_)
            {
               _loc2_ = Quest.getQuestById(_loc5_);
               if((_loc9_ = _loc2_.category.order) > _loc7_.length || !_loc7_[_loc9_])
               {
                  (_loc4_ = new Object()).data = new Array();
                  _loc4_.id = _loc2_.categoryId;
                  _loc7_[_loc9_] = _loc4_;
               }
               _loc7_[_loc9_].data.push({
                  "id":_loc5_,
                  "status":false
               });
            }
         }
         return _loc7_;
      }
      
      [Untrusted]
      public function getTutorialReward() : Vector.<ItemWrapper>
      {
         var _loc1_:Vector.<ItemWrapper> = new Vector.<ItemWrapper>();
         _loc1_.push(ItemWrapper.create(0,0,10785,1,null,false));
         _loc1_.push(ItemWrapper.create(0,0,10794,1,null,false));
         _loc1_.push(ItemWrapper.create(0,0,10797,1,null,false));
         _loc1_.push(ItemWrapper.create(0,0,10798,1,null,false));
         _loc1_.push(ItemWrapper.create(0,0,10799,1,null,false));
         _loc1_.push(ItemWrapper.create(0,0,10784,1,null,false));
         _loc1_.push(ItemWrapper.create(0,0,10800,1,null,false));
         _loc1_.push(ItemWrapper.create(0,0,10801,1,null,false));
         _loc1_.push(ItemWrapper.create(0,0,10792,1,null,false));
         _loc1_.push(ItemWrapper.create(0,0,10793,2,null,false));
         _loc1_.push(ItemWrapper.create(0,0,10795,1,null,false));
         _loc1_.push(ItemWrapper.create(0,0,10796,1,null,false));
         return _loc1_;
      }
      
      [Untrusted]
      public function getNotificationList() : Array
      {
         return QuestFrame.notificationList;
      }
      
      [Untrusted]
      public function getFinishedAchievementsIds() : Vector.<uint>
      {
         return this.getQuestFrame().finishedAchievementsIds;
      }
      
      [Untrusted]
      public function isAchievementFinished(param1:int) : Boolean
      {
         return this.getQuestFrame().finishedAchievementsIds.indexOf(param1) != -1;
      }
      
      [Untrusted]
      public function getAchievementKamasReward(param1:Achievement, param2:int = 0) : Number
      {
         if(param2 == 0)
         {
            param2 = PlayedCharacterManager.getInstance().infos.level;
         }
         return param1.getKamasReward(param2);
      }
      
      [Untrusted]
      public function getAchievementExperienceReward(param1:Achievement, param2:int = 0) : Number
      {
         if(param2 == 0)
         {
            param2 = PlayedCharacterManager.getInstance().infos.level;
         }
         return param1.getExperienceReward(param2,PlayedCharacterManager.getInstance().experiencePercent);
      }
      
      [Untrusted]
      public function getRewardableAchievements() : Vector.<AchievementRewardable>
      {
         return this.getQuestFrame().rewardableAchievements;
      }
      
      [Untrusted]
      public function getAchievementObjectivesNames(param1:int) : String
      {
         var _loc2_:int = 0;
         var _loc3_:AchievementObjective = null;
         var _loc4_:* = "-";
         var _loc5_:Achievement = Achievement.getAchievementById(param1);
         for each(_loc2_ in _loc5_.objectiveIds)
         {
            _loc3_ = AchievementObjective.getAchievementObjectiveById(_loc2_);
            if(_loc3_ && _loc3_.name)
            {
               _loc4_ = _loc4_ + (" " + StringUtils.noAccent(_loc3_.name).toLowerCase());
            }
         }
         return _loc4_;
      }
      
      [Untrusted]
      public function getTreasureHunt(param1:int) : Object
      {
         return this.getQuestFrame().getTreasureHuntById(param1);
      }
      
      private function getQuestFrame() : QuestFrame
      {
         return Kernel.getWorker().getFrame(QuestFrame) as QuestFrame;
      }
   }
}
