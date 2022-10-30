package com.ankamagames.dofus.logic.game.fight.miscs
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.FightEntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class FightReachableCellsMaker
   {
      
      protected static const _log:Logger = Log.getLogger("FightReachableCellsMaker");
       
      
      private var _cellGrid:Vector.<Vector.<_ReachableCellStore>>;
      
      private var _reachableCells:Vector.<uint>;
      
      private var _unreachableCells:Vector.<uint>;
      
      private var _mapPoint:MapPoint;
      
      private var _infos:GameFightFighterInformations;
      
      private var _mp:int;
      
      private var _waitingCells:Vector.<_ReachableCellStore>;
      
      private var _watchedCells:Vector.<_ReachableCellStore>;
      
      public function FightReachableCellsMaker(param1:GameFightFighterInformations, param2:int = -1, param3:int = -1)
      {
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:IEntity = null;
         var _loc8_:_ReachableCellStore = null;
         var _loc9_:Number = NaN;
         super();
         var _loc10_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         this._reachableCells = new Vector.<uint>();
         this._unreachableCells = new Vector.<uint>();
         this._infos = param1;
         if(param3 > -1)
         {
            this._mp = param3;
         }
         else
         {
            this._mp = this._infos.stats.movementPoints > 0?int(this._infos.stats.movementPoints):0;
         }
         if(param2 != -1)
         {
            this._mapPoint = MapPoint.fromCellId(param2);
         }
         else
         {
            if(this._infos.disposition.cellId == -1)
            {
               _log.warn("Failed to initialize FightReachableCellsMaker for entity " + param1.contextualId + " because its cellId is -1");
               return;
            }
            this._mapPoint = MapPoint.fromCellId(this._infos.disposition.cellId);
         }
         this._cellGrid = new Vector.<Vector.<_ReachableCellStore>>(this._mp * 2 + 1);
         for(_loc4_ in this._cellGrid)
         {
            this._cellGrid[_loc4_] = new Vector.<_ReachableCellStore>(this._mp * 2 + 1);
         }
         for each(_loc7_ in EntitiesManager.getInstance().entities)
         {
            if(_loc7_.id != this._infos.contextualId && _loc7_.position)
            {
               _loc5_ = _loc7_.position.x - this._mapPoint.x + this._mp;
               _loc6_ = _loc7_.position.y - this._mapPoint.y + this._mp;
               if(_loc5_ >= 0 && _loc5_ < this._mp * 2 + 1 && _loc6_ >= 0 && _loc6_ < this._mp * 2 + 1)
               {
                  param1 = _loc10_.getEntityInfos(_loc7_.id) as GameFightFighterInformations;
                  if(param1)
                  {
                     if(!(param1.disposition is FightEntityDispositionInformations && FightEntityDispositionInformations(param1.disposition).carryingCharacterId == this._infos.contextualId))
                     {
                        (_loc8_ = new _ReachableCellStore(_loc7_.position,_loc5_,_loc6_,this._cellGrid)).state = _ReachableCellStore.STATE_UNREACHABLE;
                        _loc9_ = TackleUtil.getTackleForFighter(param1,this._infos);
                        if(!_loc8_.evade || _loc9_ < _loc8_.evade)
                        {
                           _loc8_.evade = _loc9_;
                        }
                        this._cellGrid[_loc5_][_loc6_] = _loc8_;
                     }
                  }
               }
            }
         }
         this.compute();
      }
      
      public function get reachableCells() : Vector.<uint>
      {
         return this._reachableCells;
      }
      
      public function get unreachableCells() : Vector.<uint>
      {
         return this._unreachableCells;
      }
      
      private function compute() : void
      {
         var _loc1_:Vector.<_ReachableCellStore> = null;
         var _loc2_:_ReachableCellStore = null;
         var _loc3_:int = this._mp;
         var _loc4_:int = this._mp;
         this._waitingCells = new Vector.<_ReachableCellStore>();
         this._watchedCells = new Vector.<_ReachableCellStore>();
         this.markNode(this._mapPoint.x,this._mapPoint.y,_loc3_,_loc4_);
         while(this._waitingCells.length || this._watchedCells.length)
         {
            if(this._waitingCells.length)
            {
               _loc1_ = this._waitingCells;
               this._waitingCells = new Vector.<_ReachableCellStore>();
            }
            else
            {
               _loc1_ = this._watchedCells;
               this._watchedCells = new Vector.<_ReachableCellStore>();
            }
            for each(_loc2_ in _loc1_)
            {
               _loc3_ = int(_loc2_.bestMp * _loc2_.evade + 0.49) - 1;
               _loc4_ = _loc2_.bestUntackledMp - 1;
               if(MapPoint.isInMap(_loc2_.mapPoint.x - 1,_loc2_.mapPoint.y))
               {
                  this.markNode(_loc2_.mapPoint.x - 1,_loc2_.mapPoint.y,_loc3_,_loc4_);
               }
               if(MapPoint.isInMap(_loc2_.mapPoint.x + 1,_loc2_.mapPoint.y))
               {
                  this.markNode(_loc2_.mapPoint.x + 1,_loc2_.mapPoint.y,_loc3_,_loc4_);
               }
               if(MapPoint.isInMap(_loc2_.mapPoint.x,_loc2_.mapPoint.y - 1))
               {
                  this.markNode(_loc2_.mapPoint.x,_loc2_.mapPoint.y - 1,_loc3_,_loc4_);
               }
               if(MapPoint.isInMap(_loc2_.mapPoint.x,_loc2_.mapPoint.y + 1))
               {
                  this.markNode(_loc2_.mapPoint.x,_loc2_.mapPoint.y + 1,_loc3_,_loc4_);
               }
            }
         }
      }
      
      private function markNode(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = param1 - this._mapPoint.x + this._mp;
         var _loc7_:int = param2 - this._mapPoint.y + this._mp;
         var _loc8_:_ReachableCellStore;
         if(!(_loc8_ = this._cellGrid[_loc6_][_loc7_]))
         {
            _loc8_ = new _ReachableCellStore(MapPoint.fromCoords(param1,param2),_loc6_,_loc7_,this._cellGrid);
            this._cellGrid[_loc6_][_loc7_] = _loc8_;
            _loc8_.findState(this._infos);
            if(_loc8_.state != _ReachableCellStore.STATE_UNREACHABLE)
            {
               if(param3 >= 0)
               {
                  this._reachableCells.push(_loc8_.mapPoint.cellId);
               }
               else
               {
                  this._unreachableCells.push(_loc8_.mapPoint.cellId);
               }
            }
         }
         if(_loc8_.state == _ReachableCellStore.STATE_UNREACHABLE)
         {
            return;
         }
         if(!_loc8_.set || param3 > _loc8_.bestMp || param4 > _loc8_.bestUntackledMp)
         {
            if(param3 >= 0 && _loc8_.bestMp < 0)
            {
               this._reachableCells.push(_loc8_.mapPoint.cellId);
               if((_loc5_ = this._unreachableCells.indexOf(_loc8_.mapPoint.cellId)) == -1)
               {
                  throw new Error("INTERNAL ERROR : " + _loc8_.mapPoint.cellId + " : Can\'t delete cell because it don\'t exist");
               }
               this._unreachableCells.splice(_loc5_,1);
            }
            _loc8_.updateMp(param3,param4);
            if(param4 > 0)
            {
               if(_loc8_.state == _ReachableCellStore.STATE_REACHABLE)
               {
                  this._waitingCells.push(_loc8_);
               }
               else if(_loc8_.state == _ReachableCellStore.STATE_WATCHED)
               {
                  this._watchedCells.push(_loc8_);
               }
            }
         }
      }
   }
}

