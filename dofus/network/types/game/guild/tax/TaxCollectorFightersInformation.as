package com.ankamagames.dofus.network.types.game.guild.tax
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalPlusLookInformations;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class TaxCollectorFightersInformation implements INetworkType
   {
      
      public static const protocolId:uint = 169;
       
      
      public var collectorId:int = 0;
      
      public var allyCharactersInformations:Vector.<CharacterMinimalPlusLookInformations>;
      
      public var enemyCharactersInformations:Vector.<CharacterMinimalPlusLookInformations>;
      
      public function TaxCollectorFightersInformation()
      {
         this.allyCharactersInformations = new Vector.<CharacterMinimalPlusLookInformations>();
         this.enemyCharactersInformations = new Vector.<CharacterMinimalPlusLookInformations>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 169;
      }
      
      public function initTaxCollectorFightersInformation(param1:int = 0, param2:Vector.<CharacterMinimalPlusLookInformations> = null, param3:Vector.<CharacterMinimalPlusLookInformations> = null) : TaxCollectorFightersInformation
      {
         this.collectorId = param1;
         this.allyCharactersInformations = param2;
         this.enemyCharactersInformations = param3;
         return this;
      }
      
      public function reset() : void
      {
         this.collectorId = 0;
         this.allyCharactersInformations = new Vector.<CharacterMinimalPlusLookInformations>();
         this.enemyCharactersInformations = new Vector.<CharacterMinimalPlusLookInformations>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_TaxCollectorFightersInformation(param1);
      }
      
      public function serializeAs_TaxCollectorFightersInformation(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         param1.writeInt(this.collectorId);
         param1.writeShort(this.allyCharactersInformations.length);
         while(_loc2_ < this.allyCharactersInformations.length)
         {
            param1.writeShort((this.allyCharactersInformations[_loc2_] as CharacterMinimalPlusLookInformations).getTypeId());
            (this.allyCharactersInformations[_loc2_] as CharacterMinimalPlusLookInformations).serialize(param1);
            _loc2_++;
         }
         param1.writeShort(this.enemyCharactersInformations.length);
         while(_loc3_ < this.enemyCharactersInformations.length)
         {
            param1.writeShort((this.enemyCharactersInformations[_loc3_] as CharacterMinimalPlusLookInformations).getTypeId());
            (this.enemyCharactersInformations[_loc3_] as CharacterMinimalPlusLookInformations).serialize(param1);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_TaxCollectorFightersInformation(param1);
      }
      
      public function deserializeAs_TaxCollectorFightersInformation(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:CharacterMinimalPlusLookInformations = null;
         var _loc4_:uint = 0;
         var _loc5_:CharacterMinimalPlusLookInformations = null;
         var _loc7_:uint = 0;
         var _loc9_:uint = 0;
         this.collectorId = param1.readInt();
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(CharacterMinimalPlusLookInformations,_loc2_);
            _loc3_.deserialize(param1);
            this.allyCharactersInformations.push(_loc3_);
            _loc7_++;
         }
         var _loc8_:uint = param1.readUnsignedShort();
         while(_loc9_ < _loc8_)
         {
            _loc4_ = param1.readUnsignedShort();
            (_loc5_ = ProtocolTypeManager.getInstance(CharacterMinimalPlusLookInformations,_loc4_)).deserialize(param1);
            this.enemyCharactersInformations.push(_loc5_);
            _loc9_++;
         }
      }
   }
}
