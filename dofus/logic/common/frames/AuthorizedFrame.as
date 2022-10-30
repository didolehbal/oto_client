package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.berilia.factories.HyperlinkFactory;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.console.BasicConsoleInstructionRegistar;
   import com.ankamagames.dofus.console.DebugConsoleInstructionRegistar;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionType;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.actions.AuthorizedCommandAction;
   import com.ankamagames.dofus.logic.common.actions.QuitGameAction;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkAdminManager;
   import com.ankamagames.dofus.misc.lists.GameDataList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.ProtocolConstantsEnum;
   import com.ankamagames.dofus.network.messages.authorized.AdminCommandMessage;
   import com.ankamagames.dofus.network.messages.authorized.ConsoleMessage;
   import com.ankamagames.dofus.network.messages.security.CheckIntegrityMessage;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleOutputMessage;
   import com.ankamagames.jerakine.console.ConsolesManager;
   import com.ankamagames.jerakine.console.UnhandledConsoleInstructionError;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.RegisteringFrame;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import flash.filesystem.File;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class AuthorizedFrame extends RegisteringFrame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AuthorizedFrame));
       
      
      private var _hasRights:Boolean;
      
      private var _isFantomas:Boolean;
      
      private var _include_CheckIntegrityMessage:CheckIntegrityMessage = null;
      
      private var _loader:IResourceLoader;
      
      public function AuthorizedFrame()
      {
         super();
      }
      
      override public function get priority() : int
      {
         return Priority.LOW;
      }
      
      override public function pushed() : Boolean
      {
         this.hasRights = false;
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.objectLoaded);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.objectLoadedFailed);
         this._loader.load(new Uri(File.applicationDirectory.nativePath + File.separator + "uplauncher.xml"));
         return true;
      }
      
      override public function pulled() : Boolean
      {
         return true;
      }
      
      public function set hasRights(param1:Boolean) : void
      {
         this._hasRights = param1;
         if(param1)
         {
            HyperlinkFactory.registerProtocol("admin",HyperlinkAdminManager.addCmd);
            ConsolesManager.registerConsole("debug",new ConsoleHandler(Kernel.getWorker()),new DebugConsoleInstructionRegistar());
         }
         else
         {
            ConsolesManager.registerConsole("debug",new ConsoleHandler(Kernel.getWorker()),new BasicConsoleInstructionRegistar());
         }
      }
      
      public function isFantomas() : Boolean
      {
         return this._isFantomas;
      }
      
      override protected function registerMessages() : void
      {
         register(ConsoleMessage,this.onConsoleMessage);
         register(AuthorizedCommandAction,this.onAuthorizedCommandAction);
         register(ConsoleOutputMessage,this.onConsoleOutputMessage);
         register(QuitGameAction,this.onQuitGameAction);
      }
      
      private function onConsoleMessage(param1:ConsoleMessage) : Boolean
      {
         ConsolesManager.getConsole("debug").output(param1.content,param1.type);
         return true;
      }
      
      private function onAuthorizedCommandAction(param1:AuthorizedCommandAction) : Boolean
      {
         var acmsg:AdminCommandMessage = null;
         var aca:AuthorizedCommandAction = param1;
         if(aca.command.substr(0,1) == "/")
         {
            try
            {
               ConsolesManager.getConsole("debug").process(ConsolesManager.getMessage(aca.command));
            }
            catch(ucie:UnhandledConsoleInstructionError)
            {
               ConsolesManager.getConsole("debug").output("Unknown command: " + aca.command + "\n");
            }
         }
         else if(ConnectionsHandler.connectionType != ConnectionType.DISCONNECTED)
         {
            if(this._hasRights)
            {
               if(aca.command.length >= 1 && aca.command.length <= ProtocolConstantsEnum.MAX_CHAT_LEN)
               {
                  acmsg = new AdminCommandMessage();
                  acmsg.initAdminCommandMessage(aca.command);
                  ConnectionsHandler.getConnection().send(acmsg);
               }
               else
               {
                  ConsolesManager.getConsole("debug").output("Too long command is too long, try again.");
               }
            }
            else
            {
               ConsolesManager.getConsole("debug").output("You have no admin rights, please use only client side commands. (/help)");
            }
         }
         else
         {
            ConsolesManager.getConsole("debug").output("You are disconnected, use only client side commands.");
         }
         return true;
      }
      
      private function onConsoleOutputMessage(param1:ConsoleOutputMessage) : Boolean
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:* = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:Object = null;
         var _loc14_:uint = 0;
         if(param1.consoleId != "debug")
         {
            return false;
         }
         var _loc10_:Dictionary = this.getValidClass();
         var _loc11_:String = param1.text;
         var _loc12_:RegExp = /@client\((\w*)\.(\d*)\.(\w*)\)/gm;
         var _loc13_:* = true;
         while(_loc13_ && _loc14_++ < 100)
         {
            _loc2_ = _loc11_.match(_loc12_);
            _loc13_ = _loc2_.length != 0;
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = null;
               _loc5_ = _loc3_.substring(8,_loc3_.length - 1).split(".");
               if((_loc6_ = _loc10_[_loc5_[0].toLowerCase()]) != null)
               {
                  _loc7_ = getDefinitionByName(_loc6_);
                  if((_loc8_ = this.getIdFunction(_loc6_)) != null)
                  {
                     if((_loc9_ = _loc7_[_loc8_](parseInt(_loc5_[1]))) != null)
                     {
                        if(_loc9_.hasOwnProperty(_loc5_[2]))
                        {
                           _loc4_ = _loc9_[_loc5_[2]];
                        }
                        else
                        {
                           _loc4_ = _loc3_.substr(0,_loc3_.length - 1) + ".bad field)";
                        }
                     }
                     else
                     {
                        _loc4_ = _loc3_.substr(0,_loc3_.length - 1) + ".bad ID)";
                     }
                  }
                  else
                  {
                     _loc4_ = _loc3_.substr(0,_loc3_.length - 1) + ".not compatible class)";
                  }
               }
               else
               {
                  _loc4_ = _loc3_.substr(0,_loc3_.length - 1) + ".bad class)";
               }
               _loc11_ = _loc11_.split(_loc3_).join(_loc4_);
            }
         }
         KernelEventsManager.getInstance().processCallback(HookList.ConsoleOutput,_loc11_,param1.type);
         return true;
      }
      
      private function getValidClass() : Dictionary
      {
         var _loc1_:XML = null;
         var _loc2_:Array = null;
         var _loc3_:Dictionary = new Dictionary();
         var _loc4_:XML = DescribeTypeCache.typeDescription(GameDataList);
         for each(_loc1_ in _loc4_..constant)
         {
            _loc2_ = this.getSimpleVariablesAndAccessors(String(_loc1_.@type));
            if(_loc2_.indexOf("id") != -1)
            {
               _loc3_[String(_loc1_.@name).toLowerCase()] = String(_loc1_.@type);
            }
         }
         return _loc3_;
      }
      
      private function getSimpleVariablesAndAccessors(param1:String, param2:Boolean = false) : Array
      {
         var _loc3_:String = null;
         var _loc4_:XML = null;
         var _loc5_:Array = new Array();
         var _loc6_:XML = DescribeTypeCache.typeDescription(getDefinitionByName(param1));
         for each(_loc4_ in _loc6_..variable)
         {
            _loc3_ = String(_loc4_.@type);
            if(_loc3_ == "int" || _loc3_ == "uint" || _loc3_ == "Number" || _loc3_ == "String")
            {
               _loc5_.push(String(_loc4_.@name));
            }
            if(param2)
            {
               if(_loc3_.indexOf("Vector.<int>") != -1 || _loc3_.indexOf("Vector.<uint>") != -1 || _loc3_.indexOf("Vector.<Number>") != -1 || _loc3_.indexOf("Vector.<String>") != -1)
               {
                  if(_loc3_.split("Vector").length == 2)
                  {
                     _loc5_.push(String(_loc4_.@name));
                  }
               }
            }
         }
         for each(_loc4_ in _loc6_..accessor)
         {
            _loc3_ = String(_loc4_.@type);
            if(_loc3_ == "int" || _loc3_ == "uint" || _loc3_ == "Number" || _loc3_ == "String")
            {
               _loc5_.push(String(_loc4_.@name));
            }
            if(param2)
            {
               if(_loc3_.indexOf("Vector.<int>") != -1 || _loc3_.indexOf("Vector.<uint>") != -1 || _loc3_.indexOf("Vector.<Number>") != -1 || _loc3_.indexOf("Vector.<String>") != -1)
               {
                  if(_loc3_.split("Vector").length == 2)
                  {
                     _loc5_.push(String(_loc4_.@name));
                  }
               }
            }
         }
         return _loc5_;
      }
      
      private function getIdFunction(param1:String) : String
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:XML = DescribeTypeCache.typeDescription(getDefinitionByName(param1));
         for each(_loc2_ in _loc4_..method)
         {
            if(_loc2_.@returnType == param1 && (XMLList(_loc2_.parameter).length() == 1 || XMLList(_loc2_.parameter).length() == 2))
            {
               _loc3_ = String(XMLList(_loc2_.parameter)[0].@type);
               if(_loc3_ == "int" || _loc3_ == "uint")
               {
                  if(String(_loc2_.@name).indexOf("ById") != -1)
                  {
                     return String(_loc2_.@name);
                  }
               }
            }
         }
         return null;
      }
      
      private function onQuitGameAction(param1:QuitGameAction) : Boolean
      {
         Dofus.getInstance().quit();
         return true;
      }
      
      public function objectLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:XML = new XML(param1.resource);
         if(_loc2_.Debug.fantomas.contains("1"))
         {
            this._isFantomas = true;
         }
         else
         {
            this._isFantomas = false;
         }
      }
      
      public function objectLoadedFailed(param1:ResourceErrorEvent) : void
      {
         _log.debug("Uplauncher loading failed : " + param1.uri + ", " + param1.errorMsg);
      }
   }
}
