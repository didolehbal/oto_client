package com.ankamagames.dofus.modules.utils.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class InstalledModuleListRequestAction implements Action
   {
       
      
      public function InstalledModuleListRequestAction()
      {
         super();
      }
      
      public static function create() : InstalledModuleListRequestAction
      {
         return new InstalledModuleListRequestAction();
      }
   }
}
