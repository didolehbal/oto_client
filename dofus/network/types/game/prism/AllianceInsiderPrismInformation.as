package com.ankamagames.dofus.network.types.game.prism
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class AllianceInsiderPrismInformation extends PrismInformation implements INetworkType
   {
      
      public static const protocolId:uint = 431;
       
      
      public var lastTimeSlotModificationDate:uint = 0;
      
      public var lastTimeSlotModificationAuthorGuildId:uint = 0;
      
      public var lastTimeSlotModificationAuthorId:uint = 0;
      
      public var lastTimeSlotModificationAuthorName:String = "";
      
      public var modulesItemIds:Vector.<uint>;
      
      public function AllianceInsiderPrismInformation()
      {
         this.modulesItemIds = new Vector.<uint>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 431;
      }
      
      public function initAllianceInsiderPrismInformation(param1:uint = 0, param2:uint = 1, param3:uint = 0, param4:uint = 0, param5:uint = 0, param6:uint = 0, param7:uint = 0, param8:uint = 0, param9:String = "", param10:Vector.<uint> = null) : AllianceInsiderPrismInformation
      {
         super.initPrismInformation(param1,param2,param3,param4,param5);
         this.lastTimeSlotModificationDate = param6;
         this.lastTimeSlotModificationAuthorGuildId = param7;
         this.lastTimeSlotModificationAuthorId = param8;
         this.lastTimeSlotModificationAuthorName = param9;
         this.modulesItemIds = param10;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.lastTimeSlotModificationDate = 0;
         this.lastTimeSlotModificationAuthorGuildId = 0;
         this.lastTimeSlotModificationAuthorId = 0;
         this.lastTimeSlotModificationAuthorName = "";
         this.modulesItemIds = new Vector.<uint>();
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_AllianceInsiderPrismInformation(param1);
      }
      
      public function serializeAs_AllianceInsiderPrismInformation(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         super.serializeAs_PrismInformation(param1);
         if(this.lastTimeSlotModificationDate < 0)
         {
            throw new Error("Forbidden value (" + this.lastTimeSlotModificationDate + ") on element lastTimeSlotModificationDate.");
         }
         param1.writeInt(this.lastTimeSlotModificationDate);
         if(this.lastTimeSlotModificationAuthorGuildId < 0)
         {
            throw new Error("Forbidden value (" + this.lastTimeSlotModificationAuthorGuildId + ") on element lastTimeSlotModificationAuthorGuildId.");
         }
         param1.writeVarInt(this.lastTimeSlotModificationAuthorGuildId);
         if(this.lastTimeSlotModificationAuthorId < 0)
         {
            throw new Error("Forbidden value (" + this.lastTimeSlotModificationAuthorId + ") on element lastTimeSlotModificationAuthorId.");
         }
         param1.writeVarInt(this.lastTimeSlotModificationAuthorId);
         param1.writeUTF(this.lastTimeSlotModificationAuthorName);
         param1.writeShort(this.modulesItemIds.length);
         while(_loc2_ < this.modulesItemIds.length)
         {
            if(this.modulesItemIds[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.modulesItemIds[_loc2_] + ") on element 5 (starting at 1) of modulesItemIds.");
            }
            param1.writeVarInt(this.modulesItemIds[_loc2_]);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_AllianceInsiderPrismInformation(param1);
      }
      
      public function deserializeAs_AllianceInsiderPrismInformation(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         super.deserialize(param1);
         this.lastTimeSlotModificationDate = param1.readInt();
         if(this.lastTimeSlotModificationDate < 0)
         {
            throw new Error("Forbidden value (" + this.lastTimeSlotModificationDate + ") on element of AllianceInsiderPrismInformation.lastTimeSlotModificationDate.");
         }
         this.lastTimeSlotModificationAuthorGuildId = param1.readVarUhInt();
         if(this.lastTimeSlotModificationAuthorGuildId < 0)
         {
            throw new Error("Forbidden value (" + this.lastTimeSlotModificationAuthorGuildId + ") on element of AllianceInsiderPrismInformation.lastTimeSlotModificationAuthorGuildId.");
         }
         this.lastTimeSlotModificationAuthorId = param1.readVarUhInt();
         if(this.lastTimeSlotModificationAuthorId < 0)
         {
            throw new Error("Forbidden value (" + this.lastTimeSlotModificationAuthorId + ") on element of AllianceInsiderPrismInformation.lastTimeSlotModificationAuthorId.");
         }
         this.lastTimeSlotModificationAuthorName = param1.readUTF();
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readVarUhInt();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of modulesItemIds.");
            }
            this.modulesItemIds.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
