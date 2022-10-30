package com.ankamagames.jerakine.utils.memory
{
   import flash.utils.Dictionary;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public dynamic class WeakProxyReference extends Proxy
   {
       
      
      protected var dictionary:Dictionary;
      
      public function WeakProxyReference(param1:Object)
      {
         super();
         this.dictionary = new Dictionary(true);
         this.dictionary[param1] = null;
      }
      
      public function get object() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:* = this.dictionary;
         if(!(§§hasnext(_loc3_,_loc2_)))
         {
            return null;
         }
      }
      
      private function getObject() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:* = this.dictionary;
         if(!(§§hasnext(_loc3_,_loc2_)))
         {
            throw new ReferenceError("Reference Error: Object is no longer available through WeakProxyReference, it may have been removed from memory.");
         }
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         var _loc3_:* = this.getObject()[param1];
         if(!(_loc3_ is Function))
         {
            throw new TypeError("TypeError: Cannot call " + param1.toString() + " through WeakProxyReference, it is not a function.");
         }
         return _loc3_.apply(null,rest);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         return this.getObject()[param1];
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         this.getObject()[param1] = param2;
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         return delete this.getObject()[param1];
      }
   }
}
