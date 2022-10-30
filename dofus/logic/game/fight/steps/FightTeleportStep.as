package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightSpellCastFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightTurnFrame;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class FightTeleportStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _fighterId:int;
      
      private var _destinationCell:MapPoint;
      
      public function FightTeleportStep(param1:int, param2:MapPoint)
      {
         super();
         this._fighterId = param1;
         this._destinationCell = param2;
      }
      
      public function get stepType() : String
      {
         return "teleport";
      }
      
      override public function start() : void
      {
         var _loc1_:FightTurnFrame = null;
         var _loc2_:IMovable = DofusEntities.getEntity(this._fighterId) as IMovable;
         if(_loc2_)
         {
            (_loc2_ as IDisplayable).display(PlacementStrataEnums.STRATA_PLAYER);
            _loc2_.jump(this._destinationCell);
         }
         else
         {
            _log.warn("Unable to teleport unknown entity " + this._fighterId + ".");
         }
         var _loc3_:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._fighterId) as GameFightFighterInformations;
         _loc3_.disposition.cellId = this._destinationCell.cellId;
         if(this._fighterId == PlayedCharacterManager.getInstance().id)
         {
            _loc1_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
            if(_loc1_ && _loc1_.myTurn)
            {
               _loc1_.drawPath();
            }
         }
         FightSpellCastFrame.updateRangeAndTarget();
         var _loc4_:FightContextFrame;
         if((_loc4_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame).showPermanentTooltips && _loc4_.battleFrame.targetedEntities.indexOf(_loc2_.id) != -1)
         {
            TooltipManager.updatePosition(_loc3_ is GameFightCharacterInformations?"PlayerShortInfos" + this._fighterId:"EntityShortInfos" + this._fighterId,"tooltipOverEntity_" + this._fighterId,(_loc2_ as AnimatedCharacter).absoluteBounds,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,true,_loc2_.position.cellId);
         }
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_TELEPORTED,[this._fighterId],0,castingSpellId);
         executeCallbacks();
      }
   }
}
