package com.ankamagames.dofus.network.messages.game.actions.fight
{
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameActionFightChangeLookMessage extends AbstractGameActionMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5532;
       
      
      private var _isInitialized:Boolean = false;
      
      public var targetId:int = 0;
      
      public var entityLook:EntityLook;
      
      public function GameActionFightChangeLookMessage()
      {
         this.entityLook = new EntityLook();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5532;
      }
      
      public function initGameActionFightChangeLookMessage(param1:uint = 0, param2:int = 0, param3:int = 0, param4:EntityLook = null) : GameActionFightChangeLookMessage
      {
         super.initAbstractGameActionMessage(param1,param2);
         this.targetId = param3;
         this.entityLook = param4;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.targetId = 0;
         this.entityLook = new EntityLook();
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
         this.serializeAs_GameActionFightChangeLookMessage(param1);
      }
      
      public function serializeAs_GameActionFightChangeLookMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_AbstractGameActionMessage(param1);
         param1.writeInt(this.targetId);
         this.entityLook.serializeAs_EntityLook(param1);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameActionFightChangeLookMessage(param1);
      }
      
      public function deserializeAs_GameActionFightChangeLookMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.targetId = param1.readInt();
         this.entityLook = new EntityLook();
         this.entityLook.deserialize(param1);
      }
   }
}
