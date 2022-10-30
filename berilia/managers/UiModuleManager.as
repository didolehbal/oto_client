package com.ankamagames.berilia.managers
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.api.ApiBinder;
   import com.ankamagames.berilia.types.data.PreCompiledUiModule;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiGroup;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.event.ParsingErrorEvent;
   import com.ankamagames.berilia.types.event.ParsorEvent;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.messages.AllModulesLoadedMessage;
   import com.ankamagames.berilia.types.messages.AllUiXmlParsedMessage;
   import com.ankamagames.berilia.types.messages.ModuleLoadedMessage;
   import com.ankamagames.berilia.types.messages.ModuleRessourceLoadFailedMessage;
   import com.ankamagames.berilia.types.messages.UiXmlParsedErrorMessage;
   import com.ankamagames.berilia.types.messages.UiXmlParsedMessage;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.berilia.types.shortcut.ShortcutCategory;
   import com.ankamagames.berilia.uiRender.XmlParsor;
   import com.ankamagames.berilia.utils.ModFlashProtocol;
   import com.ankamagames.berilia.utils.ModProtocol;
   import com.ankamagames.berilia.utils.UriCacheFactory;
   import com.ankamagames.berilia.utils.errors.UntrustedApiCallError;
   import com.ankamagames.berilia.utils.web.HttpServer;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.resources.ResourceType;
   import com.ankamagames.jerakine.resources.adapters.impl.AdvancedSignedFileAdapter;
   import com.ankamagames.jerakine.resources.adapters.impl.AdvancedSwfAdapter;
   import com.ankamagames.jerakine.resources.adapters.impl.BinaryAdapter;
   import com.ankamagames.jerakine.resources.adapters.impl.SignedFileAdapter;
   import com.ankamagames.jerakine.resources.adapters.impl.TxtAdapter;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.protocols.ProtocolFactory;
   import com.ankamagames.jerakine.types.ASwf;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.crypto.Signature;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.FrameIdManager;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class UiModuleManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UiModuleManager));
      
      private static const _lastModulesToUnload:Array = ["Ankama_GameUiCore","Ankama_Common","Ankama_Tooltips","Ankama_ContextMenu"];
      
      private static var _self:UiModuleManager;
       
      
      private var _sharedDefinitionLoader:IResourceLoader;
      
      private var _sharedDefinition:ApplicationDomain;
      
      private var _useSharedDefinition:Boolean;
      
      private var _loader:IResourceLoader;
      
      private var _uiLoader:IResourceLoader;
      
      private var _scriptNum:uint;
      
      private var _modules:Array;
      
      private var _preprocessorIndex:Dictionary;
      
      private var _uiFiles:Array;
      
      private var _regImport:RegExp;
      
      private var _versions:Array;
      
      private var _clearUi:Array;
      
      private var _uiFileToLoad:uint;
      
      private var _moduleCount:uint = 0;
      
      private var _cacheLoader:IResourceLoader;
      
      private var _unparsedXml:Array;
      
      private var _unparsedXmlCount:uint;
      
      private var _unparsedXmlTotalCount:uint;
      
      private var _modulesRoot:File;
      
      private var _modulesPaths:Dictionary;
      
      private var _modulesHashs:Dictionary;
      
      private var _resetState:Boolean;
      
      private var _parserAvaibleCount:uint = 2;
      
      private var _moduleLaunchWaitForSharedDefinition:Boolean;
      
      private var _unInitializedModules:Array;
      
      private var _useHttpServer:Boolean;
      
      private var _moduleLoaders:Dictionary;
      
      private var _loadingModule:Dictionary;
      
      private var _disabledModules:Array;
      
      private var _sharedDefinitionInstance:Object;
      
      private var _timeOutFrameNumber:int;
      
      private var _waitingInit:Boolean;
      
      private var _filter:Array;
      
      private var _filterInclude:Boolean;
      
      public var isDevMode:Boolean;
      
      private var _moduleScriptLoadedRef:Dictionary;
      
      private var _uiLoaded:Dictionary;
      
      private var _loadModuleFunction:Function;
      
      public function UiModuleManager(param1:Boolean = false)
      {
         this._regImport = /<Import *url *= *"([^"]*)/g;
         this._modulesHashs = new Dictionary();
         this._moduleScriptLoadedRef = new Dictionary();
         this._uiLoaded = new Dictionary();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError,false,0,true);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoad,false,0,true);
         this._sharedDefinitionLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
         this._sharedDefinitionLoader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError,false,0,true);
         this._sharedDefinitionLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onSharedDefinitionLoad,false,0,true);
         this._uiLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._uiLoader.addEventListener(ResourceErrorEvent.ERROR,this.onUiLoadError,false,0,true);
         this._uiLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onUiLoaded,false,0,true);
         this._cacheLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._moduleLoaders = new Dictionary();
         this._useHttpServer = false;
         if(!param1 && ApplicationDomain.currentDomain.hasDefinition("flash.net.ServerSocket"))
         {
            this._useHttpServer = true;
         }
         if(this._useHttpServer)
         {
            HttpServer.getInstance().init(File.applicationDirectory);
         }
      }
      
      public static function getInstance(param1:Boolean = false) : UiModuleManager
      {
         if(!_self)
         {
            _self = new UiModuleManager(param1);
         }
         return _self;
      }
      
      public function get unInitializedModules() : Array
      {
         return this._unInitializedModules;
      }
      
      public function get moduleCount() : uint
      {
         return this._moduleCount;
      }
      
      public function get unparsedXmlCount() : uint
      {
         return this._unparsedXmlCount;
      }
      
      public function get unparsedXmlTotalCount() : uint
      {
         return this._unparsedXmlTotalCount;
      }
      
      public function set sharedDefinitionContainer(param1:Uri) : void
      {
         var _loc2_:String = null;
         var _loc3_:Uri = null;
         this._useSharedDefinition = param1 != null;
         if(param1)
         {
            if(this._useHttpServer)
            {
               _loc2_ = HttpServer.getInstance().getUrlTo(param1.fileName);
               _loc3_ = new Uri(_loc2_);
               _log.debug("sharedDefinition.swf location: " + param1.uri + " (" + _loc2_ + ")");
               this._sharedDefinitionLoader.load(_loc3_,null,param1.fileType == "swf"?AdvancedSwfAdapter:null);
               _log.info("trying to load sharedDefinition.swf throught an httpServer");
               FrameIdManager.frameId;
               this._timeOutFrameNumber = StageShareManager.stage.frameRate * 10;
               EnterFrameDispatcher.addEventListener(this.timeOutFrameCount,"frameCount");
            }
            else
            {
               this._sharedDefinitionLoader.load(param1,null,param1.fileType == "swf"?AdvancedSwfAdapter:null);
               _log.info("trying to load sharedDefinition.swf the good ol\' way");
            }
         }
      }
      
      public function get sharedDefinition() : ApplicationDomain
      {
         return this._sharedDefinition;
      }
      
      public function get ready() : Boolean
      {
         return this._sharedDefinition != null;
      }
      
      public function get sharedDefinitionInstance() : Object
      {
         return this._sharedDefinitionInstance;
      }
      
      public function get modulesHashs() : Dictionary
      {
         return this._modulesHashs;
      }
      
      public function init(param1:Array, param2:Boolean) : void
      {
         var _loc3_:Uri = null;
         var _loc4_:File = null;
         this._filter = param1;
         this._filterInclude = param2;
         if(!this._sharedDefinition)
         {
            this._waitingInit = true;
            return;
         }
         this._moduleLaunchWaitForSharedDefinition = false;
         this._resetState = false;
         this._modules = new Array();
         this._preprocessorIndex = new Dictionary(true);
         this._scriptNum = 0;
         this._moduleCount = 0;
         this._versions = new Array();
         this._clearUi = new Array();
         this._uiFiles = new Array();
         this._modulesPaths = new Dictionary();
         this._unInitializedModules = new Array();
         this._loadingModule = new Dictionary();
         this._disabledModules = [];
         if(AirScanner.hasAir())
         {
            ProtocolFactory.addProtocol("mod",ModProtocol);
         }
         else
         {
            ProtocolFactory.addProtocol("mod",ModFlashProtocol);
         }
         var _loc5_:String;
         if((_loc5_ = LangManager.getInstance().getEntry("config.mod.path")).substr(0,2) != "\\\\" && _loc5_.substr(1,2) != ":/")
         {
            this._modulesRoot = new File(File.applicationDirectory.nativePath + File.separator + _loc5_);
         }
         else
         {
            this._modulesRoot = new File(_loc5_);
         }
         _loc3_ = new Uri(this._modulesRoot.nativePath + "/hash.metas");
         this._loader.load(_loc3_);
         BindsManager.getInstance().initialize();
         if(this._modulesRoot.exists)
         {
            for each(_loc4_ in this._modulesRoot.getDirectoryListing())
            {
               if(!(!_loc4_.isDirectory || _loc4_.name.charAt(0) == "."))
               {
                  if(param1.indexOf(_loc4_.name) != -1 == param2)
                  {
                     this.loadModule(_loc4_.name);
                  }
               }
            }
            return;
         }
         ErrorManager.addError("Impossible de trouver le dossier contenant les modules (url: " + LangManager.getInstance().getEntry("config.mod.path") + ")");
      }
      
      public function lightInit(param1:Vector.<UiModule>) : void
      {
         var _loc2_:UiModule = null;
         this._resetState = false;
         this._modules = new Array();
         this._modulesPaths = new Dictionary();
         for each(_loc2_ in param1)
         {
            this._modules[_loc2_.id] = _loc2_;
            this._modulesPaths[_loc2_.id] = _loc2_.rootPath;
         }
      }
      
      public function getModules() : Array
      {
         return this._modules;
      }
      
      public function getModule(param1:String, param2:Boolean = false) : UiModule
      {
         var _loc3_:UiModule = null;
         if(this._modules)
         {
            _loc3_ = this._modules[param1];
         }
         if(!_loc3_ && param2 && this._unInitializedModules)
         {
            _loc3_ = this._unInitializedModules[param1];
         }
         return _loc3_;
      }
      
      public function get disabledModules() : Array
      {
         return this._disabledModules;
      }
      
      public function reset() : void
      {
         var _loc1_:UiModule = null;
         var _loc2_:int = 0;
         _log.warn("Reset des modules");
         this._resetState = true;
         if(this._loader)
         {
            this._loader.cancel();
         }
         if(this._cacheLoader)
         {
            this._cacheLoader.cancel();
         }
         if(this._uiLoader)
         {
            this._uiLoader.cancel();
         }
         TooltipManager.clearCache();
         for each(_loc1_ in this._modules)
         {
            if(_lastModulesToUnload.indexOf(_loc1_.id) == -1)
            {
               this.unloadModule(_loc1_.id);
            }
         }
         _loc2_ = 0;
         while(_loc2_ < _lastModulesToUnload.length)
         {
            if(this._modules[_lastModulesToUnload[_loc2_]])
            {
               this.unloadModule(_lastModulesToUnload[_loc2_]);
            }
            _loc2_++;
         }
         Shortcut.reset();
         Berilia.getInstance().reset();
         ApiBinder.reset();
         KernelEventsManager.getInstance().initialize();
         this._modules = [];
         this._uiFileToLoad = 0;
         this._scriptNum = 0;
         this._moduleCount = 0;
         this._parserAvaibleCount = 2;
         this._modulesPaths = new Dictionary();
      }
      
      public function getModulePath(param1:String) : String
      {
         return this._modulesPaths[param1];
      }
      
      public function loadModule(param1:String) : void
      {
         var _loc2_:File = null;
         var _loc3_:Uri = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         this.unloadModule(param1);
         var _loc7_:File;
         if((_loc7_ = this._modulesRoot.resolvePath(param1)).exists)
         {
            _loc2_ = this.searchDmFile(_loc7_);
            if(_loc2_)
            {
               ++this._moduleCount;
               ++this._scriptNum;
               if(_loc2_.nativePath.indexOf("app:/") == 0)
               {
                  _loc5_ = "app:/".length;
                  _loc6_ = _loc2_.nativePath.substring(_loc5_,_loc2_.url.length);
                  _loc3_ = new Uri(_loc6_);
                  _loc4_ = _loc6_.substr(0,_loc6_.lastIndexOf("/"));
               }
               else
               {
                  _loc3_ = new Uri(_loc2_.nativePath);
                  _loc4_ = _loc2_.parent.nativePath;
               }
               _loc3_.tag = _loc2_;
               this._modulesPaths[param1] = _loc4_;
               this._loader.load(_loc3_);
            }
            else
            {
               _log.error("Cannot found .dm or .d2ui file in " + _loc7_.url);
            }
         }
      }
      
      public function unloadModule(param1:String) : void
      {
         var api:Object = null;
         var uiCtr:UiRootContainer = null;
         var ui:String = null;
         var group:UiGroup = null;
         var variables:Array = null;
         var varName:String = null;
         var apiList:Vector.<Object> = null;
         api = null;
         var id:String = param1;
         if(this._modules == null)
         {
            return;
         }
         var m:UiModule = this._modules[id];
         if(!m)
         {
            return;
         }
         var moduleUiInstances:Array = [];
         for each(uiCtr in Berilia.getInstance().uiList)
         {
            if(uiCtr.uiModule == m)
            {
               moduleUiInstances.push(uiCtr.name);
            }
         }
         for each(ui in moduleUiInstances)
         {
            Berilia.getInstance().unloadUi(ui);
         }
         for each(group in m.groups)
         {
            UiGroupManager.getInstance().removeGroup(group.name);
         }
         variables = DescribeTypeCache.getVariables(m.mainClass,true);
         for each(varName in variables)
         {
            if(m.mainClass[varName] is Object)
            {
               m.mainClass[varName] = null;
            }
         }
         m.destroy();
         apiList = m.apiList;
         while(apiList.length)
         {
            api = apiList.shift();
            if(api && api.hasOwnProperty("destroy"))
            {
               try
               {
                  api["destroy"]();
               }
               catch(e:UntrustedApiCallError)
               {
                  api["destroy"](SecureCenter.ACCESS_KEY);
               }
            }
         }
         if(m.mainClass && m.mainClass.hasOwnProperty("unload"))
         {
            m.mainClass["unload"]();
         }
         BindsManager.getInstance().removeAllEventListeners("__module_" + m.id);
         KernelEventsManager.getInstance().removeAllEventListeners("__module_" + m.id);
         delete this._modules[id];
         this._disabledModules[id] = m;
      }
      
      public function checkSharedDefinitionHash(param1:String) : void
      {
         var _loc2_:Uri = new Uri(param1);
      }
      
      private function onTimeOut() : void
      {
         _log.error("SharedDefinition load Timeout");
         this.switchToNoHttpMode();
         EnterFrameDispatcher.removeEventListener(this.timeOutFrameCount);
      }
      
      private function timeOutFrameCount(param1:Event) : void
      {
         --this._timeOutFrameNumber;
         if(this._timeOutFrameNumber <= 0)
         {
            this.onTimeOut();
         }
      }
      
      private function launchModule() : void
      {
         var _loc1_:UiModule = null;
         var _loc2_:String = null;
         var _loc3_:UiModule = null;
         var _loc4_:Array = null;
         var _loc5_:UiModule = null;
         var _loc6_:uint = 0;
         this._moduleLaunchWaitForSharedDefinition = false;
         var _loc7_:Array = new Array();
         for each(_loc1_ in this._unInitializedModules)
         {
            if(_loc1_.trusted)
            {
               _loc7_.unshift(_loc1_);
            }
            else
            {
               _loc7_.push(_loc1_);
            }
         }
         while(_loc7_.length > 0)
         {
            _loc4_ = new Array();
            for each(_loc5_ in _loc7_)
            {
               ApiBinder.addApiData("currentUi",null);
               _loc2_ = ApiBinder.initApi(_loc5_.mainClass,_loc5_,this._sharedDefinition);
               if(_loc2_)
               {
                  _loc3_ = _loc5_;
                  _loc4_.push(_loc5_);
               }
               else if(_loc5_.mainClass)
               {
                  delete this._unInitializedModules[_loc5_.id];
                  _loc6_ = getTimer();
                  ErrorManager.tryFunction(_loc5_.mainClass.main,null,"Une erreur est survenue lors de l\'appel à la fonction main() du module " + _loc5_.id);
               }
               else
               {
                  _log.error("Impossible d\'instancier la classe principale du module " + _loc5_.id);
               }
            }
            if(_loc4_.length == _loc7_.length)
            {
               ErrorManager.addError("Le module " + _loc3_.id + " demande une référence vers un module inexistant : " + _loc2_);
            }
            _loc7_ = _loc4_;
         }
         Berilia.getInstance().handler.process(new AllModulesLoadedMessage());
      }
      
      private function launchUiCheck() : void
      {
         this._uiFileToLoad = this._uiFiles.length;
         if(this._uiFiles.length)
         {
            this._uiLoader.load(this._uiFiles,null,TxtAdapter);
         }
         else
         {
            this.onAllUiChecked(null);
         }
      }
      
      private function processCachedFiles(param1:Array) : void
      {
         var _loc2_:Uri = null;
         var _loc3_:Uri = null;
         var _loc4_:ICache = null;
         for each(_loc3_ in param1)
         {
            switch(_loc3_.fileType.toLowerCase())
            {
               case "css":
                  CssManager.getInstance().load(_loc3_.uri);
                  continue;
               case "jpg":
               case "png":
                  _loc2_ = new Uri(FileUtils.getFilePath(_loc3_.normalizedUri));
                  if(!(_loc4_ = UriCacheFactory.getCacheFromUri(_loc2_)))
                  {
                     _loc4_ = UriCacheFactory.init(_loc2_.uri,new Cache(param1.length,new LruGarbageCollector()));
                  }
                  this._cacheLoader.load(_loc3_,_loc4_);
                  continue;
               default:
                  ErrorManager.addError("Impossible de mettre en cache le fichier " + _loc3_.uri + ", le type n\'est pas supporté (uniquement css, jpg et png)");
                  continue;
            }
         }
      }
      
      private function onLoadError(param1:ResourceErrorEvent) : void
      {
         _log.error("onLoadError() - " + param1.errorMsg);
         var _loc2_:Uri = new Uri(HttpServer.getInstance().getUrlTo("SharedDefinitions.swf"));
         if(param1.uri == _loc2_)
         {
            this.switchToNoHttpMode();
         }
         else
         {
            if(param1.uri.fileType != "metas")
            {
               Berilia.getInstance().handler.process(new ModuleRessourceLoadFailedMessage(param1.uri.tag,param1.uri));
            }
            switch(param1.uri.fileType.toLowerCase())
            {
               case "swfs":
                  ErrorManager.addError("Impossible de charger le fichier " + param1.uri + " (" + param1.errorMsg + ")");
                  if(!--this._scriptNum)
                  {
                     this.launchUiCheck();
                  }
                  break;
               case "metas":
                  break;
               default:
                  ErrorManager.addError("Impossible de charger le fichier " + param1.uri + " (" + param1.errorMsg + ")");
            }
         }
      }
      
      private function switchToNoHttpMode() : void
      {
         this._useHttpServer = false;
         _log.fatal("Failed Loading SharedDefinitions, Going no HttpServer Style !");
         this._sharedDefinitionLoader.cancel();
         var _loc1_:Uri = new Uri("SharedDefinitions.swf");
         _loc1_.loaderContext = new LoaderContext(false,new ApplicationDomain());
         this.sharedDefinitionContainer = _loc1_;
      }
      
      private function onUiLoadError(param1:ResourceErrorEvent) : void
      {
         ErrorManager.addError("Impossible de charger le fichier d\'interface " + param1.uri + " (" + param1.errorMsg + ")");
         Berilia.getInstance().handler.process(new ModuleRessourceLoadFailedMessage(param1.uri.tag,param1.uri));
         --this._uiFileToLoad;
      }
      
      private function onLoad(param1:ResourceLoadedEvent) : void
      {
         if(this._resetState)
         {
            return;
         }
         switch(param1.uri.fileType.toLowerCase())
         {
            case "swf":
            case "swfs":
               this.onScriptLoad(param1);
               break;
            case "d2ui":
            case "dm":
               this.onDMLoad(param1);
               break;
            case "xml":
               this.onShortcutLoad(param1);
               break;
            case "metas":
               this.onHashLoaded(param1);
         }
      }
      
      private function onDMLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:UiModule = null;
         var _loc3_:Uri = null;
         var _loc4_:File = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Uri = null;
         var _loc8_:File = null;
         var _loc9_:FileStream = null;
         var _loc10_:ByteArray = null;
         var _loc11_:ByteArray = null;
         var _loc12_:Signature = null;
         var _loc13_:Uri = null;
         var _loc14_:String = null;
         var _loc15_:UiData = null;
         var _loc16_:Array = null;
         var _loc17_:File = null;
         if(param1.resourceType == ResourceType.RESOURCE_XML)
         {
            _loc2_ = UiModule.createFromXml(param1.resource as XML,FileUtils.getFilePath(param1.uri.path),File(param1.uri.tag).parent.name);
         }
         else
         {
            _loc2_ = PreCompiledUiModule.fromRaw(param1.resource,FileUtils.getFilePath(param1.uri.path),File(param1.uri.tag).parent.name);
         }
         this._unInitializedModules[_loc2_.id] = _loc2_;
         if(_loc2_.script)
         {
            _loc6_ = unescape(_loc2_.script);
            _loc7_ = new Uri(_loc6_);
            if(Berilia.getInstance().checkModuleAuthority)
            {
               _loc8_ = _loc7_.toFile();
               _log.debug("hash " + _loc7_);
               if(!_loc8_.exists)
               {
                  ErrorManager.addError("Le script du module " + _loc2_.id + " est introuvable (url: " + _loc8_.nativePath + ")");
                  --this._moduleCount;
                  --this._scriptNum;
                  _loc2_.trusted = false;
                  return;
               }
               (_loc9_ = new FileStream()).open(_loc8_,FileMode.READ);
               _loc10_ = new ByteArray();
               _loc9_.readBytes(_loc10_);
               _loc9_.close();
               if(_loc7_.fileType == "swf")
               {
                  _loc2_.trusted = MD5.hashBytes(_loc10_) == this._modulesHashs[_loc7_.fileName];
                  if(!_loc2_.trusted)
                  {
                     _log.error("Hash incorrect pour le module " + _loc2_.id);
                  }
               }
               else if(_loc7_.fileType == "swfs")
               {
                  _loc11_ = new ByteArray();
                  if(!(_loc12_ = new Signature(SignedFileAdapter.defaultSignatureKey)).verify(_loc10_,_loc11_))
                  {
                     _log.fatal("Invalid signature in " + _loc8_.nativePath);
                     --this._moduleCount;
                     --this._scriptNum;
                     _loc2_.trusted = false;
                     return;
                  }
                  _loc2_.trusted = true;
               }
            }
            else
            {
               _loc2_.trusted = true;
            }
            if(!_loc2_.enable)
            {
               _log.fatal("Le module " + _loc2_.id + " est désactivé");
               --this._moduleCount;
               --this._scriptNum;
               this._disabledModules[_loc2_.id] = _loc2_;
               return;
            }
            if(_loc2_.shortcuts)
            {
               (_loc13_ = new Uri(_loc2_.shortcuts)).tag = _loc2_.id;
               this._loader.load(_loc13_);
            }
            if(this._useHttpServer && _loc7_.fileType != "swfs")
            {
               _loc14_ = File.applicationDirectory.nativePath.split("\\").join("/");
               if(_loc6_.indexOf(_loc14_) != -1)
               {
                  _loc6_ = _loc6_.substr(_loc6_.indexOf(_loc14_) + _loc14_.length);
               }
               _loc6_ = HttpServer.getInstance().getUrlTo(_loc6_);
               _log.trace("[WebServer] Load " + _loc6_);
               this._loadModuleFunction(_loc6_,this.onModuleScriptLoaded,this.onScriptLoadFail,_loc2_);
            }
            else
            {
               if(!_loc2_.trusted)
               {
                  --this._moduleCount;
                  --this._scriptNum;
                  ErrorManager.addError("Failed to load custom module " + _loc2_.author + "_" + _loc2_.name + ", because the local HTTP server is not available.");
                  return;
               }
               _loc7_.tag = _loc2_.id;
               _loc7_.loaderContext = new LoaderContext();
               _loc7_.loaderContext.applicationDomain = new ApplicationDomain(this._sharedDefinition);
               this._loadingModule[_loc2_] = _loc2_.id;
               _log.trace("[Classic] Load " + _loc7_);
               this._loader.load(_loc7_,null,_loc7_.fileType != "swfs"?BinaryAdapter:AdvancedSignedFileAdapter);
            }
         }
         var _loc18_:Array = new Array();
         if(!(_loc2_ is PreCompiledUiModule))
         {
            for each(_loc15_ in _loc2_.uis)
            {
               if(_loc15_.file)
               {
                  _loc3_ = new Uri(_loc15_.file);
                  _loc3_.tag = {
                     "mod":_loc2_.id,
                     "base":_loc15_.file
                  };
                  this._uiFiles.push(_loc3_);
               }
            }
         }
         var _loc19_:File = this._modulesRoot.resolvePath(_loc2_.id);
         _loc18_ = new Array();
         for each(_loc5_ in _loc2_.cachedFiles)
         {
            if((_loc4_ = _loc19_.resolvePath(_loc5_)).exists)
            {
               if(!_loc4_.isDirectory)
               {
                  _loc18_.push(new Uri("mod://" + _loc2_.id + "/" + _loc5_));
               }
               else
               {
                  _loc16_ = _loc4_.getDirectoryListing();
                  for each(_loc17_ in _loc16_)
                  {
                     if(!_loc17_.isDirectory)
                     {
                     }
                     _loc18_.push(new Uri("mod://" + _loc2_.id + "/" + _loc5_ + "/" + FileUtils.getFileName(_loc17_.url)));
                  }
               }
            }
         }
         this.processCachedFiles(_loc18_);
      }
      
      private function onScriptLoadFail(param1:IOErrorEvent, param2:UiModule) : void
      {
         _log.error("Le script du module " + param2.id + " est introuvable");
         if(!--this._scriptNum)
         {
            this.launchUiCheck();
         }
      }
      
      private function onScriptLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:UiModule = this._unInitializedModules[param1.uri.tag];
         var _loc3_:Loader = new Loader();
         this._moduleScriptLoadedRef[_loc3_] = _loc2_;
         var _loc4_:LoaderContext = new LoaderContext(false,new ApplicationDomain(this._sharedDefinition));
         AirScanner.allowByteCodeExecution(_loc4_,true);
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onModuleScriptLoaded);
         _loc3_.loadBytes(param1.resource as ByteArray,_loc4_);
      }
      
      private function onModuleScriptLoaded(param1:Event, param2:UiModule = null) : void
      {
         var _loc3_:Loader = LoaderInfo(param1.target).loader;
         _loc3_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onModuleScriptLoaded);
         if(!param2)
         {
            param2 = this._moduleScriptLoadedRef[_loc3_];
         }
         delete this._loadingModule[param2];
         _log.trace("Load script " + param2.id + ", " + (this._moduleCount - this._scriptNum + 1) + "/" + this._moduleCount);
         param2.loader = _loc3_;
         param2.applicationDomain = _loc3_.contentLoaderInfo.applicationDomain;
         param2.mainClass = _loc3_.content;
         this._modules[param2.id] = param2;
         delete this._disabledModules[param2.id];
         Berilia.getInstance().handler.process(new ModuleLoadedMessage(param2.id));
         if(!--this._scriptNum)
         {
            this.launchUiCheck();
         }
      }
      
      private function onShortcutLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:XML = null;
         var _loc3_:ShortcutCategory = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc8_:XML = null;
         var _loc9_:XML = param1.resource;
         for each(_loc2_ in _loc9_..category)
         {
            _loc3_ = ShortcutCategory.create(_loc2_.@name,LangManager.getInstance().replaceKey(_loc2_.@description));
            for each(_loc8_ in _loc2_..shortcut)
            {
               if(!_loc8_.@name || !_loc8_.@name.toString().length)
               {
                  ErrorManager.addError("Le fichier de raccourci est mal formé, il manque la priopriété name dans le fichier " + param1.uri);
                  return;
               }
               _loc4_ = false;
               if(_loc8_.@permanent && _loc8_.@permanent == "true")
               {
                  _loc4_ = true;
               }
               _loc5_ = true;
               if(_loc8_.@visible && _loc8_.@visible == "false")
               {
                  _loc5_ = false;
               }
               _loc6_ = false;
               if(_loc8_.@required && _loc8_.@required == "true")
               {
                  _loc6_ = true;
               }
               _loc7_ = false;
               if(_loc8_.@holdKeys && _loc8_.@holdKeys == "true")
               {
                  _loc7_ = true;
               }
               new Shortcut(_loc8_.@name,_loc8_.@textfieldEnabled == "true",LangManager.getInstance().replaceKey(_loc8_.toString()),_loc3_,!_loc4_,_loc5_,_loc6_,_loc7_,LangManager.getInstance().replaceKey(_loc8_.@tooltipContent));
            }
         }
      }
      
      private function onHashLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:XML = null;
         for each(_loc2_ in param1.resource..file)
         {
            this._modulesHashs[_loc2_.@name.toString()] = _loc2_.toString();
         }
      }
      
      private function onAllUiChecked(param1:ResourceLoaderProgressEvent) : void
      {
         var _loc2_:UiModule = null;
         var _loc3_:* = null;
         var _loc4_:UiData = null;
         var _loc5_:Array = new Array();
         for each(_loc2_ in this._unInitializedModules)
         {
            for each(_loc4_ in _loc2_.uis)
            {
               _loc5_[UiData(_loc4_).file] = _loc4_;
            }
         }
         this._unparsedXml = [];
         for(_loc3_ in this._clearUi)
         {
            UiRenderManager.getInstance().clearCacheFromId(_loc3_);
            UiRenderManager.getInstance().setUiVersion(_loc3_,this._clearUi[_loc3_]);
            if(_loc5_[_loc3_])
            {
               this._unparsedXml.push(_loc5_[_loc3_]);
            }
         }
         this._unparsedXmlCount = this._unparsedXmlTotalCount = this._unparsedXml.length;
         this.parseNextXml();
      }
      
      private function parseNextXml() : void
      {
         var _loc1_:UiData = null;
         var _loc2_:XmlParsor = null;
         this._unparsedXmlCount = this._unparsedXml.length;
         if(this._unparsedXml.length)
         {
            if(this._parserAvaibleCount)
            {
               --this._parserAvaibleCount;
               _loc1_ = this._unparsedXml.shift() as UiData;
               _loc2_ = new XmlParsor();
               _loc2_.rootPath = _loc1_.module.rootPath;
               _loc2_.addEventListener(Event.COMPLETE,this.onXmlParsed,false,0,true);
               _loc2_.addEventListener(ParsingErrorEvent.ERROR,this.onXmlParsingError);
               _loc2_.processFile(_loc1_.file);
            }
         }
         else
         {
            BindsManager.getInstance().checkBinds();
            Berilia.getInstance().handler.process(new AllUiXmlParsedMessage());
            if(!this._useSharedDefinition || this._sharedDefinition)
            {
               this.launchModule();
            }
            else
            {
               this._moduleLaunchWaitForSharedDefinition = true;
            }
         }
      }
      
      private function onXmlParsed(param1:ParsorEvent) : void
      {
         if(param1.uiDefinition)
         {
            param1.uiDefinition.name = XmlParsor(param1.target).url;
            UiRenderManager.getInstance().setUiDefinition(param1.uiDefinition);
            Berilia.getInstance().handler.process(new UiXmlParsedMessage(param1.uiDefinition.name));
         }
         ++this._parserAvaibleCount;
         this.parseNextXml();
      }
      
      private function onXmlParsingError(param1:ParsingErrorEvent) : void
      {
         Berilia.getInstance().handler.process(new UiXmlParsedErrorMessage(param1.url,param1.msg));
      }
      
      private function onUiLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc9_:* = undefined;
         var _loc10_:String = null;
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Uri = null;
         if(this._resetState)
         {
            return;
         }
         var _loc6_:int = this._uiFiles.indexOf(param1.uri);
         this._uiFiles.splice(this._uiFiles.indexOf(param1.uri),1);
         var _loc7_:UiModule = this._unInitializedModules[param1.uri.tag.mod];
         var _loc8_:String = param1.uri.tag.base;
         if(!(_loc9_ = (_loc10_ = this._versions[param1.uri.uri] != null?this._versions[param1.uri.uri]:MD5.hash(param1.resource as String)) == UiRenderManager.getInstance().getUiVersion(param1.uri.uri)))
         {
            this._clearUi[param1.uri.uri] = _loc10_;
            if(param1.uri.tag.template)
            {
               this._clearUi[param1.uri.tag.base] = this._versions[param1.uri.tag.base];
            }
         }
         this._versions[param1.uri.uri] = _loc10_;
         var _loc11_:String = param1.resource as String;
         while(_loc2_ = this._regImport.exec(_loc11_))
         {
            if((_loc3_ = LangManager.getInstance().replaceKey(_loc2_[1])).indexOf("mod://") != -1)
            {
               _loc4_ = _loc3_.substr(6,_loc3_.indexOf("/",6) - 6);
               _loc3_ = this._modulesPaths[_loc4_] + _loc3_.substr(6 + _loc4_.length);
            }
            else if(_loc3_.indexOf(":") == -1 && _loc3_.indexOf("ui/Ankama_Common") == -1)
            {
               _loc3_ = _loc7_.rootPath + _loc3_;
            }
            if(this._clearUi[_loc3_])
            {
               this._clearUi[param1.uri.uri] = _loc10_;
               this._clearUi[_loc8_] = this._versions[_loc8_];
            }
            else if(!this._uiLoaded[_loc3_])
            {
               this._uiLoaded[_loc3_] = true;
               ++this._uiFileToLoad;
               (_loc5_ = new Uri(_loc3_)).tag = {
                  "mod":_loc7_.id,
                  "base":_loc8_,
                  "template":true
               };
               this._uiLoader.load(_loc5_,null,TxtAdapter);
            }
         }
         if(!--this._uiFileToLoad)
         {
            this.onAllUiChecked(null);
         }
      }
      
      private function searchDmFile(param1:File) : File
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
            if(!_loc2_.isDirectory && _loc2_.extension)
            {
               if(_loc2_.extension.toLowerCase() == "d2ui")
               {
                  return _loc2_;
               }
               if(!_loc3_ && _loc2_.extension.toLowerCase() == "dm")
               {
                  _loc3_ = _loc2_;
               }
            }
         }
         if(_loc3_)
         {
            return _loc3_;
         }
         for each(_loc2_ in _loc4_)
         {
            if(_loc2_.isDirectory)
            {
               if(_loc3_ = this.searchDmFile(_loc2_))
               {
                  break;
               }
            }
         }
         return _loc3_;
      }
      
      private function onSharedDefinitionLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         EnterFrameDispatcher.removeEventListener(this.timeOutFrameCount);
         var _loc2_:ASwf = param1.resource as ASwf;
         this._sharedDefinition = _loc2_.applicationDomain;
         var _loc3_:Object = this._sharedDefinition.getDefinition("d2components::SecureComponent");
         _loc3_.init(SecureCenter.ACCESS_KEY,SecureCenter.unsecureContent,SecureCenter.secure,SecureCenter.unsecure,DescribeTypeCache.getVariables);
         (_loc4_ = this._sharedDefinition.getDefinition("utils::ReadOnlyData")).init(SecureCenter.ACCESS_KEY,SecureCenter.unsecureContent,SecureCenter.secure,SecureCenter.unsecure);
         (_loc5_ = this._sharedDefinition.getDefinition("utils::DirectAccessObject")).init(SecureCenter.ACCESS_KEY);
         SecureCenter.init(_loc3_,_loc4_,_loc5_);
         this._sharedDefinitionInstance = Object(_loc2_.content);
         this._loadModuleFunction = Object(_loc2_.content).loadModule;
         if(this._waitingInit)
         {
            this.init(this._filter,this._filterInclude);
         }
         if(this._moduleLaunchWaitForSharedDefinition)
         {
            this.launchModule();
         }
      }
   }
}
