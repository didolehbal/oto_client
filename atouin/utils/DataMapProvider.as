package com.ankamagames.atouin.utils
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.map.Cell;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.interfaces.IObstacle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class DataMapProvider implements IDataMapProvider
   {
      
      private static const TOLERANCE_ELEVATION:int = 11;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(DataMapProvider));
      
      private static var _self:DataMapProvider;
      
      private static var _playerClass:Class;
       
      
      public var isInFight:Boolean;
      
      private var _updatedCell:Dictionary;
      
      private var _specialEffects:Dictionary;
      
      public function DataMapProvider()
      {
         this._updatedCell = new Dictionary();
         this._specialEffects = new Dictionary();
         super();
      }
      
      public static function getInstance() : DataMapProvider
      {
         if(!_self)
         {
            throw new SingletonError("Init function wasn\'t call");
         }
         return _self;
      }
      
      public static function init(param1:Class) : void
      {
         _playerClass = param1;
         if(!_self)
         {
            _self = new DataMapProvider();
         }
      }
      
      public function pointLos(param1:int, param2:int, param3:Boolean = true) : Boolean
      {
         var _loc4_:Array = null;
         var _loc5_:IObstacle = null;
         var _loc6_:uint = MapPoint.fromCoords(param1,param2).cellId;
         var _loc7_:Boolean = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc6_]).los;
         if(this._updatedCell[_loc6_] != null)
         {
            _loc7_ = this._updatedCell[_loc6_];
         }
         if(!param3)
         {
            if((_loc4_ = EntitiesManager.getInstance().getEntitiesOnCell(_loc6_,IObstacle)).length)
            {
               for each(_loc5_ in _loc4_)
               {
                  if(!IObstacle(_loc5_).canSeeThrough())
                  {
                     return false;
                  }
               }
            }
         }
         return _loc7_;
      }
      
      public function farmCell(param1:int, param2:int) : Boolean
      {
         var _loc3_:uint = MapPoint.fromCoords(param1,param2).cellId;
         return CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc3_]).farmCell;
      }
      
      public function isChangeZone(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:CellData = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param1]);
         var _loc4_:CellData = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param2]);
         var _loc5_:int = Math.abs(Math.abs(_loc3_.floor) - Math.abs(_loc4_.floor));
         if(_loc3_.moveZone != _loc4_.moveZone && _loc5_ == 0)
         {
            return true;
         }
         return false;
      }
      
      public function pointMov(param1:int, param2:int, param3:Boolean = true, param4:int = -1, param5:int = -1) : Boolean
      {
         var _loc6_:Boolean = false;
         var _loc7_:uint = 0;
         var _loc8_:CellData = null;
         var _loc9_:Boolean = false;
         var _loc10_:CellData = null;
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:IObstacle = null;
         if(MapPoint.isInMap(param1,param2))
         {
            _loc6_ = MapDisplayManager.getInstance().getDataMapContainer().dataMap.isUsingNewMovementSystem;
            _loc7_ = MapPoint.fromCoords(param1,param2).cellId;
            _loc9_ = (_loc8_ = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc7_])).mov && (!this.isInFight || !_loc8_.nonWalkableDuringFight);
            if(this._updatedCell[_loc7_] != null)
            {
               _loc9_ = this._updatedCell[_loc7_];
            }
            if(_loc9_ && _loc6_ && param4 != -1 && param4 != _loc7_)
            {
               _loc10_ = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param4]);
               _loc11_ = Math.abs(Math.abs(_loc8_.floor) - Math.abs(_loc10_.floor));
               if(_loc10_.moveZone != _loc8_.moveZone && _loc11_ > 0 || _loc10_.moveZone == _loc8_.moveZone && _loc8_.moveZone == 0 && _loc11_ > TOLERANCE_ELEVATION)
               {
                  _loc9_ = false;
               }
            }
            if(!param3)
            {
               if((_loc12_ = EntitiesManager.getInstance().getEntitiesOnCell(_loc7_,IObstacle)).length)
               {
                  for each(_loc13_ in _loc12_)
                  {
                     if(!(param5 == _loc7_ && _loc13_.canWalkTo()))
                     {
                        if(!_loc13_.canWalkThrough())
                        {
                           return false;
                        }
                     }
                  }
               }
            }
         }
         else
         {
            _loc9_ = false;
         }
         return _loc9_;
      }
      
      public function pointCanStop(param1:int, param2:int, param3:Boolean = true) : Boolean
      {
         var _loc4_:uint = MapPoint.fromCoords(param1,param2).cellId;
         var _loc5_:CellData = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc4_]);
         return this.pointMov(param1,param2,param3) && (this.isInFight || !_loc5_.nonWalkableDuringRP);
      }
      
      public function pointWeight(param1:int, param2:int, param3:Boolean = true) : Number
      {
         var _loc4_:IEntity = null;
         var _loc5_:Number = 1;
         var _loc6_:int = this.getCellSpeed(MapPoint.fromCoords(param1,param2).cellId);
         if(param3)
         {
            if(_loc6_ >= 0)
            {
               _loc5_ = _loc5_ + (5 - _loc6_);
            }
            else
            {
               _loc5_ = _loc5_ + (11 + Math.abs(_loc6_));
            }
            if((_loc4_ = EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(param1,param2),_playerClass)) && !_loc4_["allowMovementThrough"])
            {
               _loc5_ = 20;
            }
         }
         else
         {
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(param1,param2),_playerClass) != null)
            {
               _loc5_ = _loc5_ + 0.3;
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(param1 + 1,param2),_playerClass) != null)
            {
               _loc5_ = _loc5_ + 0.3;
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(param1,param2 + 1),_playerClass) != null)
            {
               _loc5_ = _loc5_ + 0.3;
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(param1 - 1,param2),_playerClass) != null)
            {
               _loc5_ = _loc5_ + 0.3;
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(param1,param2 - 1),_playerClass) != null)
            {
               _loc5_ = _loc5_ + 0.3;
            }
            if((this.pointSpecialEffects(param1,param2) & 2) == 2)
            {
               _loc5_ = _loc5_ + 0.2;
            }
         }
         return _loc5_;
      }
      
      public function getCellSpeed(param1:uint) : int
      {
         return (MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param1] as CellData).speed;
      }
      
      public function pointSpecialEffects(param1:int, param2:int) : uint
      {
         var _loc3_:uint = MapPoint.fromCoords(param1,param2).cellId;
         if(this._specialEffects[_loc3_])
         {
            return this._specialEffects[_loc3_];
         }
         return 0;
      }
      
      public function get width() : int
      {
         return AtouinConstants.MAP_HEIGHT + AtouinConstants.MAP_WIDTH - 2;
      }
      
      public function get height() : int
      {
         return AtouinConstants.MAP_HEIGHT + AtouinConstants.MAP_WIDTH - 1;
      }
      
      public function hasEntity(param1:int, param2:int) : Boolean
      {
         var _loc3_:IObstacle = null;
         var _loc4_:Array;
         if((_loc4_ = EntitiesManager.getInstance().getEntitiesOnCell(MapPoint.fromCoords(param1,param2).cellId,IObstacle)).length)
         {
            for each(_loc3_ in _loc4_)
            {
               if(!IObstacle(_loc3_).canWalkTo())
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function updateCellMovLov(param1:uint, param2:Boolean) : void
      {
         this._updatedCell[param1] = param2;
      }
      
      public function resetUpdatedCell() : void
      {
         this._updatedCell = new Dictionary();
      }
      
      public function setSpecialEffects(param1:uint, param2:uint) : void
      {
         this._specialEffects[param1] = param2;
      }
      
      public function resetSpecialEffects() : void
      {
         this._specialEffects = new Dictionary();
      }
   }
}
