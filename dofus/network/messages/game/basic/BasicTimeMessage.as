package com.ankamagames.dofus.network.messages.game.basic
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class BasicTimeMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 175;
       
      
      private var _isInitialized:Boolean = false;
      
      public var timestamp:Number = 0;
      
      public var timezoneOffset:int = 0;
      
      public function BasicTimeMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 175;
      }
      
      public function initBasicTimeMessage(param1:Number = 0, param2:int = 0) : BasicTimeMessage
      {
         this.timestamp = param1;
         this.timezoneOffset = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.timestamp = 0;
         this.timezoneOffset = 0;
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
         this.serializeAs_BasicTimeMessage(param1);
      }
      
      public function serializeAs_BasicTimeMessage(param1:ICustomDataOutput) : void
      {
         if(this.timestamp < 0 || this.timestamp > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.timestamp + ") on element timestamp.");
         }
         param1.writeDouble(this.timestamp);
         param1.writeShort(this.timezoneOffset);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_BasicTimeMessage(param1);
      }
      
      public function deserializeAs_BasicTimeMessage(param1:ICustomDataInput) : void
      {
         this.timestamp = param1.readDouble();
         if(this.timestamp < 0 || this.timestamp > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.timestamp + ") on element of BasicTimeMessage.timestamp.");
         }
         this.timezoneOffset = param1.readShort();
      }
   }
}
