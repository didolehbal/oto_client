package com.ankamagames.dofus.network.messages.game.context.roleplay.houses
{
   import com.ankamagames.dofus.network.types.game.house.HouseInformationsForSell;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class HouseToSellListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6140;
       
      
      private var _isInitialized:Boolean = false;
      
      public var pageIndex:uint = 0;
      
      public var totalPage:uint = 0;
      
      public var houseList:Vector.<HouseInformationsForSell>;
      
      public function HouseToSellListMessage()
      {
         this.houseList = new Vector.<HouseInformationsForSell>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6140;
      }
      
      public function initHouseToSellListMessage(param1:uint = 0, param2:uint = 0, param3:Vector.<HouseInformationsForSell> = null) : HouseToSellListMessage
      {
         this.pageIndex = param1;
         this.totalPage = param2;
         this.houseList = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.pageIndex = 0;
         this.totalPage = 0;
         this.houseList = new Vector.<HouseInformationsForSell>();
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
         this.serializeAs_HouseToSellListMessage(param1);
      }
      
      public function serializeAs_HouseToSellListMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         if(this.pageIndex < 0)
         {
            throw new Error("Forbidden value (" + this.pageIndex + ") on element pageIndex.");
         }
         param1.writeVarShort(this.pageIndex);
         if(this.totalPage < 0)
         {
            throw new Error("Forbidden value (" + this.totalPage + ") on element totalPage.");
         }
         param1.writeVarShort(this.totalPage);
         param1.writeShort(this.houseList.length);
         while(_loc2_ < this.houseList.length)
         {
            (this.houseList[_loc2_] as HouseInformationsForSell).serializeAs_HouseInformationsForSell(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_HouseToSellListMessage(param1);
      }
      
      public function deserializeAs_HouseToSellListMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:HouseInformationsForSell = null;
         var _loc4_:uint = 0;
         this.pageIndex = param1.readVarUhShort();
         if(this.pageIndex < 0)
         {
            throw new Error("Forbidden value (" + this.pageIndex + ") on element of HouseToSellListMessage.pageIndex.");
         }
         this.totalPage = param1.readVarUhShort();
         if(this.totalPage < 0)
         {
            throw new Error("Forbidden value (" + this.totalPage + ") on element of HouseToSellListMessage.totalPage.");
         }
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new HouseInformationsForSell();
            _loc2_.deserialize(param1);
            this.houseList.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
