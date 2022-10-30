package com.ankamagames.berilia.api
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.BeriliaConstants;
   import com.ankamagames.berilia.components.ComponentInternalAccessor;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.enums.EventEnums;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.interfaces.IRadioItem;
   import com.ankamagames.berilia.managers.BindsManager;
   import com.ankamagames.berilia.managers.CssManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UIEventManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.berilia.types.data.RadioGroup;
   import com.ankamagames.berilia.types.data.SlotDragAndDropData;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.berilia.types.data.TreeData;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.event.InstanceEvent;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.GraphicSize;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.types.listener.GenericListener;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.berilia.types.tooltip.Tooltip;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.handlers.FocusHandler;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.display.KeyPoll;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.memory.WeakReference;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.StageDisplayState;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class UiApi implements IApi
   {
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      public static const _log:Logger = Log.getLogger(getQualifiedClassName(UiApi));
      
      private static var _label:Label;
       
      
      private var _module:UiModule;
      
      private var _currentUi:UiRootContainer;
      
      private var oldTextureUri:String;
      
      private var oldTextureBounds:Rectangle;
      
      public function UiApi()
      {
         this.oldTextureBounds = new Rectangle();
         super();
         MEMORY_LOG[this] = 1;
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         if(!this._module)
         {
            this._module = param1;
         }
      }
      
      [ApiData(name="currentUi")]
      public function set currentUi(param1:UiRootContainer) : void
      {
         if(!this._currentUi)
         {
            this._currentUi = param1;
         }
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._currentUi = null;
         this._module = null;
      }
      
      [Untrusted]
      public function loadUi(param1:String, param2:String = null, param3:* = null, param4:uint = 1, param5:String = null, param6:Boolean = false) : Object
      {
         var _loc7_:Array = null;
         var _loc8_:UiRootContainer = null;
         var _loc9_:UiModule = this._module;
         var _loc10_:String = param1;
         if(!this._module.uis[param1])
         {
            if(param1.indexOf("::") == -1)
            {
               throw new BeriliaError(param1 + " not found in module " + this._module.name);
            }
            _loc7_ = param1.split("::");
            if(!(_loc9_ = UiModuleManager.getInstance().getModule(_loc7_[0])))
            {
               throw new BeriliaError("Module [" + _loc7_[0] + "] does not exist");
            }
            if(_loc9_.trusted && !this._module.trusted)
            {
               throw new ApiError("You cannot load trusted UI");
            }
            _loc10_ = _loc7_[1];
         }
         if(!param2)
         {
            param2 = _loc10_;
         }
         if(_loc9_.uis[_loc10_])
         {
            _loc8_ = Berilia.getInstance().loadUi(_loc9_,_loc9_.uis[_loc10_],param2,param3,param6,param4,false,param5);
            if(_loc10_ != "tips" && _loc10_ != "buffUi")
            {
               FocusHandler.getInstance().setFocus(_loc8_);
            }
            return SecureCenter.secure(_loc8_,_loc9_.trusted);
         }
         return null;
      }
      
      [Untrusted]
      public function loadUiInside(param1:String, param2:GraphicContainer, param3:String = null, param4:* = null) : Object
      {
         var _loc5_:Array = null;
         var _loc6_:UiRootContainer = null;
         var _loc7_:UiModule = this._module;
         var _loc8_:String = param1;
         if(!this._module.uis[param1])
         {
            if(param1.indexOf("::") == -1)
            {
               throw new BeriliaError(param1 + " not found in module " + this._module.name);
            }
            _loc5_ = param1.split("::");
            if(!(_loc7_ = UiModuleManager.getInstance().getModule(_loc5_[0])))
            {
               throw new BeriliaError("Module [" + _loc5_[0] + "] does not exist");
            }
            if(_loc7_.trusted && !this._module.trusted)
            {
               throw new ApiError("You cannot load trusted UI");
            }
            _loc8_ = _loc5_[1];
         }
         if(!param3)
         {
            param3 = _loc8_;
         }
         if(_loc7_.uis[_loc8_])
         {
            (_loc6_ = new UiRootContainer(StageShareManager.stage,_loc7_.uis[_loc8_])).uiModule = _loc7_;
            _loc6_.strata = param2.getUi().strata;
            _loc6_.depth = param2.getUi().depth + 1;
            Berilia.getInstance().loadUiInside(_loc7_.uis[_loc8_],param3,_loc6_,param4,false);
            param2.addChild(_loc6_);
            return SecureCenter.secure(_loc6_,_loc7_.trusted);
         }
         return null;
      }
      
      [Untrusted]
      public function unloadUi(param1:String = null) : void
      {
         Berilia.getInstance().unloadUi(param1);
      }
      
      [Untrusted]
      public function getUi(param1:String) : *
      {
         var _loc2_:UiRootContainer = Berilia.getInstance().getUi(param1);
         if(!_loc2_)
         {
            return null;
         }
         if(_loc2_.uiModule != this._module && !this._module.trusted)
         {
            throw new ArgumentError("Cannot get access to an UI owned by another module.");
         }
         return SecureCenter.secure(_loc2_,this._module.trusted);
      }
      
      [Untrusted]
      public function getUiInstances() : Vector.<UiRootContainer>
      {
         var _loc1_:UiRootContainer = null;
         var _loc2_:Dictionary = Berilia.getInstance().uiList;
         var _loc3_:Vector.<UiRootContainer> = new Vector.<UiRootContainer>();
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_.uiModule == this._module)
            {
               _loc3_.push(_loc1_);
            }
         }
         return _loc3_;
      }
      
      [Untrusted]
      public function getModuleList() : Array
      {
         var _loc1_:UiModule = null;
         var _loc2_:Array = null;
         var _loc3_:Array = [];
         var _loc4_:Array = UiModuleManager.getInstance().getModules();
         for each(_loc1_ in _loc4_)
         {
            _loc3_.push(_loc1_);
         }
         _loc2_ = UiModuleManager.getInstance().disabledModules;
         for each(_loc1_ in _loc2_)
         {
            _loc3_.push(_loc1_);
         }
         _loc3_.sortOn(["trusted","name"],[Array.NUMERIC | Array.DESCENDING,0]);
         return _loc3_;
      }
      
      [Untrusted]
      public function getModule(param1:String, param2:Boolean = false) : UiModule
      {
         return UiModuleManager.getInstance().getModule(param1,param2);
      }
      
      [Trusted]
      public function setModuleEnable(param1:String, param2:Boolean) : void
      {
         var _loc3_:Array = null;
         var _loc4_:UiModule = null;
         var _loc5_:Boolean = false;
         if(param2)
         {
            _loc3_ = UiModuleManager.getInstance().disabledModules;
         }
         else
         {
            _loc3_ = UiModuleManager.getInstance().getModules();
         }
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.id == param1 && _loc4_.enable == !param2)
            {
               _loc4_.enable = param2;
               _loc5_ = true;
               break;
            }
         }
         if(!_loc5_)
         {
            StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_MOD,param1,param2);
         }
      }
      
      [Trusted]
      public function addChild(param1:Object, param2:Object) : void
      {
         SecureCenter.unsecure(param1).addChild(SecureCenter.unsecure(param2));
      }
      
      [Trusted]
      public function addChildAt(param1:Object, param2:Object, param3:int) : void
      {
         SecureCenter.unsecure(param1).addChildAt(SecureCenter.unsecure(param2),param3);
      }
      
      [Untrusted]
      public function me() : *
      {
         return SecureCenter.secure(this._currentUi,this._module.trusted);
      }
      
      [Trusted]
      public function initDefaultBinds() : void
      {
         BindsManager.getInstance();
      }
      
      [Untrusted]
      public function addShortcutHook(param1:String, param2:Function, param3:Boolean = false) : void
      {
         var _loc4_:Shortcut;
         if(!(_loc4_ = Shortcut.getShortcutByName(param1)) && param1 != "ALL")
         {
            throw new ApiError("Shortcut [" + param1 + "] does not exist");
         }
         var _loc5_:int = !!this._currentUi?int(this._currentUi.depth):0;
         if(param3)
         {
            _loc5_ = 1;
         }
         var _loc6_:GenericListener = new GenericListener(param1,!!this._currentUi?this._currentUi.name:"__module_" + this._module.id,param2,_loc5_,!!this._currentUi?uint(GenericListener.LISTENER_TYPE_UI):uint(GenericListener.LISTENER_TYPE_MODULE),!!this._currentUi?new WeakReference(this._currentUi):null);
         BindsManager.getInstance().registerEvent(_loc6_);
      }
      
      [Untrusted]
      public function addComponentHook(param1:GraphicContainer, param2:String) : void
      {
         var _loc3_:InstanceEvent = null;
         var _loc4_:String;
         if(!(_loc4_ = this.getEventClassName(param2)))
         {
            throw new ApiError("Hook [" + param2 + "] does not exist");
         }
         if(!UIEventManager.getInstance().instances[param1])
         {
            _loc3_ = new InstanceEvent(param1,this._currentUi.uiClass);
            UIEventManager.getInstance().registerInstance(_loc3_);
         }
         else
         {
            _loc3_ = UIEventManager.getInstance().instances[param1];
         }
         _loc3_.events[_loc4_] = _loc4_;
      }
      
      [Untrusted]
      public function removeComponentHook(param1:GraphicContainer, param2:String) : void
      {
         var _loc3_:String = this.getEventClassName(param2);
         if(!_loc3_)
         {
            throw new ApiError("Hook [" + param2 + "] does not exist");
         }
         var _loc4_:InstanceEvent;
         if((_loc4_ = UIEventManager.getInstance().instances[param1]) && _loc4_.events && _loc4_.events[_loc3_])
         {
            delete _loc4_.events[_loc3_];
         }
      }
      
      [Trusted]
      public function bindApi(param1:Texture, param2:String, param3:*) : Boolean
      {
         var targetTexture:Texture = param1;
         var propertyName:String = param2;
         var value:* = param3;
         var internalContent:DisplayObject = ComponentInternalAccessor.access(targetTexture,"_child");
         if(!internalContent)
         {
            return false;
         }
         try
         {
            internalContent[propertyName] = value;
         }
         catch(e:Error)
         {
            return false;
         }
         return true;
      }
      
      [Untrusted]
      public function createComponent(param1:String, ... rest) : GraphicContainer
      {
         return CallWithParameters.callConstructor(getDefinitionByName("com.ankamagames.berilia.components::" + param1) as Class,rest);
      }
      
      [Untrusted]
      public function createContainer(param1:String, ... rest) : *
      {
         return CallWithParameters.callConstructor(getDefinitionByName("com.ankamagames.berilia.types.graphic::" + param1) as Class,rest);
      }
      
      [Deprecated(help="use addComponentHook to add event")]
      [Untrusted]
      public function createInstanceEvent(param1:DisplayObject, param2:*) : InstanceEvent
      {
         return new InstanceEvent(param1,param2);
      }
      
      [Untrusted]
      public function getEventClassName(param1:String) : String
      {
         switch(param1)
         {
            case EventEnums.EVENT_ONPRESS:
               return EventEnums.EVENT_ONPRESS_MSG;
            case EventEnums.EVENT_ONRELEASE:
               return EventEnums.EVENT_ONRELEASE_MSG;
            case EventEnums.EVENT_ONROLLOUT:
               return EventEnums.EVENT_ONROLLOUT_MSG;
            case EventEnums.EVENT_ONROLLOVER:
               return EventEnums.EVENT_ONROLLOVER_MSG;
            case EventEnums.EVENT_ONRELEASEOUTSIDE:
               return EventEnums.EVENT_ONRELEASEOUTSIDE_MSG;
            case EventEnums.EVENT_ONDOUBLECLICK:
               return EventEnums.EVENT_ONDOUBLECLICK_MSG;
            case EventEnums.EVENT_ONRIGHTCLICK:
               return EventEnums.EVENT_ONRIGHTCLICK_MSG;
            case EventEnums.EVENT_ONTEXTCLICK:
               return EventEnums.EVENT_ONTEXTCLICK_MSG;
            case EventEnums.EVENT_ONCOLORCHANGE:
               return EventEnums.EVENT_ONCOLORCHANGE_MSG;
            case EventEnums.EVENT_ONENTITYREADY:
               return EventEnums.EVENT_ONENTITYREADY_MSG;
            case EventEnums.EVENT_ONSELECTITEM:
               return EventEnums.EVENT_ONSELECTITEM_MSG;
            case EventEnums.EVENT_ONSELECTEMPTYITEM:
               return EventEnums.EVENT_ONSELECTEMPTYITEM_MSG;
            case EventEnums.EVENT_ONCREATETAB:
               return EventEnums.EVENT_ONCREATETAB_MSG;
            case EventEnums.EVENT_ONDELETETAB:
               return EventEnums.EVENT_ONDELETETAB_MSG;
            case EventEnums.EVENT_ONRENAMETAB:
               return EventEnums.EVENT_ONRENAMETAB_MSG;
            case EventEnums.EVENT_ONITEMROLLOUT:
               return EventEnums.EVENT_ONITEMROLLOUT_MSG;
            case EventEnums.EVENT_ONITEMROLLOVER:
               return EventEnums.EVENT_ONITEMROLLOVER_MSG;
            case EventEnums.EVENT_ONITEMRIGHTCLICK:
               return EventEnums.EVENT_ONITEMRIGHTCLICK_MSG;
            case EventEnums.EVENT_ONDROP:
               return EventEnums.EVENT_ONDROP_MSG;
            case EventEnums.EVENT_ONTEXTUREREADY:
               return EventEnums.EVENT_ONTEXTUREREADY_MSG;
            case EventEnums.EVENT_ONTEXTURELOADFAIL:
               return EventEnums.EVENT_ONTEXTURELOADFAIL_MSG;
            case EventEnums.EVENT_ONMAPELEMENTROLLOUT:
               return EventEnums.EVENT_ONMAPELEMENTROLLOUT_MSG;
            case EventEnums.EVENT_ONMAPELEMENTROLLOVER:
               return EventEnums.EVENT_ONMAPELEMENTROLLOVER_MSG;
            case EventEnums.EVENT_ONMAPELEMENTRIGHTCLICK:
               return EventEnums.EVENT_ONMAPELEMENTRIGHTCLICK_MSG;
            case EventEnums.EVENT_ONMAPMOVE:
               return EventEnums.EVENT_ONMAPMOVE_MSG;
            case EventEnums.EVENT_ONMAPROLLOVER:
               return EventEnums.EVENT_ONMAPROLLOVER_MSG;
            case EventEnums.EVENT_ONVIDEOCONNECTFAILED:
               return EventEnums.EVENT_ONVIDEOCONNECTFAILED_MSG;
            case EventEnums.EVENT_ONVIDEOCONNECTSUCCESS:
               return EventEnums.EVENT_ONVIDEOCONNECTSUCCESS_MSG;
            case EventEnums.EVENT_ONVIDEOBUFFERCHANGE:
               return EventEnums.EVENT_ONVIDEOBUFFERCHANGE_MSG;
            case EventEnums.EVENT_ONCOMPONENTREADY:
               return EventEnums.EVENT_ONCOMPONENTREADY_MSG;
            case EventEnums.EVENT_ONWHEEL:
               return EventEnums.EVENT_ONWHEEL_MSG;
            case EventEnums.EVENT_ONMOUSEUP:
               return EventEnums.EVENT_ONMOUSEUP_MSG;
            case EventEnums.EVENT_ONCHANGE:
               return EventEnums.EVENT_ONCHANGE_MSG;
            case EventEnums.EVENT_ONBROWSER_SESSION_TIMEOUT:
               return EventEnums.EVENT_ONBROWSER_SESSION_TIMEOUT_MSG;
            case EventEnums.EVENT_ONBROWSER_DOM_READY:
               return EventEnums.EVENT_ONBROWSER_DOM_READY_MSG;
            case EventEnums.EVENT_ONBROWSER_DOM_CHANGE:
               return EventEnums.EVENT_ONBROWSER_DOM_CHANGE_MSG;
            case EventEnums.EVENT_MIDDLECLICK:
               return EventEnums.EVENT_MIDDLECLICK_MSG;
            default:
               return null;
         }
      }
      
      [Deprecated(help="use addComponentHook to add event")]
      [Untrusted]
      public function addInstanceEvent(param1:InstanceEvent) : void
      {
         UIEventManager.getInstance().registerInstance(param1);
      }
      
      [NoBoxing]
      [Untrusted]
      public function createUri(param1:String) : Uri
      {
         if(param1 && param1.indexOf(":") == -1 && param1.indexOf("./") != 0 && param1.indexOf("\\\\") != 0)
         {
            param1 = "mod://" + this._module.id + "/" + param1;
         }
         return new Uri(param1);
      }
      
      [Untrusted]
      public function showTooltip(param1:*, param2:*, param3:Boolean = false, param4:String = "standard", param5:uint = 0, param6:uint = 2, param7:int = 3, param8:String = null, param9:Class = null, param10:Object = null, param11:String = null, param12:Boolean = false, param13:int = 4, param14:Number = 1, param15:String = "") : void
      {
         var _loc16_:Tooltip = null;
         if(param15 || this._currentUi)
         {
            if(_loc16_ = TooltipManager.show(param1,param2,this._module,param3,param4,param5,param6,param7,true,param8,param9,param10,param11,param12,param13,param14))
            {
               _loc16_.uiModuleName = !!param15?param15:this._currentUi.name;
            }
         }
      }
      
      [Untrusted]
      public function hideTooltip(param1:String = null) : void
      {
         TooltipManager.hide(param1);
      }
      
      [Untrusted]
      public function textTooltipInfo(param1:String, param2:String = null, param3:String = null, param4:int = 400) : Object
      {
         return new TextTooltipInfo(param1,param2,param3,param4);
      }
      
      [Untrusted]
      public function getRadioGroupSelectedItem(param1:String, param2:UiRootContainer) : IRadioItem
      {
         var _loc3_:RadioGroup = param2.getRadioGroup(param1);
         return _loc3_.selectedItem;
      }
      
      [Untrusted]
      public function setRadioGroupSelectedItem(param1:String, param2:IRadioItem, param3:UiRootContainer) : void
      {
         var _loc4_:RadioGroup;
         (_loc4_ = param3.getRadioGroup(param1)).selectedItem = param2;
      }
      
      [Untrusted]
      public function keyIsDown(param1:uint) : Boolean
      {
         return KeyPoll.getInstance().isDown(param1);
      }
      
      [Untrusted]
      public function keyIsUp(param1:uint) : Boolean
      {
         return KeyPoll.getInstance().isUp(param1);
      }
      
      [NoBoxing]
      [Untrusted]
      public function convertToTreeData(param1:*) : Vector.<TreeData>
      {
         return TreeData.fromArray(param1);
      }
      
      [Untrusted]
      public function setFollowCursorUri(param1:*, param2:Boolean = false, param3:Boolean = false, param4:int = 0, param5:int = 0, param6:Number = 1) : void
      {
         var _loc7_:LinkedCursorData = null;
         if(param1)
         {
            (_loc7_ = new LinkedCursorData()).sprite = new Texture();
            Texture(_loc7_.sprite).uri = param1 is String?new Uri(param1):param1;
            _loc7_.sprite.scaleX = param6;
            _loc7_.sprite.scaleY = param6;
            Texture(_loc7_.sprite).finalize();
            _loc7_.lockX = param2;
            _loc7_.lockY = param3;
            _loc7_.offset = new Point(param4,param5);
            LinkedCursorSpriteManager.getInstance().addItem("customUserCursor",_loc7_);
         }
         else
         {
            LinkedCursorSpriteManager.getInstance().removeItem("customUserCursor");
         }
      }
      
      [Untrusted]
      public function getFollowCursorUri() : Object
      {
         return LinkedCursorSpriteManager.getInstance().getItem("customUserCursor");
      }
      
      [Untrusted]
      public function endDrag() : void
      {
         var _loc1_:LinkedCursorData = LinkedCursorSpriteManager.getInstance().getItem("DragAndDrop");
         if(_loc1_ && _loc1_.data is SlotDragAndDropData)
         {
            LinkedCursorSpriteManager.getInstance().removeItem("DragAndDrop");
            KernelEventsManager.getInstance().processCallback(BeriliaHookList.DropEnd,SecureCenter.secure(SlotDragAndDropData(_loc1_.data).currentHolder));
         }
      }
      
      [Untrusted]
      public function preloadCss(param1:String) : void
      {
         CssManager.getInstance().preloadCss(param1);
      }
      
      [Untrusted]
      public function getMouseX() : int
      {
         return StageShareManager.mouseX;
      }
      
      [Untrusted]
      public function getMouseY() : int
      {
         return StageShareManager.mouseY;
      }
      
      [Untrusted]
      public function getStageWidth() : int
      {
         return StageShareManager.startWidth;
      }
      
      [Untrusted]
      public function getStageHeight() : int
      {
         return StageShareManager.startHeight;
      }
      
      [Untrusted]
      public function getWindowWidth() : int
      {
         return StageShareManager.stage.stageWidth;
      }
      
      [Untrusted]
      public function getWindowHeight() : int
      {
         return StageShareManager.stage.stageHeight;
      }
      
      [Untrusted]
      public function getWindowScale() : Number
      {
         return StageShareManager.windowScale;
      }
      
      [Trusted]
      public function setFullScreen(param1:Boolean, param2:Boolean = false) : void
      {
         StageShareManager.setFullScreen(param1,param2);
      }
      
      [Untrusted]
      public function isFullScreen() : Boolean
      {
         return StageShareManager.stage.displayState != StageDisplayState.NORMAL;
      }
      
      [Trusted]
      public function setShortcutUsedToExitFullScreen(param1:Boolean) : void
      {
         StageShareManager.shortcutUsedToExitFullScreen = param1;
      }
      
      [Untrusted]
      public function useIME() : Boolean
      {
         return Berilia.getInstance().useIME;
      }
      
      private function getInitBounds(param1:Texture) : Rectangle
      {
         var _loc2_:MovieClip = null;
         if(this.oldTextureUri == null || param1 && param1.uri && this.oldTextureUri != param1.uri.toString())
         {
            if(!(param1.child is DisplayObjectContainer))
            {
               return null;
            }
            _loc2_ = (param1.child as DisplayObjectContainer).getChildByName("bg") as MovieClip;
            if(_loc2_)
            {
               this.oldTextureBounds.width = _loc2_.width;
               this.oldTextureBounds.height = _loc2_.height;
               this.oldTextureUri = param1.uri.toString();
            }
         }
         return this.oldTextureBounds;
      }
      
      [Trusted]
      public function buildOrnamentTooltipFrom(param1:Texture, param2:Rectangle) : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Rectangle;
         if(!(_loc6_ = this.getInitBounds(param1)))
         {
            _loc6_ = new Rectangle();
         }
         var _loc7_:DisplayObjectContainer = param1.child as DisplayObjectContainer;
         var _loc8_:MovieClip;
         if(_loc8_ = this.addPart("bg",_loc7_,param2,_loc6_.x,_loc6_.y) as MovieClip)
         {
            _loc3_ = _loc8_.getBounds(_loc8_);
            _loc4_ = (param2.width - _loc3_.left + (_loc3_.right - 160)) / _loc3_.width;
            _loc5_ = (param2.height - _loc3_.top + (_loc3_.bottom - 40)) / _loc3_.height;
            _loc8_.x = _loc8_.x + (-_loc3_.left * _loc4_ + _loc3_.left);
            _loc8_.y = _loc8_.y + (-_loc3_.top * _loc5_ + _loc3_.top);
            _loc8_.scale9Grid = new Rectangle(80,20,1,1);
            _loc8_.width = _loc6_.width * _loc4_;
            _loc8_.height = _loc6_.height * _loc5_;
         }
         this.addPart("top",_loc7_,param2,param2.width / 2,0);
         this.addPart("picto",_loc7_,param2,param2.width / 2,0);
         this.addPart("right",_loc7_,param2,param2.width,param2.height / 2);
         this.addPart("bottom",_loc7_,param2,param2.width / 2,param2.height - 1);
         this.addPart("left",_loc7_,param2,0,param2.height / 2);
      }
      
      private function addPart(param1:String, param2:DisplayObjectContainer, param3:Rectangle, param4:int, param5:int) : DisplayObject
      {
         if(!param2)
         {
            return null;
         }
         var _loc6_:DisplayObject;
         if((_loc6_ = param2.getChildByName(param1)) != null)
         {
            _loc6_.x = param3.x + param4;
            _loc6_.y = param3.y + param5;
         }
         return _loc6_;
      }
      
      [Untrusted]
      public function getTextSize(param1:String, param2:Uri, param3:String) : Rectangle
      {
         if(!_label)
         {
            _label = this.createComponent("Label") as Label;
         }
         _label.css = param2;
         _label.cssClass = param3;
         _label.fixedWidth = false;
         _label.text = param1;
         return new Rectangle(0,0,_label.textWidth,_label.textHeight);
      }
      
      [Trusted]
      public function setComponentMinMaxSize(param1:GraphicContainer, param2:Point, param3:Point) : void
      {
         if(!param1.minSize)
         {
            param1.minSize = new GraphicSize();
         }
         param1.minSize.x = param2.x;
         param1.minSize.y = param2.y;
         if(!param1.maxSize)
         {
            param1.maxSize = new GraphicSize();
         }
         param1.maxSize.x = param3.x;
         param1.maxSize.y = param3.y;
      }
      
      [Untrusted]
      public function replaceParams(param1:String, param2:Array, param3:String = "%") : String
      {
         return I18n.replaceParams(param1,param2,param3);
      }
      
      [Untrusted]
      public function replaceKey(param1:String) : String
      {
         return LangManager.getInstance().replaceKey(param1,true);
      }
      
      [Untrusted]
      public function getText(param1:String, ... rest) : String
      {
         return I18n.getUiText(param1,rest);
      }
      
      [Untrusted]
      public function getTextFromKey(param1:uint, param2:String = "%", ... rest) : String
      {
         return I18n.getText(param1,rest,param2);
      }
      
      [Untrusted]
      public function processText(param1:String, param2:String, param3:Boolean = true) : String
      {
         return PatternDecoder.combine(param1,param2,param3);
      }
      
      [Untrusted]
      public function decodeText(param1:String, param2:Array) : String
      {
         return PatternDecoder.decode(param1,param2);
      }
   }
}
