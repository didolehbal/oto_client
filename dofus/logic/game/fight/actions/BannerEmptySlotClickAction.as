package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class BannerEmptySlotClickAction implements Action
   {
       
      
      public function BannerEmptySlotClickAction()
      {
         super();
      }
      
      public static function create() : BannerEmptySlotClickAction
      {
         return new BannerEmptySlotClickAction();
      }
   }
}
