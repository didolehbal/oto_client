package com.ankamagames.dofus.logic.game.common.misc.inventoryView
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.StorageOptionManager;
   import com.ankamagames.dofus.logic.game.common.misc.HookLock;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   
   public class BankEquipementView extends StorageGenericView
   {
       
      
      public function BankEquipementView(param1:HookLock)
      {
         super(param1);
      }
      
      override public function get name() : String
      {
         return "bankEquipement";
      }
      
      override public function isListening(param1:ItemWrapper) : Boolean
      {
         return super.isListening(param1) && param1.category == StorageOptionManager.EQUIPMENT_CATEGORY;
      }
      
      override public function updateView() : void
      {
         super.updateView();
         if(StorageOptionManager.getInstance().bankCategory == StorageOptionManager.EQUIPMENT_CATEGORY && !StorageOptionManager.getInstance().hasBankFilter())
         {
            _hookLock.addHook(InventoryHookList.BankViewContent,[content,InventoryManager.getInstance().bankInventory.localKamas]);
         }
      }
      
      override public function sortFields() : Array
      {
         return StorageOptionManager.getInstance().sortBankFields;
      }
      
      override public function sortRevert() : Boolean
      {
         return StorageOptionManager.getInstance().sortBankRevert;
      }
   }
}
