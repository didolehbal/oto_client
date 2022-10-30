package com.ankamagames.dofus.network.messages.game.context.fight
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.data.items.SpellItem;
   import com.ankamagames.dofus.network.types.game.shortcut.Shortcut;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class SlaveSwitchContextMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6214;
       
      
      private var _isInitialized:Boolean = false;
      
      public var masterId:int = 0;
      
      public var slaveId:int = 0;
      
      public var slaveSpells:Vector.<SpellItem>;
      
      public var slaveStats:CharacterCharacteristicsInformations;
      
      public var shortcuts:Vector.<Shortcut>;
      
      public function SlaveSwitchContextMessage()
      {
         this.slaveSpells = new Vector.<SpellItem>();
         this.slaveStats = new CharacterCharacteristicsInformations();
         this.shortcuts = new Vector.<Shortcut>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6214;
      }
      
      public function initSlaveSwitchContextMessage(param1:int = 0, param2:int = 0, param3:Vector.<SpellItem> = null, param4:CharacterCharacteristicsInformations = null, param5:Vector.<Shortcut> = null) : SlaveSwitchContextMessage
      {
         this.masterId = param1;
         this.slaveId = param2;
         this.slaveSpells = param3;
         this.slaveStats = param4;
         this.shortcuts = param5;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.masterId = 0;
         this.slaveId = 0;
         this.slaveSpells = new Vector.<SpellItem>();
         this.slaveStats = new CharacterCharacteristicsInformations();
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
         this.serializeAs_SlaveSwitchContextMessage(param1);
      }
      
      public function serializeAs_SlaveSwitchContextMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         param1.writeInt(this.masterId);
         param1.writeInt(this.slaveId);
         param1.writeShort(this.slaveSpells.length);
         while(_loc2_ < this.slaveSpells.length)
         {
            (this.slaveSpells[_loc2_] as SpellItem).serializeAs_SpellItem(param1);
            _loc2_++;
         }
         this.slaveStats.serializeAs_CharacterCharacteristicsInformations(param1);
         param1.writeShort(this.shortcuts.length);
         while(_loc3_ < this.shortcuts.length)
         {
            param1.writeShort((this.shortcuts[_loc3_] as Shortcut).getTypeId());
            (this.shortcuts[_loc3_] as Shortcut).serialize(param1);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_SlaveSwitchContextMessage(param1);
      }
      
      public function deserializeAs_SlaveSwitchContextMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:SpellItem = null;
         var _loc3_:uint = 0;
         var _loc4_:Shortcut = null;
         var _loc6_:uint = 0;
         var _loc8_:uint = 0;
         this.masterId = param1.readInt();
         this.slaveId = param1.readInt();
         var _loc5_:uint = param1.readUnsignedShort();
         while(_loc6_ < _loc5_)
         {
            _loc2_ = new SpellItem();
            _loc2_.deserialize(param1);
            this.slaveSpells.push(_loc2_);
            _loc6_++;
         }
         this.slaveStats = new CharacterCharacteristicsInformations();
         this.slaveStats.deserialize(param1);
         var _loc7_:uint = param1.readUnsignedShort();
         while(_loc8_ < _loc7_)
         {
            _loc3_ = param1.readUnsignedShort();
            (_loc4_ = ProtocolTypeManager.getInstance(Shortcut,_loc3_)).deserialize(param1);
            this.shortcuts.push(_loc4_);
            _loc8_++;
         }
      }
   }
}
