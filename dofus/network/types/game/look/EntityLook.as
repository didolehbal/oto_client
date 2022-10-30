package com.ankamagames.dofus.network.types.game.look
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class EntityLook implements INetworkType
   {
      
      public static const protocolId:uint = 55;
       
      
      public var bonesId:uint = 0;
      
      public var skins:Vector.<uint>;
      
      public var indexedColors:Vector.<int>;
      
      public var scales:Vector.<int>;
      
      public var subentities:Vector.<SubEntity>;
      
      public function EntityLook()
      {
         this.skins = new Vector.<uint>();
         this.indexedColors = new Vector.<int>();
         this.scales = new Vector.<int>();
         this.subentities = new Vector.<SubEntity>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 55;
      }
      
      public function initEntityLook(param1:uint = 0, param2:Vector.<uint> = null, param3:Vector.<int> = null, param4:Vector.<int> = null, param5:Vector.<SubEntity> = null) : EntityLook
      {
         this.bonesId = param1;
         this.skins = param2;
         this.indexedColors = param3;
         this.scales = param4;
         this.subentities = param5;
         return this;
      }
      
      public function reset() : void
      {
         this.bonesId = 0;
         this.skins = new Vector.<uint>();
         this.indexedColors = new Vector.<int>();
         this.scales = new Vector.<int>();
         this.subentities = new Vector.<SubEntity>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_EntityLook(param1);
      }
      
      public function serializeAs_EntityLook(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(this.bonesId < 0)
         {
            throw new Error("Forbidden value (" + this.bonesId + ") on element bonesId.");
         }
         param1.writeVarShort(this.bonesId);
         param1.writeShort(this.skins.length);
         while(_loc2_ < this.skins.length)
         {
            if(this.skins[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.skins[_loc2_] + ") on element 2 (starting at 1) of skins.");
            }
            param1.writeVarShort(this.skins[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.indexedColors.length);
         while(_loc3_ < this.indexedColors.length)
         {
            param1.writeInt(this.indexedColors[_loc3_]);
            _loc3_++;
         }
         param1.writeShort(this.scales.length);
         while(_loc4_ < this.scales.length)
         {
            param1.writeVarShort(this.scales[_loc4_]);
            _loc4_++;
         }
         param1.writeShort(this.subentities.length);
         while(_loc5_ < this.subentities.length)
         {
            (this.subentities[_loc5_] as SubEntity).serializeAs_SubEntity(param1);
            _loc5_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_EntityLook(param1);
      }
      
      public function deserializeAs_EntityLook(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:SubEntity = null;
         var _loc7_:uint = 0;
         var _loc9_:uint = 0;
         var _loc11_:uint = 0;
         var _loc13_:uint = 0;
         this.bonesId = param1.readVarUhShort();
         if(this.bonesId < 0)
         {
            throw new Error("Forbidden value (" + this.bonesId + ") on element of EntityLook.bonesId.");
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc2_ = param1.readVarUhShort();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of skins.");
            }
            this.skins.push(_loc2_);
            _loc7_++;
         }
         var _loc8_:uint = param1.readUnsignedShort();
         while(_loc9_ < _loc8_)
         {
            _loc3_ = param1.readInt();
            this.indexedColors.push(_loc3_);
            _loc9_++;
         }
         var _loc10_:uint = param1.readUnsignedShort();
         while(_loc11_ < _loc10_)
         {
            _loc4_ = param1.readVarShort();
            this.scales.push(_loc4_);
            _loc11_++;
         }
         var _loc12_:uint = param1.readUnsignedShort();
         while(_loc13_ < _loc12_)
         {
            (_loc5_ = new SubEntity()).deserialize(param1);
            this.subentities.push(_loc5_);
            _loc13_++;
         }
      }
   }
}
