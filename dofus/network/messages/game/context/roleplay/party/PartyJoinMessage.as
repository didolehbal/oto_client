package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.PartyGuestInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.PartyMemberInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   public class PartyJoinMessage extends AbstractPartyMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5576;
       
      
      private var _isInitialized:Boolean = false;
      
      public var partyType:uint = 0;
      
      public var partyLeaderId:uint = 0;
      
      public var maxParticipants:uint = 0;
      
      public var members:Vector.<PartyMemberInformations>;
      
      public var guests:Vector.<PartyGuestInformations>;
      
      public var restricted:Boolean = false;
      
      public var partyName:String = "";
      
      public function PartyJoinMessage()
      {
         this.members = new Vector.<PartyMemberInformations>();
         this.guests = new Vector.<PartyGuestInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5576;
      }
      
      public function initPartyJoinMessage(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:uint = 0, param5:Vector.<PartyMemberInformations> = null, param6:Vector.<PartyGuestInformations> = null, param7:Boolean = false, param8:String = "") : PartyJoinMessage
      {
         super.initAbstractPartyMessage(param1);
         this.partyType = param2;
         this.partyLeaderId = param3;
         this.maxParticipants = param4;
         this.members = param5;
         this.guests = param6;
         this.restricted = param7;
         this.partyName = param8;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.partyType = 0;
         this.partyLeaderId = 0;
         this.maxParticipants = 0;
         this.members = new Vector.<PartyMemberInformations>();
         this.guests = new Vector.<PartyGuestInformations>();
         this.restricted = false;
         this.partyName = "";
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
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_PartyJoinMessage(param1);
      }
      
      public function serializeAs_PartyJoinMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.serializeAs_AbstractPartyMessage(param1);
         param1.writeByte(this.partyType);
         if(this.partyLeaderId < 0)
         {
            throw new Error("Forbidden value (" + this.partyLeaderId + ") on element partyLeaderId.");
         }
         param1.writeVarInt(this.partyLeaderId);
         if(this.maxParticipants < 0)
         {
            throw new Error("Forbidden value (" + this.maxParticipants + ") on element maxParticipants.");
         }
         param1.writeByte(this.maxParticipants);
         param1.writeShort(this.members.length);
         while(_loc2_ < this.members.length)
         {
            param1.writeShort((this.members[_loc2_] as PartyMemberInformations).getTypeId());
            (this.members[_loc2_] as PartyMemberInformations).serialize(param1);
            _loc2_++;
         }
         param1.writeShort(this.guests.length);
         while(_loc3_ < this.guests.length)
         {
            (this.guests[_loc3_] as PartyGuestInformations).serializeAs_PartyGuestInformations(param1);
            _loc3_++;
         }
         param1.writeBoolean(this.restricted);
         param1.writeUTF(this.partyName);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PartyJoinMessage(param1);
      }
      
      public function deserializeAs_PartyJoinMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:PartyMemberInformations = null;
         var _loc4_:PartyGuestInformations = null;
         var _loc6_:uint = 0;
         var _loc8_:uint = 0;
         super.deserialize(param1);
         this.partyType = param1.readByte();
         if(this.partyType < 0)
         {
            throw new Error("Forbidden value (" + this.partyType + ") on element of PartyJoinMessage.partyType.");
         }
         this.partyLeaderId = param1.readVarUhInt();
         if(this.partyLeaderId < 0)
         {
            throw new Error("Forbidden value (" + this.partyLeaderId + ") on element of PartyJoinMessage.partyLeaderId.");
         }
         this.maxParticipants = param1.readByte();
         if(this.maxParticipants < 0)
         {
            throw new Error("Forbidden value (" + this.maxParticipants + ") on element of PartyJoinMessage.maxParticipants.");
         }
         var _loc5_:uint = param1.readUnsignedShort();
         while(_loc6_ < _loc5_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(PartyMemberInformations,_loc2_);
            _loc3_.deserialize(param1);
            this.members.push(_loc3_);
            _loc6_++;
         }
         var _loc7_:uint = param1.readUnsignedShort();
         while(_loc8_ < _loc7_)
         {
            (_loc4_ = new PartyGuestInformations()).deserialize(param1);
            this.guests.push(_loc4_);
            _loc8_++;
         }
         this.restricted = param1.readBoolean();
         this.partyName = param1.readUTF();
      }
   }
}
