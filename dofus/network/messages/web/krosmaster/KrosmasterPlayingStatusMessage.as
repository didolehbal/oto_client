package com.ankamagames.dofus.network.messages.web.krosmaster
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class KrosmasterPlayingStatusMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6347;
       
      
      private var _isInitialized:Boolean = false;
      
      public var playing:Boolean = false;
      
      public function KrosmasterPlayingStatusMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6347;
      }
      
      public function initKrosmasterPlayingStatusMessage(param1:Boolean = false) : KrosmasterPlayingStatusMessage
      {
         this.playing = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.playing = false;
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
         this.serializeAs_KrosmasterPlayingStatusMessage(param1);
      }
      
      public function serializeAs_KrosmasterPlayingStatusMessage(param1:ICustomDataOutput) : void
      {
         param1.writeBoolean(this.playing);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_KrosmasterPlayingStatusMessage(param1);
      }
      
      public function deserializeAs_KrosmasterPlayingStatusMessage(param1:ICustomDataInput) : void
      {
         this.playing = param1.readBoolean();
      }
   }
}
