package com.ankamagames.dofus.network.messages.game.dialog
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class PauseDialogMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6012;
       
      
      private var _isInitialized:Boolean = false;
      
      public var dialogType:uint = 0;
      
      public function PauseDialogMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6012;
      }
      
      public function initPauseDialogMessage(param1:uint = 0) : PauseDialogMessage
      {
         this.dialogType = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.dialogType = 0;
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
         this.serializeAs_PauseDialogMessage(param1);
      }
      
      public function serializeAs_PauseDialogMessage(param1:ICustomDataOutput) : void
      {
         param1.writeByte(this.dialogType);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PauseDialogMessage(param1);
      }
      
      public function deserializeAs_PauseDialogMessage(param1:ICustomDataInput) : void
      {
         this.dialogType = param1.readByte();
         if(this.dialogType < 0)
         {
            throw new Error("Forbidden value (" + this.dialogType + ") on element of PauseDialogMessage.dialogType.");
         }
      }
   }
}
