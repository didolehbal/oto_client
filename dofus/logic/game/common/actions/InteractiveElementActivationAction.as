package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class InteractiveElementActivationAction implements Action
   {
       
      
      public var interactiveElement:InteractiveElement;
      
      public var position:MapPoint;
      
      public var skillInstanceId:uint;
      
      public function InteractiveElementActivationAction()
      {
         super();
      }
      
      public static function create(param1:InteractiveElement, param2:MapPoint, param3:uint) : InteractiveElementActivationAction
      {
         var _loc4_:InteractiveElementActivationAction;
         (_loc4_ = new InteractiveElementActivationAction()).interactiveElement = param1;
         _loc4_.position = param2;
         _loc4_.skillInstanceId = param3;
         return _loc4_;
      }
   }
}
