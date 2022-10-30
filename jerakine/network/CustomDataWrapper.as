package com.ankamagames.jerakine.network
{
   import com.ankamagames.jerakine.network.utils.types.Int64;
   import com.ankamagames.jerakine.network.utils.types.UInt64;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CustomDataWrapper implements ICustomDataInput, ICustomDataOutput
   {
      
      private static const INT_SIZE:int = 32;
      
      private static const SHORT_SIZE:int = 16;
      
      private static const SHORT_MIN_VALUE:int = -32768;
      
      private static const SHORT_MAX_VALUE:int = 32767;
      
      private static const UNSIGNED_SHORT_MAX_VALUE:int = 65536;
      
      private static const CHUNCK_BIT_SIZE:int = 7;
      
      private static const MAX_ENCODING_LENGTH:int = Math.ceil(INT_SIZE / CHUNCK_BIT_SIZE);
      
      private static const MASK_10000000:int = 128;
      
      private static const MASK_01111111:int = 127;
       
      
      private var _data;
      
      public function CustomDataWrapper(param1:*)
      {
         super();
         this._data = param1;
      }
      
      public function set position(param1:uint) : void
      {
         this._data.position = param1;
      }
      
      public function get position() : uint
      {
         return this._data.position;
      }
      
      public function readVarInt() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = false;
         while(_loc3_ < INT_SIZE)
         {
            _loc1_ = this._data.readByte();
            _loc4_ = (_loc1_ & MASK_10000000) == MASK_10000000;
            if(_loc3_ > 0)
            {
               _loc2_ = _loc2_ + ((_loc1_ & MASK_01111111) << _loc3_);
            }
            else
            {
               _loc2_ = _loc2_ + (_loc1_ & MASK_01111111);
            }
            _loc3_ = _loc3_ + CHUNCK_BIT_SIZE;
            if(!_loc4_)
            {
               return _loc2_;
            }
         }
         throw new Error("Too much data");
      }
      
      public function readVarUhInt() : uint
      {
         return this.readVarInt();
      }
      
      public function readVarShort() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = false;
         while(_loc3_ < SHORT_SIZE)
         {
            _loc1_ = this._data.readByte();
            _loc4_ = (_loc1_ & MASK_10000000) == MASK_10000000;
            if(_loc3_ > 0)
            {
               _loc2_ = _loc2_ + ((_loc1_ & MASK_01111111) << _loc3_);
            }
            else
            {
               _loc2_ = _loc2_ + (_loc1_ & MASK_01111111);
            }
            _loc3_ = _loc3_ + CHUNCK_BIT_SIZE;
            if(!_loc4_)
            {
               if(_loc2_ > SHORT_MAX_VALUE)
               {
                  _loc2_ = _loc2_ - UNSIGNED_SHORT_MAX_VALUE;
               }
               return _loc2_;
            }
         }
         throw new Error("Too much data");
      }
      
      public function readVarUhShort() : uint
      {
         return this.readVarShort();
      }
      
      public function readVarLong() : Number
      {
         return this.readInt64(this._data).toNumber();
      }
      
      public function readVarUhLong() : Number
      {
         return this.readUInt64(this._data).toNumber();
      }
      
      public function readBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void
      {
         this._data.readBytes(param1,param2,param3);
      }
      
      public function readBoolean() : Boolean
      {
         return this._data.readBoolean();
      }
      
      public function readByte() : int
      {
         return this._data.readByte();
      }
      
      public function readUnsignedByte() : uint
      {
         return this._data.readUnsignedByte();
      }
      
      public function readShort() : int
      {
         return this._data.readShort();
      }
      
      public function readUnsignedShort() : uint
      {
         return this._data.readUnsignedShort();
      }
      
      public function readInt() : int
      {
         return this._data.readInt();
      }
      
      public function readUnsignedInt() : uint
      {
         return this._data.readUnsignedInt();
      }
      
      public function readFloat() : Number
      {
         return this._data.readFloat();
      }
      
      public function readDouble() : Number
      {
         return this._data.readDouble();
      }
      
      public function readMultiByte(param1:uint, param2:String) : String
      {
         return this._data.readMultiByte(param1,param2);
      }
      
      public function readUTF() : String
      {
         return this._data.readUTF();
      }
      
      public function readUTFBytes(param1:uint) : String
      {
         return this._data.readUTFBytes(param1);
      }
      
      public function get bytesAvailable() : uint
      {
         return this._data.bytesAvailable;
      }
      
      public function readObject() : *
      {
         return this._data.readObject();
      }
      
      public function get objectEncoding() : uint
      {
         return this._data.objectEncoding;
      }
      
      public function set objectEncoding(param1:uint) : void
      {
         this._data.objectEncoding = param1;
      }
      
      public function get endian() : String
      {
         return this._data.endian;
      }
      
      public function set endian(param1:String) : void
      {
         this._data.endian = param1;
      }
      
      public function writeVarInt(param1:int) : void
      {
         var _loc2_:* = 0;
         var _loc3_:ByteArray = new ByteArray();
         if(param1 >= 0 && param1 <= MASK_01111111)
         {
            _loc3_.writeByte(param1);
            this._data.writeBytes(_loc3_);
            return;
         }
         var _loc4_:int = param1;
         var _loc5_:ByteArray = new ByteArray();
         while(_loc4_ != 0)
         {
            _loc5_.writeByte(_loc4_ & MASK_01111111);
            _loc5_.position = _loc5_.length - 1;
            _loc2_ = int(_loc5_.readByte());
            if((_loc4_ = _loc4_ >>> CHUNCK_BIT_SIZE) > 0)
            {
               _loc2_ = _loc2_ | MASK_10000000;
            }
            _loc3_.writeByte(_loc2_);
         }
         this._data.writeBytes(_loc3_);
      }
      
      public function writeVarShort(param1:int) : void
      {
         var _loc2_:* = 0;
         if(param1 > SHORT_MAX_VALUE || param1 < SHORT_MIN_VALUE)
         {
            throw new Error("Forbidden value");
         }
         var _loc3_:ByteArray = new ByteArray();
         if(param1 >= 0 && param1 <= MASK_01111111)
         {
            _loc3_.writeByte(param1);
            this._data.writeBytes(_loc3_);
            return;
         }
         var _loc4_:* = param1 & 65535;
         var _loc5_:ByteArray = new ByteArray();
         while(_loc4_ != 0)
         {
            _loc5_.writeByte(_loc4_ & MASK_01111111);
            _loc5_.position = _loc5_.length - 1;
            _loc2_ = int(_loc5_.readByte());
            if((_loc4_ = _loc4_ >>> CHUNCK_BIT_SIZE) > 0)
            {
               _loc2_ = _loc2_ | MASK_10000000;
            }
            _loc3_.writeByte(_loc2_);
         }
         this._data.writeBytes(_loc3_);
      }
      
      public function writeVarLong(param1:Number) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Int64 = Int64.fromNumber(param1);
         if(_loc3_.high == 0)
         {
            this.writeint32(this._data,_loc3_.low);
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < 4)
            {
               this._data.writeByte(_loc3_.low & 127 | 128);
               _loc3_.low = _loc3_.low >>> 7;
               _loc2_++;
            }
            if((_loc3_.high & 268435455 << 3) == 0)
            {
               this._data.writeByte(_loc3_.high << 4 | _loc3_.low);
            }
            else
            {
               this._data.writeByte((_loc3_.high << 4 | _loc3_.low) & 127 | 128);
               this.writeint32(this._data,_loc3_.high >>> 3);
            }
         }
      }
      
      public function writeBytes(param1:ByteArray, param2:uint = 0, param3:uint = 0) : void
      {
         this._data.writeBytes(param1,param2,param3);
      }
      
      public function writeBoolean(param1:Boolean) : void
      {
         this._data.writeBoolean(param1);
      }
      
      public function writeByte(param1:int) : void
      {
         this._data.writeByte(param1);
      }
      
      public function writeShort(param1:int) : void
      {
         this._data.writeShort(param1);
      }
      
      public function writeInt(param1:int) : void
      {
         this._data.writeInt(param1);
      }
      
      public function writeUnsignedInt(param1:uint) : void
      {
         this._data.writeUnsignedInt(param1);
      }
      
      public function writeFloat(param1:Number) : void
      {
         this._data.writeFloat(param1);
      }
      
      public function writeDouble(param1:Number) : void
      {
         this._data.writeDouble(param1);
      }
      
      public function writeMultiByte(param1:String, param2:String) : void
      {
         this._data.writeMultiByte(param1,param2);
      }
      
      public function writeUTF(param1:String) : void
      {
         this._data.writeUTF(param1);
      }
      
      public function writeUTFBytes(param1:String) : void
      {
         this._data.writeUTFBytes(param1);
      }
      
      public function writeObject(param1:*) : void
      {
         this._data.writeObject(param1);
      }
      
      private function readInt64(param1:IDataInput) : Int64
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:Int64 = new Int64();
         while(true)
         {
            _loc2_ = param1.readUnsignedByte();
            if(_loc4_ == 28)
            {
               break;
            }
            if(_loc2_ >= 128)
            {
               continue;
            }
            _loc3_.low = _loc3_.low | _loc2_ << _loc4_;
            return _loc3_;
         }
         if(_loc2_ >= 128)
         {
            _loc2_ = _loc2_ & 127;
            _loc3_.low = _loc3_.low | _loc2_ << _loc4_;
            _loc3_.high = _loc2_ >>> 4;
            _loc4_ = 3;
            while(true)
            {
               _loc2_ = param1.readUnsignedByte();
               if(_loc4_ < 32)
               {
                  if(_loc2_ < 128)
                  {
                     break;
                  }
                  _loc3_.high = _loc3_.high | (_loc2_ & 127) << _loc4_;
               }
               _loc4_ = _loc4_ + 7;
            }
            _loc3_.high = _loc3_.high | _loc2_ << _loc4_;
            return _loc3_;
         }
         _loc3_.low = _loc3_.low | _loc2_ << _loc4_;
         _loc3_.high = _loc2_ >>> 4;
         return _loc3_;
      }
      
      private function readUInt64(param1:IDataInput) : UInt64
      {
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         var _loc3_:UInt64 = new UInt64();
         while(true)
         {
            _loc2_ = param1.readUnsignedByte();
            if(_loc4_ == 28)
            {
               break;
            }
            if(_loc2_ >= 128)
            {
               continue;
            }
            _loc3_.low = _loc3_.low | _loc2_ << _loc4_;
            return _loc3_;
         }
         if(_loc2_ >= 128)
         {
            _loc2_ = _loc2_ & 127;
            _loc3_.low = _loc3_.low | _loc2_ << _loc4_;
            _loc3_.high = _loc2_ >>> 4;
            _loc4_ = 3;
            while(true)
            {
               _loc2_ = param1.readUnsignedByte();
               if(_loc4_ < 32)
               {
                  if(_loc2_ < 128)
                  {
                     break;
                  }
                  _loc3_.high = _loc3_.high | (_loc2_ & 127) << _loc4_;
               }
               _loc4_ = _loc4_ + 7;
            }
            _loc3_.high = _loc3_.high | _loc2_ << _loc4_;
            return _loc3_;
         }
         _loc3_.low = _loc3_.low | _loc2_ << _loc4_;
         _loc3_.high = _loc2_ >>> 4;
         return _loc3_;
      }
      
      private function writeint32(param1:IDataOutput, param2:uint) : void
      {
         while(param2 >= 128)
         {
            param1.writeByte(param2 & 127 | 128);
            param2 = param2 >>> 7;
         }
         param1.writeByte(param2);
      }
   }
}
