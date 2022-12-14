package com.ankamagames.berilia.types.data
{
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   
   public class Hook
   {
      
      private static var _hookNameList:Array;
       
      
      private var _trusted:Boolean;
      
      private var _name:String;
      
      private var _nativeHook:Boolean;
      
      public function Hook(param1:String, param2:Boolean, param3:Boolean = true)
      {
         super();
         if(!_hookNameList)
         {
            _hookNameList = new Array();
         }
         _hookNameList[param1] = this;
         this._name = param1;
         this._trusted = param2;
      }
      
      public static function create(param1:String, param2:Boolean, param3:Boolean = true) : Hook
      {
         var _loc4_:Hook;
         if(_loc4_ = _hookNameList[param1])
         {
            if(param2)
            {
               throw new BeriliaError("Hook name (" + param1 + ") aleardy used, please rename it.");
            }
            return _loc4_;
         }
         return new Hook(param1,param2,param3);
      }
      
      public static function getHookByName(param1:String) : Hook
      {
         return _hookNameList[param1];
      }
      
      public function get trusted() : Boolean
      {
         return this._trusted;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get nativeHook() : Boolean
      {
         return this._nativeHook;
      }
   }
}
