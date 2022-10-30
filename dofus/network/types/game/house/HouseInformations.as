package com.ankamagames.dofus.network.types.game.house
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.jerakine.network.utils.BooleanByteWrapper;
   
   public class HouseInformations implements INetworkType
   {
      
      public static const protocolId:uint = 111;
       
      
      public var houseId:uint = 0;
      
      public var doorsOnMap:Vector.<uint>;
      
      public var ownerName:String = "";
      
      public var isOnSale:Boolean = false;
      
      public var isSaleLocked:Boolean = false;
      
      public var modelId:uint = 0;
      
      public function HouseInformations()
      {
         this.doorsOnMap = new Vector.<uint>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 111;
      }
      
      public function initHouseInformations(param1:uint = 0, param2:Vector.<uint> = null, param3:String = "", param4:Boolean = false, param5:Boolean = false, param6:uint = 0) : HouseInformations
      {
         this.houseId = param1;
         this.doorsOnMap = param2;
         this.ownerName = param3;
         this.isOnSale = param4;
         this.isSaleLocked = param5;
         this.modelId = param6;
         return this;
      }
      
      public function reset() : void
      {
         this.houseId = 0;
         this.doorsOnMap = new Vector.<uint>();
         this.ownerName = "";
         this.isOnSale = false;
         this.isSaleLocked = false;
         this.modelId = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_HouseInformations(param1);
      }
      
      public function serializeAs_HouseInformations(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,0,this.isOnSale);
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,1,this.isSaleLocked);
         param1.writeByte(_loc2_);
         if(this.houseId < 0)
         {
            throw new Error("Forbidden value (" + this.houseId + ") on element houseId.");
         }
         param1.writeVarInt(this.houseId);
         param1.writeShort(this.doorsOnMap.length);
         while(_loc3_ < this.doorsOnMap.length)
         {
            if(this.doorsOnMap[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.doorsOnMap[_loc3_] + ") on element 2 (starting at 1) of doorsOnMap.");
            }
            param1.writeInt(this.doorsOnMap[_loc3_]);
            _loc3_++;
         }
         param1.writeUTF(this.ownerName);
         if(this.modelId < 0)
         {
            throw new Error("Forbidden value (" + this.modelId + ") on element modelId.");
         }
         param1.writeVarShort(this.modelId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_HouseInformations(param1);
      }
      
      public function deserializeAs_HouseInformations(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc5_:uint = 0;
         var _loc3_:uint = param1.readByte();
         this.isOnSale = BooleanByteWrapper.getFlag(_loc3_,0);
         this.isSaleLocked = BooleanByteWrapper.getFlag(_loc3_,1);
         this.houseId = param1.readVarUhInt();
         if(this.houseId < 0)
         {
            throw new Error("Forbidden value (" + this.houseId + ") on element of HouseInformations.houseId.");
         }
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readInt();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of doorsOnMap.");
            }
            this.doorsOnMap.push(_loc2_);
            _loc5_++;
         }
         this.ownerName = param1.readUTF();
         this.modelId = param1.readVarUhShort();
         if(this.modelId < 0)
         {
            throw new Error("Forbidden value (" + this.modelId + ") on element of HouseInformations.modelId.");
         }
      }
   }
}
