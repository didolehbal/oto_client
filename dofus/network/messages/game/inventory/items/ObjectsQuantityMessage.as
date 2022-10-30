package com.ankamagames.dofus.network.messages.game.inventory.items
{
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemQuantity;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ObjectsQuantityMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6206;
       
      
      private var _isInitialized:Boolean = false;
      
      public var objectsUIDAndQty:Vector.<ObjectItemQuantity>;
      
      public function ObjectsQuantityMessage()
      {
         this.objectsUIDAndQty = new Vector.<ObjectItemQuantity>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6206;
      }
      
      public function initObjectsQuantityMessage(param1:Vector.<ObjectItemQuantity> = null) : ObjectsQuantityMessage
      {
         this.objectsUIDAndQty = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.objectsUIDAndQty = new Vector.<ObjectItemQuantity>();
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
         this.serializeAs_ObjectsQuantityMessage(param1);
      }
      
      public function serializeAs_ObjectsQuantityMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.objectsUIDAndQty.length);
         while(_loc2_ < this.objectsUIDAndQty.length)
         {
            (this.objectsUIDAndQty[_loc2_] as ObjectItemQuantity).serializeAs_ObjectItemQuantity(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ObjectsQuantityMessage(param1);
      }
      
      public function deserializeAs_ObjectsQuantityMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:ObjectItemQuantity = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new ObjectItemQuantity();
            _loc2_.deserialize(param1);
            this.objectsUIDAndQty.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
