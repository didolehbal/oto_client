package com.ankamagames.dofus.network.types.game.character.choice
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class RemodelingInformation implements INetworkType
   {
      
      public static const protocolId:uint = 480;
       
      
      public var name:String = "";
      
      public var breed:int = 0;
      
      public var sex:Boolean = false;
      
      public var cosmeticId:uint = 0;
      
      public var colors:Vector.<int>;
      
      public function RemodelingInformation()
      {
         this.colors = new Vector.<int>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 480;
      }
      
      public function initRemodelingInformation(param1:String = "", param2:int = 0, param3:Boolean = false, param4:uint = 0, param5:Vector.<int> = null) : RemodelingInformation
      {
         this.name = param1;
         this.breed = param2;
         this.sex = param3;
         this.cosmeticId = param4;
         this.colors = param5;
         return this;
      }
      
      public function reset() : void
      {
         this.name = "";
         this.breed = 0;
         this.sex = false;
         this.cosmeticId = 0;
         this.colors = new Vector.<int>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_RemodelingInformation(param1);
      }
      
      public function serializeAs_RemodelingInformation(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
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
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_RemodelingInformation(param1);
      }
      
      public function deserializeAs_RemodelingInformation(param1:ICustomDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc4_:uint = 0;
         this.name = param1.readUTF();
         this.breed = param1.readByte();
         this.sex = param1.readBoolean();
         this.cosmeticId = param1.readVarUhShort();
         if(this.cosmeticId < 0)
         {
            throw new Error("Forbidden value (" + this.cosmeticId + ") on element of RemodelingInformation.cosmeticId.");
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
