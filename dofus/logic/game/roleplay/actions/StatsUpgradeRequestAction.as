package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class StatsUpgradeRequestAction implements Action
   {
       
      
      public var useAdditionnal:Boolean;
      
      public var statId:uint;
      
      public var boostPoint:uint;
      
      public function StatsUpgradeRequestAction()
      {
         super();
      }
      
      public static function create(param1:Boolean, param2:uint, param3:uint) : StatsUpgradeRequestAction
      {
         var _loc4_:StatsUpgradeRequestAction;
         (_loc4_ = new StatsUpgradeRequestAction()).useAdditionnal = param1;
         _loc4_.statId = param2;
         _loc4_.boostPoint = param3;
         return _loc4_;
      }
   }
}
