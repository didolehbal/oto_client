package com.ankamagames.dofus.network.messages.game.context.roleplay.spell
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class SpellForgottenMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5834;
       
      
      private var _isInitialized:Boolean = false;
      
      public var spellsId:Vector.<uint>;
      
      public var boostPoint:uint = 0;
      
      public function SpellForgottenMessage()
      {
         this.spellsId = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5834;
      }
      
      public function initSpellForgottenMessage(param1:Vector.<uint> = null, param2:uint = 0) : SpellForgottenMessage
      {
         this.spellsId = param1;
         this.boostPoint = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.spellsId = new Vector.<uint>();
         this.boostPoint = 0;
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
         this.serializeAs_SpellForgottenMessage(param1);
      }
      
      public function serializeAs_SpellForgottenMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.spellsId.length);
         while(_loc2_ < this.spellsId.length)
         {
            if(this.spellsId[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.spellsId[_loc2_] + ") on element 1 (starting at 1) of spellsId.");
            }
            param1.writeVarShort(this.spellsId[_loc2_]);
            _loc2_++;
         }
         if(this.boostPoint < 0)
         {
            throw new Error("Forbidden value (" + this.boostPoint + ") on element boostPoint.");
         }
         param1.writeVarShort(this.boostPoint);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_SpellForgottenMessage(param1);
      }
      
      public function deserializeAs_SpellForgottenMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readVarUhShort();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of spellsId.");
            }
            this.spellsId.push(_loc2_);
            _loc4_++;
         }
         this.boostPoint = param1.readVarUhShort();
         if(this.boostPoint < 0)
         {
            throw new Error("Forbidden value (" + this.boostPoint + ") on element of SpellForgottenMessage.boostPoint.");
         }
      }
   }
}
