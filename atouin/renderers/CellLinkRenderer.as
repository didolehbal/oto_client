package com.ankamagames.atouin.renderers
{
   import com.ankamagames.atouin.data.map.Cell;
   import com.ankamagames.atouin.types.CellLink;
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.atouin.utils.CellUtil;
   import com.ankamagames.atouin.utils.IZoneRenderer;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.geom.Point;
   
   public class CellLinkRenderer implements IZoneRenderer
   {
       
      
      public var strata:uint;
      
      public var cells:Vector.<Cell>;
      
      private var _cellLinks:Vector.<CellLink>;
      
      private var _useThicknessMalus:Boolean;
      
      private var _thickness:Number;
      
      private var _alpha:Number;
      
      public function CellLinkRenderer(param1:Number = 10, param2:Number = 1, param3:Boolean = false, param4:uint = 160)
      {
         super();
         this.strata = param4;
         this._thickness = param1;
         this._alpha = param2;
         this._useThicknessMalus = param3;
      }
      
      public function render(param1:Vector.<uint>, param2:Color, param3:DataMapContainer, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc6_:CellLink = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:MapPoint = null;
         var _loc11_:MapPoint = null;
         var _loc12_:int = 0;
         this._cellLinks = new Vector.<CellLink>();
         var _loc13_:Vector.<MapPoint> = new Vector.<MapPoint>();
         while(param1.length)
         {
            _loc13_.push(MapPoint.fromCellId(param1.shift()));
         }
         var _loc14_:Number = this._thickness;
         var _loc15_:int = _loc13_.length - 1;
         _loc12_ = 0;
         while(_loc12_ < _loc15_)
         {
            _loc7_ = CellUtil.getPixelsPointFromMapPoint(_loc13_[_loc12_],false);
            _loc8_ = CellUtil.getPixelsPointFromMapPoint(_loc13_[_loc12_ + 1],false);
            if(_loc7_.y > _loc8_.y || _loc7_.y == _loc8_.y && _loc7_.x > _loc8_.x)
            {
               _loc10_ = _loc13_[_loc12_];
               _loc11_ = _loc13_[_loc12_ + 1];
               _loc9_ = new Point(_loc8_.x - _loc7_.x,_loc8_.y - _loc7_.y);
            }
            else
            {
               _loc10_ = _loc13_[_loc12_ + 1];
               _loc11_ = _loc13_[_loc12_];
               _loc9_ = new Point(_loc7_.x - _loc8_.x,_loc7_.y - _loc8_.y);
            }
            (_loc6_ = new CellLink()).graphics.lineStyle(_loc14_,param2.color,this._alpha);
            _loc6_.graphics.moveTo(0,0);
            _loc6_.graphics.lineTo(_loc9_.x,_loc9_.y);
            _loc6_.orderedCheckpoints = new <MapPoint>[_loc10_,_loc11_];
            _loc6_.display(this.strata);
            this._cellLinks.push(_loc6_);
            if((_loc14_ = _loc14_ - 2) < 1)
            {
               _loc14_ = 1;
            }
            _loc12_++;
         }
      }
      
      public function remove(param1:Vector.<uint>, param2:DataMapContainer) : void
      {
         if(this._cellLinks)
         {
            while(this._cellLinks.length)
            {
               this._cellLinks.pop().remove();
            }
         }
         this._cellLinks = null;
      }
   }
}
