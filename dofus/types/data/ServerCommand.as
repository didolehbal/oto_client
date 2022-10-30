package com.ankamagames.dofus.types.data
{
   public class ServerCommand
   {
      
      private static var _cmdList:Array = [];
      
      private static var _cmdByName:Array = [];
       
      
      public var name:String;
      
      public var help:String;
      
      public function ServerCommand(param1:String, param2:String)
      {
         super();
         this.name = param1;
         this.help = param2;
         if(!_cmdByName[param1])
         {
            _cmdByName[param1] = this;
            _cmdList.push(param1);
         }
      }
      
      public static function get commandList() : Array
      {
         return _cmdList;
      }
      
      public static function autoComplete(param1:String) : String
      {
         var _loc2_:* = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:Array = new Array();
         for(_loc2_ in _cmdByName)
         {
            if(_loc2_.indexOf(param1) == 0)
            {
               _loc6_.push(_loc2_);
            }
         }
         if(_loc6_.length > 1)
         {
            _loc3_ = "";
            _loc4_ = true;
            _loc5_ = 1;
            while(_loc5_ < 30)
            {
               if(_loc5_ > _loc6_[0].length)
               {
                  break;
               }
               for each(_loc2_ in _loc6_)
               {
                  if(!(_loc4_ = _loc4_ && _loc2_.indexOf(_loc6_[0].substr(0,_loc5_)) == 0))
                  {
                     break;
                  }
               }
               if(!_loc4_)
               {
                  break;
               }
               _loc3_ = _loc6_[0].substr(0,_loc5_);
               _loc5_++;
            }
            return _loc3_;
         }
         return _loc6_[0];
      }
      
      public static function getAutoCompletePossibilities(param1:String) : Array
      {
         var _loc2_:* = null;
         var _loc3_:Array = new Array();
         for(_loc2_ in _cmdByName)
         {
            if(_loc2_.indexOf(param1) == 0)
            {
               _loc3_.push(_loc2_);
            }
         }
         return _loc3_;
      }
      
      public static function getHelp(param1:String) : String
      {
         return !!_cmdByName[param1]?_cmdByName[param1].help:null;
      }
      
      public static function hasCommand(param1:String) : Boolean
      {
         return _cmdByName.hasOwnProperty(param1);
      }
   }
}
