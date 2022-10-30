package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.types.data.Theme;
   import com.ankamagames.berilia.types.messages.NoThemeErrorMessage;
   import com.ankamagames.berilia.types.messages.ThemeLoadErrorMessage;
   import com.ankamagames.berilia.types.messages.ThemeLoadedMessage;
   import com.ankamagames.berilia.utils.ThemeFlashProtocol;
   import com.ankamagames.berilia.utils.ThemeProtocol;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.enum.OperatingSystem;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.protocols.ProtocolFactory;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.getQualifiedClassName;
   
   public class ThemeManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ThemeManager));
      
      private static var _self:ThemeManager;
       
      
      private var _loader:IResourceLoader;
      
      private var _themes:Array;
      
      private var _themeNames:Array;
      
      private var _dtFileToLoad:uint = 0;
      
      private var _themeCount:uint = 0;
      
      private var _themesRoot:File;
      
      private var _currentTheme:String;
      
      private var _applyWaiting:String = "";
      
      public function ThemeManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError,false,0,true);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoad,false,0,true);
         if(AirScanner.isStreamingVersion())
         {
            ProtocolFactory.addProtocol("theme",ThemeFlashProtocol);
         }
         else
         {
            ProtocolFactory.addProtocol("theme",ThemeProtocol);
         }
      }
      
      public static function getInstance() : ThemeManager
      {
         if(!_self)
         {
            _self = new ThemeManager();
         }
         return _self;
      }
      
      public function get themeCount() : uint
      {
         return this._themeCount;
      }
      
      public function get currentTheme() : String
      {
         return this._currentTheme;
      }
      
      public function init() : void
      {
         var _loc1_:Uri = null;
         var _loc2_:File = null;
         var _loc3_:File = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:FileStream = null;
         var _loc7_:XML = null;
         var _loc8_:Array = null;
         this._themes = new Array();
         this._themeNames = new Array();
         this._themeCount = 0;
         this._dtFileToLoad = 0;
         var _loc9_:String = File.applicationDirectory.nativePath + File.separator + LangManager.getInstance().getEntry("config.ui.common.themes").replace("file://","");
         this._themesRoot = new File(_loc9_);
         if(this._themesRoot.exists)
         {
            for each(_loc2_ in this._themesRoot.getDirectoryListing())
            {
               if(!(!_loc2_.isDirectory || _loc2_.name.charAt(0) == "."))
               {
                  _loc3_ = this.searchDtFile(_loc2_);
                  if(_loc3_)
                  {
                     ++this._dtFileToLoad;
                     if(_loc3_.url.indexOf("app:/") == 0)
                     {
                        _loc4_ = "app:/".length;
                        _loc5_ = _loc3_.url.substring(_loc4_,_loc3_.url.length);
                        _loc1_ = new Uri(_loc5_);
                     }
                     else
                     {
                        _loc1_ = new Uri(_loc3_.nativePath);
                     }
                     _loc1_.tag = _loc3_;
                     if(SystemManager.getSingleton().os == OperatingSystem.MAC_OS)
                     {
                        _log.debug("Using FileStream to load " + _loc3_.nativePath + " on MAC OS X!");
                        (_loc6_ = new FileStream()).open(_loc3_,FileMode.READ);
                        _loc7_ = XML(_loc6_.readUTFBytes(_loc6_.bytesAvailable));
                        _loc6_.close();
                        _loc8_ = _loc1_.path.split("/");
                        this.loadDT(_loc7_,_loc1_.fileName.split(".")[0],_loc8_[_loc8_.length - 2]);
                     }
                     else
                     {
                        this._loader.load(_loc1_);
                     }
                  }
                  else
                  {
                     ErrorManager.addError("Impossible de trouver le fichier de description de thème dans le dossier " + _loc2_.nativePath);
                     Berilia.getInstance().handler.process(new ThemeLoadErrorMessage(_loc2_.name));
                  }
               }
            }
         }
         else
         {
            ErrorManager.addError("Le dossier des thèmes est introuvable (url:" + LangManager.getInstance().getEntry("config.ui.common.themes") + ")");
         }
      }
      
      public function getThemes() : Array
      {
         return this._themes;
      }
      
      public function getTheme(param1:String) : Theme
      {
         return this._themes[param1];
      }
      
      public function applyTheme(param1:String) : void
      {
         var _loc2_:* = null;
         if(this._dtFileToLoad == this._themeCount)
         {
            if(this._themeNames.length == 0)
            {
               Berilia.getInstance().handler.process(new NoThemeErrorMessage());
            }
            else
            {
               this._applyWaiting = null;
               if(!this._themes[param1])
               {
                  param1 = this._themeNames[0];
                  OptionManager.getOptionManager("dofus")["switchUiSkin"] = param1;
                  UiRenderManager.getInstance().clearCache();
               }
               this._currentTheme = param1;
               _loc2_ = LangManager.getInstance().getEntry("config.ui.common.themes") + param1 + "/";
               LangManager.getInstance().setEntry("config.ui.skin",_loc2_,"string");
               XmlConfig.getInstance().setEntry("config.ui.skin",_loc2_);
               LangManager.getInstance().loadFile(_loc2_ + "colors.xml");
            }
         }
         else
         {
            this._applyWaiting = param1;
         }
      }
      
      private function onLoadError(param1:ResourceErrorEvent) : void
      {
         var _loc2_:File = null;
         _log.error("Cannot load " + param1.uri + "(" + param1.errorMsg + ")");
         var _loc3_:String = param1.uri.toString();
         try
         {
            _loc2_ = param1.uri.toFile();
            _loc3_ = _loc3_ + ("(" + _loc2_.nativePath + ")");
         }
         catch(e:Error)
         {
         }
         ErrorManager.addError("Cannot load " + _loc3_);
         Berilia.getInstance().handler.process(new ThemeLoadErrorMessage(param1.uri.fileName));
      }
      
      private function onLoad(param1:ResourceLoadedEvent) : void
      {
         switch(param1.uri.fileType.toLowerCase())
         {
            case "dt":
               this.onDTLoad(param1);
               return;
            default:
               return;
         }
      }
      
      private function onDTLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:XML = param1.resource as XML;
         var _loc3_:String = param1.uri.fileName.split(".")[0];
         var _loc4_:Array = param1.uri.path.split("/");
         var _loc5_:String = _loc4_[_loc4_.length - 2];
         this.loadDT(_loc2_,_loc3_,_loc5_);
      }
      
      private function loadDT(param1:XML, param2:String, param3:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Theme = null;
         ++this._themeCount;
         if(param2 == param3)
         {
            _loc4_ = param1.name;
            _loc5_ = param1.description;
            _loc6_ = new Theme(param2,_loc4_,_loc5_,param1.previewUri);
            this._themes[param2] = _loc6_;
            this._themeNames.push(param2);
            Berilia.getInstance().handler.process(new ThemeLoadedMessage(param2));
            if(this._applyWaiting != "")
            {
               this.applyTheme(this._applyWaiting);
            }
         }
         else
         {
            Berilia.getInstance().handler.process(new ThemeLoadErrorMessage(param2));
         }
      }
      
      private function searchDtFile(param1:File) : File
      {
         var _loc2_:File = null;
         var _loc3_:File = null;
         if(param1.nativePath.indexOf(".svn") != -1)
         {
            return null;
         }
         var _loc4_:Array = param1.getDirectoryListing();
         for each(_loc2_ in _loc4_)
         {
            if(!_loc2_.isDirectory && _loc2_.extension.toLowerCase() == "dt")
            {
               return _loc2_;
            }
         }
         for each(_loc2_ in _loc4_)
         {
            if(_loc2_.isDirectory)
            {
               _loc3_ = this.searchDtFile(_loc2_);
               if(_loc3_)
               {
                  break;
               }
            }
         }
         return _loc3_;
      }
   }
}
