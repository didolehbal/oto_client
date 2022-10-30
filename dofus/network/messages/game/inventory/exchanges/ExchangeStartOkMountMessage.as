package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.mount.MountClientData;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeStartOkMountMessage extends ExchangeStartOkMountWithOutPaddockMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5979;
       
      
      private var _isInitialized:Boolean = false;
      
      public var paddockedMountsDescription:Vector.<MountClientData>;
      
      public function ExchangeStartOkMountMessage()
      {
         this.paddockedMountsDescription = new Vector.<MountClientData>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5979;
      }
      
      public function initExchangeStartOkMountMessage(param1:Vector.<MountClientData> = null, param2:Vector.<MountClientData> = null) : ExchangeStartOkMountMessage
      {
         super.initExchangeStartOkMountWithOutPaddockMessage(param1);
         this.paddockedMountsDescription = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.paddockedMountsDescription = new Vector.<MountClientData>();
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
         this.serializeAs_ExchangeStartOkMountMessage(param1);
      }
      
      public function serializeAs_ExchangeStartOkMountMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_ExchangeStartOkMountWithOutPaddockMessage(param1);
         param1.writeShort(this.paddockedMountsDescription.length);
         while(_loc2_ < this.paddockedMountsDescription.length)
         {
            (this.paddockedMountsDescription[_loc2_] as MountClientData).serializeAs_MountClientData(param1);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeStartOkMountMessage(param1);
      }
      
      public function deserializeAs_ExchangeStartOkMountMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:MountClientData = null;
         var _loc4_:uint = 0;
         super.deserialize(param1);
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new MountClientData();
            _loc2_.deserialize(param1);
            this.paddockedMountsDescription.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
