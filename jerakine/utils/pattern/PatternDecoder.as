package com.ankamagames.jerakine.utils.pattern
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class PatternDecoder
   {
      
      public static const _log:Logger = Log.getLogger(getQualifiedClassName(PatternDecoder));
       
      
      public function PatternDecoder()
      {
         super();
      }
      
      public static function getDescription(param1:String, param2:Array) : String
      {
         var _loc3_:Array = param1.split("");
         return decodeDescription(_loc3_,param2).join("");
      }
      
      public static function combine(param1:String, param2:String, param3:Boolean) : String
      {
         if(!param1)
         {
            return "";
         }
         var _loc4_:Array = param1.split("");
         var _loc5_:Object;
         (_loc5_ = new Object()).m = param2 == "m";
         _loc5_.f = param2 == "f";
         _loc5_.n = param2 == "n";
         _loc5_.p = !param3;
         _loc5_.s = param3;
         return decodeCombine(_loc4_,_loc5_).join("");
      }
      
      public static function decode(param1:String, param2:Array) : String
      {
         if(!param1)
         {
            return "";
         }
         return decodeCombine(param1.split(""),param2).join("");
      }
      
      public static function replace(param1:String, param2:String) : String
      {
         var _loc3_:Array = null;
         var _loc4_:Array = param1.split("##");
         var _loc5_:uint = 1;
         while(_loc5_ < _loc4_.length)
         {
            _loc3_ = _loc4_[_loc5_].split(",");
            _loc4_[_loc5_] = getDescription(param2,_loc3_);
            _loc5_ = _loc5_ + 2;
         }
         return _loc4_.join("");
      }
      
      public static function replaceStr(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:Array;
         return (_loc4_ = param1.split(param2)).join(param3);
      }
      
      private static function findOptionnalDices(param1:Array, param2:Array) : Array
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = param1.length;
         var _loc6_:* = "";
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         var _loc9_:Array = param1;
         var _loc10_:Number = find(param1,"{");
         var _loc11_:Number = find(param1,"}");
         if(_loc10_ >= 0 && _loc11_ > _loc10_)
         {
            _loc3_ = 0;
            while(param1[_loc10_ - (_loc3_ + 1)] == " ")
            {
               _loc3_++;
            }
            _loc4_ = 0;
            while(param1[_loc11_ + (_loc4_ + 1)] == " ")
            {
               _loc4_++;
            }
            _loc7_ = param1.slice(0,_loc10_ - (2 + _loc3_));
            _loc8_ = param1.slice(_loc11_ - _loc10_ + 5 + _loc4_ + _loc3_,param1.length - (_loc11_ - _loc10_));
            if(param1[0] == "#" && param1[param1.length - 2] == "#")
            {
               if(param2[1] == null && param2[2] == null && param2[3] == null)
               {
                  _loc7_.push(param2[0]);
               }
               else if(param2[0] == 0 && param2[1] == 0)
               {
                  _loc7_.push(param2[2]);
               }
               else if(!param2[2])
               {
                  param1.splice(param1.indexOf("#"),2,param2[0]);
                  param1.splice(param1.indexOf("{"),1);
                  param1.splice(param1.indexOf("~"),4);
                  param1.splice(param1.indexOf("#"),2,param2[1]);
                  param1.splice(param1.indexOf("}"),1);
                  _loc7_ = _loc7_.concat(param1);
               }
               else
               {
                  param1.splice(param1.indexOf("#"),2,param2[0] + param2[2]);
                  param1.splice(param1.indexOf("{"),1);
                  param1.splice(param1.indexOf("~"),4);
                  param1.splice(param1.indexOf("#"),2,param2[0] * param2[1] + param2[2]);
                  param1.splice(param1.indexOf("}"),1);
                  _loc7_ = _loc7_.concat(param1);
               }
               _loc9_ = _loc7_.concat(_loc8_);
            }
         }
         return _loc9_;
      }
      
      private static function decodeDescription(param1:Array, param2:Array) : Array
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         _loc3_ = 0;
         var _loc10_:String = new String();
         var _loc11_:Number = param1.length;
         param1 = findOptionnalDices(param1,param2);
         for(; _loc3_ < _loc11_; _loc3_++)
         {
            _loc10_ = param1[_loc3_];
            switch(_loc10_)
            {
               case "#":
                  _loc4_ = param1[_loc3_ + 1];
                  if(!isNaN(_loc4_))
                  {
                     if(param2[_loc4_ - 1] != undefined)
                     {
                        param1.splice(_loc3_,2,param2[_loc4_ - 1]);
                        _loc3_--;
                     }
                     else
                     {
                        param1.splice(_loc3_,2);
                        _loc3_ = _loc3_ - 2;
                     }
                  }
                  continue;
               case "~":
                  _loc5_ = param1[_loc3_ + 1];
                  if(!isNaN(_loc5_))
                  {
                     if(param2[_loc5_ - 1] == null)
                     {
                        return param1.slice(0,_loc3_);
                     }
                     param1.splice(_loc3_,2);
                     _loc3_ = _loc3_ - 2;
                  }
                  continue;
               case "{":
                  _loc6_ = find(param1.slice(_loc3_),"}");
                  _loc7_ = decodeDescription(param1.slice(_loc3_ + 1,_loc3_ + _loc6_),param2).join("");
                  param1.splice(_loc3_,_loc6_ + 1,_loc7_);
                  continue;
               case "[":
                  _loc8_ = find(param1.slice(_loc3_),"]");
                  _loc9_ = Number(param1.slice(_loc3_ + 1,_loc3_ + _loc8_).join(""));
                  if(!isNaN(_loc9_))
                  {
                     param1.splice(_loc3_,_loc8_ + 1,param2[_loc9_] + " ");
                     _loc3_ = _loc3_ - _loc8_;
                  }
                  continue;
               default:
                  continue;
            }
         }
         return param1;
      }
      
      private static function decodeCombine(param1:Array, param2:Object) : Array
      {
         var _loc3_:Number = NaN;
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:String = null;
         _loc3_ = 0;
         var _loc8_:String = new String();
         var _loc9_:Number = param1.length;
         for(; _loc3_ < _loc9_; _loc3_++)
         {
            _loc8_ = param1[_loc3_];
            switch(_loc8_)
            {
               case "~":
                  _loc4_ = param1[_loc3_ + 1];
                  if(param2[_loc4_])
                  {
                     param1.splice(_loc3_,2);
                     _loc3_ = _loc3_ - 2;
                     continue;
                  }
                  return param1.slice(0,_loc3_);
                  break;
               case "{":
                  _loc5_ = find(param1.slice(_loc3_),"}");
                  _loc6_ = -1;
                  if(_loc5_ > -1)
                  {
                     _loc6_ = find(param1.slice(_loc3_,_loc3_ + _loc5_),":");
                  }
                  if(_loc6_ == -1 || !param1[_loc3_ + _loc6_ + 1] || param1[_loc3_ + _loc6_ + 1] != ":")
                  {
                     _loc7_ = decodeCombine(param1.slice(_loc3_ + 1,_loc3_ + _loc5_),param2).join("");
                     param1.splice(_loc3_,_loc5_ + 1,_loc7_);
                  }
                  continue;
               default:
                  continue;
            }
         }
         return param1;
      }
      
      private static function find(param1:Array, param2:Object) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = param1.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1[_loc3_] == param2)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
   }
}
