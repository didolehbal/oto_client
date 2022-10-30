package com.ankamagames.jerakine.eval
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class Evaluator
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Evaluator));
      
      private static const NUMBER:uint = 0;
      
      private static const STRING:uint = 1;
       
      
      public function Evaluator()
      {
         super();
      }
      
      public function eval(param1:String) : *
      {
         return this.complexEval(param1);
      }
      
      private function simpleEval(param1:String) : *
      {
         var _loc2_:Function = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
         var _loc10_:* = false;
         var _loc11_:Boolean = false;
         var _loc15_:uint = 0;
         var _loc17_:uint = 0;
         var _loc9_:* = "";
         var _loc12_:* = "";
         var _loc13_:uint = STRING;
         var _loc14_:Array = new Array();
         while(_loc15_ < param1.length)
         {
            _loc3_ = param1.charAt(_loc15_);
            if(_loc3_ == "\'" && !_loc11_)
            {
               _loc13_ = STRING;
               _loc10_ = !_loc10_;
            }
            else if(_loc3_ == "\\")
            {
               _loc11_ = true;
            }
            else if(!_loc10_)
            {
               switch(_loc3_)
               {
                  case "(":
                  case ")":
                  case " ":
                  case "\t":
                  case "\n":
                     break;
                  case "0":
                  case "1":
                  case "2":
                  case "3":
                  case "4":
                  case "5":
                  case "6":
                  case "7":
                  case "8":
                  case "9":
                     _loc13_ = NUMBER;
                     _loc9_ = "";
                     _loc2_ = null;
                     _loc12_ = _loc12_ + _loc3_;
                     break;
                  case ".":
                     _loc12_ = _loc12_ + ".";
                     break;
                  default:
                     if(_loc3_ == "-" || _loc3_ == "+")
                     {
                        if(!_loc12_.length)
                        {
                           _loc12_ = _loc12_ + _loc3_;
                           break;
                        }
                     }
                     _loc6_ = true;
                     _loc7_ = false;
                     _loc9_ = _loc9_ + _loc3_;
                     switch(_loc9_)
                     {
                        case "-":
                           _loc2_ = this.minus;
                           break;
                        case "+":
                           _loc2_ = this.plus;
                           break;
                        case "*":
                           _loc2_ = this.multiply;
                           break;
                        case "/":
                           _loc2_ = this.divide;
                           break;
                        case ">":
                           if(param1.charAt(_loc15_ + 1) != "=")
                           {
                              _loc2_ = this.sup;
                           }
                           else
                           {
                              _loc7_ = true;
                              _loc6_ = false;
                           }
                           break;
                        case ">=":
                           _loc2_ = this.supOrEquals;
                           break;
                        case "<":
                           if(param1.charAt(_loc15_ + 1) != "=")
                           {
                              _loc2_ = this.inf;
                           }
                           else
                           {
                              _loc7_ = true;
                              _loc6_ = false;
                           }
                           break;
                        case "<=":
                           _loc2_ = this.infOrEquals;
                           break;
                        case "&&":
                           _loc2_ = this.and;
                           break;
                        case "||":
                           _loc2_ = this.or;
                           break;
                        case "==":
                           _loc2_ = this.equals;
                           break;
                        case "!=":
                           _loc2_ = this.diff;
                           break;
                        case "?":
                           _loc2_ = this.ternary;
                           break;
                        case ":":
                           _loc2_ = this.opElse;
                           break;
                        case "|":
                        case "=":
                        case "&":
                        case "!":
                           _loc7_ = true;
                        default:
                           _loc6_ = false;
                     }
                     if(_loc6_)
                     {
                        if(_loc12_.length)
                        {
                           if(_loc13_ == STRING)
                           {
                              _loc14_.push(_loc12_);
                           }
                           else
                           {
                              _loc14_.push(parseFloat(_loc12_));
                           }
                           _loc14_.push(_loc2_);
                        }
                        else
                        {
                           _log.warn(this.showPosInExpr(_loc15_,param1));
                           _log.warn("Expecting Number at char " + _loc15_ + ", but found operator " + _loc3_);
                        }
                        _loc12_ = "";
                     }
                     else if(!_loc7_)
                     {
                        _log.warn(this.showPosInExpr(_loc15_,param1));
                        _log.warn("Bad character at " + _loc15_);
                     }
               }
            }
            else
            {
               _loc9_ = "";
               _loc2_ = null;
               _loc12_ = _loc12_ + _loc3_;
               _loc11_ = false;
            }
            _loc15_++;
         }
         if(_loc12_.length)
         {
            if(_loc13_ == STRING)
            {
               _loc14_.push(_loc12_);
            }
            else
            {
               _loc14_.push(parseFloat(_loc12_));
            }
         }
         var _loc16_:Array = [this.divide,this.multiply,this.minus,this.plus,this.sup,this.inf,this.supOrEquals,this.infOrEquals,this.equals,this.diff,this.and,this.or,this.ternary];
         while(_loc17_ < _loc16_.length)
         {
            _loc4_ = new Array();
            _loc8_ = 0;
            while(_loc8_ < _loc14_.length)
            {
               if(_loc14_[_loc8_] is Function && _loc14_[_loc8_] == _loc16_[_loc17_])
               {
                  if((_loc5_ = _loc4_[_loc4_.length - 1]) is Number || (_loc14_[_loc8_] == this.plus || _loc14_[_loc8_] == this.ternary || _loc14_[_loc8_] == this.equals || _loc14_[_loc8_] == this.diff) && _loc5_ is String)
                  {
                     if(_loc14_[_loc8_ + 1] is Number || (_loc14_[_loc8_] == this.plus || _loc14_[_loc8_] == this.ternary || _loc14_[_loc8_] == this.equals || _loc14_[_loc8_] == this.diff) && _loc14_[_loc8_ + 1] is String)
                     {
                        if(_loc14_[_loc8_] === this.ternary)
                        {
                           if(_loc14_[_loc8_ + 2] == this.opElse)
                           {
                              _loc4_[_loc4_.length - 1] = this.ternary(_loc5_,_loc14_[_loc8_ + 1],_loc14_[_loc8_ + 3]);
                              _loc8_ = _loc8_ + 2;
                           }
                           else
                           {
                              _log.warn("operator \':\' not found");
                           }
                        }
                        else
                        {
                           _loc4_[_loc4_.length - 1] = _loc14_[_loc8_](_loc5_,_loc14_[_loc8_ + 1]);
                        }
                     }
                     else
                     {
                        _log.warn("Expect Number, but find [" + _loc14_[_loc8_ + 1] + "]");
                     }
                     _loc8_++;
                  }
                  else if((_loc5_ = _loc14_[_loc8_ - 1]) is Number || (_loc14_[_loc8_] == this.plus || _loc14_[_loc8_] == this.ternary || _loc14_[_loc8_] == this.equals || _loc14_[_loc8_] == this.diff) && _loc5_ is String)
                  {
                     if(_loc14_[_loc8_ + 1] is Number || (_loc14_[_loc8_] == this.plus || _loc14_[_loc8_] == this.ternary || _loc14_[_loc8_] == this.equals || _loc14_[_loc8_] == this.diff) && _loc14_[_loc8_ + 1] is String)
                     {
                        if(_loc14_[_loc8_] === this.ternary)
                        {
                           if(_loc14_[_loc8_ + 2] == this.opElse)
                           {
                              _loc4_[_loc4_.length - 1] = this.ternary(_loc5_,_loc14_[_loc8_ + 1],_loc14_[_loc8_ + 3]);
                           }
                           else
                           {
                              _log.warn("operator \':\' not found");
                           }
                        }
                        else
                        {
                           _loc4_.push(_loc14_[_loc8_](_loc5_,_loc14_[_loc8_ + 1]));
                        }
                     }
                     else
                     {
                        _log.warn("Expect Number,  but find [" + _loc14_[_loc8_ + 1] + "]");
                     }
                     _loc8_++;
                  }
               }
               else
               {
                  _loc4_.push(_loc14_[_loc8_]);
               }
               _loc8_++;
            }
            _loc14_ = _loc4_;
            _loc17_++;
         }
         return _loc14_[0];
      }
      
      private function complexEval(param1:String) : *
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:uint = 0;
         var _loc6_:int = 0;
         param1 = this.trim(param1);
         var _loc5_:Boolean = true;
         while(_loc5_)
         {
            _loc5_ = false;
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               if(param1.charAt(_loc4_) == "(")
               {
                  if(!_loc6_)
                  {
                     _loc2_ = _loc4_;
                  }
                  _loc6_++;
               }
               if(param1.charAt(_loc4_) == ")")
               {
                  if(!--_loc6_)
                  {
                     _loc3_ = this.complexEval(param1.substr(_loc2_ + 1,_loc4_ - _loc2_ - 1));
                     param1 = param1.substr(0,_loc2_) + (_loc3_ is Number?_loc3_:"\'" + _loc3_ + "\'") + param1.substr(_loc4_ + 1);
                     _loc5_ = true;
                     break;
                  }
               }
               _loc4_++;
            }
         }
         if(_loc6_)
         {
            _log.warn("Missing right parenthesis in " + param1);
         }
         return this.simpleEval(param1);
      }
      
      private function plus(param1:*, param2:*) : *
      {
         return param1 + param2;
      }
      
      private function minus(param1:Number, param2:Number) : Number
      {
         return param1 - param2;
      }
      
      private function multiply(param1:Number, param2:Number) : Number
      {
         return param1 * param2;
      }
      
      private function divide(param1:Number, param2:Number) : Number
      {
         return param1 / param2;
      }
      
      private function sup(param1:Number, param2:Number) : Number
      {
         return param1 > param2?Number(1):Number(0);
      }
      
      private function supOrEquals(param1:Number, param2:Number) : Number
      {
         return param1 >= param2?Number(1):Number(0);
      }
      
      private function inf(param1:Number, param2:Number) : Number
      {
         return param1 < param2?Number(1):Number(0);
      }
      
      private function infOrEquals(param1:Number, param2:Number) : Number
      {
         return param1 <= param2?Number(1):Number(0);
      }
      
      private function and(param1:Number, param2:Number) : Number
      {
         return param1 && param2?Number(1):Number(0);
      }
      
      private function or(param1:Number, param2:Number) : Number
      {
         return param1 || param2?Number(1):Number(0);
      }
      
      private function equals(param1:*, param2:*) : Number
      {
         return param1 == param2?Number(1):Number(0);
      }
      
      private function diff(param1:*, param2:*) : Number
      {
         return param1 != param2?Number(1):Number(0);
      }
      
      private function ternary(param1:Number, param2:*, param3:*) : *
      {
         return !!param1?param2:param3;
      }
      
      private function opElse() : void
      {
      }
      
      private function showPosInExpr(param1:uint, param2:String) : String
      {
         var _loc4_:uint = 0;
         var _loc3_:* = param2 + "\n";
         while(_loc4_ < param1)
         {
            _loc3_ = _loc3_ + " ";
            _loc4_++;
         }
         return _loc3_ + "^";
      }
      
      private function trim(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:* = false;
         var _loc6_:uint = 0;
         var _loc3_:* = "";
         while(_loc6_ < param1.length)
         {
            _loc2_ = param1.charAt(_loc6_);
            if(_loc2_ == "\'" && !_loc4_)
            {
               _loc5_ = !_loc5_;
            }
            if(_loc2_ == "\\")
            {
               _loc4_ = true;
            }
            else
            {
               _loc4_ = false;
            }
            if(_loc2_ != " " || _loc5_)
            {
               _loc3_ = _loc3_ + _loc2_;
            }
            _loc6_++;
         }
         return _loc3_;
      }
   }
}
