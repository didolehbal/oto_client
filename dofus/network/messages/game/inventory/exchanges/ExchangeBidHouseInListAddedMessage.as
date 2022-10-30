package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeBidHouseInListAddedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5949;
       
      
      private var _isInitialized:Boolean = false;
      
      public var itemUID:int = 0;
      
      public var objGenericId:int = 0;
      
      public var effects:Vector.<ObjectEffect>;
      
      public var prices:Vector.<uint>;
      
      public function ExchangeBidHouseInListAddedMessage()
      {
         this.effects = new Vector.<ObjectEffect>();
         this.prices = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5949;
      }
      
      public function initExchangeBidHouseInListAddedMessage(param1:int = 0, param2:int = 0, param3:Vector.<ObjectEffect> = null, param4:Vector.<uint> = null) : ExchangeBidHouseInListAddedMessage
      {
         this.itemUID = param1;
         this.objGenericId = param2;
         this.effects = param3;
         this.prices = param4;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.itemUID = 0;
         this.objGenericId = 0;
         this.effects = new Vector.<ObjectEffect>();
         this.prices = new Vector.<uint>();
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
         this.serializeAs_ExchangeBidHouseInListAddedMessage(param1);
      }
      
      public function serializeAs_ExchangeBidHouseInListAddedMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         param1.writeInt(this.itemUID);
         param1.writeInt(this.objGenericId);
         param1.writeShort(this.effects.length);
         while(_loc2_ < this.effects.length)
         {
            param1.writeShort((this.effects[_loc2_] as ObjectEffect).getTypeId());
            (this.effects[_loc2_] as ObjectEffect).serialize(param1);
            _loc2_++;
         }
         param1.writeShort(this.prices.length);
         while(_loc3_ < this.prices.length)
         {
            if(this.prices[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.prices[_loc3_] + ") on element 4 (starting at 1) of prices.");
            }
            param1.writeVarInt(this.prices[_loc3_]);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeBidHouseInListAddedMessage(param1);
      }
      
      public function deserializeAs_ExchangeBidHouseInListAddedMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ObjectEffect = null;
         var _loc4_:uint = 0;
         var _loc6_:uint = 0;
         var _loc8_:uint = 0;
         this.itemUID = param1.readInt();
         this.objGenericId = param1.readInt();
         var _loc5_:uint = param1.readUnsignedShort();
         while(_loc6_ < _loc5_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(ObjectEffect,_loc2_);
            _loc3_.deserialize(param1);
            this.effects.push(_loc3_);
            _loc6_++;
         }
         var _loc7_:uint = param1.readUnsignedShort();
         while(_loc8_ < _loc7_)
         {
            if((_loc4_ = param1.readVarUhInt()) < 0)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of prices.");
            }
            this.prices.push(_loc4_);
            _loc8_++;
         }
      }
   }
}
