package com.ankamagames.dofus.network.messages.updater.parts
{
   import com.ankamagames.dofus.network.types.updater.ContentPart;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class PartsListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 1502;
       
      
      private var _isInitialized:Boolean = false;
      
      public var parts:Vector.<ContentPart>;
      
      public function PartsListMessage()
      {
         this.parts = new Vector.<ContentPart>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 1502;
      }
      
      public function initPartsListMessage(param1:Vector.<ContentPart> = null) : PartsListMessage
      {
         this.parts = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.parts = new Vector.<ContentPart>();
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
         this.serializeAs_PartsListMessage(param1);
      }
      
      public function serializeAs_PartsListMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.parts.length);
         while(_loc2_ < this.parts.length)
         {
            (this.parts[_loc2_] as ContentPart).serializeAs_ContentPart(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PartsListMessage(param1);
      }
      
      public function deserializeAs_PartsListMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:ContentPart = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new ContentPart();
            _loc2_.deserialize(param1);
            this.parts.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
