package com.ankamagames.jerakine.data
{
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.utils.Dictionary;
   
   public class CensoredContentManager
   {
      
      private static var _self:CensoredContentManager;
       
      
      private var _data:Dictionary;
      
      private var _emtptyData:Dictionary;
      
      public function CensoredContentManager()
      {
         this._data = new Dictionary();
         this._emtptyData = new Dictionary();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : CensoredContentManager
      {
         if(!_self)
         {
            _self = new CensoredContentManager();
         }
         return _self;
      }
      
      public function init(param1:Array, param2:String) : void
      {
         var _loc3_:ICensoredDataItem = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.lang == param2)
            {
               if(!this._data[_loc3_.type])
               {
                  this._data[_loc3_.type] = new Dictionary();
               }
               this._data[_loc3_.type][_loc3_.oldValue] = _loc3_.newValue;
            }
         }
      }
      
      public function getCensoredIndex(param1:int) : Dictionary
      {
         return !!this._data[param1]?this._data[param1]:this._emtptyData;
      }
   }
}
