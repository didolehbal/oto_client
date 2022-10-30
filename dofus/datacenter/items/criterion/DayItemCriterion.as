package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   
   public class DayItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      public function DayItemCriterion(param1:String)
      {
         super(param1);
      }
      
      override public function get text() : String
      {
         var _loc1_:String = _criterionValue.toString();
         var _loc2_:String = PatternDecoder.combine(I18n.getUiText("ui.time.days"),"n",true);
         return _loc2_ + " " + _operator.text + " " + _loc1_;
      }
      
      override public function clone() : IItemCriterion
      {
         return new DayItemCriterion(this.basicText);
      }
      
      override protected function getCriterion() : int
      {
         var _loc1_:Date = new Date();
         return TimeManager.getInstance().getDateFromTime(_loc1_.getTime())[2];
      }
   }
}
