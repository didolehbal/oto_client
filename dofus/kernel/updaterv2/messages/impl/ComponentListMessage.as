package com.ankamagames.dofus.kernel.updaterv2.messages.impl
{
   import com.ankamagames.dofus.kernel.updaterv2.messages.IUpdaterInputMessage;
   import flash.utils.Dictionary;
   
   public class ComponentListMessage implements IUpdaterInputMessage
   {
       
      
      private var _components:Dictionary;
      
      public function ComponentListMessage()
      {
         super();
      }
      
      public function get components() : Dictionary
      {
         return this._components;
      }
      
      public function deserialize(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Array = param1["components"];
         this._components = new Dictionary();
         if(_loc4_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               _loc3_ = _loc4_[_loc2_];
               this._components[_loc3_.name] = _loc3_;
               _loc2_++;
            }
         }
      }
   }
}
