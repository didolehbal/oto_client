package com.ankamagames.dofus.modules.utils.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ModuleInstallCancelAction implements Action
   {
       
      
      public function ModuleInstallCancelAction()
      {
         super();
      }
      
      public static function create() : ModuleInstallCancelAction
      {
         return new ModuleInstallCancelAction();
      }
   }
}
