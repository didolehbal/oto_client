package com.ankamagames.atouin.renderers
{
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.atouin.types.TrapZoneTile;
   import com.ankamagames.atouin.utils.IZoneRenderer;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.filters.ColorMatrixFilter;
   
   public class TrapZoneRenderer implements IZoneRenderer
   {
       
      
      private var _aZoneTile:Array;
      
      private var _aCellTile:Array;
      
      private var _visible:Boolean;
      
      public var strata:uint;
      
      public function TrapZoneRenderer(param1:uint = 10, param2:Boolean = true)
      {
         super();
         this._aZoneTile = new Array();
         this._aCellTile = new Array();
         this._visible = param2;
         this.strata = param1;
      }
      
      public function render(param1:Vector.<uint>, param2:Color, param3:DataMapContainer, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc6_:TrapZoneTile = null;
         var _loc7_:uint = 0;
         var _loc8_:MapPoint = null;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:uint = 0;
         var _loc14_:MapPoint = null;
         var _loc15_:int = 0;
         while(_loc15_ < param1.length)
         {
            if(!this._aZoneTile[_loc15_])
            {
               (this._aZoneTile[_loc15_] = new TrapZoneTile()).mouseChildren = false;
               _loc6_.mouseEnabled = false;
               _loc6_.strata = this.strata;
               _loc6_.visible = this._visible;
               _loc6_.filters = [new ColorMatrixFilter([0,0,0,0,param2.red,0,0,0,0,param2.green,0,0,0,0,param2.blue,0,0,0,0.7,0])];
            }
            this._aCellTile[_loc15_] = param1[_loc15_];
            _loc7_ = param1[_loc15_];
            _loc8_ = MapPoint.fromCellId(_loc7_);
            TrapZoneTile(this._aZoneTile[_loc15_]).cellId = _loc7_;
            _loc9_ = false;
            _loc10_ = false;
            _loc11_ = false;
            _loc12_ = false;
            for each(_loc13_ in param1)
            {
               if(_loc13_ != _loc7_)
               {
                  if((_loc14_ = MapPoint.fromCellId(_loc13_)).x == _loc8_.x)
                  {
                     if(_loc14_.y == _loc8_.y - 1)
                     {
                        _loc9_ = true;
                     }
                     else if(_loc14_.y == _loc8_.y + 1)
                     {
                        _loc10_ = true;
                     }
                  }
                  else if(_loc14_.y == _loc8_.y)
                  {
                     if(_loc14_.x == _loc8_.x - 1)
                     {
                        _loc11_ = true;
                     }
                     else if(_loc14_.x == _loc8_.x + 1)
                     {
                        _loc12_ = true;
                     }
                  }
               }
            }
            TrapZoneTile(this._aZoneTile[_loc15_]).drawStroke(_loc9_,_loc11_,_loc10_,_loc12_);
            TrapZoneTile(this._aZoneTile[_loc15_]).display(this.strata);
            _loc15_++;
         }
         while(_loc15_ < this._aZoneTile.length)
         {
            if(this._aZoneTile[_loc15_])
            {
               (this._aZoneTile[_loc15_] as TrapZoneTile).remove();
            }
            _loc15_++;
         }
      }
      
      public function remove(param1:Vector.<uint>, param2:DataMapContainer) : void
      {
         var _loc4_:int = 0;
         if(!param1)
         {
            return;
         }
         var _loc3_:Array = new Array();
         while(_loc4_ < param1.length)
         {
            _loc3_[param1[_loc4_]] = true;
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this._aCellTile.length)
         {
            if(_loc3_[this._aCellTile[_loc4_]])
            {
               if(this._aZoneTile[_loc4_])
               {
                  TrapZoneTile(this._aZoneTile[_loc4_]).remove();
               }
               delete this._aZoneTile[_loc4_];
               delete this._aCellTile[_loc4_];
            }
            _loc4_++;
         }
      }
   }
}
