package com.ankamagames.dofus.network.messages.game.context.roleplay.emote
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class EmotePlayAbstractMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5690;
       
      
      private var _isInitialized:Boolean = false;
      
      public var emoteId:uint = 0;
      
      public var emoteStartTime:Number = 0;
      
      public function EmotePlayAbstractMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5690;
      }
      
      public function initEmotePlayAbstractMessage(param1:uint = 0, param2:Number = 0) : EmotePlayAbstractMessage
      {
         this.emoteId = param1;
         this.emoteStartTime = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.emoteId = 0;
         this.emoteStartTime = 0;
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
         this.serializeAs_EmotePlayAbstractMessage(param1);
      }
      
      public function serializeAs_EmotePlayAbstractMessage(param1:ICustomDataOutput) : void
      {
         if(this.emoteId < 0 || this.emoteId > 255)
         {
            throw new Error("Forbidden value (" + this.emoteId + ") on element emoteId.");
         }
         param1.writeByte(this.emoteId);
         if(this.emoteStartTime < -9007199254740992 || this.emoteStartTime > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.emoteStartTime + ") on element emoteStartTime.");
         }
         param1.writeDouble(this.emoteStartTime);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_EmotePlayAbstractMessage(param1);
      }
      
      public function deserializeAs_EmotePlayAbstractMessage(param1:ICustomDataInput) : void
      {
         this.emoteId = param1.readUnsignedByte();
         if(this.emoteId < 0 || this.emoteId > 255)
         {
            throw new Error("Forbidden value (" + this.emoteId + ") on element of EmotePlayAbstractMessage.emoteId.");
         }
         this.emoteStartTime = param1.readDouble();
         if(this.emoteStartTime < -9007199254740992 || this.emoteStartTime > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.emoteStartTime + ") on element of EmotePlayAbstractMessage.emoteStartTime.");
         }
      }
   }
}
