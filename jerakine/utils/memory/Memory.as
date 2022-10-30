package com.ankamagames.jerakine.utils.memory
{
   import flash.net.LocalConnection;
   import flash.system.System;
   
   public class Memory
   {
      
      private static const MOD:uint = 1024;
      
      private static const UNITS:Array = ["B","KB","MB","GB","TB","PB"];
       
      
      public function Memory()
      {
         super();
      }
      
      public static function usage() : uint
      {
         return System.totalMemory;
      }
      
      public static function humanReadableUsage() : String
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = System.totalMemory;
         while(_loc1_ > MOD)
         {
            _loc1_ = _loc1_ / MOD;
            _loc2_++;
         }
         return _loc1_ + " " + UNITS[_loc2_];
      }
      
      public static function gc() : void
      {
         try
         {
            new LocalConnection().connect("foo");
            new LocalConnection().connect("foo");
         }
         catch(e:*)
         {
         }
      }
   }
}
