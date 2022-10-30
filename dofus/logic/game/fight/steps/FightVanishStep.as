package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.sequencer.CallbackStep;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class FightVanishStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _entityId:int;
      
      private var _sourceId:int;
      
      private var _vanishSubSequence:ISequencer;
      
      public function FightVanishStep(param1:int, param2:int)
      {
         super();
         this._entityId = param1;
         this._sourceId = param2;
      }
      
      public function get stepType() : String
      {
         return "vanish";
      }
      
      public function get entityId() : int
      {
         return this._entityId;
      }
      
      override public function start() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:TiphonSprite = null;
         var _loc4_:TiphonSprite = null;
         var _loc5_:IEntity;
         if(!(_loc5_ = DofusEntities.getEntity(this._entityId)))
         {
            _log.warn("Unable to play vanish of an unexisting fighter " + this._entityId + ".");
            this.vanishFinished();
            return;
         }
         BuffManager.getInstance().dispell(_loc5_.id,false,false,true);
         _loc1_ = BuffManager.getInstance().removeLinkedBuff(_loc5_.id,false,true);
         BuffManager.getInstance().reaffectBuffs(_loc5_.id);
         this._vanishSubSequence = new SerialSequencer(FightBattleFrame.FIGHT_SEQUENCER_NAME);
         _loc2_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._sourceId).disposition.cellId;
         if(_loc5_ is TiphonSprite && _loc5_.position.cellId != _loc2_)
         {
            _loc3_ = _loc5_ as TiphonSprite;
            if(_loc4_ = _loc3_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite)
            {
               _loc3_ = _loc4_;
            }
            this._vanishSubSequence.addStep(new PlayAnimationStep(_loc3_,AnimationEnum.ANIM_VANISH));
            this._vanishSubSequence.addStep(new CallbackStep(new Callback(this.onAnimEnd,_loc5_)));
         }
         this._vanishSubSequence.addStep(new CallbackStep(new Callback(this.manualRollOut,this._entityId)));
         this._vanishSubSequence.addStep(new FightDestroyEntityStep(_loc5_));
         this._vanishSubSequence.addEventListener(SequencerEvent.SEQUENCE_END,this.vanishFinished);
         this._vanishSubSequence.start();
      }
      
      override public function clear() : void
      {
         if(this._vanishSubSequence)
         {
            this._vanishSubSequence.clear();
         }
         super.clear();
      }
      
      private function manualRollOut(param1:int) : void
      {
         var _loc2_:FightContextFrame = null;
         if(FightContextFrame.fighterEntityTooltipId == param1)
         {
            TooltipManager.hide();
            TooltipManager.hide("fighter");
            _loc2_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
            if(_loc2_)
            {
               _loc2_.outEntity(param1);
            }
         }
      }
      
      private function onAnimEnd(param1:TiphonSprite) : void
      {
         var _loc2_:TiphonSprite = param1.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite;
         if(_loc2_)
         {
            param1 = _loc2_;
         }
         var _loc3_:DisplayObjectContainer = param1.getSubEntitySlot(FightCarryCharacterStep.CARRIED_SUBENTITY_CATEGORY,FightCarryCharacterStep.CARRIED_SUBENTITY_INDEX);
         if(_loc3_)
         {
            param1.removeSubEntity(_loc3_);
         }
      }
      
      private function vanishFinished(param1:Event = null) : void
      {
         if(this._vanishSubSequence)
         {
            this._vanishSubSequence.removeEventListener(SequencerEvent.SEQUENCE_END,this.vanishFinished);
            this._vanishSubSequence = null;
         }
         executeCallbacks();
      }
   }
}
