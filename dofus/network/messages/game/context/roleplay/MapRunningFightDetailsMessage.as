package com.ankamagames.dofus.network.messages.game.context.roleplay
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterLightInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class MapRunningFightDetailsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5751;
       
      
      private var _isInitialized:Boolean = false;
      
      public var fightId:uint = 0;
      
      public var attackers:Vector.<GameFightFighterLightInformations>;
      
      public var defenders:Vector.<GameFightFighterLightInformations>;
      
      public function MapRunningFightDetailsMessage()
      {
         this.attackers = new Vector.<GameFightFighterLightInformations>();
         this.defenders = new Vector.<GameFightFighterLightInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5751;
      }
      
      public function initMapRunningFightDetailsMessage(param1:uint = 0, param2:Vector.<GameFightFighterLightInformations> = null, param3:Vector.<GameFightFighterLightInformations> = null) : MapRunningFightDetailsMessage
      {
         this.fightId = param1;
         this.attackers = param2;
         this.defenders = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.fightId = 0;
         this.attackers = new Vector.<GameFightFighterLightInformations>();
         this.defenders = new Vector.<GameFightFighterLightInformations>();
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
         this.serializeAs_MapRunningFightDetailsMessage(param1);
      }
      
      public function serializeAs_MapRunningFightDetailsMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this.fightId < 0)
         {
            throw new Error("Forbidden value (" + this.fightId + ") on element fightId.");
         }
         param1.writeInt(this.fightId);
         param1.writeShort(this.attackers.length);
         while(_loc2_ < this.attackers.length)
         {
            param1.writeShort((this.attackers[_loc2_] as GameFightFighterLightInformations).getTypeId());
            (this.attackers[_loc2_] as GameFightFighterLightInformations).serialize(param1);
            _loc2_++;
         }
         param1.writeShort(this.defenders.length);
         while(_loc3_ < this.defenders.length)
         {
            param1.writeShort((this.defenders[_loc3_] as GameFightFighterLightInformations).getTypeId());
            (this.defenders[_loc3_] as GameFightFighterLightInformations).serialize(param1);
            _loc3_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_MapRunningFightDetailsMessage(param1);
      }
      
      public function deserializeAs_MapRunningFightDetailsMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:GameFightFighterLightInformations = null;
         var _loc4_:uint = 0;
         var _loc5_:GameFightFighterLightInformations = null;
         var _loc7_:uint = 0;
         var _loc9_:uint = 0;
         this.fightId = param1.readInt();
         if(this.fightId < 0)
         {
            throw new Error("Forbidden value (" + this.fightId + ") on element of MapRunningFightDetailsMessage.fightId.");
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(GameFightFighterLightInformations,_loc2_);
            _loc3_.deserialize(param1);
            this.attackers.push(_loc3_);
            _loc7_++;
         }
         var _loc8_:uint = param1.readUnsignedShort();
         while(_loc9_ < _loc8_)
         {
            _loc4_ = param1.readUnsignedShort();
            (_loc5_ = ProtocolTypeManager.getInstance(GameFightFighterLightInformations,_loc4_)).deserialize(param1);
            this.defenders.push(_loc5_);
            _loc9_++;
         }
      }
   }
}
