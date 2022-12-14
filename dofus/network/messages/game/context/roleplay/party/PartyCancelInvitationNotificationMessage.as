package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class PartyCancelInvitationNotificationMessage extends AbstractPartyEventMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6251;
       
      
      private var _isInitialized:Boolean = false;
      
      public var cancelerId:uint = 0;
      
      public var guestId:uint = 0;
      
      public function PartyCancelInvitationNotificationMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6251;
      }
      
      public function initPartyCancelInvitationNotificationMessage(param1:uint = 0, param2:uint = 0, param3:uint = 0) : PartyCancelInvitationNotificationMessage
      {
         super.initAbstractPartyEventMessage(param1);
         this.cancelerId = param2;
         this.guestId = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.cancelerId = 0;
         this.guestId = 0;
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
         this.serializeAs_PartyCancelInvitationNotificationMessage(param1);
      }
      
      public function serializeAs_PartyCancelInvitationNotificationMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_AbstractPartyEventMessage(param1);
         if(this.cancelerId < 0)
         {
            throw new Error("Forbidden value (" + this.cancelerId + ") on element cancelerId.");
         }
         param1.writeVarInt(this.cancelerId);
         if(this.guestId < 0)
         {
            throw new Error("Forbidden value (" + this.guestId + ") on element guestId.");
         }
         param1.writeVarInt(this.guestId);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PartyCancelInvitationNotificationMessage(param1);
      }
      
      public function deserializeAs_PartyCancelInvitationNotificationMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.cancelerId = param1.readVarUhInt();
         if(this.cancelerId < 0)
         {
            throw new Error("Forbidden value (" + this.cancelerId + ") on element of PartyCancelInvitationNotificationMessage.cancelerId.");
         }
         this.guestId = param1.readVarUhInt();
         if(this.guestId < 0)
         {
            throw new Error("Forbidden value (" + this.guestId + ") on element of PartyCancelInvitationNotificationMessage.guestId.");
         }
      }
   }
}
