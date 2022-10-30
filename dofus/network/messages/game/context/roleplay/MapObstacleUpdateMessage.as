package com.ankamagames.dofus.network.messages.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class MapObstacleUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6051;
       
      
      private var _isInitialized:Boolean = false;
      
      public var obstacles:Vector.<MapObstacle>;
      
      public function MapObstacleUpdateMessage()
      {
         this.obstacles = new Vector.<MapObstacle>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6051;
      }
      
      public function initMapObstacleUpdateMessage(param1:Vector.<MapObstacle> = null) : MapObstacleUpdateMessage
      {
         this.obstacles = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.obstacles = new Vector.<MapObstacle>();
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
         this.serializeAs_MapObstacleUpdateMessage(param1);
      }
      
      public function serializeAs_MapObstacleUpdateMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         param1.writeShort(this.obstacles.length);
         while(_loc2_ < this.obstacles.length)
         {
            (this.obstacles[_loc2_] as MapObstacle).serializeAs_MapObstacle(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_MapObstacleUpdateMessage(param1);
      }
      
      public function deserializeAs_MapObstacleUpdateMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:MapObstacle = null;
         var _loc4_:uint = 0;
         var _loc3_:uint = param1.readUnsignedShort();
         while(_loc4_ < _loc3_)
         {
            _loc2_ = new MapObstacle();
            _loc2_.deserialize(param1);
            this.obstacles.push(_loc2_);
            _loc4_++;
         }
      }
   }
}
