package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.BeriliaConstants;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.enums.ShortcutsEnum;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.listener.GenericListener;
   import com.ankamagames.berilia.types.shortcut.Bind;
   import com.ankamagames.berilia.types.shortcut.LocalizedKeyboard;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.jerakine.handlers.FocusHandler;
   import com.ankamagames.jerakine.logger.ModuleLogger;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.filesystem.File;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public class BindsManager extends GenericEventsManager
   {
      
      private static var _self:BindsManager;
       
      
      private var _aRegisterKey:Array;
      
      private var _loader:IResourceLoader;
      
      private var _loaderKeyboard:IResourceLoader;
      
      private var _availableKeyboards:Array;
      
      private var _waitingBinds:Array;
      
      private var _bindsToCheck:Array;
      
      private var _shortcutsLoaded:Boolean;
      
      private var _bindsLoaded:Boolean;
      
      public function BindsManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("ShortcutsManager constructor should not be called directly.");
         }
         _self = this;
         this._aRegisterKey = new Array();
         this._availableKeyboards = new Array();
      }
      
      public static function getInstance() : BindsManager
      {
         if(_self == null)
         {
            _self = new BindsManager();
         }
         return _self;
      }
      
      public static function destroy() : void
      {
         if(_self != null)
         {
            _self = null;
         }
      }
      
      public function get availableKeyboards() : Array
      {
         return this._availableKeyboards;
      }
      
      public function get currentLocale() : String
      {
         return StoreDataManager.getInstance().getData(BeriliaConstants.DATASTORE_BINDS,"locale");
      }
      
      override public function initialize() : void
      {
         var _loc1_:File = null;
         var _loc2_:Bind = null;
         super.initialize();
         this._shortcutsLoaded = false;
         this._bindsLoaded = false;
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.objectLoaded);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.objectLoadedFailed);
         this._loaderKeyboard = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loaderKeyboard.addEventListener(ResourceLoadedEvent.LOADED,this.keyboardFileLoaded);
         this._loaderKeyboard.addEventListener(ResourceLoaderProgressEvent.LOADER_COMPLETE,this.keyboardFileAllLoaded);
         this._loaderKeyboard.addEventListener(ResourceErrorEvent.ERROR,this.objectLoadedFailed);
         StoreDataManager.getInstance().registerClass(new Bind());
         this._waitingBinds = new Array();
         this._aRegisterKey = StoreDataManager.getInstance().getSetData(BeriliaConstants.DATASTORE_BINDS,"registeredKeys",new Array());
         if(this._aRegisterKey && !(this._aRegisterKey[0] is Bind))
         {
            this._aRegisterKey = new Array();
         }
         this.fillShortcutsEnum();
         var _loc3_:String = LangManager.getInstance().getEntry("config.binds.path.root").split("file://")[1];
         if(!_loc3_)
         {
            _loc3_ = LangManager.getInstance().getEntry("config.binds.path.root");
         }
         var _loc4_:File;
         (_loc4_ = new File(File.applicationDirectory.nativePath + File.separator + _loc3_)).createDirectory();
         var _loc5_:Array = _loc4_.getDirectoryListing();
         var _loc6_:Array = new Array();
         for each(_loc1_ in _loc5_)
         {
            if(!_loc1_.isDirectory && _loc1_.extension == "xml")
            {
               _loc6_.push(new Uri(_loc1_.nativePath));
            }
         }
         this._loaderKeyboard.load(_loc6_);
         if(this._aRegisterKey.length == 0)
         {
            _loc2_ = new Bind("ALL","ALL",true,true,true);
            this._aRegisterKey.push(_loc2_);
         }
      }
      
      public function get binds() : Array
      {
         return this._aRegisterKey;
      }
      
      public function getShortcutString(param1:uint, param2:uint) : String
      {
         if(ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[param1] != null)
         {
            return ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[param1];
         }
         if(param2 == 0)
         {
            return null;
         }
         return String.fromCharCode(param2);
      }
      
      public function getBind(param1:Bind, param2:Boolean = false) : Bind
      {
         var _loc3_:Bind = null;
         if(this._aRegisterKey == null)
         {
            return null;
         }
         var _loc4_:int = -1;
         var _loc5_:int = this._aRegisterKey.length;
         while(++_loc4_ < _loc5_)
         {
            _loc3_ = this._aRegisterKey[_loc4_] as Bind;
            if(_loc3_ && _loc3_.equals(param1) && (param2 || !_loc3_.disabled))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function isRegister(param1:Bind) : Boolean
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._aRegisterKey.length)
         {
            if(this._aRegisterKey[_loc2_] && this._aRegisterKey[_loc2_].equals(param1))
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function isPermanent(param1:Bind) : Boolean
      {
         var _loc2_:Shortcut = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this._aRegisterKey.length)
         {
            if(this._aRegisterKey[_loc3_] && this._aRegisterKey[_loc3_].equals(param1))
            {
               _loc2_ = Shortcut.getShortcutByName(this._aRegisterKey[_loc3_].targetedShortcut);
               if(_loc2_ != null && !_loc2_.bindable)
               {
                  return true;
               }
            }
            _loc3_++;
         }
         return false;
      }
      
      public function isDisabled(param1:Bind) : Boolean
      {
         var _loc2_:Bind = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this._aRegisterKey.length)
         {
            if(this._aRegisterKey[_loc3_] && this._aRegisterKey[_loc3_].equals(param1))
            {
               _loc2_ = this._aRegisterKey[_loc3_] as Bind;
               return _loc2_.disabled;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function setDisabled(param1:Bind, param2:Boolean) : void
      {
         var _loc3_:Bind = null;
         var _loc4_:uint = 0;
         while(_loc4_ < this._aRegisterKey.length)
         {
            if(this._aRegisterKey[_loc4_] && this._aRegisterKey[_loc4_].equals(param1))
            {
               _loc3_ = this._aRegisterKey[_loc4_] as Bind;
               _loc3_.disabled = param2;
               return;
            }
            _loc4_++;
         }
      }
      
      public function isRegisteredName(param1:String) : Boolean
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._aRegisterKey.length)
         {
            if(this._aRegisterKey[_loc2_] && this._aRegisterKey[_loc2_].targetedShortcut == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function canBind(param1:Bind) : Boolean
      {
         var _loc2_:uint = 0;
         while(_loc2_ < ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.length)
         {
            if(ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN[_loc2_].equals(param1))
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      public function removeBind(param1:Bind) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         while(_loc3_ < this._aRegisterKey.length)
         {
            if(this._aRegisterKey[_loc3_] && this._aRegisterKey[_loc3_].equals(param1))
            {
               _loc2_ = Bind(this._aRegisterKey[_loc3_]).targetedShortcut;
               Bind(this._aRegisterKey[_loc3_]).reset();
               StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_BINDS,"registeredKeys",this._aRegisterKey,true);
               KernelEventsManager.getInstance().processCallback(BeriliaHookList.ShortcutUpdate,_loc2_,null);
               return;
            }
            _loc3_++;
         }
      }
      
      public function addBind(param1:Bind) : void
      {
         var _loc2_:uint = 0;
         if(!this.canBind(param1))
         {
            _log.warn(param1.toString() + " cannot be bind.");
            return;
         }
         this.removeBind(param1);
         while(_loc2_ < this._aRegisterKey.length)
         {
            if(this._aRegisterKey[_loc2_] && Bind(this._aRegisterKey[_loc2_]).targetedShortcut == param1.targetedShortcut)
            {
               this._aRegisterKey.splice(_loc2_,1,param1);
               StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_BINDS,"registeredKeys",this._aRegisterKey,true);
               KernelEventsManager.getInstance().processCallback(BeriliaHookList.ShortcutUpdate,param1.targetedShortcut,param1);
               return;
            }
            _loc2_++;
         }
         this._aRegisterKey.push(param1);
         StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_BINDS,"registeredKeys",this._aRegisterKey,true);
         KernelEventsManager.getInstance().processCallback(BeriliaHookList.ShortcutUpdate,param1.targetedShortcut,param1);
      }
      
      public function isRegisteredShortcut(param1:Bind, param2:Boolean = false) : Boolean
      {
         return _aEvent[param1.targetedShortcut] != null || !param2 && _aEvent["ALL"];
      }
      
      public function getBindFromShortcut(param1:String, param2:Boolean = false) : Bind
      {
         var _loc3_:Bind = null;
         for each(_loc3_ in this._aRegisterKey)
         {
            if(_loc3_ && _loc3_.targetedShortcut == param1 && (param2 || !_loc3_.disabled))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function processCallback(param1:*, ... rest) : void
      {
         var _loc3_:GenericListener = null;
         var _loc4_:Array = null;
         var _loc5_:TextField = null;
         var _loc6_:UiRootContainer = null;
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
         var _loc9_:UiRootContainer = null;
         var _loc10_:* = undefined;
         var _loc11_:Bind = Bind(param1);
         if(!this.isRegisteredShortcut(_loc11_))
         {
            return;
         }
         var _loc12_:* = true;
         if(_aEvent[_loc11_.targetedShortcut])
         {
            (_loc4_ = _aEvent[_loc11_.targetedShortcut].concat(_aEvent["ALL"])).sortOn("sortIndex",Array.DESCENDING | Array.NUMERIC);
            if((_loc5_ = FocusHandler.getInstance().getFocus() as TextField) && _loc5_.parent is Input && Input(_loc5_.parent).focusEventHandlerPriority)
            {
               _loc6_ = Input(_loc5_.parent).getUi();
               _loc7_ = false;
               _loc8_ = 0;
               while(_loc8_ < _loc4_.length)
               {
                  _loc3_ = _loc4_[_loc8_];
                  if(_loc3_ && _loc3_.listenerType == GenericListener.LISTENER_TYPE_UI && _loc3_.listenerContext && _loc3_.listenerContext.object)
                  {
                     if(_loc9_ = UiRootContainer(_loc3_.listenerContext.object))
                     {
                        if(_loc9_.modal)
                        {
                           _loc7_ = true;
                        }
                        if(_loc6_ == _loc9_ && !_loc7_ || _loc9_.modal == true)
                        {
                           (_loc4_ = _loc4_.splice(_loc8_,1)).unshift(_loc3_);
                        }
                     }
                  }
                  _loc8_++;
               }
            }
            for each(_loc3_ in _loc4_)
            {
               if(!_loc12_)
               {
                  break;
               }
               if(_loc3_ && _loc3_.callback != null)
               {
                  if(Berilia.getInstance().getUi(_loc3_.listener) && Berilia.getInstance().getUi(_loc3_.listener).depth < Berilia.getInstance().highestModalDepth)
                  {
                     return;
                  }
                  _log.info("Dispatch " + rest + " to " + _loc3_.listener);
                  ModuleLogger.log(_loc11_,_loc3_.listener);
                  if((_loc10_ = _loc3_.callback.apply(null,rest)) === null || !(_loc10_ is Boolean))
                  {
                     throw new ApiError(_loc3_.callback + " does not return a Boolean value");
                  }
                  _loc12_ = !_loc10_;
               }
            }
         }
      }
      
      public function reset() : void
      {
         var _loc1_:Bind = null;
         var _loc2_:Shortcut = null;
         var _loc3_:Array = new Array();
         for each(_loc1_ in this._aRegisterKey)
         {
            if(_loc1_)
            {
               _loc3_[_loc1_.targetedShortcut] = _loc1_;
            }
         }
         for each(_loc2_ in Shortcut.getShortcuts())
         {
            if(_loc3_[_loc2_.name] == null || _loc3_[_loc2_.name].key == null || _loc2_.defaultBind != _loc3_[_loc2_.name])
            {
               if(_loc2_.defaultBind)
               {
                  this.addBind(_loc2_.defaultBind.copy());
               }
               else
               {
                  this.removeBind(_loc3_[_loc2_.name]);
               }
            }
         }
      }
      
      public function changeKeyboard(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:LocalizedKeyboard = null;
         for each(_loc3_ in this._availableKeyboards)
         {
            if(_loc3_.locale == param1)
            {
               StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_BINDS,"locale",param1);
               _loc3_.uri.tag = param2;
               this._loader.load(_loc3_.uri);
               break;
            }
         }
      }
      
      public function getRegisteredBind(param1:Bind) : Bind
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._aRegisterKey.length)
         {
            if(this._aRegisterKey[_loc2_] && this._aRegisterKey[_loc2_].equals(param1))
            {
               return this._aRegisterKey[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function newShortcut(param1:Shortcut) : void
      {
         var _loc2_:Bind = null;
         var _loc3_:Bind = null;
         var _loc4_:int = 0;
         while(_loc4_ < this._waitingBinds.length)
         {
            if(this._waitingBinds[_loc4_].targetedShortcut == param1.name)
            {
               _loc2_ = this._waitingBinds[_loc4_];
               break;
            }
            _loc4_++;
         }
         if(!_loc2_)
         {
            return;
         }
         this._waitingBinds.splice(_loc4_,1);
         if(!this.canBind(_loc2_))
         {
            _log.warn(_loc2_.toString() + " cannot be bind.");
            return;
         }
         param1.defaultBind = _loc2_.copy();
         if(this.isRegister(_loc2_))
         {
            return;
         }
         for each(_loc3_ in this._aRegisterKey)
         {
            if(_loc3_ && _loc3_.targetedShortcut == _loc2_.targetedShortcut)
            {
               return;
            }
         }
         this._aRegisterKey.push(_loc2_);
         StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_BINDS,"registeredKeys",this._aRegisterKey,true);
      }
      
      public function checkBinds() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Object = null;
         this._shortcutsLoaded = true;
         if(this._shortcutsLoaded && this._bindsLoaded && this._bindsToCheck && this._bindsToCheck.length > 0)
         {
            _loc1_ = false;
            for each(_loc2_ in this._bindsToCheck)
            {
               if(!Shortcut.getShortcutByName(_loc2_.bind.targetedShortcut))
               {
                  this._aRegisterKey.splice(_loc2_.index,1,null);
                  _loc1_ = true;
               }
            }
            if(_loc1_)
            {
               StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_BINDS,"registeredKeys",this._aRegisterKey,true);
            }
            this._bindsToCheck.length = 0;
         }
      }
      
      private function fillShortcutsEnum() : void
      {
         var _loc1_:String = null;
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("C","",false,true));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("V","",false,true));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(F4)","",true,false));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(del)","",true,true));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(tab)","",true));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(backspace)"));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(insert)"));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(del)"));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("(locknum)"));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("Z","",false,true));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("Y","",false,true));
         ShortcutsEnum.BASIC_SHORTCUT_FORBIDDEN.push(new Bind("Z","",false,true,true));
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.ESCAPE] = "(escape)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.ENTER] = "(enter)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.TAB] = "(tab)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.BACKSPACE] = "(backspace)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.UP] = "(upArrow)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.RIGHT] = "(rightArrow)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.DOWN] = "(downArrow)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.LEFT] = "(leftArrow)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.SPACE] = "(space)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.PAGE_UP] = "(pageUp)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.PAGE_DOWN] = "(pageDown)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.DELETE] = "(delete)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[144] = "(numLock)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.INSERT] = "(insert)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.END] = "(end)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.SHIFT] = "(shift)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F1] = "(F1)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F2] = "(F2)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F3] = "(F3)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F4] = "(F4)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F5] = "(F5)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F6] = "(F6)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F7] = "(F7)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F8] = "(F8)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F9] = "(F9)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F10] = "(F10)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F11] = "(F11)";
         ShortcutsEnum.BASIC_SHORTCUT_KEYCODE[Keyboard.F12] = "(F12)";
         for(ShortcutsEnum.BASIC_SHORTCUT_NAME[ShortcutsEnum.BASIC_SHORTCUT_KEYCODE] in ShortcutsEnum.BASIC_SHORTCUT_KEYCODE)
         {
         }
      }
      
      private function parseBindsXml(param1:String, param2:Boolean) : void
      {
         var _loc3_:Bind = null;
         var _loc4_:Shortcut = null;
         var _loc5_:Bind = null;
         var _loc6_:* = false;
         var _loc7_:Array = null;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:XML = null;
         var _loc10_:Object = null;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc13_:XML = XML(param1);
         var _loc14_:Array = new Array();
         for each(_loc5_ in this._aRegisterKey)
         {
            if(_loc5_)
            {
               _loc14_[_loc5_.targetedShortcut] = _loc5_;
            }
         }
         _loc6_ = this._aRegisterKey.length > 1;
         _loc7_ = new Array();
         if(_loc6_)
         {
            _loc11_ = 0;
            while(_loc11_ < this._aRegisterKey.length)
            {
               if(!this._aRegisterKey[_loc11_] || this._aRegisterKey[_loc11_].targetedShortcut == "ALL" && _loc11_ != this._aRegisterKey.length - 1)
               {
                  if(!_loc8_)
                  {
                     _loc8_ = new Vector.<uint>(0);
                  }
                  _loc8_.push(_loc11_);
               }
               _loc11_++;
            }
            _loc12_ = !!_loc8_?int(_loc8_.length):0;
            _loc11_ = 0;
            while(_loc11_ < _loc12_)
            {
               this._aRegisterKey.splice(_loc8_[_loc11_],1);
               _loc11_++;
            }
            _loc11_ = 0;
            while(_loc11_ < this._aRegisterKey.length)
            {
               if(this._aRegisterKey[_loc11_])
               {
                  _loc7_[this._aRegisterKey[_loc11_].targetedShortcut] = {
                     "exist":(!!Shortcut.getShortcutByName(this._aRegisterKey[_loc11_].targetedShortcut)?true:false),
                     "bind":this._aRegisterKey[_loc11_],
                     "index":_loc11_
                  };
               }
               _loc11_++;
            }
         }
         for each(_loc9_ in _loc13_..bind)
         {
            _loc4_ = Shortcut.getShortcutByName(_loc9_..@shortcut);
            _loc3_ = new Bind(_loc9_,_loc9_..@shortcut,_loc9_..@alt == true,_loc9_..@ctrl == true,_loc9_..@shift == true);
            if(_loc7_[_loc3_.targetedShortcut])
            {
               _loc7_[_loc3_.targetedShortcut].exist = true;
            }
            if(!_loc4_)
            {
               this._waitingBinds.push(_loc3_);
            }
            else if(!this.canBind(_loc3_))
            {
               _log.warn(_loc3_.toString() + " cannot be bind.");
            }
            else
            {
               _loc4_.defaultBind = _loc3_.copy();
               if(!this.isRegister(_loc3_))
               {
                  if(_loc14_[_loc3_.targetedShortcut])
                  {
                     if(param2)
                     {
                        this.addBind(_loc3_);
                     }
                  }
                  else if(!_loc6_)
                  {
                     this._aRegisterKey.push(_loc3_);
                  }
               }
            }
         }
         if(!this._shortcutsLoaded)
         {
            this._bindsToCheck = new Array();
         }
         for each(_loc10_ in _loc7_)
         {
            if(!_loc10_.exist || this._shortcutsLoaded && !Shortcut.getShortcutByName(_loc10_.bind.targetedShortcut))
            {
               if(!this._shortcutsLoaded)
               {
                  this._bindsToCheck.push(_loc10_);
               }
               else
               {
                  this._aRegisterKey.splice(_loc10_.index,1,null);
               }
            }
         }
         this._bindsLoaded = true;
         if(this._shortcutsLoaded)
         {
            StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_BINDS,"registeredKeys",this._aRegisterKey,true);
         }
      }
      
      public function objectLoaded(param1:ResourceLoadedEvent) : void
      {
         this.parseBindsXml(param1.resource,param1.uri.tag);
      }
      
      public function keyboardFileLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:XML = XML(param1.resource);
         this._availableKeyboards.push(new LocalizedKeyboard(param1.uri,_loc2_.@locale,_loc2_.@description));
      }
      
      public function keyboardFileAllLoaded(param1:ResourceLoaderProgressEvent) : void
      {
         var _loc2_:String = null;
         try
         {
            _loc2_ = StoreDataManager.getInstance().getSetData(BeriliaConstants.DATASTORE_BINDS,"locale",LangManager.getInstance().getEntry("config.binds.current"));
            this.changeKeyboard(_loc2_);
         }
         catch(e:Error)
         {
         }
      }
      
      public function objectLoadedFailed(param1:ResourceErrorEvent) : void
      {
         _log.debug("objectLoadedFailed : " + param1.uri + ", " + param1.errorMsg);
      }
   }
}
