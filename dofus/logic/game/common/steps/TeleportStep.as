package com.ankamagames.dofus.logic.game.common.steps
{
   import com.ankamagames.dofus.scripts.ScriptsUtil;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class TeleportStep extends AbstractSequencable
   {
       
      
      private var _entity:AnimatedCharacter;
      
      private var _args:Array;
      
      public function TeleportStep(param1:AnimatedCharacter, param2:Array)
      {
         super();
         this._entity = param1;
         this._args = param2;
      }
      
      override public function start() : void
      {
         this._entity.movementBehavior.jump(this._entity,ScriptsUtil.getMapPoint(this._args));
         executeCallbacks();
      }
   }
}
