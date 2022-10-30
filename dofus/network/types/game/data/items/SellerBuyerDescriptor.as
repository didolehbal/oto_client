package com.ankamagames.dofus.network.types.game.data.items
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class SellerBuyerDescriptor implements INetworkType
   {
      
      public static const protocolId:uint = 121;
       
      
      public var quantities:Vector.<uint>;
      
      public var types:Vector.<uint>;
      
      public var taxPercentage:Number = 0;
      
      public var taxModificationPercentage:Number = 0;
      
      public var maxItemLevel:uint = 0;
      
      public var maxItemPerAccount:uint = 0;
      
      public var npcContextualId:int = 0;
      
      public var unsoldDelay:uint = 0;
      
      public function SellerBuyerDescriptor()
      {
         this.quantities = new Vector.<uint>();
         this.types = new Vector.<uint>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 121;
      }
      
      public function initSellerBuyerDescriptor(param1:Vector.<uint> = null, param2:Vector.<uint> = null, param3:Number = 0, param4:Number = 0, param5:uint = 0, param6:uint = 0, param7:int = 0, param8:uint = 0) : SellerBuyerDescriptor
      {
         this.quantities = param1;
         this.types = param2;
         this.taxPercentage = param3;
         this.taxModificationPercentage = param4;
         this.maxItemLevel = param5;
         this.maxItemPerAccount = param6;
         this.npcContextualId = param7;
         this.unsoldDelay = param8;
         return this;
      }
      
      public function reset() : void
      {
         this.quantities = new Vector.<uint>();
         this.types = new Vector.<uint>();
         this.taxPercentage = 0;
         this.taxModificationPercentage = 0;
         this.maxItemLevel = 0;
         this.maxItemPerAccount = 0;
         this.npcContextualId = 0;
         this.unsoldDelay = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_SellerBuyerDescriptor(param1);
      }
      
      public function serializeAs_SellerBuyerDescriptor(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         param1.writeShort(this.quantities.length);
         while(_loc2_ < this.quantities.length)
         {
            if(this.quantities[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.quantities[_loc2_] + ") on element 1 (starting at 1) of quantities.");
            }
            param1.writeVarInt(this.quantities[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.types.length);
         while(_loc3_ < this.types.length)
         {
            if(this.types[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.types[_loc3_] + ") on element 2 (starting at 1) of types.");
            }
            param1.writeVarInt(this.types[_loc3_]);
            _loc3_++;
         }
         param1.writeFloat(this.taxPercentage);
         param1.writeFloat(this.taxModificationPercentage);
         if(this.maxItemLevel < 0 || this.maxItemLevel > 255)
         {
            throw new Error("Forbidden value (" + this.maxItemLevel + ") on element maxItemLevel.");
         }
         param1.writeByte(this.maxItemLevel);
         if(this.maxItemPerAccount < 0)
         {
            throw new Error("Forbidden value (" + this.maxItemPerAccount + ") on element maxItemPerAccount.");
         }
         param1.writeVarInt(this.maxItemPerAccount);
         param1.writeInt(this.npcContextualId);
         if(this.unsoldDelay < 0)
         {
            throw new Error("Forbidden value (" + this.unsoldDelay + ") on element unsoldDelay.");
         }
         param1.writeVarShort(this.unsoldDelay);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_SellerBuyerDescriptor(param1);
      }
      
      public function deserializeAs_SellerBuyerDescriptor(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readVarUhInt();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of quantities.");
            }
            this.quantities.push(_loc2_);
            _loc5_++;
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc3_ = param1.readVarUhInt();
            if(_loc3_ < 0)
            {
               throw new Error("Forbidden value (" + _loc3_ + ") on elements of types.");
            }
            this.types.push(_loc3_);
            _loc7_++;
         }
         this.taxPercentage = param1.readFloat();
         this.taxModificationPercentage = param1.readFloat();
         this.maxItemLevel = param1.readUnsignedByte();
         if(this.maxItemLevel < 0 || this.maxItemLevel > 255)
         {
            throw new Error("Forbidden value (" + this.maxItemLevel + ") on element of SellerBuyerDescriptor.maxItemLevel.");
         }
         this.maxItemPerAccount = param1.readVarUhInt();
         if(this.maxItemPerAccount < 0)
         {
            throw new Error("Forbidden value (" + this.maxItemPerAccount + ") on element of SellerBuyerDescriptor.maxItemPerAccount.");
         }
         this.npcContextualId = param1.readInt();
         this.unsoldDelay = param1.readVarUhShort();
         if(this.unsoldDelay < 0)
         {
            throw new Error("Forbidden value (" + this.unsoldDelay + ") on element of SellerBuyerDescriptor.unsoldDelay.");
         }
      }
   }
}
