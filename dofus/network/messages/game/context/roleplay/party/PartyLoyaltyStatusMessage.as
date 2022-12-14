package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class PartyLoyaltyStatusMessage extends AbstractPartyMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6270;
       
      
      private var _isInitialized:Boolean = false;
      
      public var loyal:Boolean = false;
      
      public function PartyLoyaltyStatusMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6270;
      }
      
      public function initPartyLoyaltyStatusMessage(param1:uint = 0, param2:Boolean = false) : PartyLoyaltyStatusMessage
      {
         super.initAbstractPartyMessage(param1);
         this.loyal = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.loyal = false;
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
         this.serializeAs_PartyLoyaltyStatusMessage(param1);
      }
      
      public function serializeAs_PartyLoyaltyStatusMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_AbstractPartyMessage(param1);
         param1.writeBoolean(this.loyal);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PartyLoyaltyStatusMessage(param1);
      }
      
      public function deserializeAs_PartyLoyaltyStatusMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.loyal = param1.readBoolean();
      }
   }
}
