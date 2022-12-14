package com.ankamagames.dofus.network.messages.game.character.stats
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class CharacterExperienceGainMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6321;
       
      
      private var _isInitialized:Boolean = false;
      
      public var experienceCharacter:Number = 0;
      
      public var experienceMount:Number = 0;
      
      public var experienceGuild:Number = 0;
      
      public var experienceIncarnation:Number = 0;
      
      public function CharacterExperienceGainMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6321;
      }
      
      public function initCharacterExperienceGainMessage(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0) : CharacterExperienceGainMessage
      {
         this.experienceCharacter = param1;
         this.experienceMount = param2;
         this.experienceGuild = param3;
         this.experienceIncarnation = param4;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.experienceCharacter = 0;
         this.experienceMount = 0;
         this.experienceGuild = 0;
         this.experienceIncarnation = 0;
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
         this.serializeAs_CharacterExperienceGainMessage(param1);
      }
      
      public function serializeAs_CharacterExperienceGainMessage(param1:ICustomDataOutput) : void
      {
         if(this.experienceCharacter < 0 || this.experienceCharacter > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.experienceCharacter + ") on element experienceCharacter.");
         }
         param1.writeVarLong(this.experienceCharacter);
         if(this.experienceMount < 0 || this.experienceMount > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.experienceMount + ") on element experienceMount.");
         }
         param1.writeVarLong(this.experienceMount);
         if(this.experienceGuild < 0 || this.experienceGuild > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.experienceGuild + ") on element experienceGuild.");
         }
         param1.writeVarLong(this.experienceGuild);
         if(this.experienceIncarnation < 0 || this.experienceIncarnation > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.experienceIncarnation + ") on element experienceIncarnation.");
         }
         param1.writeVarLong(this.experienceIncarnation);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_CharacterExperienceGainMessage(param1);
      }
      
      public function deserializeAs_CharacterExperienceGainMessage(param1:ICustomDataInput) : void
      {
         this.experienceCharacter = param1.readVarUhLong();
         if(this.experienceCharacter < 0 || this.experienceCharacter > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.experienceCharacter + ") on element of CharacterExperienceGainMessage.experienceCharacter.");
         }
         this.experienceMount = param1.readVarUhLong();
         if(this.experienceMount < 0 || this.experienceMount > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.experienceMount + ") on element of CharacterExperienceGainMessage.experienceMount.");
         }
         this.experienceGuild = param1.readVarUhLong();
         if(this.experienceGuild < 0 || this.experienceGuild > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.experienceGuild + ") on element of CharacterExperienceGainMessage.experienceGuild.");
         }
         this.experienceIncarnation = param1.readVarUhLong();
         if(this.experienceIncarnation < 0 || this.experienceIncarnation > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.experienceIncarnation + ") on element of CharacterExperienceGainMessage.experienceIncarnation.");
         }
      }
   }
}
