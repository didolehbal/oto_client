package com.ankamagames.dofus.network.messages.game.basic
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class TextInformationMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 780;
       
      
      private var _isInitialized:Boolean = false;
      
      public var msgType:uint = 0;
      
      public var msgId:uint = 0;
      
      public var parameters:Vector.<String>;
      
      public function TextInformationMessage()
      {
         this.parameters = new Vector.<String>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 780;
      }
      
      public function initTextInformationMessage(param1:uint = 0, param2:uint = 0, param3:Vector.<String> = null) : TextInformationMessage
      {
         this.msgType = param1;
         this.msgId = param2;
         this.parameters = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.msgType = 0;
         this.msgId = 0;
         this.parameters = new Vector.<String>();
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
         this.serializeAs_TextInformationMessage(param1);
      }
      
      public function serializeAs_TextInformationMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeByte(this.msgType);
         if(this.msgId < 0)
         {
            throw new Error("Forbidden value (" + this.msgId + ") on element msgId.");
         }
         param1.writeVarShort(this.msgId);
         param1.writeShort(this.parameters.length);
         while(_loc2_ < this.parameters.length)
         {
            param1.writeUTF(this.parameters[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_TextInformationMessage(param1);
      }
      
      public function deserializeAs_TextInformationMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:String = null;
         var _loc4_:uint = 0;
         this.msgType = param1.readByte();
         if(this.msgType < 0)
         {
            throw new Error("Forbidden value (" + this.msgType + ") on element of TextInformationMessage.msgType.");
         }
         this.msgId = param1.readVarUhShort();
         if(this.msgId < 0)
         {
            throw new Error("Forbidden value (" + this.msgId + ") on element of TextInformationMessage.msgId.");
         }
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readUTF();
            this.parameters.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
