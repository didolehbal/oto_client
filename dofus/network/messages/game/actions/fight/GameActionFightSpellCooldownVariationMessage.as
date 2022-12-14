package com.ankamagames.dofus.network.messages.game.actions.fight
{
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameActionFightSpellCooldownVariationMessage extends AbstractGameActionMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6219;
       
      
      private var _isInitialized:Boolean = false;
      
      public var targetId:int = 0;
      
      public var spellId:uint = 0;
      
      public var value:int = 0;
      
      public function GameActionFightSpellCooldownVariationMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6219;
      }
      
      public function initGameActionFightSpellCooldownVariationMessage(param1:uint = 0, param2:int = 0, param3:int = 0, param4:uint = 0, param5:int = 0) : GameActionFightSpellCooldownVariationMessage
      {
         super.initAbstractGameActionMessage(param1,param2);
         this.targetId = param3;
         this.spellId = param4;
         this.value = param5;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.targetId = 0;
         this.spellId = 0;
         this.value = 0;
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
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameActionFightSpellCooldownVariationMessage(param1);
      }
      
      public function serializeAs_GameActionFightSpellCooldownVariationMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_AbstractGameActionMessage(param1);
         param1.writeInt(this.targetId);
         if(this.spellId < 0)
         {
            throw new Error("Forbidden value (" + this.spellId + ") on element spellId.");
         }
         param1.writeVarShort(this.spellId);
         param1.writeVarShort(this.value);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameActionFightSpellCooldownVariationMessage(param1);
      }
      
      public function deserializeAs_GameActionFightSpellCooldownVariationMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.targetId = param1.readInt();
         this.spellId = param1.readVarUhShort();
         if(this.spellId < 0)
         {
            throw new Error("Forbidden value (" + this.spellId + ") on element of GameActionFightSpellCooldownVariationMessage.spellId.");
         }
         this.value = param1.readVarShort();
      }
   }
}
