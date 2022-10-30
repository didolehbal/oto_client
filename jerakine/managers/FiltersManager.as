package com.ankamagames.jerakine.managers
{
   import flash.display.DisplayObject;
   import flash.filters.BitmapFilter;
   import flash.utils.Dictionary;
   
   public class FiltersManager
   {
      
      private static var _self:FiltersManager;
       
      
      private var dFilters:Dictionary;
      
      public function FiltersManager(param1:PrivateClass)
      {
         super();
         this.dFilters = new Dictionary(true);
      }
      
      public static function getInstance() : FiltersManager
      {
         if(_self == null)
         {
            _self = new FiltersManager(new PrivateClass());
         }
         return _self;
      }
      
      public function addEffect(param1:DisplayObject, param2:BitmapFilter) : void
      {
         var _loc3_:Array = this.dFilters[param1] as Array;
         if(_loc3_ == null)
         {
            _loc3_ = this.dFilters[param1] = param1.filters;
         }
         _loc3_.push(param2);
         param1.filters = _loc3_;
      }
      
      public function removeEffect(param1:DisplayObject, param2:BitmapFilter) : void
      {
         var _loc3_:Array = this.dFilters[param1] as Array;
         if(_loc3_ == null)
         {
            _loc3_ = this.dFilters[param1] = param1.filters;
         }
         var _loc4_:int;
         if((_loc4_ = this.indexOf(_loc3_,param2)) != -1)
         {
            _loc3_.splice(_loc4_,1);
            param1.filters = _loc3_;
         }
      }
      
      public function indexOf(param1:Array, param2:BitmapFilter) : int
      {
         var _loc3_:BitmapFilter = null;
         var _loc4_:int = param1.length;
         while(_loc4_--)
         {
            _loc3_ = param1[_loc4_];
            if(_loc3_ == param2)
            {
               return _loc4_;
            }
         }
         return -1;
      }
   }
}

class PrivateClass
{
    
   
   function PrivateClass()
   {
      super();
   }
}
