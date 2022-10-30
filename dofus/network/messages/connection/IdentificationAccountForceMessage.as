package com.ankamagames.dofus.network.messages.connection
{
   import com.ankamagames.dofus.network.types.secure.TrustCertificate;
   import com.ankamagames.dofus.network.types.version.VersionExtended;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class IdentificationAccountForceMessage extends IdentificationMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6119;
       
      
      private var _isInitialized:Boolean = false;
      
      public var forcedAccountLogin:String = "";
      
      public function IdentificationAccountForceMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6119;
      }
      
      public function initIdentificationAccountForceMessage(param1:VersionExtended = null, param2:String = "", param3:Vector.<int> = null, param4:int = 0, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:TrustCertificate = null, param9:Number = 0, param10:Vector.<uint> = null, param11:String = "") : IdentificationAccountForceMessage
      {
         super.initIdentificationMessage(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
         this.forcedAccountLogin = param11;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.forcedAccountLogin = "";
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
         this.serializeAs_IdentificationAccountForceMessage(param1);
      }
      
      public function serializeAs_IdentificationAccountForceMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_IdentificationMessage(param1);
         param1.writeUTF(this.forcedAccountLogin);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_IdentificationAccountForceMessage(param1);
      }
      
      public function deserializeAs_IdentificationAccountForceMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.forcedAccountLogin = param1.readUTF();
      }
   }
}
