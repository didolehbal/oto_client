package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class FightDispellSpellStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _fighterId:int;
      
      private var _spellId:int;
      
      public function FightDispellSpellStep(param1:int, param2:int)
      {
         super();
         this._fighterId = param1;
         this._spellId = param2;
      }
      
      public function get stepType() : String
      {
         return "dispellSpell";
      }
      
      override public function start() : void
      {
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_SPELL_DISPELLED,[this._fighterId,this._spellId],this._fighterId,castingSpellId);
         BuffManager.getInstance().dispellSpell(this._fighterId,this._spellId,true);
         executeCallbacks();
      }
   }
}
