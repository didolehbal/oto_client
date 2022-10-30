package com.ankamagames.dofus.network.types.game.data.items
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class BidExchangerObjectInfo implements INetworkType
   {
      
      public static const protocolId:uint = 122;
       
      
      public var objectUID:uint = 0;
      
      public var effects:Vector.<ObjectEffect>;
      
      public var prices:Vector.<uint>;
      
      public function BidExchangerObjectInfo()
      {
         this.effects = new Vector.<ObjectEffect>();
         this.prices = new Vector.<uint>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 122;
      }
      
      public function initBidExchangerObjectInfo(param1:uint = 0, param2:Vector.<ObjectEffect> = null, param3:Vector.<uint> = null) : BidExchangerObjectInfo
      {
         this.objectUID = param1;
         this.effects = param2;
         this.prices = param3;
         return this;
      }
      
      public function reset() : void
      {
         this.objectUID = 0;
         this.effects = new Vector.<ObjectEffect>();
         this.prices = new Vector.<uint>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_BidExchangerObjectInfo(param1);
      }
      
      public function serializeAs_BidExchangerObjectInfo(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.objectUID < 0)
         {
            throw new Error("Forbidden value (" + this.objectUID + ") on element objectUID.");
         }
         param1.writeVarInt(this.objectUID);
         param1.writeShort(this.effects.length);
         while(_loc2_ < this.effects.length)
         {
            param1.writeShort((this.effects[_loc2_] as ObjectEffect).getTypeId());
            (this.effects[_loc2_] as ObjectEffect).serialize(param1);
            _loc2_++;
         }
         param1.writeShort(this.prices.length);
         while(_loc3_ < this.prices.length)
         {
            if(this.prices[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.prices[_loc3_] + ") on element 3 (starting at 1) of prices.");
            }
            param1.writeInt(this.prices[_loc3_]);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_BidExchangerObjectInfo(param1);
      }
      
      public function deserializeAs_BidExchangerObjectInfo(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ObjectEffect = null;
         var _loc4_:uint = 0;
         var _loc6_:uint = 0;
         var _loc8_:uint = 0;
         this.objectUID = param1.readVarUhInt();
         if(this.objectUID < 0)
         {
            throw new Error("Forbidden value (" + this.objectUID + ") on element of BidExchangerObjectInfo.objectUID.");
         }
         var _loc5_:uint = param1.readUnsignedShort();
         while(_loc6_ < _loc5_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(ObjectEffect,_loc2_);
            _loc3_.deserialize(param1);
            this.effects.push(_loc3_);
            _loc6_++;
         }
         var _loc7_:uint = param1.readUnsignedShort();
         while(_loc8_ < _loc7_)
         {
            if((_loc4_ = param1.readInt()) < 0)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of prices.");
            }
            this.prices.push(_loc4_);
            _loc8_++;
         }
      }
   }
}
