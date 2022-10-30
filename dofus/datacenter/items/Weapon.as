package com.ankamagames.dofus.datacenter.items
{
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class Weapon extends Item implements IDataCenter
   {
       
      
      public var apCost:int;
      
      public var minRange:int;
      
      public var range:int;
      
      public var maxCastPerTurn:uint;
      
      public var castInLine:Boolean;
      
      public var castInDiagonal:Boolean;
      
      public var castTestLos:Boolean;
      
      public var criticalHitProbability:int;
      
      public var criticalHitBonus:int;
      
      public var criticalFailureProbability:int;
      
      public function Weapon()
      {
         super();
      }
      
      public static function getWeaponById(param1:int) : Weapon
      {
         var _loc2_:Item = Item.getItemById(param1);
         if(_loc2_ && _loc2_.isWeapon)
         {
            return Weapon(_loc2_);
         }
         return null;
      }
      
      public static function getWeapons() : Array
      {
         var _loc1_:Item = null;
         var _loc2_:Array = Item.getItems();
         var _loc3_:Array = new Array();
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_.isWeapon)
            {
               _loc3_.push(_loc1_);
            }
         }
         return _loc3_;
      }
      
      override public function get isWeapon() : Boolean
      {
         return true;
      }
      
      override public function copy(param1:Item, param2:Item) : void
      {
         super.copy(param1,param2);
         Object(param2).apCost = Object(param1).apCost;
         Object(param2).minRange = Object(param1).minRange;
         Object(param2).range = Object(param1).range;
         Object(param2).maxCastPerTurn = Object(param1).maxCastPerTurn;
         Object(param2).castInLine = Object(param1).castInLine;
         Object(param2).castInDiagonal = Object(param1).castInDiagonal;
         Object(param2).castTestLos = Object(param1).castTestLos;
         Object(param2).criticalHitProbability = Object(param1).criticalHitProbability;
         Object(param2).criticalHitBonus = Object(param1).criticalHitBonus;
         Object(param2).criticalFailureProbability = Object(param1).criticalFailureProbability;
      }
   }
}
