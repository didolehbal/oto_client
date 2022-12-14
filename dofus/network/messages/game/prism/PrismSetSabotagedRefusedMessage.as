package com.ankamagames.dofus.network.messages.game.prism
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class PrismSetSabotagedRefusedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6466;
       
      
      private var _isInitialized:Boolean = false;
      
      public var subAreaId:uint = 0;
      
      public var reason:int = 0;
      
      public function PrismSetSabotagedRefusedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6466;
      }
      
      public function initPrismSetSabotagedRefusedMessage(param1:uint = 0, param2:int = 0) : PrismSetSabotagedRefusedMessage
      {
         this.subAreaId = param1;
         this.reason = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.subAreaId = 0;
         this.reason = 0;
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
         this.serializeAs_PrismSetSabotagedRefusedMessage(param1);
      }
      
      public function serializeAs_PrismSetSabotagedRefusedMessage(param1:ICustomDataOutput) : void
      {
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element subAreaId.");
         }
         param1.writeVarShort(this.subAreaId);
         param1.writeByte(this.reason);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PrismSetSabotagedRefusedMessage(param1);
      }
      
      public function deserializeAs_PrismSetSabotagedRefusedMessage(param1:ICustomDataInput) : void
      {
         this.subAreaId = param1.readVarUhShort();
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element of PrismSetSabotagedRefusedMessage.subAreaId.");
         }
         this.reason = param1.readByte();
      }
   }
}
