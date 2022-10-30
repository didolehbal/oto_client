package com.ankamagames.dofus.network.messages.game.alliance
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.AllianceInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.BasicAllianceInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class KohUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6439;
       
      
      private var _isInitialized:Boolean = false;
      
      public var alliances:Vector.<AllianceInformations>;
      
      public var allianceNbMembers:Vector.<uint>;
      
      public var allianceRoundWeigth:Vector.<uint>;
      
      public var allianceMatchScore:Vector.<uint>;
      
      public var allianceMapWinner:BasicAllianceInformations;
      
      public var allianceMapWinnerScore:uint = 0;
      
      public var allianceMapMyAllianceScore:uint = 0;
      
      public var nextTickTime:Number = 0;
      
      public function KohUpdateMessage()
      {
         this.alliances = new Vector.<AllianceInformations>();
         this.allianceNbMembers = new Vector.<uint>();
         this.allianceRoundWeigth = new Vector.<uint>();
         this.allianceMatchScore = new Vector.<uint>();
         this.allianceMapWinner = new BasicAllianceInformations();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6439;
      }
      
      public function initKohUpdateMessage(param1:Vector.<AllianceInformations> = null, param2:Vector.<uint> = null, param3:Vector.<uint> = null, param4:Vector.<uint> = null, param5:BasicAllianceInformations = null, param6:uint = 0, param7:uint = 0, param8:Number = 0) : KohUpdateMessage
      {
         this.alliances = param1;
         this.allianceNbMembers = param2;
         this.allianceRoundWeigth = param3;
         this.allianceMatchScore = param4;
         this.allianceMapWinner = param5;
         this.allianceMapWinnerScore = param6;
         this.allianceMapMyAllianceScore = param7;
         this.nextTickTime = param8;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.alliances = new Vector.<AllianceInformations>();
         this.allianceNbMembers = new Vector.<uint>();
         this.allianceRoundWeigth = new Vector.<uint>();
         this.allianceMatchScore = new Vector.<uint>();
         this.allianceMapWinner = new BasicAllianceInformations();
         this.allianceMapMyAllianceScore = 0;
         this.nextTickTime = 0;
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
         this.serializeAs_KohUpdateMessage(param1);
      }
      
      public function serializeAs_KohUpdateMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         param1.writeShort(this.alliances.length);
         while(_loc2_ < this.alliances.length)
         {
            (this.alliances[_loc2_] as AllianceInformations).serializeAs_AllianceInformations(param1);
            _loc2_++;
         }
         param1.writeShort(this.allianceNbMembers.length);
         while(_loc3_ < this.allianceNbMembers.length)
         {
            if(this.allianceNbMembers[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.allianceNbMembers[_loc3_] + ") on element 2 (starting at 1) of allianceNbMembers.");
            }
            param1.writeVarShort(this.allianceNbMembers[_loc3_]);
            _loc3_++;
         }
         param1.writeShort(this.allianceRoundWeigth.length);
         while(_loc4_ < this.allianceRoundWeigth.length)
         {
            if(this.allianceRoundWeigth[_loc4_] < 0)
            {
               throw new Error("Forbidden value (" + this.allianceRoundWeigth[_loc4_] + ") on element 3 (starting at 1) of allianceRoundWeigth.");
            }
            param1.writeVarInt(this.allianceRoundWeigth[_loc4_]);
            _loc4_++;
         }
         param1.writeShort(this.allianceMatchScore.length);
         while(_loc5_ < this.allianceMatchScore.length)
         {
            if(this.allianceMatchScore[_loc5_] < 0)
            {
               throw new Error("Forbidden value (" + this.allianceMatchScore[_loc5_] + ") on element 4 (starting at 1) of allianceMatchScore.");
            }
            param1.writeByte(this.allianceMatchScore[_loc5_]);
            _loc5_++;
         }
         this.allianceMapWinner.serializeAs_BasicAllianceInformations(param1);
         if(this.allianceMapWinnerScore < 0)
         {
            throw new Error("Forbidden value (" + this.allianceMapWinnerScore + ") on element allianceMapWinnerScore.");
         }
         param1.writeVarInt(this.allianceMapWinnerScore);
         if(this.allianceMapMyAllianceScore < 0)
         {
            throw new Error("Forbidden value (" + this.allianceMapMyAllianceScore + ") on element allianceMapMyAllianceScore.");
         }
         param1.writeVarInt(this.allianceMapMyAllianceScore);
         if(this.nextTickTime < 0 || this.nextTickTime > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.nextTickTime + ") on element nextTickTime.");
         }
         param1.writeDouble(this.nextTickTime);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_KohUpdateMessage(param1);
      }
      
      public function deserializeAs_KohUpdateMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:AllianceInformations = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc9_:uint = 0;
         var _loc11_:uint = 0;
         var _loc13_:uint = 0;
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc2_ = new AllianceInformations();
            _loc2_.deserialize(param1);
            this.alliances.push(_loc2_);
            _loc7_++;
         }
         var _loc8_:uint = param1.readUnsignedShort();
         while(_loc9_ < _loc8_)
         {
            _loc3_ = param1.readVarUhShort();
            if(_loc3_ < 0)
            {
               throw new Error("Forbidden value (" + _loc3_ + ") on elements of allianceNbMembers.");
            }
            this.allianceNbMembers.push(_loc3_);
            _loc9_++;
         }
         var _loc10_:uint = param1.readUnsignedShort();
         while(_loc11_ < _loc10_)
         {
            if((_loc4_ = param1.readVarUhInt()) < 0)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of allianceRoundWeigth.");
            }
            this.allianceRoundWeigth.push(_loc4_);
            _loc11_++;
         }
         var _loc12_:uint = param1.readUnsignedShort();
         while(_loc13_ < _loc12_)
         {
            if((_loc5_ = param1.readByte()) < 0)
            {
               throw new Error("Forbidden value (" + _loc5_ + ") on elements of allianceMatchScore.");
            }
            this.allianceMatchScore.push(_loc5_);
            _loc13_++;
         }
         this.allianceMapWinner = new BasicAllianceInformations();
         this.allianceMapWinner.deserialize(param1);
         this.allianceMapWinnerScore = param1.readVarUhInt();
         if(this.allianceMapWinnerScore < 0)
         {
            throw new Error("Forbidden value (" + this.allianceMapWinnerScore + ") on element of KohUpdateMessage.allianceMapWinnerScore.");
         }
         this.allianceMapMyAllianceScore = param1.readVarUhInt();
         if(this.allianceMapMyAllianceScore < 0)
         {
            throw new Error("Forbidden value (" + this.allianceMapMyAllianceScore + ") on element of KohUpdateMessage.allianceMapMyAllianceScore.");
         }
         this.nextTickTime = param1.readDouble();
         if(this.nextTickTime < 0 || this.nextTickTime > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.nextTickTime + ") on element of KohUpdateMessage.nextTickTime.");
         }
      }
   }
}
