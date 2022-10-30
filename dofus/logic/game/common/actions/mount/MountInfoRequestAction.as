package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceMount;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class MountInfoRequestAction implements Action
   {
      
      public static const EFFECT_ID_MOUNT:int = 995;
      
      public static const EFFECT_ID_VALIDITY:int = 998;
       
      
      public var item:ItemWrapper;
      
      public var mountId:Number;
      
      public var time:Number;
      
      public function MountInfoRequestAction()
      {
         super();
      }
      
      public static function create(param1:ItemWrapper) : MountInfoRequestAction
      {
         var _loc2_:EffectInstance = null;
         var _loc3_:MountInfoRequestAction = new MountInfoRequestAction();
         _loc3_.item = param1;
         for each(_loc2_ in param1.effects)
         {
            switch(_loc2_.effectId)
            {
               case EFFECT_ID_MOUNT:
                  _loc3_.time = (_loc2_ as EffectInstanceMount).date;
                  _loc3_.mountId = (_loc2_ as EffectInstanceMount).mountId;
                  continue;
               default:
                  continue;
            }
         }
         return _loc3_;
      }
   }
}
