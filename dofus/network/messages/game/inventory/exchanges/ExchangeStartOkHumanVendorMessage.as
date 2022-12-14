package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemToSellInHumanVendorShop;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeStartOkHumanVendorMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5767;
       
      
      private var _isInitialized:Boolean = false;
      
      public var sellerId:uint = 0;
      
      public var objectsInfos:Vector.<ObjectItemToSellInHumanVendorShop>;
      
      public function ExchangeStartOkHumanVendorMessage()
      {
         this.objectsInfos = new Vector.<ObjectItemToSellInHumanVendorShop>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5767;
      }
      
      public function initExchangeStartOkHumanVendorMessage(param1:uint = 0, param2:Vector.<ObjectItemToSellInHumanVendorShop> = null) : ExchangeStartOkHumanVendorMessage
      {
         this.sellerId = param1;
         this.objectsInfos = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.sellerId = 0;
         this.objectsInfos = new Vector.<ObjectItemToSellInHumanVendorShop>();
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
         this.serializeAs_ExchangeStartOkHumanVendorMessage(param1);
      }
      
      public function serializeAs_ExchangeStartOkHumanVendorMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         if(this.sellerId < 0)
         {
            throw new Error("Forbidden value (" + this.sellerId + ") on element sellerId.");
         }
         param1.writeVarInt(this.sellerId);
         param1.writeShort(this.objectsInfos.length);
         while(_loc2_ < this.objectsInfos.length)
         {
            (this.objectsInfos[_loc2_] as ObjectItemToSellInHumanVendorShop).serializeAs_ObjectItemToSellInHumanVendorShop(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeStartOkHumanVendorMessage(param1);
      }
      
      public function deserializeAs_ExchangeStartOkHumanVendorMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:ObjectItemToSellInHumanVendorShop = null;
         var _loc4_:uint = 0;
         this.sellerId = param1.readVarUhInt();
         if(this.sellerId < 0)
         {
            throw new Error("Forbidden value (" + this.sellerId + ") on element of ExchangeStartOkHumanVendorMessage.sellerId.");
         }
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new ObjectItemToSellInHumanVendorShop();
            _loc2_.deserialize(param1);
            this.objectsInfos.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
