package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.QuestFrame;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class AchievementItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      public function AchievementItemCriterion(param1:String)
      {
         super(param1);
      }
      
      override public function get isRespected() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<uint> = (Kernel.getWorker().getFrame(QuestFrame) as QuestFrame).finishedAchievementsIds;
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_ == _criterionValue)
            {
               return true;
            }
         }
         return false;
      }
      
      override public function get text() : String
      {
         var _loc1_:* = " \'" + Achievement.getAchievementById(_criterionValue).name + "\'";
         var _loc2_:String = I18n.getUiText("ui.tooltip.unlockAchievement",[_loc1_]);
         if(_operator.text == ItemCriterionOperator.DIFFERENT)
         {
            _loc2_ = I18n.getUiText("ui.tooltip.dontUnlockAchievement",[_loc1_]);
         }
         return _loc2_;
      }
      
      override public function clone() : IItemCriterion
      {
         return new AchievementItemCriterion(this.basicText);
      }
      
      override protected function getCriterion() : int
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<uint> = (Kernel.getWorker().getFrame(QuestFrame) as QuestFrame).finishedAchievementsIds;
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_ == _criterionValue)
            {
               return 1;
            }
         }
         return 0;
      }
   }
}
