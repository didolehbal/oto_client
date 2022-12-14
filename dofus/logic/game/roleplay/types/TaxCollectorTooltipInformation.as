package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   
   public class TaxCollectorTooltipInformation
   {
       
      
      public var lastName:String;
      
      public var firstName:String;
      
      public var guildIdentity:GuildWrapper;
      
      public var taxCollectorAttack:int;
      
      public var allianceIdentity:AllianceWrapper;
      
      public function TaxCollectorTooltipInformation(param1:String, param2:String, param3:GuildWrapper, param4:AllianceWrapper, param5:int)
      {
         super();
         this.lastName = param2;
         this.firstName = param1;
         this.guildIdentity = param3;
         this.allianceIdentity = param4;
         this.taxCollectorAttack = param5;
      }
   }
}
