package com.ankamagames.jerakine.logger.targets
{
   import com.ankamagames.jerakine.json.JSON;
   import com.ankamagames.jerakine.logger.LogEvent;
   import com.hurlant.util.Base64;
   
   public class LimitedBufferTarget extends AbstractTarget
   {
       
      
      private var _buffer:Vector.<LogEvent>;
      
      private var _limit:int;
      
      public function LimitedBufferTarget(param1:int = 50)
      {
         super();
         this._limit = param1;
         this._buffer = new Vector.<LogEvent>();
      }
      
      override public function logEvent(param1:LogEvent) : void
      {
         if(this._buffer.length >= this._limit)
         {
            this._buffer.shift();
         }
         this._buffer.push(param1);
      }
      
      public function getFormatedBuffer() : String
      {
         var _loc1_:LogEvent = null;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:Array = new Array();
         for each(_loc1_ in this._buffer)
         {
            _loc2_ = new Object();
            _loc2_.message = _loc1_.message;
            _loc2_.level = _loc1_.level;
            _loc4_.push(_loc2_);
         }
         _loc3_ = com.ankamagames.jerakine.json.JSON.encode(_loc4_);
         return Base64.encode(_loc3_);
      }
      
      public function clearBuffer() : void
      {
         this._buffer = new Vector.<LogEvent>();
      }
   }
}
