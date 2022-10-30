package com.ankamagames.jerakine.utils.system
{
   import flash.utils.Dictionary;
   
   public class CommandLineArguments
   {
      
      private static var _self:CommandLineArguments;
       
      
      private var _arguments:Dictionary;
      
      public function CommandLineArguments()
      {
         this._arguments = new Dictionary();
         super();
      }
      
      public static function getInstance() : CommandLineArguments
      {
         if(!_self)
         {
            _self = new CommandLineArguments();
         }
         return _self;
      }
      
      public function setArguments(param1:Array) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         if(param1)
         {
            for each(_loc2_ in param1)
            {
               _loc3_ = _loc2_.split("=");
               _loc4_ = _loc3_[0].replace(/^--?/,"");
               this._arguments[_loc4_] = _loc3_[1];
            }
         }
      }
      
      public function hasArgument(param1:String) : Boolean
      {
         return this._arguments.hasOwnProperty(param1);
      }
      
      public function getArgument(param1:String) : String
      {
         return this._arguments[param1];
      }
      
      public function toString() : String
      {
         var _loc1_:* = null;
         var _loc2_:Array = [];
         for(_loc1_ in this._arguments)
         {
            _loc2_.push(_loc1_ + "=" + this._arguments[_loc1_]);
         }
         return _loc2_.join("||");
      }
   }
}
