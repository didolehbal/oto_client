package com.ankamagames.dofus.logic.game.common.misc.inventoryView
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.StorageOptionManager;
   import com.ankamagames.dofus.logic.game.common.misc.HookLock;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   
   public class BankFilteredView extends StorageGenericView
   {
       
      
      public function BankFilteredView(param1:HookLock)
      {
         super(param1);
      }
      
      override public function get name() : String
      {
         return "bankFiltered";
      }
      
      override public function isListening(param1:ItemWrapper) : Boolean
      {
         return super.isListening(param1) && StorageOptionManager.getInstance().hasBankFilter() && param1.typeId == StorageOptionManager.getInstance().bankFilter;
      }
      
      override public function updateView() : void
      {
         super.updateView();
         if(StorageOptionManager.getInstance().hasBankFilter())
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
