package com.ankamagames.dofus.network.messages.game.achievement
{
   import com.ankamagames.dofus.network.types.game.achievement.Achievement;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class AchievementDetailedListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6358;
       
      
      private var _isInitialized:Boolean = false;
      
      public var startedAchievements:Vector.<Achievement>;
      
      public var finishedAchievements:Vector.<Achievement>;
      
      public function AchievementDetailedListMessage()
      {
         this.startedAchievements = new Vector.<Achievement>();
         this.finishedAchievements = new Vector.<Achievement>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6358;
      }
      
      public function initAchievementDetailedListMessage(param1:Vector.<Achievement> = null, param2:Vector.<Achievement> = null) : AchievementDetailedListMessage
      {
         this.startedAchievements = param1;
         this.finishedAchievements = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.startedAchievements = new Vector.<Achievement>();
         this.finishedAchievements = new Vector.<Achievement>();
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
         this.serializeAs_AchievementDetailedListMessage(param1);
      }
      
      public function serializeAs_AchievementDetailedListMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         param1.writeShort(this.startedAchievements.length);
         while(_loc2_ < this.startedAchievements.length)
         {
            (this.startedAchievements[_loc2_] as Achievement).serializeAs_Achievement(param1);
            _loc2_++;
         }
         param1.writeShort(this.finishedAchievements.length);
         while(_loc3_ < this.finishedAchievements.length)
         {
            (this.finishedAchievements[_loc3_] as Achievement).serializeAs_Achievement(param1);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_AchievementDetailedListMessage(param1);
      }
      
      public function deserializeAs_AchievementDetailedListMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:Achievement = null;
         var _loc3_:Achievement = null;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new Achievement();
            _loc2_.deserialize(param1);
            this.startedAchievements.push(_loc2_);
            _loc5_++;
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc3_ = new Achievement();
            _loc3_.deserialize(param1);
            this.finishedAchievements.push(_loc3_);
            _loc7_++;
         }
      }
   }
}
