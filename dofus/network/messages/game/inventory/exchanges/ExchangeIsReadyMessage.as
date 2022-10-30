package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeIsReadyMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5509;
       
      
      private var _isInitialized:Boolean = false;
      
      public var id:uint = 0;
      
      public var ready:Boolean = false;
      
      public function ExchangeIsReadyMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5509;
      }
      
      public function initExchangeIsReadyMessage(param1:uint = 0, param2:Boolean = false) : ExchangeIsReadyMessage
      {
         this.id = param1;
         this.ready = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.id = 0;
         this.ready = false;
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
         this.serializeAs_ExchangeIsReadyMessage(param1);
      }
      
      public function serializeAs_ExchangeIsReadyMessage(param1:ICustomDataOutput) : void
      {
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element id.");
         }
         param1.writeVarInt(this.id);
         param1.writeBoolean(this.ready);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeIsReadyMessage(param1);
      }
      
      public function deserializeAs_ExchangeIsReadyMessage(param1:ICustomDataInput) : void
      {
         this.id = param1.readVarUhInt();
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element of ExchangeIsReadyMessage.id.");
         }
         this.ready = param1.readBoolean();
      }
   }
}
