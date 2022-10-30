package com.ankamagames.jerakine.json
{
   public class JSONTokenizer
   {
       
      
      private var strict:Boolean;
      
      private var obj:Object;
      
      private var jsonString:String;
      
      private var loc:int;
      
      private var ch:String;
      
      private var controlCharsRegExp:RegExp;
      
      public function JSONTokenizer(param1:String, param2:Boolean)
      {
         this.controlCharsRegExp = /[\x00-\x1F]/;
         super();
         this.jsonString = param1;
         this.strict = param2;
         this.loc = 0;
         this.nextChar();
      }
      
      public function getNextToken() : JSONToken
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:JSONToken = new JSONToken();
         this.skipIgnored();
         switch(this.ch)
         {
            case "{":
               _loc5_.type = JSONTokenType.LEFT_BRACE;
               _loc5_.value = "{";
               this.nextChar();
               break;
            case "}":
               _loc5_.type = JSONTokenType.RIGHT_BRACE;
               _loc5_.value = "}";
               this.nextChar();
               break;
            case "[":
               _loc5_.type = JSONTokenType.LEFT_BRACKET;
               _loc5_.value = "[";
               this.nextChar();
               break;
            case "]":
               _loc5_.type = JSONTokenType.RIGHT_BRACKET;
               _loc5_.value = "]";
               this.nextChar();
               break;
            case ",":
               _loc5_.type = JSONTokenType.COMMA;
               _loc5_.value = ",";
               this.nextChar();
               break;
            case ":":
               _loc5_.type = JSONTokenType.COLON;
               _loc5_.value = ":";
               this.nextChar();
               break;
            case "t":
               _loc1_ = "t" + this.nextChar() + this.nextChar() + this.nextChar();
               if(_loc1_ == "true")
               {
                  _loc5_.type = JSONTokenType.TRUE;
                  _loc5_.value = true;
                  this.nextChar();
               }
               else
               {
                  this.parseError("Expecting \'true\' but found " + _loc1_);
               }
               break;
            case "f":
               _loc2_ = "f" + this.nextChar() + this.nextChar() + this.nextChar() + this.nextChar();
               if(_loc2_ == "false")
               {
                  _loc5_.type = JSONTokenType.FALSE;
                  _loc5_.value = false;
                  this.nextChar();
               }
               else
               {
                  this.parseError("Expecting \'false\' but found " + _loc2_);
               }
               break;
            case "n":
               _loc3_ = "n" + this.nextChar() + this.nextChar() + this.nextChar();
               if(_loc3_ == "null")
               {
                  _loc5_.type = JSONTokenType.NULL;
                  _loc5_.value = null;
                  this.nextChar();
               }
               else
               {
                  this.parseError("Expecting \'null\' but found " + _loc3_);
               }
               break;
            case "N":
               if((_loc4_ = "N" + this.nextChar() + this.nextChar()) == "NaN")
               {
                  _loc5_.type = JSONTokenType.NAN;
                  _loc5_.value = NaN;
                  this.nextChar();
               }
               else
               {
                  this.parseError("Expecting \'NaN\' but found " + _loc4_);
               }
               break;
            case "\"":
               _loc5_ = this.readString();
               break;
            default:
               if(this.isDigit(this.ch) || this.ch == "-")
               {
                  _loc5_ = this.readNumber();
               }
               else
               {
                  if(this.ch == "")
                  {
                     return null;
                  }
                  this.parseError("Unexpected " + this.ch + " encountered");
               }
         }
         return _loc5_;
      }
      
      private function readString() : JSONToken
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = this.loc;
         while(true)
         {
            _loc3_ = this.jsonString.indexOf("\"",_loc3_);
            if(_loc3_ >= 0)
            {
               _loc1_ = 0;
               _loc2_ = _loc3_ - 1;
               while(this.jsonString.charAt(_loc2_) == "\\")
               {
                  _loc1_++;
                  _loc2_--;
               }
               if(_loc1_ % 2 == 0)
               {
                  break;
               }
               _loc3_++;
            }
            else
            {
               this.parseError("Unterminated string literal");
            }
         }
         var _loc4_:JSONToken;
         (_loc4_ = new JSONToken()).type = JSONTokenType.STRING;
         _loc4_.value = this.unescapeString(this.jsonString.substr(this.loc,_loc3_ - this.loc));
         this.loc = _loc3_ + 1;
         this.nextChar();
         return _loc4_;
      }
      
      public function unescapeString(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this.strict && this.controlCharsRegExp.test(param1))
         {
            this.parseError("String contains unescaped control character (0x00-0x1F)");
         }
         var _loc7_:* = "";
         var _loc10_:int = param1.length;
         do
         {
            if((_loc8_ = param1.indexOf("\\",_loc9_)) < 0)
            {
               _loc7_ = _loc7_ + param1.substr(_loc9_);
               break;
            }
            _loc7_ = _loc7_ + param1.substr(_loc9_,_loc8_ - _loc9_);
            _loc9_ = _loc8_ + 2;
            _loc2_ = _loc8_ + 1;
            _loc3_ = param1.charAt(_loc2_);
            switch(_loc3_)
            {
               case "\"":
                  _loc7_ = _loc7_ + "\"";
                  continue;
               case "\\":
                  _loc7_ = _loc7_ + "\\";
                  continue;
               case "n":
                  _loc7_ = _loc7_ + "\n";
                  continue;
               case "r":
                  _loc7_ = _loc7_ + "\r";
                  continue;
               case "t":
                  _loc7_ = _loc7_ + "\t";
                  continue;
               case "u":
                  _loc4_ = "";
                  if(_loc9_ + 4 > _loc10_)
                  {
                     this.parseError("Unexpected end of input.  Expecting 4 hex digits after \\u.");
                  }
                  _loc5_ = _loc9_;
                  while(_loc5_ < _loc9_ + 4)
                  {
                     _loc6_ = param1.charAt(_loc5_);
                     if(!this.isHexDigit(_loc6_))
                     {
                        this.parseError("Excepted a hex digit, but found: " + _loc6_);
                     }
                     _loc4_ = _loc4_ + _loc6_;
                     _loc5_++;
                  }
                  _loc7_ = _loc7_ + String.fromCharCode(parseInt(_loc4_,16));
                  _loc9_ = _loc9_ + 4;
                  continue;
               case "f":
                  _loc7_ = _loc7_ + "\f";
                  continue;
               case "/":
                  _loc7_ = _loc7_ + "/";
                  continue;
               case "b":
                  _loc7_ = _loc7_ + "\b";
                  continue;
               default:
                  _loc7_ = _loc7_ + ("\\" + _loc3_);
                  continue;
            }
         }
         while(_loc9_ < _loc10_);
         
         return _loc7_;
      }
      
      private function readNumber() : JSONToken
      {
         var _loc1_:JSONToken = null;
         var _loc2_:* = "";
         if(this.ch == "-")
         {
            _loc2_ = _loc2_ + "-";
            this.nextChar();
         }
         if(!this.isDigit(this.ch))
         {
            this.parseError("Expecting a digit");
         }
         if(this.ch == "0")
         {
            _loc2_ = _loc2_ + this.ch;
            this.nextChar();
            if(this.isDigit(this.ch))
            {
               this.parseError("A digit cannot immediately follow 0");
            }
            else if(!this.strict && this.ch == "x")
            {
               _loc2_ = _loc2_ + this.ch;
               this.nextChar();
               if(this.isHexDigit(this.ch))
               {
                  _loc2_ = _loc2_ + this.ch;
                  this.nextChar();
               }
               else
               {
                  this.parseError("Number in hex format require at least one hex digit after \"0x\"");
               }
               while(this.isHexDigit(this.ch))
               {
                  _loc2_ = _loc2_ + this.ch;
                  this.nextChar();
               }
            }
         }
         else
         {
            while(this.isDigit(this.ch))
            {
               _loc2_ = _loc2_ + this.ch;
               this.nextChar();
            }
         }
         if(this.ch == ".")
         {
            _loc2_ = _loc2_ + ".";
            this.nextChar();
            if(!this.isDigit(this.ch))
            {
               this.parseError("Expecting a digit");
            }
            while(this.isDigit(this.ch))
            {
               _loc2_ = _loc2_ + this.ch;
               this.nextChar();
            }
         }
         if(this.ch == "e" || this.ch == "E")
         {
            _loc2_ = _loc2_ + "e";
            this.nextChar();
            if(this.ch == "+" || this.ch == "-")
            {
               _loc2_ = _loc2_ + this.ch;
               this.nextChar();
            }
            if(!this.isDigit(this.ch))
            {
               this.parseError("Scientific notation number needs exponent value");
            }
            while(this.isDigit(this.ch))
            {
               _loc2_ = _loc2_ + this.ch;
               this.nextChar();
            }
         }
         var _loc3_:Number = Number(_loc2_);
         if(isFinite(_loc3_) && !isNaN(_loc3_))
         {
            _loc1_ = new JSONToken();
            _loc1_.type = JSONTokenType.NUMBER;
            _loc1_.value = _loc3_;
            return _loc1_;
         }
         this.parseError("Number " + _loc3_ + " is not valid!");
         return null;
      }
      
      private function nextChar() : String
      {
         return this.ch = this.jsonString.charAt(this.loc++);
      }
      
      private function skipIgnored() : void
      {
         var _loc1_:int = 0;
         do
         {
            _loc1_ = this.loc;
            this.skipWhite();
            this.skipComments();
         }
         while(_loc1_ != this.loc);
         
      }
      
      private function skipComments() : void
      {
         if(this.ch == "/")
         {
            this.nextChar();
            switch(this.ch)
            {
               case "/":
                  do
                  {
                     this.nextChar();
                  }
                  while(this.ch != "\n" && this.ch != "");
                  
                  this.nextChar();
                  return;
               case "*":
                  this.nextChar();
                  while(true)
                  {
                     if(this.ch == "*")
                     {
                        this.nextChar();
                        if(this.ch == "/")
                        {
                           break;
                        }
                     }
                     else
                     {
                        this.nextChar();
                     }
                     if(this.ch == "")
                     {
                        this.parseError("Multi-line comment not closed");
                     }
                  }
                  this.nextChar();
                  return;
               default:
                  this.parseError("Unexpected " + this.ch + " encountered (expecting \'/\' or \'*\' )");
            }
         }
      }
      
      private function skipWhite() : void
      {
         while(this.isWhiteSpace(this.ch))
         {
            this.nextChar();
         }
      }
      
      private function isWhiteSpace(param1:String) : Boolean
      {
         if(param1 == " " || param1 == "\t" || param1 == "\n" || param1 == "\r")
         {
            return true;
         }
         if(!this.strict && param1.charCodeAt(0) == 160)
         {
            return true;
         }
         return false;
      }
      
      private function isDigit(param1:String) : Boolean
      {
         return param1 >= "0" && param1 <= "9";
      }
      
      private function isHexDigit(param1:String) : Boolean
      {
         return this.isDigit(param1) || param1 >= "A" && param1 <= "F" || param1 >= "a" && param1 <= "f";
      }
      
      public function parseError(param1:String) : void
      {
         throw new JSONParseError(param1,this.loc,this.jsonString);
      }
   }
}
