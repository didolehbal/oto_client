package com.ankamagames.dofus.network.messages.game.inventory.items
{
   import com.ankamagames.dofus.network.types.game.data.items.GoldItem;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GoldAddedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6030;
       
      
      private var _isInitialized:Boolean = false;
      
      public var gold:GoldItem;
      
      public function GoldAddedMessage()
      {
         this.gold = new GoldItem();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6030;
      }
      
      public function initGoldAddedMessage(param1:GoldItem = null) : GoldAddedMessage
      {
         this.gold = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.gold = new GoldItem();
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
         this.serializeAs_GoldAddedMessage(param1);
      }
      
      public function serializeAs_GoldAddedMessage(param1:ICustomDataOutput) : void
      {
         this.gold.serializeAs_GoldItem(param1);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GoldAddedMessage(param1);
      }
      
      public function deserializeAs_GoldAddedMessage(param1:ICustomDataInput) : void
      {
         this.gold = new GoldItem();
         this.gold.deserialize(param1);
      }
   }
}
