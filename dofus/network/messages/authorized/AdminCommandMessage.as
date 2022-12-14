package com.ankamagames.dofus.network.messages.authorized
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class AdminCommandMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 76;
       
      
      private var _isInitialized:Boolean = false;
      
      public var content:String = "";
      
      public function AdminCommandMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 76;
      }
      
      public function initAdminCommandMessage(param1:String = "") : AdminCommandMessage
      {
         this.content = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.content = "";
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
         this.serializeAs_AdminCommandMessage(param1);
      }
      
      public function serializeAs_AdminCommandMessage(param1:ICustomDataOutput) : void
      {
         param1.writeUTF(this.content);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_AdminCommandMessage(param1);
      }
      
      public function deserializeAs_AdminCommandMessage(param1:ICustomDataInput) : void
      {
         this.content = param1.readUTF();
      }
   }
}
