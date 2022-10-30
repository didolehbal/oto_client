package com.ankamagames.berilia.api
{
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.utils.errors.UntrustedApiCallError;
   
   public class GenericApiFunction
   {
       
      
      public function GenericApiFunction()
      {
         super();
      }
      
      public static function throwUntrustedCallError(... rest) : void
      {
         throw new UntrustedApiCallError("Unstrusted script called a trusted method");
      }
      
      public static function getRestrictedFunctionAccess(param1:Function) : Function
      {
         var target:Function = param1;
         return function(... rest):*
         {
            var _loc2_:* = undefined;
            var _loc3_:* = SecureCenter.ACCESS_KEY;
            var _loc4_:* = 0;
            for each(_loc2_ in rest)
            {
               if(_loc2_ == _loc3_)
               {
                  rest.splice(_loc4_,1);
                  return target.apply(null,rest);
               }
               _loc4_++;
            }
            throw new UntrustedApiCallError("Unstrusted script called a trusted method");
         };
      }
   }
}
