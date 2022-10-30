package com.ankamagames.dofus.network.messages.game.context.roleplay.npc
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.GameRolePlayNpcQuestFlag;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class MapNpcsQuestStatusUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5642;
       
      
      private var _isInitialized:Boolean = false;
      
      public var mapId:int = 0;
      
      public var npcsIdsWithQuest:Vector.<int>;
      
      public var questFlags:Vector.<GameRolePlayNpcQuestFlag>;
      
      public var npcsIdsWithoutQuest:Vector.<int>;
      
      public function MapNpcsQuestStatusUpdateMessage()
      {
         this.npcsIdsWithQuest = new Vector.<int>();
         this.questFlags = new Vector.<GameRolePlayNpcQuestFlag>();
         this.npcsIdsWithoutQuest = new Vector.<int>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5642;
      }
      
      public function initMapNpcsQuestStatusUpdateMessage(param1:int = 0, param2:Vector.<int> = null, param3:Vector.<GameRolePlayNpcQuestFlag> = null, param4:Vector.<int> = null) : MapNpcsQuestStatusUpdateMessage
      {
         this.mapId = param1;
         this.npcsIdsWithQuest = param2;
         this.questFlags = param3;
         this.npcsIdsWithoutQuest = param4;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.mapId = 0;
         this.npcsIdsWithQuest = new Vector.<int>();
         this.questFlags = new Vector.<GameRolePlayNpcQuestFlag>();
         this.npcsIdsWithoutQuest = new Vector.<int>();
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
         this.serializeAs_MapNpcsQuestStatusUpdateMessage(param1);
      }
      
      public function serializeAs_MapNpcsQuestStatusUpdateMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         param1.writeInt(this.mapId);
         param1.writeShort(this.npcsIdsWithQuest.length);
         while(_loc2_ < this.npcsIdsWithQuest.length)
         {
            param1.writeInt(this.npcsIdsWithQuest[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.questFlags.length);
         while(_loc3_ < this.questFlags.length)
         {
            (this.questFlags[_loc3_] as GameRolePlayNpcQuestFlag).serializeAs_GameRolePlayNpcQuestFlag(param1);
            _loc3_++;
         }
         param1.writeShort(this.npcsIdsWithoutQuest.length);
         while(_loc4_ < this.npcsIdsWithoutQuest.length)
         {
            param1.writeInt(this.npcsIdsWithoutQuest[_loc4_]);
            _loc4_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_MapNpcsQuestStatusUpdateMessage(param1);
      }
      
      public function deserializeAs_MapNpcsQuestStatusUpdateMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GameRolePlayNpcQuestFlag = null;
         var _loc4_:int = 0;
         var _loc6_:uint = 0;
         var _loc8_:uint = 0;
         var _loc10_:uint = 0;
         this.mapId = param1.readInt();
         var _loc5_:uint = param1.readUnsignedShort();
         while(_loc6_ < _loc5_)
         {
            _loc2_ = param1.readInt();
            this.npcsIdsWithQuest.push(_loc2_);
            _loc6_++;
         }
         var _loc7_:uint = param1.readUnsignedShort();
         while(_loc8_ < _loc7_)
         {
            _loc3_ = new GameRolePlayNpcQuestFlag();
            _loc3_.deserialize(param1);
            this.questFlags.push(_loc3_);
            _loc8_++;
         }
         var _loc9_:uint = param1.readUnsignedShort();
         while(_loc10_ < _loc9_)
         {
            _loc4_ = param1.readInt();
            this.npcsIdsWithoutQuest.push(_loc4_);
            _loc10_++;
         }
      }
   }
}
