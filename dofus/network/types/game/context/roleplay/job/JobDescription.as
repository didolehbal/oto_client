package com.ankamagames.dofus.network.types.game.context.roleplay.job
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescription;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class JobDescription implements INetworkType
   {
      
      public static const protocolId:uint = 101;
       
      
      public var jobId:uint = 0;
      
      public var skills:Vector.<SkillActionDescription>;
      
      public function JobDescription()
      {
         this.skills = new Vector.<SkillActionDescription>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 101;
      }
      
      public function initJobDescription(param1:uint = 0, param2:Vector.<SkillActionDescription> = null) : JobDescription
      {
         this.jobId = param1;
         this.skills = param2;
         return this;
      }
      
      public function reset() : void
      {
         this.jobId = 0;
         this.skills = new Vector.<SkillActionDescription>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_JobDescription(param1);
      }
      
      public function serializeAs_JobDescription(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element jobId.");
         }
         param1.writeByte(this.jobId);
         param1.writeShort(this.skills.length);
         while(_loc2_ < this.skills.length)
         {
            param1.writeShort((this.skills[_loc2_] as SkillActionDescription).getTypeId());
            (this.skills[_loc2_] as SkillActionDescription).serialize(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_JobDescription(param1);
      }
      
      public function deserializeAs_JobDescription(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:SkillActionDescription = null;
         var _loc5_:uint = 0;
         this.jobId = param1.readByte();
         if(this.jobId < 0)
         {
            throw new Error("Forbidden value (" + this.jobId + ") on element of JobDescription.jobId.");
         }
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(SkillActionDescription,_loc2_);
            _loc3_.deserialize(param1);
            this.skills.push(_loc3_);
            _loc5_++;
         }
      }
   }
}
