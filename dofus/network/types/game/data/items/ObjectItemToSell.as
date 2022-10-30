package com.ankamagames.dofus.network.types.game.data.items
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class ObjectItemToSell extends Item implements INetworkType
   {
      
      public static const protocolId:uint = 120;
       
      
      public var objectGID:uint = 0;
      
      public var effects:Vector.<ObjectEffect>;
      
      public var objectUID:uint = 0;
      
      public var quantity:uint = 0;
      
      public var objectPrice:uint = 0;
      
      public function ObjectItemToSell()
      {
         this.effects = new Vector.<ObjectEffect>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 120;
      }
      
      public function initObjectItemToSell(param1:uint = 0, param2:Vector.<ObjectEffect> = null, param3:uint = 0, param4:uint = 0, param5:uint = 0) : ObjectItemToSell
      {
         this.objectGID = param1;
         this.effects = param2;
         this.objectUID = param3;
         this.quantity = param4;
         this.objectPrice = param5;
         return this;
      }
      
      override public function reset() : void
      {
         this.objectGID = 0;
         this.effects = new Vector.<ObjectEffect>();
         this.objectUID = 0;
         this.quantity = 0;
         this.objectPrice = 0;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_ObjectItemToSell(param1);
      }
      
      public function serializeAs_ObjectItemToSell(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_Item(param1);
         if(this.objectGID < 0)
         {
            throw new Error("Forbidden value (" + this.objectGID + ") on element objectGID.");
         }
         param1.writeVarShort(this.objectGID);
         param1.writeShort(this.effects.length);
         while(_loc2_ < this.effects.length)
         {
            param1.writeShort((this.effects[_loc2_] as ObjectEffect).getTypeId());
            (this.effects[_loc2_] as ObjectEffect).serialize(param1);
            _loc2_++;
         }
         if(this.objectUID < 0)
         {
            throw new Error("Forbidden value (" + this.objectUID + ") on element objectUID.");
         }
         param1.writeVarInt(this.objectUID);
         if(this.quantity < 0)
         {
            throw new Error("Forbidden value (" + this.quantity + ") on element quantity.");
         }
         param1.writeVarInt(this.quantity);
         if(this.objectPrice < 0)
         {
            throw new Error("Forbidden value (" + this.objectPrice + ") on element objectPrice.");
         }
         param1.writeVarInt(this.objectPrice);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ObjectItemToSell(param1);
      }
      
      public function deserializeAs_ObjectItemToSell(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ObjectEffect = null;
         var _loc5_:uint = 0;
         super.deserialize(param1);
         this.objectGID = param1.readVarUhShort();
         if(this.objectGID < 0)
         {
            throw new Error("Forbidden value (" + this.objectGID + ") on element of ObjectItemToSell.objectGID.");
         }
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(ObjectEffect,_loc2_);
            _loc3_.deserialize(param1);
            this.effects.push(_loc3_);
            _loc5_++;
         }
         this.objectUID = param1.readVarUhInt();
         if(this.objectUID < 0)
         {
            throw new Error("Forbidden value (" + this.objectUID + ") on element of ObjectItemToSell.objectUID.");
         }
         this.quantity = param1.readVarUhInt();
         if(this.quantity < 0)
         {
            throw new Error("Forbidden value (" + this.quantity + ") on element of ObjectItemToSell.quantity.");
         }
         this.objectPrice = param1.readVarUhInt();
         if(this.objectPrice < 0)
         {
            throw new Error("Forbidden value (" + this.objectPrice + ") on element of ObjectItemToSell.objectPrice.");
         }
      }
   }
}
