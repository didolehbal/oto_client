package com.ankamagames.dofus.logic.game.fight.managers
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.renderers.TrapZoneRenderer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.network.enums.GameActionMarkCellsTypeEnum;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMarkedCell;
   import com.ankamagames.dofus.types.entities.Glyph;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class MarkedCellsManager implements IDestroyable
   {
      
      private static const MARK_SELECTIONS_PREFIX:String = "FightMark";
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(MarkedCellsManager));
      
      private static var _self:MarkedCellsManager;
       
      
      private var _marks:Dictionary;
      
      private var _glyphs:Dictionary;
      
      private var _markUid:uint;
      
      public function MarkedCellsManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("MarkedCellsManager is a singleton and should not be instanciated directly.");
         }
         this._marks = new Dictionary(true);
         this._glyphs = new Dictionary(true);
         this._markUid = 0;
      }
      
      public static function getInstance() : MarkedCellsManager
      {
         if(_self == null)
         {
            _self = new MarkedCellsManager();
         }
         return _self;
      }
      
      public function addMark(param1:int, param2:int, param3:Spell, param4:SpellLevel, param5:Vector.<GameActionMarkedCell>, param6:int = 2, param7:Boolean = true, param8:int = -1) : void
      {
         var _loc9_:MarkInstance = null;
         var _loc10_:GameActionMarkedCell = null;
         var _loc11_:Selection = null;
         var _loc12_:uint = 0;
         var _loc13_:Vector.<uint> = null;
         var _loc14_:GameActionMarkedCell = null;
         var _loc15_:uint = 0;
         if(!this._marks[param1] || this._marks[param1].cells.length == 0)
         {
            (_loc9_ = new MarkInstance()).markId = param1;
            _loc9_.markType = param2;
            _loc9_.associatedSpell = param3;
            _loc9_.associatedSpellLevel = param4;
            _loc9_.selections = new Vector.<Selection>(0,false);
            _loc9_.cells = new Vector.<uint>(0,false);
            _loc9_.teamId = param6;
            _loc9_.active = param7;
            if(param8 != -1)
            {
               _loc9_.markImpactCellId = param8;
            }
            else if(param5 && param5.length && param5[0])
            {
               _loc9_.markImpactCellId = param5[0].cellId;
            }
            else
            {
               _log.warn("Adding a mark with unknown markImpactCellId!");
            }
            if(param5.length > 0)
            {
               _loc10_ = param5[0];
               (_loc11_ = new Selection()).color = new Color(_loc10_.cellColor);
               _loc12_ = param2 == GameActionMarkTypeEnum.PORTAL?uint(PlacementStrataEnums.STRATA_PORTAL):uint(PlacementStrataEnums.STRATA_GLYPH);
               _loc11_.renderer = new TrapZoneRenderer(_loc12_);
               _loc13_ = new Vector.<uint>();
               for each(_loc14_ in param5)
               {
                  _loc13_.push(_loc14_.cellId);
               }
               if(_loc10_.cellsType == GameActionMarkCellsTypeEnum.CELLS_CROSS)
               {
                  _loc11_.zone = new Cross(0,_loc10_.zoneSize,DataMapProvider.getInstance());
               }
               else if(_loc10_.zoneSize > 0)
               {
                  _loc11_.zone = new Lozenge(0,_loc10_.zoneSize,DataMapProvider.getInstance());
               }
               else
               {
                  _loc11_.zone = new Custom(_loc13_);
               }
               SelectionManager.getInstance().addSelection(_loc11_,this.getSelectionUid(),_loc10_.cellId);
               for each(_loc15_ in _loc11_.cells)
               {
                  _loc9_.cells.push(_loc15_);
               }
               _loc9_.selections.push(_loc11_);
            }
            this._marks[param1] = _loc9_;
            this.updateDataMapProvider();
         }
      }
      
      public function getMarks(param1:int, param2:int, param3:Boolean = true) : Vector.<MarkInstance>
      {
         var _loc4_:MarkInstance = null;
         var _loc5_:Vector.<MarkInstance> = new Vector.<MarkInstance>();
         for each(_loc4_ in this._marks)
         {
            if(_loc4_.markType == param1 && (param2 == TeamEnum.TEAM_SPECTATOR || _loc4_.teamId == param2) && (!param3 || _loc4_.active))
            {
               _loc5_.push(_loc4_);
            }
         }
         return _loc5_;
      }
      
      public function getMarkDatas(param1:int) : MarkInstance
      {
         return this._marks[param1];
      }
      
      public function removeMark(param1:int) : void
      {
         var _loc2_:Selection = null;
         var _loc3_:Vector.<Selection> = (this._marks[param1] as MarkInstance).selections;
         for each(_loc2_ in _loc3_)
         {
            _loc2_.remove();
         }
         delete this._marks[param1];
         this.updateDataMapProvider();
      }
      
      public function addGlyph(param1:Glyph, param2:int) : void
      {
         this._glyphs[param2] = param1;
      }
      
      public function getGlyph(param1:int) : Glyph
      {
         return this._glyphs[param1] as Glyph;
      }
      
      public function removeGlyph(param1:int) : void
      {
         if(this._glyphs[param1])
         {
            Glyph(this._glyphs[param1]).remove();
            delete this._glyphs[param1];
         }
      }
      
      public function getMarksMapPoint(param1:int, param2:int = 2, param3:Boolean = true) : Vector.<MapPoint>
      {
         var _loc4_:MarkInstance = null;
         var _loc5_:Vector.<MapPoint> = new Vector.<MapPoint>();
         for each(_loc4_ in this._marks)
         {
            if(_loc4_.markType == param1 && (param2 == TeamEnum.TEAM_SPECTATOR || _loc4_.teamId == param2) && (!param3 || _loc4_.active))
            {
               _loc5_.push(MapPoint.fromCellId(_loc4_.cells[0]));
            }
         }
         return _loc5_;
      }
      
      public function getMarkAtCellId(param1:uint, param2:int = -1) : MarkInstance
      {
         var _loc3_:MarkInstance = null;
         for each(_loc3_ in this._marks)
         {
            if(_loc3_.markImpactCellId == param1 && (param2 == -1 || param2 == _loc3_.markType))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function cellHasTrap(param1:uint) : Boolean
      {
         var _loc2_:MarkInstance = null;
         for each(_loc2_ in this._marks)
         {
            if(_loc2_.markImpactCellId == param1 && _loc2_.markType == GameActionMarkTypeEnum.TRAP)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getCellIdsFromMarkIds(param1:Vector.<int>) : Vector.<int>
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = new Vector.<int>();
         for each(_loc2_ in param1)
         {
            if(this._marks[_loc2_] && this._marks[_loc2_].cells && this._marks[_loc2_].cells.length == 1)
            {
               _loc3_.push(this._marks[_loc2_].cells[0]);
            }
            else
            {
               _log.warn("Can\'t find cellId for markId " + _loc2_ + " in getCellIdsFromMarkIds()");
            }
         }
         _loc3_.fixed = true;
         return _loc3_;
      }
      
      public function getMapPointsFromMarkIds(param1:Vector.<int>) : Vector.<MapPoint>
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<MapPoint> = new Vector.<MapPoint>();
         for each(_loc2_ in param1)
         {
            if(this._marks[_loc2_] && this._marks[_loc2_].cells && this._marks[_loc2_].cells.length == 1)
            {
               _loc3_.push(MapPoint.fromCellId(this._marks[_loc2_].cells[0]));
            }
            else
            {
               _log.warn("Can\'t find cellId for markId " + _loc2_ + " in getMapPointsFromMarkIds()");
            }
         }
         _loc3_.fixed = true;
         return _loc3_;
      }
      
      public function getActivePortalsCount(param1:int = 2) : uint
      {
         var _loc2_:MarkInstance = null;
         var _loc3_:uint = 0;
         for each(_loc2_ in this._marks)
         {
            if(_loc2_.markType == GameActionMarkTypeEnum.PORTAL && (param1 == TeamEnum.TEAM_SPECTATOR || _loc2_.teamId == param1) && _loc2_.active)
            {
               _loc3_++;
            }
         }
         return _loc3_;
      }
      
      public function destroy() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:Array = new Array();
         for(_loc1_ in this._marks)
         {
            _loc5_.push(int(_loc1_));
         }
         _loc2_ = -1;
         _loc3_ = _loc5_.length;
         while(++_loc2_ < _loc3_)
         {
            this.removeMark(_loc5_[_loc2_]);
         }
         _loc5_.length = 0;
         for(_loc4_ in this._glyphs)
         {
            _loc5_.push(int(_loc4_));
         }
         _loc2_ = -1;
         _loc3_ = _loc5_.length;
         while(++_loc2_ < _loc3_)
         {
            this.removeGlyph(_loc5_[_loc2_]);
         }
         _self = null;
      }
      
      private function getSelectionUid() : String
      {
         return MARK_SELECTIONS_PREFIX + this._markUid++;
      }
      
      private function updateDataMapProvider() : void
      {
         var _loc1_:MarkInstance = null;
         var _loc2_:DataMapProvider = null;
         var _loc3_:MapPoint = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Array = [];
         for each(_loc1_ in this._marks)
         {
            for each(_loc5_ in _loc1_.cells)
            {
               _loc6_[_loc5_] = _loc6_[_loc5_] | _loc1_.markType;
            }
         }
         _loc2_ = DataMapProvider.getInstance();
         _loc4_ = 0;
         while(_loc4_ < AtouinConstants.MAP_CELLS_COUNT)
         {
            _loc3_ = MapPoint.fromCellId(_loc4_);
            _loc2_.setSpecialEffects(_loc4_,(_loc2_.pointSpecialEffects(_loc3_.x,_loc3_.y) | 3) ^ 3);
            if(_loc6_[_loc4_])
            {
               _loc2_.setSpecialEffects(_loc4_,_loc2_.pointSpecialEffects(_loc3_.x,_loc3_.y) | _loc6_[_loc4_]);
            }
            _loc4_++;
         }
         this.updateMarksNumber(GameActionMarkTypeEnum.PORTAL);
      }
      
      public function updateMarksNumber(param1:uint) : void
      {
         var _loc2_:MarkInstance = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Color = null;
         var _loc6_:MarkInstance = null;
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         for each(_loc2_ in this._marks)
         {
            if(_loc2_.markType == param1)
            {
               if(!_loc7_[_loc2_.teamId])
               {
                  _loc7_[_loc2_.teamId] = new Array();
                  _loc8_.push(_loc2_.teamId);
               }
               _loc7_[_loc2_.teamId].push(_loc2_);
            }
         }
         for each(_loc3_ in _loc8_)
         {
            _loc7_[_loc3_].sortOn("markId",Array.NUMERIC);
            _loc4_ = 1;
            for each(_loc6_ in _loc7_[_loc3_])
            {
               if(this._glyphs[_loc6_.markId])
               {
                  _loc5_ = _loc6_.selections[0].color;
                  Glyph(this._glyphs[_loc6_.markId]).addNumber(_loc4_,_loc5_);
               }
               _loc4_++;
            }
         }
      }
   }
}
