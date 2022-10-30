package com.ankamagames.berilia.types.shortcut
{
   import com.ankamagames.berilia.managers.BindsManager;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import flash.utils.Dictionary;
   
   public class Shortcut implements IDataCenter
   {
      
      private static var _shortcuts:Array = new Array();
      
      private static var _idCount:uint = 0;
      
      private static var _datastoreType:DataStoreType = new DataStoreType("Module_Ankama_Config",true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_CHARACTER);
       
      
      private var _name:String;
      
      private var _description:String;
      
      private var _tooltipContent:String;
      
      private var _textfieldEnabled:Boolean;
      
      private var _bindable:Boolean;
      
      private var _category:ShortcutCategory;
      
      private var _unicID:uint = 0;
      
      private var _visible:Boolean;
      
      private var _disable:Boolean;
      
      private var _required:Boolean;
      
      private var _holdKeys:Boolean;
      
      public var defaultBind:Bind;
      
      public function Shortcut(param1:String, param2:Boolean = false, param3:String = null, param4:ShortcutCategory = null, param5:Boolean = true, param6:Boolean = true, param7:Boolean = false, param8:Boolean = false, param9:String = null)
      {
         super();
         if(_shortcuts[param1])
         {
            throw new BeriliaError("Shortcut name [" + param1 + "] is already use");
         }
         _shortcuts[param1] = this;
         this._name = param1;
         this._description = param3;
         this._textfieldEnabled = param2;
         this._category = param4;
         this._unicID = _idCount++;
         this._bindable = param5;
         this._visible = param6;
         this._required = param7;
         this._holdKeys = param8;
         this._tooltipContent = param9;
         this._disable = false;
         BindsManager.getInstance().newShortcut(this);
      }
      
      public static function reset() : void
      {
         BindsManager.destroy();
         _shortcuts = [];
         _idCount = 0;
      }
      
      public static function loadSavedData() : void
      {
         var _loc1_:Shortcut = null;
         var _loc2_:Dictionary = null;
         var _loc3_:Shortcut = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:* = false;
         var _loc16_:Object;
         if(_loc16_ = StoreDataManager.getInstance().getData(_datastoreType,"openShortcutsCategory"))
         {
            if(_loc16_ is Array)
            {
               _loc2_ = new Dictionary();
               _loc4_ = new Array();
               for each(_loc3_ in _shortcuts)
               {
                  if(_loc3_.visible)
                  {
                     _loc4_.push(_loc3_);
                  }
               }
               _loc4_.sortOn("unicID",Array.NUMERIC);
               _loc6_ = 0;
               _loc7_ = _loc4_.length;
               _loc8_ = _loc16_ as Array;
               _loc9_ = new Array();
               _loc6_ = 0;
               while(_loc6_ < _loc7_)
               {
                  _loc3_ = _loc4_[_loc6_];
                  if(_loc3_.category.name != _loc5_)
                  {
                     if((_loc11_ = _loc9_.indexOf(_loc3_.category.name)) == -1)
                     {
                        _loc9_.push(_loc3_.category.name);
                        _loc9_.push(_loc3_);
                        _loc5_ = _loc3_.category.name;
                     }
                     else
                     {
                        _loc12_ = 0;
                        _loc13_ = _loc11_;
                        _loc14_ = _loc9_.length;
                        while(++_loc13_ < _loc14_)
                        {
                           if(_loc9_[_loc13_] is String)
                           {
                              break;
                           }
                           _loc12_++;
                        }
                        _loc9_.splice(_loc11_ + _loc12_ + 1,0,_loc3_);
                     }
                  }
                  else
                  {
                     _loc9_.push(_loc3_);
                  }
                  _loc6_++;
               }
               _loc10_ = _loc9_.length;
               _loc6_ = 0;
               while(_loc6_ < _loc10_)
               {
                  if(_loc9_[_loc6_] is String)
                  {
                     if(_loc8_[_loc6_] != undefined)
                     {
                        _loc2_[_loc9_[_loc6_]] = _loc8_[_loc6_];
                     }
                     else
                     {
                        _loc2_[_loc9_[_loc6_]] = true;
                     }
                  }
                  _loc6_++;
               }
               _loc16_ = _loc2_;
               StoreDataManager.getInstance().setData(_datastoreType,"openShortcutsCategory",_loc16_);
            }
            for each(_loc1_ in _shortcuts)
            {
               if(_loc1_.visible)
               {
                  if(_loc16_[_loc1_.category.name] != undefined)
                  {
                     _loc15_ = !_loc16_[_loc1_.category.name];
                  }
                  else
                  {
                     _loc16_[_loc1_.category.name] = true;
                     _loc15_ = false;
                  }
                  _loc1_.disable = _loc15_;
               }
            }
         }
      }
      
      public static function getShortcutByName(param1:String) : Shortcut
      {
         return _shortcuts[param1];
      }
      
      public static function getShortcuts() : Array
      {
         return _shortcuts;
      }
      
      public function get unicID() : uint
      {
         return this._unicID;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function get tooltipContent() : String
      {
         return this._tooltipContent;
      }
      
      public function get textfieldEnabled() : Boolean
      {
         return this._textfieldEnabled;
      }
      
      public function get bindable() : Boolean
      {
         return this._bindable;
      }
      
      public function get category() : ShortcutCategory
      {
         return this._category;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._visible = param1;
      }
      
      public function get required() : Boolean
      {
         return this._required;
      }
      
      public function get holdKeys() : Boolean
      {
         return this._holdKeys;
      }
      
      public function get disable() : Boolean
      {
         return this._disable;
      }
      
      public function set disable(param1:Boolean) : void
      {
         this._disable = param1;
      }
   }
}
