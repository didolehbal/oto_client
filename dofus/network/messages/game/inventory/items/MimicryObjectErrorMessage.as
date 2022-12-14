package com.ankamagames.dofus.network.messages.game.inventory.items
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class MimicryObjectErrorMessage extends SymbioticObjectErrorMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6461;
       
      
      private var _isInitialized:Boolean = false;
      
      public var preview:Boolean = false;
      
      public function MimicryObjectErrorMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6461;
      }
      
      public function initMimicryObjectErrorMessage(param1:int = 0, param2:int = 0, param3:Boolean = false) : MimicryObjectErrorMessage
      {
         super.initSymbioticObjectErrorMessage(param1,param2);
         this.preview = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.preview = false;
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
         this.serializeAs_MimicryObjectErrorMessage(param1);
      }
      
      public function serializeAs_MimicryObjectErrorMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_SymbioticObjectErrorMessage(param1);
         param1.writeBoolean(this.preview);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_MimicryObjectErrorMessage(param1);
      }
      
      public function deserializeAs_MimicryObjectErrorMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.preview = param1.readBoolean();
      }
   }
}
