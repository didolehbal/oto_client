package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.data.items.BidExchangerObjectInfo;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeTypesItemsExchangerDescriptionForUserMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5752;
       
      
      private var _isInitialized:Boolean = false;
      
      public var itemTypeDescriptions:Vector.<BidExchangerObjectInfo>;
      
      public function ExchangeTypesItemsExchangerDescriptionForUserMessage()
      {
         this.itemTypeDescriptions = new Vector.<BidExchangerObjectInfo>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5752;
      }
      
      public function initExchangeTypesItemsExchangerDescriptionForUserMessage(param1:Vector.<BidExchangerObjectInfo> = null) : ExchangeTypesItemsExchangerDescriptionForUserMessage
      {
         this.itemTypeDescriptions = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.itemTypeDescriptions = new Vector.<BidExchangerObjectInfo>();
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
         this.serializeAs_ExchangeTypesItemsExchangerDescriptionForUserMessage(param1);
      }
      
      public function serializeAs_ExchangeTypesItemsExchangerDescriptionForUserMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.itemTypeDescriptions.length);
         while(_loc2_ < this.itemTypeDescriptions.length)
         {
            (this.itemTypeDescriptions[_loc2_] as BidExchangerObjectInfo).serializeAs_BidExchangerObjectInfo(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeTypesItemsExchangerDescriptionForUserMessage(param1);
      }
      
      public function deserializeAs_ExchangeTypesItemsExchangerDescriptionForUserMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:BidExchangerObjectInfo = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new BidExchangerObjectInfo();
            _loc2_.deserialize(param1);
            this.itemTypeDescriptions.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
