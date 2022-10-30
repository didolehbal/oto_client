package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class SoulStoneItemCriterion extends ItemCriterion implements IDataCenter
   {
      
      private static const ID_SOUL_STONE:Array = [7010,10417,10418];
       
      
      private var _quantityMonster:uint = 1;
      
      private var _monsterId:uint;
      
      private var _monsterName:String;
      
      public function SoulStoneItemCriterion(param1:String)
      {
         super(param1);
         var _loc2_:Array = String(_criterionValueText).split(",");
         if(_loc2_ && _loc2_.length > 0)
         {
            if(_loc2_.length <= 2)
            {
               this._monsterId = uint(_loc2_[0]);
               this._quantityMonster = int(_loc2_[1]);
            }
         }
         else
         {
            this._monsterId = uint(_criterionValue);
         }
         this._monsterName = Monster.getMonsterById(this._monsterId).name;
      }
      
      override public function get isRespected() : Boolean
      {
         var _loc1_:ItemWrapper = null;
         var _loc2_:uint = 0;
         for each(_loc1_ in InventoryManager.getInstance().realInventory)
         {
            for each(_loc2_ in ID_SOUL_STONE)
            {
               if(_loc1_.objectGID == _loc2_)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      override public function get text() : String
      {
         return I18n.getUiText("ui.tooltip.possessSoulStone",[this._quantityMonster,this._monsterName]);
      }
      
      override public function clone() : IItemCriterion
      {
         return new SoulStoneItemCriterion(this.basicText);
      }
   }
}
