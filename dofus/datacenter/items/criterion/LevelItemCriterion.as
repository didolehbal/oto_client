package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class LevelItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      public function LevelItemCriterion(param1:String)
      {
         super(param1);
      }
      
      override public function get text() : String
      {
         var _loc1_:String = _criterionValue.toString();
         var _loc2_:String = I18n.getUiText("ui.common.level");
         return _loc2_ + " " + _operator.text + " " + _loc1_;
      }
      
      override public function clone() : IItemCriterion
      {
         return new LevelItemCriterion(this.basicText);
      }
      
      override protected function getCriterion() : int
      {
         return PlayedCharacterManager.getInstance().infos.level;
      }
   }
}
