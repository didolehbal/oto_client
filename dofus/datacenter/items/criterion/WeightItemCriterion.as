package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class WeightItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      public function WeightItemCriterion(param1:String)
      {
         super(param1);
      }
      
      override public function get text() : String
      {
         var _loc1_:String = _criterionValue.toString();
         var _loc2_:String = I18n.getUiText("ui.common.weight");
         return _loc2_ + " " + _operator.text + " " + _loc1_;
      }
      
      override public function clone() : IItemCriterion
      {
         return new WeightItemCriterion(this.basicText);
      }
      
      override protected function getCriterion() : int
      {
         return PlayedCharacterManager.getInstance().inventoryWeight;
      }
   }
}
