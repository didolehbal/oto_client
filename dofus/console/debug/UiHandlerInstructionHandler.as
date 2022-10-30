package com.ankamagames.dofus.console.debug
{
   import avmplus.getQualifiedClassName;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.BeriliaConstants;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.managers.UiRenderManager;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.utils.ModuleScriptAnalyzer;
   import com.ankamagames.dofus.console.moduleLogger.Console;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.utils.Inspector;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.document.ComicReadingBeginMessage;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.Dictionary;
   
   public class UiHandlerInstructionHandler implements ConsoleInstructionHandler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UiHandlerInstructionHandler));
       
      
      private var _uiInspector:Inspector;
      
      public function UiHandlerInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:ComicReadingBeginMessage = null;
         var _loc6_:RoleplayContextFrame = null;
         var _loc7_:Dictionary = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:UiModule = null;
         var _loc11_:Array = null;
         var _loc12_:UiModule = null;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:UiRootContainer = null;
         var _loc16_:GraphicContainer = null;
         var _loc17_:uint = 0;
         var _loc18_:Array = null;
         var _loc19_:* = null;
         var _loc20_:* = null;
         var _loc21_:UiData = null;
         var _loc22_:ModuleScriptAnalyzer = null;
         var _loc23_:Boolean = false;
         switch(param2)
         {
            case "loadui":
               return;
            case "debugwebreader":
               _loc4_ = 0;
               if(param3 && param3[0])
               {
                  _loc4_ = parseInt(param3[0]);
               }
               (_loc5_ = new ComicReadingBeginMessage()).initComicReadingBeginMessage(_loc4_);
               if(_loc6_ = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame)
               {
                  _loc6_.process(_loc5_);
               }
               else
               {
                  param1.output("Failed to open the webReader, you need to be in Roleplay context for that!");
               }
               return;
            case "unloadui":
               if(param3.length == 0)
               {
                  _loc17_ = 0;
                  _loc18_ = [];
                  for(_loc19_ in Berilia.getInstance().uiList)
                  {
                     if(Berilia.getInstance().uiList[_loc19_].name != "Console")
                     {
                        _loc18_.push(Berilia.getInstance().uiList[_loc19_].name);
                     }
                  }
                  for each(_loc19_ in _loc18_)
                  {
                     Berilia.getInstance().unloadUi(_loc19_);
                  }
                  param1.output(_loc18_.length + " UI were unload");
                  return;
               }
               if(Berilia.getInstance().unloadUi(param3[0]))
               {
                  param1.output("RIP " + param3[0]);
               }
               else
               {
                  param1.output(param3[0] + " does not exist or an error occured while unloading UI");
               }
               return;
               break;
            case "clearuicache":
               if(param3 && param3[0])
               {
                  UiRenderManager.getInstance().clearCacheFromUiName(param3[0]);
               }
               else
               {
                  UiRenderManager.getInstance().clearCache();
               }
               return;
            case "setuiscale":
               Berilia.getInstance().scale = Number(param3[0]);
               return;
            case "useuicache":
               StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_DEFINITION,"useCache",param3[0] == "true");
               BeriliaConstants.USE_UI_CACHE = param3[0] == "true";
               return;
            case "uilist":
               _loc7_ = Berilia.getInstance().uiList;
               _loc8_ = [];
               for(_loc20_ in _loc7_)
               {
                  _loc21_ = UiRootContainer(_loc7_[_loc20_]).uiData;
                  _loc8_.push([_loc20_,_loc21_.name,_loc21_.uiClassName,_loc21_.module.id,_loc21_.module.trusted]);
               }
               param1.output(StringUtils.formatArray(_loc8_,["Instance ID","Ui name","Class","Module","Trusted"]));
               return;
            case "reloadui":
               if(param3[0])
               {
                  UiModuleManager.getInstance().loadModule(param3[0]);
               }
               else
               {
                  param1.output("Failed to reload ui, no id found in command arguments");
               }
               return;
            case "fps":
               _loc23_ = Dofus.getInstance().toggleFPS();
               param1.output("Fps manager is " + (!!_loc23_?"en":"dis") + "abled");
               return;
            case "modulelist":
               _loc9_ = [];
               _loc11_ = UiModuleManager.getInstance().getModules();
               for each(_loc10_ in _loc11_)
               {
                  _loc9_.push([_loc10_.id,_loc10_.author,_loc10_.trusted,true]);
               }
               if((_loc11_ = UiModuleManager.getInstance().disabledModules).length)
               {
                  for each(_loc10_ in _loc11_)
                  {
                     _loc9_.push([_loc10_.id,_loc10_.author,_loc10_.trusted,false]);
                  }
               }
               param1.output(StringUtils.formatArray(_loc9_,["ID","Author","Trusted","Active"]));
               return;
            case "getmoduleinfo":
               if(_loc12_ = UiModuleManager.getInstance().getModule(param3[0]))
               {
                  _loc22_ = new ModuleScriptAnalyzer(_loc12_,null);
               }
               else
               {
                  param1.output("Module " + param3[0] + " does not exists");
               }
               return;
            case "chatoutput":
               _loc13_ = !param3.length || String(param3[0]).toLowerCase() == "true" || String(param3[0]).toLowerCase() == "on";
               Console.getInstance().chatMode = _loc13_;
               Console.getInstance().display();
               Console.getInstance().disableLogEvent();
               KernelEventsManager.getInstance().processCallback(ChatHookList.ToggleChatLog,_loc13_);
               _loc14_ = OptionManager.getOptionManager("chat")["chatoutput"];
               OptionManager.getOptionManager("chat")["chatoutput"] = _loc13_;
               if(_loc13_)
               {
                  param1.output("Chatoutput is on.");
               }
               else
               {
                  param1.output("Chatoutput is off.");
               }
               return;
            case "uiinspector":
            case "inspector":
               if(!this._uiInspector)
               {
                  this._uiInspector = new Inspector();
               }
               this._uiInspector.enable = !this._uiInspector.enable;
               if(this._uiInspector.enable)
               {
                  param1.output("Inspector is ON.\n Use Ctrl-C to save the last hovered element informations.");
               }
               else
               {
                  param1.output("Inspector is OFF.");
               }
               return;
            case "inspectuielementsos":
            case "inspectuielement":
               if(param3.length == 0)
               {
                  param1.output(param2 + " need at least one argument (" + param2 + " uiName [uiElementName])");
                  return;
               }
               if(!(_loc15_ = Berilia.getInstance().getUi(param3[0])))
               {
                  param1.output("UI " + param3[0] + " not found (use /uilist to grab current displayed UI list)");
                  return;
               }
               if(param3.length == 1)
               {
                  this.inspectUiElement(_loc15_,param2 == "inspectuielementsos"?null:param1);
                  return;
               }
               if(!(_loc16_ = _loc15_.getElement(param3[1])))
               {
                  param1.output("UI Element " + param3[0] + " not found on UI " + param3[0] + "(use /uiinspector to view elements names)");
                  return;
               }
               this.inspectUiElement(_loc16_,param2 == "inspectuielementsos"?null:param1);
               return;
               break;
            default:
               return;
         }
      }
      
      private function inspectUiElement(param1:GraphicContainer, param2:ConsoleHandler) : void
      {
         var txt:String = null;
         var property:String = null;
         var type:String = null;
         var target:GraphicContainer = param1;
         var console:ConsoleHandler = param2;
         var properties:Array = DescribeTypeCache.getVariables(target).concat();
         properties.sort();
         for each(property in properties)
         {
            try
            {
               type = target[property] != null?getQualifiedClassName(target[property]).split("::").pop():"?";
               if(type == "Array")
               {
                  type = type + (", len: " + target[property].length);
               }
               txt = property + " (" + type + ") : " + target[property];
            }
            catch(e:Error)
            {
               txt = property + " (?) : <Exception throw by getter>";
            }
            if(!console)
            {
               _log.info(txt);
            }
            else
            {
               console.output(txt);
            }
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "loadui":
               return "Load an UI. Usage: loadUi <uiId> <uiInstanceName>(optional)";
            case "debugwebreader":
               return "Load the webReader UI in a Debug mode, you can specify the document_id from tbl_game_client_comics_reader optionally. Usage: debugReader <comicId>(optional)";
            case "unloadui":
               return "Unload UI with the given UI instance name.";
            case "clearuicache":
               return "Clear an UI/all UIs (if no paramter) in cache (will force xml parsing)";
            case "setuiscale":
               return "Set scale for all scalable UI. Usage: setUiScale <Number> (100% = 1.0)";
            case "useuicache":
               return "Enable UI caching";
            case "uilist":
               return "Get current UI list";
            case "reloadui":
               return "Unload and reload an UI/all UIs (if no paramter))";
            case "fps":
               return "Toggle FPS";
            case "chatoutput":
               return "Display the chat content in a separated window.";
            case "modulelist":
               return "Display activated modules.";
            case "inspector":
            case "uiinspector":
               return "Display a tooltip with informations over each interactive element";
            case "inspectuielement":
               return "Display the property list of an UI element (UI or Component), usage /inspectuielement uiName (elementName)";
            case "inspectuielementsos":
               return "Display the property list of an UI element (UI or Component) to SOS, usage /inspectuielement uiName (elementName)";
            default:
               return "No help for command \'" + param1 + "\'";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         var _loc4_:* = null;
         var _loc5_:Array = [];
         switch(param1)
         {
            case "unloadui":
               if(param2 == 0)
               {
                  for(_loc4_ in Berilia.getInstance().uiList)
                  {
                     _loc5_.push(Berilia.getInstance().uiList[_loc4_].name);
                  }
               }
         }
         return _loc5_;
      }
   }
}
