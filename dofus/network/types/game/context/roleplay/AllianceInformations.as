package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class AllianceInformations extends BasicNamedAllianceInformations implements INetworkType
   {
      
      public static const protocolId:uint = 417;
       
      
      public var allianceEmblem:GuildEmblem;
      
      public function AllianceInformations()
      {
         this.allianceEmblem = new GuildEmblem();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 417;
      }
      
      public function initAllianceInformations(param1:uint = 0, param2:String = "", param3:String = "", param4:GuildEmblem = null) : AllianceInformations
      {
         super.initBasicNamedAllianceInformations(param1,param2,param3);
         this.allianceEmblem = param4;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.allianceEmblem = new GuildEmblem();
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_AllianceInformations(param1);
      }
      
      public function serializeAs_AllianceInformations(param1:ICustomDataOutput) : void
      {
         super.serializeAs_BasicNamedAllianceInformations(param1);
         this.allianceEmblem.serializeAs_GuildEmblem(param1);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_AllianceInformations(param1);
      }
      
      public function deserializeAs_AllianceInformations(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.allianceEmblem = new GuildEmblem();
         this.allianceEmblem.deserialize(param1);
      }
   }
}
