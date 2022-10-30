package com.ankamagames.jerakine.network.utils.types
{
   public final class UInt64 extends Binary64
   {
       
      
      public function UInt64(param1:uint = 0, param2:uint = 0)
      {
         super(param1,param2);
      }
      
      public static function fromNumber(param1:Number) : UInt64
      {
         return new UInt64(param1,Math.floor(param1 / 4294967296));
      }
      
      public static function parseUInt64(param1:String, param2:uint = 0) : UInt64
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param2 == 0)
         {
            if(param1.search(/^0x/) == 0)
            {
               param2 = 16;
               _loc4_ = 2;
            }
            else
            {
               param2 = 10;
            }
         }
         if(param2 < 2 || param2 > 36)
         {
            throw new ArgumentError();
         }
         param1 = param1.toLowerCase();
         var _loc5_:UInt64 = new UInt64();
         while(_loc4_ < param1.length)
         {
            _loc3_ = param1.charCodeAt(_loc4_);
            if(_loc3_ >= CHAR_CODE_0 && _loc3_ <= CHAR_CODE_9)
            {
               _loc3_ = _loc3_ - CHAR_CODE_0;
            }
            else
            {
               if(!(_loc3_ >= CHAR_CODE_A && _loc3_ <= CHAR_CODE_Z))
               {
                  throw new ArgumentError();
               }
               _loc3_ = _loc3_ - CHAR_CODE_A;
               _loc3_ = _loc3_ + 10;
            }
            if(_loc3_ >= param2)
            {
               throw new ArgumentError();
            }
            _loc5_.mul(param2);
            _loc5_.add(_loc3_);
            _loc4_++;
         }
         return _loc5_;
      }
      
      public final function set high(param1:uint) : void
      {
         internalHigh = param1;
      }
      
      public final function get high() : uint
      {
         return internalHigh;
      }
      
      public final function toNumber() : Number
      {
         return this.high * 4294967296 + low;
      }
      
      public final function toString(param1:uint = 10) : String
      {
         var _loc2_:uint = 0;
         if(param1 < 2 || param1 > 36)
         {
            throw new ArgumentError();
         }
         if(this.high == 0)
         {
            return low.toString(param1);
         }
         var _loc3_:Array = [];
         var _loc4_:UInt64 = new UInt64(low,this.high);
         do
         {
            _loc2_ = _loc4_.div(param1);
            if(_loc2_ < 10)
            {
               _loc3_.push(_loc2_ + CHAR_CODE_0);
            }
            else
            {
               _loc3_.push(_loc2_ - 10 + CHAR_CODE_A);
            }
         }
         while(_loc4_.high != 0);
         
         return _loc4_.low.toString(param1) + String.fromCharCode.apply(String,_loc3_.reverse());
      }
   }
}
