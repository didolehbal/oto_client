package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   
   public class PrismTooltipInformation
   {
       
      
      public var allianceIdentity:AllianceWrapper;
      
      public function PrismTooltipInformation(param1:AllianceWrapper)
      {
         super();
         this.allianceIdentity = param1;
      }
   }
}
