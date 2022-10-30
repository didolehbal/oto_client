package com.ankamagames.jerakine.utils.memory
{
   import flash.utils.Dictionary;
   
   public class WeakReference
   {
       
      
      private var dictionary:Dictionary;
      
      public function WeakReference(param1:*)
      {
         super();
         this.dictionary = new Dictionary(true);
         this.dictionary[param1] = null;
      }
      
      public function get object() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:* = this.dictionary;
         if(!(§§hasnext(_loc3_,_loc2_)))
         {
            return null;
         }
      }
      
      public function destroy() : void
      {
         this.dictionary = null;
      }
   }
}
