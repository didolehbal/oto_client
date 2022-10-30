package com.ankamagames.dofus.network.types.game.character.choice
{
   import com.ankamagames.dofus.network.types.game.character.AbstractCharacterInformation;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class CharacterRemodelingInformation extends AbstractCharacterInformation implements INetworkType
   {
      
      public static const protocolId:uint = 479;
       
      
      public var name:String = "";
      
      public var breed:int = 0;
      
      public var sex:Boolean = false;
      
      public var cosmeticId:uint = 0;
      
      public var colors:Vector.<int>;
      
      public function CharacterRemodelingInformation()
      {
         this.colors = new Vector.<int>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 479;
      }
      
      public function initCharacterRemodelingInformation(param1:uint = 0, param2:String = "", param3:int = 0, param4:Boolean = false, param5:uint = 0, param6:Vector.<int> = null) : CharacterRemodelingInformation
      {
         super.initAbstractCharacterInformation(param1);
         this.name = param2;
         this.breed = param3;
         this.sex = param4;
         this.cosmeticId = param5;
         this.colors = param6;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.name = "";
         this.breed = 0;
         this.sex = false;
         this.cosmeticId = 0;
         this.colors = new Vector.<int>();
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_CharacterRemodelingInformation(param1);
      }
      
      public function serializeAs_CharacterRemodelingInformation(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_AbstractCharacterInformation(param1);
         param1.writeUTF(this.name);
         param1.writeByte(this.breed);
         param1.writeBoolean(this.sex);
         if(this.cosmeticId < 0)
         {
            throw new Error("Forbidden value (" + this.cosmeticId + ") on element cosmeticId.");
         }
         param1.writeVarShort(this.cosmeticId);
         param1.writeShort(this.colors.length);
         while(_loc2_ < this.colors.length)
         {
            param1.writeInt(this.colors[_loc2_]);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_CharacterRemodelingInformation(param1);
      }
      
      public function deserializeAs_CharacterRemodelingInformation(param1:ICustomDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc4_:uint = 0;
         super.deserialize(param1);
         this.name = param1.readUTF();
         this.breed = param1.readByte();
         this.sex = param1.readBoolean();
         this.cosmeticId = param1.readVarUhShort();
         if(this.cosmeticId < 0)
         {
            throw new Error("Forbidden value (" + this.cosmeticId + ") on element of CharacterRemodelingInformation.cosmeticId.");
         }
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readInt();
            this.colors.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
