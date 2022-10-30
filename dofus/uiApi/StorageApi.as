package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.datacenter.livingObjects.Pet;
   import com.ankamagames.dofus.datacenter.mounts.RideFood;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.MountWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.MountFrame;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.StorageOptionManager;
   import com.ankamagames.dofus.logic.game.common.misc.IInventoryView;
   import com.ankamagames.dofus.network.enums.ShortcutBarEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class StorageApi implements IApi
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(StorageApi));
      
      private static var _lastItemPosition:Array = new Array();
      
      public static const ITEM_TYPE_TO_SERVER_POSITION:Array = [[],[0],[1],[2,4],[3],[5],[],[15],[1],[],[6],[7],[8],[9,10,11,12,13,14],[],[20],[21],[22,23],[24,25],[26],[27],[16],[],[28]];
       
      
      public function StorageApi()
      {
         super();
      }
      
      [Untrusted]
      public static function itemSuperTypeToServerPosition(param1:uint) : Array
      {
         return ITEM_TYPE_TO_SERVER_POSITION[param1];
      }
      
      [Untrusted]
      public static function getLivingObjectFood(param1:int) : Vector.<ItemWrapper>
      {
         var _loc2_:ItemWrapper = null;
         var _loc6_:int = 0;
         var _loc3_:Vector.<ItemWrapper> = new Vector.<ItemWrapper>();
         var _loc4_:Vector.<ItemWrapper>;
         var _loc5_:int = (_loc4_ = InventoryManager.getInstance().inventory.getView("storage").content).length;
         while(_loc6_ < _loc5_)
         {
            _loc2_ = _loc4_[_loc6_];
            if(!_loc2_.isLivingObject && _loc2_.type.id == param1)
            {
               _loc3_.push(_loc2_);
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      [Untrusted]
      public static function getPetFood(param1:int) : Vector.<ItemWrapper>
      {
         var _loc2_:Vector.<ItemWrapper> = null;
         var _loc3_:Vector.<int> = null;
         var _loc4_:Vector.<int> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:ItemWrapper = null;
         var _loc8_:Vector.<ItemWrapper> = new Vector.<ItemWrapper>();
         var _loc9_:Pet;
         if(_loc9_ = Pet.getPetById(param1))
         {
            _loc2_ = InventoryManager.getInstance().inventory.getView("storage").content;
            _loc3_ = Pet.getPetById(param1).foodItems;
            _loc4_ = Pet.getPetById(param1).foodTypes;
            _loc5_ = _loc2_.length;
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc7_ = _loc2_[_loc6_];
               if(_loc3_.indexOf(_loc7_.objectGID) > -1 || _loc4_.indexOf(_loc7_.typeId) > -1)
               {
                  _loc8_.push(_loc7_);
               }
               _loc6_++;
            }
         }
         return _loc8_;
      }
      
      [Untrusted]
      public static function getRideFoods() : Array
      {
         var _loc1_:RideFood = null;
         var _loc2_:ItemWrapper = null;
         var _loc3_:Item = null;
         var _loc4_:Array = new Array();
         var _loc5_:Vector.<ItemWrapper> = InventoryManager.getInstance().inventory.getView("storage").content;
         var _loc6_:Array = RideFood.getRideFoods();
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         for each(_loc1_ in _loc6_)
         {
            if(_loc1_.gid != 0)
            {
               _loc7_.push(_loc1_.gid);
            }
            if(_loc1_.typeId != 0)
            {
               _loc8_.push(_loc1_.typeId);
            }
         }
         for each(_loc2_ in _loc5_)
         {
            _loc3_ = Item.getItemById(_loc2_.objectGID);
            if(_loc7_.indexOf(_loc2_.objectGID) != -1 || _loc8_.indexOf(_loc3_.typeId) != -1)
            {
               _loc4_.push(_loc2_);
            }
         }
         return _loc4_;
      }
      
      [Untrusted]
      public static function getViewContent(param1:String) : Vector.<ItemWrapper>
      {
         var _loc2_:IInventoryView = InventoryManager.getInstance().inventory.getView(param1);
         if(_loc2_)
         {
            return _loc2_.content;
         }
         return null;
      }
      
      [Untrusted]
      public static function getShortcutBarContent(param1:uint) : Array
      {
         if(param1 == ShortcutBarEnum.GENERAL_SHORTCUT_BAR)
         {
            return InventoryManager.getInstance().shortcutBarItems;
         }
         if(param1 == ShortcutBarEnum.SPELL_SHORTCUT_BAR)
         {
            return InventoryManager.getInstance().shortcutBarSpells;
         }
         return new Array();
      }
      
      [Untrusted]
      public static function getFakeItemMount() : MountWrapper
      {
         if(PlayedCharacterManager.getInstance().mount)
         {
            return MountWrapper.create();
         }
         return null;
      }
      
      [Untrusted]
      public static function getBestEquipablePosition(param1:Object) : int
      {
         var _loc2_:int = 0;
         var _loc3_:ItemType = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = param1.type.superTypeId;
         if(param1 && (param1.isLivingObject || param1.isWrapperObject))
         {
            _loc2_ = 0;
            if(param1.isLivingObject)
            {
               _loc2_ = param1.livingObjectCategory;
            }
            else
            {
               _loc2_ = param1.wrapperObjectCategory;
            }
            _loc3_ = ItemType.getItemTypeById(_loc2_);
            if(_loc3_)
            {
               _loc9_ = _loc3_.superTypeId;
            }
         }
         var _loc10_:Object;
         if((_loc10_ = itemSuperTypeToServerPosition(_loc9_)) && _loc10_.length)
         {
            _loc4_ = getViewContent("equipment");
            _loc5_ = -1;
            for each(_loc6_ in _loc10_)
            {
               _loc7_ = param1.typeId;
               if(_loc4_[_loc6_] && _loc4_[_loc6_].objectGID == param1.objectGID && (param1.typeId != 9 || param1.belongsToSet))
               {
                  _loc5_ = _loc6_;
                  break;
               }
            }
            if(_loc5_ == -1)
            {
               for each(_loc6_ in _loc10_)
               {
                  if(!_loc4_[_loc6_])
                  {
                     _loc5_ = _loc6_;
                     break;
                  }
               }
            }
            if(_loc5_ == -1)
            {
               if(!_lastItemPosition[param1.type.superTypeId])
               {
                  _lastItemPosition[param1.type.superTypeId] = 0;
               }
               if((_loc8_ = ++_lastItemPosition[param1.type.superTypeId]) >= _loc10_.length)
               {
                  _loc8_ = 0;
               }
               _lastItemPosition[param1.type.superTypeId] = _loc8_;
               _loc5_ = _loc10_[_loc8_];
            }
         }
         return _loc5_;
      }
      
      [Untrusted]
      public static function addItemMask(param1:int, param2:String, param3:int) : void
      {
         InventoryManager.getInstance().inventory.addItemMask(param1,param2,param3);
      }
      
      [Untrusted]
      public static function removeItemMask(param1:int, param2:String) : void
      {
         InventoryManager.getInstance().inventory.removeItemMask(param1,param2);
      }
      
      [Untrusted]
      public static function removeAllItemMasks(param1:String) : void
      {
         InventoryManager.getInstance().inventory.removeAllItemMasks(param1);
      }
      
      [Untrusted]
      public static function releaseHooks() : void
      {
         InventoryManager.getInstance().inventory.releaseHooks();
      }
      
      [Untrusted]
      public static function releaseBankHooks() : void
      {
         InventoryManager.getInstance().bankInventory.releaseHooks();
      }
      
      [Untrusted]
      public static function dracoTurkyInventoryWeight() : uint
      {
         var _loc1_:MountFrame = Kernel.getWorker().getFrame(MountFrame) as MountFrame;
         return _loc1_.inventoryWeight;
      }
      
      [Untrusted]
      public static function dracoTurkyMaxInventoryWeight() : uint
      {
         var _loc1_:MountFrame = Kernel.getWorker().getFrame(MountFrame) as MountFrame;
         return _loc1_.inventoryMaxWeight;
      }
      
      [Untrusted]
      public static function getStorageTypes(param1:int) : Array
      {
         var _loc2_:Object = null;
         var _loc3_:Array = new Array();
         var _loc4_:Dictionary;
         if(!(_loc4_ = StorageOptionManager.getInstance().getCategoryTypes(param1)))
         {
            return null;
         }
         for each(_loc2_ in _loc4_)
         {
            _loc3_.push(_loc2_);
         }
         _loc3_.sort(sortStorageTypes);
         return _loc3_;
      }
      
      private static function sortStorageTypes(param1:Object, param2:Object) : int
      {
         return -StringUtils.noAccent(param2.name).localeCompare(StringUtils.noAccent(param1.name));
      }
      
      [Untrusted]
      public static function getBankStorageTypes(param1:int) : Array
      {
         var _loc2_:Object = null;
         var _loc3_:Array = new Array();
         var _loc4_:Dictionary;
         if(!(_loc4_ = StorageOptionManager.getInstance().getBankCategoryTypes(param1)))
         {
            return null;
         }
         for each(_loc2_ in _loc4_)
         {
            _loc3_.push(_loc2_);
         }
         _loc3_.sortOn("name");
         return _loc3_;
      }
      
      [Untrusted]
      public static function setDisplayedCategory(param1:int) : void
      {
         StorageOptionManager.getInstance().category = param1;
      }
      
      [Untrusted]
      public static function setDisplayedBankCategory(param1:int) : void
      {
         StorageOptionManager.getInstance().bankCategory = param1;
      }
      
      [Untrusted]
      public static function getDisplayedCategory() : int
      {
         return StorageOptionManager.getInstance().category;
      }
      
      [Untrusted]
      public static function getDisplayedBankCategory() : int
      {
         return StorageOptionManager.getInstance().bankCategory;
      }
      
      [Untrusted]
      public static function setStorageFilter(param1:int) : void
      {
         StorageOptionManager.getInstance().filter = param1;
      }
      
      [Untrusted]
      public static function setBankStorageFilter(param1:int) : void
      {
         StorageOptionManager.getInstance().bankFilter = param1;
      }
      
      [Untrusted]
      public static function getStorageFilter() : int
      {
         return StorageOptionManager.getInstance().filter;
      }
      
      [Untrusted]
      public static function getBankStorageFilter() : int
      {
         return StorageOptionManager.getInstance().bankFilter;
      }
      
      [Untrusted]
      public static function updateStorageView() : void
      {
         StorageOptionManager.getInstance().updateStorageView();
      }
      
      [Untrusted]
      public static function updateBankStorageView() : void
      {
         StorageOptionManager.getInstance().updateBankStorageView();
      }
      
      [Untrusted]
      public static function sort(param1:int, param2:Boolean) : void
      {
         StorageOptionManager.getInstance().sortRevert = param2;
         StorageOptionManager.getInstance().sortField = param1;
      }
      
      [Untrusted]
      public static function resetSort() : void
      {
         StorageOptionManager.getInstance().resetSort();
      }
      
      [Untrusted]
      public static function sortBank(param1:int, param2:Boolean) : void
      {
         StorageOptionManager.getInstance().sortBankRevert = param2;
         StorageOptionManager.getInstance().sortBankField = param1;
      }
      
      [Untrusted]
      public static function resetBankSort() : void
      {
         StorageOptionManager.getInstance().resetBankSort();
      }
      
      [Untrusted]
      public static function getSortFields() : Array
      {
         return StorageOptionManager.getInstance().sortFields;
      }
      
      [Untrusted]
      public static function getSortBankFields() : Array
      {
         return StorageOptionManager.getInstance().sortBankFields;
      }
      
      [Untrusted]
      public static function unsort() : void
      {
         StorageOptionManager.getInstance().sortField = StorageOptionManager.SORT_FIELD_NONE;
      }
      
      [Untrusted]
      public static function unsortBank() : void
      {
         StorageOptionManager.getInstance().sortBankField = StorageOptionManager.SORT_FIELD_NONE;
      }
      
      [Untrusted]
      public static function enableBidHouseFilter(param1:Object, param2:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Vector.<uint> = new Vector.<uint>();
         for each(_loc3_ in param1)
         {
            _loc4_.push(_loc3_);
         }
         StorageOptionManager.getInstance().enableBidHouseFilter(_loc4_,param2);
      }
      
      [Untrusted]
      public static function disableBidHouseFilter() : void
      {
         StorageOptionManager.getInstance().disableBidHouseFilter();
      }
      
      [Untrusted]
      public static function getIsBidHouseFilterEnabled() : Boolean
      {
         return StorageOptionManager.getInstance().getIsBidHouseFilterEnabled();
      }
      
      [Untrusted]
      public static function enableSmithMagicFilter(param1:Object) : void
      {
         StorageOptionManager.getInstance().enableSmithMagicFilter(param1 as Skill);
      }
      
      [Untrusted]
      public static function disableSmithMagicFilter() : void
      {
         StorageOptionManager.getInstance().disableSmithMagicFilter();
      }
      
      [Untrusted]
      public static function enableCraftFilter(param1:Object, param2:int) : void
      {
         StorageOptionManager.getInstance().enableCraftFilter(param1 as Skill,param2);
      }
      
      [Untrusted]
      public static function disableCraftFilter() : void
      {
         StorageOptionManager.getInstance().disableCraftFilter();
      }
      
      [Untrusted]
      public static function getIsSmithMagicFilterEnabled() : Boolean
      {
         return StorageOptionManager.getInstance().getIsSmithMagicFilterEnabled();
      }
      
      [Untrusted]
      public static function getItemMaskCount(param1:int, param2:String) : int
      {
         return InventoryManager.getInstance().inventory.getItemMaskCount(param1,param2);
      }
   }
}
