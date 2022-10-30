package com.ankamagames.dofus.network.messages.game.basic
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class BasicLatencyStatsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5663;
       
      
      private var _isInitialized:Boolean = false;
      
      public var latency:uint = 0;
      
      public var sampleCount:uint = 0;
      
      public var max:uint = 0;
      
      public function BasicLatencyStatsMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5663;
      }
      
      public function initBasicLatencyStatsMessage(param1:uint = 0, param2:uint = 0, param3:uint = 0) : BasicLatencyStatsMessage
      {
         this.latency = param1;
         this.sampleCount = param2;
         this.max = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.latency = 0;
         this.sampleCount = 0;
         this.max = 0;
         this._isInitialized = false;
      }
      
      override public function pack(param1:ICustomDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(new CustomDataWrapper(_loc2_));
         if(HASH_FUNCTION != null)
         {
            HASH_FUNCTION(_loc2_);
         }
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:ICustomDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_BasicLatencyStatsMessage(param1);
      }
      
      public function serializeAs_BasicLatencyStatsMessage(param1:ICustomDataOutput) : void
      {
         if(this.latency < 0 || this.latency > 65535)
         {
            throw new Error("Forbidden value (" + this.latency + ") on element latency.");
         }
         param1.writeShort(this.latency);
         if(this.sampleCount < 0)
         {
            throw new Error("Forbidden value (" + this.sampleCount + ") on element sampleCount.");
         }
         param1.writeVarShort(this.sampleCount);
         if(this.max < 0)
         {
            throw new Error("Forbidden value (" + this.max + ") on element max.");
         }
         param1.writeVarShort(this.max);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_BasicLatencyStatsMessage(param1);
      }
      
      public function deserializeAs_BasicLatencyStatsMessage(param1:ICustomDataInput) : void
      {
         this.latency = param1.readUnsignedShort();
         if(this.latency < 0 || this.latency > 65535)
         {
            throw new Error("Forbidden value (" + this.latency + ") on element of BasicLatencyStatsMessage.latency.");
         }
         this.sampleCount = param1.readVarUhShort();
         if(this.sampleCount < 0)
         {
            throw new Error("Forbidden value (" + this.sampleCount + ") on element of BasicLatencyStatsMessage.sampleCount.");
         }
         this.max = param1.readVarUhShort();
         if(this.max < 0)
         {
            throw new Error("Forbidden value (" + this.max + ") on element of BasicLatencyStatsMessage.max.");
         }
      }
   }
}
