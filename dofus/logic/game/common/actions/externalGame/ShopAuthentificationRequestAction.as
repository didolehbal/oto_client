package com.ankamagames.dofus.logic.game.common.actions.externalGame
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ShopAuthentificationRequestAction implements Action
   {
       
      
      public function ShopAuthentificationRequestAction()
      {
         super();
      }
      
      public static function create() : ShopAuthentificationRequestAction
      {
         return new ShopAuthentificationRequestAction();
      }
   }
}
