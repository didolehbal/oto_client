package com.ankamagames.dofus.network.messages.updater.parts
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class DownloadSetSpeedRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 1512;
       
      
      private var _isInitialized:Boolean = false;
      
      public var downloadSpeed:uint = 0;
      
      public function DownloadSetSpeedRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 1512;
      }
      
      public function initDownloadSetSpeedRequestMessage(param1:uint = 0) : DownloadSetSpeedRequestMessage
      {
         this.downloadSpeed = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.downloadSpeed = 0;
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
         this.serializeAs_DownloadSetSpeedRequestMessage(param1);
      }
      
      public function serializeAs_DownloadSetSpeedRequestMessage(param1:ICustomDataOutput) : void
      {
         if(this.downloadSpeed < 1 || this.downloadSpeed > 10)
         {
            throw new Error("Forbidden value (" + this.downloadSpeed + ") on element downloadSpeed.");
         }
         param1.writeByte(this.downloadSpeed);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_DownloadSetSpeedRequestMessage(param1);
      }
      
      public function deserializeAs_DownloadSetSpeedRequestMessage(param1:ICustomDataInput) : void
      {
         this.downloadSpeed = param1.readByte();
         if(this.downloadSpeed < 1 || this.downloadSpeed > 10)
         {
            throw new Error("Forbidden value (" + this.downloadSpeed + ") on element of DownloadSetSpeedRequestMessage.downloadSpeed.");
         }
      }
   }
}
