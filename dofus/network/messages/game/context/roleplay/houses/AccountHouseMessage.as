package com.ankamagames.dofus.network.messages.game.context.roleplay.houses
{
   import com.ankamagames.dofus.network.types.game.house.AccountHouseInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class AccountHouseMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6315;
       
      
      private var _isInitialized:Boolean = false;
      
      public var houses:Vector.<AccountHouseInformations>;
      
      public function AccountHouseMessage()
      {
         this.houses = new Vector.<AccountHouseInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6315;
      }
      
      public function initAccountHouseMessage(param1:Vector.<AccountHouseInformations> = null) : AccountHouseMessage
      {
         this.houses = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.houses = new Vector.<AccountHouseInformations>();
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
         this.serializeAs_AccountHouseMessage(param1);
      }
      
      public function serializeAs_AccountHouseMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.houses.length);
         while(_loc2_ < this.houses.length)
         {
            (this.houses[_loc2_] as AccountHouseInformations).serializeAs_AccountHouseInformations(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_AccountHouseMessage(param1);
      }
      
      public function deserializeAs_AccountHouseMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:AccountHouseInformations = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new AccountHouseInformations();
            _loc2_.deserialize(param1);
            this.houses.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
