package com.ankamagames.dofus.logic.game.common.actions.tinsel
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TitleSelectRequestAction implements Action
   {
       
      
      public var titleId:int;
      
      public function TitleSelectRequestAction()
      {
         super();
      }
      
      public static function create(param1:int) : TitleSelectRequestAction
      {
         var _loc2_:TitleSelectRequestAction = new TitleSelectRequestAction();
         _loc2_.titleId = param1;
         return _loc2_;
      }
   }
}
