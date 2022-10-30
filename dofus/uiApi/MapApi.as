package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.datacenter.world.Hint;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.MapReference;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.world.SuperArea;
   import com.ankamagames.dofus.datacenter.world.WorldMap;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.common.managers.FlagManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.messages.authorized.AdminQuietCommandMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class MapApi implements IApi
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MapApi));
       
      
      public function MapApi()
      {
         super();
      }
      
      [Untrusted]
      public function getCurrentSubArea() : SubArea
      {
         var _loc1_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         if(_loc1_)
         {
            return SubArea.getSubAreaById(_loc1_.currentSubAreaId);
         }
         return null;
      }
      
      [Untrusted]
      public function getCurrentWorldMap() : WorldMap
      {
         if(PlayedCharacterManager.getInstance().currentWorldMap)
         {
            return PlayedCharacterManager.getInstance().currentWorldMap;
         }
         return null;
      }
      
      [Untrusted]
      public function getAllSuperArea() : Array
      {
         return SuperArea.getAllSuperArea();
      }
      
      [Untrusted]
      public function getAllArea() : Array
      {
         return Area.getAllArea();
      }
      
      [Untrusted]
      public function getAllSubArea() : Array
      {
         return SubArea.getAllSubArea();
      }
      
      [Untrusted]
      public function getSubArea(param1:uint) : SubArea
      {
         return SubArea.getSubAreaById(param1);
      }
      
      [Untrusted]
      public function getSubAreaMapIds(param1:uint) : Vector.<uint>
      {
         return SubArea.getSubAreaById(param1).mapIds;
      }
      
      [Untrusted]
      public function getSubAreaCenter(param1:uint) : Point
      {
         return SubArea.getSubAreaById(param1).center;
      }
      
      [Untrusted]
      public function getWorldPoint(param1:uint) : WorldPoint
      {
         return WorldPoint.fromMapId(param1);
      }
      
      [Untrusted]
      public function getMapCoords(param1:uint) : Point
      {
         var _loc2_:MapPosition = MapPosition.getMapPositionById(param1);
         return new Point(_loc2_.posX,_loc2_.posY);
      }
      
      [Untrusted]
      public function getSubAreaShape(param1:uint) : Vector.<int>
      {
         var _loc2_:SubArea = SubArea.getSubAreaById(param1);
         if(_loc2_)
         {
            return _loc2_.shape;
         }
         return null;
      }
      
      [Untrusted]
      public function getHintIds() : Array
      {
         var _loc1_:Hint = null;
         var _loc2_:Object = null;
         var _loc3_:MapPosition = null;
         var _loc6_:int = 0;
         var _loc4_:Array = Hint.getHints() as Array;
         var _loc5_:Array = new Array();
         for each(_loc1_ in _loc4_)
         {
            if(_loc1_)
            {
               _loc6_++;
               _loc2_ = new Object();
               _loc2_.id = _loc1_.id;
               _loc2_.category = _loc1_.categoryId;
               _loc2_.name = _loc1_.name;
               _loc2_.mapId = _loc1_.mapId;
               _loc2_.realMapId = _loc1_.realMapId;
               _loc2_.gfx = _loc1_.gfx;
               _loc2_.subarea = SubArea.getSubAreaByMapId(_loc1_.mapId);
               if(_loc2_.subarea)
               {
                  _loc3_ = MapPosition.getMapPositionById(_loc1_.mapId);
                  if(_loc3_)
                  {
                     _loc2_.x = _loc3_.posX;
                     _loc2_.y = _loc3_.posY;
                     _loc2_.outdoor = _loc3_.outdoor;
                     _loc2_.worldMapId = _loc1_.worldMapId;
                     _loc5_.push(_loc2_);
                  }
               }
            }
         }
         _loc5_.sortOn("id",Array.NUMERIC);
         return _loc5_;
      }
      
      [Untrusted]
      public function subAreaByMapId(param1:uint) : SubArea
      {
         return SubArea.getSubAreaByMapId(param1);
      }
      
      [Untrusted]
      public function getMapIdByCoord(param1:int, param2:int) : Vector.<int>
      {
         return MapPosition.getMapIdByCoord(param1,param2);
      }
      
      [Untrusted]
      public function getMapPositionById(param1:uint) : MapPosition
      {
         return MapPosition.getMapPositionById(param1);
      }
      
      [Untrusted]
      public function intersects(param1:Object, param2:Object) : Boolean
      {
         if(!param1 || !param2)
         {
            return false;
         }
         var _loc3_:Rectangle = Rectangle(SecureCenter.unsecure(param1));
         var _loc4_:Rectangle = Rectangle(SecureCenter.unsecure(param2));
         if(_loc3_ && _loc4_)
         {
            return _loc3_.intersects(_loc4_);
         }
         return false;
      }
      
      [Trusted]
      public function movePlayer(param1:int, param2:int, param3:int = -1) : void
      {
         var _loc4_:WorldPoint = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Array = null;
         var _loc11_:uint = 0;
         var _loc12_:MapPosition = null;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:int = 0;
         var _loc16_:UiRootContainer = null;
         if(!PlayerManager.getInstance().hasRights)
         {
            return;
         }
         var _loc17_:AdminQuietCommandMessage = new AdminQuietCommandMessage();
         var _loc18_:Vector.<int>;
         if(_loc18_ = MapPosition.getMapIdByCoord(param1,param2))
         {
            _loc5_ = param3 == -1?uint(PlayedCharacterManager.getInstance().currentMap.worldId):uint(param3);
            _loc6_ = PlayedCharacterManager.getInstance().currentSubArea.area.superArea.id;
            _loc7_ = PlayedCharacterManager.getInstance().currentSubArea.area.id;
            _loc8_ = PlayedCharacterManager.getInstance().currentSubArea.id;
            _loc9_ = MapPosition.getMapPositionById(PlayedCharacterManager.getInstance().currentMap.mapId).outdoor;
            _loc10_ = [];
            var _loc19_:int = 0;
            var _loc20_:* = _loc18_;
            for(; §§hasnext(_loc20_,_loc19_); _loc15_ = this.getCurrentWorldMap().id,if(!(_loc16_ = Berilia.getInstance().getUi("cartographyUi")))
            {
               _loc16_ = Berilia.getInstance().getUi("cartographyPopup");
            },if(_loc16_)
            {
               _loc15_ = _loc16_.uiClass.currentWorldId;
            },if(_loc12_.subArea && _loc12_.subArea.worldmap && _loc12_.subArea.worldmap.id == _loc15_)
            {
               _loc13_ = _loc13_ + 100000;
            },if(_loc12_.hasPriorityOnWorldmap)
            {
               _loc13_ = _loc13_ + 10000;
            },if(_loc12_.outdoor == _loc9_)
            {
               _loc13_++;
            },if(_loc12_.subArea && _loc12_.subArea.id == _loc8_)
            {
               _loc13_ = _loc13_ + 100;
            },if(_loc12_.subArea && _loc12_.subArea.area && _loc12_.subArea.area.id == _loc7_)
            {
               _loc13_ = _loc13_ + 50;
            },if(_loc12_.subArea && _loc12_.subArea.area && _loc12_.subArea.area.superArea && _loc12_.subArea.area.superArea.id == _loc6_)
            {
               _loc13_ = _loc13_ + 25;
            },if(_loc14_ == _loc5_)
            {
               _loc13_ = _loc13_ + 100;
            },_loc10_.push({
               "id":_loc11_,
               "order":_loc13_
            }))
            {
               _loc11_ = §§nextvalue(_loc19_,_loc20_);
               _loc12_ = MapPosition.getMapPositionById(_loc11_);
               _loc13_ = 0;
               _loc14_ = WorldPoint.fromMapId(_loc12_.id).worldId;
               switch(_loc14_)
               {
                  case 0:
                     _loc13_ = 40;
                     continue;
                  case 3:
                     _loc13_ = 30;
                     continue;
                  case 2:
                     _loc13_ = 20;
                     continue;
                  case 1:
                     _loc13_ = 10;
                     continue;
                  default:
                     continue;
               }
            }
            if(_loc10_.length)
            {
               _loc10_.sortOn(["order","id"],[Array.NUMERIC,Array.NUMERIC | Array.DESCENDING]);
               _loc17_.initAdminQuietCommandMessage("moveto " + _loc10_.pop().id);
            }
            else
            {
               _loc17_.initAdminQuietCommandMessage("moveto " + param1 + "," + param2);
            }
         }
         else
         {
            _loc17_.initAdminQuietCommandMessage("moveto " + param1 + "," + param2);
         }
         ConnectionsHandler.getConnection().send(_loc17_);
      }
      
      [Trusted]
      public function movePlayerOnMapId(param1:uint) : void
      {
         var _loc2_:AdminQuietCommandMessage = new AdminQuietCommandMessage();
         _loc2_.initAdminQuietCommandMessage("moveto " + param1);
         if(PlayerManager.getInstance().hasRights)
         {
            ConnectionsHandler.getConnection().send(_loc2_);
         }
      }
      
      [Untrusted]
      public function getMapReference(param1:uint) : Object
      {
         return MapReference.getMapReferenceById(param1);
      }
      
      [Untrusted]
      public function getPhoenixsMaps() : Array
      {
         return FlagManager.getInstance().phoenixs;
      }
      
      [Untrusted]
      public function getClosestPhoenixMap() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MapPosition = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = -1;
         for each(_loc1_ in FlagManager.getInstance().phoenixs)
         {
            _loc3_ = MapPosition.getMapPositionById(_loc1_);
            if(_loc3_.worldMap == PlayedCharacterManager.getInstance().currentWorldMap.id)
            {
               _loc5_ = _loc3_.posX - PlayedCharacterManager.getInstance().currentMap.outdoorX;
               _loc6_ = _loc3_.posY - PlayedCharacterManager.getInstance().currentMap.outdoorY;
               _loc4_ = _loc5_ * _loc5_ + _loc6_ * _loc6_;
               if(_loc7_ == -1)
               {
                  _loc7_ = _loc4_;
                  _loc2_ = _loc1_;
               }
               else if(_loc4_ < _loc7_ || _loc4_ == 0)
               {
                  _loc7_ = _loc4_;
                  _loc2_ = _loc1_;
               }
            }
         }
         return _loc2_;
      }
      
      [Trusted]
      public function isInIncarnam() : Boolean
      {
         return this.getCurrentSubArea().areaId == 45;
      }
   }
}
