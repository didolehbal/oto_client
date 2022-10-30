package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class FightCommonInformations implements INetworkType
   {
      
      public static const protocolId:uint = 43;
       
      
      public var fightId:int = 0;
      
      public var fightType:uint = 0;
      
      public var fightTeams:Vector.<FightTeamInformations>;
      
      public var fightTeamsPositions:Vector.<uint>;
      
      public var fightTeamsOptions:Vector.<FightOptionsInformations>;
      
      public function FightCommonInformations()
      {
         this.fightTeams = new Vector.<FightTeamInformations>();
         this.fightTeamsPositions = new Vector.<uint>();
         this.fightTeamsOptions = new Vector.<FightOptionsInformations>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 43;
      }
      
      public function initFightCommonInformations(param1:int = 0, param2:uint = 0, param3:Vector.<FightTeamInformations> = null, param4:Vector.<uint> = null, param5:Vector.<FightOptionsInformations> = null) : FightCommonInformations
      {
         this.fightId = param1;
         this.fightType = param2;
         this.fightTeams = param3;
         this.fightTeamsPositions = param4;
         this.fightTeamsOptions = param5;
         return this;
      }
      
      public function reset() : void
      {
         this.fightId = 0;
         this.fightType = 0;
         this.fightTeams = new Vector.<FightTeamInformations>();
         this.fightTeamsPositions = new Vector.<uint>();
         this.fightTeamsOptions = new Vector.<FightOptionsInformations>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_FightCommonInformations(param1);
      }
      
      public function serializeAs_FightCommonInformations(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         param1.writeInt(this.fightId);
         param1.writeByte(this.fightType);
         param1.writeShort(this.fightTeams.length);
         while(_loc2_ < this.fightTeams.length)
         {
            param1.writeShort((this.fightTeams[_loc2_] as FightTeamInformations).getTypeId());
            (this.fightTeams[_loc2_] as FightTeamInformations).serialize(param1);
            _loc2_++;
         }
         param1.writeShort(this.fightTeamsPositions.length);
         while(_loc3_ < this.fightTeamsPositions.length)
         {
            if(this.fightTeamsPositions[_loc3_] < 0 || this.fightTeamsPositions[_loc3_] > 559)
            {
               throw new Error("Forbidden value (" + this.fightTeamsPositions[_loc3_] + ") on element 4 (starting at 1) of fightTeamsPositions.");
            }
            param1.writeVarShort(this.fightTeamsPositions[_loc3_]);
            _loc3_++;
         }
         param1.writeShort(this.fightTeamsOptions.length);
         while(_loc4_ < this.fightTeamsOptions.length)
         {
            (this.fightTeamsOptions[_loc4_] as FightOptionsInformations).serializeAs_FightOptionsInformations(param1);
            _loc4_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_FightCommonInformations(param1);
      }
      
      public function deserializeAs_FightCommonInformations(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:FightTeamInformations = null;
         var _loc4_:uint = 0;
         var _loc5_:FightOptionsInformations = null;
         var _loc7_:uint = 0;
         var _loc9_:uint = 0;
         var _loc11_:uint = 0;
         this.fightId = param1.readInt();
         this.fightType = param1.readByte();
         if(this.fightType < 0)
         {
            throw new Error("Forbidden value (" + this.fightType + ") on element of FightCommonInformations.fightType.");
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(FightTeamInformations,_loc2_);
            _loc3_.deserialize(param1);
            this.fightTeams.push(_loc3_);
            _loc7_++;
         }
         var _loc8_:uint = param1.readUnsignedShort();
         while(_loc9_ < _loc8_)
         {
            if((_loc4_ = param1.readVarUhShort()) < 0 || _loc4_ > 559)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of fightTeamsPositions.");
            }
            this.fightTeamsPositions.push(_loc4_);
            _loc9_++;
         }
         var _loc10_:uint = param1.readUnsignedShort();
         while(_loc11_ < _loc10_)
         {
            (_loc5_ = new FightOptionsInformations()).deserialize(param1);
            this.fightTeamsOptions.push(_loc5_);
            _loc11_++;
         }
      }
   }
}
