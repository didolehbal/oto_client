package com.ankamagames.dofus.network.types.game.context.roleplay.quest
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class GameRolePlayNpcQuestFlag implements INetworkType
   {
      
      public static const protocolId:uint = 384;
       
      
      public var questsToValidId:Vector.<uint>;
      
      public var questsToStartId:Vector.<uint>;
      
      public function GameRolePlayNpcQuestFlag()
      {
         this.questsToValidId = new Vector.<uint>();
         this.questsToStartId = new Vector.<uint>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 384;
      }
      
      public function initGameRolePlayNpcQuestFlag(param1:Vector.<uint> = null, param2:Vector.<uint> = null) : GameRolePlayNpcQuestFlag
      {
         this.questsToValidId = param1;
         this.questsToStartId = param2;
         return this;
      }
      
      public function reset() : void
      {
         this.questsToValidId = new Vector.<uint>();
         this.questsToStartId = new Vector.<uint>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameRolePlayNpcQuestFlag(param1);
      }
      
      public function serializeAs_GameRolePlayNpcQuestFlag(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         param1.writeShort(this.questsToValidId.length);
         while(_loc2_ < this.questsToValidId.length)
         {
            if(this.questsToValidId[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.questsToValidId[_loc2_] + ") on element 1 (starting at 1) of questsToValidId.");
            }
            param1.writeVarShort(this.questsToValidId[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.questsToStartId.length);
         while(_loc3_ < this.questsToStartId.length)
         {
            if(this.questsToStartId[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.questsToStartId[_loc3_] + ") on element 2 (starting at 1) of questsToStartId.");
            }
            param1.writeVarShort(this.questsToStartId[_loc3_]);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameRolePlayNpcQuestFlag(param1);
      }
      
      public function deserializeAs_GameRolePlayNpcQuestFlag(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readVarUhShort();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of questsToValidId.");
            }
            this.questsToValidId.push(_loc2_);
            _loc5_++;
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc3_ = param1.readVarUhShort();
            if(_loc3_ < 0)
            {
               throw new Error("Forbidden value (" + _loc3_ + ") on elements of questsToStartId.");
            }
            this.questsToStartId.push(_loc3_);
            _loc7_++;
         }
      }
   }
}
