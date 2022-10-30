package com.ankamagames.berilia.types.graphic
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.enums.LocationTypeEnum;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.UiRenderManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.data.RadioGroup;
   import com.ankamagames.berilia.types.data.UiData;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManager;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.errors.IllegalOperationError;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class UiRootContainer extends GraphicContainer
   {
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UiRootContainer));
       
      
      private var _aNamedElements:Array;
      
      private var _bUsedCustomSize:Boolean = false;
      
      private var _stage:Stage;
      
      private var _root:Sprite;
      
      private var _aGraphicLocationStack:Array;
      
      private var _aSizeStack:Array;
      
      private var _aGraphicElementIndex:Array;
      
      private var _aPositionnedElement:Array;
      
      private var _linkedUi:Array;
      
      private var _aPostFinalizeElement:Array;
      
      private var _aFinalizeElements:Array;
      
      private var _uiDefinitionUpdateTimer:Timer;
      
      private var _rendering:Boolean = false;
      
      private var _ready:Boolean;
      
      private var _waitingFctCall:Array;
      
      private var _properties;
      
      private var _wasVisible:Boolean;
      
      private var _lock:Boolean = true;
      
      private var _renderAsk:Boolean = false;
      
      private var _isNotFinalized:Boolean = true;
      
      private var _tempVisible:Boolean = true;
      
      private var _uiData:UiData;
      
      public var uiClass;
      
      public var uiModule:UiModule;
      
      public var strata:int;
      
      public var depth:int;
      
      public var scalable:Boolean = true;
      
      public var modal:Boolean = false;
      
      private var _modalContainer:GraphicContainer;
      
      public var giveFocus:Boolean = true;
      
      public var modalIndex:uint = 0;
      
      public var radioGroup:Array;
      
      public var cached:Boolean = false;
      
      public var hideAfterLoading:Boolean = false;
      
      public var transmitFocus:Boolean = true;
      
      public var constants:Array;
      
      public var tempHolder:DisplayObjectContainer;
      
      public function UiRootContainer(param1:Stage, param2:UiData, param3:Sprite = null)
      {
         super();
         this._stage = param1;
         this._root = param3;
         this._aNamedElements = new Array();
         this._aSizeStack = new Array();
         this._linkedUi = new Array();
         this._uiData = param2;
         this._aGraphicLocationStack = new Array();
         this._aGraphicElementIndex = new Array();
         this._aPostFinalizeElement = new Array();
         this._aFinalizeElements = new Array();
         this._waitingFctCall = new Array();
         this.radioGroup = new Array();
         super.visible = false;
         MEMORY_LOG[this] = 1;
      }
      
      public function set properties(param1:*) : void
      {
         if(!this._properties)
         {
            this._properties = param1;
         }
      }
      
      override public function get customUnicName() : String
      {
         return name;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         if(this._isNotFinalized)
         {
            this._tempVisible = param1;
         }
         else
         {
            super.visible = param1;
         }
      }
      
      override public function get width() : Number
      {
         if(this._bUsedCustomSize)
         {
            return __width;
         }
         return super.width;
      }
      
      override public function set width(param1:Number) : void
      {
         this._bUsedCustomSize = true;
         __width = param1;
      }
      
      override public function get height() : Number
      {
         if(this._bUsedCustomSize)
         {
            return __height;
         }
         return super.height;
      }
      
      override public function set height(param1:Number) : void
      {
         this._bUsedCustomSize = true;
         __height = param1;
      }
      
      public function set useCustomSize(param1:Boolean) : void
      {
         this._bUsedCustomSize = param1;
      }
      
      public function get useCustomSize() : Boolean
      {
         return this._bUsedCustomSize;
      }
      
      public function set disableRender(param1:Boolean) : void
      {
         this._rendering = param1;
      }
      
      public function get disableRender() : Boolean
      {
         return this._rendering;
      }
      
      public function get ready() : Boolean
      {
         return this._ready;
      }
      
      public function set modalContainer(param1:GraphicContainer) : void
      {
         this._modalContainer = param1;
      }
      
      public function set showModalContainer(param1:Boolean) : void
      {
         if(this.modal && this._modalContainer != null)
         {
            this._modalContainer.visible = param1;
         }
      }
      
      public function get uiData() : UiData
      {
         return this._uiData;
      }
      
      public function addElement(param1:String, param2:Object) : void
      {
         this._aNamedElements[param1] = param2;
      }
      
      public function removeElement(param1:String) : void
      {
         delete this._aNamedElements[param1];
      }
      
      public function getElement(param1:String) : GraphicContainer
      {
         return this._aNamedElements[param1];
      }
      
      public function getElements() : Array
      {
         return this._aNamedElements;
      }
      
      public function getConstant(param1:String) : *
      {
         return this.constants[param1];
      }
      
      public function iAmFinalized(param1:FinalizableUIComponent) : void
      {
         var _loc2_:FinalizableUIComponent = null;
         var _loc3_:int = 0;
         var _loc4_:Callback = null;
         var _loc5_:Boolean = false;
         if(!this._lock || this._rendering)
         {
            return;
         }
         for each(_loc2_ in this._aFinalizeElements)
         {
            if(!_loc2_.finalized)
            {
               return;
            }
         }
         this._lock = false;
         this.render();
         this._ready = true;
         if(this.tempHolder)
         {
            if(!this.hideAfterLoading)
            {
               this.tempHolder.parent.addChildAt(this,this.tempHolder.parent.getChildIndex(this.tempHolder));
            }
            this.tempHolder.parent.removeChild(this.tempHolder);
            this.tempHolder = null;
         }
         this._isNotFinalized = false;
         if(this.uiClass && this.uiClass.hasOwnProperty("main"))
         {
            this._rendering = true;
            _loc3_ = getTimer();
            FpsManager.getInstance().startTracking("hook",7108545);
            ErrorManager.tryFunction(this.uiClass["main"],[this._properties],"Une erreur est survenue lors de l\'exécution de la fonction main de l\'interface " + name + " (" + getQualifiedClassName(this.uiClass) + ")");
            FpsManager.getInstance().stopTracking("hook");
            this._rendering = false;
            if(ErrorManager.lastTryFunctionHasException)
            {
               _loc5_ = true;
            }
            else if(this._renderAsk)
            {
               this.render();
            }
            this._ready = true;
            for each(_loc4_ in this._waitingFctCall)
            {
               _loc4_.exec();
            }
            this._waitingFctCall = null;
         }
         dispatchEvent(new UiRenderEvent(UiRenderEvent.UIRenderComplete,false,false,this));
         this.visible = this._tempVisible;
         if(_loc5_)
         {
            _log.error("UI " + name + " has encountered an exception and must be unloaded.");
            _log.warn("" + ErrorManager.lastExceptionStacktrace);
            Berilia.getInstance().unloadUi(name);
         }
      }
      
      public function render() : void
      {
         var _loc1_:int = 0;
         var _loc2_:GraphicElement = null;
         var _loc3_:FinalizableUIComponent = null;
         this._renderAsk = true;
         var _loc4_:Boolean = this._ready;
         this._ready = false;
         if(this._rendering || this._lock)
         {
            return;
         }
         var _loc5_:uint = getTimer();
         this._rendering = true;
         this._aPositionnedElement = new Array();
         this.zSort(this._aSizeStack);
         this.processSize();
         _loc1_ = 0;
         while(_loc1_ < this._aGraphicLocationStack.length)
         {
            if(this._aGraphicLocationStack[_loc1_] != null)
            {
               this._aGraphicLocationStack[_loc1_].render = false;
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._aGraphicLocationStack.length)
         {
            if(this._aGraphicLocationStack[_loc1_] != null)
            {
               if(!this._aGraphicLocationStack[_loc1_].render)
               {
                  _loc2_ = this._aGraphicLocationStack[_loc1_];
                  if(!_loc2_.sprite.dynamicPosition)
                  {
                     this.processLocation(this._aGraphicLocationStack[_loc1_]);
                  }
               }
            }
            _loc1_++;
         }
         this.updateLinkedUi();
         for each(_loc3_ in this._aPostFinalizeElement)
         {
            _loc3_.finalize();
         }
         this._aPositionnedElement = new Array();
         this._rendering = false;
         this._ready = _loc4_;
      }
      
      public function registerId(param1:String, param2:GraphicElement) : void
      {
         if(this._aGraphicElementIndex[param1] != null && this._aGraphicElementIndex[param1] != undefined)
         {
            throw new BeriliaError(param1 + " name is already used");
         }
         this._aGraphicElementIndex[param1] = param2;
         this.addElement(param1,param2.sprite);
      }
      
      public function deleteId(param1:String) : void
      {
         if(this._aGraphicElementIndex[param1] == null)
         {
            return;
         }
         delete this._aGraphicElementIndex[param1];
         this.removeElement(param1);
      }
      
      public function getElementById(param1:String) : GraphicElement
      {
         return this._aGraphicElementIndex[param1];
      }
      
      public function removeFromRenderList(param1:String) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:GraphicElement = null;
         _loc2_ = 0;
         while(_loc2_ < this._aGraphicLocationStack.length)
         {
            _loc3_ = this._aGraphicLocationStack[_loc2_];
            if(_loc3_ != null && _loc3_.sprite.name == param1)
            {
               delete this._aGraphicLocationStack[_loc2_];
               break;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._aSizeStack.length)
         {
            if(this._aSizeStack[_loc2_] != null && this._aSizeStack[_loc2_].name == param1)
            {
               delete this._aSizeStack[_loc2_];
               return;
            }
            _loc2_++;
         }
      }
      
      public function addDynamicSizeElement(param1:GraphicElement) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._aSizeStack.length)
         {
            if(this._aSizeStack[_loc2_] == param1)
            {
               return;
            }
            _loc2_++;
         }
         this._aSizeStack.push(param1);
      }
      
      public function addDynamicElement(param1:GraphicElement) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < this._aGraphicLocationStack.length)
         {
            if(this._aGraphicLocationStack[_loc2_] != null && this._aGraphicLocationStack[_loc2_].sprite.name == param1.sprite.name)
            {
               return;
            }
            _loc2_++;
         }
         this._aGraphicLocationStack.push(param1);
      }
      
      public function addPostFinalizeComponent(param1:FinalizableUIComponent) : void
      {
         this._aPostFinalizeElement.push(param1);
      }
      
      public function addFinalizeElement(param1:FinalizableUIComponent) : void
      {
         this._aFinalizeElements.push(param1);
      }
      
      public function addRadioGroup(param1:String) : RadioGroup
      {
         if(!this.radioGroup[param1])
         {
            this.radioGroup[param1] = new RadioGroup(param1);
         }
         return this.radioGroup[param1];
      }
      
      public function getRadioGroup(param1:String) : RadioGroup
      {
         return this.radioGroup[param1];
      }
      
      public function addLinkedUi(param1:String) : void
      {
         if(param1 != name)
         {
            this._linkedUi[param1] = param1;
         }
         else
         {
            _log.error("Cannot add link to yourself in " + name);
         }
      }
      
      public function removeLinkedUi(param1:String) : void
      {
         delete this._linkedUi[param1];
      }
      
      public function updateLinkedUi() : void
      {
         var _loc1_:String = null;
         for each(_loc1_ in this._linkedUi)
         {
            if(Berilia.getInstance().getUi(this._linkedUi[_loc1_]))
            {
               Berilia.getInstance().getUi(this._linkedUi[_loc1_]).render();
            }
         }
      }
      
      public function call(param1:Function, param2:Array, param3:Object) : void
      {
         if(param3 !== SecureCenter.ACCESS_KEY)
         {
            throw new IllegalOperationError();
         }
         if(this._ready)
         {
            CallWithParameters.call(param1,param2);
         }
         else
         {
            this._waitingFctCall.push(CallWithParameters.callConstructor(Callback,[param1].concat(param2)));
         }
      }
      
      public function destroyUi(param1:Object) : void
      {
         var _loc2_:RadioGroup = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:GraphicContainer = null;
         if(param1 !== SecureCenter.ACCESS_KEY)
         {
            throw new IllegalOperationError();
         }
         for each(_loc2_ in this.radioGroup)
         {
            RadioGroup(_loc2_).destroy();
         }
         this.radioGroup = null;
         this._stage = null;
         this._root = null;
         this._aNamedElements = new Array();
         this._aSizeStack = new Array();
         this._linkedUi = new Array();
         this._aGraphicLocationStack = new Array();
         this._aGraphicElementIndex = new Array();
         this._aPostFinalizeElement = new Array();
         if(this._aFinalizeElements)
         {
            _loc3_ = this._aFinalizeElements.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               (_loc5_ = this._aFinalizeElements[_loc4_]).remove();
               _loc4_++;
            }
         }
         this._aFinalizeElements = null;
      }
      
      private function isRegisteredId(param1:String) : Boolean
      {
         return this._aGraphicElementIndex[param1] != null;
      }
      
      private function processSize() : void
      {
         var _loc1_:GraphicElement = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this._aSizeStack.length)
         {
            _loc1_ = this._aSizeStack[_loc2_];
            if(_loc1_ != null)
            {
               if(!isNaN(_loc1_.size.x) && _loc1_.size.xUnit == GraphicSize.SIZE_PRC)
               {
                  if(_loc1_.sprite && _loc1_.sprite.parent && _loc1_.sprite.parent.parent is UiRootContainer)
                  {
                     _loc1_.sprite.width = int(_loc1_.size.x * StageShareManager.startWidth);
                  }
                  else if(GraphicContainer(_loc1_.sprite).getParent())
                  {
                     _loc1_.sprite.width = int(_loc1_.size.x * GraphicContainer(_loc1_.sprite).getParent().width);
                  }
               }
               if(!isNaN(_loc1_.size.y) && _loc1_.size.yUnit == GraphicSize.SIZE_PRC)
               {
                  if(_loc1_.sprite && _loc1_.sprite.parent && _loc1_.sprite.parent.parent is UiRootContainer)
                  {
                     _loc1_.sprite.height = int(_loc1_.size.y * StageShareManager.startHeight);
                  }
                  else if(GraphicContainer(_loc1_.sprite).getParent())
                  {
                     _loc1_.sprite.height = int(_loc1_.size.y * GraphicContainer(_loc1_.sprite).getParent().height);
                  }
               }
            }
            _loc2_++;
         }
      }
      
      public function processLocation(param1:GraphicElement) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:Number = param1.sprite.x;
         var _loc5_:Number = param1.sprite.y;
         var _loc6_:Number = param1.location.getOffsetX();
         var _loc7_:Number = param1.location.getOffsetY();
         param1.sprite.x = 0;
         param1.sprite.y = 0;
         param1.location.setOffsetX(_loc6_);
         param1.location.setOffsetY(_loc7_);
         if(param1.locations.length > 1)
         {
            param1.sprite.width = 0;
            param1.sprite.height = 0;
            _loc2_ = this.getLocation(new Point(param1.sprite.x,param1.sprite.y),param1.locations[0],param1.sprite);
            _loc3_ = this.getLocation(new Point(param1.sprite.x,param1.sprite.y),param1.locations[1],param1.sprite);
            if(_loc2_ && _loc3_)
            {
               param1.sprite.width = Math.floor(Math.abs(_loc3_.x - _loc2_.x));
               param1.sprite.height = Math.floor(Math.abs(_loc3_.y - _loc2_.y));
            }
            else
            {
               _log.error("Erreur de positionement dans " + name + " avec " + param1.name);
            }
         }
         var _loc8_:Point = this.getLocation(new Point(param1.sprite.x,param1.sprite.y),param1.location,param1.sprite);
         if(param1.sprite && _loc8_)
         {
            param1.sprite.x = _loc8_.x;
            param1.sprite.y = _loc8_.y;
         }
         else
         {
            param1.sprite.x = _loc4_;
            param1.sprite.y = _loc5_;
            _log.error("Erreur dans " + name + " avec " + param1.name);
         }
      }
      
      private function getLocation(param1:Point, param2:GraphicLocation, param3:DisplayObject) : Point
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:Array = null;
         var _loc7_:UiRootContainer = null;
         var _loc8_:Point = new Point();
         var _loc9_:Point = new Point();
         var _loc10_:Point = new Point();
         if(param2.offsetXType == LocationTypeEnum.LOCATION_TYPE_RELATIVE || param2.offsetYType == LocationTypeEnum.LOCATION_TYPE_RELATIVE)
         {
            _loc9_ = param3.localToGlobal(new Point(param3.x,param3.y));
            switch(param2.getRelativeTo())
            {
               case GraphicLocation.REF_PARENT:
                  _loc8_.x = Math.floor(GraphicContainer(param3).getParent().width * param2.getOffsetX());
                  _loc8_.y = Math.floor(GraphicContainer(param3).getParent().height * param2.getOffsetY());
            }
            if(param2.offsetXType == LocationTypeEnum.LOCATION_TYPE_RELATIVE)
            {
               param1.x = param1.x + _loc8_.x;
            }
            if(param2.offsetYType == LocationTypeEnum.LOCATION_TYPE_RELATIVE)
            {
               param1.y = param1.y + _loc8_.y;
            }
         }
         if(param2.offsetXType == LocationTypeEnum.LOCATION_TYPE_ABSOLUTE || param2.offsetYType == LocationTypeEnum.LOCATION_TYPE_ABSOLUTE)
         {
            _loc8_.x = 0;
            _loc8_.y = 0;
            _loc9_ = param3.localToGlobal(new Point(param3.x,param3.y));
            switch(param2.getRelativeTo())
            {
               case GraphicLocation.REF_PARENT:
                  _loc8_.x = param2.getOffsetX();
                  _loc8_.y = param2.getOffsetY();
                  break;
               case GraphicLocation.REF_SCREEN:
                  _loc10_ = param3.localToGlobal(new Point(param3.x,param3.y));
                  _loc8_.x = param2.getOffsetX() - _loc10_.x;
                  _loc8_.y = param2.getOffsetY() - _loc10_.y;
                  break;
               case GraphicLocation.REF_TOP:
                  _loc10_ = new Point(x,y);
                  _loc8_.x = param2.getOffsetX() + (_loc10_.x - _loc9_.x);
                  _loc8_.y = param2.getOffsetY() + (_loc10_.y - _loc9_.y);
                  break;
               default:
                  if(this.isRegisteredId(param2.getRelativeTo()))
                  {
                     _loc5_ = this._aGraphicElementIndex[param2.getRelativeTo()].sprite;
                  }
                  else if(Berilia.getInstance().getUi(param2.getRelativeTo()))
                  {
                     _loc5_ = Berilia.getInstance().getUi(param2.getRelativeTo());
                     UiRootContainer(_loc5_).addLinkedUi(name);
                     param3 = _loc5_;
                  }
                  else
                  {
                     if(param2.getRelativeTo().indexOf(".") == -1)
                     {
                        _log.warn("[Warning] " + param2.getRelativeTo() + " is unknow graphic element reference");
                        return null;
                     }
                     _loc6_ = param2.getRelativeTo().split(".");
                     if(!(_loc7_ = Berilia.getInstance().getUi(_loc6_[0])))
                     {
                        _log.warn("[Warning] UI " + _loc6_[0] + " does not exist (found " + param2.getRelativeTo() + " in " + name + ")");
                        return null;
                     }
                     if(!_loc7_.getElementById(_loc6_[1]))
                     {
                        _log.warn("[Warning] UI " + _loc6_[0] + " does not contain element [" + _loc6_[1] + "] (found " + param2.getRelativeTo() + " in " + name + ")");
                        return null;
                     }
                     _loc5_ = _loc7_.getElementById(_loc6_[1]).sprite;
                     _loc9_ = param3.localToGlobal(new Point(param3.x,param3.y));
                     GraphicContainer(_loc5_).getUi().addLinkedUi(name);
                  }
                  _loc10_ = param3.localToGlobal(new Point(_loc5_.x,_loc5_.y));
                  _loc8_.x = param2.getOffsetX() + (_loc10_.x - _loc9_.x);
                  _loc8_.y = param2.getOffsetY() + (_loc10_.y - _loc9_.y);
            }
            if(param2.offsetXType == LocationTypeEnum.LOCATION_TYPE_ABSOLUTE)
            {
               param1.x = param1.x + _loc8_.x;
            }
            if(param2.offsetYType == LocationTypeEnum.LOCATION_TYPE_ABSOLUTE)
            {
               param1.y = param1.y + _loc8_.y;
            }
         }
         _loc8_ = this.getOffsetModificator(param2.getPoint(),param3);
         param1.x = param1.x - _loc8_.x;
         param1.y = param1.y - _loc8_.y;
         switch(param2.getRelativeTo())
         {
            case GraphicLocation.REF_PARENT:
               if(param3.parent && param3.parent.parent)
               {
                  _loc4_ = param3.parent.parent;
               }
               break;
            case GraphicLocation.REF_SCREEN:
               _loc4_ = this._root;
               break;
            case GraphicLocation.REF_TOP:
               _loc4_ = this;
               break;
            default:
               if((_loc4_ = _loc5_) == param3)
               {
                  _log.warn("[Warning] Wrong relative position : " + _loc4_.name + " refer to himself");
               }
         }
         _loc8_ = this.getOffsetModificator(param2.getRelativePoint(),_loc4_);
         param1.x = param1.x + _loc8_.x;
         param1.y = param1.y + _loc8_.y;
         return param1;
      }
      
      private function getOffsetModificator(param1:uint, param2:DisplayObject) : Point
      {
         var _loc3_:uint = param2 == null || param2 is UiRootContainer?uint(StageShareManager.startWidth):uint(param2.width);
         var _loc4_:uint = param2 == null || param2 is UiRootContainer?uint(StageShareManager.startHeight):uint(param2.height);
         var _loc5_:Point = new Point(0,0);
         switch(param1)
         {
            case LocationEnum.POINT_TOPLEFT:
               break;
            case LocationEnum.POINT_TOP:
               _loc5_.x = _loc3_ / 2;
               break;
            case LocationEnum.POINT_TOPRIGHT:
               _loc5_.x = _loc3_;
               break;
            case LocationEnum.POINT_LEFT:
               _loc5_.y = _loc3_ / 2;
               break;
            case LocationEnum.POINT_CENTER:
               _loc5_.x = _loc3_ / 2;
               _loc5_.y = _loc4_ / 2;
               break;
            case LocationEnum.POINT_RIGHT:
               _loc5_.x = _loc3_;
               _loc5_.y = _loc4_ / 2;
               break;
            case LocationEnum.POINT_BOTTOMLEFT:
               _loc5_.y = _loc4_;
               break;
            case LocationEnum.POINT_BOTTOM:
               _loc5_.x = _loc3_ / 2;
               _loc5_.y = _loc4_;
               break;
            case LocationEnum.POINT_BOTTOMRIGHT:
               _loc5_.x = _loc3_;
               _loc5_.y = _loc4_;
         }
         return _loc5_;
      }
      
      private function zSort(param1:Array) : Boolean
      {
         var _loc2_:GraphicElement = null;
         var _loc3_:GraphicLocation = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc8_:Boolean = false;
         var _loc7_:Boolean = true;
         while(_loc7_)
         {
            _loc7_ = false;
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc2_ = param1[_loc4_];
               if(_loc2_ != null)
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc2_.locations.length)
                  {
                     _loc6_ = _loc4_ + 1;
                     while(_loc6_ < param1.length)
                     {
                        _loc3_ = _loc2_.locations[_loc5_];
                        if(param1[_loc6_] != null)
                        {
                           if(_loc3_.getRelativeTo().charAt(0) != "$" && _loc3_.getRelativeTo() == param1[_loc6_].sprite.name || _loc3_.getRelativeTo() == GraphicLocation.REF_PARENT && param1[_loc6_].sprite == _loc2_.sprite.getParent())
                           {
                              _loc8_ = true;
                              _loc7_ = true;
                              param1[_loc4_] = param1[_loc6_];
                              param1[_loc6_] = _loc2_;
                              break;
                           }
                        }
                        _loc6_++;
                     }
                     _loc5_++;
                  }
               }
               _loc4_++;
            }
         }
         return _loc8_;
      }
      
      private function onDefinitionUpdateTimer(param1:TimerEvent) : void
      {
         UiRenderManager.getInstance().updateCachedUiDefinition();
         this._uiDefinitionUpdateTimer.removeEventListener(TimerEvent.TIMER,this.onDefinitionUpdateTimer);
         this._uiDefinitionUpdateTimer = null;
      }
   }
}
