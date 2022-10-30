package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.CarrierAnimationModifier;
   import com.ankamagames.dofus.logic.game.fight.miscs.CarrierSubEntityBehaviour;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.RiderBehavior;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class FightTeleportationPreview
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(FightTeleportationPreview));
       
      
      private var _currentSpell:SpellWrapper;
      
      private var _targetedEntities:Vector.<int>;
      
      private var _teleportationEffectId:uint;
      
      private var _impactPos:MapPoint;
      
      private var _casterPos:MapPoint;
      
      private var _previews:Vector.<AnimatedCharacter>;
      
      private var _teleFraggedEntities:Vector.<AnimatedCharacter>;
      
      private var _previewIdEntityIdAssoc:Dictionary;
      
      private var _multipleTeleportationEffects:Boolean;
      
      private var _teleportAllTargets:Boolean;
      
      public function FightTeleportationPreview(param1:SpellWrapper, param2:Vector.<int>, param3:uint, param4:uint, param5:uint, param6:Boolean, param7:Boolean)
      {
         super();
         this._currentSpell = param1;
         this._targetedEntities = param2;
         this._teleportationEffectId = param3;
         this._impactPos = MapPoint.fromCellId(param4);
         this._casterPos = MapPoint.fromCellId(param5);
         this._previewIdEntityIdAssoc = new Dictionary();
         this._multipleTeleportationEffects = param6;
         this._teleportAllTargets = param7;
      }
      
      public function getEntitiesIds() : Vector.<int>
      {
         return this._targetedEntities;
      }
      
      public function getTelefraggedEntitiesIds() : Vector.<int>
      {
         var _loc1_:AnimatedCharacter = null;
         var _loc2_:Vector.<int> = new Vector.<int>(0);
         for each(_loc1_ in this._teleFraggedEntities)
         {
            _loc2_.push(!!this._previewIdEntityIdAssoc[_loc1_.id]?this._previewIdEntityIdAssoc[_loc1_.id]:_loc1_.id);
         }
         return _loc2_;
      }
      
      public function show() : void
      {
         var _loc1_:int = 0;
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:Function = null;
         var _loc4_:AnimatedCharacter = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         switch(this._teleportationEffectId)
         {
            case 1100:
               _loc3_ = this.teleportationToPreviousPosition;
               break;
            case 1104:
               _loc3_ = this.symetricTeleportation;
               break;
            case 1105:
               _loc3_ = this.symetricTeleportationFromCaster;
               break;
            case 1106:
               _loc3_ = this.symetricTeleportationFromImpactCell;
         }
         this._targetedEntities.sort(this.compareDistanceFromCaster);
         var _loc7_:int = this._targetedEntities.length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc2_ = DofusEntities.getEntity(this._targetedEntities[_loc6_]) as AnimatedCharacter;
            if(_loc2_)
            {
               (_loc4_ = this.getParentEntity(_loc2_) as AnimatedCharacter).visible = false;
               _loc3_.apply(this,[!!this._teleportAllTargets?_loc2_.id:_loc4_.id]);
            }
            _loc6_++;
         }
      }
      
      public function remove() : void
      {
         var _loc1_:int = 0;
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:AnimatedCharacter = null;
         var _loc4_:int = 0;
         var _loc5_:AnimatedCharacter = null;
         var _loc6_:FightContextFrame;
         var _loc7_:Boolean = (_loc6_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame).showPermanentTooltips && _loc6_.battleFrame.targetedEntities.length > 0;
         var _loc8_:AnimatedCharacter = !!(_loc8_ = EntitiesManager.getInstance().getEntityOnCell(FightContextFrame.currentCell,AnimatedCharacter) as AnimatedCharacter)?this.getParentEntity(_loc8_) as AnimatedCharacter:null;
         for each(_loc1_ in this._targetedEntities)
         {
            _loc2_ = DofusEntities.getEntity(_loc1_) as AnimatedCharacter;
            if(_loc2_)
            {
               _loc3_ = this.getParentEntity(_loc2_) as AnimatedCharacter;
               if(!_loc8_ || _loc8_.id != _loc3_.id)
               {
                  TooltipManager.hide("tooltipOverEntity_" + _loc3_.id);
                  if(_loc7_ && _loc6_.battleFrame.targetedEntities.indexOf(_loc3_.id) != -1)
                  {
                     _loc6_.displayEntityTooltip(_loc3_.id);
                  }
               }
               _loc3_.visible = true;
            }
         }
         if(this._previews)
         {
            for each(_loc5_ in this._previews)
            {
               _loc5_.destroy();
            }
         }
         if(this._teleFraggedEntities)
         {
            for each(_loc5_ in this._teleFraggedEntities)
            {
               TooltipManager.hide("tooltipOverEntity_" + _loc5_.id);
               if(_loc7_ && _loc6_.battleFrame.targetedEntities.indexOf(_loc5_.id) != -1)
               {
                  _loc6_.displayEntityTooltip(_loc5_.id);
               }
               _loc5_.visible = true;
            }
         }
      }
      
      private function symetricTeleportation(param1:int) : void
      {
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc4_:MapPoint;
         if((_loc4_ = this._casterPos.pointSymetry(this._impactPos)) && this.isValidCell(_loc4_.cellId) && EntitiesManager.getInstance().getEntitiesOnCell(this._impactPos.cellId,AnimatedCharacter).length > 0)
         {
            _loc2_ = this.createFighterPreview(param1,_loc4_,this._casterPos.advancedOrientationTo(this._impactPos));
            this.checkTeleFrag(_loc2_,param1,_loc4_,this._casterPos);
         }
         else
         {
            _loc3_.visible = true;
         }
      }
      
      private function symetricTeleportationFromCaster(param1:int) : void
      {
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc5_:MapPoint;
         var _loc4_:MapPoint;
         if((_loc5_ = (_loc4_ = _loc3_.position).pointSymetry(this._casterPos)) && this.isValidCell(_loc5_.cellId))
         {
            _loc2_ = this.createFighterPreview(param1,_loc5_,_loc3_.getDirection());
            this.checkTeleFrag(_loc2_,param1,_loc5_,_loc4_);
         }
         else
         {
            _loc3_.visible = true;
         }
      }
      
      private function symetricTeleportationFromImpactCell(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:AnimatedCharacter = null;
         var _loc4_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc7_:MapPoint;
         var _loc8_:MapPoint = (_loc7_ = !!(_loc6_ = Boolean((_loc5_ = this.getPreview(param1)) && this._multipleTeleportationEffects))?_loc5_.position:_loc4_.position).pointSymetry(this._impactPos);
         if(_loc6_ && this.willSwitchPosition(_loc5_,_loc8_))
         {
            _loc8_ = (_loc7_ = _loc4_.position).pointSymetry(this._impactPos);
         }
         if(_loc8_ && this.isValidCell(_loc8_.cellId))
         {
            _loc2_ = param1 == this._targetedEntities[0]?uint(_loc7_.advancedOrientationTo(this._impactPos)):uint(_loc4_.getDirection());
            _loc3_ = this.createFighterPreview(param1,_loc8_,_loc2_);
            this.checkTeleFrag(_loc3_,param1,_loc8_,_loc7_);
         }
         else
         {
            _loc4_.visible = true;
         }
      }
      
      private function teleportationToPreviousPosition(param1:int) : void
      {
         var _loc2_:* = false;
         var _loc3_:MapPoint = null;
         var _loc4_:AnimatedCharacter = null;
         var _loc5_:MapPoint = null;
         var _loc6_:AnimatedCharacter = null;
         var _loc7_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc8_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc9_:int;
         if((_loc9_ = _loc7_.getFighterPreviousPosition(param1)) != -1)
         {
            _loc2_ = !this._teleportAllTargets;
            if(this._teleportAllTargets && _loc8_.parentSprite && _loc8_.parentSprite.carriedEntity == _loc8_ && _loc9_ == _loc7_.getFighterPreviousPosition((_loc8_.parentSprite as AnimatedCharacter).id))
            {
               return;
            }
            if(this._teleportAllTargets && _loc8_.carriedEntity && _loc9_ == _loc7_.getFighterPreviousPosition((_loc8_.carriedEntity as AnimatedCharacter).id))
            {
               _loc2_ = true;
            }
            _loc3_ = MapPoint.fromCellId(_loc9_);
            if(_loc3_ && this.isValidCell(_loc3_.cellId))
            {
               _loc5_ = !!(_loc4_ = this.getPreview(param1))?_loc4_.position:_loc8_.position;
               _loc6_ = this.createFighterPreview(param1,_loc3_,_loc8_.getDirection(),_loc2_);
               this.checkTeleFrag(_loc6_,param1,_loc3_,_loc5_);
            }
            else
            {
               _loc8_.visible = true;
            }
         }
         else if(this._teleportAllTargets && this.isCarriedEntityTeleported(_loc8_))
         {
            this.createFighterPreview(param1,MapPoint.fromCellId(_loc7_.entitiesFrame.getEntityInfos(param1).disposition.cellId),_loc8_.getDirection(),false);
         }
         else if(!this.getPreview(param1))
         {
            _loc8_.visible = true;
         }
      }
      
      private function checkTeleFrag(param1:AnimatedCharacter, param2:int, param3:MapPoint, param4:MapPoint) : void
      {
         var _loc5_:AnimatedCharacter = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:AnimatedCharacter = null;
         var _loc9_:Array;
         if((_loc9_ = EntitiesManager.getInstance().getEntitiesOnCell(param3.cellId,AnimatedCharacter)).length > 0)
         {
            for each(_loc5_ in _loc9_)
            {
               if(_loc5_ != param1 && _loc5_.id != param2)
               {
                  if(this._previewIdEntityIdAssoc[_loc5_.id])
                  {
                     _loc6_ = this._previewIdEntityIdAssoc[_loc5_.id];
                  }
                  else
                  {
                     if(this.getPreview(_loc5_.id))
                     {
                        continue;
                     }
                     _loc6_ = _loc5_.id;
                  }
                  _loc5_ = this.getParentEntity(_loc5_) as AnimatedCharacter;
                  if(this.canTeleport(_loc6_) && !_loc5_.carriedEntity && !param1.carriedEntity)
                  {
                     this.telefrag(_loc5_,param1,param2,param4);
                  }
                  else
                  {
                     _loc7_ = this._previewIdEntityIdAssoc[param1.id];
                     if(_loc8_ = DofusEntities.getEntity(_loc7_) as AnimatedCharacter)
                     {
                        (_loc8_ = this.getParentEntity(_loc8_) as AnimatedCharacter).visible = true;
                     }
                     param1.destroy();
                  }
                  break;
               }
            }
         }
      }
      
      private function telefrag(param1:AnimatedCharacter, param2:AnimatedCharacter, param3:int, param4:MapPoint) : void
      {
         var _loc6_:MapPoint = !!(_loc5_ = this.getPreview(param1.id))?_loc5_.position:null;
         var _loc7_:AnimatedCharacter = this.createFighterPreview(param1.id,param4,param1.getDirection());
         var _loc8_:int = !!this._previewIdEntityIdAssoc[param1.id]?int(this._previewIdEntityIdAssoc[param1.id]):int(param1.id);
         if(param4.equals(param2.position) && _loc6_)
         {
            this.telefrag(param2,_loc7_,_loc8_,_loc6_);
            return;
         }
         if(!this._previewIdEntityIdAssoc[param1.id])
         {
            param1.visible = false;
         }
         if(!this._teleFraggedEntities)
         {
            this._teleFraggedEntities = new Vector.<AnimatedCharacter>(0);
         }
         this._teleFraggedEntities.push(param1);
         this.showTelefragTooltip(_loc8_,_loc7_);
         this.showTelefragTooltip(param3,param2);
      }
      
      private function willSwitchPosition(param1:AnimatedCharacter, param2:MapPoint) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:AnimatedCharacter = null;
         var _loc5_:int = 0;
         var _loc6_:FightContextFrame = null;
         var _loc7_:GameFightFighterInformations = null;
         var _loc8_:GameFightFighterInformations = null;
         var _loc9_:int = 0;
         if(param2 && this.isValidCell(param2.cellId))
         {
            _loc3_ = EntitiesManager.getInstance().getEntitiesOnCell(param2.cellId,AnimatedCharacter);
            _loc5_ = this._previewIdEntityIdAssoc[param1.id];
            _loc7_ = (_loc6_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame).entitiesFrame.getEntityInfos(_loc5_) as GameFightFighterInformations;
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_ != param1 && _loc4_.id != _loc5_)
               {
                  _loc9_ = !!this._previewIdEntityIdAssoc[_loc4_.id]?int(this._previewIdEntityIdAssoc[_loc4_.id]):int(_loc4_.id);
                  _loc8_ = _loc6_.entitiesFrame.getEntityInfos(_loc9_) as GameFightFighterInformations;
                  if(_loc7_.teamId == _loc8_.teamId)
                  {
                     return true;
                  }
                  return false;
               }
            }
         }
         return false;
      }
      
      private function getPreview(param1:int) : AnimatedCharacter
      {
         var _loc2_:* = undefined;
         var _loc3_:AnimatedCharacter = null;
         if(this._previewIdEntityIdAssoc[param1])
         {
            for each(_loc3_ in this._previews)
            {
               if(_loc3_.id == param1)
               {
                  return _loc3_;
               }
            }
         }
         else
         {
            for(_loc2_ in this._previewIdEntityIdAssoc)
            {
               if(this._previewIdEntityIdAssoc[_loc2_] == param1)
               {
                  for each(_loc3_ in this._previews)
                  {
                     if(_loc3_.id == _loc2_)
                     {
                        return _loc3_;
                     }
                  }
               }
            }
         }
         return null;
      }
      
      private function canTeleport(param1:int) : Boolean
      {
         var _loc2_:Monster = null;
         var _loc3_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc4_:GameFightFighterInformations;
         if((_loc4_ = _loc3_.entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations) is GameFightMonsterInformations)
         {
            _loc2_ = Monster.getMonsterById((_loc4_ as GameFightMonsterInformations).creatureGenericId);
            if(!_loc2_.canSwitchPos)
            {
               return false;
            }
         }
         var _loc5_:Array;
         return !(_loc5_ = FightersStateManager.getInstance().getStates(param1)) || _loc5_.indexOf(6) == -1 && _loc5_.indexOf(97) == -1;
      }
      
      private function createFighterPreview(param1:int, param2:MapPoint, param3:uint, param4:Boolean = true) : AnimatedCharacter
      {
         var _loc5_:FightContextFrame = null;
         var _loc6_:GameFightFighterInformations = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc10_:TiphonSprite = !!param4?this.getParentEntity(_loc9_):_loc9_;
         var _loc11_:AnimatedCharacter;
         if(!(_loc11_ = this.getPreview(param1)))
         {
            _loc11_ = new AnimatedCharacter(EntitiesManager.getInstance().getFreeEntityId(),_loc10_.look);
            this.addPreviewSubEntities(_loc10_,_loc11_);
            _loc11_.mouseEnabled = _loc11_.mouseChildren = false;
            if(!param4 && _loc11_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_LIFTED_ENTITY,0))
            {
               _loc11_.removeAnimationModifierByClass(CarrierAnimationModifier);
               _loc11_.removeSubEntity(_loc11_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_LIFTED_ENTITY,0));
               _loc11_.setAnimation(AnimationEnum.ANIM_STATIQUE);
            }
            if(!this._previews)
            {
               this._previews = new Vector.<AnimatedCharacter>(0);
            }
            this._previews.push(_loc11_);
            this._previewIdEntityIdAssoc[_loc11_.id] = param1;
         }
         _loc11_.position = param2;
         _loc11_.setDirection(param3);
         _loc11_.display(PlacementStrataEnums.STRATA_PLAYER);
         if(TooltipManager.isVisible("tooltipOverEntity_" + param1))
         {
            _loc7_ = (_loc6_ = (_loc5_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame).entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations) is GameFightCharacterInformations?"PlayerShortInfos" + param1:"EntityShortInfos" + param1;
            _loc8_ = "tooltipOverEntity_" + param1;
            TooltipManager.updatePosition(_loc7_,_loc8_,_loc11_.absoluteBounds,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,true,_loc11_.position.cellId);
         }
         return _loc11_;
      }
      
      private function getParentEntity(param1:TiphonSprite) : TiphonSprite
      {
         var _loc2_:TiphonSprite = null;
         var _loc3_:TiphonSprite = param1.parentSprite;
         while(_loc3_)
         {
            _loc2_ = _loc3_;
            _loc3_ = _loc3_.parentSprite;
         }
         return !!_loc2_?_loc2_:param1;
      }
      
      private function isCarriedEntityTeleported(param1:AnimatedCharacter) : Boolean
      {
         var _loc2_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc3_:AnimatedCharacter = param1.carriedEntity as AnimatedCharacter;
         if(_loc3_)
         {
            return _loc2_.getFighterPreviousPosition(_loc3_.id) != -1;
         }
         return false;
      }
      
      private function addPreviewSubEntities(param1:TiphonSprite, param2:TiphonSprite) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:TiphonSprite = null;
         if(param1.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER) && param1.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER).length)
         {
            _loc3_ = true;
            param2.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,new RiderBehavior());
         }
         var _loc5_:TiphonSprite = param1;
         if(_loc3_ && param1.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0))
         {
            _loc5_ = param1.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite;
         }
         var _loc6_:TiphonSprite = param2;
         if(_loc3_ && param2.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0))
         {
            _loc6_ = param2.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite;
         }
         var _loc7_:TiphonSprite = _loc5_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_LIFTED_ENTITY,0) as TiphonSprite;
         this.addTeamCircle(param1,param2);
         if(_loc7_)
         {
            _loc4_ = new TiphonSprite(_loc7_.look);
            _loc6_.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_LIFTED_ENTITY,new CarrierSubEntityBehaviour());
            _loc6_.isCarrying = true;
            _loc6_.addAnimationModifier(CarrierAnimationModifier.getInstance());
            _loc6_.addSubEntity(_loc4_,SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_LIFTED_ENTITY,0);
            _loc4_.setAnimation(AnimationEnum.ANIM_STATIQUE);
            _loc6_.setAnimation(AnimationEnum.ANIM_STATIQUE_CARRYING);
            this.addPreviewSubEntities(_loc7_,_loc4_);
         }
      }
      
      private function addTeamCircle(param1:TiphonSprite, param2:TiphonSprite) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         for each(_loc4_ in _loc5_.getEntitiesIdsList())
         {
            if(DofusEntities.getEntity(_loc4_) == param1)
            {
               _loc3_ = _loc4_;
            }
         }
         if(_loc3_ != 0)
         {
            _loc5_.addCircleToFighter(param2,(_loc5_.getEntityInfos(_loc3_) as GameFightFighterInformations).teamId == TeamEnum.TEAM_DEFENDER?uint(255):uint(16711680));
         }
      }
      
      private function isValidCell(param1:int) : Boolean
      {
         if(param1 == -1)
         {
            return false;
         }
         var _loc2_:CellData = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param1];
         return _loc2_.mov && !_loc2_.nonWalkableDuringFight;
      }
      
      private function compareDistanceFromCaster(param1:uint, param2:uint) : int
      {
         var _loc3_:IEntity = DofusEntities.getEntity(param1);
         var _loc4_:IEntity = DofusEntities.getEntity(param2);
         var _loc5_:int = _loc3_.position.distanceToCell(this._casterPos);
         var _loc6_:int = _loc4_.position.distanceToCell(this._casterPos);
         if(_loc5_ < _loc6_)
         {
            return -1;
         }
         if(_loc5_ > _loc6_)
         {
            return 1;
         }
         return 0;
      }
      
      private function showTelefragTooltip(param1:int, param2:AnimatedCharacter) : void
      {
         var _loc3_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc4_:GameFightFighterInformations = _loc3_.entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
         TooltipManager.hide("tooltipOverEntity_" + param1);
         _loc3_.displayEntityTooltip(param1,this._currentSpell,null,true,FightContextFrame.currentCell,{
            "fightStatus":(_loc4_.teamId == TeamEnum.TEAM_DEFENDER?244:251),
            "target":param2.absoluteBounds,
            "cellId":param2.position.cellId
         });
      }
   }
}
