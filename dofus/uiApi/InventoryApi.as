package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.MountWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.PresetWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.QuantifiedItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.SimpleTextureWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.InventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayPointCellFrame;
   import com.ankamagames.dofus.network.enums.CharacterInventoryPositionEnum;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class InventoryApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function InventoryApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(InventoryApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getStorageObjectGID(param1:uint, param2:uint = 1) : Object
      {
         var _loc3_:ItemWrapper = null;
         var _loc5_:uint = 0;
         var _loc4_:Array = new Array();
         var _loc6_:Vector.<ItemWrapper> = InventoryManager.getInstance().realInventory;
         for each(_loc3_ in _loc6_)
         {
            if(!(_loc3_.objectGID != param1 || _loc3_.position < 63 || _loc3_.linked))
            {
               if(_loc3_.quantity >= param2 - _loc5_)
               {
                  _loc4_.push({
                     "objectUID":_loc3_.objectUID,
                     "quantity":param2 - _loc5_
                  });
                  _loc5_ = param2;
                  return _loc4_;
               }
               _loc4_.push({
                  "objectUID":_loc3_.objectUID,
                  "quantity":_loc3_.quantity
               });
               _loc5_ = _loc5_ + _loc3_.quantity;
            }
         }
         return null;
      }
      
      [Untrusted]
      public function getStorageObjectsByType(param1:uint) : Array
      {
         var _loc2_:ItemWrapper = null;
         var _loc3_:Array = new Array();
         var _loc4_:Vector.<ItemWrapper> = InventoryManager.getInstance().realInventory;
         for each(_loc2_ in _loc4_)
         {
            if(!(_loc2_.typeId != param1 || _loc2_.position < 63))
            {
               _loc3_.push(_loc2_);
            }
         }
         return _loc3_;
      }
      
      [Untrusted]
      public function getItemQty(param1:uint, param2:uint = 0) : uint
      {
         var _loc3_:ItemWrapper = null;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<ItemWrapper> = InventoryManager.getInstance().realInventory;
         for each(_loc3_ in _loc5_)
         {
            if(!(_loc3_.position < 63 || _loc3_.objectGID != param1 || param2 > 0 && _loc3_.objectUID != param2))
            {
               _loc4_ = _loc4_ + _loc3_.quantity;
            }
         }
         return _loc4_;
      }
      
      [Untrusted]
      public function getItemByGID(param1:uint) : ItemWrapper
      {
         var _loc2_:ItemWrapper = null;
         var _loc3_:Vector.<ItemWrapper> = InventoryManager.getInstance().realInventory;
         for each(_loc2_ in _loc3_)
         {
            if(!(_loc2_.position < 63 || _loc2_.objectGID != param1))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      [Untrusted]
      public function getQuantifiedItemByGIDInInventoryOrMakeUpOne(param1:uint) : QuantifiedItemWrapper
      {
         var _loc2_:QuantifiedItemWrapper = null;
         var _loc3_:ItemWrapper = null;
         var _loc5_:ItemWrapper = null;
         var _loc4_:Vector.<ItemWrapper> = InventoryManager.getInstance().realInventory;
         for each(_loc3_ in _loc4_)
         {
            if(!(_loc3_.position < 63 || _loc3_.objectGID != param1))
            {
               _loc5_ = _loc3_;
               break;
            }
         }
         if(_loc5_)
         {
            _loc2_ = QuantifiedItemWrapper.create(_loc5_.position,_loc5_.objectUID,param1,_loc5_.quantity,_loc5_.effectsList,false);
         }
         else
         {
            _loc2_ = QuantifiedItemWrapper.create(0,0,param1,0,new Vector.<ObjectEffect>(),false);
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getItem(param1:uint) : ItemWrapper
      {
         return InventoryManager.getInstance().inventory.getItem(param1);
      }
      
      [Untrusted]
      public function getEquipementItemByPosition(param1:uint) : ItemWrapper
      {
         if(param1 > 15 && param1 != CharacterInventoryPositionEnum.INVENTORY_POSITION_COMPANION)
         {
            return null;
         }
         var _loc2_:Vector.<ItemWrapper> = InventoryManager.getInstance().inventory.getView("equipment").content;
         return _loc2_[param1];
      }
      
      [Untrusted]
      public function getEquipement() : Vector.<ItemWrapper>
      {
         return InventoryManager.getInstance().inventory.getView("equipment").content;
      }
      
      [Untrusted]
      public function getEquipementForPreset() : Array
      {
         var _loc1_:Uri = null;
         var _loc2_:Boolean = false;
         var _loc3_:ItemWrapper = null;
         var _loc4_:MountWrapper = null;
         var _loc7_:int = 0;
         var _loc5_:Vector.<ItemWrapper> = InventoryManager.getInstance().inventory.getView("equipment").content;
         var _loc6_:Array = new Array(16);
         while(_loc7_ < 16)
         {
            _loc2_ = false;
            for each(_loc3_ in _loc5_)
            {
               if(_loc3_)
               {
                  if(_loc3_.position == _loc7_)
                  {
                     _loc6_[_loc7_] = _loc3_;
                     _loc2_ = true;
                  }
               }
               else if(_loc7_ == 8 && PlayedCharacterManager.getInstance().isRidding)
               {
                  _loc4_ = MountWrapper.create();
                  _loc6_[_loc7_] = _loc4_;
                  _loc2_ = true;
               }
            }
            if(!_loc2_)
            {
               switch(_loc7_)
               {
                  case 9:
                  case 10:
                  case 11:
                  case 12:
                  case 13:
                  case 14:
                     _loc1_ = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "assets.swf|tx_slotDofus");
                     break;
                  default:
                     _loc1_ = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "assets.swf|tx_slotItem" + _loc7_);
               }
               _loc6_[_loc7_] = SimpleTextureWrapper.create(_loc1_);
            }
            _loc7_++;
         }
         return _loc6_;
      }
      
      [Untrusted]
      public function getVoidItemForPreset(param1:int) : SimpleTextureWrapper
      {
         var _loc2_:Uri = null;
         switch(param1)
         {
            case 9:
            case 10:
            case 11:
            case 12:
            case 13:
            case 14:
               _loc2_ = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "assets.swf|tx_slotDofus");
               break;
            default:
               _loc2_ = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "assets.swf|tx_slotItem" + param1);
         }
         return SimpleTextureWrapper.create(_loc2_);
      }
      
      [Untrusted]
      public function getCurrentWeapon() : ItemWrapper
      {
         return this.getEquipementItemByPosition(CharacterInventoryPositionEnum.ACCESSORY_POSITION_WEAPON) as ItemWrapper;
      }
      
      [Untrusted]
      public function getPresets() : Array
      {
         var _loc1_:PresetWrapper = null;
         var _loc4_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:Uri = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin").concat("bitmap/emptySlot.png"));
         while(_loc4_ < 16)
         {
            _loc1_ = InventoryManager.getInstance().presets[_loc4_];
            if(_loc1_)
            {
               _loc2_.push(_loc1_);
            }
            else
            {
               _loc2_.push(SimpleTextureWrapper.create(_loc3_));
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      [Trusted]
      public function removeSelectedItem() : Boolean
      {
         var _loc1_:RoleplayPointCellFrame = null;
         var _loc2_:InventoryManagementFrame = Kernel.getWorker().getFrame(InventoryManagementFrame) as InventoryManagementFrame;
         if(_loc2_ && _loc2_.roleplayPointCellFrame && _loc2_.roleplayPointCellFrame.object)
         {
            _loc1_ = Kernel.getWorker().getFrame(RoleplayPointCellFrame) as RoleplayPointCellFrame;
            if(_loc1_)
            {
               _loc1_.cancelShow();
            }
            else
            {
               Kernel.getWorker().removeFrame(_loc2_.roleplayPointCellFrame.object as RoleplayPointCellFrame);
               _loc2_.roleplayPointCellFrame = null;
            }
            return true;
         }
         return false;
      }
   }
}
