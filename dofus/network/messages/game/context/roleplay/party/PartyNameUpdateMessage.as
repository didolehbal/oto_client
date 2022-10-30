package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class PartyNameUpdateMessage extends AbstractPartyMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6502;
       
      
      private var _isInitialized:Boolean = false;
      
      public var partyName:String = "";
      
      public function PartyNameUpdateMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6502;
      }
      
      public function initPartyNameUpdateMessage(param1:uint = 0, param2:String = "") : PartyNameUpdateMessage
      {
         super.initAbstractPartyMessage(param1);
         this.partyName = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
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
         this.serializeAs_PartyNameUpdateMessage(param1);
      }
      
      public function serializeAs_PartyNameUpdateMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_AbstractPartyMessage(param1);
         param1.writeUTF(this.partyName);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PartyNameUpdateMessage(param1);
      }
      
      public function deserializeAs_PartyNameUpdateMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.partyName = param1.readUTF();
      }
   }
}
