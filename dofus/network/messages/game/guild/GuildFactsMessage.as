package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalInformations;
   import com.ankamagames.dofus.network.types.game.social.GuildFactSheetInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GuildFactsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6415;
       
      
      private var _isInitialized:Boolean = false;
      
      public var infos:GuildFactSheetInformations;
      
      public var creationDate:uint = 0;
      
      public var nbTaxCollectors:uint = 0;
      
      public var enabled:Boolean = false;
      
      public var members:Vector.<CharacterMinimalInformations>;
      
      public function GuildFactsMessage()
      {
         this.infos = new GuildFactSheetInformations();
         this.members = new Vector.<CharacterMinimalInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6415;
      }
      
      public function initGuildFactsMessage(param1:GuildFactSheetInformations = null, param2:uint = 0, param3:uint = 0, param4:Boolean = false, param5:Vector.<CharacterMinimalInformations> = null) : GuildFactsMessage
      {
         this.infos = param1;
         this.creationDate = param2;
         this.nbTaxCollectors = param3;
         this.enabled = param4;
         this.members = param5;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.infos = new GuildFactSheetInformations();
         this.nbTaxCollectors = 0;
         this.enabled = false;
         this.members = new Vector.<CharacterMinimalInformations>();
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
         this.serializeAs_GuildFactsMessage(param1);
      }
      
      public function serializeAs_GuildFactsMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.infos.getTypeId());
         this.infos.serialize(param1);
         if(this.creationDate < 0)
         {
            throw new Error("Forbidden value (" + this.creationDate + ") on element creationDate.");
         }
         param1.writeInt(this.creationDate);
         if(this.nbTaxCollectors < 0)
         {
            throw new Error("Forbidden value (" + this.nbTaxCollectors + ") on element nbTaxCollectors.");
         }
         param1.writeVarShort(this.nbTaxCollectors);
         param1.writeBoolean(this.enabled);
         param1.writeShort(this.members.length);
         while(_loc2_ < this.members.length)
         {
            (this.members[_loc2_] as CharacterMinimalInformations).serializeAs_CharacterMinimalInformations(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GuildFactsMessage(param1);
      }
      
      public function deserializeAs_GuildFactsMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:CharacterMinimalInformations = null;
         var _loc5_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         this.infos = ProtocolTypeManager.getInstance(GuildFactSheetInformations,_loc3_);
         this.infos.deserialize(param1);
         this.creationDate = param1.readInt();
         if(this.creationDate < 0)
         {
            throw new Error("Forbidden value (" + this.creationDate + ") on element of GuildFactsMessage.creationDate.");
         }
         this.nbTaxCollectors = param1.readVarUhShort();
         if(this.nbTaxCollectors < 0)
         {
            throw new Error("Forbidden value (" + this.nbTaxCollectors + ") on element of GuildFactsMessage.nbTaxCollectors.");
         }
         this.enabled = param1.readBoolean();
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = new CharacterMinimalInformations();
            _loc2_.deserialize(param1);
            this.members.push(_loc2_);
            _loc5_++;
         }
      }
   }
}
