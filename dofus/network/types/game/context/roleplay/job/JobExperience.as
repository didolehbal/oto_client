package com.ankamagames.dofus.network.types.game.context.roleplay.job
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class JobExperience implements INetworkType
   {
      
      public static const protocolId:uint = 98;
       
      
      public var jobId:uint = 0;
      
      public var jobLevel:uint = 0;
      
      public var jobXP:Number = 0;
      
      public var jobXpLevelFloor:Number = 0;
      
      public var jobXpNextLevelFloor:Number = 0;
      
      public function JobExperience()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 98;
      }
      
      public function initJobExperience(param1:uint = 0, param2:uint = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0) : JobExperience
      {
         this.jobId = param1;
         this.jobLevel = param2;
         this.jobXP = param3;
         this.jobXpLevelFloor = param4;
         this.jobXpNextLevelFloor = param5;
         return this;
      }
      
      public function reset() : void
      {
         this.jobId = 0;
         this.jobLevel = 0;
         this.jobXP = 0;
         this.jobXpLevelFloor = 0;
         this.jobXpNextLevelFloor = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_JobExperience(param1);
      }
      
      public function serializeAs_JobExperience(param1:ICustomDataOutput) : void
      {
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element jobId.");
         }
         param1.writeByte(this.jobId);
         if(this.jobLevel < 0 || this.jobLevel > 255)
         {
            throw new Error("Forbidden value (" + this.jobLevel + ") on element jobLevel.");
         }
         param1.writeByte(this.jobLevel);
         if(this.jobXP < 0 || this.jobXP > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.jobXP + ") on element jobXP.");
         }
         param1.writeVarLong(this.jobXP);
         if(this.jobXpLevelFloor < 0 || this.jobXpLevelFloor > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.jobXpLevelFloor + ") on element jobXpLevelFloor.");
         }
         param1.writeVarLong(this.jobXpLevelFloor);
         if(this.jobXpNextLevelFloor < 0 || this.jobXpNextLevelFloor > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.jobXpNextLevelFloor + ") on element jobXpNextLevelFloor.");
         }
         param1.writeVarLong(this.jobXpNextLevelFloor);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_JobExperience(param1);
      }
      
      public function deserializeAs_JobExperience(param1:ICustomDataInput) : void
      {
         this.jobId = param1.readByte();
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element of JobExperience.jobId.");
         }
         this.jobLevel = param1.readUnsignedByte();
         if(this.jobLevel < 0 || this.jobLevel > 255)
         {
            throw new Error("Forbidden value (" + this.jobLevel + ") on element of JobExperience.jobLevel.");
         }
         this.jobXP = param1.readVarUhLong();
         if(this.jobXP < 0 || this.jobXP > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.jobXP + ") on element of JobExperience.jobXP.");
         }
         this.jobXpLevelFloor = param1.readVarUhLong();
         if(this.jobXpLevelFloor < 0 || this.jobXpLevelFloor > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.jobXpLevelFloor + ") on element of JobExperience.jobXpLevelFloor.");
         }
         this.jobXpNextLevelFloor = param1.readVarUhLong();
         if(this.jobXpNextLevelFloor < 0 || this.jobXpNextLevelFloor > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.jobXpNextLevelFloor + ") on element of JobExperience.jobXpNextLevelFloor.");
         }
      }
   }
}
