package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.components.messages.MapElementRightClickMessage;
   import com.ankamagames.berilia.components.messages.MapElementRollOutMessage;
   import com.ankamagames.berilia.components.messages.MapElementRollOverMessage;
   import com.ankamagames.berilia.components.messages.MapMoveMessage;
   import com.ankamagames.berilia.components.messages.MapRollOverMessage;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.berilia.types.data.Map;
   import com.ankamagames.berilia.types.data.MapArea;
   import com.ankamagames.berilia.types.data.MapElement;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.MapAreaShape;
   import com.ankamagames.berilia.types.graphic.MapGroupElement;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDownMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOutMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseReleaseOutsideMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseWheelMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class MapViewer extends GraphicContainer implements FinalizableUIComponent
   {
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MapViewer));
      
      public static var FLAG_CURSOR:Class;
       
      
      private var _finalized:Boolean;
      
      private var _showGrid:Boolean = false;
      
      private var _mapBitmapContainer:Sprite;
      
      private var _mapContainer:Sprite;
      
      private var _arrowContainer:Sprite;
      
      private var _grid:Shape;
      
      private var _areaShapesContainer:Sprite;
      
      private var _groupsContainer:Sprite;
      
      private var _layersContainer:Sprite;
      
      private var _openedMapGroupElement:MapGroupElement;
      
      private var _elementsGraphicRef:Dictionary;
      
      private var _lastMx:int;
      
      private var _lastMy:int;
      
      private var _viewRect:Rectangle;
      
      private var _layers:Array;
      
      private var _mapElements:Array;
      
      private var _dragging:Boolean;
      
      private var _currentMap:Map;
      
      private var _availableMaps:Array;
      
      private var _arrowPool:Array;
      
      private var _arrowAllocation:Dictionary;
      
      private var _reverseArrowAllocation:Dictionary;
      
      private var _mapGroupElements:Dictionary;
      
      private var _lastScaleIconUpdate:Number = -1;
      
      private var _enable3DMode:Boolean = false;
      
      private var _flagCursor:Sprite;
      
      private var _flagCursorVisible:Boolean;
      
      private var _mouseOnArrow:Boolean = false;
      
      private var _zoomLevels:Array;
      
      private var _zoomLevelsPercent:Array;
      
      private var _visibleMapAreas:Vector.<MapArea>;
      
      private var _mapToClear:Map;
      
      public var mapWidth:Number;
      
      public var mapHeight:Number;
      
      public var origineX:int;
      
      public var origineY:int;
      
      public var maxScale:Number = 2;
      
      public var minScale:Number = 0.5;
      
      public var startScale:Number = 0.8;
      
      public var roundCornerRadius:uint = 0;
      
      public var enabledDrag:Boolean = true;
      
      public var autoSizeIcon:Boolean = false;
      
      public var gridLineThickness:Number = 0.5;
      
      private var zz:Number = 1;
      
      private var _lastMouseX:int = 0;
      
      private var _lastMouseY:int = 0;
      
      public function MapViewer()
      {
         this._availableMaps = [];
         this._arrowPool = new Array();
         this._arrowAllocation = new Dictionary();
         this._reverseArrowAllocation = new Dictionary();
         this._mapGroupElements = new Dictionary();
         this._zoomLevels = [];
         super();
         MEMORY_LOG[this] = 1;
         if(AirScanner.hasAir())
         {
            StageShareManager.stage.nativeWindow.addEventListener(Event.DEACTIVATE,this.onWindowDeactivate);
         }
      }
      
      public function get mapContainerBounds() : Rectangle
      {
         return new Rectangle(this._mapContainer.x,this._mapContainer.y,this._mapContainer.width,this._mapContainer.height);
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      public function set finalized(param1:Boolean) : void
      {
         this._finalized = param1;
      }
      
      public function get showGrid() : Boolean
      {
         return this._showGrid;
      }
      
      public function set showGrid(param1:Boolean) : void
      {
         this._showGrid = param1;
         this.drawGrid();
      }
      
      public function get isDragging() : Boolean
      {
         return this._dragging;
      }
      
      public function get visibleMaps() : Rectangle
      {
         var _loc1_:Number = -(this._mapContainer.x / this._mapContainer.scaleX + this.origineX) / this.mapWidth;
         var _loc2_:Number = -(this._mapContainer.y / this._mapContainer.scaleY + this.origineY) / this.mapHeight;
         var _loc3_:Number = width / (this.mapWidth * this._mapContainer.scaleX) - 1;
         var _loc4_:Number = height / (this.mapHeight * this._mapContainer.scaleY) - 1;
         var _loc5_:Number = Math.ceil(_loc3_);
         var _loc6_:Number = Math.ceil(_loc4_);
         return new Rectangle(_loc1_,_loc2_,_loc5_ < 1?Number(1):Number(_loc5_),_loc6_ < 1?Number(1):Number(_loc6_));
      }
      
      public function get currentMouseMapX() : int
      {
         return this._lastMx;
      }
      
      public function get currentMouseMapY() : int
      {
         return this._lastMy;
      }
      
      public function get mapBounds() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle();
         _loc1_.x = Math.floor(-this.origineX / this.mapWidth);
         _loc1_.y = Math.floor(-this.origineY / this.mapHeight);
         if(this._currentMap)
         {
            _loc1_.width = Math.round(this._currentMap.initialWidth / this.mapWidth);
            _loc1_.height = Math.round(this._currentMap.initialHeight / this.mapHeight);
         }
         else
         {
            _loc1_.width = Math.round(this._mapBitmapContainer.width / this.mapWidth);
            _loc1_.height = Math.round(this._mapBitmapContainer.height / this.mapHeight);
         }
         return _loc1_;
      }
      
      public function set mapAlpha(param1:Number) : void
      {
         this._mapBitmapContainer.alpha = param1;
      }
      
      public function get mapPixelPosition() : Point
      {
         return new Point(this._mapContainer.x,this._mapContainer.y);
      }
      
      public function get zoomFactor() : Number
      {
         return Number(this._mapContainer.scaleX.toFixed(2));
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         if(this.finalized)
         {
            this.initMask();
            this.updateVisibleChunck(false);
            this.updateMapElements();
         }
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         if(this.finalized)
         {
            this.initMask();
            this.updateVisibleChunck(false);
            this.updateMapElements();
         }
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         super.width = param1;
         super.height = param2;
         if(this.finalized)
         {
            this.initMask();
            this.updateVisibleChunck(false);
            this.updateMapElements();
         }
      }
      
      public function get zoomStep() : Number
      {
         return this._availableMaps.length > 0?Number(this.maxScale / this._availableMaps.length):Number(NaN);
      }
      
      public function get zoomLevels() : Array
      {
         return this._zoomLevels;
      }
      
      public function get allLayersVisible() : Boolean
      {
         var _loc1_:Sprite = null;
         for each(_loc1_ in this._layers)
         {
            if(!_loc1_.visible)
            {
               return false;
            }
         }
         return true;
      }
      
      public function finalize() : void
      {
         var _loc1_:Texture = null;
         var _loc2_:InteractiveObject = null;
         var _loc3_:int = 0;
         destroy(this._mapBitmapContainer);
         destroy(this._mapContainer);
         destroy(this._areaShapesContainer);
         destroy(this._groupsContainer);
         destroy(this._layersContainer);
         if(this._arrowPool && this._arrowAllocation)
         {
            for each(_loc1_ in this._arrowAllocation)
            {
               this._arrowPool.push(_loc1_);
            }
            this._arrowAllocation = new Dictionary();
         }
         MapElement.removeAllElements(this);
         this._viewRect = new Rectangle();
         this._mapBitmapContainer = new Sprite();
         this._mapBitmapContainer.doubleClickEnabled = true;
         this._mapBitmapContainer.mouseChildren = false;
         this._mapBitmapContainer.mouseEnabled = false;
         this._mapContainer = new Sprite();
         this._mapContainer.doubleClickEnabled = true;
         this._arrowContainer = new Sprite();
         this._arrowContainer.mouseEnabled = false;
         this._grid = new Shape();
         this._areaShapesContainer = new Sprite();
         this._areaShapesContainer.mouseEnabled = false;
         this._groupsContainer = new Sprite();
         this._groupsContainer.mouseEnabled = false;
         this._layersContainer = new Sprite();
         this._layersContainer.doubleClickEnabled = true;
         this._elementsGraphicRef = new Dictionary();
         this._layers = [];
         this._mapElements = [];
         this.initMap();
         this._finalized = true;
         while(_loc3_ < numChildren)
         {
            _loc2_ = getChildAt(_loc3_) as InteractiveObject;
            if(_loc2_)
            {
               _loc2_.doubleClickEnabled = true;
            }
            _loc3_++;
         }
         this.setupZoomLevels(width,height);
         getUi().iAmFinalized(this);
      }
      
      public function setupZoomLevels(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Vector.<Number> = null;
         for each(_loc3_ in this._zoomLevels)
         {
            if(this._currentMap && (this._currentMap.initialWidth * _loc3_ < param1 || this._currentMap.initialHeight * _loc3_ < param2))
            {
               if(!_loc4_)
               {
                  _loc4_ = new Vector.<Number>(0);
               }
               _loc4_.push(_loc3_);
            }
         }
         this._zoomLevelsPercent = [];
         for each(_loc3_ in this._zoomLevels)
         {
            this._zoomLevelsPercent.push(int(_loc3_ * 100));
         }
      }
      
      public function addLayer(param1:String) : void
      {
         var _loc2_:Sprite = null;
         if(!this._layers[param1])
         {
            _loc2_ = new Sprite();
            _loc2_.name = "layer_" + param1;
            _loc2_.mouseEnabled = false;
            _loc2_.doubleClickEnabled = true;
            this._layers[param1] = _loc2_;
         }
         this._layersContainer.addChild(this._layers[param1]);
      }
      
      public function addIcon(param1:String, param2:String, param3:*, param4:int, param5:int, param6:Number = 1, param7:String = null, param8:Boolean = false, param9:int = -1, param10:Boolean = true, param11:Boolean = true) : MapIconElement
      {
         var _loc12_:Texture = null;
         var _loc13_:Number = NaN;
         var _loc14_:MapIconElement = null;
         var _loc15_:DisplayObject = null;
         var _loc16_:Number = NaN;
         var _loc17_:* = 0;
         var _loc18_:* = 0;
         var _loc19_:* = 0;
         var _loc20_:ColorTransform = null;
         if(this._layers[param1] && this.mapBounds.contains(param4,param5))
         {
            if(param3 is String)
            {
               param3 = new Uri(param3);
            }
            (_loc12_ = new Texture()).uri = param3;
            _loc12_.mouseChildren = false;
            if(this.autoSizeIcon && this._lastScaleIconUpdate == this._mapContainer.scaleX)
            {
               _loc15_ = this._mapContainer;
               _loc16_ = this._mapContainer.scaleX;
               while(_loc15_ && _loc15_.parent)
               {
                  _loc15_ = _loc15_.parent;
                  _loc16_ = _loc16_ * _loc15_.scaleX;
               }
               _loc13_ = 1 / _loc16_;
            }
            else
            {
               _loc13_ = Math.min(2,param6);
            }
            _loc12_.scaleX = _loc12_.scaleY = _loc13_;
            if(param9 != -1)
            {
               _loc17_ = param9 >> 16 & 255;
               _loc18_ = param9 >> 8 & 255;
               _loc19_ = param9 >> 0 & 255;
               _loc20_ = new ColorTransform(0.6,0.6,0.6,1,_loc17_ - 80,_loc18_ - 80,_loc19_ - 80);
               _loc12_.transform.colorTransform = _loc20_;
            }
            (_loc14_ = new MapIconElement(param2,param4,param5,param1,_loc12_,param7,this,param11)).canBeGrouped = param10;
            _loc14_.follow = param8;
            this._mapElements.push(_loc14_);
            this._elementsGraphicRef[_loc12_] = _loc14_;
            return _loc14_;
         }
         return null;
      }
      
      public function addAreaShape(param1:String, param2:String, param3:Vector.<int>, param4:uint = 0, param5:Number = 1, param6:uint = 0, param7:Number = 0.4, param8:int = 4) : MapAreaShape
      {
         var _loc9_:MapAreaShape = null;
         var _loc10_:Texture = null;
         var _loc11_:Graphics = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:MapAreaShape = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         if(this._layers[param1] && param3)
         {
            if(_loc9_ = MapAreaShape(MapElement.getElementById(param2,this)))
            {
               if(_loc9_.lineColor == param4 && _loc9_.fillColor == param6)
               {
                  return _loc9_;
               }
               _loc9_.remove();
               this._mapElements.splice(this._mapElements.indexOf(_loc9_),1);
            }
            (_loc10_ = new Texture()).mouseEnabled = false;
            _loc10_.mouseChildren = false;
            (_loc11_ = _loc10_.graphics).lineStyle(param8,param4,param5,true);
            _loc11_.beginFill(param6,param7);
            _loc12_ = param3.length;
            _loc13_ = 0;
            while(_loc13_ < _loc12_)
            {
               _loc15_ = param3[_loc13_];
               _loc16_ = param3[_loc13_ + 1];
               if(_loc15_ > 10000)
               {
                  _loc11_.moveTo((_loc15_ - 11000) * this.mapWidth,(_loc16_ - 11000) * this.mapHeight);
               }
               else
               {
                  _loc11_.lineTo(_loc15_ * this.mapWidth,_loc16_ * this.mapHeight);
               }
               _loc13_ = _loc13_ + 2;
            }
            _loc14_ = new MapAreaShape(param2,param1,_loc10_,this.origineX,this.origineY,param4,param6,this);
            this._mapElements.push(_loc14_);
            return _loc14_;
         }
         return null;
      }
      
      public function areaShapeColorTransform(param1:MapAreaShape, param2:int, param3:Number = 1, param4:Number = 1, param5:Number = 1, param6:Number = 1, param7:Number = 0, param8:Number = 0, param9:Number = 0, param10:Number = 0) : void
      {
         param1.colorTransform(param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      public function getMapElement(param1:String) : MapElement
      {
         var _loc2_:MapElement = null;
         var _loc3_:MapElement = MapElement.getElementById(param1,this);
         if(!_loc3_)
         {
            for each(_loc2_ in this._mapElements)
            {
               if(_loc2_.id == param1)
               {
                  _loc3_ = _loc2_;
                  break;
               }
            }
         }
         return _loc3_;
      }
      
      public function getMapElementsByLayer(param1:String) : Array
      {
         var _loc2_:MapElement = null;
         var _loc5_:int = 0;
         var _loc3_:int = this._mapElements.length;
         var _loc4_:Array = new Array();
         while(_loc5_ < _loc3_)
         {
            _loc2_ = this._mapElements[_loc5_];
            if(_loc2_.layer == param1)
            {
               _loc4_.push(_loc2_);
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function removeMapElement(param1:MapElement) : void
      {
         var _loc2_:MapElement = null;
         var _loc3_:Object = null;
         if(!param1)
         {
            return;
         }
         var _loc4_:int;
         if((_loc4_ = this._mapElements.indexOf(param1)) != -1)
         {
            _loc2_ = this._mapElements[_loc4_];
            if(param1 is MapIconElement)
            {
               _loc3_ = MapIconElement(param1)._texture;
               if(this._mapGroupElements[param1])
               {
                  this._mapGroupElements[param1].icons.splice(this._mapGroupElements[param1].icons.indexOf(_loc3_),1);
                  delete this._mapGroupElements[param1];
               }
               if(this._arrowAllocation[_loc3_] && this._arrowAllocation[_loc3_].parent)
               {
                  this._arrowAllocation[_loc3_].parent.removeChild(this._arrowAllocation[_loc3_]);
                  this._arrowPool.push(this._arrowAllocation[_loc3_]);
                  delete this._reverseArrowAllocation[this._arrowAllocation[_loc3_]];
                  delete this._arrowAllocation[_loc3_];
               }
            }
            _loc2_.remove();
            this._mapElements.splice(_loc4_,1);
         }
      }
      
      public function updateMapElements() : void
      {
         var _loc1_:* = null;
         var _loc2_:MapElement = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:MapGroupElement = null;
         var _loc7_:MapIconElement = null;
         var _loc8_:MapAreaShape = null;
         var _loc9_:Sprite = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         this.updateIconSize();
         for(_loc1_ in this._mapGroupElements)
         {
            delete this._mapGroupElements[_loc1_];
         }
         this.clearLayer();
         this.clearElementsGroups();
         this.clearMapAreaShapes();
         _loc3_ = new Array();
         for each(_loc2_ in this._mapElements)
         {
            if(!_loc3_[_loc2_.x + "_" + _loc2_.y])
            {
               _loc3_[_loc2_.x + "_" + _loc2_.y] = new Array();
            }
            _loc3_[_loc2_.x + "_" + _loc2_.y].push(_loc2_);
         }
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = 0;
            _loc6_ = null;
            for each(_loc2_ in _loc4_)
            {
               if(this._layers[_loc2_.layer].visible)
               {
                  switch(true)
                  {
                     case _loc2_ is MapIconElement:
                        (_loc7_ = _loc2_ as MapIconElement)._texture.x = _loc7_.x * this.mapWidth + this.origineX + this.mapWidth / 2;
                        _loc7_._texture.y = _loc7_.y * this.mapHeight + this.origineY + this.mapHeight / 2;
                        if(_loc4_.length != 1 && _loc7_.canBeGrouped)
                        {
                           if(!_loc6_)
                           {
                              (_loc6_ = new MapGroupElement(this.mapWidth * 0.5,this.mapHeight * 0.5)).x = _loc7_.x * this.mapWidth + this.origineX + this.mapWidth / 2;
                              _loc6_.y = _loc7_.y * this.mapHeight + this.origineY + this.mapHeight / 2;
                              this._groupsContainer.addChild(_loc6_);
                           }
                           this._mapGroupElements[_loc7_] = _loc6_;
                           if(_loc2_.layer != "layer_8")
                           {
                              if((_loc10_ = _loc4_.length) > 2)
                              {
                                 _loc10_ = 2;
                              }
                              _loc11_ = Math.min(_loc10_,_loc5_);
                              _loc7_._texture.x = 4 * _loc11_ - _loc10_ * 4 / 2;
                              _loc7_._texture.y = 4 * _loc11_ - _loc10_ * 4 / 2;
                              _loc6_.addChild(_loc7_._texture);
                           }
                           else
                           {
                              _loc6_.icons.push(_loc7_._texture);
                              this._layers[_loc2_.layer].addChild(_loc7_._texture);
                           }
                        }
                        else
                        {
                           this._layers[_loc2_.layer].addChild(_loc7_._texture);
                        }
                        break;
                     case _loc2_ is MapAreaShape:
                        _loc8_ = _loc2_ as MapAreaShape;
                        if((_loc9_ = this._layers[_loc2_.layer]).parent != this._areaShapesContainer)
                        {
                           this._areaShapesContainer.addChild(_loc9_);
                        }
                        _loc9_.addChild(_loc8_.shape);
                        _loc8_.shape.x = _loc8_.x;
                        _loc8_.shape.y = _loc8_.y;
                  }
                  _loc5_++;
               }
            }
         }
         this.updateIcons();
      }
      
      public function showLayer(param1:String, param2:Boolean = true) : void
      {
         if(this._layers[param1])
         {
            this._layers[param1].visible = param2;
         }
      }
      
      public function showAllLayers(param1:Boolean = true) : void
      {
         var _loc2_:Sprite = null;
         for each(_loc2_ in this._layers)
         {
            _loc2_.visible = param1;
         }
         this.updateMapElements();
      }
      
      public function moveToPixel(param1:int, param2:int, param3:Number) : void
      {
         this._mapContainer.x = param1;
         this._mapContainer.y = param2;
         this._mapContainer.scaleX = param3;
         this._mapContainer.scaleY = param3;
         this.updateVisibleChunck();
      }
      
      public function moveTo(param1:Number, param2:Number, param3:uint = 1, param4:uint = 1, param5:Boolean = true, param6:Boolean = true) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Rectangle;
         if((_loc15_ = this.mapBounds).left > param1)
         {
            param1 = _loc15_.left;
         }
         if(_loc15_.top > param2)
         {
            param2 = _loc15_.top;
         }
         if(param5)
         {
            if((_loc7_ = param3 * this.mapWidth * this._mapContainer.scaleX) > this.width && param6)
            {
               this._mapContainer.scaleX = this.width / (this.mapWidth * param3);
               this._mapContainer.scaleY = this._mapContainer.scaleX;
            }
            if((_loc8_ = param4 * this.mapHeight * this._mapContainer.scaleY) > this.height && param6)
            {
               this._mapContainer.scaleY = this.height / (this.mapHeight * param4);
               this._mapContainer.scaleX = this._mapContainer.scaleY;
            }
            _loc9_ = -(param1 * this.mapWidth + this.origineX) * this._mapContainer.scaleX - this.mapWidth / 2 * this._mapContainer.scaleX;
            _loc10_ = -(param2 * this.mapHeight + this.origineY) * this._mapContainer.scaleY - this.mapHeight / 2 * this._mapContainer.scaleY;
            _loc11_ = this.width / 2;
            _loc12_ = this.height / 2;
            if((_loc13_ = Math.abs(-this._mapContainer.width - _loc9_)) < _loc11_)
            {
               _loc11_ = _loc11_ + (_loc11_ - _loc13_);
            }
            if((_loc14_ = Math.abs(-this._mapContainer.height - _loc10_)) < _loc12_)
            {
               _loc12_ = _loc12_ + (_loc12_ - _loc14_);
            }
            this._mapContainer.x = _loc9_ + _loc11_;
            this._mapContainer.y = _loc10_ + _loc12_;
         }
         else
         {
            this._mapContainer.x = -(param1 * this.mapWidth + this.origineX) * this._mapContainer.scaleX;
            this._mapContainer.y = -(param2 * this.mapHeight + this.origineY) * this._mapContainer.scaleY;
         }
         var _loc16_:Number = !!this._currentMap?Number(this._currentMap.initialWidth):Number(this._mapBitmapContainer.width);
         var _loc17_:Number = !!this._currentMap?Number(this._currentMap.initialHeight):Number(this._mapBitmapContainer.height);
         if(this._mapContainer.x < param3 - _loc16_)
         {
            if(!param5)
            {
               this._mapContainer.x = param3 - _loc16_;
            }
            else
            {
               this._mapContainer.x = 0;
            }
         }
         if(this._mapContainer.y < param4 - _loc17_)
         {
            if(!param5)
            {
               this._mapContainer.y = param4 - _loc17_;
            }
            else
            {
               this._mapContainer.y = 0;
            }
         }
         if(this._mapContainer.x > 0)
         {
            this._mapContainer.x = 0;
         }
         if(this._mapContainer.y > 0)
         {
            this._mapContainer.y = 0;
         }
         this.updateVisibleChunck();
         Berilia.getInstance().handler.process(new MapMoveMessage(this));
      }
      
      private function zoomWithScalePercent(param1:int, param2:Point = null) : void
      {
         this.zoom(param1 / 100,param2);
      }
      
      public function zoom(param1:Number, param2:Point = null) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Rectangle = null;
         var _loc6_:Point = null;
         if(param1 > this.maxScale)
         {
            param1 = this.maxScale;
         }
         if(param1 < this.minScale)
         {
            param1 = this.minScale;
         }
         if(this._currentMap)
         {
            if(this._currentMap.initialWidth * param1 < width)
            {
               param1 = width / this._currentMap.initialWidth;
            }
            if(this._currentMap.initialHeight * param1 < height)
            {
               param1 = height / this._currentMap.initialHeight;
            }
         }
         if(param2)
         {
            if(this._currentMap)
            {
               this._currentMap.currentScale = NaN;
            }
            this._mapContainer.x = this._mapContainer.x - (param2.x * param1 - param2.x * this._mapContainer.scaleX);
            this._mapContainer.y = this._mapContainer.y - (param2.y * param1 - param2.y * this._mapContainer.scaleY);
            this._mapContainer.scaleX = this._mapContainer.scaleY = param1;
            _loc3_ = !!this._currentMap?Number(this._currentMap.initialWidth):Number(this._mapBitmapContainer.width);
            _loc4_ = !!this._currentMap?Number(this._currentMap.initialHeight):Number(this._mapBitmapContainer.height);
            if(this._mapContainer.x < width - _loc3_ * param1)
            {
               this._mapContainer.x = width - _loc3_ * param1;
            }
            if(this._mapContainer.y < height - _loc4_ * param1)
            {
               this._mapContainer.y = height - _loc4_ * param1;
            }
            if(this._mapContainer.x > 0)
            {
               this._mapContainer.x = 0;
            }
            if(this._mapContainer.y > 0)
            {
               this._mapContainer.y = 0;
            }
            this.updateIconSize();
            this.processMapInfo();
            return;
         }
         _loc5_ = this.visibleMaps;
         _loc6_ = new Point((_loc5_.x + _loc5_.width / 2) * this.mapWidth + this.origineX,(_loc5_.y + _loc5_.height / 2) * this.mapHeight + this.origineY);
         this.zoom(param1,_loc6_);
      }
      
      public function addMap(param1:Number, param2:String, param3:uint, param4:uint, param5:uint, param6:uint) : void
      {
         this._availableMaps.push(new Map(param1,param2,new Sprite(),param3,param4,param5,param6));
         if(this._zoomLevels.indexOf(param1) == -1)
         {
            this._zoomLevels.push(param1);
            this._zoomLevels.sort(Array.NUMERIC);
         }
      }
      
      public function removeAllMap() : void
      {
         var _loc1_:Map = null;
         var _loc2_:MapArea = null;
         for each(_loc1_ in this._availableMaps)
         {
            for each(_loc2_ in _loc1_.areas)
            {
               _loc2_.free(true);
            }
         }
         this._availableMaps = [];
         this._zoomLevels.length = 0;
      }
      
      public function getOrigineFromPos(param1:int, param2:int) : Point
      {
         return new Point(-this._mapContainer.x / this._mapContainer.scaleX - param1 * this.mapWidth,-this._mapContainer.y / this._mapContainer.scaleY - param2 * this.mapHeight);
      }
      
      public function set useFlagCursor(param1:Boolean) : void
      {
         var _loc2_:LinkedCursorData = null;
         if(!FLAG_CURSOR)
         {
            return;
         }
         if(param1)
         {
            if(!this._flagCursor)
            {
               this._flagCursor = new Sprite();
               this._flagCursor.addChild(new FLAG_CURSOR());
            }
            _loc2_ = new LinkedCursorData();
            _loc2_.sprite = this._flagCursor;
            _loc2_.offset = new Point();
            Mouse.hide();
            LinkedCursorSpriteManager.getInstance().addItem("mapViewerCursor",_loc2_);
         }
         else
         {
            this.removeCustomCursor();
         }
         this._flagCursorVisible = param1;
      }
      
      public function get useFlagCursor() : Boolean
      {
         return this._flagCursorVisible;
      }
      
      public function get allChunksLoaded() : Boolean
      {
         var _loc1_:MapArea = null;
         if(!this._visibleMapAreas || !this._visibleMapAreas.length)
         {
            return false;
         }
         for each(_loc1_ in this._visibleMapAreas)
         {
            if(!_loc1_.isLoaded)
            {
               return false;
            }
         }
         return true;
      }
      
      private function removeCustomCursor() : void
      {
         Mouse.show();
         LinkedCursorSpriteManager.getInstance().removeItem("mapViewerCursor");
      }
      
      override public function remove() : void
      {
         var _loc1_:MapElement = null;
         var _loc2_:* = null;
         if(!__removed)
         {
            if(this._grid)
            {
               this._grid.cacheAsBitmap = false;
               if(this._mapContainer.contains(this._grid))
               {
                  this._mapContainer.removeChild(this._grid);
               }
            }
            if(this._mapToClear)
            {
               this.clearMap(this._mapToClear);
               this._mapToClear = null;
            }
            this.removeAllMap();
            for each(_loc1_ in MapElement.getOwnerElements(this))
            {
               if(this._mapGroupElements[_loc1_])
               {
                  delete this._mapGroupElements[_loc1_];
               }
               _loc1_.remove();
            }
            for(_loc2_ in this._elementsGraphicRef)
            {
               delete this._elementsGraphicRef[_loc2_];
            }
            this._mapElements = null;
            this._elementsGraphicRef = null;
            this._mapGroupElements = null;
            this._visibleMapAreas = null;
            MapElement._elementRef = new Dictionary(true);
            EnterFrameDispatcher.removeEventListener(this.onMapEnterFrame);
            this.removeCustomCursor();
            if(AirScanner.hasAir())
            {
               StageShareManager.stage.nativeWindow.removeEventListener(Event.DEACTIVATE,this.onWindowDeactivate);
            }
         }
         super.remove();
      }
      
      private function getIconTextureGlobalCoords(param1:MapIconElement) : Point
      {
         var _loc2_:Number = param1.x * this.mapWidth + this.origineX + this.mapWidth / 2;
         var _loc3_:Number = param1.y * this.mapHeight + this.origineY + this.mapHeight / 2;
         var _loc4_:Sprite;
         return (_loc4_ = this._layers[param1.layer] as Sprite).localToGlobal(new Point(_loc2_,_loc3_));
      }
      
      private function updateIcons() : void
      {
         var _loc1_:Texture = null;
         var _loc2_:MapIconElement = null;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc6_:* = false;
         var _loc7_:MapElement = null;
         var _loc8_:Texture = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:* = undefined;
         var _loc13_:Texture = null;
         var _loc14_:Number = NaN;
         var _loc15_:Rectangle = new Rectangle(0,0,1,1);
         var _loc16_:Rectangle = this.visibleMaps;
         var _loc17_:Point = new Point(Math.floor(_loc16_.x + _loc16_.width / 2),Math.floor(_loc16_.y + _loc16_.height / 2));
         var _loc18_:Number = _loc16_.width / 2;
         var _loc19_:* = this.roundCornerRadius > width / 3;
         var _loc20_:Number = width / 2;
         for each(_loc7_ in this._mapElements)
         {
            _loc2_ = _loc7_ as MapIconElement;
            if(_loc2_)
            {
               _loc15_.x = _loc2_.x;
               _loc15_.y = _loc2_.y;
               _loc1_ = _loc2_._texture;
               if(_loc1_)
               {
                  if(_loc2_.follow)
                  {
                     _loc3_ = this.getIconTextureGlobalCoords(_loc2_);
                     if(_loc19_)
                     {
                        _loc4_ = globalToLocal(_loc3_);
                        _loc6_ = (_loc5_ = Math.floor(Math.sqrt(Math.pow(_loc4_.x - _loc20_,2) + Math.pow(_loc4_.y - _loc20_,2)))) < _loc20_;
                     }
                     else
                     {
                        _loc6_ = Boolean(this._mapContainer.mask.getBounds(StageShareManager.stage).containsPoint(_loc3_));
                     }
                  }
                  else
                  {
                     _loc6_ = Boolean(_loc16_.intersects(_loc15_));
                  }
                  _loc1_.visible = this._layers[_loc2_.layer].visible != false && _loc6_;
                  if(_loc1_.visible && !_loc1_.finalized)
                  {
                     _loc1_.finalize();
                  }
                  if(_loc2_.follow)
                  {
                     if(_loc1_.visible && this._arrowAllocation[_loc1_])
                     {
                        this._arrowContainer.removeChild(this._arrowAllocation[_loc1_]);
                        this._arrowPool.push(this._arrowAllocation[_loc1_]);
                        _loc2_.boundsRef = null;
                        delete this._reverseArrowAllocation[this._arrowAllocation[_loc1_]];
                        delete this._arrowAllocation[_loc1_];
                     }
                     else if(_loc2_.follow && !_loc1_.visible)
                     {
                        (_loc13_ = this.getIconArrow(_loc1_)).visible = this._layers[_loc2_.layer].visible;
                        this._arrowContainer.addChild(_loc13_);
                        this._elementsGraphicRef[_loc13_] = _loc2_;
                        _loc2_.boundsRef = _loc13_;
                     }
                  }
               }
            }
         }
         _loc9_ = Math.atan2(0,-width / 2);
         _loc10_ = Math.atan2(width / 2,0) + _loc9_;
         for(_loc12_ in this._arrowAllocation)
         {
            _loc8_ = this._arrowAllocation[_loc12_];
            _loc2_ = this._elementsGraphicRef[_loc12_];
            if(_loc19_)
            {
               _loc3_ = globalToLocal(this.getIconTextureGlobalCoords(_loc2_));
               _loc14_ = Math.atan2(-_loc3_.y + height / 2,-_loc3_.x + width / 2);
            }
            else
            {
               _loc14_ = Math.atan2(-_loc2_.y + _loc17_.y,-_loc2_.x + _loc17_.x);
            }
            _loc8_.x = Math.cos(_loc9_ + _loc14_) * width / 2;
            _loc8_.y = Math.sin(_loc9_ + _loc14_) * height / 2;
            _loc8_.rotation = _loc14_ * (180 / Math.PI);
            if(_loc19_)
            {
               _loc8_.x = _loc8_.x + width / 2;
               _loc8_.y = _loc8_.y + height / 2;
            }
            else
            {
               _loc10_ = _loc8_.y / _loc8_.x;
               if((_loc14_ = _loc14_ + Math.PI) < Math.PI / 4 || _loc14_ > Math.PI * 7 / 4)
               {
                  if((_loc11_ = width / 2 * _loc10_ + height / 2) > 0 && _loc11_ < height)
                  {
                     _loc8_.x = width;
                     _loc8_.y = _loc11_;
                     continue;
                  }
               }
               else if(_loc14_ < Math.PI * 3 / 4)
               {
                  if((_loc11_ = (_loc11_ = Number(height / 2 / _loc10_ + width / 2)) > width?Number(width):Number(_loc11_)) > 0)
                  {
                     _loc8_.x = _loc11_;
                     _loc8_.y = height;
                     continue;
                  }
               }
               else if(_loc14_ < Math.PI * 5 / 4)
               {
                  if((_loc11_ = -width / 2 * _loc10_ + height / 2) > 0 && _loc11_ < height)
                  {
                     _loc8_.x = 0;
                     _loc8_.y = _loc11_;
                     continue;
                  }
               }
               else if((_loc11_ = (_loc11_ = Number(-height / 2 / _loc10_ + width / 2)) > width?Number(width):_loc11_ < 0?Number(0):Number(_loc11_)) >= 0)
               {
                  _loc8_.x = _loc11_;
                  _loc8_.y = 0;
                  continue;
               }
               if(_loc8_.rotation == -45)
               {
                  _loc8_.x = 0;
                  _loc8_.y = _loc11_;
               }
            }
         }
      }
      
      private function getIconArrow(param1:Texture) : Texture
      {
         var _loc2_:Texture = null;
         if(this._arrowAllocation[param1])
         {
            return this._arrowAllocation[param1];
         }
         if(this._arrowPool.length)
         {
            this._arrowAllocation[param1] = this._arrowPool.pop();
         }
         else
         {
            _loc2_ = new Texture();
            _loc2_.uri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path") + "icons/assets.swf|arrow0");
            _loc2_.mouseEnabled = true;
            _loc2_.buttonMode = _loc2_.useHandCursor = true;
            _loc2_.finalize();
            this._arrowAllocation[param1] = _loc2_;
         }
         this._reverseArrowAllocation[this._arrowAllocation[param1]] = param1;
         Texture(this._arrowAllocation[param1]).transform.colorTransform = param1.transform.colorTransform;
         return this._arrowAllocation[param1];
      }
      
      private function processMapInfo() : void
      {
         var _loc1_:Map = null;
         var _loc2_:Number = NaN;
         var _loc3_:Map = null;
         if(!this._availableMaps.length)
         {
            return;
         }
         this._lastScaleIconUpdate = -1;
         var _loc4_:Number = 10000;
         for each(_loc3_ in this._availableMaps)
         {
            _loc2_ = Math.abs(_loc3_.zoom - this._mapContainer.scaleX);
            if(_loc2_ < _loc4_)
            {
               _loc1_ = _loc3_;
               _loc4_ = _loc2_;
            }
         }
         if(!this._currentMap || _loc1_ != this._currentMap)
         {
            if(this._currentMap)
            {
               if(this._mapToClear)
               {
                  this.clearMap(this._mapToClear);
               }
               this._mapToClear = this._currentMap;
            }
            this._currentMap = _loc1_;
            this._mapBitmapContainer.graphics.beginFill(0,0);
            this._mapBitmapContainer.graphics.drawRect(0,0,this._currentMap.initialWidth,this._currentMap.initialHeight);
            this._mapBitmapContainer.graphics.endFill();
            this._mapBitmapContainer.addChild(this._currentMap.container);
            this._viewRect.width = width;
            this._viewRect.height = height;
         }
         this.updateVisibleChunck();
      }
      
      private function updateVisibleChunck(param1:Boolean = true) : void
      {
         if(!this._currentMap || !this._currentMap.areas)
         {
            return;
         }
         if(param1)
         {
            this.updateIcons();
         }
         var _loc2_:uint = 100;
         this._viewRect.x = -this._mapContainer.x / this._mapContainer.scaleX - _loc2_;
         this._viewRect.y = -this._mapContainer.y / this._mapContainer.scaleY - _loc2_;
         this._viewRect.width = width / this._mapContainer.scaleX + _loc2_ * 2;
         this._viewRect.height = height / this._mapContainer.scaleY + _loc2_ * 2;
         this._visibleMapAreas = this._currentMap.loadAreas(this._viewRect);
      }
      
      private function initMask() : void
      {
         if(this._mapContainer.mask)
         {
            this._mapContainer.mask.parent.removeChild(this._mapContainer.mask);
         }
         var _loc1_:Sprite = new Sprite();
         _loc1_.doubleClickEnabled = true;
         _loc1_.graphics.beginFill(7798784,0.3);
         if(!this.roundCornerRadius)
         {
            _loc1_.graphics.drawRect(0,0,width,height);
         }
         else
         {
            _loc1_.graphics.drawRoundRectComplex(0,0,width,height,this.roundCornerRadius,this.roundCornerRadius,this.roundCornerRadius,this.roundCornerRadius);
         }
         addChild(_loc1_);
         this._mapContainer.mask = _loc1_;
      }
      
      private function initMap() : void
      {
         var _loc1_:Sprite = null;
         this._mapContainer = new Sprite();
         this.initMask();
         this._mapContainer.addChild(this._mapBitmapContainer);
         this._grid = new Shape();
         this.drawGrid();
         this._mapContainer.addChild(this._grid);
         this._areaShapesContainer = new Sprite();
         this._areaShapesContainer.mouseEnabled = false;
         this._mapContainer.addChild(this._areaShapesContainer);
         this._groupsContainer = new Sprite();
         this._groupsContainer.mouseEnabled = false;
         this._mapContainer.addChild(this._groupsContainer);
         this._layersContainer = new Sprite();
         this._mapContainer.addChild(this._layersContainer);
         this._layersContainer.mouseEnabled = false;
         if(this._enable3DMode)
         {
            _loc1_ = new Sprite();
            _loc1_.addChild(this._mapContainer);
            _loc1_.rotationX = -30;
            _loc1_.doubleClickEnabled = true;
            addChild(_loc1_);
         }
         else
         {
            addChild(this._mapContainer);
         }
         addChild(this._arrowContainer);
         this._mapElements = new Array();
         this._layers = new Array();
         this._elementsGraphicRef = new Dictionary(true);
         this.zoom(this.startScale);
      }
      
      private function drawGrid() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = this.origineX % this.mapWidth;
         var _loc6_:int = this.origineY % this.mapHeight;
         if(!this._showGrid)
         {
            this._grid.graphics.clear();
         }
         else
         {
            this._grid.cacheAsBitmap = false;
            this._grid.graphics.lineStyle(1,7829367,this.gridLineThickness);
            _loc3_ = this._mapBitmapContainer.width / this.mapWidth;
            _loc1_ = 0;
            while(_loc1_ < _loc3_)
            {
               _loc2_ = _loc1_ * this.mapWidth + _loc5_;
               this._grid.graphics.moveTo(_loc2_,0);
               this._grid.graphics.lineTo(_loc2_,this._mapBitmapContainer.height);
               _loc1_++;
            }
            _loc4_ = this._mapBitmapContainer.height / this.mapHeight;
            _loc1_ = 0;
            while(_loc1_ < _loc4_)
            {
               _loc2_ = _loc1_ * this.mapHeight + _loc6_;
               this._grid.graphics.moveTo(0,_loc2_);
               this._grid.graphics.lineTo(this._mapBitmapContainer.width,_loc2_);
               _loc1_++;
            }
            this._grid.cacheAsBitmap = true;
         }
      }
      
      private function clearLayer(param1:DisplayObjectContainer = null) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObjectContainer = null;
         for each(_loc3_ in this._layers)
         {
            if(!param1 || param1 == _loc3_)
            {
               while(_loc3_.numChildren)
               {
                  _loc2_ = _loc3_.removeChildAt(0);
               }
            }
         }
      }
      
      private function clearElementsGroups() : void
      {
         var _loc1_:MapGroupElement = null;
         while(this._groupsContainer.numChildren > 0)
         {
            _loc1_ = this._groupsContainer.getChildAt(0) as MapGroupElement;
            _loc1_.remove();
            this._groupsContainer.removeChildAt(0);
         }
      }
      
      private function clearMapAreaShapes() : void
      {
         var _loc1_:MapAreaShape = null;
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:int = this._areaShapesContainer.numChildren;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = this._areaShapesContainer.getChildAt(_loc3_) as Sprite;
            while(_loc2_.numChildren)
            {
               _loc1_ = _loc2_.getChildAt(0) as MapAreaShape;
               _loc1_.remove();
               _loc2_.removeChildAt(0);
            }
            _loc3_++;
         }
      }
      
      private function updateIconSize() : void
      {
         var _loc1_:MapIconElement = null;
         var _loc2_:MapElement = null;
         if(!this.autoSizeIcon || this._lastScaleIconUpdate == this._mapContainer.scaleX)
         {
            return;
         }
         this._lastScaleIconUpdate = this._mapContainer.scaleX;
         var _loc3_:DisplayObject = this._mapContainer;
         var _loc4_:Number = this._mapContainer.scaleX;
         while(_loc3_ && _loc3_.parent)
         {
            _loc3_ = _loc3_.parent;
            _loc4_ = _loc4_ * _loc3_.scaleX;
         }
         for each(_loc2_ in this._mapElements)
         {
            _loc1_ = _loc2_ as MapIconElement;
            if(!(!_loc1_ || !_loc1_.canBeAutoSize))
            {
               _loc1_._texture.scaleX = _loc1_._texture.scaleY = 1 / _loc4_;
            }
         }
      }
      
      private function forceMapRollOver() : void
      {
         this._mouseOnArrow = false;
         Berilia.getInstance().handler.process(new MapRollOverMessage(this,Math.floor((this._mapBitmapContainer.mouseX - this.origineX) / this.mapWidth),Math.floor((this._mapBitmapContainer.mouseY - this.origineY) / this.mapHeight)));
      }
      
      private function clearMap(param1:Map) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = param1.areas.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1.areas[_loc2_].free();
            _loc2_++;
         }
         if(param1.container.parent == this._mapBitmapContainer)
         {
            this._mapBitmapContainer.removeChild(param1.container);
         }
         param1 = null;
      }
      
      override public function process(param1:Message) : Boolean
      {
         var _loc2_:MouseOverMessage = null;
         var _loc3_:MouseOutMessage = null;
         var _loc4_:MouseClickMessage = null;
         var _loc5_:MouseWheelMessage = null;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         var _loc8_:MouseRightClickMessage = null;
         var _loc9_:MapElement = null;
         switch(true)
         {
            case param1 is MouseOverMessage:
               _loc2_ = param1 as MouseOverMessage;
               if(_loc2_.target == this || _loc2_.target.parent == this || _loc2_.target.parent != this._arrowContainer && _loc2_.target.parent.parent == this)
               {
                  if(!EnterFrameDispatcher.hasEventListener(this.onMapEnterFrame))
                  {
                     EnterFrameDispatcher.addEventListener(this.onMapEnterFrame,"mapMouse");
                  }
                  return false;
               }
               this._mouseOnArrow = _loc2_.target.parent == this._arrowContainer?true:false;
               if(_loc2_.target is MapGroupElement || _loc2_.target.parent is MapGroupElement && this._openedMapGroupElement != _loc2_.target.parent || this._mapGroupElements[this._elementsGraphicRef[_loc2_.target]] is MapGroupElement && this._openedMapGroupElement != this._mapGroupElements[this._elementsGraphicRef[_loc2_.target]])
               {
                  if(_loc2_.target is MapGroupElement)
                  {
                     this._openedMapGroupElement = MapGroupElement(_loc2_.target);
                  }
                  else if(_loc2_.target.parent is MapGroupElement)
                  {
                     this._openedMapGroupElement = MapGroupElement(_loc2_.target.parent);
                  }
                  else if(!this._mouseOnArrow)
                  {
                     this._openedMapGroupElement = this._mapGroupElements[this._elementsGraphicRef[_loc2_.target]];
                  }
                  else
                  {
                     this._openedMapGroupElement = null;
                  }
                  if(this._openedMapGroupElement && !this._openedMapGroupElement.opened && this._openedMapGroupElement.icons.length > 1)
                  {
                     this._openedMapGroupElement.open();
                  }
                  if(!(_loc2_.target is MapGroupElement) && (!this._openedMapGroupElement || this._openedMapGroupElement.icons.length > 1))
                  {
                     Berilia.getInstance().handler.process(new MapElementRollOverMessage(this,this._elementsGraphicRef[_loc2_.target]));
                  }
               }
               else if(this._elementsGraphicRef[_loc2_.target])
               {
                  Berilia.getInstance().handler.process(new MapElementRollOverMessage(this,this._elementsGraphicRef[_loc2_.target]));
               }
               else if(this._reverseArrowAllocation[_loc2_.target] && this._elementsGraphicRef[this._reverseArrowAllocation[_loc2_.target]])
               {
                  Berilia.getInstance().handler.process(new MapElementRollOverMessage(this,this._elementsGraphicRef[this._reverseArrowAllocation[_loc2_.target]]));
               }
               break;
            case param1 is MouseOutMessage:
               _loc3_ = param1 as MouseOutMessage;
               if(_loc3_.target == this || _loc3_.target.parent == this || _loc3_.target.parent != this._arrowContainer && _loc3_.target.parent.parent == this)
               {
                  if(!this._dragging && EnterFrameDispatcher.hasEventListener(this.onMapEnterFrame))
                  {
                     EnterFrameDispatcher.removeEventListener(this.onMapEnterFrame);
                  }
                  return false;
               }
               this._mouseOnArrow = false;
               if(_loc3_.mouseEvent.relatedObject && _loc3_.mouseEvent.relatedObject.parent != this._openedMapGroupElement && _loc3_.mouseEvent.relatedObject != this._openedMapGroupElement && this._mapGroupElements[this._elementsGraphicRef[_loc3_.mouseEvent.relatedObject]] != this._openedMapGroupElement && this._openedMapGroupElement && this._openedMapGroupElement.opened)
               {
                  this._openedMapGroupElement.close();
                  this._openedMapGroupElement = null;
                  this.forceMapRollOver();
               }
               if(this._elementsGraphicRef[_loc3_.target])
               {
                  Berilia.getInstance().handler.process(new MapElementRollOutMessage(this,this._elementsGraphicRef[_loc3_.target]));
               }
               else if(this._reverseArrowAllocation[_loc3_.target] && this._elementsGraphicRef[this._reverseArrowAllocation[_loc3_.target]])
               {
                  Berilia.getInstance().handler.process(new MapElementRollOutMessage(this,this._elementsGraphicRef[this._reverseArrowAllocation[_loc3_.target]]));
               }
               break;
            case param1 is MouseDownMessage:
               if(!this.enabledDrag)
               {
                  return false;
               }
               if(!this._enable3DMode)
               {
                  this._mapContainer.startDrag(false,new Rectangle(width - this._currentMap.initialWidth * this._mapContainer.scaleX,height - this._currentMap.initialHeight * this._mapContainer.scaleY,this._currentMap.initialWidth * this._mapContainer.scaleX - width,this._currentMap.initialHeight * this._mapContainer.scaleY - height));
               }
               this._dragging = true;
               return false;
               break;
            case param1 is MouseClickMessage:
               _loc4_ = param1 as MouseClickMessage;
               if(this._reverseArrowAllocation[_loc4_.target])
               {
                  TooltipManager.hide();
                  _loc9_ = this._elementsGraphicRef[this._reverseArrowAllocation[_loc4_.target]];
                  this.moveTo(_loc9_.x,_loc9_.y);
               }
               break;
            case param1 is MouseReleaseOutsideMessage:
            case param1 is MouseUpMessage:
               if(!this._enable3DMode)
               {
                  this._mapContainer.stopDrag();
               }
               this._dragging = false;
               this._lastMouseX = 0;
               this.updateVisibleChunck();
               Berilia.getInstance().handler.process(new MapMoveMessage(this));
               return false;
            case param1 is MouseWheelMessage:
               _loc5_ = param1 as MouseWheelMessage;
               _loc6_ = this._mapContainer.scaleX * 100 + (_loc5_.mouseEvent.delta > 0?100:-100) * this.zoomStep;
               _loc7_ = new Point(_loc5_.mouseEvent.localX,_loc5_.mouseEvent.localY);
               switch(true)
               {
                  case _loc5_.mouseEvent.target.parent is MapGroupElement:
                     _loc7_.x = _loc5_.mouseEvent.target.parent.x;
                     _loc7_.y = _loc5_.mouseEvent.target.parent.y;
                     break;
                  case _loc5_.mouseEvent.target is MapGroupElement:
                  case _loc5_.mouseEvent.target is Texture:
                     _loc7_.x = _loc5_.mouseEvent.target.x;
                     _loc7_.y = _loc5_.mouseEvent.target.y;
               }
               this.zoomWithScalePercent(_loc6_,_loc7_);
               Berilia.getInstance().handler.process(new MapMoveMessage(this));
               return true;
            case param1 is MouseRightClickMessage:
               _loc8_ = param1 as MouseRightClickMessage;
               if(this._elementsGraphicRef[_loc8_.target])
               {
                  Berilia.getInstance().handler.process(new MapElementRightClickMessage(this,this._elementsGraphicRef[_loc8_.target]));
               }
               else if(this._reverseArrowAllocation[_loc8_.target] && this._elementsGraphicRef[this._reverseArrowAllocation[_loc8_.target]])
               {
                  Berilia.getInstance().handler.process(new MapElementRightClickMessage(this,this._elementsGraphicRef[this._reverseArrowAllocation[_loc8_.target]]));
               }
               return false;
         }
         return false;
      }
      
      private function onMapEnterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._mapToClear && this.allChunksLoaded)
         {
            this.clearMap(this._mapToClear);
            this._mapToClear = null;
         }
         if(this._dragging && (this._lastMouseX != StageShareManager.mouseX || this._lastMouseY != StageShareManager.mouseY))
         {
            if(this._enable3DMode && this._lastMouseX)
            {
               this._mapContainer.x = this._mapContainer.x - (StageShareManager.mouseX - this._lastMouseX);
               this._mapContainer.y = this._mapContainer.y - (StageShareManager.mouseY - this._lastMouseY);
            }
            this.updateVisibleChunck();
            this._lastMouseX = StageShareManager.mouseX;
            this._lastMouseY = StageShareManager.mouseY;
         }
         var _loc4_:int = this.mouseX;
         var _loc5_:int = this.mouseY;
         if(_loc4_ > 0 && _loc4_ < __width && _loc5_ > 0 && _loc5_ < __height)
         {
            _loc2_ = Math.floor((this._mapBitmapContainer.mouseX - this.origineX) / this.mapWidth);
            _loc3_ = Math.floor((this._mapBitmapContainer.mouseY - this.origineY) / this.mapHeight);
            if((!this._openedMapGroupElement || !this._openedMapGroupElement.opened) && !this._mouseOnArrow && (_loc2_ != this._lastMx || _loc3_ != this._lastMy))
            {
               this._lastMx = _loc2_;
               this._lastMy = _loc3_;
               Berilia.getInstance().handler.process(new MapRollOverMessage(this,_loc2_,_loc3_));
            }
         }
      }
      
      private function onWindowDeactivate(param1:Event) : void
      {
         if(this._dragging)
         {
            this.process(new MouseUpMessage());
         }
      }
   }
}
