package com.ankamagames.jerakine.console
{
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class ConsoleHandler implements MessageHandler, ConsoleInstructionHandler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ConsoleHandler));
       
      
      private var _name:String;
      
      private var _handlers:Dictionary;
      
      private var _outputHandler:MessageHandler;
      
      private var _displayExecutionTime:Boolean;
      
      private var _hideCommandsWithoutHelp:Boolean;
      
      public function ConsoleHandler(param1:MessageHandler, param2:Boolean = true, param3:Boolean = false)
      {
         super();
         this._outputHandler = param1;
         this._handlers = new Dictionary();
         this._displayExecutionTime = param2;
         this._hideCommandsWithoutHelp = param3;
         this._handlers["help"] = this;
      }
      
      public function get handlers() : Dictionary
      {
         return this._handlers;
      }
      
      public function get outputHandler() : MessageHandler
      {
         return this._outputHandler;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function process(param1:Message) : Boolean
      {
         if(param1 is ConsoleInstructionMessage)
         {
            this.dispatchMessage(ConsoleInstructionMessage(param1));
            return true;
         }
         return false;
      }
      
      public function output(param1:String, param2:uint = 0) : void
      {
         this._outputHandler.process(new ConsoleOutputMessage(this._name,param1,param2));
      }
      
      public function addHandler(param1:*, param2:ConsoleInstructionHandler) : void
      {
         var _loc3_:String = null;
         if(param1 is Array)
         {
            for each(_loc3_ in param1)
            {
               if(_loc3_)
               {
                  this._handlers[String(_loc3_)] = param2;
               }
            }
         }
         else if(param1)
         {
            this._handlers[String(param1)] = param2;
         }
      }
      
      public function changeOutputHandler(param1:MessageHandler) : void
      {
         this._outputHandler = param1;
      }
      
      public function removeHandler(param1:String) : void
      {
         delete this._handlers[param1];
      }
      
      public function isHandled(param1:String) : Boolean
      {
         return this._handlers[param1] != null;
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:ConsoleInstructionHandler = null;
         switch(param2)
         {
            case "help":
               if(param3.length == 0)
               {
                  param1.output(I18n.getUiText("ui.console.generalHelp",[this._name]));
                  _loc4_ = new Array();
                  for(param2 in this._handlers)
                  {
                     _loc4_.push(param2);
                  }
                  _loc4_.sort();
                  for each(_loc5_ in _loc4_)
                  {
                     if((_loc6_ = (this._handlers[_loc5_] as ConsoleInstructionHandler).getHelp(_loc5_)) || !this._hideCommandsWithoutHelp)
                     {
                        param1.output("  - <b>" + _loc5_ + "</b>: " + _loc6_);
                     }
                  }
               }
               else if(_loc7_ = this._handlers[param3[0]])
               {
                  param1.output("<b>" + _loc5_ + "</b>: " + _loc7_.getHelp(param3[0]));
               }
               else
               {
                  param1.output(I18n.getUiText("ui.console.unknownCommand",[param3[0]]));
               }
               return;
            default:
               return;
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "help":
               return I18n.getUiText("ui.console.displayhelp");
            default:
               return I18n.getUiText("ui.chat.console.noHelp",[param1]);
         }
      }
      
      public function getCmdHelp(param1:String) : String
      {
         var _loc2_:ConsoleInstructionHandler = this._handlers[param1];
         if(_loc2_)
         {
            return _loc2_.getHelp(param1);
         }
         return null;
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         return [];
      }
      
      public function autoComplete(param1:String) : String
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc7_:Array = new Array();
         var _loc8_:Array;
         if((_loc8_ = param1.split(" ")).length == 1)
         {
            for(_loc2_ in this._handlers)
            {
               if(_loc2_.indexOf(param1) == 0)
               {
                  _loc7_.push(_loc2_);
               }
            }
            _loc3_ = "";
         }
         else
         {
            _loc7_ = this.getAutoCompletePossibilitiesOnParam(_loc8_[0],_loc8_.slice(1).length - 1,_loc8_.slice(1));
            _loc3_ = _loc8_.slice(0,_loc8_.length - 1).join(" ") + " ";
         }
         if(_loc7_.length > 1)
         {
            _loc4_ = "";
            _loc5_ = true;
            _loc6_ = 1;
            while(_loc6_ < 30)
            {
               if(_loc6_ > _loc7_[0].length)
               {
                  break;
               }
               for each(_loc2_ in _loc7_)
               {
                  if(!(_loc5_ = _loc5_ && _loc2_.indexOf(_loc7_[0].substr(0,_loc6_)) == 0))
                  {
                     break;
                  }
               }
               if(!_loc5_)
               {
                  break;
               }
               _loc4_ = _loc7_[0].substr(0,_loc6_);
               _loc6_++;
            }
            return _loc3_ + _loc4_;
         }
         if(_loc7_.length == 1)
         {
            return _loc3_ + _loc7_[0];
         }
         return param1;
      }
      
      public function getAutoCompletePossibilities(param1:String) : Array
      {
         var _loc2_:* = null;
         var _loc3_:Array = new Array();
         for(_loc2_ in this._handlers)
         {
            if(_loc2_.indexOf(param1) == 0)
            {
               _loc3_.push(_loc2_);
            }
         }
         return _loc3_;
      }
      
      public function getAutoCompletePossibilitiesOnParam(param1:String, param2:uint, param3:Array) : Array
      {
         var _loc4_:String = null;
         var _loc5_:ConsoleInstructionHandler = this._handlers[param1];
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         if(_loc5_)
         {
            _loc6_ = _loc5_.getParamPossibilities(param1,param2,param3);
            for each(_loc4_ in _loc6_)
            {
               if(_loc4_.toLowerCase().indexOf(param3[param2].toLowerCase()) == 0)
               {
                  _loc7_.push(_loc4_);
               }
            }
            return _loc7_;
         }
         return [];
      }
      
      private function dispatchMessage(param1:ConsoleInstructionMessage) : void
      {
         var _loc2_:ConsoleInstructionHandler = null;
         var _loc3_:uint = 0;
         if(this._handlers[param1.cmd] != null)
         {
            _loc2_ = this._handlers[param1.cmd] as ConsoleInstructionHandler;
            _loc3_ = getTimer();
            _loc2_.handle(this,param1.cmd,param1.args);
            if(this._displayExecutionTime)
            {
               this.output("Command " + param1.cmd + " executed in " + (getTimer() - _loc3_) + " ms");
            }
            return;
         }
         throw new UnhandledConsoleInstructionError(I18n.getUiText("ui.console.notfound",[param1.cmd]));
      }
   }
}
