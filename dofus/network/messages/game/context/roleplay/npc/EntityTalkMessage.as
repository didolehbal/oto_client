package com.ankamagames.dofus.network.messages.game.context.roleplay.npc
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class EntityTalkMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6110;
       
      
      private var _isInitialized:Boolean = false;
      
      public var entityId:int = 0;
      
      public var textId:uint = 0;
      
      public var parameters:Vector.<String>;
      
      public function EntityTalkMessage()
      {
         this.parameters = new Vector.<String>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6110;
      }
      
      public function initEntityTalkMessage(param1:int = 0, param2:uint = 0, param3:Vector.<String> = null) : EntityTalkMessage
      {
         this.entityId = param1;
         this.textId = param2;
         this.parameters = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.entityId = 0;
         this.textId = 0;
         this.parameters = new Vector.<String>();
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
         this.serializeAs_EntityTalkMessage(param1);
      }
      
      public function serializeAs_EntityTalkMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeInt(this.entityId);
         if(this.textId < 0)
         {
            throw new Error("Forbidden value (" + this.textId + ") on element textId.");
         }
         param1.writeVarShort(this.textId);
         param1.writeShort(this.parameters.length);
         while(_loc2_ < this.parameters.length)
         {
            param1.writeUTF(this.parameters[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_EntityTalkMessage(param1);
      }
      
      public function deserializeAs_EntityTalkMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:String = null;
         var _loc4_:uint = 0;
         this.entityId = param1.readInt();
         this.textId = param1.readVarUhShort();
         if(this.textId < 0)
         {
            throw new Error("Forbidden value (" + this.textId + ") on element of EntityTalkMessage.textId.");
         }
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1.readUTF();
            this.parameters.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
