package com.ankamagames.dofus.network.types.game.social
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class AllianceVersatileInformations implements INetworkType
   {
      
      public static const protocolId:uint = 432;
       
      
      public var allianceId:uint = 0;
      
      public var nbGuilds:uint = 0;
      
      public var nbMembers:uint = 0;
      
      public var nbSubarea:uint = 0;
      
      public function AllianceVersatileInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 432;
      }
      
      public function initAllianceVersatileInformations(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:uint = 0) : AllianceVersatileInformations
      {
         this.allianceId = param1;
         this.nbGuilds = param2;
         this.nbMembers = param3;
         this.nbSubarea = param4;
         return this;
      }
      
      public function reset() : void
      {
         this.allianceId = 0;
         this.nbGuilds = 0;
         this.nbMembers = 0;
         this.nbSubarea = 0;
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_AllianceVersatileInformations(param1);
      }
      
      public function serializeAs_AllianceVersatileInformations(param1:ICustomDataOutput) : void
      {
         if(this.allianceId < 0)
         {
            throw new Error("Forbidden value (" + this.allianceId + ") on element allianceId.");
         }
         param1.writeVarInt(this.allianceId);
         if(this.nbGuilds < 0)
         {
            throw new Error("Forbidden value (" + this.nbGuilds + ") on element nbGuilds.");
         }
         param1.writeVarShort(this.nbGuilds);
         if(this.nbMembers < 0)
         {
            throw new Error("Forbidden value (" + this.nbMembers + ") on element nbMembers.");
         }
         param1.writeVarShort(this.nbMembers);
         if(this.nbSubarea < 0)
         {
            throw new Error("Forbidden value (" + this.nbSubarea + ") on element nbSubarea.");
         }
         param1.writeVarShort(this.nbSubarea);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_AllianceVersatileInformations(param1);
      }
      
      public function deserializeAs_AllianceVersatileInformations(param1:ICustomDataInput) : void
      {
         this.allianceId = param1.readVarUhInt();
         if(this.allianceId < 0)
         {
            throw new Error("Forbidden value (" + this.allianceId + ") on element of AllianceVersatileInformations.allianceId.");
         }
         this.nbGuilds = param1.readVarUhShort();
         if(this.nbGuilds < 0)
         {
            throw new Error("Forbidden value (" + this.nbGuilds + ") on element of AllianceVersatileInformations.nbGuilds.");
         }
         this.nbMembers = param1.readVarUhShort();
         if(this.nbMembers < 0)
         {
            throw new Error("Forbidden value (" + this.nbMembers + ") on element of AllianceVersatileInformations.nbMembers.");
         }
         this.nbSubarea = param1.readVarUhShort();
         if(this.nbSubarea < 0)
         {
            throw new Error("Forbidden value (" + this.nbSubarea + ") on element of AllianceVersatileInformations.nbSubarea.");
         }
      }
   }
}
