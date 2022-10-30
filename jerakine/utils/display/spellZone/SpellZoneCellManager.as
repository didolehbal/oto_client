package com.ankamagames.jerakine.utils.display.spellZone
{
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Cone;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.jerakine.types.zones.HalfLozenge;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.types.zones.Line;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.types.zones.Square;
   import flash.display.Sprite;
   
   public class SpellZoneCellManager extends Sprite
   {
      
      public static const RANGE_COLOR:uint = 65280;
      
      public static const CHARACTER_COLOR:uint = 16711680;
      
      public static const SPELL_COLOR:uint = 255;
       
      
      private var _centerCell:SpellZoneCell;
      
      public var cells:Vector.<SpellZoneCell>;
      
      private var _spellLevel:ICellZoneProvider;
      
      private var _spellCellsId:Vector.<uint>;
      
      private var _rollOverCell:SpellZoneCell;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _paddingTop:uint;
      
      private var _paddingLeft:uint;
      
      private var _zoneDisplay:Sprite;
      
      public function SpellZoneCellManager()
      {
         super();
         this._zoneDisplay = new Sprite();
         addChild(this._zoneDisplay);
         this.cells = new Vector.<SpellZoneCell>();
         this._spellCellsId = new Vector.<uint>();
      }
      
      public function setDisplayZone(param1:uint, param2:uint) : void
      {
         this._width = param1;
         this._height = param2;
      }
      
      public function set spellLevel(param1:ICellZoneProvider) : void
      {
         this._spellLevel = param1;
      }
      
      private function addListeners() : void
      {
         addEventListener(SpellZoneEvent.CELL_ROLLOVER,this.onCellRollOver);
         addEventListener(SpellZoneEvent.CELL_ROLLOUT,this.onCellRollOut);
      }
      
      private function removeListeners() : void
      {
         removeEventListener(SpellZoneEvent.CELL_ROLLOVER,this.onCellRollOver);
         removeEventListener(SpellZoneEvent.CELL_ROLLOUT,this.onCellRollOut);
      }
      
      private function onCellRollOver(param1:SpellZoneEvent) : void
      {
         this._rollOverCell = param1.cell;
         this.showSpellZone(param1.cell);
      }
      
      private function onCellRollOut(param1:SpellZoneEvent) : void
      {
         this.setLastSpellCellToNormal();
      }
      
      public function showSpellZone(param1:SpellZoneCell) : void
      {
         if(this._spellCellsId.length > 0)
         {
            this.setLastSpellCellToNormal();
         }
         this._spellCellsId = this.getSpellZone().getCells(param1.cellId);
         this.setSpellZone(this._spellCellsId);
      }
      
      private function setLastSpellCellToNormal() : void
      {
         var _loc1_:SpellZoneCell = null;
         var _loc2_:uint = 0;
         for each(_loc1_ in this.cells)
         {
            for each(_loc2_ in this._spellCellsId)
            {
               if(_loc2_ == _loc1_.cellId)
               {
                  _loc1_.changeColorToDefault();
               }
            }
         }
      }
      
      private function resetCells() : void
      {
         var _loc1_:SpellZoneCell = null;
         for each(_loc1_ in this.cells)
         {
            _loc1_.setNormalCell();
         }
      }
      
      public function show() : void
      {
         var _loc1_:IZone = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:IDataMapProvider = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:SpellZoneCell = null;
         if(this._spellLevel == null)
         {
            return;
         }
         this.resetCells();
         if(this._spellLevel.castZoneInLine)
         {
            _loc1_ = new Cross(this._spellLevel.minimalRange,this._spellLevel.maximalRange,_loc7_);
         }
         else
         {
            _loc1_ = new Lozenge(this._spellLevel.minimalRange,this._spellLevel.maximalRange,_loc7_);
         }
         if(this.cells.length == 0)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc5_ = 40;
            _loc4_ = 14;
            _loc6_ = 0;
            _loc8_ = this._width / (_loc4_ + 0.5);
            _loc9_ = this._height / (_loc5_ / 2 + 0.5);
            _loc10_ = 0;
            while(_loc10_ < _loc5_)
            {
               _loc2_ = Math.ceil(_loc10_ / 2);
               _loc3_ = -Math.floor(_loc10_ / 2);
               _loc11_ = 0;
               while(_loc11_ < _loc4_)
               {
                  if((_loc12_ = new SpellZoneCell(_loc8_,_loc9_,MapPoint.fromCoords(_loc2_,_loc3_).cellId)).cellId == SpellZoneConstant.CENTER_CELL_ID + _loc6_)
                  {
                     this._centerCell = _loc12_;
                  }
                  else
                  {
                     _loc12_.changeColorToDefault();
                  }
                  _loc12_.addEventListener(SpellZoneEvent.CELL_ROLLOVER,this.onCellRollOver);
                  _loc12_.addEventListener(SpellZoneEvent.CELL_ROLLOUT,this.onCellRollOut);
                  this.cells.push(_loc12_);
                  _loc12_.posX = _loc2_;
                  _loc12_.posY = _loc3_;
                  if(_loc10_ == 0 || _loc10_ % 2 == 0)
                  {
                     _loc12_.x = _loc11_ * _loc8_;
                  }
                  else
                  {
                     _loc12_.x = _loc11_ * _loc8_ + _loc8_ / 2;
                  }
                  _loc12_.y = _loc10_ * _loc9_ / 2;
                  this._zoneDisplay.addChild(_loc12_);
                  _loc2_++;
                  _loc3_++;
                  _loc11_++;
               }
               _loc10_++;
            }
         }
         this.colorCell(this._centerCell,CHARACTER_COLOR,true);
         var _loc13_:Number = 14.5 / (1 + Math.ceil(this._spellLevel.maximalRange) + Math.ceil(this.getSpellZone().radius));
         this._zoneDisplay.scaleX = this._zoneDisplay.scaleY = _loc13_;
         this._zoneDisplay.x = (this._width - this._zoneDisplay.width) / 2 + 0.5 / 14.5 * this._zoneDisplay.width / 2;
         this._zoneDisplay.y = (this._height - this._zoneDisplay.height) / 2 + 0.5 / 20.5 * this._zoneDisplay.height / 2;
         if(this._centerCell)
         {
            this.setRangedCells(_loc1_.getCells(this._centerCell.cellId));
         }
         if(mask != null)
         {
            return;
         }
         var _loc14_:Sprite;
         (_loc14_ = new Sprite()).graphics.beginFill(16711680);
         _loc14_.graphics.drawRoundRect(0,0,this._width,this._height - 3,30,30);
         addChild(_loc14_);
         this.mask = _loc14_;
      }
      
      private function isInSpellArea(param1:SpellZoneCell, param2:Lozenge) : Boolean
      {
         var _loc3_:uint = 0;
         if(param2 == null)
         {
            return false;
         }
         var _loc4_:Vector.<uint> = param2.getCells(this._centerCell.cellId);
         for each(_loc3_ in _loc4_)
         {
            if(_loc3_ == param1.cellId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function remove() : void
      {
         var _loc1_:SpellZoneCell = null;
         var _loc2_:uint = this.cells.length;
         var _loc3_:uint = _loc2_;
         while(_loc3_ > 0)
         {
            _loc1_ = this.cells.pop();
            this._zoneDisplay.removeChild(_loc1_);
            _loc1_ = null;
            _loc3_--;
         }
      }
      
      public function setRangedCells(param1:Vector.<uint>) : void
      {
         var _loc2_:SpellZoneCell = null;
         var _loc3_:uint = 0;
         for each(_loc2_ in this.cells)
         {
            for each(_loc3_ in param1)
            {
               if(_loc3_ == _loc2_.cellId)
               {
                  _loc2_.setRangeCell();
               }
            }
         }
      }
      
      public function setSpellZone(param1:Vector.<uint>) : void
      {
         var _loc2_:SpellZoneCell = null;
         var _loc3_:uint = 0;
         for each(_loc2_ in this.cells)
         {
            for each(_loc3_ in param1)
            {
               if(_loc3_ == _loc2_.cellId)
               {
                  _loc2_.setSpellCell();
               }
            }
         }
      }
      
      public function colorCell(param1:SpellZoneCell, param2:uint, param3:Boolean = false) : void
      {
         param1.colorCell(param2,param3);
      }
      
      public function colorCells(param1:Vector.<uint>, param2:uint, param3:Boolean = false) : void
      {
         var _loc4_:SpellZoneCell = null;
         var _loc5_:uint = 0;
         for each(_loc4_ in this.cells)
         {
            for each(_loc5_ in param1)
            {
               if(_loc5_ == _loc4_.cellId)
               {
                  this.colorCell(_loc4_,param2,param3);
               }
            }
         }
      }
      
      private function getSpellZone() : IZone
      {
         var _loc1_:uint = 0;
         var _loc2_:IDataMapProvider = null;
         var _loc3_:IZoneShape = null;
         var _loc4_:IZone = null;
         var _loc5_:Line = null;
         var _loc6_:Cross = null;
         var _loc7_:Square = null;
         var _loc8_:Cross = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:uint = 88;
         _loc1_ = 0;
         for each(_loc3_ in this._spellLevel.spellZoneEffects)
         {
            if(_loc3_.zoneShape != 0 && _loc3_.zoneSize < 63 && (_loc3_.zoneSize > _loc1_ || _loc3_.zoneSize == _loc1_ && _loc11_ == SpellShapeEnum.P))
            {
               _loc1_ = _loc3_.zoneSize;
               _loc11_ = _loc3_.zoneShape;
            }
         }
         switch(_loc11_)
         {
            case SpellShapeEnum.X:
               _loc4_ = new Cross(0,_loc1_,_loc2_);
               break;
            case SpellShapeEnum.L:
               _loc4_ = _loc5_ = new Line(_loc1_,_loc2_);
               break;
            case SpellShapeEnum.T:
               (_loc6_ = new Cross(0,_loc1_,_loc2_)).onlyPerpendicular = true;
               _loc4_ = _loc6_;
               break;
            case SpellShapeEnum.D:
               _loc4_ = new Cross(0,_loc1_,_loc2_);
               break;
            case SpellShapeEnum.C:
               _loc4_ = new Lozenge(0,_loc1_,_loc2_);
               break;
            case SpellShapeEnum.I:
               _loc4_ = new Lozenge(_loc1_,63,_loc2_);
               break;
            case SpellShapeEnum.O:
               _loc4_ = new Lozenge(_loc1_,_loc1_,_loc2_);
               break;
            case SpellShapeEnum.Q:
               _loc4_ = new Cross(1,_loc1_,_loc2_);
               break;
            case SpellShapeEnum.G:
               _loc4_ = new Square(0,_loc1_,_loc2_);
               break;
            case SpellShapeEnum.V:
               _loc4_ = new Cone(0,_loc1_,_loc2_);
               break;
            case SpellShapeEnum.W:
               (_loc7_ = new Square(0,_loc1_,_loc2_)).diagonalFree = true;
               _loc4_ = _loc7_;
               break;
            case SpellShapeEnum.plus:
               (_loc8_ = new Cross(0,_loc1_,_loc2_)).diagonal = true;
               _loc4_ = _loc8_;
               break;
            case SpellShapeEnum.sharp:
               (_loc8_ = new Cross(1,_loc1_,_loc2_)).diagonal = true;
               _loc4_ = _loc8_;
               break;
            case SpellShapeEnum.star:
               (_loc8_ = new Cross(0,_loc1_,_loc2_)).allDirections = true;
               _loc4_ = _loc8_;
               break;
            case SpellShapeEnum.slash:
               _loc4_ = new Line(_loc1_,_loc2_);
               break;
            case SpellShapeEnum.minus:
               (_loc8_ = new Cross(0,_loc1_,_loc2_)).onlyPerpendicular = true;
               _loc8_.diagonal = true;
               _loc4_ = _loc8_;
               break;
            case SpellShapeEnum.U:
               _loc4_ = new HalfLozenge(0,_loc1_,_loc2_);
               break;
            case SpellShapeEnum.A:
            case SpellShapeEnum.a:
               _loc4_ = new Lozenge(0,63,_loc2_);
               break;
            case SpellShapeEnum.P:
            default:
               _loc4_ = new Cross(0,0,_loc2_);
         }
         if(this._rollOverCell)
         {
            _loc9_ = this._centerCell.posX - this._rollOverCell.posX;
            _loc10_ = this._centerCell.posY - this._rollOverCell.posY;
            _loc4_.direction = DirectionsEnum.DOWN_RIGHT;
            if(_loc9_ == 0 && _loc10_ > 0)
            {
               _loc4_.direction = DirectionsEnum.DOWN_LEFT;
            }
            if(_loc9_ == 0 && _loc10_ < 0)
            {
               _loc4_.direction = DirectionsEnum.UP_RIGHT;
            }
            if(_loc9_ > 0 && _loc10_ == 0)
            {
               _loc4_.direction = DirectionsEnum.UP_LEFT;
            }
         }
         return _loc4_;
      }
   }
}
