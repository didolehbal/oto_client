package com.ankamagames.dofus.network.messages.game.context.roleplay.death
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class WarnOnPermaDeathMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6512;
       
      
      private var _isInitialized:Boolean = false;
      
      public var enable:Boolean = false;
      
      public function WarnOnPermaDeathMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6512;
      }
      
      public function initWarnOnPermaDeathMessage(param1:Boolean = false) : WarnOnPermaDeathMessage
      {
         this.enable = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.enable = false;
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
         this.serializeAs_WarnOnPermaDeathMessage(param1);
      }
      
      public function serializeAs_WarnOnPermaDeathMessage(param1:ICustomDataOutput) : void
      {
         param1.writeBoolean(this.enable);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_WarnOnPermaDeathMessage(param1);
      }
      
      public function deserializeAs_WarnOnPermaDeathMessage(param1:ICustomDataInput) : void
      {
         this.enable = param1.readBoolean();
      }
   }
}
