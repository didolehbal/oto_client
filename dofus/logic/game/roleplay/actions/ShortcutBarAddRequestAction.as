package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ShortcutBarAddRequestAction implements Action
   {
       
      
      public var barType:uint;
      
      public var id:uint;
      
      public var slot:uint;
      
      public function ShortcutBarAddRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint) : ShortcutBarAddRequestAction
      {
         var _loc4_:ShortcutBarAddRequestAction;
         (_loc4_ = new ShortcutBarAddRequestAction()).barType = param1;
         _loc4_.id = param2;
         _loc4_.slot = param3;
         return _loc4_;
      }
   }
}
