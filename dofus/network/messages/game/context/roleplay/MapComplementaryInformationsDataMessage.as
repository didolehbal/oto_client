package com.ankamagames.dofus.network.messages.game.context.roleplay
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.context.fight.FightCommonInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.network.types.game.house.HouseInformations;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.dofus.network.types.game.interactive.StatedElement;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class MapComplementaryInformationsDataMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 226;
       
      
      private var _isInitialized:Boolean = false;
      
      public var subAreaId:uint = 0;
      
      public var mapId:uint = 0;
      
      public var houses:Vector.<HouseInformations>;
      
      public var actors:Vector.<GameRolePlayActorInformations>;
      
      public var interactiveElements:Vector.<InteractiveElement>;
      
      public var statedElements:Vector.<StatedElement>;
      
      public var obstacles:Vector.<MapObstacle>;
      
      public var fights:Vector.<FightCommonInformations>;
      
      public var redcells:Vector.<int>;
      
      public var bluecells:Vector.<int>;
      
      public function MapComplementaryInformationsDataMessage()
      {
         this.houses = new Vector.<HouseInformations>();
         this.actors = new Vector.<GameRolePlayActorInformations>();
         this.interactiveElements = new Vector.<InteractiveElement>();
         this.statedElements = new Vector.<StatedElement>();
         this.obstacles = new Vector.<MapObstacle>();
         this.fights = new Vector.<FightCommonInformations>();
         this.redcells = new Vector.<int>();
         this.bluecells = new Vector.<int>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 226;
      }
      
      public function initMapComplementaryInformationsDataMessage(param1:uint = 0, param2:uint = 0, param3:Vector.<HouseInformations> = null, param4:Vector.<GameRolePlayActorInformations> = null, param5:Vector.<InteractiveElement> = null, param6:Vector.<StatedElement> = null, param7:Vector.<MapObstacle> = null, param8:Vector.<FightCommonInformations> = null, param9:Vector.<int> = null, param10:Vector.<int> = null) : MapComplementaryInformationsDataMessage
      {
         this.subAreaId = param1;
         this.mapId = param2;
         this.houses = param3;
         this.actors = param4;
         this.interactiveElements = param5;
         this.statedElements = param6;
         this.obstacles = param7;
         this.fights = param8;
         this.redcells = param9;
         this.bluecells = param10;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.subAreaId = 0;
         this.mapId = 0;
         this.houses = new Vector.<HouseInformations>();
         this.actors = new Vector.<GameRolePlayActorInformations>();
         this.interactiveElements = new Vector.<InteractiveElement>();
         this.statedElements = new Vector.<StatedElement>();
         this.obstacles = new Vector.<MapObstacle>();
         this.fights = new Vector.<FightCommonInformations>();
         this.redcells = new Vector.<int>();
         this.bluecells = new Vector.<int>();
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
         this.serializeAs_MapComplementaryInformationsDataMessage(param1);
      }
      
      public function serializeAs_MapComplementaryInformationsDataMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element subAreaId.");
         }
         param1.writeVarShort(this.subAreaId);
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element mapId.");
         }
         param1.writeInt(this.mapId);
         param1.writeShort(this.houses.length);
         while(_loc2_ < this.houses.length)
         {
            param1.writeShort((this.houses[_loc2_] as HouseInformations).getTypeId());
            (this.houses[_loc2_] as HouseInformations).serialize(param1);
            _loc2_++;
         }
         param1.writeShort(this.actors.length);
         while(_loc3_ < this.actors.length)
         {
            param1.writeShort((this.actors[_loc3_] as GameRolePlayActorInformations).getTypeId());
            (this.actors[_loc3_] as GameRolePlayActorInformations).serialize(param1);
            _loc3_++;
         }
         param1.writeShort(this.interactiveElements.length);
         while(_loc4_ < this.interactiveElements.length)
         {
            param1.writeShort((this.interactiveElements[_loc4_] as InteractiveElement).getTypeId());
            (this.interactiveElements[_loc4_] as InteractiveElement).serialize(param1);
            _loc4_++;
         }
         param1.writeShort(this.statedElements.length);
         while(_loc5_ < this.statedElements.length)
         {
            (this.statedElements[_loc5_] as StatedElement).serializeAs_StatedElement(param1);
            _loc5_++;
         }
         param1.writeShort(this.obstacles.length);
         while(_loc6_ < this.obstacles.length)
         {
            (this.obstacles[_loc6_] as MapObstacle).serializeAs_MapObstacle(param1);
            _loc6_++;
         }
         param1.writeShort(this.fights.length);
         while(_loc7_ < this.fights.length)
         {
            (this.fights[_loc7_] as FightCommonInformations).serializeAs_FightCommonInformations(param1);
            _loc7_++;
         }
         param1.writeShort(this.redcells.length);
         var _loc8_:int = 0;
         while(_loc8_ < this.redcells.length)
         {
            param1.writeShort(this.redcells[_loc8_]);
            _loc8_++;
         }
         param1.writeShort(this.bluecells.length);
         _loc8_ = 0;
         while(_loc8_ < this.bluecells.length)
         {
            param1.writeShort(this.bluecells[_loc8_]);
            _loc8_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_MapComplementaryInformationsDataMessage(param1);
      }
      
      public function deserializeAs_MapComplementaryInformationsDataMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:HouseInformations = null;
         var _loc4_:uint = 0;
         var _loc5_:GameRolePlayActorInformations = null;
         var _loc6_:uint = 0;
         var _loc7_:InteractiveElement = null;
         var _loc8_:StatedElement = null;
         var _loc9_:MapObstacle = null;
         var _loc10_:FightCommonInformations = null;
         var _loc12_:uint = 0;
         var _loc14_:uint = 0;
         var _loc16_:uint = 0;
         var _loc18_:uint = 0;
         var _loc20_:uint = 0;
         var _loc22_:uint = 0;
         this.subAreaId = param1.readVarUhShort();
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element of MapComplementaryInformationsDataMessage.subAreaId.");
         }
         this.mapId = param1.readInt();
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element of MapComplementaryInformationsDataMessage.mapId.");
         }
         var _loc11_:uint = param1.readUnsignedShort();
         while(_loc12_ < _loc11_)
         {
            _loc2_ = param1.readUnsignedShort();
            _loc3_ = ProtocolTypeManager.getInstance(HouseInformations,_loc2_);
            _loc3_.deserialize(param1);
            this.houses.push(_loc3_);
            _loc12_++;
         }
         var _loc13_:uint = param1.readUnsignedShort();
         while(_loc14_ < _loc13_)
         {
            _loc4_ = param1.readUnsignedShort();
            (_loc5_ = ProtocolTypeManager.getInstance(GameRolePlayActorInformations,_loc4_)).deserialize(param1);
            this.actors.push(_loc5_);
            _loc14_++;
         }
         var _loc15_:uint = param1.readUnsignedShort();
         while(_loc16_ < _loc15_)
         {
            _loc6_ = param1.readUnsignedShort();
            (_loc7_ = ProtocolTypeManager.getInstance(InteractiveElement,_loc6_)).deserialize(param1);
            this.interactiveElements.push(_loc7_);
            _loc16_++;
         }
         var _loc17_:uint = param1.readUnsignedShort();
         while(_loc18_ < _loc17_)
         {
            (_loc8_ = new StatedElement()).deserialize(param1);
            this.statedElements.push(_loc8_);
            _loc18_++;
         }
         var _loc19_:uint = param1.readUnsignedShort();
         while(_loc20_ < _loc19_)
         {
            (_loc9_ = new MapObstacle()).deserialize(param1);
            this.obstacles.push(_loc9_);
            _loc20_++;
         }
         var _loc21_:uint = param1.readUnsignedShort();
         while(_loc22_ < _loc21_)
         {
            (_loc10_ = new FightCommonInformations()).deserialize(param1);
            this.fights.push(_loc10_);
            _loc22_++;
         }
         var _loc23_:uint = param1.readUnsignedShort();
         var _loc24_:uint = 0;
         while(_loc24_ < _loc23_)
         {
            this.redcells.push(param1.readUnsignedShort());
            _loc24_++;
         }
         _loc23_ = param1.readUnsignedShort();
         _loc24_ = 0;
         while(_loc24_ < _loc23_)
         {
            this.bluecells.push(param1.readUnsignedShort());
            _loc24_++;
         }
      }
   }
}
