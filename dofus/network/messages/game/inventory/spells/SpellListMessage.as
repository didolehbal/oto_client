package com.ankamagames.dofus.network.messages.game.inventory.spells
{
   import com.ankamagames.dofus.network.types.game.data.items.SpellItem;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class SpellListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 1200;
       
      
      private var _isInitialized:Boolean = false;
      
      public var spellPrevisualization:Boolean = false;
      
      public var spells:Vector.<SpellItem>;
      
      public function SpellListMessage()
      {
         this.spells = new Vector.<SpellItem>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 1200;
      }
      
      public function initSpellListMessage(param1:Boolean = false, param2:Vector.<SpellItem> = null) : SpellListMessage
      {
         this.spellPrevisualization = param1;
         this.spells = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.spellPrevisualization = false;
         this.spells = new Vector.<SpellItem>();
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
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_SpellListMessage(param1);
      }
      
      public function serializeAs_SpellListMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeBoolean(this.spellPrevisualization);
         param1.writeShort(this.spells.length);
         while(_loc2_ < this.spells.length)
         {
            (this.spells[_loc2_] as SpellItem).serializeAs_SpellItem(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_SpellListMessage(param1);
      }
      
      public function deserializeAs_SpellListMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:SpellItem = null;
         var _loc4_:uint = 0;
         this.spellPrevisualization = param1.readBoolean();
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new SpellItem();
            _loc2_.deserialize(param1);
            this.spells.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
