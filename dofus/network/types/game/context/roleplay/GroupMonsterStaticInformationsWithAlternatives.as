package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class GroupMonsterStaticInformationsWithAlternatives extends GroupMonsterStaticInformations implements INetworkType
   {
      
      public static const protocolId:uint = 396;
       
      
      public var alternatives:Vector.<AlternativeMonstersInGroupLightInformations>;
      
      public function GroupMonsterStaticInformationsWithAlternatives()
      {
         this.alternatives = new Vector.<AlternativeMonstersInGroupLightInformations>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 396;
      }
      
      public function initGroupMonsterStaticInformationsWithAlternatives(param1:MonsterInGroupLightInformations = null, param2:Vector.<MonsterInGroupInformations> = null, param3:Vector.<AlternativeMonstersInGroupLightInformations> = null) : GroupMonsterStaticInformationsWithAlternatives
      {
         super.initGroupMonsterStaticInformations(param1,param2);
         this.alternatives = param3;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.alternatives = new Vector.<AlternativeMonstersInGroupLightInformations>();
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GroupMonsterStaticInformationsWithAlternatives(param1);
      }
      
      public function serializeAs_GroupMonsterStaticInformationsWithAlternatives(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_GroupMonsterStaticInformations(param1);
         param1.writeShort(this.alternatives.length);
         while(_loc2_ < this.alternatives.length)
         {
            (this.alternatives[_loc2_] as AlternativeMonstersInGroupLightInformations).serializeAs_AlternativeMonstersInGroupLightInformations(param1);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GroupMonsterStaticInformationsWithAlternatives(param1);
      }
      
      public function deserializeAs_GroupMonsterStaticInformationsWithAlternatives(param1:ICustomDataInput) : void
      {
         var _loc2_:AlternativeMonstersInGroupLightInformations = null;
         var _loc4_:uint = 0;
         super.deserialize(param1);
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new AlternativeMonstersInGroupLightInformations();
            _loc2_.deserialize(param1);
            this.alternatives.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
