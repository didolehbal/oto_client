package com.ankamagames.dofus.network.messages.game.context.roleplay.objects
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ObjectGroundListAddedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5925;
       
      
      private var _isInitialized:Boolean = false;
      
      public var cells:Vector.<uint>;
      
      public var referenceIds:Vector.<uint>;
      
      public function ObjectGroundListAddedMessage()
      {
         this.cells = new Vector.<uint>();
         this.referenceIds = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5925;
      }
      
      public function initObjectGroundListAddedMessage(param1:Vector.<uint> = null, param2:Vector.<uint> = null) : ObjectGroundListAddedMessage
      {
         this.cells = param1;
         this.referenceIds = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.cells = new Vector.<uint>();
         this.referenceIds = new Vector.<uint>();
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
         this.serializeAs_ObjectGroundListAddedMessage(param1);
      }
      
      public function serializeAs_ObjectGroundListAddedMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         param1.writeShort(this.cells.length);
         while(_loc2_ < this.cells.length)
         {
            if(this.cells[_loc2_] < 0 || this.cells[_loc2_] > 559)
            {
               throw new Error("Forbidden value (" + this.cells[_loc2_] + ") on element 1 (starting at 1) of cells.");
            }
            param1.writeVarShort(this.cells[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.referenceIds.length);
         while(_loc3_ < this.referenceIds.length)
         {
            if(this.referenceIds[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.referenceIds[_loc3_] + ") on element 2 (starting at 1) of referenceIds.");
            }
            param1.writeVarShort(this.referenceIds[_loc3_]);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ObjectGroundListAddedMessage(param1);
      }
      
      public function deserializeAs_ObjectGroundListAddedMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readVarUhShort();
            if(_loc2_ < 0 || _loc2_ > 559)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of cells.");
            }
            this.cells.push(_loc2_);
            _loc5_++;
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc3_ = param1.readVarUhShort();
            if(_loc3_ < 0)
            {
               throw new Error("Forbidden value (" + _loc3_ + ") on elements of referenceIds.");
            }
            this.referenceIds.push(_loc3_);
            _loc7_++;
         }
      }
   }
}
