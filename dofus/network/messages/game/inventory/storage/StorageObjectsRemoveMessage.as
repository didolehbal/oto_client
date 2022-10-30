package com.ankamagames.dofus.network.messages.game.inventory.storage
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class StorageObjectsRemoveMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6035;
       
      
      private var _isInitialized:Boolean = false;
      
      public var objectUIDList:Vector.<uint>;
      
      public function StorageObjectsRemoveMessage()
      {
         this.objectUIDList = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6035;
      }
      
      public function initStorageObjectsRemoveMessage(param1:Vector.<uint> = null) : StorageObjectsRemoveMessage
      {
         this.objectUIDList = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.objectUIDList = new Vector.<uint>();
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
         this.serializeAs_StorageObjectsRemoveMessage(param1);
      }
      
      public function serializeAs_StorageObjectsRemoveMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.objectUIDList.length);
         while(_loc2_ < this.objectUIDList.length)
         {
            if(this.objectUIDList[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.objectUIDList[_loc2_] + ") on element 1 (starting at 1) of objectUIDList.");
            }
            param1.writeVarInt(this.objectUIDList[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_StorageObjectsRemoveMessage(param1);
      }
      
      public function deserializeAs_StorageObjectsRemoveMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readVarUhInt();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of objectUIDList.");
            }
            this.objectUIDList.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
