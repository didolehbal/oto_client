package com.ankamagames.jerakine.utils.crypto
{
   public class AdvancedMd5
   {
      
      public static const HEX_FORMAT_LOWERCASE:uint = 0;
      
      public static const HEX_FORMAT_UPPERCASE:uint = 1;
      
      public static const BASE64_PAD_CHARACTER_DEFAULT_COMPLIANCE:String = "";
      
      public static const BASE64_PAD_CHARACTER_RFC_COMPLIANCE:String = "=";
      
      public static var hexcase:uint = 0;
      
      public static var b64pad:String = "";
       
      
      public function AdvancedMd5()
      {
         super();
      }
      
      public static function encrypt(param1:String) : String
      {
         return hex_md5(param1);
      }
      
      public static function hex_md5(param1:String) : String
      {
         return rstr2hex(rstr_md5(str2rstr_utf8(param1)));
      }
      
      public static function b64_md5(param1:String) : String
      {
         return rstr2b64(rstr_md5(str2rstr_utf8(param1)));
      }
      
      public static function any_md5(param1:String, param2:String) : String
      {
         return rstr2any(rstr_md5(str2rstr_utf8(param1)),param2);
      }
      
      public static function hex_hmac_md5(param1:String, param2:String) : String
      {
         return rstr2hex(rstr_hmac_md5(str2rstr_utf8(param1),str2rstr_utf8(param2)));
      }
      
      public static function b64_hmac_md5(param1:String, param2:String) : String
      {
         return rstr2b64(rstr_hmac_md5(str2rstr_utf8(param1),str2rstr_utf8(param2)));
      }
      
      public static function any_hmac_md5(param1:String, param2:String, param3:String) : String
      {
         return rstr2any(rstr_hmac_md5(str2rstr_utf8(param1),str2rstr_utf8(param2)),param3);
      }
      
      public static function md5_vm_test() : Boolean
      {
         return hex_md5("abc") == "900150983cd24fb0d6963f7d28e17f72";
      }
      
      public static function rstr_md5(param1:String) : String
      {
         return binl2rstr(binl_md5(rstr2binl(param1),param1.length * 8));
      }
      
      public static function rstr_hmac_md5(param1:String, param2:String) : String
      {
         var _loc3_:Array = rstr2binl(param1);
         if(_loc3_.length > 16)
         {
            _loc3_ = binl_md5(_loc3_,param1.length * 8);
         }
         var _loc4_:Array = new Array(16);
         var _loc5_:Array = new Array(16);
         var _loc6_:Number = 0;
         while(_loc6_ < 16)
         {
            _loc4_[_loc6_] = _loc3_[_loc6_] ^ 909522486;
            _loc5_[_loc6_] = _loc3_[_loc6_] ^ 1549556828;
            _loc6_++;
         }
         var _loc7_:Array = binl_md5(_loc4_.concat(rstr2binl(param2)),512 + param2.length * 8);
         return binl2rstr(binl_md5(_loc5_.concat(_loc7_),512 + 128));
      }
      
      public static function rstr2hex(param1:String) : String
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = !!hexcase?"0123456789ABCDEF":"0123456789abcdef";
         var _loc4_:* = "";
         var _loc5_:Number = 0;
         while(_loc5_ < param1.length)
         {
            _loc2_ = param1.charCodeAt(_loc5_);
            _loc4_ = _loc4_ + (_loc3_.charAt(_loc2_ >>> 4 & 15) + _loc3_.charAt(_loc2_ & 15));
            _loc5_++;
         }
         return _loc4_;
      }
      
      public static function rstr2b64(param1:String) : String
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:* = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
         var _loc5_:* = "";
         var _loc6_:Number = param1.length;
         var _loc7_:Number = 0;
         while(_loc7_ < _loc6_)
         {
            _loc2_ = param1.charCodeAt(_loc7_) << 16 | (_loc7_ + 1 < _loc6_?param1.charCodeAt(_loc7_ + 1) << 8:0) | (_loc7_ + 2 < _loc6_?param1.charCodeAt(_loc7_ + 2):0);
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               if(_loc7_ * 8 + _loc3_ * 6 > param1.length * 8)
               {
                  _loc5_ = _loc5_ + b64pad;
               }
               else
               {
                  _loc5_ = _loc5_ + _loc4_.charAt(_loc2_ >>> 6 * (3 - _loc3_) & 63);
               }
               _loc3_++;
            }
            _loc7_ = _loc7_ + 3;
         }
         return _loc5_;
      }
      
      public static function rstr2any(param1:String, param2:String) : String
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc7_:Number = param2.length;
         var _loc8_:Array = [];
         var _loc9_:Array = new Array(param1.length / 2);
         _loc3_ = 0;
         while(_loc3_ < _loc9_.length)
         {
            _loc9_[_loc3_] = param1.charCodeAt(_loc3_ * 2) << 8 | param1.charCodeAt(_loc3_ * 2 + 1);
            _loc3_++;
         }
         while(_loc9_.length > 0)
         {
            _loc6_ = [];
            _loc5_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc9_.length)
            {
               _loc5_ = (_loc5_ << 16) + _loc9_[_loc3_];
               _loc4_ = Math.floor(_loc5_ / _loc7_);
               _loc5_ = _loc5_ - _loc4_ * _loc7_;
               if(_loc6_.length > 0 || _loc4_ > 0)
               {
                  _loc6_[_loc6_.length] = _loc4_;
               }
               _loc3_++;
            }
            _loc8_[_loc8_.length] = _loc5_;
            _loc9_ = _loc6_;
         }
         var _loc10_:* = "";
         _loc3_ = _loc8_.length - 1;
         while(_loc3_ >= 0)
         {
            _loc10_ = _loc10_ + param2.charAt(_loc8_[_loc3_]);
            _loc3_--;
         }
         return _loc10_;
      }
      
      public static function str2rstr_utf8(param1:String) : String
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:* = "";
         var _loc5_:Number = -1;
         while(++_loc5_ < param1.length)
         {
            _loc2_ = param1.charCodeAt(_loc5_);
            _loc3_ = _loc5_ + 1 < param1.length?Number(param1.charCodeAt(_loc5_ + 1)):Number(0);
            if(55296 <= _loc2_ && _loc2_ <= 56319 && 56320 <= _loc3_ && _loc3_ <= 57343)
            {
               _loc2_ = 65536 + ((_loc2_ & 1023) << 10) + (_loc3_ & 1023);
               _loc5_++;
            }
            if(_loc2_ <= 127)
            {
               _loc4_ = _loc4_ + String.fromCharCode(_loc2_);
            }
            else if(_loc2_ <= 2047)
            {
               _loc4_ = _loc4_ + String.fromCharCode(192 | _loc2_ >>> 6 & 31,128 | _loc2_ & 63);
            }
            else if(_loc2_ <= 65535)
            {
               _loc4_ = _loc4_ + String.fromCharCode(224 | _loc2_ >>> 12 & 15,128 | _loc2_ >>> 6 & 63,128 | _loc2_ & 63);
            }
            else if(_loc2_ <= 2097151)
            {
               _loc4_ = _loc4_ + String.fromCharCode(240 | _loc2_ >>> 18 & 7,128 | _loc2_ >>> 12 & 63,128 | _loc2_ >>> 6 & 63,128 | _loc2_ & 63);
            }
         }
         return _loc4_;
      }
      
      public static function str2rstr_utf16le(param1:String) : String
      {
         var _loc2_:* = "";
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = _loc2_ + String.fromCharCode(param1.charCodeAt(_loc3_) & 255,param1.charCodeAt(_loc3_) >>> 8 & 255);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function str2rstr_utf16be(param1:String) : String
      {
         var _loc2_:* = "";
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ = _loc2_ + String.fromCharCode(param1.charCodeAt(_loc3_) >>> 8 & 255,param1.charCodeAt(_loc3_) & 255);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function rstr2binl(param1:String) : Array
      {
         var _loc2_:Array = new Array(param1.length >> 2);
         var _loc3_:Number = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_] = 0;
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length * 8)
         {
            _loc2_[_loc3_ >> 5] = _loc2_[_loc3_ >> 5] | (param1.charCodeAt(_loc3_ / 8) & 255) << _loc3_ % 32;
            _loc3_ = _loc3_ + 8;
         }
         return _loc2_;
      }
      
      public static function binl2rstr(param1:Array) : String
      {
         var _loc2_:* = "";
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length * 32)
         {
            _loc2_ = _loc2_ + String.fromCharCode(param1[_loc3_ >> 5] >>> _loc3_ % 32 & 255);
            _loc3_ = _loc3_ + 8;
         }
         return _loc2_;
      }
      
      public static function binl_md5(param1:Array, param2:Number) : Array
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         param1[param2 >> 5] = param1[param2 >> 5] | 128 << param2 % 32;
         param1[(param2 + 64 >>> 9 << 4) + 14] = param2;
         var _loc7_:Number = 1732584193;
         var _loc8_:Number = -271733879;
         var _loc9_:Number = -1732584194;
         var _loc10_:Number = 271733878;
         var _loc11_:Number = 0;
         while(_loc11_ < param1.length)
         {
            _loc3_ = _loc7_;
            _loc4_ = _loc8_;
            _loc5_ = _loc9_;
            _loc6_ = _loc10_;
            _loc7_ = md5_ff(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 0],7,-680876936);
            _loc10_ = md5_ff(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 1],12,-389564586);
            _loc9_ = md5_ff(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 2],17,606105819);
            _loc8_ = md5_ff(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 3],22,-1044525330);
            _loc7_ = md5_ff(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 4],7,-176418897);
            _loc10_ = md5_ff(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 5],12,1200080426);
            _loc9_ = md5_ff(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 6],17,-1473231341);
            _loc8_ = md5_ff(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 7],22,-45705983);
            _loc7_ = md5_ff(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 8],7,1770035416);
            _loc10_ = md5_ff(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 9],12,-1958414417);
            _loc9_ = md5_ff(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 10],17,-42063);
            _loc8_ = md5_ff(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 11],22,-1990404162);
            _loc7_ = md5_ff(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 12],7,1804603682);
            _loc10_ = md5_ff(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 13],12,-40341101);
            _loc9_ = md5_ff(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 14],17,-1502002290);
            _loc8_ = md5_ff(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 15],22,1236535329);
            _loc7_ = md5_gg(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 1],5,-165796510);
            _loc10_ = md5_gg(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 6],9,-1069501632);
            _loc9_ = md5_gg(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 11],14,643717713);
            _loc8_ = md5_gg(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 0],20,-373897302);
            _loc7_ = md5_gg(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 5],5,-701558691);
            _loc10_ = md5_gg(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 10],9,38016083);
            _loc9_ = md5_gg(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 15],14,-660478335);
            _loc8_ = md5_gg(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 4],20,-405537848);
            _loc7_ = md5_gg(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 9],5,568446438);
            _loc10_ = md5_gg(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 14],9,-1019803690);
            _loc9_ = md5_gg(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 3],14,-187363961);
            _loc8_ = md5_gg(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 8],20,1163531501);
            _loc7_ = md5_gg(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 13],5,-1444681467);
            _loc10_ = md5_gg(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 2],9,-51403784);
            _loc9_ = md5_gg(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 7],14,1735328473);
            _loc8_ = md5_gg(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 12],20,-1926607734);
            _loc7_ = md5_hh(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 5],4,-378558);
            _loc10_ = md5_hh(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 8],11,-2022574463);
            _loc9_ = md5_hh(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 11],16,1839030562);
            _loc8_ = md5_hh(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 14],23,-35309556);
            _loc7_ = md5_hh(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 1],4,-1530992060);
            _loc10_ = md5_hh(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 4],11,1272893353);
            _loc9_ = md5_hh(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 7],16,-155497632);
            _loc8_ = md5_hh(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 10],23,-1094730640);
            _loc7_ = md5_hh(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 13],4,681279174);
            _loc10_ = md5_hh(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 0],11,-358537222);
            _loc9_ = md5_hh(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 3],16,-722521979);
            _loc8_ = md5_hh(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 6],23,76029189);
            _loc7_ = md5_hh(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 9],4,-640364487);
            _loc10_ = md5_hh(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 12],11,-421815835);
            _loc9_ = md5_hh(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 15],16,530742520);
            _loc8_ = md5_hh(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 2],23,-995338651);
            _loc7_ = md5_ii(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 0],6,-198630844);
            _loc10_ = md5_ii(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 7],10,1126891415);
            _loc9_ = md5_ii(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 14],15,-1416354905);
            _loc8_ = md5_ii(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 5],21,-57434055);
            _loc7_ = md5_ii(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 12],6,1700485571);
            _loc10_ = md5_ii(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 3],10,-1894986606);
            _loc9_ = md5_ii(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 10],15,-1051523);
            _loc8_ = md5_ii(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 1],21,-2054922799);
            _loc7_ = md5_ii(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 8],6,1873313359);
            _loc10_ = md5_ii(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 15],10,-30611744);
            _loc9_ = md5_ii(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 6],15,-1560198380);
            _loc8_ = md5_ii(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 13],21,1309151649);
            _loc7_ = md5_ii(_loc7_,_loc8_,_loc9_,_loc10_,param1[_loc11_ + 4],6,-145523070);
            _loc10_ = md5_ii(_loc10_,_loc7_,_loc8_,_loc9_,param1[_loc11_ + 11],10,-1120210379);
            _loc9_ = md5_ii(_loc9_,_loc10_,_loc7_,_loc8_,param1[_loc11_ + 2],15,718787259);
            _loc8_ = md5_ii(_loc8_,_loc9_,_loc10_,_loc7_,param1[_loc11_ + 9],21,-343485551);
            _loc7_ = safe_add(_loc7_,_loc3_);
            _loc8_ = safe_add(_loc8_,_loc4_);
            _loc9_ = safe_add(_loc9_,_loc5_);
            _loc10_ = safe_add(_loc10_,_loc6_);
            _loc11_ = _loc11_ + 16;
         }
         return [_loc7_,_loc8_,_loc9_,_loc10_];
      }
      
      public static function md5_cmn(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         return safe_add(bit_rol(safe_add(safe_add(param2,param1),safe_add(param4,param6)),param5),param3);
      }
      
      public static function md5_ff(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
      {
         return md5_cmn(param2 & param3 | ~param2 & param4,param1,param2,param5,param6,param7);
      }
      
      public static function md5_gg(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
      {
         return md5_cmn(param2 & param4 | param3 & ~param4,param1,param2,param5,param6,param7);
      }
      
      public static function md5_hh(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
      {
         return md5_cmn(param2 ^ param3 ^ param4,param1,param2,param5,param6,param7);
      }
      
      public static function md5_ii(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Number
      {
         return md5_cmn(param3 ^ (param2 | ~param4),param1,param2,param5,param6,param7);
      }
      
      public static function safe_add(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (param1 & 65535) + (param2 & 65535);
         var _loc4_:Number;
         return (_loc4_ = (param1 >> 16) + (param2 >> 16) + (_loc3_ >> 16)) << 16 | _loc3_ & 65535;
      }
      
      public static function bit_rol(param1:Number, param2:Number) : Number
      {
         return param1 << param2 | param1 >>> 32 - param2;
      }
   }
}
