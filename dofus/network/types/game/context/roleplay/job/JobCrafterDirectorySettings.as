package com.ankamagames.dofus.network.types.game.context.roleplay.job
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class JobCrafterDirectorySettings implements INetworkType
   {
      
      public static const protocolId:uint = 97;
       
      
      public var jobId:uint = 0;
      
      public var minLevel:uint = 0;
      
      public var free:Boolean = false;
      
      public function JobCrafterDirectorySettings()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 97;
      }
      
      public function initJobCrafterDirectorySettings(param1:uint = 0, param2:uint = 0, param3:Boolean = false) : JobCrafterDirectorySettings
      {
         this.jobId = param1;
         this.minLevel = param2;
         this.free = param3;
         return this;
      }
      
      public function reset() : void
      {
         this.jobId = 0;
         this.minLevel = 0;
         this.free = false;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_JobCrafterDirectorySettings(param1);
      }
      
      public function serializeAs_JobCrafterDirectorySettings(param1:ICustomDataOutput) : void
      {
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element jobId.");
         }
         param1.writeByte(this.jobId);
         if(this.minLevel < 0 || this.minLevel > 255)
         {
            throw new Error("Forbidden value (" + this.minLevel + ") on element minLevel.");
         }
         param1.writeByte(this.minLevel);
         param1.writeBoolean(this.free);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_JobCrafterDirectorySettings(param1);
      }
      
      public function deserializeAs_JobCrafterDirectorySettings(param1:ICustomDataInput) : void
      {
         this.jobId = param1.readByte();
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element of JobCrafterDirectorySettings.jobId.");
         }
         this.minLevel = param1.readUnsignedByte();
         if(this.minLevel < 0 || this.minLevel > 255)
         {
            throw new Error("Forbidden value (" + this.minLevel + ") on element of JobCrafterDirectorySettings.minLevel.");
         }
         this.free = param1.readBoolean();
      }
   }
}
