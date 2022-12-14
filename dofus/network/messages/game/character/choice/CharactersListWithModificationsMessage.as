package com.ankamagames.dofus.network.messages.game.character.choice
{
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterBaseInformations;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterToRecolorInformation;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterToRelookInformation;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class CharactersListWithModificationsMessage extends CharactersListMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6120;
       
      
      private var _isInitialized:Boolean = false;
      
      public var charactersToRecolor:Vector.<CharacterToRecolorInformation>;
      
      public var charactersToRename:Vector.<int>;
      
      public var unusableCharacters:Vector.<int>;
      
      public var charactersToRelook:Vector.<CharacterToRelookInformation>;
      
      public function CharactersListWithModificationsMessage()
      {
         this.charactersToRecolor = new Vector.<CharacterToRecolorInformation>();
         this.charactersToRename = new Vector.<int>();
         this.unusableCharacters = new Vector.<int>();
         this.charactersToRelook = new Vector.<CharacterToRelookInformation>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6120;
      }
      
      public function initCharactersListWithModificationsMessage(param1:Vector.<CharacterBaseInformations> = null, param2:Boolean = false, param3:Vector.<CharacterToRecolorInformation> = null, param4:Vector.<int> = null, param5:Vector.<int> = null, param6:Vector.<CharacterToRelookInformation> = null) : CharactersListWithModificationsMessage
      {
         super.initCharactersListMessage(param1,param2);
         this.charactersToRecolor = param3;
         this.charactersToRename = param4;
         this.unusableCharacters = param5;
         this.charactersToRelook = param6;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.charactersToRecolor = new Vector.<CharacterToRecolorInformation>();
         this.charactersToRename = new Vector.<int>();
         this.unusableCharacters = new Vector.<int>();
         this.charactersToRelook = new Vector.<CharacterToRelookInformation>();
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
         this.serializeAs_CharactersListWithModificationsMessage(param1);
      }
      
      public function serializeAs_CharactersListWithModificationsMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         super.serializeAs_CharactersListMessage(param1);
         param1.writeShort(this.charactersToRecolor.length);
         while(_loc2_ < this.charactersToRecolor.length)
         {
            (this.charactersToRecolor[_loc2_] as CharacterToRecolorInformation).serializeAs_CharacterToRecolorInformation(param1);
            _loc2_++;
         }
         param1.writeShort(this.charactersToRename.length);
         while(_loc3_ < this.charactersToRename.length)
         {
            param1.writeInt(this.charactersToRename[_loc3_]);
            _loc3_++;
         }
         param1.writeShort(this.unusableCharacters.length);
         while(_loc4_ < this.unusableCharacters.length)
         {
            param1.writeInt(this.unusableCharacters[_loc4_]);
            _loc4_++;
         }
         param1.writeShort(this.charactersToRelook.length);
         while(_loc5_ < this.charactersToRelook.length)
         {
            (this.charactersToRelook[_loc5_] as CharacterToRelookInformation).serializeAs_CharacterToRelookInformation(param1);
            _loc5_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_CharactersListWithModificationsMessage(param1);
      }
      
      public function deserializeAs_CharactersListWithModificationsMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:CharacterToRecolorInformation = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:CharacterToRelookInformation = null;
         var _loc7_:uint = 0;
         var _loc9_:uint = 0;
         var _loc11_:uint = 0;
         var _loc13_:uint = 0;
         super.deserialize(param1);
         var _loc6_:uint = param1.readUnsignedShort();
         while(_loc7_ < _loc6_)
         {
            _loc2_ = new CharacterToRecolorInformation();
            _loc2_.deserialize(param1);
            this.charactersToRecolor.push(_loc2_);
            _loc7_++;
         }
         var _loc8_:uint = param1.readUnsignedShort();
         while(_loc9_ < _loc8_)
         {
            _loc3_ = param1.readInt();
            this.charactersToRename.push(_loc3_);
            _loc9_++;
         }
         var _loc10_:uint = param1.readUnsignedShort();
         while(_loc11_ < _loc10_)
         {
            _loc4_ = param1.readInt();
            this.unusableCharacters.push(_loc4_);
            _loc11_++;
         }
         var _loc12_:uint = param1.readUnsignedShort();
         while(_loc13_ < _loc12_)
         {
            (_loc5_ = new CharacterToRelookInformation()).deserialize(param1);
            this.charactersToRelook.push(_loc5_);
            _loc13_++;
         }
      }
   }
}
