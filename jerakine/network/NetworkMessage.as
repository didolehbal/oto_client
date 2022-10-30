package com.ankamagames.jerakine.network
{
   import com.adobe.crypto.MD5;
   import com.ankamagames.jerakine.scrambling.ScramblableElement;
   import com.ankamagames.jerakine.utils.errors.AbstractMethodCallError;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.getQualifiedClassName;
   
   public class NetworkMessage extends ScramblableElement implements INetworkMessage
   {
      
      public static var GLOBAL_INSTANCE_ID:uint = 0;
      
      public static const BIT_RIGHT_SHIFT_LEN_PACKET_ID:uint = 2;
      
      public static const BIT_MASK:uint = 3;
      
      public static var HASH_FUNCTION:Function;
      
      private static var encryptionKey:ByteArray = new ByteArray();
       
      
      private var _instance_id:uint;
      
      public var receptionTime:int;
      
      public function NetworkMessage()
      {
         this._instance_id = ++GLOBAL_INSTANCE_ID;
         super();
      }
      
      private static function computeTypeLen(param1:uint) : uint
      {
         if(param1 > 65535)
         {
            return 3;
         }
         if(param1 > 255)
         {
            return 2;
         }
         if(param1 > 0)
         {
            return 1;
         }
         return 0;
      }
      
      private static function subComputeStaticHeader(param1:uint, param2:uint) : uint
      {
         return param1 << BIT_RIGHT_SHIFT_LEN_PACKET_ID | param2;
      }
      
      public static function setEncryptionKey(param1:Vector.<int>) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeByte(param1[_loc3_]);
            _loc3_++;
         }
         encryptionKey = _loc2_;
      }
      
      public static function encryptMessage(param1:ByteArray) : ByteArray
      {
         encryptionKey.position = 0;
         param1.position = 0;
         var _loc2_:int = encryptionKey.readByte();
         var _loc3_:ByteArray = new ByteArray();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_.writeByte(param1.readByte() ^ _loc2_);
            _loc4_++;
         }
         _loc3_.position = 0;
         param1.position = 0;
         return _loc3_;
      }
      
      public function writePacket(param1:ICustomDataOutput, param2:int, param3:ByteArray) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = computeTypeLen(param3.length);
         var _loc7_:ByteArray;
         (_loc7_ = new ByteArray()).writeShort(subComputeStaticHeader(param2,_loc6_));
         _loc7_.writeUnsignedInt(this._instance_id);
         var _loc8_:String = MD5.hashBytes(param3);
         _loc7_.writeUTF(_loc8_);
         switch(_loc6_)
         {
            case 0:
               break;
            case 1:
               _loc7_.writeByte(param3.length);
               break;
            case 2:
               _loc7_.writeShort(param3.length);
               break;
            case 3:
               _loc4_ = param3.length >> 16 & 255;
               _loc5_ = param3.length & 65535;
               _loc7_.writeByte(_loc4_);
               _loc7_.writeShort(_loc5_);
         }
         if(param3.length > 0)
         {
            _loc7_.writeBytes(param3,0,param3.length);
         }
         _loc7_ = encryptMessage(_loc7_);
         param1.writeUnsignedInt(_loc7_.length);
         param1.writeBytes(_loc7_,0,_loc7_.length);
      }
      
      public function get isInitialized() : Boolean
      {
         throw new AbstractMethodCallError();
      }
      
      public function getMessageId() : uint
      {
         throw new AbstractMethodCallError();
      }
      
      public function reset() : void
      {
         throw new AbstractMethodCallError();
      }
      
      public function pack(param1:ICustomDataOutput) : void
      {
         throw new AbstractMethodCallError();
      }
      
      public function unpack(param1:ICustomDataInput, param2:uint) : void
      {
         throw new AbstractMethodCallError();
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         throw new AbstractMethodCallError();
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         throw new AbstractMethodCallError();
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this).split("::")[1] + " @" + this._instance_id;
      }
   }
}
