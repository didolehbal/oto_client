package com.ankamagames.dofus.network.messages.game.alliance
{
   import com.ankamagames.dofus.network.types.game.social.AllianceFactSheetInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class AllianceListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6408;
       
      
      private var _isInitialized:Boolean = false;
      
      public var alliances:Vector.<AllianceFactSheetInformations>;
      
      public function AllianceListMessage()
      {
         this.alliances = new Vector.<AllianceFactSheetInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6408;
      }
      
      public function initAllianceListMessage(param1:Vector.<AllianceFactSheetInformations> = null) : AllianceListMessage
      {
         this.alliances = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.alliances = new Vector.<AllianceFactSheetInformations>();
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
         this.serializeAs_AllianceListMessage(param1);
      }
      
      public function serializeAs_AllianceListMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.alliances.length);
         while(_loc2_ < this.alliances.length)
         {
            (this.alliances[_loc2_] as AllianceFactSheetInformations).serializeAs_AllianceFactSheetInformations(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_AllianceListMessage(param1);
      }
      
      public function deserializeAs_AllianceListMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:AllianceFactSheetInformations = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new AllianceFactSheetInformations();
            _loc2_.deserialize(param1);
            this.alliances.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
