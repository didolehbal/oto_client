package com.ankamagames.dofus.internalDatacenter.fight
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.types.game.context.fight.FightLoot;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class FightLootWrapper implements IDataCenter
   {
       
      
      public var objects:Array;
      
      public var kamas:uint;
      
      public function FightLootWrapper(param1:FightLoot)
      {
         var _loc2_:uint = 0;
         super();
         this.objects = new Array();
         while(_loc2_ < param1.objects.length)
         {
            this.objects.push(ItemWrapper.create(63,0,param1.objects[_loc2_],param1.objects[_loc2_ + 1],new Vector.<ObjectEffect>(),false));
            _loc2_ = _loc2_ + 2;
         }
         this.kamas = param1.kamas;
      }
   }
}
