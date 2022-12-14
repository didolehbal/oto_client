package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.dofus.network.types.game.guild.GuildMember;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GuildInformationsMembersMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5558;
       
      
      private var _isInitialized:Boolean = false;
      
      public var members:Vector.<GuildMember>;
      
      public function GuildInformationsMembersMessage()
      {
         this.members = new Vector.<GuildMember>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5558;
      }
      
      public function initGuildInformationsMembersMessage(param1:Vector.<GuildMember> = null) : GuildInformationsMembersMessage
      {
         this.members = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.members = new Vector.<GuildMember>();
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
         this.serializeAs_GuildInformationsMembersMessage(param1);
      }
      
      public function serializeAs_GuildInformationsMembersMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.members.length);
         while(_loc2_ < this.members.length)
         {
            (this.members[_loc2_] as GuildMember).serializeAs_GuildMember(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GuildInformationsMembersMessage(param1);
      }
      
      public function deserializeAs_GuildInformationsMembersMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:GuildMember = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new GuildMember();
            _loc2_.deserialize(param1);
            this.members.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
