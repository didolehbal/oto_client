package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class GameFightFighterInformations extends GameContextActorInformations implements INetworkType
   {
      
      public static const protocolId:uint = 143;
       
      
      public var teamId:uint = 2;
      
      public var wave:uint = 0;
      
      public var alive:Boolean = false;
      
      public var stats:GameFightMinimalStats;
      
      public var previousPositions:Vector.<uint>;
      
      public function GameFightFighterInformations()
      {
         this.stats = new GameFightMinimalStats();
         this.previousPositions = new Vector.<uint>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 143;
      }
      
      public function initGameFightFighterInformations(param1:int = 0, param2:EntityLook = null, param3:EntityDispositionInformations = null, param4:uint = 2, param5:uint = 0, param6:Boolean = false, param7:GameFightMinimalStats = null, param8:Vector.<uint> = null) : GameFightFighterInformations
      {
         super.initGameContextActorInformations(param1,param2,param3);
         this.teamId = param4;
         this.wave = param5;
         this.alive = param6;
         this.stats = param7;
         this.previousPositions = param8;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.teamId = 2;
         this.wave = 0;
         this.alive = false;
         this.stats = new GameFightMinimalStats();
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameFightFighterInformations(param1);
      }
      
      public function serializeAs_GameFightFighterInformations(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_GameContextActorInformations(param1);
         param1.writeByte(this.teamId);
         if(this.wave < 0)
         {
            throw new Error("Forbidden value (" + this.wave + ") on element wave.");
         }
         param1.writeByte(this.wave);
         param1.writeBoolean(this.alive);
         param1.writeShort(this.stats.getTypeId());
         this.stats.serialize(param1);
         param1.writeShort(this.previousPositions.length);
         while(_loc2_ < this.previousPositions.length)
         {
            if(this.previousPositions[_loc2_] < 0 || this.previousPositions[_loc2_] > 559)
            {
               throw new Error("Forbidden value (" + this.previousPositions[_loc2_] + ") on element 5 (starting at 1) of previousPositions.");
            }
            param1.writeVarShort(this.previousPositions[_loc2_]);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameFightFighterInformations(param1);
      }
      
      public function deserializeAs_GameFightFighterInformations(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc5_:uint = 0;
         super.deserialize(param1);
         this.teamId = param1.readByte();
         if(this.teamId < 0)
         {
            throw new Error("Forbidden value (" + this.teamId + ") on element of GameFightFighterInformations.teamId.");
         }
         this.wave = param1.readByte();
         if(this.wave < 0)
         {
            throw new Error("Forbidden value (" + this.wave + ") on element of GameFightFighterInformations.wave.");
         }
         this.alive = param1.readBoolean();
         var _loc3_:uint = param1.readUnsignedShort();
         this.stats = ProtocolTypeManager.getInstance(GameFightMinimalStats,_loc3_);
         this.stats.deserialize(param1);
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readVarUhShort();
            if(_loc2_ < 0 || _loc2_ > 559)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of previousPositions.");
            }
            this.previousPositions.push(_loc2_);
            _loc5_++;
         }
      }
   }
}
