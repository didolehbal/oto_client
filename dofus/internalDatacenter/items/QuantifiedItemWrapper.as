package com.ankamagames.dofus.internalDatacenter.items
{
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.utils.display.spellZone.ICellZoneProvider;
   
   public class QuantifiedItemWrapper extends ItemWrapper implements ISlotData, ICellZoneProvider, IDataCenter
   {
       
      
      public function QuantifiedItemWrapper()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint, param4:uint, param5:Vector.<ObjectEffect>, param6:Boolean = true) : QuantifiedItemWrapper
      {
         var _loc7_:ItemWrapper;
         return (_loc7_ = ItemWrapper.create(param1,param2,param3,param4,param5,param6)).clone(QuantifiedItemWrapper) as QuantifiedItemWrapper;
      }
      
      override public function get info1() : String
      {
         return quantity > 0?quantity.toString():null;
      }
      
      override public function get active() : Boolean
      {
         return quantity > 0;
      }
      
      override public function toString() : String
      {
         return "[QuantifiedItemWrapper#" + objectUID + "_" + name + "]";
      }
   }
}
