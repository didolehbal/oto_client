package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.QuestFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestActiveInformations;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class QuestItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      private var _questId:uint;
      
      public function QuestItemCriterion(param1:String)
      {
         super(param1);
         this._questId = _criterionValue;
      }
      
      override public function get text() : String
      {
         var _loc1_:* = "";
         var _loc2_:Quest = Quest.getQuestById(this._questId);
         if(!_loc2_)
         {
            return _loc1_;
         }
         var _loc3_:String = _loc2_.name;
         var _loc4_:String = _serverCriterionForm.slice(0,2);
         switch(_loc4_)
         {
            case "Qa":
               _loc1_ = I18n.getUiText("ui.grimoire.quest.active",[_loc3_]);
               break;
            case "Qc":
               _loc1_ = I18n.getUiText("ui.grimoire.quest.startable",[_loc3_]);
               break;
            case "Qf":
               _loc1_ = I18n.getUiText("ui.grimoire.quest.done",[_loc3_]);
         }
         return _loc1_;
      }
      
      override public function get isRespected() : Boolean
      {
         var _loc1_:QuestActiveInformations = null;
         var _loc2_:Quest = Quest.getQuestById(this._questId);
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:QuestFrame = Kernel.getWorker().getFrame(QuestFrame) as QuestFrame;
         var _loc4_:String = _serverCriterionForm.slice(0,2);
         switch(_loc4_)
         {
            case "Qa":
               for each(_loc1_ in _loc3_.getActiveQuests())
               {
                  if(_loc1_.questId == this._questId)
                  {
                     return true;
                  }
               }
               break;
            case "Qc":
               return true;
            case "Qf":
               return _loc3_.getCompletedQuests().indexOf(this._questId) != -1;
         }
         return false;
      }
      
      override public function clone() : IItemCriterion
      {
         return new QuestItemCriterion(this.basicText);
      }
      
      override protected function getCriterion() : int
      {
         return PlayedCharacterManager.getInstance().infos.level;
      }
   }
}
