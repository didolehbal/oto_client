package com.ankamagames.dofus.network.messages.game.interactive
{
   import com.ankamagames.dofus.network.types.game.interactive.StatedElement;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class StatedMapUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5716;
       
      
      private var _isInitialized:Boolean = false;
      
      public var statedElements:Vector.<StatedElement>;
      
      public function StatedMapUpdateMessage()
      {
         this.statedElements = new Vector.<StatedElement>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5716;
      }
      
      public function initStatedMapUpdateMessage(param1:Vector.<StatedElement> = null) : StatedMapUpdateMessage
      {
         this.statedElements = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.statedElements = new Vector.<StatedElement>();
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
         this.serializeAs_StatedMapUpdateMessage(param1);
      }
      
      public function serializeAs_StatedMapUpdateMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.statedElements.length);
         while(_loc2_ < this.statedElements.length)
         {
            (this.statedElements[_loc2_] as StatedElement).serializeAs_StatedElement(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_StatedMapUpdateMessage(param1);
      }
      
      public function deserializeAs_StatedMapUpdateMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:StatedElement = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new StatedElement();
            _loc2_.deserialize(param1);
            this.statedElements.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
