package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.types.sequences.AddWorldEntityStep;
   import com.ankamagames.atouin.types.sequences.ParableGfxMovementStep;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightSpellCastFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightTurnFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.CarrierAnimationModifier;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.entities.Glyph;
   import com.ankamagames.dofus.types.entities.Projectile;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.enums.PortalAnimationEnum;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.SetAnimationStep;
   import com.ankamagames.tiphon.sequence.SetDirectionStep;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class FightThrowCharacterStep extends AbstractSequencable implements IFightStep
   {
      
      private static const THROWING_PROJECTILE_FX:uint = 21209;
       
      
      private var _fighterId:int;
      
      private var _carriedId:int;
      
      private var _cellId:int;
      
      private var _throwSubSequence:ISequencer;
      
      private var _isCreature:Boolean;
      
      public var portals:Vector.<MapPoint>;
      
      public var portalIds:Vector.<int>;
      
      public function FightThrowCharacterStep(param1:int, param2:int, param3:int)
      {
         super();
         this._fighterId = param1;
         this._carriedId = param2;
         this._cellId = param3;
         this._isCreature = (Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).isInCreaturesFightMode();
      }
      
      public function get stepType() : String
      {
         return "throwCharacter";
      }
      
      override public function start() : void
      {
         var _loc1_:GameFightFighterInformations = null;
         var _loc2_:FightTurnFrame = null;
         var _loc3_:MapPoint = null;
         var _loc4_:MapPoint = null;
         var _loc5_:Projectile = null;
         var _loc9_:Boolean = false;
         var _loc6_:DisplayObject;
         var _loc7_:IEntity = (_loc6_ = DofusEntities.getEntity(this._fighterId) as DisplayObject) as IEntity;
         _loc6_ = TiphonUtility.getEntityWithoutMount(_loc6_ as TiphonSprite);
         var _loc8_:IEntity;
         if(!(_loc8_ = DofusEntities.getEntity(this._carriedId)))
         {
            _log.error("Attention, l\'entité [" + this._fighterId + "] ne porte pas [" + this._carriedId + "]");
            this.throwFinished();
            return;
         }
         if(!_loc6_)
         {
            _log.error("Attention, l\'entité [" + this._fighterId + "] ne porte pas [" + this._carriedId + "]");
            (_loc8_ as IDisplayable).display(PlacementStrataEnums.STRATA_PLAYER);
            if(_loc8_ is TiphonSprite)
            {
               (_loc8_ as TiphonSprite).setAnimation(AnimationEnum.ANIM_STATIQUE);
            }
            this.throwFinished();
            return;
         }
         if(this._cellId != -1)
         {
            _loc1_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._carriedId) as GameFightFighterInformations;
            _loc1_.disposition.cellId = this._cellId;
         }
         if(this._carriedId == CurrentPlayedFighterManager.getInstance().currentFighterId)
         {
            _loc2_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
            if(_loc2_)
            {
               _loc2_.freePlayer();
            }
         }
         if(TiphonSprite(_loc8_).look.getBone() == 761)
         {
            _loc9_ = true;
         }
         _log.debug(this._fighterId + " is throwing " + this._carriedId + " (invisibility : " + _loc9_ + ")");
         if(_loc6_ && _loc6_ is TiphonSprite)
         {
            (_loc6_ as TiphonSprite).removeAnimationModifierByClass(CarrierAnimationModifier);
         }
         this._throwSubSequence = new SerialSequencer(FightBattleFrame.FIGHT_SEQUENCER_NAME);
         if(this._cellId == -1 || _loc9_)
         {
            this._throwSubSequence.addStep(new FightRemoveCarriedEntityStep(this._fighterId,this._carriedId,FightCarryCharacterStep.CARRIED_SUBENTITY_CATEGORY,FightCarryCharacterStep.CARRIED_SUBENTITY_INDEX));
            if(this._cellId == -1)
            {
               if(_loc6_ is TiphonSprite)
               {
                  this._throwSubSequence.addStep(new SetAnimationStep(_loc6_ as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
               }
               this.startSubSequence();
               return;
            }
         }
         if(this.portals && this.portals.length > 1)
         {
            _loc3_ = this.portals[0];
            _loc4_ = this.portals[this.portals.length - 1];
         }
         var _loc10_:MapPoint = MapPoint.fromCellId(this._cellId);
         var _loc11_:MapPoint = _loc3_ != null?_loc3_:_loc10_;
         var _loc12_:int = _loc7_.position.distanceToCell(_loc11_);
         var _loc13_:int = _loc7_.position.advancedOrientationTo(_loc11_);
         if(!_loc9_)
         {
            _loc8_.position = _loc10_;
         }
         if(_loc6_ is TiphonSprite)
         {
            this._throwSubSequence.addStep(new SetDirectionStep((_loc6_ as TiphonSprite).rootEntity,_loc13_));
         }
         if(_loc12_ == 1)
         {
            _log.debug("Dropping nearby.");
            if(_loc6_ is TiphonSprite)
            {
               if(!this._isCreature)
               {
                  this._throwSubSequence.addStep(new PlayAnimationStep(_loc6_ as TiphonSprite,AnimationEnum.ANIM_DROP,_loc9_,true,TiphonEvent.ANIMATION_END,1,!!_loc9_?AnimationEnum.ANIM_STATIQUE:""));
                  if(_loc3_)
                  {
                     this.addCleanEntitiesSteps(_loc8_,_loc6_,false);
                     this.addPortalAnimationSteps();
                     (_loc5_ = new Projectile(EntitiesManager.getInstance().getFreeEntityId(),TiphonEntityLook.fromString("{" + THROWING_PROJECTILE_FX + "}"))).position = _loc4_;
                     this._throwSubSequence.addStep(new AddWorldEntityStep(_loc5_));
                     this._throwSubSequence.addStep(new ParableGfxMovementStep(_loc5_,_loc10_,200,0.3,-70,true,1));
                     this._throwSubSequence.addStep(new FightDestroyEntityStep(_loc5_));
                  }
               }
               else
               {
                  this._throwSubSequence.addStep(new SetAnimationStep(_loc6_ as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
               }
            }
         }
         else
         {
            _log.debug("Throwing away.");
            if(_loc6_ is TiphonSprite)
            {
               if(!this._isCreature)
               {
                  this._throwSubSequence.addStep(new PlayAnimationStep(_loc6_ as TiphonSprite,AnimationEnum.ANIM_THROW,_loc9_,true,TiphonEvent.ANIMATION_SHOT,1,!!_loc9_?AnimationEnum.ANIM_STATIQUE:""));
               }
               else
               {
                  (_loc8_ as TiphonSprite).visible = false;
               }
            }
            if(!_loc9_)
            {
               (_loc5_ = new Projectile(EntitiesManager.getInstance().getFreeEntityId(),TiphonEntityLook.fromString("{" + THROWING_PROJECTILE_FX + "}"))).position = _loc7_.position.getNearestCellInDirection(_loc13_);
               this._throwSubSequence.addStep(new AddWorldEntityStep(_loc5_));
               this._throwSubSequence.addStep(new ParableGfxMovementStep(_loc5_,_loc11_,200,0.3,-70,true,1));
               this._throwSubSequence.addStep(new FightDestroyEntityStep(_loc5_));
               if(_loc4_)
               {
                  this.addCleanEntitiesSteps(_loc8_,_loc6_,false);
                  this.addPortalAnimationSteps();
                  (_loc5_ = new Projectile(EntitiesManager.getInstance().getFreeEntityId(),TiphonEntityLook.fromString("{" + THROWING_PROJECTILE_FX + "}"))).position = _loc4_;
                  this._throwSubSequence.addStep(new AddWorldEntityStep(_loc5_));
                  this._throwSubSequence.addStep(new ParableGfxMovementStep(_loc5_,_loc10_,200,0.3,-70,true,1));
                  this._throwSubSequence.addStep(new FightDestroyEntityStep(_loc5_));
               }
            }
         }
         if(_loc9_)
         {
            this.startSubSequence();
            return;
         }
         if(_loc3_)
         {
            this._throwSubSequence.addStep(new AddWorldEntityStep(_loc8_));
         }
         else
         {
            this.addCleanEntitiesSteps(_loc8_,_loc6_,true);
         }
         this.startSubSequence();
      }
      
      private function startSubSequence() : void
      {
         this._throwSubSequence.addEventListener(SequencerEvent.SEQUENCE_END,this.throwFinished);
         this._throwSubSequence.start();
      }
      
      private function throwFinished(param1:Event = null) : void
      {
         var _loc2_:DisplayObject = null;
         if(this._throwSubSequence)
         {
            this._throwSubSequence.removeEventListener(SequencerEvent.SEQUENCE_END,this.throwFinished);
            this._throwSubSequence = null;
         }
         var _loc3_:DisplayObject = DofusEntities.getEntity(this._fighterId) as DisplayObject;
         if(_loc3_ is TiphonSprite)
         {
            _loc2_ = (_loc3_ as TiphonSprite).getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0);
            if(_loc2_)
            {
               (_loc3_ as TiphonSprite).removeAnimationModifierByClass(CarrierAnimationModifier);
               _loc3_ = _loc2_;
            }
         }
         var _loc4_:IEntity = DofusEntities.getEntity(this._carriedId);
         if(_loc3_ && _loc3_ is TiphonSprite)
         {
            (_loc3_ as TiphonSprite).removeAnimationModifierByClass(CarrierAnimationModifier);
            (_loc3_ as TiphonSprite).removeSubEntity(_loc4_ as DisplayObject);
         }
         (_loc4_ as TiphonSprite).visible = true;
         if(_loc4_ is IMovable)
         {
            IMovable(_loc4_).movementBehavior.synchroniseSubEntitiesPosition(IMovable(_loc4_));
         }
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_THROW,[this._fighterId,this._carriedId,this._cellId],0,castingSpellId);
         FightSpellCastFrame.updateRangeAndTarget();
         executeCallbacks();
      }
      
      private function addCleanEntitiesSteps(param1:IEntity, param2:DisplayObject, param3:Boolean) : void
      {
         this._throwSubSequence.addStep(new FightRemoveCarriedEntityStep(this._fighterId,this._carriedId,FightCarryCharacterStep.CARRIED_SUBENTITY_CATEGORY,FightCarryCharacterStep.CARRIED_SUBENTITY_INDEX));
         this._throwSubSequence.addStep(new SetDirectionStep(param1 as TiphonSprite,(param2 as TiphonSprite).rootEntity.getDirection()));
         if(param3)
         {
            this._throwSubSequence.addStep(new AddWorldEntityStep(param1));
         }
         this._throwSubSequence.addStep(new SetAnimationStep(param1 as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
         if(param2 is TiphonSprite)
         {
            this._throwSubSequence.addStep(new SetAnimationStep(param2 as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
         }
      }
      
      private function addPortalAnimationSteps() : void
      {
         var _loc1_:Glyph = MarkedCellsManager.getInstance().getGlyph(this.portalIds[0]);
         if(_loc1_)
         {
            if(_loc1_.getAnimation() != PortalAnimationEnum.STATE_NORMAL)
            {
               this._throwSubSequence.addStep(new PlayAnimationStep(_loc1_,PortalAnimationEnum.STATE_NORMAL,false,false));
            }
            this._throwSubSequence.addStep(new PlayAnimationStep(_loc1_,PortalAnimationEnum.STATE_ENTRY_SPELL,false,true,TiphonEvent.ANIMATION_SHOT));
         }
         var _loc2_:int = 1;
         while(_loc2_ < this.portalIds.length - 1)
         {
            _loc1_ = MarkedCellsManager.getInstance().getGlyph(this.portalIds[_loc2_]);
            if(_loc1_)
            {
               if(_loc1_.getAnimation() != PortalAnimationEnum.STATE_NORMAL)
               {
                  this._throwSubSequence.addStep(new PlayAnimationStep(_loc1_,PortalAnimationEnum.STATE_NORMAL,false,false));
               }
               this._throwSubSequence.addStep(new PlayAnimationStep(_loc1_,PortalAnimationEnum.STATE_ENTRY_SPELL,false,true,TiphonEvent.ANIMATION_SHOT));
            }
            _loc2_++;
         }
         _loc1_ = MarkedCellsManager.getInstance().getGlyph(this.portalIds[this.portalIds.length - 1]);
         if(_loc1_)
         {
            if(_loc1_.getAnimation() != PortalAnimationEnum.STATE_NORMAL)
            {
               this._throwSubSequence.addStep(new PlayAnimationStep(_loc1_,PortalAnimationEnum.STATE_NORMAL,false,false));
            }
            this._throwSubSequence.addStep(new PlayAnimationStep(_loc1_,PortalAnimationEnum.STATE_EXIT_SPELL,false,false));
         }
      }
      
      override public function toString() : String
      {
         return "[FightThrowCharacterStep(carrier=" + this._fighterId + ", carried=" + this._carriedId + ", cell=" + this._cellId + ")]";
      }
   }
}