import com.ankamagames.atouin.data.map.CellData;
import com.ankamagames.atouin.managers.MapDisplayManager;
import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
import com.ankamagames.jerakine.types.positions.MapPoint;

class _ReachableCellStore
{
   
   public static const STATE_UNDEFINED:int = 0;
   
   public static const STATE_REACHABLE:int = 1;
   
   public static const STATE_UNREACHABLE:int = 2;
   
   public static const STATE_WATCHED:int = 3;
    
   
   public var mapPoint:MapPoint;
   
   public var state:int;
   
   public var evade:Number = 1;
   
   public var bestMp:int;
   
   public var bestUntackledMp:int;
   
   public var set:Boolean;
   
   public var gridX:int;
   
   public var gridY:int;
   
   public var cellGrid:Vector.<Vector.<_ReachableCellStore>>;
   
   function _ReachableCellStore(param1:MapPoint, param2:int, param3:int, param4:Vector.<Vector.<_ReachableCellStore>>)
   {
      super();
      this.mapPoint = param1;
      this.gridX = param2;
      this.gridY = param3;
      this.cellGrid = param4;
   }
   
   public function findState(param1:GameFightFighterInformations) : void
   {
      var _loc2_:_ReachableCellStore = null;
      var _loc3_:CellData = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[this.mapPoint.cellId]);
      if(!_loc3_.mov || _loc3_.nonWalkableDuringFight)
      {
         this.state = STATE_UNREACHABLE;
      }
      else
      {
         this.evade = 1;
         if(this.gridX > 0)
         {
            _loc2_ = this.cellGrid[this.gridX - 1][this.gridY];
            if(_loc2_ && _loc2_.state == STATE_UNREACHABLE)
            {
               this.evade = this.evade * _loc2_.evade;
            }
         }
         if(this.gridX < this.cellGrid.length - 1)
         {
            _loc2_ = this.cellGrid[this.gridX + 1][this.gridY];
            if(_loc2_ && _loc2_.state == STATE_UNREACHABLE)
            {
               this.evade = this.evade * _loc2_.evade;
            }
         }
         if(this.gridY > 0)
         {
            _loc2_ = this.cellGrid[this.gridX][this.gridY - 1];
            if(_loc2_ && _loc2_.state == STATE_UNREACHABLE)
            {
               this.evade = this.evade * _loc2_.evade;
            }
         }
         if(this.gridY < this.cellGrid[0].length - 1)
         {
            _loc2_ = this.cellGrid[this.gridX][this.gridY + 1];
            if(_loc2_ && _loc2_.state == STATE_UNREACHABLE)
            {
               this.evade = this.evade * _loc2_.evade;
            }
         }
         this.state = this.evade == 1?int(STATE_REACHABLE):int(STATE_WATCHED);
      }
   }
   
   public function updateMp(param1:int, param2:int) : void
   {
      this.set = true;
      if(param1 > this.bestMp)
      {
         this.bestMp = param1;
      }
      if(param2 > this.bestUntackledMp)
      {
         this.bestUntackledMp = param2;
      }
   }
}
