package com.ankamagames.dofus.network.messages.game.context.fight
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameFightTurnListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 713;
       
      
      private var _isInitialized:Boolean = false;
      
      public var ids:Vector.<int>;
      
      public var deadsIds:Vector.<int>;
      
      public function GameFightTurnListMessage()
      {
         this.ids = new Vector.<int>();
         this.deadsIds = new Vector.<int>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 713;
      }
      
      public function initGameFightTurnListMessage(param1:Vector.<int> = null, param2:Vector.<int> = null) : GameFightTurnListMessage
      {
         this.ids = param1;
         this.deadsIds = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.ids = new Vector.<int>();
         this.deadsIds = new Vector.<int>();
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
         this.serializeAs_GameFightTurnListMessage(param1);
      }
      
      public function serializeAs_GameFightTurnListMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         param1.writeShort(this.ids.length);
         while(_loc2_ < this.ids.length)
         {
            param1.writeInt(this.ids[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.deadsIds.length);
         while(_loc3_ < this.deadsIds.length)
         {
            param1.writeInt(this.deadsIds[_loc3_]);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameFightTurnListMessage(param1);
      }
      
      public function deserializeAs_GameFightTurnListMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readInt();
            this.ids.push(_loc2_);
            _loc5_++;
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc3_ = param1.readInt();
            this.deadsIds.push(_loc3_);
            _loc7_++;
         }
      }
   }
}
