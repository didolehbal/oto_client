package com.ankamagames.dofus.network.messages.game.context.roleplay.emote
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class EmotePlayMessage extends EmotePlayAbstractMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5683;
       
      
      private var _isInitialized:Boolean = false;
      
      public var actorId:int = 0;
      
      public var accountId:uint = 0;
      
      public function EmotePlayMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5683;
      }
      
      public function initEmotePlayMessage(param1:uint = 0, param2:Number = 0, param3:int = 0, param4:uint = 0) : EmotePlayMessage
      {
         super.initEmotePlayAbstractMessage(param1,param2);
         this.actorId = param3;
         this.accountId = param4;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.actorId = 0;
         this.accountId = 0;
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
         this.serializeAs_EmotePlayMessage(param1);
      }
      
      public function serializeAs_EmotePlayMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_EmotePlayAbstractMessage(param1);
         param1.writeInt(this.actorId);
         if(this.accountId < 0)
         {
            throw new Error("Forbidden value (" + this.accountId + ") on element accountId.");
         }
         param1.writeInt(this.accountId);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_EmotePlayMessage(param1);
      }
      
      public function deserializeAs_EmotePlayMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.actorId = param1.readInt();
         this.accountId = param1.readInt();
         if(this.accountId < 0)
         {
            throw new Error("Forbidden value (" + this.accountId + ") on element of EmotePlayMessage.accountId.");
         }
      }
   }
}
