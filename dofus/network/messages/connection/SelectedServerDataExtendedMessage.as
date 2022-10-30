package com.ankamagames.dofus.network.messages.connection
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class SelectedServerDataExtendedMessage extends SelectedServerDataMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6469;
       
      
      private var _isInitialized:Boolean = false;
      
      public var serverIds:Vector.<uint>;
      
      public function SelectedServerDataExtendedMessage()
      {
         this.serverIds = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6469;
      }
      
      public function initSelectedServerDataExtendedMessage(param1:uint = 0, param2:String = "", param3:uint = 0, param4:uint = 0, param5:Boolean = false, param6:Vector.<int> = null, param7:Vector.<uint> = null) : SelectedServerDataExtendedMessage
      {
         super.initSelectedServerDataMessage(param1,param2,param3,param4,param5,param6);
         this.serverIds = param7;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.serverIds = new Vector.<uint>();
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
         this.serializeAs_SelectedServerDataExtendedMessage(param1);
      }
      
      public function serializeAs_SelectedServerDataExtendedMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_SelectedServerDataMessage(param1);
         param1.writeShort(this.serverIds.length);
         while(_loc2_ < this.serverIds.length)
         {
            if(this.serverIds[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.serverIds[_loc2_] + ") on element 1 (starting at 1) of serverIds.");
            }
            param1.writeVarShort(this.serverIds[_loc2_]);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_SelectedServerDataExtendedMessage(param1);
      }
      
      public function deserializeAs_SelectedServerDataExtendedMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         super.deserialize(param1);
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readVarUhShort();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of serverIds.");
            }
            this.serverIds.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
