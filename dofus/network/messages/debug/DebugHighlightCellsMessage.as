package com.ankamagames.dofus.network.messages.debug
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class DebugHighlightCellsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 2001;
       
      
      private var _isInitialized:Boolean = false;
      
      public var color:int = 0;
      
      public var cells:Vector.<uint>;
      
      public function DebugHighlightCellsMessage()
      {
         this.cells = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 2001;
      }
      
      public function initDebugHighlightCellsMessage(param1:int = 0, param2:Vector.<uint> = null) : DebugHighlightCellsMessage
      {
         this.color = param1;
         this.cells = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.color = 0;
         this.cells = new Vector.<uint>();
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
         this.serializeAs_DebugHighlightCellsMessage(param1);
      }
      
      public function serializeAs_DebugHighlightCellsMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeInt(this.color);
         param1.writeShort(this.cells.length);
         while(_loc2_ < this.cells.length)
         {
            if(this.cells[_loc2_] < 0 || this.cells[_loc2_] > 559)
            {
               throw new Error("Forbidden value (" + this.cells[_loc2_] + ") on element 2 (starting at 1) of cells.");
            }
            param1.writeVarShort(this.cells[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_DebugHighlightCellsMessage(param1);
      }
      
      public function deserializeAs_DebugHighlightCellsMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         this.color = param1.readInt();
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readVarUhShort();
            if(_loc2_ < 0 || _loc2_ > 559)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of cells.");
            }
            this.cells.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
