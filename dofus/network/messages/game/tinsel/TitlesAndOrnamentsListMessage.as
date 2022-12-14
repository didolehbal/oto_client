package com.ankamagames.dofus.network.messages.game.tinsel
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class TitlesAndOrnamentsListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6367;
       
      
      private var _isInitialized:Boolean = false;
      
      public var titles:Vector.<uint>;
      
      public var ornaments:Vector.<uint>;
      
      public var activeTitle:uint = 0;
      
      public var activeOrnament:uint = 0;
      
      public function TitlesAndOrnamentsListMessage()
      {
         this.titles = new Vector.<uint>();
         this.ornaments = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6367;
      }
      
      public function initTitlesAndOrnamentsListMessage(param1:Vector.<uint> = null, param2:Vector.<uint> = null, param3:uint = 0, param4:uint = 0) : TitlesAndOrnamentsListMessage
      {
         this.titles = param1;
         this.ornaments = param2;
         this.activeTitle = param3;
         this.activeOrnament = param4;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.titles = new Vector.<uint>();
         this.ornaments = new Vector.<uint>();
         this.activeTitle = 0;
         this.activeOrnament = 0;
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
         this.serializeAs_TitlesAndOrnamentsListMessage(param1);
      }
      
      public function serializeAs_TitlesAndOrnamentsListMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         param1.writeShort(this.titles.length);
         while(_loc2_ < this.titles.length)
         {
            if(this.titles[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.titles[_loc2_] + ") on element 1 (starting at 1) of titles.");
            }
            param1.writeVarShort(this.titles[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.ornaments.length);
         while(_loc3_ < this.ornaments.length)
         {
            if(this.ornaments[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.ornaments[_loc3_] + ") on element 2 (starting at 1) of ornaments.");
            }
            param1.writeVarShort(this.ornaments[_loc3_]);
            _loc3_++;
         }
         if(this.activeTitle < 0)
         {
            throw new Error("Forbidden value (" + this.activeTitle + ") on element activeTitle.");
         }
         param1.writeVarShort(this.activeTitle);
         if(this.activeOrnament < 0)
         {
            throw new Error("Forbidden value (" + this.activeOrnament + ") on element activeOrnament.");
         }
         param1.writeVarShort(this.activeOrnament);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_TitlesAndOrnamentsListMessage(param1);
      }
      
      public function deserializeAs_TitlesAndOrnamentsListMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc4_:uint = param1.readUnsignedShort();
         while(_loc5_ < _loc4_)
         {
            _loc2_ = param1.readVarUhShort();
            if(_loc2_ < 0)
            {
               throw new Error("Forbidden value (" + _loc2_ + ") on elements of titles.");
            }
            this.titles.push(_loc2_);
            _loc5_++;
         }
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc3_ = param1.readVarUhShort();
            if(_loc3_ < 0)
            {
               throw new Error("Forbidden value (" + _loc3_ + ") on elements of ornaments.");
            }
            this.ornaments.push(_loc3_);
            _loc7_++;
         }
         this.activeTitle = param1.readVarUhShort();
         if(this.activeTitle < 0)
         {
            throw new Error("Forbidden value (" + this.activeTitle + ") on element of TitlesAndOrnamentsListMessage.activeTitle.");
         }
         this.activeOrnament = param1.readVarUhShort();
         if(this.activeOrnament < 0)
         {
            throw new Error("Forbidden value (" + this.activeOrnament + ") on element of TitlesAndOrnamentsListMessage.activeOrnament.");
         }
      }
   }
}
