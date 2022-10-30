package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class FightKillStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _killerId:int;
      
      private var _fighterId:int;
      
      public function FightKillStep(param1:int, param2:int)
      {
         super();
         this._killerId = param2;
         this._fighterId = param1;
      }
      
      public function get stepType() : String
      {
         return "kill";
      }
      
      override public function start() : void
      {
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_GOT_KILLED,[this._killerId,this._fighterId],this._fighterId,castingSpellId);
         executeCallbacks();
      }
   }
}
