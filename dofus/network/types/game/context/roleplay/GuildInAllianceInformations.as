package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class GuildInAllianceInformations extends GuildInformations implements INetworkType
   {
      
      public static const protocolId:uint = 420;
       
      
      public var guildLevel:uint = 0;
      
      public var nbMembers:uint = 0;
      
      public var enabled:Boolean = false;
      
      public function GuildInAllianceInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 420;
      }
      
      public function initGuildInAllianceInformations(param1:uint = 0, param2:String = "", param3:GuildEmblem = null, param4:uint = 0, param5:uint = 0, param6:Boolean = false) : GuildInAllianceInformations
      {
         super.initGuildInformations(param1,param2,param3);
         this.guildLevel = param4;
         this.nbMembers = param5;
         this.enabled = param6;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.guildLevel = 0;
         this.nbMembers = 0;
         this.enabled = false;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GuildInAllianceInformations(param1);
      }
      
      public function serializeAs_GuildInAllianceInformations(param1:ICustomDataOutput) : void
      {
         super.serializeAs_GuildInformations(param1);
         if(this.guildLevel < 1 || this.guildLevel > 200)
         {
            throw new Error("Forbidden value (" + this.guildLevel + ") on element guildLevel.");
         }
         param1.writeByte(this.guildLevel);
         if(this.nbMembers < 1 || this.nbMembers > 240)
         {
            throw new Error("Forbidden value (" + this.nbMembers + ") on element nbMembers.");
         }
         param1.writeByte(this.nbMembers);
         param1.writeBoolean(this.enabled);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GuildInAllianceInformations(param1);
      }
      
      public function deserializeAs_GuildInAllianceInformations(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.guildLevel = param1.readUnsignedByte();
         if(this.guildLevel < 1 || this.guildLevel > 200)
         {
            throw new Error("Forbidden value (" + this.guildLevel + ") on element of GuildInAllianceInformations.guildLevel.");
         }
         this.nbMembers = param1.readUnsignedByte();
         if(this.nbMembers < 1 || this.nbMembers > 240)
         {
            throw new Error("Forbidden value (" + this.nbMembers + ") on element of GuildInAllianceInformations.nbMembers.");
         }
         this.enabled = param1.readBoolean();
      }
   }
}
