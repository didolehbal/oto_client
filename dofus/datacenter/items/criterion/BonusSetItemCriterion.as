package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import flash.utils.Dictionary;
   
   public class BonusSetItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      public function BonusSetItemCriterion(param1:String)
      {
         super(param1);
      }
      
      override public function get text() : String
      {
         var _loc1_:String = I18n.getUiText("ui.criterion.setBonus");
         return _loc1_ + " " + _operator.text + " " + _criterionValue;
      }
      
      override public function get isRespected() : Boolean
      {
         return _operator.compare(uint(this.getCriterion()),_criterionValue);
      }
      
      override public function clone() : IItemCriterion
      {
         return new BonusSetItemCriterion(this.basicText);
      }
      
      override protected function getCriterion() : int
      {
         var _loc1_:ItemWrapper = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Dictionary = new Dictionary();
         for each(_loc1_ in InventoryManager.getInstance().inventory.getView("equipment").content)
         {
            if(_loc1_)
            {
               if(_loc1_.itemSetId > 0)
               {
                  if(_loc4_[_loc1_.itemSetId] > 0)
                  {
                     _loc4_[_loc1_.itemSetId] = _loc4_[_loc1_.itemSetId] + 1;
                  }
                  if(_loc4_[_loc1_.itemSetId] == -1)
                  {
                     _loc4_[_loc1_.itemSetId] = 1;
                  }
                  if(!_loc4_[_loc1_.itemSetId])
                  {
                     _loc4_[_loc1_.itemSetId] = -1;
                  }
               }
            }
         }
         for each(_loc2_ in _loc4_)
         {
            if(_loc2_ > 0)
            {
               _loc3_ = _loc3_ + _loc2_;
            }
         }
         return _loc3_;
      }
   }
}
