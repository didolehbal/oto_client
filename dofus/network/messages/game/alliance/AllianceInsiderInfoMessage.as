package com.ankamagames.dofus.network.messages.game.alliance
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.prism.PrismSubareaEmptyInfo;
   import com.ankamagames.dofus.network.types.game.social.AllianceFactSheetInformations;
   import com.ankamagames.dofus.network.types.game.social.GuildInsiderFactSheetInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class AllianceInsiderInfoMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6403;
       
      
      private var _isInitialized:Boolean = false;
      
      public var allianceInfos:AllianceFactSheetInformations;
      
      public var guilds:Vector.<GuildInsiderFactSheetInformations>;
      
      public var prisms:Vector.<PrismSubareaEmptyInfo>;
      
      public function AllianceInsiderInfoMessage()
      {
         this.allianceInfos = new AllianceFactSheetInformations();
         this.guilds = new Vector.<GuildInsiderFactSheetInformations>();
         this.prisms = new Vector.<PrismSubareaEmptyInfo>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6403;
      }
      
      public function initAllianceInsiderInfoMessage(param1:AllianceFactSheetInformations = null, param2:Vector.<GuildInsiderFactSheetInformations> = null, param3:Vector.<PrismSubareaEmptyInfo> = null) : AllianceInsiderInfoMessage
      {
         this.allianceInfos = param1;
         this.guilds = param2;
         this.prisms = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.allianceInfos = new AllianceFactSheetInformations();
         this.prisms = new Vector.<PrismSubareaEmptyInfo>();
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
         this.serializeAs_AllianceInsiderInfoMessage(param1);
      }
      
      public function serializeAs_AllianceInsiderInfoMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.allianceInfos.serializeAs_AllianceFactSheetInformations(param1);
         param1.writeShort(this.guilds.length);
         while(_loc2_ < this.guilds.length)
         {
            (this.guilds[_loc2_] as GuildInsiderFactSheetInformations).serializeAs_GuildInsiderFactSheetInformations(param1);
            _loc2_++;
         }
         param1.writeShort(this.prisms.length);
         while(_loc3_ < this.prisms.length)
         {
            param1.writeShort((this.prisms[_loc3_] as PrismSubareaEmptyInfo).getTypeId());
            (this.prisms[_loc3_] as PrismSubareaEmptyInfo).serialize(param1);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_AllianceInsiderInfoMessage(param1);
      }
      
      public function deserializeAs_AllianceInsiderInfoMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:GuildInsiderFactSheetInformations = null;
         var _loc3_:uint = 0;
         var _loc4_:PrismSubareaEmptyInfo = null;
         var _loc6_:uint = 0;
         var _loc8_:uint = 0;
         this.allianceInfos = new AllianceFactSheetInformations();
         this.allianceInfos.deserialize(param1);
         var _loc5_:uint = param1.readUnsignedShort();
         while(_loc6_ < _loc5_)
         {
            _loc2_ = new GuildInsiderFactSheetInformations();
            _loc2_.deserialize(param1);
            this.guilds.push(_loc2_);
            _loc6_++;
         }
         var _loc7_:uint = param1.readUnsignedShort();
         while(_loc8_ < _loc7_)
         {
            _loc3_ = param1.readUnsignedShort();
            (_loc4_ = ProtocolTypeManager.getInstance(PrismSubareaEmptyInfo,_loc3_)).deserialize(param1);
            this.prisms.push(_loc4_);
            _loc8_++;
         }
      }
   }
}
