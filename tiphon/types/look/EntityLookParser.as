package com.ankamagames.tiphon.types.look
{
   public class EntityLookParser
   {
      
      public static const CURRENT_FORMAT_VERSION:uint = 0;
      
      public static const DEFAULT_NUMBER_BASE:uint = 10;
       
      
      public function EntityLookParser()
      {
         super();
      }
      
      public static function fromString(param1:String, param2:uint = 0, param3:uint = 10, param4:TiphonEntityLook = null) : TiphonEntityLook
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:Array = null;
         var _loc15_:Number = NaN;
         var _loc16_:String = null;
         var _loc17_:uint = 0;
         var _loc18_:Array = null;
         var _loc19_:String = null;
         var _loc20_:int = 0;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:Array = null;
         var _loc24_:uint = 0;
         var _loc25_:uint = 0;
         var _loc26_:TiphonEntityLook;
         (_loc26_ = !!param4?param4:new TiphonEntityLook()).lock();
         var _loc27_:uint = CURRENT_FORMAT_VERSION;
         var _loc28_:uint = DEFAULT_NUMBER_BASE;
         if(param1.charAt(0) == "[")
         {
            if((_loc5_ = param1.substring(1,param1.indexOf("]"))).indexOf(",") > 0)
            {
               if((_loc6_ = _loc5_.split(",")).length != 2)
               {
                  throw new Error("Malformated headers in an Entity Look string.");
               }
               _loc27_ = uint(_loc6_[0]);
               _loc28_ = getNumberBase(_loc6_[1]);
            }
            else
            {
               _loc27_ = uint(_loc5_);
            }
            param1 = param1.substr(param1.indexOf("]") + 1);
         }
         if(param1.charAt(0) != "{" || param1.charAt(param1.length - 1) != "}")
         {
            throw new Error("Malformed body in an Entity Look string.");
         }
         param1 = param1.substring(1,param1.length - 1);
         var _loc29_:Array = param1.split("|");
         _loc26_.setBone(parseInt(_loc29_[0],_loc28_));
         if(_loc29_.length > 1 && _loc29_[1].length > 0)
         {
            _loc7_ = _loc29_[1].split(",");
            for each(_loc8_ in _loc7_)
            {
               _loc26_.addSkin(parseInt(_loc8_,_loc28_));
            }
         }
         if(_loc29_.length > 2 && _loc29_[2].length > 0)
         {
            _loc9_ = _loc29_[2].split(",");
            for each(_loc10_ in _loc9_)
            {
               if((_loc11_ = _loc10_.split("=")).length != 2)
               {
                  throw new Error("Malformed color in an Entity Look string.");
               }
               _loc12_ = parseInt(_loc11_[0],_loc28_);
               _loc13_ = 0;
               if(_loc11_[1].charAt(0) == "#")
               {
                  _loc13_ = parseInt(_loc11_[1].substr(1),16);
               }
               else
               {
                  _loc13_ = parseInt(_loc11_[1],_loc28_);
               }
               _loc26_.setColor(_loc12_,_loc13_);
            }
         }
         if(_loc29_.length > 3 && _loc29_[3].length > 0)
         {
            if((_loc14_ = _loc29_[3].split(",")).length == 1)
            {
               _loc15_ = parseInt(_loc14_[0],_loc28_) / 100;
               _loc26_.setScales(_loc15_,_loc15_);
            }
            else
            {
               if(_loc14_.length != 2)
               {
                  throw new Error("Malformed scale in an Entity Look string.");
               }
               _loc26_.setScales(parseInt(_loc14_[0],_loc28_) / 100,parseInt(_loc14_[1],_loc28_) / 100);
            }
         }
         else
         {
            _loc26_.setScales(1,1);
         }
         if(_loc29_.length > 4 && _loc29_[4].length > 0)
         {
            _loc16_ = "";
            _loc17_ = 4;
            while(_loc17_ < _loc29_.length)
            {
               _loc16_ = _loc16_ + (_loc29_[_loc17_] + "|");
               _loc17_++;
            }
            _loc16_ = _loc16_.substr(0,_loc16_.length - 1);
            _loc18_ = [];
            while((_loc20_ = _loc16_.indexOf("}")) != -1)
            {
               _loc18_.push(_loc16_.substr(0,_loc20_ + 1));
               _loc16_ = _loc16_.substr(_loc20_ + 1);
            }
            for each(_loc19_ in _loc18_)
            {
               _loc21_ = _loc19_.substring(0,_loc19_.indexOf("="));
               _loc22_ = _loc19_.substr(_loc19_.indexOf("=") + 1);
               if((_loc23_ = _loc21_.split("@")).length != 2)
               {
                  throw new Error("Malformed subentity binding in an Entity Look string.");
               }
               _loc24_ = parseInt(_loc23_[0],_loc28_);
               _loc25_ = parseInt(_loc23_[1],_loc28_);
               _loc26_.addSubEntity(_loc24_,_loc25_,EntityLookParser.fromString(_loc22_,_loc27_,_loc28_));
            }
         }
         _loc26_.unlock(true);
         return _loc26_;
      }
      
      public static function toString(param1:TiphonEntityLook) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         var _loc6_:* = null;
         var _loc7_:Boolean = false;
         var _loc8_:* = null;
         var _loc9_:* = null;
         var _loc10_:TiphonEntityLook = null;
         var _loc11_:* = (_loc11_ = (_loc11_ = "{") + param1.getBone().toString(DEFAULT_NUMBER_BASE)) + "|";
         var _loc12_:Vector.<uint>;
         if((_loc12_ = param1.getSkins(true)) != null)
         {
            _loc2_ = 0;
            _loc3_ = true;
            for each(_loc4_ in _loc12_)
            {
               if(!(_loc2_++ == 0 && param1.defaultSkin != -1))
               {
                  if(_loc3_)
                  {
                     _loc3_ = false;
                  }
                  else
                  {
                     _loc11_ = _loc11_ + ",";
                  }
                  _loc11_ = _loc11_ + _loc4_.toString(DEFAULT_NUMBER_BASE);
               }
            }
         }
         _loc11_ = _loc11_ + "|";
         var _loc13_:Array;
         if((_loc13_ = param1.getColors(true)) != null)
         {
            _loc5_ = true;
            for(_loc6_ in _loc13_)
            {
               if(_loc5_)
               {
                  _loc5_ = false;
               }
               else
               {
                  _loc11_ = _loc11_ + ",";
               }
               _loc11_ = _loc11_ + (uint(_loc6_).toString(DEFAULT_NUMBER_BASE) + "=" + uint(_loc13_[_loc6_]).toString(DEFAULT_NUMBER_BASE));
            }
         }
         _loc11_ = _loc11_ + "|";
         var _loc14_:Number = param1.getScaleX();
         var _loc15_:Number = param1.getScaleY();
         if(_loc14_ != 1 || _loc15_ != 1)
         {
            _loc11_ = _loc11_ + Math.round(_loc14_ * 100).toString(DEFAULT_NUMBER_BASE);
            if(_loc15_ != _loc14_)
            {
               _loc11_ = _loc11_ + ("," + Math.round(_loc15_ * 100).toString(DEFAULT_NUMBER_BASE));
            }
         }
         _loc11_ = _loc11_ + "|";
         var _loc16_:Array;
         if((_loc16_ = param1.getSubEntities(true)) != null)
         {
            _loc7_ = true;
            for(_loc8_ in _loc16_)
            {
               for(_loc9_ in _loc16_[_loc8_])
               {
                  _loc10_ = _loc16_[_loc8_][_loc9_];
                  if(_loc7_)
                  {
                     _loc7_ = false;
                  }
                  else
                  {
                     _loc11_ = _loc11_ + ",";
                  }
                  _loc11_ = _loc11_ + (uint(_loc8_).toString(DEFAULT_NUMBER_BASE) + "@" + uint(_loc9_).toString(DEFAULT_NUMBER_BASE) + "=" + _loc10_.toString());
               }
            }
         }
         while(_loc11_.charAt(_loc11_.length - 1) == "|")
         {
            _loc11_ = _loc11_.substr(0,_loc11_.length - 1);
         }
         return _loc11_ + "}";
      }
      
      private static function getNumberBase(param1:String) : uint
      {
         switch(param1)
         {
            case "A":
               return 10;
            case "G":
               return 16;
            case "Z":
               return 36;
            default:
               throw new Error("Unknown number base type \'" + param1 + "\' in an Entity Look string.");
         }
      }
   }
}
