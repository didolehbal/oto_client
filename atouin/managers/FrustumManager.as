package com.ankamagames.atouin.managers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.map.Cell;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.atouin.messages.AdjacentMapOutMessage;
   import com.ankamagames.atouin.messages.AdjacentMapOverMessage;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.types.Frustum;
   import com.ankamagames.atouin.types.FrustumShape;
   import com.ankamagames.atouin.utils.CellIdConverter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getQualifiedClassName;
   
   public class FrustumManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FrustumManager));
      
      private static var _self:FrustumManager;
       
      
      private var _frustumContainer:DisplayObjectContainer;
      
      private var _shapeTop:FrustumShape;
      
      private var _shapeRight:FrustumShape;
      
      private var _shapeBottom:FrustumShape;
      
      private var _shapeLeft:FrustumShape;
      
      private var _frustrum:Frustum;
      
      private var _lastCellId:int;
      
      private var _enable:Boolean;
      
      public function FrustumManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : FrustumManager
      {
         if(!_self)
         {
            _self = new FrustumManager();
         }
         return _self;
      }
      
      public function init(param1:DisplayObjectContainer) : void
      {
         this._frustumContainer = param1;
         this._shapeTop = new FrustumShape(DirectionsEnum.UP);
         this._shapeRight = new FrustumShape(DirectionsEnum.RIGHT);
         this._shapeBottom = new FrustumShape(DirectionsEnum.DOWN);
         this._shapeLeft = new FrustumShape(DirectionsEnum.LEFT);
         this._frustumContainer.addChild(this._shapeLeft);
         this._frustumContainer.addChild(this._shapeTop);
         this._frustumContainer.addChild(this._shapeRight);
         this._frustumContainer.addChild(this._shapeBottom);
         this._shapeLeft.buttonMode = true;
         this._shapeTop.buttonMode = true;
         this._shapeRight.buttonMode = true;
         this._shapeBottom.buttonMode = true;
         this._shapeLeft.addEventListener(MouseEvent.CLICK,this.click);
         this._shapeTop.addEventListener(MouseEvent.CLICK,this.click);
         this._shapeRight.addEventListener(MouseEvent.CLICK,this.click);
         this._shapeBottom.addEventListener(MouseEvent.CLICK,this.click);
         this._shapeLeft.addEventListener(MouseEvent.MOUSE_OVER,this.mouseMove);
         this._shapeTop.addEventListener(MouseEvent.MOUSE_OVER,this.mouseMove);
         this._shapeRight.addEventListener(MouseEvent.MOUSE_OVER,this.mouseMove);
         this._shapeBottom.addEventListener(MouseEvent.MOUSE_OVER,this.mouseMove);
         this._shapeLeft.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this._shapeTop.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this._shapeRight.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this._shapeBottom.addEventListener(MouseEvent.MOUSE_OUT,this.out);
         this._shapeLeft.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this._shapeTop.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this._shapeRight.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this._shapeBottom.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this.setBorderInteraction(false);
         this._lastCellId = -1;
      }
      
      public function setBorderInteraction(param1:Boolean) : void
      {
         this._enable = param1;
         this._shapeTop.mouseEnabled = param1;
         this._shapeRight.mouseEnabled = param1;
         this._shapeBottom.mouseEnabled = param1;
         this._shapeLeft.mouseEnabled = param1;
         this.updateMap();
      }
      
      public function updateMap() : void
      {
         this._lastCellId = -1;
         if(this._enable)
         {
            this._shapeTop.mouseEnabled = this.findNearestCell(this._shapeTop).cell != -1;
            this._shapeRight.mouseEnabled = this.findNearestCell(this._shapeRight).cell != -1;
            this._shapeBottom.mouseEnabled = this.findNearestCell(this._shapeBottom).cell != -1;
            this._shapeLeft.mouseEnabled = this.findNearestCell(this._shapeLeft).cell != -1;
         }
      }
      
      public function getShape(param1:int) : Sprite
      {
         switch(param1)
         {
            case DirectionsEnum.UP:
               return this._shapeTop;
            case DirectionsEnum.LEFT:
               return this._shapeLeft;
            case DirectionsEnum.RIGHT:
               return this._shapeRight;
            case DirectionsEnum.DOWN:
               return this._shapeBottom;
            default:
               return null;
         }
      }
      
      public function set frustum(param1:Frustum) : void
      {
         this._frustrum = param1;
         var _loc2_:Point = new Point(param1.x + AtouinConstants.CELL_HALF_WIDTH * param1.scale,param1.y + AtouinConstants.CELL_HALF_HEIGHT * param1.scale);
         var _loc3_:Point = new Point(param1.x - AtouinConstants.CELL_HALF_WIDTH * param1.scale + param1.width,param1.y + AtouinConstants.CELL_HALF_HEIGHT * param1.scale);
         var _loc4_:Point = new Point(param1.x + AtouinConstants.CELL_HALF_WIDTH * param1.scale,param1.y - AtouinConstants.CELL_HEIGHT * param1.scale + param1.height);
         var _loc5_:Point = new Point(param1.x - AtouinConstants.CELL_HALF_WIDTH * param1.scale + param1.width,param1.y - AtouinConstants.CELL_HEIGHT * param1.scale + param1.height);
         var _loc6_:Point = new Point(param1.x,param1.y);
         var _loc7_:Point = new Point(param1.x + param1.width,param1.y);
         var _loc8_:Point = new Point(param1.x,param1.y + param1.height - AtouinConstants.CELL_HALF_HEIGHT * param1.scale);
         var _loc9_:Point = new Point(param1.x + param1.width,param1.y + param1.height - AtouinConstants.CELL_HALF_HEIGHT * param1.scale);
         var _loc10_:Number = 1;
         var _loc11_:Vector.<int>;
         (_loc11_ = new Vector.<int>(7,true))[0] = 1;
         _loc11_[1] = 2;
         _loc11_[2] = 2;
         _loc11_[3] = 2;
         _loc11_[4] = 2;
         _loc11_[5] = 2;
         _loc11_[6] = 2;
         var _loc12_:Vector.<Number>;
         (_loc12_ = new Vector.<Number>(14,true))[0] = 0;
         _loc12_[1] = _loc6_.y;
         _loc12_[2] = _loc6_.x;
         _loc12_[3] = _loc6_.y;
         _loc12_[4] = _loc2_.x;
         _loc12_[5] = _loc2_.y;
         _loc12_[6] = _loc4_.x;
         _loc12_[7] = _loc4_.y;
         _loc12_[8] = _loc8_.x;
         _loc12_[9] = _loc8_.y;
         _loc12_[10] = 0;
         _loc12_[11] = _loc8_.y;
         _loc12_[12] = 0;
         _loc12_[13] = _loc6_.y;
         var _loc13_:Bitmap;
         if((_loc13_ = this.drawShape(16746564,_loc11_,_loc12_)) != null)
         {
            this._shapeLeft.addChild(_loc13_);
         }
         var _loc14_:Vector.<Number>;
         (_loc14_ = new Vector.<Number>(14,true))[0] = _loc6_.x;
         _loc14_[1] = 0;
         _loc14_[2] = _loc6_.x;
         _loc14_[3] = _loc6_.y;
         _loc14_[4] = _loc2_.x;
         _loc14_[5] = _loc2_.y;
         _loc14_[6] = _loc3_.x;
         _loc14_[7] = _loc3_.y;
         _loc14_[8] = _loc7_.x;
         _loc14_[9] = _loc7_.y;
         _loc14_[10] = _loc7_.x;
         _loc14_[11] = 0;
         _loc14_[12] = 0;
         _loc14_[13] = 0;
         if((_loc13_ = this.drawShape(7803289,_loc11_,_loc14_)) != null)
         {
            this._shapeTop.addChild(_loc13_);
         }
         var _loc15_:Vector.<Number>;
         (_loc15_ = new Vector.<Number>(14,true))[0] = StageShareManager.startWidth;
         _loc15_[1] = _loc7_.y;
         _loc15_[2] = _loc7_.x;
         _loc15_[3] = _loc7_.y;
         _loc15_[4] = _loc3_.x;
         _loc15_[5] = _loc3_.y;
         _loc15_[6] = _loc5_.x;
         _loc15_[7] = _loc5_.y;
         _loc15_[8] = _loc9_.x;
         _loc15_[9] = _loc9_.y;
         _loc15_[10] = StageShareManager.startWidth;
         _loc15_[11] = _loc9_.y;
         _loc15_[12] = StageShareManager.startWidth;
         _loc15_[13] = _loc7_.y;
         if((_loc13_ = this.drawShape(1218969,_loc11_,_loc15_)) != null)
         {
            _loc13_.x = StageShareManager.startWidth - _loc13_.width;
            _loc13_.y = 15;
            this._shapeRight.addChild(_loc13_);
         }
         var _loc16_:Vector.<Number>;
         (_loc16_ = new Vector.<Number>(14,true))[0] = _loc9_.x;
         _loc16_[1] = StageShareManager.startHeight;
         _loc16_[2] = _loc9_.x;
         _loc16_[3] = _loc9_.y;
         _loc16_[4] = _loc5_.x;
         _loc16_[5] = _loc5_.y + 10;
         _loc16_[6] = _loc4_.x;
         _loc16_[7] = _loc4_.y + 10;
         _loc16_[8] = _loc8_.x;
         _loc16_[9] = _loc8_.y;
         _loc16_[10] = _loc8_.x;
         _loc16_[11] = StageShareManager.startHeight;
         _loc16_[12] = _loc9_.x;
         _loc16_[13] = StageShareManager.startHeight;
         if((_loc13_ = this.drawShape(7807590,_loc11_,_loc16_)) != null)
         {
            _loc13_.y = StageShareManager.startHeight - _loc13_.height;
            this._shapeBottom.addChild(_loc13_);
         }
      }
      
      private function drawShape(param1:uint, param2:Vector.<int>, param3:Vector.<Number>) : Bitmap
      {
         var _loc4_:BitmapData = null;
         var _loc5_:Shape;
         (_loc5_ = new Shape()).graphics.beginFill(param1,0);
         _loc5_.graphics.drawPath(param2,param3);
         _loc5_.graphics.endFill();
         if(_loc5_.width > 0 && _loc5_.height > 0)
         {
            (_loc4_ = new BitmapData(_loc5_.width,_loc5_.height,true,16777215)).draw(_loc5_);
            _loc5_.graphics.clear();
            _loc5_ = null;
            return new Bitmap(_loc4_);
         }
         return null;
      }
      
      private function click(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Map = MapDisplayManager.getInstance().getDataMapContainer().dataMap;
         switch(param1.target)
         {
            case this._shapeRight:
               _loc2_ = 1;
               break;
            case this._shapeLeft:
               _loc2_ = 3;
               break;
            case this._shapeBottom:
               _loc2_ = 4;
               break;
            case this._shapeTop:
               _loc2_ = 2;
         }
         var _loc4_:Point = new Point(!!isNaN(param1.localX)?Number(Sprite(param1.target).mouseX):Number(param1.localX),!!isNaN(param1.localY)?Number(Sprite(param1.target).mouseY):Number(param1.localY));
         var _loc5_:Object;
         if((_loc5_ = this.findNearestCell(param1.target as Sprite,_loc4_)).cell == -1)
         {
            return;
         }
         if(!_loc5_.custom)
         {
            this.sendClickAdjacentMsg(_loc2_,_loc5_.cell);
         }
         else
         {
            this.sendCellClickMsg(_loc2_,_loc5_.cell);
         }
      }
      
      private function findCustomNearestCell(param1:Sprite, param2:Point = null) : Object
      {
         var _loc3_:Array = null;
         var _loc4_:Point = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc13_:uint = 0;
         var _loc9_:Map = MapDisplayManager.getInstance().getDataMapContainer().dataMap;
         if(!param2)
         {
            param2 = new Point(param1.mouseX,param1.mouseY);
         }
         switch(param1)
         {
            case this._shapeRight:
               _loc11_ = 1;
               _loc3_ = _loc9_.rightArrowCell;
               break;
            case this._shapeLeft:
               _loc11_ = 1;
               _loc3_ = _loc9_.leftArrowCell;
               break;
            case this._shapeBottom:
               _loc10_ = 1;
               _loc3_ = _loc9_.bottomArrowCell;
               break;
            case this._shapeTop:
               _loc10_ = 1;
               _loc3_ = _loc9_.topArrowCell;
         }
         if(!_loc3_ || !_loc3_.length)
         {
            return {
               "cell":-1,
               "distance":Number.MAX_VALUE
            };
         }
         var _loc12_:Number = Number.MAX_VALUE;
         while(_loc13_ < _loc3_.length)
         {
            _loc7_ = _loc3_[_loc13_];
            _loc4_ = Cell.cellPixelCoords(_loc7_);
            _loc6_ = CellData(_loc9_.cells[_loc7_]).floor;
            if(_loc11_ == 1)
            {
               _loc5_ = Math.abs(param2.x - this._frustrum.y - (_loc4_.y - _loc6_ + AtouinConstants.CELL_HALF_HEIGHT) * this._frustrum.scale);
            }
            if(_loc10_ == 1)
            {
               _loc5_ = Math.abs(param2.x - this._frustrum.x - (_loc4_.x + AtouinConstants.CELL_HALF_WIDTH) * this._frustrum.scale);
            }
            if(_loc5_ < _loc12_)
            {
               _loc12_ = _loc5_;
               _loc8_ = _loc7_;
            }
            _loc13_++;
         }
         return {
            "cell":_loc8_,
            "distance":_loc12_
         };
      }
      
      private function findNearestCell(param1:Sprite, param2:Point = null) : Object
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:int = 0;
         var _loc14_:CellData = null;
         var _loc15_:uint = 0;
         var _loc16_:Map = MapDisplayManager.getInstance().getDataMapContainer().dataMap;
         var _loc17_:Number = Number.MAX_VALUE;
         if(!param2)
         {
            param2 = new Point(param1.mouseX,param1.mouseY);
         }
         switch(param1)
         {
            case this._shapeRight:
               _loc3_ = AtouinConstants.MAP_WIDTH - 1;
               _loc4_ = AtouinConstants.MAP_WIDTH - 1;
               _loc10_ = _loc16_.rightNeighbourId;
               break;
            case this._shapeLeft:
               _loc3_ = 0;
               _loc4_ = 0;
               _loc10_ = _loc16_.leftNeighbourId;
               break;
            case this._shapeBottom:
               _loc3_ = AtouinConstants.MAP_HEIGHT - 1;
               _loc4_ = -(AtouinConstants.MAP_HEIGHT - 1);
               _loc10_ = _loc16_.bottomNeighbourId;
               break;
            case this._shapeTop:
               _loc3_ = 0;
               _loc4_ = 0;
               _loc10_ = _loc16_.topNeighbourId;
         }
         var _loc18_:Object;
         if((_loc18_ = this.findCustomNearestCell(param1)).cell != -1)
         {
            _loc17_ = _loc18_.distance;
            _loc5_ = CellIdConverter.cellIdToCoord(_loc18_.cell).x;
            _loc6_ = CellIdConverter.cellIdToCoord(_loc18_.cell).y;
         }
         if(param1 == this._shapeRight || param1 == this._shapeLeft)
         {
            _loc12_ = AtouinConstants.MAP_HEIGHT * 2;
            _loc11_ = 0;
            while(_loc11_ < _loc12_)
            {
               _loc13_ = CellIdConverter.coordToCellId(_loc3_,_loc4_);
               _loc7_ = Cell.cellPixelCoords(_loc13_);
               _loc8_ = CellData(_loc16_.cells[_loc13_]).floor;
               if((_loc9_ = Math.abs(param2.y - this._frustrum.y - (_loc7_.y - _loc8_ + AtouinConstants.CELL_HALF_HEIGHT) * this._frustrum.scale)) < _loc17_)
               {
                  if((_loc15_ = (_loc14_ = _loc16_.cells[_loc13_] as CellData).mapChangeData) && (param1 == this._shapeRight && (_loc15_ & 1 || (_loc13_ + 1) % (AtouinConstants.MAP_WIDTH * 2) == 0 && _loc15_ & 2 || (_loc13_ + 1) % (AtouinConstants.MAP_WIDTH * 2) == 0 && _loc15_ & 128) || param1 == this._shapeLeft && (_loc3_ == -_loc4_ && _loc15_ & 8 || _loc15_ & 16 || _loc3_ == -_loc4_ && _loc15_ & 32)))
                  {
                     _loc5_ = _loc3_;
                     _loc6_ = _loc4_;
                     _loc17_ = _loc9_;
                  }
               }
               if(!(_loc11_ % 2))
               {
                  _loc3_++;
               }
               else
               {
                  _loc4_--;
               }
               _loc11_++;
            }
         }
         else
         {
            _loc11_ = 0;
            while(_loc11_ < AtouinConstants.MAP_WIDTH * 2)
            {
               _loc13_ = CellIdConverter.coordToCellId(_loc3_,_loc4_);
               _loc7_ = Cell.cellPixelCoords(_loc13_);
               if((_loc9_ = Math.abs(param2.x - this._frustrum.x - (_loc7_.x + AtouinConstants.CELL_HALF_WIDTH) * this._frustrum.scale)) < _loc17_)
               {
                  if((_loc15_ = (_loc14_ = _loc16_.cells[_loc13_] as CellData).mapChangeData) && (param1 == this._shapeTop && (_loc13_ < AtouinConstants.MAP_WIDTH && _loc15_ & 32 || _loc15_ & 64 || _loc13_ < AtouinConstants.MAP_WIDTH && _loc15_ & 128) || param1 == this._shapeBottom && (_loc13_ >= AtouinConstants.MAP_CELLS_COUNT - AtouinConstants.MAP_WIDTH && _loc15_ & 2 || _loc15_ & 4 || _loc13_ >= AtouinConstants.MAP_CELLS_COUNT - AtouinConstants.MAP_WIDTH && _loc15_ & 8)))
                  {
                     _loc5_ = _loc3_;
                     _loc6_ = _loc4_;
                     _loc17_ = _loc9_;
                  }
               }
               if(!(_loc11_ % 2))
               {
                  _loc3_++;
               }
               else
               {
                  _loc4_++;
               }
               _loc11_++;
            }
         }
         if(_loc17_ != Number.MAX_VALUE)
         {
            return {
               "cell":CellIdConverter.coordToCellId(_loc5_,_loc6_),
               "custom":_loc17_ == _loc18_.distance
            };
         }
         return {
            "cell":-1,
            "custom":false
         };
      }
      
      private function sendClickAdjacentMsg(param1:uint, param2:uint) : void
      {
         var _loc3_:AdjacentMapClickMessage = new AdjacentMapClickMessage();
         _loc3_.cellId = param2;
         _loc3_.adjacentMapId = param1;
         Atouin.getInstance().handler.process(_loc3_);
      }
      
      private function sendCellClickMsg(param1:uint, param2:uint) : void
      {
         var _loc3_:CellClickMessage = new CellClickMessage();
         _loc3_.cellId = param2;
         _loc3_.id = param1;
         Atouin.getInstance().handler.process(_loc3_);
      }
      
      private function out(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         switch(param1.target)
         {
            case this._shapeRight:
               _loc2_ = DirectionsEnum.RIGHT;
               break;
            case this._shapeLeft:
               _loc2_ = DirectionsEnum.LEFT;
               break;
            case this._shapeBottom:
               _loc2_ = DirectionsEnum.DOWN;
               break;
            case this._shapeTop:
               _loc2_ = DirectionsEnum.UP;
         }
         this._lastCellId = -1;
         var _loc3_:AdjacentMapOutMessage = new AdjacentMapOutMessage(_loc2_,DisplayObject(param1.target));
         Atouin.getInstance().handler.process(_loc3_);
      }
      
      private function mouseMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         switch(param1.target)
         {
            case this._shapeRight:
               _loc2_ = DirectionsEnum.RIGHT;
               break;
            case this._shapeLeft:
               _loc2_ = DirectionsEnum.LEFT;
               break;
            case this._shapeBottom:
               _loc2_ = DirectionsEnum.DOWN;
               break;
            case this._shapeTop:
               _loc2_ = DirectionsEnum.UP;
         }
         var _loc3_:int = this.findNearestCell(param1.target as Sprite).cell;
         if(_loc3_ == -1 || _loc3_ == this._lastCellId)
         {
            return;
         }
         this._lastCellId = _loc3_;
         var _loc4_:CellData = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc3_] as CellData;
         var _loc5_:AdjacentMapOverMessage = new AdjacentMapOverMessage(_loc2_,DisplayObject(param1.target),_loc3_,_loc4_);
         Atouin.getInstance().handler.process(_loc5_);
      }
   }
}
