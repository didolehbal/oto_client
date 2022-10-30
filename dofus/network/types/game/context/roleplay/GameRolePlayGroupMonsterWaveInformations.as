package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class GameRolePlayGroupMonsterWaveInformations extends GameRolePlayGroupMonsterInformations implements INetworkType
   {
      
      public static const protocolId:uint = 464;
       
      
      public var nbWaves:uint = 0;
      
      public var alternatives:Vector.<GroupMonsterStaticInformations>;
      
      public function GameRolePlayGroupMonsterWaveInformations()
      {
         this.alternatives = new Vector.<GroupMonsterStaticInformations>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 464;
      }
      
      public function initGameRolePlayGroupMonsterWaveInformations(param1:int = 0, param2:EntityLook = null, param3:EntityDispositionInformations = null, param4:GroupMonsterStaticInformations = null, param5:int = 0, param6:int = 0, param7:int = 0, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:uint = 0, param12:Vector.<GroupMonsterStaticInformations> = null) : GameRolePlayGroupMonsterWaveInformations
      {
         super.initGameRolePlayGroupMonsterInformations(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
         this.nbWaves = param11;
         this.alternatives = param12;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.nbWaves = 0;
         this.alternatives = new Vector.<GroupMonsterStaticInformations>();
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameRolePlayGroupMonsterWaveInformations(param1);
      }
      
      public function serializeAs_GameRolePlayGroupMonsterWaveInformations(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_GameRolePlayGroupMonsterInformations(param1);
         if(this.nbWaves < 0)
         {
            throw new Error("Forbidden value (" + this.nbWaves + ") on element nbWaves.");
         }
         param1.writeByte(this.nbWaves);
         param1.writeShort(this.alternatives.length);
         while(_loc2_ < this.alternatives.length)
         {
            param1.writeShort((this.alternatives[_loc2_] as GroupMonsterStaticInformations).getTypeId());
            (this.alternatives[_loc2_] as GroupMonsterStaticInformations).serialize(param1);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameRolePlayGroupMonsterWaveInformations(param1);
      }
      
      public function deserializeAs_GameRolePlayGroupMonsterWaveInformations(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:GroupMonsterStaticInformations = null;
         var _loc5_:uint = 0;
         super.deserialize(param1);
         this.nbWaves = param1.readByte();
         if(this.nbWaves < 0)
         {
            throw new Error("Forbidden value (" + this.nbWaves + ") on element of GameRolePlayGroupMonsterWaveInformations.nbWaves.");
         }
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(GroupMonsterStaticInformations,_loc2_);
            _loc3_.deserialize(param1);
            this.alternatives.push(_loc3_);
            _loc5_++;
         }
      }
   }
}
