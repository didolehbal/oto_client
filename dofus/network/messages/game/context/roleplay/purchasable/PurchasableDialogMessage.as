package com.ankamagames.dofus.network.messages.game.context.roleplay.purchasable
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class PurchasableDialogMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5739;
       
      
      private var _isInitialized:Boolean = false;
      
      public var buyOrSell:Boolean = false;
      
      public var purchasableId:uint = 0;
      
      public var price:uint = 0;
      
      public function PurchasableDialogMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5739;
      }
      
      public function initPurchasableDialogMessage(param1:Boolean = false, param2:uint = 0, param3:uint = 0) : PurchasableDialogMessage
      {
         this.buyOrSell = param1;
         this.purchasableId = param2;
         this.price = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.buyOrSell = false;
         this.purchasableId = 0;
         this.price = 0;
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
         this.serializeAs_PurchasableDialogMessage(param1);
      }
      
      public function serializeAs_PurchasableDialogMessage(param1:ICustomDataOutput) : void
      {
         param1.writeBoolean(this.buyOrSell);
         if(this.purchasableId < 0)
         {
            throw new Error("Forbidden value (" + this.purchasableId + ") on element purchasableId.");
         }
         param1.writeVarInt(this.purchasableId);
         if(this.price < 0)
         {
            throw new Error("Forbidden value (" + this.price + ") on element price.");
         }
         param1.writeVarInt(this.price);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PurchasableDialogMessage(param1);
      }
      
      public function deserializeAs_PurchasableDialogMessage(param1:ICustomDataInput) : void
      {
         this.buyOrSell = param1.readBoolean();
         this.purchasableId = param1.readVarUhInt();
         if(this.purchasableId < 0)
         {
            throw new Error("Forbidden value (" + this.purchasableId + ") on element of PurchasableDialogMessage.purchasableId.");
         }
         this.price = param1.readVarUhInt();
         if(this.price < 0)
         {
            throw new Error("Forbidden value (" + this.price + ") on element of PurchasableDialogMessage.price.");
         }
      }
   }
}
