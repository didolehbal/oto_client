package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class FightLoot implements INetworkType
   {
      
      public static const protocolId:uint = 41;
       
      
      public var objects:Vector.<uint>;
      
      public var kamas:uint = 0;
      
      public function FightLoot()
      {
         this.objects = new Vector.<uint>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 41;
      }
      
      public function initFightLoot(param1:Vector.<uint> = null, param2:uint = 0) : FightLoot
      {
         this.objects = param1;
         this.kamas = param2;
         return this;
      }
      
      public function reset() : void
      {
         this.objects = new Vector.<uint>();
         this.kamas = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_FightLoot(param1);
      }
      
      public function serializeAs_FightLoot(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.objects.length);
         while(_loc2_ < this.objects.length)
         {
            if(this.objects[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.objects[_loc2_] + ") on element 1 (starting at 1) of objects.");
            }
            param1.writeVarShort(this.objects[_loc2_]);
            _loc2_++;
         }
         if(this.kamas < 0)
         {
            throw new Error("Forbidden value (" + this.kamas + ") on element kamas.");
         }
         param1.writeVarInt(this.kamas);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_FightLoot(param1);
      }
      
      public function deserializeAs_FightLoot(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readVarUhShort();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of objects.");
            }
            this.objects.push(_loc2_);
            _loc4_++;
         }
         this.kamas = param1.readVarUhInt();
         if(this.kamas < 0)
         {
            throw new Error("Forbidden value (" + this.kamas + ") on element of FightLoot.kamas.");
         }
      }
   }
}
