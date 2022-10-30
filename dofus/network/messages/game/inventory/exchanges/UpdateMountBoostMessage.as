package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.mount.UpdateMountBoost;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class UpdateMountBoostMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6179;
       
      
      private var _isInitialized:Boolean = false;
      
      public var rideId:int = 0;
      
      public var boostToUpdateList:Vector.<UpdateMountBoost>;
      
      public function UpdateMountBoostMessage()
      {
         this.boostToUpdateList = new Vector.<UpdateMountBoost>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6179;
      }
      
      public function initUpdateMountBoostMessage(param1:int = 0, param2:Vector.<UpdateMountBoost> = null) : UpdateMountBoostMessage
      {
         this.rideId = param1;
         this.boostToUpdateList = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.rideId = 0;
         this.boostToUpdateList = new Vector.<UpdateMountBoost>();
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
         this.serializeAs_UpdateMountBoostMessage(param1);
      }
      
      public function serializeAs_UpdateMountBoostMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeVarInt(this.rideId);
         param1.writeShort(this.boostToUpdateList.length);
         while(_loc2_ < this.boostToUpdateList.length)
         {
            param1.writeShort((this.boostToUpdateList[_loc2_] as UpdateMountBoost).getTypeId());
            (this.boostToUpdateList[_loc2_] as UpdateMountBoost).serialize(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_UpdateMountBoostMessage(param1);
      }
      
      public function deserializeAs_UpdateMountBoostMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:UpdateMountBoost = null;
         var _loc5_:uint = 0;
         this.rideId = param1.readVarInt();
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(UpdateMountBoost,_loc2_);
            _loc3_.deserialize(param1);
            this.boostToUpdateList.push(_loc3_);
            _loc5_++;
         }
      }
   }
}
