package com.ankamagames.dofus.network.types.game.inventory.preset
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class Preset implements INetworkType
   {
      
      public static const protocolId:uint = 355;
       
      
      public var presetId:uint = 0;
      
      public var symbolId:uint = 0;
      
      public var mount:Boolean = false;
      
      public var objects:Vector.<PresetItem>;
      
      public function Preset()
      {
         this.objects = new Vector.<PresetItem>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 355;
      }
      
      public function initPreset(param1:uint = 0, param2:uint = 0, param3:Boolean = false, param4:Vector.<PresetItem> = null) : Preset
      {
         this.presetId = param1;
         this.symbolId = param2;
         this.mount = param3;
         this.objects = param4;
         return this;
      }
      
      public function reset() : void
      {
         this.presetId = 0;
         this.symbolId = 0;
         this.mount = false;
         this.objects = new Vector.<PresetItem>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_Preset(param1);
      }
      
      public function serializeAs_Preset(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         if(this.presetId < 0)
         {
            throw new Error("Forbidden value (" + this.presetId + ") on element presetId.");
         }
         param1.writeByte(this.presetId);
         if(this.symbolId < 0)
         {
            throw new Error("Forbidden value (" + this.symbolId + ") on element symbolId.");
         }
         param1.writeByte(this.symbolId);
         param1.writeBoolean(this.mount);
         param1.writeShort(this.objects.length);
         while(_loc2_ < this.objects.length)
         {
            (this.objects[_loc2_] as PresetItem).serializeAs_PresetItem(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_Preset(param1);
      }
      
      public function deserializeAs_Preset(param1:ICustomDataInput) : void
      {
         var _loc2_:PresetItem = null;
         var _loc4_:uint = 0;
         this.presetId = param1.readByte();
         if(this.presetId < 0)
         {
            throw new Error("Forbidden value (" + this.presetId + ") on element of Preset.presetId.");
         }
         this.symbolId = param1.readByte();
         if(this.symbolId < 0)
         {
            throw new Error("Forbidden value (" + this.symbolId + ") on element of Preset.symbolId.");
         }
         this.mount = param1.readBoolean();
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new PresetItem();
            _loc2_.deserialize(param1);
            this.objects.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
