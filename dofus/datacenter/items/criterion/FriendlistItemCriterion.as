package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class FriendlistItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      public function FriendlistItemCriterion(param1:String)
      {
         super(param1);
      }
      
      override public function get text() : String
      {
         var _loc1_:String = I18n.getUiText("ui.tooltip.playerInFriendlist");
         var _loc2_:String = _operator.text;
         if(_loc2_ == ItemCriterionOperator.EQUAL)
         {
            _loc2_ = ":";
         }
         return _loc1_ + " " + _loc2_ + " " + _criterionValue;
      }
      
      override public function clone() : IItemCriterion
      {
         return new FriendlistItemCriterion(this.basicText);
      }
      
      override protected function getCriterion() : int
      {
         return (Kernel.getWorker().getFrame(SocialFrame) as SocialFrame).friendsList.length;
      }
   }
}
