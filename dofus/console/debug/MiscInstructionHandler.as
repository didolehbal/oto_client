package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.types.graphic.TimeoutHTMLLoader;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.SynchronisationFrame;
   import com.ankamagames.dofus.logic.game.common.managers.InactivityManager;
   import com.ankamagames.dofus.logic.shield.SecureModeManager;
   import com.ankamagames.dofus.logic.shield.ShieldSecureLevel;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.handlers.HumanInputHandler;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.LogLogger;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.replay.LogFrame;
   import com.ankamagames.jerakine.utils.crypto.Base64;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.desktop.NativeApplication;
   import flash.display.DisplayObject;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.InvokeEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class MiscInstructionHandler implements ConsoleInstructionHandler
   {
       
      
      private var _synchronisationFrameInstance:SynchronisationFrame;
      
      public function MiscInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var log:Logger = null;
         var size:uint = 0;
         var emptySince:uint = 0;
         var i:uint = 0;
         var s:String = null;
         var managerName:String = null;
         var manager:OptionManager = null;
         var logFile:File = null;
         var entitiesList:Array = null;
         var level:uint = 0;
         var monster:Monster = null;
         var prop:Array = null;
         var name:String = null;
         var p:Object = null;
         var fsLog:FileStream = null;
         var logContent:ByteArray = null;
         var entity:TiphonSprite = null;
         var tete:DisplayObject = null;
         var oldValue:Number = NaN;
         var monsterLook:TiphonEntityLook = null;
         var changeCount:uint = 0;
         var sceneEntity:IEntity = null;
         var console:ConsoleHandler = param1;
         var cmd:String = param2;
         var args:Array = param3;
         var val:* = undefined;
         var o:* = undefined;
         switch(cmd)
         {
            case "log":
               log = Log.getLogger(getQualifiedClassName(MiscInstructionHandler));
               LogLogger.activeLog(args[0] == "true" || args[0] == "on");
               console.output("Log set to " + LogLogger.logIsActive());
               return;
            case "newdofus":
               NativeApplication.nativeApplication.dispatchEvent(new Event(InvokeEvent.INVOKE));
               return;
            case "i18nsize":
               size = 0;
               emptySince = 0;
               i = 1;
               s = "";
               do
               {
                  s = I18n.getText(i++);
                  if(s)
                  {
                     emptySince = 0;
                     size = size + s.length;
                  }
                  else
                  {
                     emptySince++;
                  }
               }
               while(emptySince < 20);
               
               console.output(size + " characters in " + (i - 1) + " entries.");
               return;
            case "clear":
               KernelEventsManager.getInstance().processCallback(HookList.ConsoleClear);
               return;
            case "config":
               if(!args[0])
               {
                  console.output("Syntax : /config <manager> [<option>]");
                  return;
               }
               managerName = args[0];
               if(!OptionManager.getOptionManager(managerName))
               {
                  console.output("Unknown manager \'" + managerName + "\').");
                  return;
               }
               manager = OptionManager.getOptionManager(managerName);
               if(args[1])
               {
                  if(manager[args[1]] != null)
                  {
                     val = args[2];
                     if(val == "true")
                     {
                        val = true;
                     }
                     if(val == "false")
                     {
                        val = false;
                     }
                     if(parseInt(val).toString() == val)
                     {
                        val = parseInt(val);
                     }
                     manager[args[1]] = val;
                  }
                  else
                  {
                     console.output(args[1] + " not found on " + manager);
                  }
               }
               else
               {
                  prop = new Array();
                  for(name in manager)
                  {
                     prop.push({
                        "name":name,
                        "value":manager[name]
                     });
                  }
                  prop.sortOn("name");
                  for each(p in prop)
                  {
                     console.output(" - " + p.name + " : " + p.value);
                  }
               }
               return;
               break;
            case "clearwebcache":
               TimeoutHTMLLoader.resetCache();
               return;
            case "geteventmodeparams":
               if(args.length != 2)
               {
                  console.output("Syntax : /getEventModeParams <login> <password>");
                  return;
               }
               console.output(Base64.encode("login:" + args[0] + ",password:" + args[1]));
               return;
               break;
            case "setquality":
               if(args.length != 1)
               {
                  console.output("Current stage.quality : [" + StageShareManager.stage.quality + "]");
                  return;
               }
               StageShareManager.stage.quality = args[0];
               console.output("Try set stage.qualitity to [" + args[0] + "], result : [" + StageShareManager.stage.quality + "]");
               return;
               break;
            case "lowdefskin":
               for each(o in EntitiesManager.getInstance().entities)
               {
                  if(o is TiphonSprite)
                  {
                     TiphonSprite(o).setAlternativeSkinIndex(TiphonSprite(o).getAlternativeSkinIndex() == -1?0:-1);
                  }
               }
               return;
            case "copylog":
               LogFrame.getInstance(false).duplicateLogFile();
               return;
            case "savereplaylog":
               logFile = LogFrame.getInstance(false).duplicateLogFile();
               if(logFile.exists)
               {
                  fsLog = new FileStream();
                  logContent = new ByteArray();
                  fsLog.open(logFile,FileMode.READ);
                  fsLog.readBytes(logContent);
                  File.desktopDirectory.save(logContent,"log.d2l");
               }
               return;
            case "synchrosequence":
               if(Kernel.getWorker().contains(SynchronisationFrame))
               {
                  this._synchronisationFrameInstance = Kernel.getWorker().getFrame(SynchronisationFrame) as SynchronisationFrame;
                  Kernel.getWorker().removeFrame(this._synchronisationFrameInstance);
                  console.output("Synchro sequence disable");
               }
               else if(this._synchronisationFrameInstance)
               {
                  console.output("Synchro sequence enable");
                  Kernel.getWorker().addFrame(this._synchronisationFrameInstance);
               }
               else
               {
                  console.output("Can\'t enable synchro sequence");
               }
               return;
            case "throw":
               if(args[0] == "async")
               {
                  setTimeout(function():void
                  {
                     throw new Error("Test error");
                  },100);
                  return;
               }
               throw new Error("Test error");
               break;
            case "sd":
               entitiesList = EntitiesManager.getInstance().entities;
               for each(entity in entitiesList)
               {
                  if(entity)
                  {
                     tete = entity.getSlot("Tete");
                     if(tete)
                     {
                        tete.scaleX = 2;
                        tete.scaleY = 2;
                     }
                  }
               }
               return;
            case "shieldmax":
            case "shieldmed":
            case "shieldmin":
               if(cmd == "shieldmax")
               {
                  level = ShieldSecureLevel.MAX;
               }
               else if(cmd == "shieldmed")
               {
                  level = ShieldSecureLevel.MEDIUM;
               }
               else if(cmd == "shieldmin")
               {
                  level = ShieldSecureLevel.LOW;
               }
               SecureModeManager.getInstance().shieldLevel = level;
               console.output(I18n.getUiText("ui.shield.changeNotification" + level.toString()));
               return;
            case "debugmouseover":
               HumanInputHandler.getInstance().debugOver = !HumanInputHandler.getInstance().debugOver;
               return;
            case "idletime":
               if(args.length == 1)
               {
                  InactivityManager.getInstance().inactivityDelay = int(args[0]) * 1000;
               }
               console.output("Temps avant inactivité : " + Math.floor(InactivityManager.getInstance().inactivityDelay / 1000) + "s");
               return;
            case "setmonsterspeed":
               if(args.length >= 1)
               {
                  monster = Monster.getMonsterById(int(args[0]));
               }
               if(args.length == 1)
               {
                  console.output("Vitesse du monstre " + monster.name + " (id:" + monster.id + ") : " + monster.speedAdjust);
               }
               else if(args.length == 2)
               {
                  oldValue = monster.speedAdjust;
                  monster.speedAdjust = parseFloat(args[1]);
                  console.output("Vitesse du monstre " + monster.name + " (id:" + monster.id + ") : " + monster.speedAdjust + " (ancienne valeur: " + oldValue + ")");
                  monsterLook = TiphonEntityLook.fromString(monster.look);
                  changeCount = 0;
                  for each(sceneEntity in EntitiesManager.getInstance().entities)
                  {
                     if(sceneEntity is AnimatedCharacter && AnimatedCharacter(sceneEntity).look.getBone() == monsterLook.getBone())
                     {
                        changeCount++;
                        AnimatedCharacter(sceneEntity).speedAdjust = monster.speedAdjust;
                     }
                  }
                  console.output("Nombre d\'entité sur la scene modifiées : " + changeCount);
               }
               else
               {
                  console.output("Un ou deux arguments sont nécessaires : ID du monstre, 2 vitesse de -10 à +10");
               }
               return;
            default:
               return;
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "log":
               return "Switch on/off client log process.";
            case "i18nsize":
               return "Get the total size in characters of I18N datas.";
            case "newdofus":
               return "Try to launch a new dofus client.";
            case "clear":
               return "clear the console output";
            case "clearwebcache":
               return "clear cached web browser";
            case "geteventmodeparams":
               return "Get event mode config file param. param 1 : login, param 2 : password";
            case "setquality":
               return "Set stage quality (no param to get actual value)";
            case "config":
               return "list options in different managers if no param else set an option /config [managerName] [paramName] [paramValue]";
            case "copylog":
               return "Copy current log file to xxx.copy";
            case "savereplaylog":
               return I18n.getUiText("ui.chat.console.help.savereplaylog");
            case "synchrosequence":
               return "Enable/disable synchro sequence";
            case "throw":
               return "Throw an exception (test only) option:[async|sync]";
            case "debugmouseover":
               return "Activate/Deactivate mouse over debug : It will show which objects receive event and their bounds.";
            case "idletime":
               return "Set inactivity time limit (in seconds)";
            case "setmonsterspeed":
               return "Ajuste la vitesse de déplacement d\'un monstre";
            case "shieldmin":
               return I18n.getUiText("ui.shield.changeHelp0");
            case "shieldmed":
               return I18n.getUiText("ui.shield.changeHelp1");
            case "shieldmax":
               return I18n.getUiText("ui.shield.changeHelp2");
            default:
               return "No help for command \'" + param1 + "\'";
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         var _loc4_:String = null;
         var _loc5_:* = null;
         var _loc6_:Array = [];
         switch(param1)
         {
            case "throw":
               _loc6_ = ["async","sync"];
               break;
            case "setquality":
               _loc6_ = [StageQuality.LOW,StageQuality.MEDIUM,StageQuality.HIGH,StageQuality.BEST];
               break;
            case "config":
               if(param2 == 0)
               {
                  _loc6_ = OptionManager.getOptionManagers();
               }
               else if(param2 == 1)
               {
                  _loc4_ = param3[0];
                  for(_loc5_ in OptionManager.getOptionManager(_loc4_))
                  {
                     _loc6_.push(_loc5_);
                  }
               }
         }
         return _loc6_;
      }
   }
}
