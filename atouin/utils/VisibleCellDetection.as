package com.ankamagames.atouin.utils
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.elements.Elements;
   import com.ankamagames.atouin.data.elements.GraphicalElementData;
   import com.ankamagames.atouin.data.elements.subtypes.NormalGraphicalElementData;
   import com.ankamagames.atouin.data.map.Cell;
   import com.ankamagames.atouin.data.map.Layer;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.atouin.data.map.elements.BasicElement;
   import com.ankamagames.atouin.data.map.elements.GraphicalElement;
   import com.ankamagames.atouin.enums.ElementTypesEnum;
   import com.ankamagames.atouin.types.Frustum;
   import com.ankamagames.atouin.types.miscs.PartialDataMap;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   
   public class VisibleCellDetection
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(VisibleCellDetection));
       
      
      public function VisibleCellDetection()
      {
         super();
      }
      
      public static function detectCell(param1:Boolean, param2:Map, param3:WorldPoint, param4:Frustum, param5:WorldPoint) : PartialDataMap
      {
         var _loc6_:Point = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:GraphicalElementData = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Layer = null;
         var _loc15_:* = null;
         var _loc16_:Cell = null;
         var _loc17_:BasicElement = null;
         var _loc18_:NormalGraphicalElementData = null;
         var _loc19_:uint = 0;
         if(param5 == null)
         {
            _log.error("Cannot detect visible cells with no current map point.");
            return null;
         }
         var _loc20_:PartialDataMap = new PartialDataMap();
         var _loc21_:int = (param3.x - param5.x) * AtouinConstants.CELL_WIDTH * AtouinConstants.MAP_WIDTH;
         var _loc22_:int = (param3.y - param5.y) * AtouinConstants.CELL_HEIGHT * AtouinConstants.MAP_HEIGHT;
         var _loc23_:Rectangle = new Rectangle(-param4.x / param4.scale,-param4.y / param4.scale,StageShareManager.startHeight / param4.scale,StageShareManager.stage.stageHeight / param4.scale);
         var _loc24_:Rectangle = new Rectangle();
         var _loc25_:Array = new Array();
         var _loc26_:Array = new Array();
         var _loc27_:Sprite;
         (_loc27_ = Sprite(Atouin.getInstance().worldContainer.parent).addChild(new Sprite()) as Sprite).graphics.beginFill(0,0);
         _loc27_.graphics.lineStyle(1,16711680);
         var _loc28_:Elements = Elements.getInstance();
         for each(_loc14_ in param2.layers)
         {
            for each(_loc16_ in _loc14_.cells)
            {
               _loc7_ = 0;
               _loc8_ = 0;
               _loc10_ = 100000;
               _loc12_ = 0;
               _loc26_ = new Array();
               for each(_loc17_ in _loc16_.elements)
               {
                  if(_loc17_.elementType == ElementTypesEnum.GRAPHICAL)
                  {
                     _loc11_ = _loc28_.getElementData(GraphicalElement(_loc17_).elementId);
                     _loc12_ = (_loc13_ = int(GraphicalElement(_loc17_).altitude * AtouinConstants.ALTITUDE_PIXEL_UNIT)) < _loc12_?int(_loc13_):int(_loc12_);
                     if(_loc11_ && _loc11_ is NormalGraphicalElementData)
                     {
                        if(-(_loc18_ = _loc11_ as NormalGraphicalElementData).origin.x + AtouinConstants.CELL_WIDTH < _loc10_)
                        {
                           _loc10_ = -_loc18_.origin.x + AtouinConstants.CELL_WIDTH;
                        }
                        if(_loc18_.size.x > _loc8_)
                        {
                           _loc8_ = _loc18_.size.x;
                        }
                        _loc7_ = _loc7_ + (_loc18_.origin.y + _loc18_.size.y);
                        _loc26_.push(_loc18_.gfxId);
                     }
                     else
                     {
                        _loc7_ = _loc7_ + Math.abs(_loc13_);
                     }
                  }
               }
               if(!_loc7_)
               {
                  _loc7_ = AtouinConstants.CELL_HEIGHT;
               }
               if(_loc10_ == 100000)
               {
                  _loc10_ = 0;
               }
               if(_loc8_ < AtouinConstants.CELL_WIDTH)
               {
                  _loc8_ = AtouinConstants.CELL_WIDTH;
               }
               _loc6_ = Cell.cellPixelCoords(_loc16_.cellId);
               _loc24_.left = _loc6_.x + _loc21_ + _loc10_ - AtouinConstants.CELL_HALF_WIDTH;
               _loc24_.top = _loc6_.y + _loc22_ - _loc12_ - _loc7_;
               _loc24_.width = _loc8_;
               _loc24_.height = _loc7_ + AtouinConstants.CELL_HEIGHT * 2;
               if(!_loc25_[_loc16_.cellId])
               {
                  _loc25_[_loc16_.cellId] = {
                     "r":_loc24_.clone(),
                     "gfx":_loc26_
                  };
               }
               else
               {
                  _loc25_[_loc16_.cellId].r = _loc25_[_loc16_.cellId].r.union(_loc24_);
                  _loc25_[_loc16_.cellId].gfx = _loc25_[_loc16_.cellId].gfx.concat(_loc26_);
               }
            }
         }
         _loc26_ = new Array();
         _loc9_ = 0;
         while(_loc9_ < _loc25_.length)
         {
            if(_loc25_[_loc9_])
            {
               if((_loc24_ = _loc25_[_loc9_].r) && _loc24_.intersects(_loc23_) == param1)
               {
                  _loc20_.cell[_loc9_] = true;
                  _loc19_ = 0;
                  while(_loc19_ < _loc25_[_loc9_].gfx.length)
                  {
                     _loc26_[_loc25_[_loc9_].gfx[_loc19_]] = true;
                     _loc19_++;
                  }
               }
            }
            _loc9_++;
         }
         for(_loc15_ in _loc26_)
         {
            _loc20_.gfx.push(_loc15_);
         }
         return _loc20_;
      }
   }
}
