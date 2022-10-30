package com.ankamagames.dofus.network.messages.game.chat.channel
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class EnabledChannelsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 892;
       
      
      private var _isInitialized:Boolean = false;
      
      public var channels:Vector.<uint>;
      
      public var disallowed:Vector.<uint>;
      
      public function EnabledChannelsMessage()
      {
         this.channels = new Vector.<uint>();
         this.disallowed = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 892;
      }
      
      public function initEnabledChannelsMessage(param1:Vector.<uint> = null, param2:Vector.<uint> = null) : EnabledChannelsMessage
      {
         this.channels = param1;
         this.disallowed = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.channels = new Vector.<uint>();
         this.disallowed = new Vector.<uint>();
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
         this.serializeAs_EnabledChannelsMessage(param1);
      }
      
      public function serializeAs_EnabledChannelsMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         param1.writeShort(this.channels.length);
         while(_loc2_ < this.channels.length)
         {
            param1.writeByte(this.channels[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.disallowed.length);
         while(_loc3_ < this.disallowed.length)
         {
            param1.writeByte(this.disallowed[_loc3_]);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_EnabledChannelsMessage(param1);
      }
      
      public function deserializeAs_EnabledChannelsMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readByte();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of channels.");
            }
            this.channels.push(_loc2_);
            _loc5_++;
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc3_ = param1.readByte();
            if(_loc3_ < 0)
            {
               throw new Error("Forbidden value (" + _loc3_ + ") on elements of disallowed.");
            }
            this.disallowed.push(_loc3_);
            _loc7_++;
         }
      }
   }
}
