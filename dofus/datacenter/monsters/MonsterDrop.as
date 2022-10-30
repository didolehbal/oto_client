package com.ankamagames.dofus.datacenter.monsters
{
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class MonsterDrop implements IDataCenter
   {
       
      
      public var dropId:uint;
      
      public var monsterId:int;
      
      public var objectId:int;
      
      public var percentDropForGrade1:Number;
      
      public var percentDropForGrade2:Number;
      
      public var percentDropForGrade3:Number;
      
      public var percentDropForGrade4:Number;
      
      public var percentDropForGrade5:Number;
      
      public var count:int;
      
      public var hasCriteria:Boolean;
      
      private var _monster:Monster;
      
      public function MonsterDrop()
      {
         super();
      }
      
      public function get monster() : Monster
      {
         if(!this._monster)
         {
            this._monster = Monster.getMonsterById(this.monsterId);
         }
         return this._monster;
      }
   }
}
