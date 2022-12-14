package com.ankamagames.dofus.network.messages.game.atlas.compass
{
   import com.ankamagames.dofus.network.types.game.context.MapCoordinates;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class CompassUpdatePartyMemberMessage extends CompassUpdateMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5589;
       
      
      private var _isInitialized:Boolean = false;
      
      public var memberId:uint = 0;
      
      public function CompassUpdatePartyMemberMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5589;
      }
      
      public function initCompassUpdatePartyMemberMessage(param1:uint = 0, param2:MapCoordinates = null, param3:uint = 0) : CompassUpdatePartyMemberMessage
      {
         super.initCompassUpdateMessage(param1,param2);
         this.memberId = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.memberId = 0;
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
         this.serializeAs_CompassUpdatePartyMemberMessage(param1);
      }
      
      public function serializeAs_CompassUpdatePartyMemberMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_CompassUpdateMessage(param1);
         if(this.memberId < 0)
         {
            throw new Error("Forbidden value (" + this.memberId + ") on element memberId.");
         }
         param1.writeVarInt(this.memberId);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_CompassUpdatePartyMemberMessage(param1);
      }
      
      public function deserializeAs_CompassUpdatePartyMemberMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.memberId = param1.readVarUhInt();
         if(this.memberId < 0)
         {
            throw new Error("Forbidden value (" + this.memberId + ") on element of CompassUpdatePartyMemberMessage.memberId.");
         }
      }
   }
}
