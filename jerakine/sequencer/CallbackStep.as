package com.ankamagames.jerakine.sequencer
{
   import com.ankamagames.jerakine.types.Callback;
   
   public class CallbackStep extends AbstractSequencable
   {
       
      
      private var _callback:Callback;
      
      public function CallbackStep(param1:Callback)
      {
         super();
         this._callback = param1;
      }
      
      override public function start() : void
      {
         this._callback.exec();
         executeCallbacks();
      }
   }
}
