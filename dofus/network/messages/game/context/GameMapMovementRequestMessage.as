package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameMapMovementRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 950;
       
      
      private var _isInitialized:Boolean = false;
      
      public var keyMovements:Vector.<uint>;
      
      public var mapId:uint = 0;
      
      public function GameMapMovementRequestMessage()
      {
         this.keyMovements = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 950;
      }
      
      public function initGameMapMovementRequestMessage(param1:Vector.<uint> = null, param2:uint = 0) : GameMapMovementRequestMessage
      {
         this.keyMovements = param1;
         this.mapId = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.keyMovements = new Vector.<uint>();
         this.mapId = 0;
         this._isInitialized = false;
      }
      
      override public function pack(param1:ICustomDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(new CustomDataWrapper(_loc2_));
         if(HASH_FUNCTION != null)
         {
            HASH_FUNCTION(_loc2_);
         }
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:ICustomDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameMapMovementRequestMessage(param1);
      }
      
      public function serializeAs_GameMapMovementRequestMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.keyMovements.length);
         while(_loc2_ < this.keyMovements.length)
         {
            if(this.keyMovements[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.keyMovements[_loc2_] + ") on element 1 (starting at 1) of keyMovements.");
            }
            param1.writeShort(this.keyMovements[_loc2_]);
            _loc2_++;
         }
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element mapId.");
         }
         param1.writeInt(this.mapId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameMapMovementRequestMessage(param1);
      }
      
      public function deserializeAs_GameMapMovementRequestMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readShort();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of keyMovements.");
            }
            this.keyMovements.push(_loc2_);
            _loc4_++;
         }
         this.mapId = param1.readInt();
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element of GameMapMovementRequestMessage.mapId.");
         }
      }
   }
}
