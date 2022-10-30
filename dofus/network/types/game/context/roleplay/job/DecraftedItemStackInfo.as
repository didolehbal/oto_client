package com.ankamagames.dofus.network.types.game.context.roleplay.job
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class DecraftedItemStackInfo implements INetworkType
   {
      
      public static const protocolId:uint = 481;
       
      
      public var objectUID:uint = 0;
      
      public var bonusMin:Number = 0;
      
      public var bonusMax:Number = 0;
      
      public var runesId:Vector.<uint>;
      
      public var runesQty:Vector.<uint>;
      
      public function DecraftedItemStackInfo()
      {
         this.runesId = new Vector.<uint>();
         this.runesQty = new Vector.<uint>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 481;
      }
      
      public function initDecraftedItemStackInfo(param1:uint = 0, param2:Number = 0, param3:Number = 0, param4:Vector.<uint> = null, param5:Vector.<uint> = null) : DecraftedItemStackInfo
      {
         this.objectUID = param1;
         this.bonusMin = param2;
         this.bonusMax = param3;
         this.runesId = param4;
         this.runesQty = param5;
         return this;
      }
      
      public function reset() : void
      {
         this.objectUID = 0;
         this.bonusMin = 0;
         this.bonusMax = 0;
         this.runesId = new Vector.<uint>();
         this.runesQty = new Vector.<uint>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_DecraftedItemStackInfo(param1);
      }
      
      public function serializeAs_DecraftedItemStackInfo(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.objectUID < 0)
         {
            throw new Error("Forbidden value (" + this.objectUID + ") on element objectUID.");
         }
         param1.writeVarInt(this.objectUID);
         param1.writeFloat(this.bonusMin);
         param1.writeFloat(this.bonusMax);
         param1.writeShort(this.runesId.length);
         while(_loc2_ < this.runesId.length)
         {
            if(this.runesId[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.runesId[_loc2_] + ") on element 4 (starting at 1) of runesId.");
            }
            param1.writeVarShort(this.runesId[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.runesQty.length);
         while(_loc3_ < this.runesQty.length)
         {
            if(this.runesQty[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.runesQty[_loc3_] + ") on element 5 (starting at 1) of runesQty.");
            }
            param1.writeVarInt(this.runesQty[_loc3_]);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_DecraftedItemStackInfo(param1);
      }
      
      public function deserializeAs_DecraftedItemStackInfo(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         this.objectUID = param1.readVarUhInt();
         if(this.objectUID < 0)
         {
            throw new Error("Forbidden value (" + this.objectUID + ") on element of DecraftedItemStackInfo.objectUID.");
         }
         this.bonusMin = param1.readFloat();
         this.bonusMax = param1.readFloat();
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readVarUhShort();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of runesId.");
            }
            this.runesId.push(_loc2_);
            _loc5_++;
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc3_ = param1.readVarUhInt();
            if(_loc3_ < 0)
            {
               throw new Error("Forbidden value (" + _loc3_ + ") on elements of runesQty.");
            }
            this.runesQty.push(_loc3_);
            _loc7_++;
         }
      }
   }
}
