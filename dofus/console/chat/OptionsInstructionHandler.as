package com.ankamagames.dofus.console.chat
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.data.I18n;
   
   public class OptionsInstructionHandler implements ConsoleInstructionHandler
   {
       
      
      public function OptionsInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         switch(param2)
         {
            case "tab":
               if(!param3[0] || param3[0] < 1)
               {
                  param1.output("Error : need a valid tab index.");
                  return;
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TabNameChange,param3[0],param3[1]);
               return;
               break;
            case "clear":
               KernelEventsManager.getInstance().processCallback(ChatHookList.ClearChat);
               return;
            default:
               return;
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "tab":
               return I18n.getUiText("ui.chat.console.help.tab");
            case "clear":
               return I18n.getUiText("ui.chat.console.help.clear");
            default:
               return I18n.getUiText("ui.chat.console.noHelp",[param1]);
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         return [];
      }
   }
}
