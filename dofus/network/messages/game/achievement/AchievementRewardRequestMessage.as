package com.ankamagames.dofus.network.messages.game.achievement
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class AchievementRewardRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6377;
       
      
      private var _isInitialized:Boolean = false;
      
      public var achievementId:int = 0;
      
      public function AchievementRewardRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6377;
      }
      
      public function initAchievementRewardRequestMessage(param1:int = 0) : AchievementRewardRequestMessage
      {
         this.achievementId = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.achievementId = 0;
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
         this.serializeAs_AchievementRewardRequestMessage(param1);
      }
      
      public function serializeAs_AchievementRewardRequestMessage(param1:ICustomDataOutput) : void
      {
         param1.writeShort(this.achievementId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_AchievementRewardRequestMessage(param1);
      }
      
      public function deserializeAs_AchievementRewardRequestMessage(param1:ICustomDataInput) : void
      {
         this.achievementId = param1.readShort();
      }
   }
}
