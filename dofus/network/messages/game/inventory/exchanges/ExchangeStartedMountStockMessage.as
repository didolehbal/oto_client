package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeStartedMountStockMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5984;
       
      
      private var _isInitialized:Boolean = false;
      
      public var objectsInfos:Vector.<ObjectItem>;
      
      public function ExchangeStartedMountStockMessage()
      {
         this.objectsInfos = new Vector.<ObjectItem>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5984;
      }
      
      public function initExchangeStartedMountStockMessage(param1:Vector.<ObjectItem> = null) : ExchangeStartedMountStockMessage
      {
         this.objectsInfos = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.objectsInfos = new Vector.<ObjectItem>();
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
         this.serializeAs_ExchangeStartedMountStockMessage(param1);
      }
      
      public function serializeAs_ExchangeStartedMountStockMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.objectsInfos.length);
         while(_loc2_ < this.objectsInfos.length)
         {
            (this.objectsInfos[_loc2_] as ObjectItem).serializeAs_ObjectItem(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeStartedMountStockMessage(param1);
      }
      
      public function deserializeAs_ExchangeStartedMountStockMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:ObjectItem = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new ObjectItem();
            _loc2_.deserialize(param1);
            this.objectsInfos.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
