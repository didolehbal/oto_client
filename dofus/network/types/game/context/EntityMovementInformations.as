package com.ankamagames.dofus.network.types.game.context
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class EntityMovementInformations implements INetworkType
   {
      
      public static const protocolId:uint = 63;
       
      
      public var id:int = 0;
      
      public var steps:Vector.<int>;
      
      public function EntityMovementInformations()
      {
         this.steps = new Vector.<int>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 63;
      }
      
      public function initEntityMovementInformations(param1:int = 0, param2:Vector.<int> = null) : EntityMovementInformations
      {
         this.id = param1;
         this.steps = param2;
         return this;
      }
      
      public function reset() : void
      {
         this.id = 0;
         this.steps = new Vector.<int>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_EntityMovementInformations(param1);
      }
      
      public function serializeAs_EntityMovementInformations(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeInt(this.id);
         param1.writeShort(this.steps.length);
         while(_loc2_ < this.steps.length)
         {
            param1.writeByte(this.steps[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_EntityMovementInformations(param1);
      }
      
      public function deserializeAs_EntityMovementInformations(param1:ICustomDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc4_:uint = 0;
         this.id = param1.readInt();
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readByte();
            this.steps.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
