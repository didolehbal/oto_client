package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemToSellInBid;
   import com.ankamagames.dofus.network.types.game.data.items.SellerBuyerDescriptor;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeStartedBidSellerMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5905;
       
      
      private var _isInitialized:Boolean = false;
      
      public var sellerDescriptor:SellerBuyerDescriptor;
      
      public var objectsInfos:Vector.<ObjectItemToSellInBid>;
      
      public function ExchangeStartedBidSellerMessage()
      {
         this.sellerDescriptor = new SellerBuyerDescriptor();
         this.objectsInfos = new Vector.<ObjectItemToSellInBid>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5905;
      }
      
      public function initExchangeStartedBidSellerMessage(param1:SellerBuyerDescriptor = null, param2:Vector.<ObjectItemToSellInBid> = null) : ExchangeStartedBidSellerMessage
      {
         this.sellerDescriptor = param1;
         this.objectsInfos = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.sellerDescriptor = new SellerBuyerDescriptor();
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
         this.serializeAs_ExchangeStartedBidSellerMessage(param1);
      }
      
      public function serializeAs_ExchangeStartedBidSellerMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         this.sellerDescriptor.serializeAs_SellerBuyerDescriptor(param1);
         param1.writeShort(this.objectsInfos.length);
         while(_loc2_ < this.objectsInfos.length)
         {
            (this.objectsInfos[_loc2_] as ObjectItemToSellInBid).serializeAs_ObjectItemToSellInBid(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeStartedBidSellerMessage(param1);
      }
      
      public function deserializeAs_ExchangeStartedBidSellerMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:ObjectItemToSellInBid = null;
         var _loc4_:uint = 0;
         this.sellerDescriptor = new SellerBuyerDescriptor();
         this.sellerDescriptor.deserialize(param1);
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new ObjectItemToSellInBid();
            _loc2_.deserialize(param1);
            this.objectsInfos.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
