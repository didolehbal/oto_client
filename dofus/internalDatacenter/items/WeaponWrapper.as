package com.ankamagames.dofus.internalDatacenter.items
{
   import com.ankamagames.dofus.datacenter.items.Weapon;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class WeaponWrapper extends ItemWrapper implements IDataCenter
   {
      
      private static var _weaponUtil:Weapon = new Weapon();
       
      
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
      
      public function WeaponWrapper()
      {
         super();
      }
      
      override public function get isWeapon() : Boolean
      {
         return true;
      }
      
      override public function clone(param1:Class = null) : ItemWrapper
      {
         var _loc2_:ItemWrapper = super.clone(WeaponWrapper);
         _weaponUtil.copy(this,_loc2_);
         return _loc2_;
      }
   }
}
