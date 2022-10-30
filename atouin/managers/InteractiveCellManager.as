package com.ankamagames.atouin.managers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.data.map.Layer;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.CellOutMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.renderers.TrapZoneRenderer;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.types.CellContainer;
   import com.ankamagames.atouin.types.CellReference;
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.atouin.types.DebugToolTip;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.atouin.types.LayerContainer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.CellIdConverter;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   
   public class InteractiveCellManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(InteractiveCellManager));
      
      private static var _self:InteractiveCellManager;
       
      
      private var _cellOverEnabled:Boolean = false;
      
      private var _aCells:Array;
      
      private var _aCellPool:Array;
      
      private var _bShowGrid:Boolean;
      
      private var _interaction_click:Boolean;
      
      private var _interaction_out:Boolean;
      
      private var _trapZoneRenderer:TrapZoneRenderer;
      
      public function InteractiveCellManager()
      {
         this._aCellPool = new Array();
         this._bShowGrid = Atouin.getInstance().options.alwaysShowGrid;
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this.init();
      }
      
      public static function getInstance() : InteractiveCellManager
      {
         if(!_self)
         {
            _self = new InteractiveCellManager();
         }
         return _self;
      }
      
      public function get cellOverEnabled() : Boolean
      {
         return this._cellOverEnabled;
      }
      
      public function set cellOverEnabled(param1:Boolean) : void
      {
         this.overStateChanged(this._cellOverEnabled,param1);
         this._cellOverEnabled = param1;
      }
      
      public function get cellOutEnabled() : Boolean
      {
         return this._interaction_out;
      }
      
      public function get cellClickEnabled() : Boolean
      {
         return this._interaction_click;
      }
      
      public function initManager() : void
      {
         this._aCells = new Array();
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
      }
      
      public function setInteraction(param1:Boolean = true, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:GraphicCell = null;
         this._interaction_click = param1;
         this._cellOverEnabled = param2;
         this._interaction_out = param3;
         for each(_loc4_ in this._aCells)
         {
            if(param1)
            {
               _loc4_.addEventListener(MouseEvent.CLICK,this.mouseClick);
            }
            else
            {
               _loc4_.removeEventListener(MouseEvent.CLICK,this.mouseClick);
            }
            if(param2)
            {
               _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            }
            else
            {
               _loc4_.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            }
            if(param3)
            {
               _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            }
            else
            {
               _loc4_.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            }
            _loc4_.mouseEnabled = param1 || param2 || param3;
         }
      }
      
      public function getCell(param1:uint) : GraphicCell
      {
         this._aCells[param1] = this._aCellPool[param1];
         return this._aCells[param1];
      }
      
      public function updateInteractiveCell(param1:DataMapContainer) : void
      {
         var _loc2_:CellReference = null;
         var _loc3_:GraphicCell = null;
         var _loc4_:DisplayObject = null;
         var _loc7_:Number = NaN;
         var _loc9_:uint = 0;
         var _loc11_:uint = 0;
         if(!param1)
         {
            _log.error("Can\'t update interactive cell of a NULL container");
            return;
         }
         this.setInteraction(true,Atouin.getInstance().options.showCellIdOnOver,Atouin.getInstance().options.showCellIdOnOver);
         var _loc5_:Array = param1.getCell();
         var _loc6_:Boolean = Atouin.getInstance().options.showTransitions;
         _loc7_ = this._bShowGrid || Atouin.getInstance().options.alwaysShowGrid?Number(1):Number(0);
         var _loc8_:LayerContainer = param1.getLayer(Layer.LAYER_DECOR);
         var _loc10_:uint = this._aCells.length;
         var _loc12_:GraphicCell;
         if(!(_loc12_ = this._aCells[0]))
         {
            while(!_loc12_ && _loc9_ < _loc10_)
            {
               _loc12_ = this._aCells[_loc9_++];
            }
            _loc9_--;
         }
         while(_loc11_ < _loc8_.numChildren && _loc9_ < _loc10_)
         {
            if(_loc12_ != null && _loc12_.cellId <= CellContainer(_loc8_.getChildAt(_loc11_)).cellId)
            {
               _loc2_ = _loc5_[_loc9_];
               _loc3_ = this._aCells[_loc9_];
               _loc3_.y = _loc2_.elevation;
               _loc3_.visible = _loc2_.mov && !_loc2_.isDisabled;
               _loc3_.alpha = _loc7_;
               _loc8_.addChildAt(_loc3_,_loc11_);
               _loc12_ = this._aCells[++_loc9_];
            }
            _loc11_++;
         }
      }
      
      public function updateCell(param1:uint, param2:Boolean) : Boolean
      {
         DataMapProvider.getInstance().updateCellMovLov(param1,param2);
         if(this._aCells[param1] != null)
         {
            this._aCells[param1].visible = param2;
            return true;
         }
         return false;
      }
      
      public function show(param1:Boolean, param2:Boolean = false) : void
      {
         var _loc3_:GraphicCell = null;
         var _loc6_:uint = 0;
         this._bShowGrid = param1;
         var _loc4_:Number = this._bShowGrid || Atouin.getInstance().options.alwaysShowGrid?Number(1):Number(0);
         var _loc5_:Array = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells;
         while(_loc6_ < this._aCells.length)
         {
            _loc3_ = GraphicCell(this._aCells[_loc6_]);
            if(_loc3_)
            {
               if((param2 || this._cellOverEnabled) && _loc4_ == 1 && _loc5_[_loc6_].nonWalkableDuringFight)
               {
                  _loc3_.alpha = 0;
               }
               else
               {
                  _loc3_.alpha = _loc4_;
               }
            }
            _loc6_++;
         }
      }
      
      public function clean() : void
      {
         var _loc1_:uint = 0;
         if(this._aCells)
         {
            _loc1_ = 0;
            while(_loc1_ < this._aCells.length)
            {
               if(!(!this._aCells[_loc1_] || !this._aCells[_loc1_].parent))
               {
                  this._aCells[_loc1_].parent.removeChild(this._aCells[_loc1_]);
               }
               _loc1_++;
            }
         }
      }
      
      private function init() : void
      {
         var _loc1_:GraphicCell = null;
         var _loc2_:uint = 0;
         while(_loc2_ < AtouinConstants.MAP_CELLS_COUNT)
         {
            _loc1_ = new GraphicCell(_loc2_);
            _loc1_.mouseEnabled = false;
            _loc1_.mouseChildren = false;
            this._aCellPool[_loc2_] = _loc1_;
            _loc2_++;
         }
      }
      
      private function overStateChanged(param1:Boolean, param2:Boolean) : void
      {
         if(param1 == param2)
         {
            return;
         }
         if(!param1 && param2)
         {
            this.registerOver(true);
         }
         else if(param1 && !param2)
         {
            this.registerOver(false);
         }
      }
      
      private function registerOver(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < AtouinConstants.MAP_CELLS_COUNT)
         {
            if(this._aCells[_loc2_])
            {
               if(param1)
               {
                  this._aCells[_loc2_].addEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
                  this._aCells[_loc2_].addEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
               }
               else
               {
                  this._aCells[_loc2_].removeEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
                  this._aCells[_loc2_].removeEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
               }
            }
            _loc2_++;
         }
      }
      
      private function mouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:IEntity = null;
         var _loc4_:CellClickMessage = null;
         var _loc5_:Sprite;
         if(!(_loc5_ = Sprite(param1.target)).parent)
         {
            return;
         }
         var _loc6_:int = _loc5_.parent.getChildIndex(_loc5_);
         var _loc7_:Point = CellIdConverter.cellIdToCoord(parseInt(_loc5_.name));
         if(!DataMapProvider.getInstance().pointCanStop(_loc7_.x,_loc7_.y))
         {
            _log.info("Cannot move to this cell in RP");
            return;
         }
         if(Atouin.getInstance().options.virtualPlayerJump)
         {
            _loc2_ = EntitiesManager.getInstance().entities;
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_ is IMovable)
               {
                  IMovable(_loc3_).jump(MapPoint.fromCellId(parseInt(_loc5_.name)));
                  break;
               }
            }
         }
         else
         {
            (_loc4_ = new CellClickMessage()).cellContainer = _loc5_;
            _loc4_.cellDepth = _loc6_;
            _loc4_.cell = MapPoint.fromCoords(_loc7_.x,_loc7_.y);
            _loc4_.cellId = parseInt(_loc5_.name);
            Atouin.getInstance().handler.process(_loc4_);
         }
      }
      
      private function mouseOver(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:* = null;
         var _loc4_:MapPoint = null;
         var _loc5_:CellData = null;
         var _loc6_:Selection = null;
         var _loc7_:Sprite;
         if(!(_loc7_ = Sprite(param1.target)).parent)
         {
            return;
         }
         var _loc8_:int = _loc7_.parent.getChildIndex(_loc7_);
         var _loc9_:Point = CellIdConverter.cellIdToCoord(parseInt(_loc7_.name));
         if(Atouin.getInstance().options.showCellIdOnOver)
         {
            _loc2_ = 0;
            _loc3_ = _loc7_.name + " (" + _loc9_.x + "/" + _loc9_.y + ")";
            _loc4_ = MapPoint.fromCoords(_loc9_.x,_loc9_.y);
            _loc3_ = _loc3_ + ("\nLigne de vue : " + !DataMapProvider.getInstance().pointLos(_loc4_.x,_loc4_.y));
            _loc3_ = _loc3_ + ("\nBlocage éditeur : " + !DataMapProvider.getInstance().pointMov(_loc4_.x,_loc4_.y));
            _loc3_ = _loc3_ + ("\nBlocage entitée : " + !DataMapProvider.getInstance().pointMov(_loc4_.x,_loc4_.y,false));
            _loc5_ = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[parseInt(_loc7_.name)]);
            _loc3_ = _loc3_ + ("\nForcage fleche bas : " + _loc5_.useBottomArrow);
            _loc3_ = _loc3_ + ("\nForcage fleche haut : " + _loc5_.useTopArrow);
            _loc3_ = _loc3_ + ("\nForcage fleche droite : " + _loc5_.useRightArrow);
            _loc3_ = _loc3_ + ("\nForcage fleche gauche : " + _loc5_.useLeftArrow);
            _loc3_ = _loc3_ + ("\nID de zone : " + _loc5_.moveZone);
            _loc3_ = _loc3_ + ("\nHauteur : " + _loc5_.floor + " px");
            _loc3_ = _loc3_ + ("\nSpeed : " + _loc5_.speed);
            DebugToolTip.getInstance().text = _loc3_;
            if(!(_loc6_ = SelectionManager.getInstance().getSelection("infoOverCell")))
            {
               (_loc6_ = new Selection()).color = new Color(_loc2_);
               _loc6_.renderer = new ZoneDARenderer();
               _loc6_.zone = new Lozenge(0,0,DataMapProvider.getInstance());
               SelectionManager.getInstance().addSelection(_loc6_,"infoOverCell",parseInt(_loc7_.name));
            }
            else
            {
               SelectionManager.getInstance().update("infoOverCell",parseInt(_loc7_.name));
            }
            StageShareManager.stage.addChild(DebugToolTip.getInstance());
         }
         var _loc10_:CellOverMessage;
         (_loc10_ = new CellOverMessage()).cellContainer = _loc7_;
         _loc10_.cellDepth = _loc8_;
         _loc10_.cell = MapPoint.fromCoords(_loc9_.x,_loc9_.y);
         _loc10_.cellId = parseInt(_loc7_.name);
         Atouin.getInstance().handler.process(_loc10_);
      }
      
      private function mouseOut(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = Sprite(param1.target);
         if(!_loc2_.parent)
         {
            return;
         }
         var _loc3_:int = _loc2_.parent.getChildIndex(_loc2_);
         var _loc4_:Point = CellIdConverter.cellIdToCoord(parseInt(_loc2_.name));
         if(Atouin.getInstance().worldContainer.contains(DebugToolTip.getInstance()))
         {
            Atouin.getInstance().worldContainer.removeChild(DebugToolTip.getInstance());
         }
         var _loc5_:CellOutMessage;
         (_loc5_ = new CellOutMessage()).cellContainer = _loc2_;
         _loc5_.cellDepth = _loc3_;
         _loc5_.cell = MapPoint.fromCoords(_loc4_.x,_loc4_.y);
         _loc5_.cellId = parseInt(_loc2_.name);
         Atouin.getInstance().handler.process(_loc5_);
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.propertyName == "alwaysShowGrid")
         {
            this.show(param1.propertyValue);
         }
      }
   }
}
