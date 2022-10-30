package com.ankamagames.dofus.network.messages.game.context.fight
{
   import com.ankamagames.dofus.network.types.game.action.fight.FightDispellableEffectExtendedInformations;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMark;
   import com.ankamagames.dofus.network.types.game.idol.Idol;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameFightSpectateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6069;
       
      
      private var _isInitialized:Boolean = false;
      
      public var effects:Vector.<FightDispellableEffectExtendedInformations>;
      
      public var marks:Vector.<GameActionMark>;
      
      public var gameTurn:uint = 0;
      
      public var fightStart:uint = 0;
      
      public var idols:Vector.<Idol>;
      
      public function GameFightSpectateMessage()
      {
         this.effects = new Vector.<FightDispellableEffectExtendedInformations>();
         this.marks = new Vector.<GameActionMark>();
         this.idols = new Vector.<Idol>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6069;
      }
      
      public function initGameFightSpectateMessage(param1:Vector.<FightDispellableEffectExtendedInformations> = null, param2:Vector.<GameActionMark> = null, param3:uint = 0, param4:uint = 0, param5:Vector.<Idol> = null) : GameFightSpectateMessage
      {
         this.effects = param1;
         this.marks = param2;
         this.gameTurn = param3;
         this.fightStart = param4;
         this.idols = param5;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.effects = new Vector.<FightDispellableEffectExtendedInformations>();
         this.marks = new Vector.<GameActionMark>();
         this.gameTurn = 0;
         this.fightStart = 0;
         this.idols = new Vector.<Idol>();
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
         this.serializeAs_GameFightSpectateMessage(param1);
      }
      
      public function serializeAs_GameFightSpectateMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         param1.writeShort(this.effects.length);
         while(_loc2_ < this.effects.length)
         {
            (this.effects[_loc2_] as FightDispellableEffectExtendedInformations).serializeAs_FightDispellableEffectExtendedInformations(param1);
            _loc2_++;
         }
         param1.writeShort(this.marks.length);
         while(_loc3_ < this.marks.length)
         {
            (this.marks[_loc3_] as GameActionMark).serializeAs_GameActionMark(param1);
            _loc3_++;
         }
         if(this.gameTurn < 0)
         {
            throw new Error("Forbidden value (" + this.gameTurn + ") on element gameTurn.");
         }
         param1.writeVarShort(this.gameTurn);
         if(this.fightStart < 0)
         {
            throw new Error("Forbidden value (" + this.fightStart + ") on element fightStart.");
         }
         param1.writeInt(this.fightStart);
         param1.writeShort(this.idols.length);
         while(_loc4_ < this.idols.length)
         {
            (this.idols[_loc4_] as Idol).serializeAs_Idol(param1);
            _loc4_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameFightSpectateMessage(param1);
      }
      
      public function deserializeAs_GameFightSpectateMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:FightDispellableEffectExtendedInformations = null;
         var _loc3_:GameActionMark = null;
         var _loc4_:Idol = null;
         var _loc6_:uint = 0;
         var _loc8_:uint = 0;
         var _loc10_:uint = 0;
         var _loc5_:uint = param1.readUnsignedShort();
         while(_loc6_ < _loc5_)
         {
            _loc2_ = new FightDispellableEffectExtendedInformations();
            _loc2_.deserialize(param1);
            this.effects.push(_loc2_);
            _loc6_++;
         }
         var _loc7_:uint = param1.readUnsignedShort();
         while(_loc8_ < _loc7_)
         {
            _loc3_ = new GameActionMark();
            _loc3_.deserialize(param1);
            this.marks.push(_loc3_);
            _loc8_++;
         }
         this.gameTurn = param1.readVarUhShort();
         if(this.gameTurn < 0)
         {
            throw new Error("Forbidden value (" + this.gameTurn + ") on element of GameFightSpectateMessage.gameTurn.");
         }
         this.fightStart = param1.readInt();
         if(this.fightStart < 0)
         {
            throw new Error("Forbidden value (" + this.fightStart + ") on element of GameFightSpectateMessage.fightStart.");
         }
         var _loc9_:uint = param1.readUnsignedShort();
         while(_loc10_ < _loc9_)
         {
            (_loc4_ = new Idol()).deserialize(param1);
            this.idols.push(_loc4_);
            _loc10_++;
         }
      }
   }
}
