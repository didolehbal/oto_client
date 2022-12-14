package com.ankamagames.dofus.network.messages.game.context.roleplay.job
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectoryListEntry;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class JobCrafterDirectoryListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6046;
       
      
      private var _isInitialized:Boolean = false;
      
      public var listEntries:Vector.<JobCrafterDirectoryListEntry>;
      
      public function JobCrafterDirectoryListMessage()
      {
         this.listEntries = new Vector.<JobCrafterDirectoryListEntry>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6046;
      }
      
      public function initJobCrafterDirectoryListMessage(param1:Vector.<JobCrafterDirectoryListEntry> = null) : JobCrafterDirectoryListMessage
      {
         this.listEntries = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.listEntries = new Vector.<JobCrafterDirectoryListEntry>();
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
         this.serializeAs_JobCrafterDirectoryListMessage(param1);
      }
      
      public function serializeAs_JobCrafterDirectoryListMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.listEntries.length);
         while(_loc2_ < this.listEntries.length)
         {
            (this.listEntries[_loc2_] as JobCrafterDirectoryListEntry).serializeAs_JobCrafterDirectoryListEntry(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_JobCrafterDirectoryListMessage(param1);
      }
      
      public function deserializeAs_JobCrafterDirectoryListMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:JobCrafterDirectoryListEntry = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new JobCrafterDirectoryListEntry();
            _loc2_.deserialize(param1);
            this.listEntries.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
