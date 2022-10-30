package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ObjectSetPositionAction implements Action
   {
       
      
      public var objectUID:uint;
      
      public var position:uint;
      
      public var quantity:uint;
      
      public function ObjectSetPositionAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint = 1) : ObjectSetPositionAction
      {
         var _loc4_:ObjectSetPositionAction;
         (_loc4_ = new ObjectSetPositionAction()).objectUID = param1;
         _loc4_.quantity = param3;
         _loc4_.position = param2;
         return _loc4_;
      }
   }
}
