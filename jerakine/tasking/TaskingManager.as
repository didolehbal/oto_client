package com.ankamagames.jerakine.tasking
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   
   public final class TaskingManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TaskingManager));
      
      private static var _self:TaskingManager;
       
      
      private var _running:Boolean;
      
      private var _queue:Vector.<SplittedTask>;
      
      public function TaskingManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError("Direct initialization of singleton is forbidden. Please access TaskingManager using the getInstance method.");
         }
         this._queue = new Vector.<SplittedTask>();
      }
      
      public static function getInstance() : TaskingManager
      {
         if(_self == null)
         {
            _self = new TaskingManager();
         }
         return _self;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function get queue() : Vector.<SplittedTask>
      {
         return this._queue;
      }
      
      public function addTask(param1:SplittedTask) : void
      {
         this._queue.push(param1);
         if(!this._running)
         {
            EnterFrameDispatcher.addEventListener(this.onEnterFrame,"TaskingManager");
            this._running = true;
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         var _loc4_:uint = 0;
         var _loc3_:SplittedTask = this._queue[0] as SplittedTask;
         do
         {
            _loc2_ = _loc3_.step();
         }
         while(++_loc4_ < _loc3_.stepsPerFrame() && !_loc2_);
         
         if(_loc2_)
         {
            this._queue.shift();
            if(this._queue.length == 0)
            {
               EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
               this._running = false;
            }
         }
      }
   }
}
