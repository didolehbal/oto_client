package com.ankamagames.dofus.network.messages.game.inventory.items
{
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.dofus.network.types.game.inventory.preset.Preset;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class InventoryContentAndPresetMessage extends InventoryContentMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6162;
       
      
      private var _isInitialized:Boolean = false;
      
      public var presets:Vector.<Preset>;
      
      public function InventoryContentAndPresetMessage()
      {
         this.presets = new Vector.<Preset>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6162;
      }
      
      public function initInventoryContentAndPresetMessage(param1:Vector.<ObjectItem> = null, param2:uint = 0, param3:Vector.<Preset> = null) : InventoryContentAndPresetMessage
      {
         super.initInventoryContentMessage(param1,param2);
         this.presets = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.presets = new Vector.<Preset>();
         this._isInitialized = false;
      }
      
      override public function pack(param1:ICustomDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(new CustomDataWrapper(_loc2_));
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:ICustomDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_InventoryContentAndPresetMessage(param1);
      }
      
      public function serializeAs_InventoryContentAndPresetMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_InventoryContentMessage(param1);
         param1.writeShort(this.presets.length);
         while(_loc2_ < this.presets.length)
         {
            (this.presets[_loc2_] as Preset).serializeAs_Preset(param1);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_InventoryContentAndPresetMessage(param1);
      }
      
      public function deserializeAs_InventoryContentAndPresetMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:Preset = null;
         var _loc4_:uint = 0;
         super.deserialize(param1);
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new Preset();
            _loc2_.deserialize(param1);
            this.presets.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
