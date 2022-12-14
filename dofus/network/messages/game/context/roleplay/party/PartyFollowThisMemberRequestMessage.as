package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class PartyFollowThisMemberRequestMessage extends PartyFollowMemberRequestMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5588;
       
      
      private var _isInitialized:Boolean = false;
      
      public var enabled:Boolean = false;
      
      public function PartyFollowThisMemberRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5588;
      }
      
      public function initPartyFollowThisMemberRequestMessage(param1:uint = 0, param2:uint = 0, param3:Boolean = false) : PartyFollowThisMemberRequestMessage
      {
         super.initPartyFollowMemberRequestMessage(param1,param2);
         this.enabled = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.enabled = false;
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
         this.serializeAs_PartyFollowThisMemberRequestMessage(param1);
      }
      
      public function serializeAs_PartyFollowThisMemberRequestMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_PartyFollowMemberRequestMessage(param1);
         param1.writeBoolean(this.enabled);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PartyFollowThisMemberRequestMessage(param1);
      }
      
      public function deserializeAs_PartyFollowThisMemberRequestMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.enabled = param1.readBoolean();
      }
   }
}
