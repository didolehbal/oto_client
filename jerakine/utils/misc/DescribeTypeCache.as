package com.ankamagames.jerakine.utils.misc
{
   import flash.utils.Dictionary;
   import flash.utils.Proxy;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   public class DescribeTypeCache
   {
      
      private static var _classDesc:Dictionary = new Dictionary();
      
      private static var _variables:Dictionary = new Dictionary();
      
      private static var _variablesAndAccessor:Dictionary = new Dictionary();
      
      private static var _tags:Dictionary = new Dictionary();
      
      private static var _consts:Dictionary = new Dictionary();
       
      
      public function DescribeTypeCache()
      {
         super();
      }
      
      public static function typeDescription(param1:Object, param2:Boolean = true) : XML
      {
         if(!param2)
         {
            return describeType(param1);
         }
         var _loc3_:String = getQualifiedClassName(param1);
         if(!_classDesc[_loc3_])
         {
            _classDesc[_loc3_] = describeType(param1);
         }
         return _classDesc[_loc3_];
      }
      
      public static function getVariables(param1:Object, param2:Boolean = false, param3:Boolean = true, param4:Boolean = false) : Array
      {
         var _loc5_:Array = null;
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:* = null;
         var _loc9_:String = null;
         var _loc10_:XML = null;
         var _loc11_:String = null;
         var _loc12_:String;
         if((_loc12_ = getQualifiedClassName(param1)) == "Object")
         {
            param3 = false;
         }
         if(param3)
         {
            if(param2 && _variables[_loc12_])
            {
               return _variables[_loc12_];
            }
            if(!param2 && _variablesAndAccessor[_loc12_])
            {
               return _variablesAndAccessor[_loc12_];
            }
         }
         _loc5_ = new Array();
         if((_loc6_ = typeDescription(param1,param3)).@isDynamic.toString() == "true" || param1 is Proxy)
         {
            try
            {
               for(_loc8_ in param1)
               {
                  _loc5_.push(_loc8_);
               }
            }
            catch(e:Error)
            {
            }
         }
         for each(_loc7_ in _loc6_..variable)
         {
            if((_loc9_ = _loc7_.@name.toString()) != "MEMORY_LOG" && _loc9_ != "FLAG" && _loc9_.indexOf("PATTERN") == -1 && _loc9_.indexOf("OFFSET") == -1)
            {
               _loc5_.push(_loc9_);
            }
         }
         if(!param2)
         {
            for each(_loc10_ in _loc6_..accessor)
            {
               if(param4)
               {
                  if(_loc10_.@access.toString() != "readOnly")
                  {
                     if((_loc11_ = _loc10_.@type.toString()) == "uint" || _loc11_ == "int" || _loc11_ == "Number" || _loc11_ == "String" || _loc11_ == "Boolean")
                     {
                        _loc5_.push(_loc10_.@name.toString());
                     }
                  }
               }
               else
               {
                  _loc5_.push(_loc10_.@name.toString());
               }
            }
         }
         if(param3)
         {
            if(param2)
            {
               _variables[_loc12_] = _loc5_;
            }
            else
            {
               _variablesAndAccessor[_loc12_] = _loc5_;
            }
         }
         return _loc5_;
      }
      
      public static function getTags(param1:Object) : Dictionary
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:String = getQualifiedClassName(param1);
         if(_tags[_loc5_])
         {
            return _tags[_loc5_];
         }
         _tags[_loc5_] = new Dictionary();
         var _loc6_:XML = typeDescription(param1);
         for each(_loc2_ in _loc6_..metadata)
         {
            _loc4_ = _loc2_.parent().@name;
            if(!_tags[_loc5_][_loc4_])
            {
               _tags[_loc5_][_loc4_] = new Dictionary();
            }
            _tags[_loc5_][_loc4_][_loc2_.@name.toString()] = true;
         }
         for each(_loc3_ in _loc6_..variable)
         {
            _loc4_ = _loc3_.@name;
            if(!_tags[_loc5_][_loc4_])
            {
               _tags[_loc5_][_loc4_] = new Dictionary();
            }
         }
         for each(_loc3_ in _loc6_..method)
         {
            _loc4_ = _loc3_.@name;
            if(!_tags[_loc5_][_loc4_])
            {
               _tags[_loc5_][_loc4_] = new Dictionary();
            }
         }
         return _tags[_loc5_];
      }
      
      public static function getConstants(param1:Object) : Dictionary
      {
         var _loc2_:XML = null;
         var _loc3_:String = getQualifiedClassName(param1);
         if(_consts[_loc3_])
         {
            return _consts[_loc3_];
         }
         _consts[_loc3_] = new Dictionary();
         var _loc4_:XML = typeDescription(param1);
         for each(_loc2_ in _loc4_..constant)
         {
            _consts[_loc3_][_loc2_.@name.toString()] = _loc2_.@type.toString();
         }
         return _consts[_loc3_];
      }
      
      public static function getConstantName(param1:Class, param2:*) : String
      {
         var _loc3_:* = null;
         var _loc4_:Dictionary = getConstants(param1);
         for(_loc3_ in _loc4_)
         {
            if(param1[_loc3_] === param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}
