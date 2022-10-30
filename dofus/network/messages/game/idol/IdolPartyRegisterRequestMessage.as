package com.ankamagames.dofus.network.messages.game.idol
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class IdolPartyRegisterRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6582;
       
      
      private var _isInitialized:Boolean = false;
      
      public var register:Boolean = false;
      
      public function IdolPartyRegisterRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6582;
      }
      
      public function initIdolPartyRegisterRequestMessage(param1:Boolean = false) : IdolPartyRegisterRequestMessage
      {
         this.register = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.register = false;
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
         this.serializeAs_IdolPartyRegisterRequestMessage(param1);
      }
      
      public function serializeAs_IdolPartyRegisterRequestMessage(param1:ICustomDataOutput) : void
      {
         param1.writeBoolean(this.register);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_IdolPartyRegisterRequestMessage(param1);
      }
      
      public function deserializeAs_IdolPartyRegisterRequestMessage(param1:ICustomDataInput) : void
      {
         this.register = param1.readBoolean();
      }
   }
}
