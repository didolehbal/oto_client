package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.mount.MountClientData;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeStartOkMountWithOutPaddockMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5991;
       
      
      private var _isInitialized:Boolean = false;
      
      public var stabledMountsDescription:Vector.<MountClientData>;
      
      public function ExchangeStartOkMountWithOutPaddockMessage()
      {
         this.stabledMountsDescription = new Vector.<MountClientData>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5991;
      }
      
      public function initExchangeStartOkMountWithOutPaddockMessage(param1:Vector.<MountClientData> = null) : ExchangeStartOkMountWithOutPaddockMessage
      {
         this.stabledMountsDescription = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.stabledMountsDescription = new Vector.<MountClientData>();
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
         this.serializeAs_ExchangeStartOkMountWithOutPaddockMessage(param1);
      }
      
      public function serializeAs_ExchangeStartOkMountWithOutPaddockMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.stabledMountsDescription.length);
         while(_loc2_ < this.stabledMountsDescription.length)
         {
            (this.stabledMountsDescription[_loc2_] as MountClientData).serializeAs_MountClientData(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeStartOkMountWithOutPaddockMessage(param1);
      }
      
      public function deserializeAs_ExchangeStartOkMountWithOutPaddockMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:MountClientData = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new MountClientData();
            _loc2_.deserialize(param1);
            this.stabledMountsDescription.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
