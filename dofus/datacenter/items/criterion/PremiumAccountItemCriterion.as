package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class PremiumAccountItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      public function PremiumAccountItemCriterion(param1:String)
      {
         super(param1);
      }
      
      override public function get text() : String
      {
         var _loc1_:String = I18n.getUiText("ui.tooltip.possessPremiumAccount");
         if(_criterionValue == 0)
         {
            _loc1_ = I18n.getUiText("ui.tooltip.dontPossessPremiumAccount");
         }
         return _loc1_;
      }
      
      override public function clone() : IItemCriterion
      {
         return new PremiumAccountItemCriterion(this.basicText);
      }
      
      override protected function getCriterion() : int
      {
         return 0;
      }
   }
}
