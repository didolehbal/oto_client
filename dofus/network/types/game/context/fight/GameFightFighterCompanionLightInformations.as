package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class GameFightFighterCompanionLightInformations extends GameFightFighterLightInformations implements INetworkType
   {
      
      public static const protocolId:uint = 454;
       
      
      public var companionId:uint = 0;
      
      public var masterId:int = 0;
      
      public function GameFightFighterCompanionLightInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 454;
      }
      
      public function initGameFightFighterCompanionLightInformations(param1:int = 0, param2:uint = 0, param3:uint = 0, param4:int = 0, param5:Boolean = false, param6:Boolean = false, param7:uint = 0, param8:int = 0) : GameFightFighterCompanionLightInformations
      {
         super.initGameFightFighterLightInformations(param1,param2,param3,param4,param5,param6);
         this.companionId = param7;
         this.masterId = param8;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.companionId = 0;
         this.masterId = 0;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameFightFighterCompanionLightInformations(param1);
      }
      
      public function serializeAs_GameFightFighterCompanionLightInformations(param1:ICustomDataOutput) : void
      {
         super.serializeAs_GameFightFighterLightInformations(param1);
         if(this.companionId < 0)
         {
            throw new Error("Forbidden value (" + this.companionId + ") on element companionId.");
         }
         param1.writeByte(this.companionId);
         param1.writeInt(this.masterId);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameFightFighterCompanionLightInformations(param1);
      }
      
      public function deserializeAs_GameFightFighterCompanionLightInformations(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.companionId = param1.readByte();
         if(this.companionId < 0)
         {
            throw new Error("Forbidden value (" + this.companionId + ") on element of GameFightFighterCompanionLightInformations.companionId.");
         }
         this.masterId = param1.readInt();
      }
   }
}
