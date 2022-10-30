package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class FightTeamInformations extends AbstractFightTeamInformations implements INetworkType
   {
      
      public static const protocolId:uint = 33;
       
      
      public var teamMembers:Vector.<FightTeamMemberInformations>;
      
      public function FightTeamInformations()
      {
         this.teamMembers = new Vector.<FightTeamMemberInformations>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 33;
      }
      
      public function initFightTeamInformations(param1:uint = 2, param2:int = 0, param3:int = 0, param4:uint = 0, param5:uint = 0, param6:Vector.<FightTeamMemberInformations> = null) : FightTeamInformations
      {
         super.initAbstractFightTeamInformations(param1,param2,param3,param4,param5);
         this.teamMembers = param6;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.teamMembers = new Vector.<FightTeamMemberInformations>();
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_FightTeamInformations(param1);
      }
      
      public function serializeAs_FightTeamInformations(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_AbstractFightTeamInformations(param1);
         param1.writeShort(this.teamMembers.length);
         while(_loc2_ < this.teamMembers.length)
         {
            param1.writeShort((this.teamMembers[_loc2_] as FightTeamMemberInformations).getTypeId());
            (this.teamMembers[_loc2_] as FightTeamMemberInformations).serialize(param1);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_FightTeamInformations(param1);
      }
      
      public function deserializeAs_FightTeamInformations(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:FightTeamMemberInformations = null;
         var _loc5_:uint = 0;
         super.deserialize(param1);
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(FightTeamMemberInformations,_loc2_);
            _loc3_.deserialize(param1);
            this.teamMembers.push(_loc3_);
            _loc5_++;
         }
      }
   }
}
