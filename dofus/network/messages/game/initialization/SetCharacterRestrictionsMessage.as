package com.ankamagames.dofus.network.messages.game.initialization
{
   import com.ankamagames.dofus.network.types.game.character.restriction.ActorRestrictionsInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class SetCharacterRestrictionsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 170;
       
      
      private var _isInitialized:Boolean = false;
      
      public var actorId:int = 0;
      
      public var restrictions:ActorRestrictionsInformations;
      
      public function SetCharacterRestrictionsMessage()
      {
         this.restrictions = new ActorRestrictionsInformations();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 170;
      }
      
      public function initSetCharacterRestrictionsMessage(param1:int = 0, param2:ActorRestrictionsInformations = null) : SetCharacterRestrictionsMessage
      {
         this.actorId = param1;
         this.restrictions = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.actorId = 0;
         this.restrictions = new ActorRestrictionsInformations();
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
         this.serializeAs_SetCharacterRestrictionsMessage(param1);
      }
      
      public function serializeAs_SetCharacterRestrictionsMessage(param1:ICustomDataOutput) : void
      {
         param1.writeInt(this.actorId);
         this.restrictions.serializeAs_ActorRestrictionsInformations(param1);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_SetCharacterRestrictionsMessage(param1);
      }
      
      public function deserializeAs_SetCharacterRestrictionsMessage(param1:ICustomDataInput) : void
      {
         this.actorId = param1.readInt();
         this.restrictions = new ActorRestrictionsInformations();
         this.restrictions.deserialize(param1);
      }
   }
}
