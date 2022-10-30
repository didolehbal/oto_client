package com.ankamagames.jerakine.data
{
   import flash.utils.IDataInput;
   import flash.utils.getDefinitionByName;
   
   public class GameDataClassDefinition
   {
       
      
      private var _class:Class;
      
      private var _fields:Vector.<GameDataField>;
      
      public function GameDataClassDefinition(param1:String, param2:String)
      {
         super();
         this._class = getDefinitionByName(param1 + "." + param2) as Class;
         this._fields = new Vector.<GameDataField>();
      }
      
      public function get fields() : Vector.<GameDataField>
      {
         return this._fields;
      }
      
      public function read(param1:String, param2:IDataInput) : *
      {
         var _loc3_:GameDataField = null;
         var _loc4_:* = new this._class();
         for each(_loc3_ in this._fields)
         {
            _loc4_[_loc3_.name] = _loc3_.readData(param1,param2);
         }
         if(_loc4_ is IPostInit)
         {
            IPostInit(_loc4_).postInit();
         }
         return _loc4_;
      }
      
      public function addField(param1:String, param2:IDataInput) : void
      {
         var _loc3_:GameDataField = new GameDataField(param1);
         _loc3_.readType(param2);
         this._fields.push(_loc3_);
      }
   }
}
