package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameContextKickMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6081;
       
      
      private var _isInitialized:Boolean = false;
      
      public var targetId:int = 0;
      
      public function GameContextKickMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6081;
      }
      
      public function initGameContextKickMessage(param1:int = 0) : GameContextKickMessage
      {
         this.targetId = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.targetId = 0;
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
         this.serializeAs_GameContextKickMessage(param1);
      }
      
      public function serializeAs_GameContextKickMessage(param1:ICustomDataOutput) : void
      {
         param1.writeInt(this.targetId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameContextKickMessage(param1);
      }
      
      public function deserializeAs_GameContextKickMessage(param1:ICustomDataInput) : void
      {
         this.targetId = param1.readInt();
      }
   }
}
