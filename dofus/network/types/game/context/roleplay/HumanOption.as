package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class HumanOption implements INetworkType
   {
      
      public static const protocolId:uint = 406;
       
      
      public function HumanOption()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 406;
      }
      
      public function initHumanOption() : HumanOption
      {
         return this;
      }
      
      public function reset() : void
      {
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
      }
      
      public function serializeAs_HumanOption(param1:ICustomDataOutput) : void
      {
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
      }
      
      public function deserializeAs_HumanOption(param1:ICustomDataInput) : void
      {
      }
   }
}
