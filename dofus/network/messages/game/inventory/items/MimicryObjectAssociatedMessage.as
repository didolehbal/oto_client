package com.ankamagames.dofus.network.messages.game.inventory.items
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class MimicryObjectAssociatedMessage extends SymbioticObjectAssociatedMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6462;
       
      
      private var _isInitialized:Boolean = false;
      
      public function MimicryObjectAssociatedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6462;
      }
      
      public function initMimicryObjectAssociatedMessage(param1:uint = 0) : MimicryObjectAssociatedMessage
      {
         super.initSymbioticObjectAssociatedMessage(param1);
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
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
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_MimicryObjectAssociatedMessage(param1);
      }
      
      public function serializeAs_MimicryObjectAssociatedMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_SymbioticObjectAssociatedMessage(param1);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_MimicryObjectAssociatedMessage(param1);
      }
      
      public function deserializeAs_MimicryObjectAssociatedMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
      }
   }
}
