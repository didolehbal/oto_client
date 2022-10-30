package com.ankamagames.dofus.network.messages.game.guild.tax
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class AbstractTaxCollectorListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6568;
       
      
      private var _isInitialized:Boolean = false;
      
      public var informations:Vector.<TaxCollectorInformations>;
      
      public function AbstractTaxCollectorListMessage()
      {
         this.informations = new Vector.<TaxCollectorInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6568;
      }
      
      public function initAbstractTaxCollectorListMessage(param1:Vector.<TaxCollectorInformations> = null) : AbstractTaxCollectorListMessage
      {
         this.informations = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.informations = new Vector.<TaxCollectorInformations>();
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
         this.serializeAs_AbstractTaxCollectorListMessage(param1);
      }
      
      public function serializeAs_AbstractTaxCollectorListMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.informations.length);
         while(_loc2_ < this.informations.length)
         {
            param1.writeShort((this.informations[_loc2_] as TaxCollectorInformations).getTypeId());
            (this.informations[_loc2_] as TaxCollectorInformations).serialize(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_AbstractTaxCollectorListMessage(param1);
      }
      
      public function deserializeAs_AbstractTaxCollectorListMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TaxCollectorInformations = null;
         var _loc5_:uint = 0;
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(TaxCollectorInformations,_loc2_);
            _loc3_.deserialize(param1);
            this.informations.push(_loc3_);
            _loc5_++;
         }
      }
   }
}
