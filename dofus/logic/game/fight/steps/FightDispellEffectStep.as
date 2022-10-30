package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.StateBuff;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.sequencer.ISequencableListener;
   
   public class FightDispellEffectStep extends AbstractSequencable implements IFightStep, ISequencableListener
   {
       
      
      private var _fighterId:int;
      
      private var _boostUID:int;
      
      private var _virtualStep:IFightStep;
      
      public function FightDispellEffectStep(param1:int, param2:int)
      {
         super();
         this._fighterId = param1;
         this._boostUID = param2;
      }
      
      public function get stepType() : String
      {
         return "dispellEffect";
      }
      
      override public function start() : void
      {
         var _loc1_:StateBuff = null;
         var _loc2_:BasicBuff = BuffManager.getInstance().getBuff(this._boostUID,this._fighterId);
         if(_loc2_ && _loc2_ is StateBuff)
         {
            _loc1_ = _loc2_ as StateBuff;
            if(_loc1_.actionId == 952)
            {
               this._virtualStep = new FightEnteringStateStep(_loc1_.targetId,_loc1_.stateId,_loc1_.effect.durationString);
            }
            else
            {
               this._virtualStep = new FightLeavingStateStep(_loc1_.targetId,_loc1_.stateId);
            }
         }
         BuffManager.getInstance().dispellUniqueBuff(this._fighterId,this._boostUID,true,false,true);
         if(!this._virtualStep)
         {
            executeCallbacks();
         }
         else
         {
            this._virtualStep.addListener(this);
            this._virtualStep.start();
         }
      }
      
      public function stepFinished(param1:ISequencable, param2:Boolean = false) : void
      {
         this._virtualStep.removeListener(this);
         executeCallbacks();
      }
   }
}
