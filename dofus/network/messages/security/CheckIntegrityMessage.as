package com.ankamagames.dofus.network.messages.security
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class CheckIntegrityMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6372;
       
      
      private var _isInitialized:Boolean = false;
      
      public var data:Vector.<int>;
      
      public function CheckIntegrityMessage()
      {
         this.data = new Vector.<int>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6372;
      }
      
      public function initCheckIntegrityMessage(param1:Vector.<int> = null) : CheckIntegrityMessage
      {
         this.data = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.data = new Vector.<int>();
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
         this.serializeAs_CheckIntegrityMessage(param1);
      }
      
      public function serializeAs_CheckIntegrityMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeVarInt(this.data.length);
         while(_loc2_ < this.data.length)
         {
            param1.writeByte(this.data[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_CheckIntegrityMessage(param1);
      }
      
      public function deserializeAs_CheckIntegrityMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readVarInt();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readByte();
            this.data.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
