package com.ankamagames.performance.tests
{
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import com.ankamagames.performance.Benchmark;
   import com.ankamagames.performance.IBenchmarkTest;
   import flash.utils.getTimer;
   
   public class TestReadDisk implements IBenchmarkTest
   {
      
      private static var _results:Array;
       
      
      public function TestReadDisk()
      {
         super();
      }
      
      public function run() : void
      {
         var startTime:Number = NaN;
         var cso:CustomSharedObject = null;
         try
         {
            CustomSharedObject.clearCache("benchmark");
            startTime = getTimer();
            cso = CustomSharedObject.getLocal("benchmark");
            if(!_results)
            {
               _results = [];
            }
            _results.push(getTimer() - startTime);
            cso.clear();
         }
         catch(error:Error)
         {
            _results.push("error");
         }
         Benchmark.onTestCompleted(this);
      }
      
      public function cancel() : void
      {
      }
      
      public function getResults() : String
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         if(_results)
         {
            _loc1_ = 0;
            _loc2_ = 0;
            while(_loc2_ < _results.length)
            {
               if(_results[_loc2_] == "error")
               {
                  return "readDiskTest:error";
               }
               _loc1_ = _loc1_ + _results[_loc2_];
               _loc2_++;
            }
            _loc1_ = _loc1_ / _results.length;
            return "readDiskTest:" + _loc1_.toString();
         }
         return "readDiskTest:none";
      }
   }
}
