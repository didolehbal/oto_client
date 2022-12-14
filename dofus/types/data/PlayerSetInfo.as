package com.ankamagames.dofus.types.data
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.items.ItemSet;
   import com.ankamagames.dofus.misc.ObjectEffectAdapter;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   
   public class PlayerSetInfo
   {
       
      
      public var setId:uint = 0;
      
      public var setName:String;
      
      public var allItems:Vector.<uint>;
      
      public var setObjects:Vector.<uint>;
      
      public var setEffects:Vector.<EffectInstance>;
      
      public function PlayerSetInfo(param1:uint, param2:Vector.<uint>, param3:Vector.<ObjectEffect>)
      {
         var _loc6_:int = 0;
         this.setObjects = new Vector.<uint>();
         super();
         var _loc4_:ItemSet = ItemSet.getItemSetById(param1);
         this.setName = _loc4_.name;
         this.allItems = _loc4_.items;
         this.setId = param1;
         this.setObjects = param2;
         var _loc5_:int = param3.length;
         this.setEffects = new Vector.<EffectInstance>(_loc5_);
         while(_loc6_ < _loc5_)
         {
            this.setEffects[_loc6_] = ObjectEffectAdapter.fromNetwork(param3[_loc6_]);
            _loc6_++;
         }
      }
   }
}
