package com.ankamagames.jerakine.BalanceManager
{
   import com.ankamagames.jerakine.BalanceManager.events.BalanceEvent;
   import com.ankamagames.jerakine.BalanceManager.type.BalancedObject;
   
   public class BalanceManager
   {
       
      
      private var _balancedObjects:Vector.<BalancedObject>;
      
      private var _nbCall:uint = 0;
      
      public function BalanceManager(param1:Array = null)
      {
         var _loc2_:Object = null;
         super();
         this.init();
         if(param1 != null)
         {
            for each(_loc2_ in param1)
            {
               this.addItem(_loc2_);
            }
         }
      }
      
      public function get nbCall() : uint
      {
         return this._nbCall;
      }
      
      public function getItemNbCall(param1:Object) : int
      {
         var _loc2_:BalancedObject = null;
         for each(_loc2_ in this._balancedObjects)
         {
            if(param1 == _loc2_.item)
            {
               return _loc2_.nbCall;
            }
         }
         return -1;
      }
      
      public function setItemBalance(param1:Object, param2:uint) : void
      {
         var _loc3_:BalancedObject = null;
         for each(_loc3_ in this._balancedObjects)
         {
            if(param1 == _loc3_.item)
            {
               _loc3_.nbCall = param2;
               return;
            }
         }
      }
      
      public function addItem(param1:Object, param2:Boolean = false) : void
      {
         this._balancedObjects.push(new BalancedObject(param1));
         if(param2)
         {
            this._nbCall = 0;
            this.resetBalance();
         }
         this.balanceItems();
      }
      
      public function addItemWithBalance(param1:Object, param2:uint) : void
      {
         var _loc3_:BalancedObject = new BalancedObject(param1);
         _loc3_.nbCall = param2;
         this._balancedObjects.push(_loc3_);
         this._nbCall = this._nbCall + param2;
         this.balanceItems();
      }
      
      public function callItem() : Object
      {
         var _loc1_:BalancedObject = null;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc2_:uint = uint(Math.random() * 10000);
         if(this._balancedObjects.length == 0)
         {
            return _loc4_;
         }
         _loc1_ = this._balancedObjects[0] as BalancedObject;
         if(_loc2_ < _loc1_.chanceToBeCall * 100)
         {
            _loc1_.increment();
            _loc4_ = _loc1_.item;
         }
         _loc3_++;
         var _loc5_:Number = _loc1_.chanceToBeCall * 100;
         while(_loc3_ < this._balancedObjects.length)
         {
            _loc1_ = this._balancedObjects[_loc3_] as BalancedObject;
            if(_loc4_ == null)
            {
               if(this._balancedObjects.length == _loc3_ + 1)
               {
                  _loc1_.increment();
                  _loc4_ = _loc1_.item;
               }
               else
               {
                  if(_loc2_ > _loc5_ && _loc2_ < _loc5_ + _loc1_.chanceToBeCall * 100)
                  {
                     _loc1_.increment();
                     _loc4_ = _loc1_.item;
                  }
                  _loc5_ = _loc5_ + _loc1_.chanceToBeCall * 100;
               }
            }
            _loc3_++;
         }
         ++this._nbCall;
         this.balanceItems();
         return _loc4_;
      }
      
      public function removeItem(param1:Object) : void
      {
         var _loc2_:BalancedObject = null;
         for each(_loc2_ in this._balancedObjects)
         {
            if(_loc2_.item == param1)
            {
               this._balancedObjects.splice(this._balancedObjects.indexOf(_loc2_),1);
            }
         }
         this.balanceItems();
      }
      
      public function reset() : void
      {
         var _loc1_:BalancedObject = null;
         for each(_loc1_ in this._balancedObjects)
         {
            this.setItemBalance(_loc1_.item,0);
         }
         this.balanceItems();
      }
      
      private function balanceItems() : void
      {
         var _loc1_:BalancedObject = null;
         var _loc2_:BalancedObject = null;
         var _loc3_:Number = NaN;
         var _loc4_:BalancedObject = null;
         var _loc5_:BalancedObject = null;
         if(this._nbCall == 0)
         {
            for each(_loc1_ in this._balancedObjects)
            {
               _loc1_.chanceToBeCall = 1 / this._balancedObjects.length * 100;
            }
         }
         else
         {
            for each(_loc2_ in this._balancedObjects)
            {
               _loc2_.chanceToBeNonCall = (_loc2_.nbCall + 1) / (this._nbCall + this._balancedObjects.length) * 100;
            }
            _loc3_ = 0;
            for each(_loc4_ in this._balancedObjects)
            {
               _loc3_ = _loc3_ + 1 / _loc4_.chanceToBeNonCall;
            }
            for each(_loc5_ in this._balancedObjects)
            {
               _loc5_.chanceToBeCall = 1 / _loc5_.chanceToBeNonCall / _loc3_ * 100;
            }
         }
      }
      
      private function init() : void
      {
         this._balancedObjects = new Vector.<BalancedObject>();
      }
      
      private function resetBalance() : void
      {
         var _loc1_:BalancedObject = null;
         for each(_loc1_ in this._balancedObjects)
         {
            _loc1_.nbCall = 0;
         }
      }
      
      private function onBalanceUpdate(param1:BalanceEvent) : void
      {
         this._nbCall = this._nbCall + (param1.newBalance - param1.previousBalance);
      }
   }
}
