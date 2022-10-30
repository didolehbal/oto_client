package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.console.moduleLogger.ModuleDebugManager;
   import com.ankamagames.dofus.logic.game.common.actions.CaptureScreenAction;
   import com.ankamagames.dofus.logic.game.common.actions.CaptureScreenWithoutUIAction;
   import com.ankamagames.dofus.logic.game.common.actions.ChangeScreenshotsDirectoryAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.uiApi.CaptureApi;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.enum.OperatingSystem;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class ScreenCaptureFrame implements Frame
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(ScreenCaptureFrame));
      
      private static const MAP_HEIGHT:uint = 886;
       
      
      private var _lastClipboardBitmap:BitmapData;
      
      private var _encoder:PNGEncoder2;
      
      private var _capturing:Boolean;
      
      private var _captureCount:uint = 1;
      
      public function ScreenCaptureFrame()
      {
         super();
      }
      
      public static function getDefaultDirectory() : String
      {
         var _loc1_:* = null;
         switch(SystemManager.getSingleton().os)
         {
            case OperatingSystem.WINDOWS:
            case OperatingSystem.MAC_OS:
               _loc1_ = File.userDirectory.nativePath + File.separator + "Pictures";
               break;
            case OperatingSystem.LINUX:
               _loc1_ = File.userDirectory.nativePath + File.separator + "Images";
         }
         var _loc2_:File = new File(_loc1_);
         if(!_loc2_.exists)
         {
            _loc1_ = File.documentsDirectory.nativePath + File.separator + "Dofus" + File.separator + "screenshots";
         }
         return _loc1_;
      }
      
      public function pushed() : Boolean
      {
         PNGEncoder2.level = CompressionLevel.UNCOMPRESSED;
         if(StageShareManager.isActive)
         {
            this.onActivate(null);
         }
         StageShareManager.stage.addEventListener(Event.ACTIVATE,this.onActivate);
         return true;
      }
      
      public function pulled() : Boolean
      {
         StageShareManager.stage.removeEventListener(Event.ACTIVATE,this.onActivate);
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         switch(true)
         {
            case param1 is ChangeScreenshotsDirectoryAction:
               this.selectDirectory();
               return true;
            case param1 is CaptureScreenAction:
            case param1 is CaptureScreenWithoutUIAction:
               if(!this._capturing)
               {
                  this._capturing = true;
                  this.captureScreen(param1 is CaptureScreenWithoutUIAction);
                  this.updateClipboardBitmap();
               }
               return true;
            default:
               return false;
         }
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      private function selectDirectory() : void
      {
         var _loc1_:String = OptionManager.getOptionManager("dofus")["screenshotsDirectory"];
         if(!_loc1_)
         {
            _loc1_ = getDefaultDirectory();
         }
         var _loc2_:File = new File(_loc1_);
         _loc2_.addEventListener(Event.SELECT,this.onFileSelect);
         _loc2_.browseForDirectory(I18n.getUiText("ui.gameuicore.screenshot.changeDirectory"));
      }
      
      private function onSaveFile(param1:Event) : void
      {
         var _loc2_:File = null;
         var _loc3_:Date = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:* = null;
         var _loc7_:FileStream = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         this._encoder.removeEventListener(Event.COMPLETE,this.onSaveFile);
         var _loc10_:String;
         if(!(_loc10_ = OptionManager.getOptionManager("dofus")["screenshotsDirectory"]))
         {
            _loc10_ = getDefaultDirectory();
         }
         if(this.checkWritePermissions(_loc10_))
         {
            _loc3_ = new Date();
            _loc4_ = TimeManager.getInstance().formatDateIRL(_loc3_.time).split("/");
            _loc5_ = TimeManager.getInstance().formatClock(_loc3_.time) + ":" + (_loc3_.seconds < 10?"0" + _loc3_.seconds:_loc3_.seconds);
            _loc6_ = "dofus-" + _loc4_[2] + "-" + _loc4_[1] + "-" + _loc4_[0] + "_" + _loc5_.replace(/:/g,"-") + "-" + PlayedCharacterManager.getInstance().infos.name + ".png";
            _loc7_ = new FileStream();
            _loc2_ = new File(_loc10_).resolvePath(_loc6_);
            if(_loc2_.exists)
            {
               ++this._captureCount;
               _loc8_ = _loc6_.lastIndexOf("-");
               _loc9_ = _loc6_.substring(0,_loc8_) + "_" + this._captureCount + _loc6_.substring(_loc8_);
               _loc2_ = new File(_loc10_).resolvePath(_loc9_);
            }
            else
            {
               this._captureCount = 1;
            }
            _loc7_.open(_loc2_,FileMode.WRITE);
            _loc7_.writeBytes(this._encoder.png#1);
            _loc7_.close();
            this.displayChatMessage(_loc2_);
            this._capturing = false;
            PNGEncoder2.freeCachedMemory();
            this.updateClipboardBitmap();
         }
      }
      
      private function captureScreen(param1:Boolean = false) : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Dictionary = null;
         var _loc4_:* = undefined;
         var _loc5_:Boolean = false;
         var _loc6_:Vector.<String> = null;
         if(param1)
         {
            _loc3_ = Berilia.getInstance().uiList;
            _loc6_ = new Vector.<String>(0);
            for(_loc4_ in _loc3_)
            {
               if((_loc4_ as String).indexOf("tooltip_entity") == -1)
               {
                  if(_loc3_[_loc4_].visible)
                  {
                     _loc3_[_loc4_].visible = false;
                     _loc6_.push(_loc4_);
                  }
               }
            }
            if(XmlConfig.getInstance().getBooleanEntry("config.dev.mode") && XmlConfig.getInstance().getBooleanEntry("config.dev.auto.display.controler"))
            {
               _loc5_ = true;
               ModuleDebugManager.display(false);
            }
            _loc2_ = CaptureApi.getScreen(new Rectangle(0,0,StageShareManager.startWidth,MAP_HEIGHT));
            for each(_loc4_ in _loc6_)
            {
               _loc3_[_loc4_].visible = true;
            }
            if(_loc5_)
            {
               ModuleDebugManager.display(true);
            }
         }
         else
         {
            _loc2_ = CaptureApi.getScreen();
         }
         this._encoder = PNGEncoder2.encodeAsync(_loc2_);
         this._encoder.addEventListener(Event.COMPLETE,this.onSaveFile);
      }
      
      private function updateClipboardBitmap() : void
      {
         if(Clipboard.generalClipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT))
         {
            this._lastClipboardBitmap = Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData;
         }
      }
      
      private function displayChatMessage(param1:File) : void
      {
         KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,"{system," + param1.parent.nativePath + "::" + I18n.getUiText("ui.gameuicore.screenshot",[param1.nativePath]) + "}",ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp(),false);
      }
      
      private function checkWritePermissions(param1:String) : Boolean
      {
         var success:Boolean = false;
         var fs:FileStream = null;
         var f:File = null;
         var mod:UiModule = null;
         var pPath:String = param1;
         try
         {
            fs = new FileStream();
            f = new File(pPath).resolvePath("foo.bar");
            fs.open(f,FileMode.WRITE);
            success = true;
         }
         catch(e:Error)
         {
            mod = UiModuleManager.getInstance().getModule("Ankama_Common");
            Berilia.getInstance().loadUi(mod,mod.uis["popup"],"screenshot_error_popup",{
               "title":I18n.getUiText("ui.common.error"),
               "content":I18n.getUiText("ui.gameuicore.screenshot.changeDirectory.error"),
               "buttonText":[I18n.getUiText("ui.common.ok")],
               "buttonCallback":[selectDirectory],
               "onEnterKey":selectDirectory
            },false,StrataEnum.STRATA_TOP);
         }
         if(success)
         {
            fs.close();
            f.deleteFile();
         }
         return success;
      }
      
      private function onFileSelect(param1:Event) : void
      {
         var _loc2_:File = param1.currentTarget as File;
         _loc2_.removeEventListener(Event.SELECT,this.onFileSelect);
         if(this.checkWritePermissions(_loc2_.nativePath))
         {
            OptionManager.getOptionManager("dofus")["screenshotsDirectory"] = _loc2_.nativePath;
         }
      }
      
      private function onActivate(param1:Event) : void
      {
         this.updateClipboardBitmap();
      }
   }
}
