package com.ankamagames.jerakine.types
{
   import com.ankamagames.jerakine.utils.errors.JerakineError;
   
   public class DataStoreType
   {
      
      private static var _lastIdInitId:int;
      
      public static var _ACCOUNT_ID:String;
      
      private static var _CHARACTER_ID:String;
       
      
      private var _sCategory:String;
      
      private var _bPersistant:Boolean;
      
      private var _nLocation:uint;
      
      private var _nBind:uint;
      
      private var _id:String;
      
      private var _idInitId:String;
      
      public function DataStoreType(param1:String, param2:Boolean, param3:Number = NaN, param4:Number = NaN)
      {
         super();
         this._sCategory = param1;
         this._bPersistant = param2;
         if(param2)
         {
            if(isNaN(param3))
            {
               throw new JerakineError("When DataStoreType is a persistant data, arg \'nLocation\' must be defined.");
            }
            this._nLocation = param3;
            if(isNaN(param4))
            {
               throw new JerakineError("When DataStoreType is a persistant data, arg \'nBind\' must be defined.");
            }
            this._nBind = param4;
         }
      }
      
      public static function get CHARACTER_ID() : String
      {
         return _CHARACTER_ID;
      }
      
      public static function set CHARACTER_ID(param1:String) : void
      {
         _CHARACTER_ID = param1;
         ++_lastIdInitId;
      }
      
      public static function get ACCOUNT_ID() : String
      {
         return _ACCOUNT_ID;
      }
      
      public static function set ACCOUNT_ID(param1:String) : void
      {
         _ACCOUNT_ID = param1;
         ++_lastIdInitId;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get category() : String
      {
         return this._sCategory;
      }
      
      public function get persistant() : Boolean
      {
         return this._bPersistant;
      }
      
      public function get location() : uint
      {
         return this._nLocation;
      }
      
      public function get bind() : uint
      {
         return this._nBind;
      }
   }
}
