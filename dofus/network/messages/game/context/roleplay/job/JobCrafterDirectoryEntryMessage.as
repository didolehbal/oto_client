package com.ankamagames.dofus.network.messages.game.context.roleplay.job
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryEntryJobInfo;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryEntryPlayerInfo;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class JobCrafterDirectoryEntryMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6044;
       
      
      private var _isInitialized:Boolean = false;
      
      public var playerInfo:JobCrafterDirectoryEntryPlayerInfo;
      
      public var jobInfoList:Vector.<JobCrafterDirectoryEntryJobInfo>;
      
      public var playerLook:EntityLook;
      
      public function JobCrafterDirectoryEntryMessage()
      {
         this.playerInfo = new JobCrafterDirectoryEntryPlayerInfo();
         this.jobInfoList = new Vector.<JobCrafterDirectoryEntryJobInfo>();
         this.playerLook = new EntityLook();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6044;
      }
      
      public function initJobCrafterDirectoryEntryMessage(param1:JobCrafterDirectoryEntryPlayerInfo = null, param2:Vector.<JobCrafterDirectoryEntryJobInfo> = null, param3:EntityLook = null) : JobCrafterDirectoryEntryMessage
      {
         this.playerInfo = param1;
         this.jobInfoList = param2;
         this.playerLook = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.playerInfo = new JobCrafterDirectoryEntryPlayerInfo();
         this.playerLook = new EntityLook();
         this._isInitialized = false;
      }
      
      override public function pack(param1:ICustomDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(new CustomDataWrapper(_loc2_));
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:ICustomDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_JobCrafterDirectoryEntryMessage(param1);
      }
      
      public function serializeAs_JobCrafterDirectoryEntryMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         this.playerInfo.serializeAs_JobCrafterDirectoryEntryPlayerInfo(param1);
         param1.writeShort(this.jobInfoList.length);
         while(_loc2_ < this.jobInfoList.length)
         {
            (this.jobInfoList[_loc2_] as JobCrafterDirectoryEntryJobInfo).serializeAs_JobCrafterDirectoryEntryJobInfo(param1);
            _loc2_++;
         }
         this.playerLook.serializeAs_EntityLook(param1);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_JobCrafterDirectoryEntryMessage(param1);
      }
      
      public function deserializeAs_JobCrafterDirectoryEntryMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:JobCrafterDirectoryEntryJobInfo = null;
         var _loc4_:uint = 0;
         this.playerInfo = new JobCrafterDirectoryEntryPlayerInfo();
         this.playerInfo.deserialize(param1);
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new JobCrafterDirectoryEntryJobInfo();
            _loc2_.deserialize(param1);
            this.jobInfoList.push(_loc2_);
            _loc4_++;
         }
         this.playerLook = new EntityLook();
         this.playerLook.deserialize(param1);
      }
   }
}
