package com.ankamagames.jerakine.utils.crypto
{
   import com.hurlant.crypto.rsa.RSAKey;
   import com.hurlant.math.BigInteger;
   import flash.utils.IDataInput;
   
   public class SignatureKey extends RSAKey
   {
      
      private static const PUBLIC_KEY_HEADER:String = "DofusPublicKey";
      
      private static const PRIVATE_KEY_HEADER:String = "DofusPrivateKey";
       
      
      private var _canSign:Boolean;
      
      public function SignatureKey(param1:BigInteger, param2:int, param3:BigInteger = null, param4:BigInteger = null, param5:BigInteger = null, param6:BigInteger = null, param7:BigInteger = null, param8:BigInteger = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public static function fromByte(param1:IDataInput) : SignatureKey
      {
         var _loc2_:RSAKey = null;
         var _loc3_:String = param1.readUTF();
         if(_loc3_ != PUBLIC_KEY_HEADER && _loc3_ != PRIVATE_KEY_HEADER)
         {
            throw Error("Invalid public or private header");
         }
         if(_loc3_ == PUBLIC_KEY_HEADER)
         {
            _loc2_ = RSAKey.parsePublicKey(param1.readUTF(),param1.readUTF());
         }
         else
         {
            _loc2_ = RSAKey.parsePrivateKey(param1.readUTF(),param1.readUTF(),param1.readUTF(),param1.readUTF(),param1.readUTF(),param1.readUTF(),param1.readUTF());
         }
         return new SignatureKey(_loc2_.n,_loc2_.e,_loc2_.d,_loc2_.p,_loc2_.q,_loc2_.dmp1,_loc2_.dmq1,_loc2_.coeff);
      }
      
      public function get canSign() : Boolean
      {
         return canEncrypt;
      }
   }
}
