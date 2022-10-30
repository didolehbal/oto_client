package com.ankamagames.atouin.renderers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesDisplayManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.atouin.types.ZoneTile;
   import com.ankamagames.atouin.utils.IZoneRenderer;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import flash.geom.ColorTransform;
   import flash.utils.getQualifiedClassName;
   
   public class ZoneDARenderer implements IZoneRenderer
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ZoneDARenderer));
      
      private static var zoneTileCache:Array = new Array();
       
      
      protected var _cells:Vector.<uint>;
      
      protected var _aZoneTile:Array;
      
      protected var _aCellTile:Array;
      
      private var _alpha:Number = 0.7;
      
      protected var _fixedStrata:Boolean;
      
      protected var _strata:uint;
      
      public var currentStrata:uint = 0;
      
      public var showFarmCell:Boolean = true;
      
      public function ZoneDARenderer(param1:uint = 0, param2:Number = 1, param3:Boolean = false)
      {
         super();
         this._aZoneTile = new Array();
         this._aCellTile = new Array();
         this._strata = param1;
         this._fixedStrata = param3;
         this.currentStrata = !this._fixedStrata && Atouin.getInstance().options.transparentOverlayMode?uint(PlacementStrataEnums.STRATA_NO_Z_ORDER):uint(this._strata);
         this._alpha = param2;
      }
      
      private static function getZoneTile() : ZoneTile
      {
         if(zoneTileCache.length)
         {
            return zoneTileCache.shift();
         }
         return new ZoneTile();
      }
      
      private static function destroyZoneTile(param1:ZoneTile) : void
      {
         param1.remove();
         zoneTileCache.push(param1);
      }
      
      public function render(param1:Vector.<uint>, param2:Color, param3:DataMapContainer, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc7_:ZoneTile = null;
         var _loc8_:CellData = null;
         var _loc9_:ColorTransform = null;
         this._cells = param1;
         var _loc10_:int = param1.length;
         _loc6_ = 0;
         while(_loc6_ < _loc10_)
         {
            _loc8_ = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param1[_loc6_]];
            if(!(!this.showFarmCell && _loc8_.farmCell))
            {
               if(!(_loc7_ = this._aZoneTile[_loc6_]))
               {
                  _loc7_ = getZoneTile();
                  this._aZoneTile[_loc6_] = _loc7_;
                  _loc7_.strata = this.currentStrata;
                  _loc9_ = new ColorTransform();
                  _loc7_.color = param2.color;
               }
               this._aCellTile[_loc6_] = param1[_loc6_];
               _loc7_.cellId = param1[_loc6_];
               _loc7_.text = this.getText(_loc6_);
               if(param5 || EntitiesDisplayManager.getInstance()._dStrataRef[_loc7_] != this.currentStrata)
               {
                  _loc7_.strata = EntitiesDisplayManager.getInstance()._dStrataRef[_loc7_] = this.currentStrata;
               }
               _loc7_.display();
            }
            _loc6_++;
         }
         while(_loc6_ < _loc10_)
         {
            if(_loc7_ = this._aZoneTile[_loc6_])
            {
               destroyZoneTile(_loc7_);
            }
            _loc6_++;
         }
      }
      
      protected function getText(param1:int) : String
      {
         return null;
      }
      
      public function remove(param1:Vector.<uint>, param2:DataMapContainer) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ZoneTile = null;
         var _loc5_:int = 0;
         var _loc8_:int = 0;
         if(!param1)
         {
            return;
         }
         var _loc6_:Array = new Array();
         var _loc7_:int = param1.length;
         _loc3_ = 0;
         while(_loc3_ < _loc7_)
         {
            _loc6_[param1[_loc3_]] = true;
            _loc3_++;
         }
         _loc7_ = this._aCellTile.length;
         while(_loc8_ < _loc7_)
         {
            if(_loc6_[this._aCellTile[_loc8_]])
            {
               _loc5_++;
               if(_loc4_ = this._aZoneTile[_loc8_])
               {
                  destroyZoneTile(_loc4_);
               }
               this._aCellTile.splice(_loc8_,1);
               this._aZoneTile.splice(_loc8_,1);
               _loc8_--;
               _loc7_--;
            }
            _loc8_++;
         }
      }
      
      public function get fixedStrata() : Boolean
      {
         return this._fixedStrata;
      }
      
      public function restoreStrata() : void
      {
         this.currentStrata = this._strata;
      }
   }
}
