package com.ankamagames.dofus.internalDatacenter.items
{
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.types.game.inventory.preset.PresetItem;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import flash.utils.getQualifiedClassName;
   
   public class PresetWrapper extends ItemWrapper implements IDataCenter
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(PresetWrapper));
       
      
      public var gfxId:int;
      
      public var _objects:Array;
      
      public var mount:Boolean;
      
      private var _uri:Uri;
      
      private var _pngMode:Boolean;
      
      public function PresetWrapper()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:Vector.<PresetItem>, param4:Boolean = false) : PresetWrapper
      {
         var _loc5_:Uri = null;
         var _loc6_:Boolean = false;
         var _loc7_:PresetItem = null;
         var _loc8_:MountWrapper = null;
         var _loc11_:int = 0;
         var _loc9_:PresetWrapper;
         (_loc9_ = new PresetWrapper()).id = param1;
         _loc9_.gfxId = param2;
         _loc9_.objects = new Array(16);
         _loc9_.mount = param4;
         var _loc10_:Uri = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "bitmap/failureSlot.png");
         while(_loc11_ < 16)
         {
            _loc6_ = false;
            for each(_loc7_ in param3)
            {
               if(_loc7_.position == _loc11_)
               {
                  if(_loc7_.objUid)
                  {
                     _loc9_.objects[_loc11_] = InventoryManager.getInstance().inventory.getItem(_loc7_.objUid);
                     _loc9_.objects[_loc11_].backGroundIconUri = null;
                  }
                  else
                  {
                     _loc9_.objects[_loc11_] = ItemWrapper.create(0,0,_loc7_.objGid,1,null,false);
                     _loc9_.objects[_loc11_].backGroundIconUri = _loc10_;
                     _loc9_.objects[_loc11_].active = false;
                  }
                  _loc6_ = true;
               }
            }
            if(_loc11_ == 8 && !_loc6_ && param4)
            {
               _loc8_ = MountWrapper.create();
               _loc9_.objects[_loc11_] = _loc8_;
               _loc9_.objects[_loc11_].backGroundIconUri = null;
               _loc6_ = true;
            }
            if(!_loc6_)
            {
               switch(_loc11_)
               {
                  case 9:
                  case 10:
                  case 11:
                  case 12:
                  case 13:
                  case 14:
                     _loc5_ = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "assets.swf|tx_slotDofus");
                     break;
                  default:
                     _loc5_ = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "assets.swf|tx_slotItem" + _loc11_);
               }
               _loc9_.objects[_loc11_] = SimpleTextureWrapper.create(_loc5_);
            }
            _loc11_++;
         }
         return _loc9_;
      }
      
      public function get objects() : Array
      {
         var _loc1_:MountWrapper = null;
         if(this.mount)
         {
            if(PlayedCharacterManager.getInstance().mount || !PlayedCharacterManager.getInstance().mount && this._objects[8])
            {
               if(!(this._objects[8] is MountWrapper))
               {
                  _loc1_ = MountWrapper.create();
                  this._objects[8] = _loc1_;
                  this._objects[8].backGroundIconUri = null;
               }
               else
               {
                  this._objects[8].update(0,0,0,0,null);
               }
            }
         }
         return this._objects;
      }
      
      public function set objects(param1:Array) : void
      {
         this._objects = param1;
      }
      
      override public function get iconUri() : Uri
      {
         return this.getIconUri();
      }
      
      override public function get fullSizeIconUri() : Uri
      {
         return this.getIconUri();
      }
      
      override public function get errorIconUri() : Uri
      {
         return null;
      }
      
      public function get uri() : Uri
      {
         return this._uri;
      }
      
      override public function getIconUri(param1:Boolean = true) : Uri
      {
         if(!this._uri)
         {
            this._pngMode = false;
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path").concat("presets/icons.swf|icon_").concat(this.gfxId));
         }
         return this._uri;
      }
      
      override public function get info1() : String
      {
         return null;
      }
      
      override public function get timer() : int
      {
         return 0;
      }
      
      override public function get active() : Boolean
      {
         return true;
      }
      
      public function updateObject(param1:PresetItem) : void
      {
         var _loc2_:Uri = null;
         var _loc3_:uint = 0;
         var _loc4_:Uri = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "bitmap/failureSlot.png");
         var _loc5_:int = param1.position;
         if(this._objects[_loc5_])
         {
            if(this._objects[_loc5_].objectGID == param1.objGid)
            {
               if(param1.objUid)
               {
                  this._objects[_loc5_] = InventoryManager.getInstance().inventory.getItem(param1.objUid);
                  if(this._objects[_loc5_])
                  {
                     this._objects[_loc5_].backGroundIconUri = null;
                  }
               }
               else
               {
                  _loc3_ = param1.objGid;
                  this._objects[_loc5_] = ItemWrapper.create(0,0,_loc3_,1,null,false);
                  this._objects[_loc5_].backGroundIconUri = _loc4_;
                  this._objects[_loc5_].active = false;
               }
            }
            else if(param1.objGid == 0 && param1.objUid == 0)
            {
               switch(_loc5_)
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
                     _loc2_ = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "assets.swf|tx_slotItem" + _loc5_);
               }
               this._objects[_loc5_] = SimpleTextureWrapper.create(_loc2_);
            }
         }
      }
      
      override public function addHolder(param1:ISlotDataHolder) : void
      {
      }
      
      override public function removeHolder(param1:ISlotDataHolder) : void
      {
      }
   }
}
