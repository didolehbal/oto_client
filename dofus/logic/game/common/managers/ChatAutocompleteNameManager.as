package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import flash.utils.Dictionary;
   
   public class ChatAutocompleteNameManager
   {
      
      private static var _instance:ChatAutocompleteNameManager;
       
      
      public var playerApi:PlayedCharacterApi;
      
      private var _dict:Dictionary;
      
      private var _cache:Vector.<String>;
      
      private var _subStringCache:String = "";
      
      public function ChatAutocompleteNameManager()
      {
         this._dict = new Dictionary();
         super();
      }
      
      public static function getInstance() : ChatAutocompleteNameManager
      {
         if(!_instance)
         {
            _instance = new ChatAutocompleteNameManager();
         }
         return _instance;
      }
      
      public function addEntry(param1:String, param2:int) : void
      {
         var _loc3_:Object = null;
         this.emptyCache();
         var _loc4_:Vector.<Object> = this.getListByName(param1);
         var _loc5_:int;
         if((_loc5_ = this.indexOf(_loc4_,param1)) != -1)
         {
            _loc3_ = _loc4_[_loc5_];
            if(_loc3_.priority > param2)
            {
               return;
            }
            _loc4_.splice(_loc5_,1);
         }
         _loc3_ = new Object();
         _loc3_.name = param1;
         _loc3_.priority = param2;
         this.insertEntry(_loc3_);
      }
      
      public function autocomplete(param1:String, param2:uint) : String
      {
         var _loc3_:Vector.<String> = null;
         if(this._subStringCache == param1)
         {
            _loc3_ = this._cache;
         }
         else
         {
            _loc3_ = this.generateNameList(param1);
         }
         if(_loc3_.length > param2)
         {
            return _loc3_[param2];
         }
         return null;
      }
      
      private function emptyCache() : void
      {
         this._subStringCache = "";
      }
      
      private function generateNameList(param1:String) : Vector.<String>
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = param1.toLowerCase();
         var _loc6_:Vector.<Object> = this.getListByName(param1);
         var _loc7_:Vector.<String> = new Vector.<String>();
         this._subStringCache = param1;
         this._cache = _loc7_;
         for each(_loc2_ in _loc6_)
         {
            _loc3_ = _loc2_.name;
            _loc4_ = _loc3_.toLowerCase();
            if(_loc2_.name.length >= _loc5_.length && _loc4_.substr(0,_loc5_.length) == _loc5_ && _loc3_ != PlayedCharacterApi.getPlayedCharacterInfo().name)
            {
               _loc7_.push(_loc3_);
            }
         }
         return _loc7_;
      }
      
      private function getListByName(param1:String) : Vector.<Object>
      {
         var _loc2_:String = param1.charAt(0).toLowerCase();
         if(!this._dict.hasOwnProperty(_loc2_))
         {
            this._dict[_loc2_] = new Vector.<Object>();
         }
         return this._dict[_loc2_];
      }
      
      private function indexOf(param1:Vector.<Object>, param2:String) : int
      {
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_].name == param2)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      private function insertEntry(param1:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:Vector.<Object> = this.getListByName(param1.name);
         while(_loc3_ < _loc2_.length && _loc2_[_loc3_].priority > param1.priority)
         {
            _loc3_++;
         }
         _loc2_.splice(_loc3_,0,param1);
      }
   }
}
