package com.ankamagames.dofus.network.types.common.basic
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class StatisticData implements INetworkType
   {
      
      public static const protocolId:uint = 484;
       
      
      public var actionId:uint = 0;
      
      public function StatisticData()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 484;
      }
      
      public function initStatisticData(param1:uint = 0) : StatisticData
      {
         this.actionId = param1;
         return this;
      }
      
      public function reset() : void
      {
         this.actionId = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_StatisticData(param1);
      }
      
      public function serializeAs_StatisticData(param1:ICustomDataOutput) : void
      {
         if(this.actionId < 0)
         {
            throw new Error("Forbidden value (" + this.actionId + ") on element actionId.");
         }
         param1.writeVarShort(this.actionId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_StatisticData(param1);
      }
      
      public function deserializeAs_StatisticData(param1:ICustomDataInput) : void
      {
         this.actionId = param1.readVarUhShort();
         if(this.actionId < 0)
         {
            throw new Error("Forbidden value (" + this.actionId + ") on element of StatisticData.actionId.");
         }
      }
   }
}
