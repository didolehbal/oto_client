package com.ankamagames.jerakine.sound
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.utils.getQualifiedClassName;
   
   public class FlashSoundSender extends AbstractFlashSound
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(FlashSoundSender));
       
      
      public function FlashSoundSender(param1:uint = 0)
      {
         super(param1);
         _conn.addEventListener(StatusEvent.STATUS,this.onStatus);
         _conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.dispatchError);
      }
      
      private function dispatchError(param1:ErrorEvent) : void
      {
         dispatchEvent(param1);
      }
      
      private function onStatus(param1:StatusEvent) : void
      {
         switch(param1.level)
         {
            case "status":
               param1.currentTarget.removeEventListener(StatusEvent.STATUS,this.onStatus);
               dispatchEvent(new Event(Event.CONNECT));
               removePingTimer();
               return;
            case "error":
               if(_currentNbPing >= LIMIT_PING_TRY)
               {
                  _log.fatal("nb try reached");
                  param1.currentTarget.removeEventListener(StatusEvent.STATUS,this.onStatus);
                  dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
                  removePingTimer();
               }
               else
               {
                  _pingTimer.start();
               }
               return;
            default:
               _log.fatal("status level: " + param1.level);
               return;
         }
      }
      
      override public function connect(param1:String, param2:int) : void
      {
         ++_currentNbPing;
         _log.debug("try to ping");
         _conn.send(CONNECTION_NAME,"ping");
      }
      
      override public function flush() : void
      {
         _conn.send(CONNECTION_NAME,"onData",_data);
         _data.clear();
      }
   }
}
