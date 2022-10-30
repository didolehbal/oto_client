package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.dofus.console.moduleLUA.ConsoleLUA;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsolesManager;
   import com.ankamagames.jerakine.lua.LuaPlayer;
   import com.ankamagames.jerakine.lua.LuaPlayerEvent;
   import com.ankamagames.jerakine.script.ScriptsManager;
   
   public class LuaInstructionHandler implements ConsoleInstructionHandler
   {
       
      
      public function LuaInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:LuaPlayer = null;
         switch(param2)
         {
            case "lua":
               if(param3 && param3[0])
               {
                  (_loc4_ = ScriptsManager.getInstance().getPlayer(ScriptsManager.LUA_PLAYER) as LuaPlayer).addEventListener(LuaPlayerEvent.PLAY_SUCCESS,this.onScriptSuccess);
                  _loc4_.addEventListener(LuaPlayerEvent.PLAY_ERROR,this.onScriptError);
                  _loc4_.playFile(param3[0]);
               }
               return;
            case "luarecorder":
               ConsoleLUA.getInstance().toggleDisplay();
               return;
            default:
               return;
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "lua":
               return "Loads and executes a lua script file.";
            case "luarecorder":
               return "Open a separate window to record in game actions and generate a LUA script file.";
            default:
               return "Unknown command \'" + param1 + "\'.";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         return null;
      }
      
      private function onScriptSuccess(param1:LuaPlayerEvent) : void
      {
         param1.currentTarget.removeEventListener(LuaPlayerEvent.PLAY_SUCCESS,this.onScriptSuccess);
         ConsolesManager.getConsole("debug").output("Script successfully executed.");
      }
      
      private function onScriptError(param1:LuaPlayerEvent) : void
      {
         param1.currentTarget.removeEventListener(LuaPlayerEvent.PLAY_ERROR,this.onScriptError);
         ConsolesManager.getConsole("debug").output("Script error.\n" + param1.stackTrace);
      }
   }
}
