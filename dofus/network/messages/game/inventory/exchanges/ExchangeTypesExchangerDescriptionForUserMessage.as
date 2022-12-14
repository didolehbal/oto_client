package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeTypesExchangerDescriptionForUserMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5765;
       
      
      private var _isInitialized:Boolean = false;
      
      public var typeDescription:Vector.<uint>;
      
      public function ExchangeTypesExchangerDescriptionForUserMessage()
      {
         this.typeDescription = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5765;
      }
      
      public function initExchangeTypesExchangerDescriptionForUserMessage(param1:Vector.<uint> = null) : ExchangeTypesExchangerDescriptionForUserMessage
      {
         this.typeDescription = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.typeDescription = new Vector.<uint>();
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
         this.serializeAs_ExchangeTypesExchangerDescriptionForUserMessage(param1);
      }
      
      public function serializeAs_ExchangeTypesExchangerDescriptionForUserMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.typeDescription.length);
         while(_loc2_ < this.typeDescription.length)
         {
            if(this.typeDescription[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.typeDescription[_loc2_] + ") on element 1 (starting at 1) of typeDescription.");
            }
            param1.writeVarInt(this.typeDescription[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeTypesExchangerDescriptionForUserMessage(param1);
      }
      
      public function deserializeAs_ExchangeTypesExchangerDescriptionForUserMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readVarUhInt();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of typeDescription.");
            }
            this.typeDescription.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
