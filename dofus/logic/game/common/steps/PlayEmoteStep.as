package com.ankamagames.dofus.logic.game.common.steps
{
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.messages.GameRolePlaySetAnimationMessage;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.tiphon.events.TiphonEvent;
   
   public class PlayEmoteStep extends AbstractSequencable
   {
       
      
      private var _entity:AnimatedCharacter;
      
      private var _emoteId:int;
      
      private var _waitForEnd:Boolean;
      
      public function PlayEmoteStep(param1:AnimatedCharacter, param2:int, param3:Boolean)
      {
         super();
         this._entity = param1;
         this._emoteId = param2;
         this._waitForEnd = param3;
         timeout = 10000;
      }
      
      override public function start() : void
      {
         var _loc1_:String = null;
         var _loc2_:RoleplayEntitiesFrame = null;
         var _loc3_:Emoticon = Emoticon.getEmoticonById(this._emoteId);
         if(_loc3_)
         {
            if(this._waitForEnd)
            {
               this._entity.addEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
            }
            _loc1_ = _loc3_.getAnimName(this._entity.look);
            _loc2_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
            _loc2_.currentEmoticon = this._emoteId;
            _loc2_.process(new GameRolePlaySetAnimationMessage(_loc2_.getEntityInfos(this._entity.id),_loc1_,0,!_loc3_.persistancy,_loc3_.eight_directions));
         }
         if(!_loc3_ || !this._waitForEnd)
         {
            executeCallbacks();
         }
      }
      
      private function onAnimationEnd(param1:TiphonEvent) : void
      {
         param1.currentTarget.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
         executeCallbacks();
      }
   }
}
