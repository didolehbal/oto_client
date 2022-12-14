package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.dofus.network.types.game.context.ActorOrientation;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameMapChangeOrientationsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6155;
       
      
      private var _isInitialized:Boolean = false;
      
      public var orientations:Vector.<ActorOrientation>;
      
      public function GameMapChangeOrientationsMessage()
      {
         this.orientations = new Vector.<ActorOrientation>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6155;
      }
      
      public function initGameMapChangeOrientationsMessage(param1:Vector.<ActorOrientation> = null) : GameMapChangeOrientationsMessage
      {
         this.orientations = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.orientations = new Vector.<ActorOrientation>();
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
         this.serializeAs_GameMapChangeOrientationsMessage(param1);
      }
      
      public function serializeAs_GameMapChangeOrientationsMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.orientations.length);
         while(_loc2_ < this.orientations.length)
         {
            (this.orientations[_loc2_] as ActorOrientation).serializeAs_ActorOrientation(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameMapChangeOrientationsMessage(param1);
      }
      
      public function deserializeAs_GameMapChangeOrientationsMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:ActorOrientation = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new ActorOrientation();
            _loc2_.deserialize(param1);
            this.orientations.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
