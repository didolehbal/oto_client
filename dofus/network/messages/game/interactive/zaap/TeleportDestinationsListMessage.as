package com.ankamagames.dofus.network.messages.game.interactive.zaap
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class TeleportDestinationsListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5960;
       
      
      private var _isInitialized:Boolean = false;
      
      public var teleporterType:uint = 0;
      
      public var mapIds:Vector.<uint>;
      
      public var subAreaIds:Vector.<uint>;
      
      public var costs:Vector.<uint>;
      
      public var destTeleporterType:Vector.<uint>;
      
      public function TeleportDestinationsListMessage()
      {
         this.mapIds = new Vector.<uint>();
         this.subAreaIds = new Vector.<uint>();
         this.costs = new Vector.<uint>();
         this.destTeleporterType = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5960;
      }
      
      public function initTeleportDestinationsListMessage(param1:uint = 0, param2:Vector.<uint> = null, param3:Vector.<uint> = null, param4:Vector.<uint> = null, param5:Vector.<uint> = null) : TeleportDestinationsListMessage
      {
         this.teleporterType = param1;
         this.mapIds = param2;
         this.subAreaIds = param3;
         this.costs = param4;
         this.destTeleporterType = param5;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.teleporterType = 0;
         this.mapIds = new Vector.<uint>();
         this.subAreaIds = new Vector.<uint>();
         this.costs = new Vector.<uint>();
         this.destTeleporterType = new Vector.<uint>();
         this._isInitialized = false;
      }
      
      override public function pack(param1:ICustomDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(new CustomDataWrapper(_loc2_));
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:ICustomDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_TeleportDestinationsListMessage(param1);
      }
      
      public function serializeAs_TeleportDestinationsListMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         param1.writeByte(this.teleporterType);
         param1.writeShort(this.mapIds.length);
         while(_loc2_ < this.mapIds.length)
         {
            if(this.mapIds[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.mapIds[_loc2_] + ") on element 2 (starting at 1) of mapIds.");
            }
            param1.writeInt(this.mapIds[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.subAreaIds.length);
         while(_loc3_ < this.subAreaIds.length)
         {
            if(this.subAreaIds[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.subAreaIds[_loc3_] + ") on element 3 (starting at 1) of subAreaIds.");
            }
            param1.writeVarShort(this.subAreaIds[_loc3_]);
            _loc3_++;
         }
         param1.writeShort(this.costs.length);
         while(_loc4_ < this.costs.length)
         {
            if(this.costs[_loc4_] < 0)
            {
               throw new Error("Forbidden value (" + this.costs[_loc4_] + ") on element 4 (starting at 1) of costs.");
            }
            param1.writeVarShort(this.costs[_loc4_]);
            _loc4_++;
         }
         param1.writeShort(this.destTeleporterType.length);
         while(_loc5_ < this.destTeleporterType.length)
         {
            param1.writeByte(this.destTeleporterType[_loc5_]);
            _loc5_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_TeleportDestinationsListMessage(param1);
      }
      
      public function deserializeAs_TeleportDestinationsListMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc9_:uint = 0;
         var _loc11_:uint = 0;
         var _loc13_:uint = 0;
         this.teleporterType = param1.readByte();
         if(this.teleporterType < 0)
         {
            throw new Error("Forbidden value (" + this.teleporterType + ") on element of TeleportDestinationsListMessage.teleporterType.");
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc2_ = param1.readInt();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of mapIds.");
            }
            this.mapIds.push(_loc2_);
            _loc7_++;
         }
         var _loc8_:uint = param1.readUnsignedShort();
         while(_loc9_ < _loc8_)
         {
            _loc3_ = param1.readVarUhShort();
            if(_loc3_ < 0)
            {
               throw new Error("Forbidden value (" + _loc3_ + ") on elements of subAreaIds.");
            }
            this.subAreaIds.push(_loc3_);
            _loc9_++;
         }
         var _loc10_:uint = param1.readUnsignedShort();
         while(_loc11_ < _loc10_)
         {
            if((_loc4_ = param1.readVarUhShort()) < 0)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of costs.");
            }
            this.costs.push(_loc4_);
            _loc11_++;
         }
         var _loc12_:uint = param1.readUnsignedShort();
         while(_loc13_ < _loc12_)
         {
            if((_loc5_ = param1.readByte()) < 0)
            {
               throw new Error("Forbidden value (" + _loc5_ + ") on elements of destTeleporterType.");
            }
            this.destTeleporterType.push(_loc5_);
            _loc13_++;
         }
      }
   }
}
