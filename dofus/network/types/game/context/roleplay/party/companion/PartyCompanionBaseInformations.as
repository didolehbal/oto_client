package com.ankamagames.dofus.network.types.game.context.roleplay.party.companion
{
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class PartyCompanionBaseInformations implements INetworkType
   {
      
      public static const protocolId:uint = 453;
       
      
      public var indexId:uint = 0;
      
      public var companionGenericId:uint = 0;
      
      public var entityLook:EntityLook;
      
      public function PartyCompanionBaseInformations()
      {
         this.entityLook = new EntityLook();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 453;
      }
      
      public function initPartyCompanionBaseInformations(param1:uint = 0, param2:uint = 0, param3:EntityLook = null) : PartyCompanionBaseInformations
      {
         this.indexId = param1;
         this.companionGenericId = param2;
         this.entityLook = param3;
         return this;
      }
      
      public function reset() : void
      {
         this.indexId = 0;
         this.companionGenericId = 0;
         this.entityLook = new EntityLook();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_PartyCompanionBaseInformations(param1);
      }
      
      public function serializeAs_PartyCompanionBaseInformations(param1:ICustomDataOutput) : void
      {
         if(this.indexId < 0)
         {
            throw new Error("Forbidden value (" + this.indexId + ") on element indexId.");
         }
         param1.writeByte(this.indexId);
         if(this.companionGenericId < 0)
         {
            throw new Error("Forbidden value (" + this.companionGenericId + ") on element companionGenericId.");
         }
         param1.writeByte(this.companionGenericId);
         this.entityLook.serializeAs_EntityLook(param1);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PartyCompanionBaseInformations(param1);
      }
      
      public function deserializeAs_PartyCompanionBaseInformations(param1:ICustomDataInput) : void
      {
         this.indexId = param1.readByte();
         if(this.indexId < 0)
         {
            throw new Error("Forbidden value (" + this.indexId + ") on element of PartyCompanionBaseInformations.indexId.");
         }
         this.companionGenericId = param1.readByte();
         if(this.companionGenericId < 0)
         {
            throw new Error("Forbidden value (" + this.companionGenericId + ") on element of PartyCompanionBaseInformations.companionGenericId.");
         }
         this.entityLook = new EntityLook();
         this.entityLook.deserialize(param1);
      }
   }
}
