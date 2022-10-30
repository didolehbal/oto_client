package com.ankamagames.jerakine.json
{
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   public class JSONEncoder
   {
       
      
      private var _depthLimit:uint = 0;
      
      private var _showObjectType:Boolean = false;
      
      private var jsonString:String;
      
      public function JSONEncoder(param1:*, param2:uint = 0, param3:Boolean = false)
      {
         super();
         this._depthLimit = param2;
         this._showObjectType = param3;
         this.jsonString = this.convertToString(param1);
      }
      
      public function getString() : String
      {
         return this.jsonString;
      }
      
      private function convertToString(param1:*, param2:int = 0) : String
      {
         if(this._depthLimit != 0 && param2 > this._depthLimit)
         {
            return "";
         }
         if(param1 is String)
         {
            return this.escapeString(param1 as String);
         }
         if(param1 is Number)
         {
            return !!isFinite(param1 as Number)?param1.toString():"null";
         }
         if(param1 is Boolean)
         {
            return !!param1?"true":"false";
         }
         if(param1 is Array || param1 is Vector.<int> || param1 is Vector.<uint> || param1 is Vector.<String> || param1 is Vector.<Boolean> || param1 is Vector.<*> || param1 is Dictionary)
         {
            return this.arrayToString(param1,param2 + 1);
         }
         if(param1 is Object && param1 != null)
         {
            return this.objectToString(param1,param2 + 1);
         }
         return "null";
      }
      
      private function escapeString(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc7_:int = 0;
         var _loc5_:* = "";
         var _loc6_:Number = param1.length;
         for(; _loc7_ < _loc6_; _loc7_++)
         {
            _loc2_ = param1.charAt(_loc7_);
            switch(_loc2_)
            {
               case "\"":
                  _loc5_ = _loc5_ + "\\\"";
                  continue;
               case "\\":
                  _loc5_ = _loc5_ + "\\\\";
                  continue;
               case "\b":
                  _loc5_ = _loc5_ + "\\b";
                  continue;
               case "\f":
                  _loc5_ = _loc5_ + "\\f";
                  continue;
               case "\n":
                  _loc5_ = _loc5_ + "\\n";
                  continue;
               case "\r":
                  _loc5_ = _loc5_ + "\\r";
                  continue;
               case "\t":
                  _loc5_ = _loc5_ + "\\t";
                  continue;
               default:
                  if(_loc2_ < " ")
                  {
                     _loc3_ = _loc2_.charCodeAt(0).toString(16);
                     _loc4_ = _loc3_.length == 2?"00":"000";
                     _loc5_ = _loc5_ + ("\\u" + _loc4_ + _loc3_);
                  }
                  else
                  {
                     _loc5_ = _loc5_ + _loc2_;
                  }
                  continue;
            }
         }
         return "\"" + _loc5_ + "\"";
      }
      
      private function arrayToString(param1:*, param2:int) : String
      {
         var _loc3_:* = undefined;
         if(this._depthLimit != 0 && param2 > this._depthLimit)
         {
            return "";
         }
         var _loc4_:* = "";
         for each(_loc3_ in param1)
         {
            if(_loc4_.length > 0)
            {
               _loc4_ = _loc4_ + ",";
            }
            _loc4_ = _loc4_ + this.convertToString(_loc3_);
         }
         return "[" + _loc4_ + "]";
      }
      
      private function objectToString(param1:Object, param2:int) : String
      {
         var className:Array = null;
         var value:Object = null;
         var key:String = null;
         var v:XML = null;
         var o:Object = param1;
         var depth:int = param2;
         if(this._depthLimit != 0 && depth > this._depthLimit)
         {
            return "";
         }
         var s:String = "";
         var classInfo:XML = describeType(o);
         if(classInfo.@name.toString() == "Object")
         {
            for(key in o)
            {
               value = o[key];
               if(!(value is Function))
               {
                  if(s.length > 0)
                  {
                     s = s + ",";
                  }
                  s = s + (this.escapeString(key) + ":" + this.convertToString(value));
               }
            }
         }
         else
         {
            var _loc4_:int = 0;
            for each(v in classInfo..*.(name() == "variable" || name() == "accessor" && attribute("access").charAt(0) == "r"))
            {
               if(!(v.metadata && v.metadata.(@name == "Transient").length() > 0))
               {
                  if(s.length > 0)
                  {
                     s = s + ",";
                  }
                  try
                  {
                     s = s + (this.escapeString(v.@name.toString()) + ":" + this.convertToString(o[v.@name]));
                  }
                  catch(e:Error)
                  {
                  }
               }
            }
         }
         if(this._showObjectType)
         {
            className = getQualifiedClassName(o).split("::");
         }
         if(className != null)
         {
            return "{" + this.escapeString("type") + ":" + this.escapeString(className.pop()) + ", " + this.escapeString("value") + ":{" + s + "}}";
         }
         return "{" + s + "}";
      }
   }
}
