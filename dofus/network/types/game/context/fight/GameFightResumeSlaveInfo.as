package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class GameFightResumeSlaveInfo implements INetworkType
   {
      
      public static const protocolId:uint = 364;
       
      
      public var slaveId:int = 0;
      
      public var spellCooldowns:Vector.<GameFightSpellCooldown>;
      
      public var summonCount:uint = 0;
      
      public var bombCount:uint = 0;
      
      public function GameFightResumeSlaveInfo()
      {
         this.spellCooldowns = new Vector.<GameFightSpellCooldown>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 364;
      }
      
      public function initGameFightResumeSlaveInfo(param1:int = 0, param2:Vector.<GameFightSpellCooldown> = null, param3:uint = 0, param4:uint = 0) : GameFightResumeSlaveInfo
      {
         this.slaveId = param1;
         this.spellCooldowns = param2;
         this.summonCount = param3;
         this.bombCount = param4;
         return this;
      }
      
      public function reset() : void
      {
         this.slaveId = 0;
         this.spellCooldowns = new Vector.<GameFightSpellCooldown>();
         this.summonCount = 0;
         this.bombCount = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameFightResumeSlaveInfo(param1);
      }
      
      public function serializeAs_GameFightResumeSlaveInfo(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeInt(this.slaveId);
         param1.writeShort(this.spellCooldowns.length);
         while(_loc2_ < this.spellCooldowns.length)
         {
            (this.spellCooldowns[_loc2_] as GameFightSpellCooldown).serializeAs_GameFightSpellCooldown(param1);
            _loc2_++;
         }
         if(this.summonCount < 0)
         {
            throw new Error("Forbidden value (" + this.summonCount + ") on element summonCount.");
         }
         param1.writeByte(this.summonCount);
         if(this.bombCount < 0)
         {
            throw new Error("Forbidden value (" + this.bombCount + ") on element bombCount.");
         }
         param1.writeByte(this.bombCount);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameFightResumeSlaveInfo(param1);
      }
      
      public function deserializeAs_GameFightResumeSlaveInfo(param1:ICustomDataInput) : void
      {
         var _loc2_:GameFightSpellCooldown = null;
         var _loc4_:uint = 0;
         this.slaveId = param1.readInt();
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new GameFightSpellCooldown();
            _loc2_.deserialize(param1);
            this.spellCooldowns.push(_loc2_);
            _loc4_++;
         }
         this.summonCount = param1.readByte();
         if(this.summonCount < 0)
         {
            throw new Error("Forbidden value (" + this.summonCount + ") on element of GameFightResumeSlaveInfo.summonCount.");
         }
         this.bombCount = param1.readByte();
         if(this.bombCount < 0)
         {
            throw new Error("Forbidden value (" + this.bombCount + ") on element of GameFightResumeSlaveInfo.bombCount.");
         }
      }
   }
}
