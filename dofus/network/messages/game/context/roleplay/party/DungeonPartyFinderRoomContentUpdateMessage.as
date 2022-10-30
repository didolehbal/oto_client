package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.DungeonPartyFinderPlayer;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class DungeonPartyFinderRoomContentUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6250;
       
      
      private var _isInitialized:Boolean = false;
      
      public var dungeonId:uint = 0;
      
      public var addedPlayers:Vector.<DungeonPartyFinderPlayer>;
      
      public var removedPlayersIds:Vector.<uint>;
      
      public function DungeonPartyFinderRoomContentUpdateMessage()
      {
         this.addedPlayers = new Vector.<DungeonPartyFinderPlayer>();
         this.removedPlayersIds = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6250;
      }
      
      public function initDungeonPartyFinderRoomContentUpdateMessage(param1:uint = 0, param2:Vector.<DungeonPartyFinderPlayer> = null, param3:Vector.<uint> = null) : DungeonPartyFinderRoomContentUpdateMessage
      {
         this.dungeonId = param1;
         this.addedPlayers = param2;
         this.removedPlayersIds = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.dungeonId = 0;
         this.addedPlayers = new Vector.<DungeonPartyFinderPlayer>();
         this.removedPlayersIds = new Vector.<uint>();
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
         this.serializeAs_DungeonPartyFinderRoomContentUpdateMessage(param1);
      }
      
      public function serializeAs_DungeonPartyFinderRoomContentUpdateMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.dungeonId < 0)
         {
            throw new Error("Forbidden value (" + this.dungeonId + ") on element dungeonId.");
         }
         param1.writeVarShort(this.dungeonId);
         param1.writeShort(this.addedPlayers.length);
         while(_loc2_ < this.addedPlayers.length)
         {
            (this.addedPlayers[_loc2_] as DungeonPartyFinderPlayer).serializeAs_DungeonPartyFinderPlayer(param1);
            _loc2_++;
         }
         param1.writeShort(this.removedPlayersIds.length);
         while(_loc3_ < this.removedPlayersIds.length)
         {
            if(this.removedPlayersIds[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.removedPlayersIds[_loc3_] + ") on element 3 (starting at 1) of removedPlayersIds.");
            }
            param1.writeVarInt(this.removedPlayersIds[_loc3_]);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_DungeonPartyFinderRoomContentUpdateMessage(param1);
      }
      
      public function deserializeAs_DungeonPartyFinderRoomContentUpdateMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:DungeonPartyFinderPlayer = null;
         var _loc3_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         this.dungeonId = param1.readVarUhShort();
         if(this.dungeonId < 0)
         {
            throw new Error("Forbidden value (" + this.dungeonId + ") on element of DungeonPartyFinderRoomContentUpdateMessage.dungeonId.");
         }
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new DungeonPartyFinderPlayer();
            _loc2_.deserialize(param1);
            this.addedPlayers.push(_loc2_);
            _loc5_++;
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc3_ = param1.readVarUhInt();
            if(_loc3_ < 0)
            {
               throw new Error("Forbidden value (" + _loc3_ + ") on elements of removedPlayersIds.");
            }
            this.removedPlayersIds.push(_loc3_);
            _loc7_++;
         }
      }
   }
}
