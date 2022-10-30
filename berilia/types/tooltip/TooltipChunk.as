package com.ankamagames.berilia.types.tooltip
{
   import flash.events.EventDispatcher;
   
   public class TooltipChunk extends EventDispatcher
   {
       
      
      private var _content:String;
      
      public function TooltipChunk(param1:String)
      {
         super();
         this._content = param1;
      }
      
      public function processContent(param1:Object) : String
      {
         var _loc2_:* = null;
         var _loc3_:String = this._content;
         for(_loc2_ in param1)
         {
            _loc3_ = _loc3_.split("#" + _loc2_).join(param1[_loc2_]);
         }
         return _loc3_;
      }
      
      public function get content() : String
      {
         return this._content;
      }
   }
}
