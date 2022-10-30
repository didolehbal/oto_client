package com.ankamagames.dofus.logic.game.common.actions.craft
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangePlayerMultiCraftRequestAction implements Action
   {
       
      
      public var exchangeType:int;
      
      public var target:uint;
      
      public var skillId:uint;
      
      public function ExchangePlayerMultiCraftRequestAction()
      {
         super();
      }
      
      public static function create(param1:int, param2:uint, param3:uint) : ExchangePlayerMultiCraftRequestAction
      {
         var _loc4_:ExchangePlayerMultiCraftRequestAction;
         (_loc4_ = new ExchangePlayerMultiCraftRequestAction()).exchangeType = param1;
         _loc4_.target = param2;
         _loc4_.skillId = param3;
         return _loc4_;
      }
   }
}
