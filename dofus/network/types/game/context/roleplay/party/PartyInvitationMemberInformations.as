package com.ankamagames.dofus.network.types.game.context.roleplay.party
{
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterBaseInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.companion.PartyCompanionBaseInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class PartyInvitationMemberInformations extends CharacterBaseInformations implements INetworkType
   {
      
      public static const protocolId:uint = 376;
       
      
      public var worldX:int = 0;
      
      public var worldY:int = 0;
      
      public var mapId:int = 0;
      
      public var subAreaId:uint = 0;
      
      public var companions:Vector.<PartyCompanionBaseInformations>;
      
      public function PartyInvitationMemberInformations()
      {
         this.companions = new Vector.<PartyCompanionBaseInformations>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 376;
      }
      
      public function initPartyInvitationMemberInformations(param1:uint = 0, param2:uint = 0, param3:String = "", param4:EntityLook = null, param5:int = 0, param6:Boolean = false, param7:int = 0, param8:int = 0, param9:int = 0, param10:uint = 0, param11:Vector.<PartyCompanionBaseInformations> = null) : PartyInvitationMemberInformations
      {
         super.initCharacterBaseInformations(param1,param2,param3,param4,param5,param6);
         this.worldX = param7;
         this.worldY = param8;
         this.mapId = param9;
         this.subAreaId = param10;
         this.companions = param11;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.worldX = 0;
         this.worldY = 0;
         this.mapId = 0;
         this.subAreaId = 0;
         this.companions = new Vector.<PartyCompanionBaseInformations>();
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_PartyInvitationMemberInformations(param1);
      }
      
      public function serializeAs_PartyInvitationMemberInformations(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_CharacterBaseInformations(param1);
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element worldX.");
         }
         param1.writeShort(this.worldX);
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element worldY.");
         }
         param1.writeShort(this.worldY);
         param1.writeInt(this.mapId);
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element subAreaId.");
         }
         param1.writeVarShort(this.subAreaId);
         param1.writeShort(this.companions.length);
         while(_loc2_ < this.companions.length)
         {
            (this.companions[_loc2_] as PartyCompanionBaseInformations).serializeAs_PartyCompanionBaseInformations(param1);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PartyInvitationMemberInformations(param1);
      }
      
      public function deserializeAs_PartyInvitationMemberInformations(param1:ICustomDataInput) : void
      {
         var _loc2_:PartyCompanionBaseInformations = null;
         var _loc4_:uint = 0;
         super.deserialize(param1);
         this.worldX = param1.readShort();
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element of PartyInvitationMemberInformations.worldX.");
         }
         this.worldY = param1.readShort();
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element of PartyInvitationMemberInformations.worldY.");
         }
         this.mapId = param1.readInt();
         this.subAreaId = param1.readVarUhShort();
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element of PartyInvitationMemberInformations.subAreaId.");
         }
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new PartyCompanionBaseInformations();
            _loc2_.deserialize(param1);
            this.companions.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
