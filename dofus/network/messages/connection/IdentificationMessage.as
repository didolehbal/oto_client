package com.ankamagames.dofus.network.messages.connection
{
   import com.ankamagames.dofus.network.types.secure.TrustCertificate;
   import com.ankamagames.dofus.network.types.version.VersionExtended;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.utils.BooleanByteWrapper;
   import com.ankamagames.jerakine.utils.crypto.Base64;
   import flash.net.NetworkInfo;
   import flash.net.NetworkInterface;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class IdentificationMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 4;
       
      
      private var _isInitialized:Boolean = false;
      
      public var version:VersionExtended;
      
      public var lang:String = "";
      
      public var credentials:Vector.<int>;
      
      public var serverId:int = 0;
      
      public var autoconnect:Boolean = false;
      
      public var useCertificate:Boolean = false;
      
      public var useLoginToken:Boolean = false;
      
      public var trustCertificate:TrustCertificate;
      
      public var sessionOptionalSalt:Number = 0;
      
      public var failedAttempts:Vector.<uint>;
      
      public function IdentificationMessage()
      {
         this.version = new VersionExtended();
         this.credentials = new Vector.<int>();
         this.trustCertificate = new TrustCertificate();
         this.failedAttempts = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 4;
      }
      
      public function initIdentificationMessage(param1:VersionExtended = null, param2:String = "", param3:Vector.<int> = null, param4:int = 0, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:TrustCertificate = null, param9:Number = 0, param10:Vector.<uint> = null) : IdentificationMessage
      {
         this.version = param1;
         this.lang = param2;
         this.credentials = param3;
         this.serverId = param4;
         this.autoconnect = param5;
         this.useCertificate = param6;
         this.useLoginToken = param7;
         this.trustCertificate = param8;
         this.sessionOptionalSalt = param9;
         this.failedAttempts = param10;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.version = new VersionExtended();
         this.credentials = new Vector.<int>();
         this.serverId = 0;
         this.autoconnect = false;
         this.useCertificate = false;
         this.useLoginToken = false;
         this.trustCertificate = new TrustCertificate();
         this.sessionOptionalSalt = 0;
         this.failedAttempts = new Vector.<uint>();
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
         this.serializeAs_IdentificationMessage(param1);
      }
      
      public function serializeAs_IdentificationMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,0,this.autoconnect);
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,1,this.useCertificate);
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,2,this.useLoginToken);
         param1.writeByte(_loc2_);
         this.version.serializeAs_VersionExtended(param1);
         param1.writeUTF(this.lang);
         param1.writeVarInt(this.credentials.length);
         while(_loc3_ < this.credentials.length)
         {
            param1.writeByte(this.credentials[_loc3_]);
            _loc3_++;
         }
         param1.writeShort(this.serverId);
         if(this.sessionOptionalSalt < -9007199254740992 || this.sessionOptionalSalt > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.sessionOptionalSalt + ") on element sessionOptionalSalt.");
         }
         if(this.useCertificate)
         {
            this.trustCertificate.serializeAs_TrustCertificate(param1);
         }
         param1.writeVarLong(this.sessionOptionalSalt);
         param1.writeShort(this.failedAttempts.length);
         while(_loc4_ < this.failedAttempts.length)
         {
            if(this.failedAttempts[_loc4_] < 0)
            {
               throw new Error("Forbidden value (" + this.failedAttempts[_loc4_] + ") on element 9 (starting at 1) of failedAttempts.");
            }
            param1.writeVarShort(this.failedAttempts[_loc4_]);
            _loc4_++;
         }
         var _loc5_:NetworkInterface;
         var _loc6_:String = (_loc5_ = NetworkInfo.networkInfo.findInterfaces()[0]).hardwareAddress;
         param1.writeUTF(Base64.encode(_loc6_));
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_IdentificationMessage(param1);
      }
      
      public function deserializeAs_IdentificationMessage(param1:ICustomDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc6_:uint = 0;
         var _loc8_:uint = 0;
         var _loc4_:uint = param1.readByte();
         this.autoconnect = BooleanByteWrapper.getFlag(_loc4_,0);
         this.useCertificate = BooleanByteWrapper.getFlag(_loc4_,1);
         this.useLoginToken = BooleanByteWrapper.getFlag(_loc4_,2);
         this.version = new VersionExtended();
         this.version.deserialize(param1);
         this.lang = param1.readUTF();
         var _loc5_:uint = param1.readVarInt();
         while(_loc6_ < _loc5_)
         {
            _loc2_ = param1.readByte();
            this.credentials.push(_loc2_);
            _loc6_++;
         }
         this.serverId = param1.readShort();
         this.sessionOptionalSalt = param1.readVarLong();
         if(this.sessionOptionalSalt < -9007199254740992 || this.sessionOptionalSalt > 9007199254740992)
         {
            throw new Error("Forbidden value (" + this.sessionOptionalSalt + ") on element of IdentificationMessage.sessionOptionalSalt.");
         }
         var _loc7_:uint = param1.readUnsignedShort();
         while(_loc8_ < _loc7_)
         {
            _loc3_ = param1.readVarUhShort();
            if(_loc3_ < 0)
            {
               throw new Error("Forbidden value (" + _loc3_ + ") on elements of failedAttempts.");
            }
            this.failedAttempts.push(_loc3_);
            _loc8_++;
         }
      }
   }
}
