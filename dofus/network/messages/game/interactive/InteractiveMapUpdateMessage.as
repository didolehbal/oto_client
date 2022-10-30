package com.ankamagames.dofus.network.messages.game.interactive
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class InteractiveMapUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5002;
       
      
      private var _isInitialized:Boolean = false;
      
      public var interactiveElements:Vector.<InteractiveElement>;
      
      public function InteractiveMapUpdateMessage()
      {
         this.interactiveElements = new Vector.<InteractiveElement>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5002;
      }
      
      public function initInteractiveMapUpdateMessage(param1:Vector.<InteractiveElement> = null) : InteractiveMapUpdateMessage
      {
         this.interactiveElements = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.interactiveElements = new Vector.<InteractiveElement>();
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
         this.serializeAs_InteractiveMapUpdateMessage(param1);
      }
      
      public function serializeAs_InteractiveMapUpdateMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.interactiveElements.length);
         while(_loc2_ < this.interactiveElements.length)
         {
            param1.writeShort((this.interactiveElements[_loc2_] as InteractiveElement).getTypeId());
            (this.interactiveElements[_loc2_] as InteractiveElement).serialize(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_InteractiveMapUpdateMessage(param1);
      }
      
      public function deserializeAs_InteractiveMapUpdateMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:InteractiveElement = null;
         var _loc5_:uint = 0;
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(InteractiveElement,_loc2_);
            _loc3_.deserialize(param1);
            this.interactiveElements.push(_loc3_);
            _loc5_++;
         }
      }
   }
}
