package com.ankamagames.dofus.modules.utils
{
   import com.ankamagames.jerakine.interfaces.IModuleUtil;
   
   public class ItemTooltipSettings implements IModuleUtil
   {
       
      
      private var _header:Boolean;
      
      private var _effects:Boolean;
      
      private var _conditions:Boolean;
      
      private var _description:Boolean;
      
      private var _averagePrice:Boolean;
      
      public function ItemTooltipSettings()
      {
         super();
         this._header = true;
         this._effects = true;
         this._conditions = true;
         this._description = true;
         this._averagePrice = true;
      }
      
      [Untrusted]
      public function get header() : Boolean
      {
         return this._header;
      }
      
      public function set header(param1:Boolean) : void
      {
         this._header = param1;
      }
      
      [Untrusted]
      public function get effects() : Boolean
      {
         return this._effects;
      }
      
      public function set effects(param1:Boolean) : void
      {
         this._effects = param1;
      }
      
      [Untrusted]
      public function get conditions() : Boolean
      {
         return this._conditions;
      }
      
      public function set conditions(param1:Boolean) : void
      {
         this._conditions = param1;
      }
      
      [Untrusted]
      public function get description() : Boolean
      {
         return this._description;
      }
      
      public function set description(param1:Boolean) : void
      {
         this._description = param1;
      }
      
      [Untrusted]
      public function get averagePrice() : Boolean
      {
         return this._averagePrice;
      }
      
      public function set averagePrice(param1:Boolean) : void
      {
         this._averagePrice = param1;
      }
   }
}
