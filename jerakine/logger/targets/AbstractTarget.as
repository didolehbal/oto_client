package com.ankamagames.jerakine.logger.targets
{
   import com.ankamagames.jerakine.logger.InvalidFilterError;
   import com.ankamagames.jerakine.logger.LogEvent;
   import com.ankamagames.jerakine.logger.LogTargetFilter;
   import com.ankamagames.jerakine.logger.Logger;
   
   public class AbstractTarget implements LoggingTarget
   {
      
      private static const FILTERS_FORBIDDEN_CHARS:String = "[]~$^&/(){}<>+=`!#%?,:;\'\"@";
       
      
      private var _loggers:Array;
      
      private var _filters:Array;
      
      public function AbstractTarget()
      {
         this._loggers = new Array();
         this._filters = new Array();
         super();
      }
      
      public function set filters(param1:Array) : void
      {
         if(!this.checkIsFiltersValid(param1))
         {
            throw new InvalidFilterError("These characters are invalid on a filter : " + FILTERS_FORBIDDEN_CHARS);
         }
         this._filters = param1;
      }
      
      public function get filters() : Array
      {
         return this._filters;
      }
      
      public function logEvent(param1:LogEvent) : void
      {
      }
      
      public function addLogger(param1:Logger) : void
      {
         this._loggers.push(param1);
      }
      
      public function removeLogger(param1:Logger) : void
      {
         var _loc2_:int = this._loggers.indexOf(param1);
         if(_loc2_ > -1)
         {
            this._loggers.splice(_loc2_,1);
         }
      }
      
      private function checkIsFiltersValid(param1:Array) : Boolean
      {
         var _loc2_:LogTargetFilter = null;
         for each(_loc2_ in param1)
         {
            if(!this.checkIsFilterValid(_loc2_.target))
            {
               return false;
            }
         }
         return true;
      }
      
      private function checkIsFilterValid(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < FILTERS_FORBIDDEN_CHARS.length)
         {
            if(param1.indexOf(FILTERS_FORBIDDEN_CHARS.charAt(_loc2_)) > -1)
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      public function onLog(param1:LogEvent) : void
      {
         var _loc2_:LogTargetFilter = null;
         var _loc3_:RegExp = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(this._filters.length > 0)
         {
            for each(_loc2_ in this._filters)
            {
               _loc3_ = new RegExp(_loc2_.target.replace("*",".*"),"i");
               _loc4_ = _loc3_.test(param1.category);
               if(param1.category == _loc2_.target && !_loc2_.allow)
               {
                  _loc5_ = false;
                  break;
               }
               if(_loc4_ && _loc2_.allow)
               {
                  _loc5_ = true;
               }
            }
         }
         else
         {
            _loc5_ = true;
         }
         if(_loc5_)
         {
            this.logEvent(param1);
         }
      }
   }
}
