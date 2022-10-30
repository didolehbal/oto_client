package com.ankamagames.dofus.network.messages.game.approach
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class HelloGameMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 101;
       
      
      private var _isInitialized:Boolean = false;
      
      public var encryptionKey:Vector.<int>;
      
      public function HelloGameMessage()
      {
         this.encryptionKey = new Vector.<int>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 101;
      }
      
      public function initHelloGameMessage(param1:Vector.<int> = null) : HelloGameMessage
      {
         this.encryptionKey = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.encryptionKey = new Vector.<int>();
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
         this.serializeAs_HelloGameMessage(param1);
      }
      
      public function serializeAs_HelloGameMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeVarInt(this.encryptionKey.length);
         _loc2_ = 0;
         while(_loc2_ < this.encryptionKey.length)
         {
            param1.writeByte(this.encryptionKey[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_HelloGameMessage(param1);
      }
      
      public function deserializeAs_HelloGameMessage(param1:ICustomDataInput) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = param1.readVarInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = param1.readUnsignedByte();
            this.encryptionKey.push(_loc3_);
            _loc4_++;
         }
      }
   }
}
