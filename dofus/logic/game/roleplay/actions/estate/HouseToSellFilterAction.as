package com.ankamagames.dofus.logic.game.roleplay.actions.estate
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseToSellFilterAction implements Action
   {
       
      
      public var areaId:int;
      
      public var atLeastNbRoom:uint;
      
      public var atLeastNbChest:uint;
      
      public var skillRequested:uint;
      
      public var maxPrice:uint;
      
      public function HouseToSellFilterAction()
      {
         super();
      }
      
      public static function create(param1:int, param2:uint, param3:uint, param4:uint, param5:uint) : HouseToSellFilterAction
      {
         var _loc6_:HouseToSellFilterAction;
         (_loc6_ = new HouseToSellFilterAction()).areaId = param1;
         _loc6_.atLeastNbRoom = param2;
         _loc6_.atLeastNbChest = param3;
         _loc6_.skillRequested = param4;
         _loc6_.maxPrice = param5;
         return _loc6_;
      }
   }
}
