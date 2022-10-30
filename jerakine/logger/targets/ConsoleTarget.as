package com.ankamagames.jerakine.logger.targets
{
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsolesManager;
   import com.ankamagames.jerakine.logger.LogEvent;
   import com.ankamagames.jerakine.logger.LogLevel;
   import flash.utils.getTimer;
   
   public class ConsoleTarget extends AbstractTarget implements ConfigurableLoggingTarget
   {
      
      public static var CONSOLE_INIT_DELAY:uint = 200;
       
      
      protected var _console:ConsoleHandler;
      
      protected var _msgBuffer:Array;
      
      protected var _delayingForConsole:Boolean;
      
      protected var _consoleAvailableSince:uint;
      
      public var consoleId:String = "defaultConsole";
      
      public function ConsoleTarget()
      {
         super();
      }
      
      override public function logEvent(param1:LogEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = "[" + LogLevel.getString(param1.level) + "] " + param1.message;
         if(this._consoleAvailableSince != 0 && this._consoleAvailableSince < getTimer())
         {
            if(this._msgBuffer != null && this._msgBuffer.length > 0)
            {
               _loc2_ = this._msgBuffer.length;
               _loc3_ = -1;
               while(++_loc3_ < _loc2_)
               {
                  this._console.output(this._msgBuffer[_loc3_]);
               }
               this._msgBuffer = null;
            }
            this._delayingForConsole = false;
            this._consoleAvailableSince = 0;
         }
         if(this._console == null || this._delayingForConsole)
         {
            this._console = ConsolesManager.getConsole(this.consoleId);
            if(this._console != null && this._console.outputHandler != null && this._consoleAvailableSince == 0 && !this._delayingForConsole)
            {
               this._consoleAvailableSince = getTimer() + CONSOLE_INIT_DELAY;
               this._delayingForConsole = true;
            }
            if(this._msgBuffer == null)
            {
               this._msgBuffer = new Array();
            }
            this._msgBuffer.push(_loc4_);
            return;
         }
         this._console.output(_loc4_);
      }
      
      public function configure(param1:XML) : void
      {
         if(param1..console.@id != undefined)
         {
            this.consoleId = String(param1..console.@id);
         }
      }
   }
}
