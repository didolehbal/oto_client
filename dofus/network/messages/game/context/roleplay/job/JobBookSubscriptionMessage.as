package com.ankamagames.dofus.network.messages.game.context.roleplay.job
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class JobBookSubscriptionMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6593;
       
      
      private var _isInitialized:Boolean = false;
      
      public var addedOrDeleted:Boolean = false;
      
      public var jobId:uint = 0;
      
      public function JobBookSubscriptionMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6593;
      }
      
      public function initJobBookSubscriptionMessage(param1:Boolean = false, param2:uint = 0) : JobBookSubscriptionMessage
      {
         this.addedOrDeleted = param1;
         this.jobId = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.addedOrDeleted = false;
         this.jobId = 0;
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
         this.serializeAs_JobBookSubscriptionMessage(param1);
      }
      
      public function serializeAs_JobBookSubscriptionMessage(param1:ICustomDataOutput) : void
      {
         param1.writeBoolean(this.addedOrDeleted);
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element jobId.");
         }
         param1.writeByte(this.jobId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_JobBookSubscriptionMessage(param1);
      }
      
      public function deserializeAs_JobBookSubscriptionMessage(param1:ICustomDataInput) : void
      {
         this.addedOrDeleted = param1.readBoolean();
         this.jobId = param1.readByte();
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element of JobBookSubscriptionMessage.jobId.");
         }
      }
   }
}
