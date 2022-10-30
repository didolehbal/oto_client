package com.ankamagames.dofus.network.messages.game.pvp
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class UpdateMapPlayersAgressableStatusMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6454;
       
      
      private var _isInitialized:Boolean = false;
      
      public var playerIds:Vector.<uint>;
      
      public var enable:Vector.<uint>;
      
      public function UpdateMapPlayersAgressableStatusMessage()
      {
         this.playerIds = new Vector.<uint>();
         this.enable = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6454;
      }
      
      public function initUpdateMapPlayersAgressableStatusMessage(param1:Vector.<uint> = null, param2:Vector.<uint> = null) : UpdateMapPlayersAgressableStatusMessage
      {
         this.playerIds = param1;
         this.enable = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.playerIds = new Vector.<uint>();
         this.enable = new Vector.<uint>();
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
         this.serializeAs_UpdateMapPlayersAgressableStatusMessage(param1);
      }
      
      public function serializeAs_UpdateMapPlayersAgressableStatusMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         param1.writeShort(this.playerIds.length);
         while(_loc2_ < this.playerIds.length)
         {
            if(this.playerIds[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.playerIds[_loc2_] + ") on element 1 (starting at 1) of playerIds.");
            }
            param1.writeVarInt(this.playerIds[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.enable.length);
         while(_loc3_ < this.enable.length)
         {
            param1.writeByte(this.enable[_loc3_]);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_UpdateMapPlayersAgressableStatusMessage(param1);
      }
      
      public function deserializeAs_UpdateMapPlayersAgressableStatusMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readVarUhInt();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of playerIds.");
            }
            this.playerIds.push(_loc2_);
            _loc5_++;
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc3_ = param1.readByte();
            if(_loc3_ < 0)
            {
               throw new Error("Forbidden value (" + _loc3_ + ") on elements of enable.");
            }
            this.enable.push(_loc3_);
            _loc7_++;
         }
      }
   }
}
