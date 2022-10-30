package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GuildModificationNameValidMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6327;
       
      
      private var _isInitialized:Boolean = false;
      
      public var guildName:String = "";
      
      public function GuildModificationNameValidMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6327;
      }
      
      public function initGuildModificationNameValidMessage(param1:String = "") : GuildModificationNameValidMessage
      {
         this.guildName = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.guildName = "";
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
         this.serializeAs_GuildModificationNameValidMessage(param1);
      }
      
      public function serializeAs_GuildModificationNameValidMessage(param1:ICustomDataOutput) : void
      {
         param1.writeUTF(this.guildName);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GuildModificationNameValidMessage(param1);
      }
      
      public function deserializeAs_GuildModificationNameValidMessage(param1:ICustomDataInput) : void
      {
         this.guildName = param1.readUTF();
      }
   }
}
