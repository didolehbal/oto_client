package com.ankamagames.dofus.scripts.spells
{
   import com.ankamagames.dofus.logic.game.fight.steps.FightLifeVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.IFightStep;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.dofus.scripts.api.FxApi;
   import com.ankamagames.dofus.scripts.api.SequenceApi;
   import com.ankamagames.dofus.scripts.api.SpellFxApi;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.Glyph;
   import com.ankamagames.dofus.types.enums.PortalAnimationEnum;
   import com.ankamagames.jerakine.enum.AddGfxModeEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.SetDirectionStep;
   import flash.utils.getQualifiedClassName;
   
   public class SpellScriptBase
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellScriptBase));
      
      protected static const PREFIX_CASTER:String = "caster";
      
      protected static const PREFIX_TARGET:String = "target";
       
      
      protected var latestStep:ISequencable;
      
      protected var runner:SpellFxRunner;
      
      protected var spell:CastingSpell;
      
      protected var caster:AnimatedCharacter;
      
      public function SpellScriptBase(param1:SpellFxRunner)
      {
         super();
         this.runner = param1;
         this.spell = SpellFxApi.GetCastingSpell(this.runner);
         this.caster = FxApi.GetCurrentCaster(this.runner) as AnimatedCharacter;
      }
      
      protected function addCasterSetDirectionStep(param1:MapPoint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:SetDirectionStep = null;
         if(this.caster && this.caster.position && param1 && !FxApi.IsPositionsEquals(this.caster.position,param1))
         {
            _loc2_ = this.caster.position.advancedOrientationTo(param1);
            _loc3_ = new SetDirectionStep(this.caster,_loc2_);
            SpellFxApi.AddFrontStep(this.runner,_loc3_);
            this.latestStep = _loc3_;
         }
      }
      
      protected function addCasterAnimationStep() : void
      {
         var _loc1_:ISequencable = null;
         if(this.caster && SpellFxApi.HasSpellParam(this.spell,"animId"))
         {
            _loc1_ = SequenceApi.CreatePlayAnimationStep(this.caster,"AnimAttaque" + SpellFxApi.GetSpellParam(this.spell,"animId"),true,true,"SHOT");
            if(!this.latestStep)
            {
               SpellFxApi.AddFrontStep(this.runner,_loc1_);
            }
            else
            {
               SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc1_);
            }
            this.latestStep = _loc1_;
         }
      }
      
      protected function addGfxEntityStep(param1:MapPoint, param2:MapPoint, param3:MapPoint, param4:String, param5:String = "") : void
      {
         var _loc6_:MapPoint = null;
         var _loc7_:MapPoint = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         if(!param1 || !param2 || !param3)
         {
            return;
         }
         if(SpellFxApi.HasSpellParam(this.spell,param4 + "GfxOriented" + param5))
         {
            if(SpellFxApi.GetSpellParam(this.spell,param4 + "GfxOriented" + param5))
            {
               _loc8_ = FxApi.GetAngleTo(param2,param3);
            }
         }
         if(SpellFxApi.HasSpellParam(this.spell,param4 + "GfxYOffset" + param5))
         {
            _loc9_ = SpellFxApi.GetSpellParam(this.spell,param4 + "GfxYOffset" + param5);
         }
         if(SpellFxApi.HasSpellParam(this.spell,param4 + "GfxShowUnder" + param5))
         {
            _loc10_ = SpellFxApi.GetSpellParam(this.spell,param4 + "GfxShowUnder" + param5);
         }
         var _loc11_:uint;
         if((_loc11_ = SpellFxApi.GetSpellParam(this.spell,param4 + "GfxDisplayType" + param5)) == AddGfxModeEnum.ORIENTED)
         {
            _loc6_ = param2;
            _loc7_ = param3;
            if(param2 && _loc7_ && param2.cellId == _loc7_.cellId)
            {
               if((_loc7_ = _loc7_.getNearestCellInDirection(this.caster.getDirection())) == null)
               {
                  _loc7_ = param3;
               }
            }
            if(!_loc7_)
            {
               _log.debug("Failed to add a GfxEntityStep, expecting it to be oriented, but found no endCell!");
               return;
            }
         }
         var _loc12_:ISequencable = SequenceApi.CreateAddGfxEntityStep(this.runner,SpellFxApi.GetSpellParam(this.spell,param4 + "GfxId" + param5),param1,_loc8_,_loc9_,_loc11_,_loc6_,_loc7_,_loc10_);
         if(!this.latestStep)
         {
            SpellFxApi.AddFrontStep(this.runner,_loc12_);
         }
         else if(param4 == PREFIX_TARGET && SpellFxApi.HasSpellParam(this.spell,"playTargetGfxFirst" + param5) && SpellFxApi.GetSpellParam(this.spell,"playTargetGfxFirst" + param5))
         {
            SpellFxApi.AddStepBefore(this.runner,this.latestStep,_loc12_);
         }
         else
         {
            SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc12_);
         }
         this.latestStep = _loc12_;
      }
      
      protected function addAnimHitSteps() : void
      {
         var _loc1_:FightLifeVariationStep = null;
         var _loc2_:String = null;
         var _loc3_:Vector.<IFightStep> = Vector.<IFightStep>(SpellFxApi.GetStepsFromType(this.runner,"lifeVariation"));
         for each(_loc1_ in _loc3_)
         {
            if(_loc1_.value < 0)
            {
               _loc2_ = "AnimHit";
               if(SpellFxApi.HasSpellParam(this.spell,"customHitAnim"))
               {
                  _loc2_ = SpellFxApi.GetSpellParam(this.spell,"customHitAnim");
               }
               SpellFxApi.AddStepBefore(this.runner,_loc1_,SequenceApi.CreatePlayAnimationStep(_loc1_.target as TiphonSprite,_loc2_,true,false));
            }
         }
      }
      
      protected function addPortalAnimationSteps(param1:Vector.<int>) : void
      {
         var _loc2_:ISequencable = null;
         if(this.spell.spellRank.canThrowPlayer)
         {
            return;
         }
         var _loc3_:Glyph = SpellFxApi.GetPortalEntity(this.runner,param1[0]);
         if(_loc3_)
         {
            if(_loc3_.getAnimation() != PortalAnimationEnum.STATE_NORMAL)
            {
               _loc2_ = new PlayAnimationStep(_loc3_,PortalAnimationEnum.STATE_NORMAL,false,false);
               if(!this.latestStep)
               {
                  SpellFxApi.AddFrontStep(this.runner,_loc2_);
               }
               else
               {
                  SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc2_);
               }
               this.latestStep = _loc2_;
            }
            _loc2_ = new PlayAnimationStep(_loc3_,PortalAnimationEnum.STATE_ENTRY_SPELL,false,true,TiphonEvent.ANIMATION_SHOT);
            if(!this.latestStep)
            {
               SpellFxApi.AddFrontStep(this.runner,_loc2_);
            }
            else
            {
               SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc2_);
            }
            this.latestStep = _loc2_;
         }
         var _loc4_:int = 1;
         while(_loc4_ < param1.length - 1)
         {
            _loc3_ = SpellFxApi.GetPortalEntity(this.runner,param1[_loc4_]);
            if(_loc3_)
            {
               if(_loc3_.getAnimation() != PortalAnimationEnum.STATE_NORMAL)
               {
                  _loc2_ = new PlayAnimationStep(_loc3_,PortalAnimationEnum.STATE_NORMAL,false,false);
                  if(!this.latestStep)
                  {
                     SpellFxApi.AddFrontStep(this.runner,_loc2_);
                  }
                  else
                  {
                     SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc2_);
                  }
                  this.latestStep = _loc2_;
               }
               _loc2_ = new PlayAnimationStep(_loc3_,PortalAnimationEnum.STATE_ENTRY_SPELL,false,true,TiphonEvent.ANIMATION_SHOT);
               SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc2_);
               this.latestStep = _loc2_;
            }
            _loc4_++;
         }
         _loc3_ = SpellFxApi.GetPortalEntity(this.runner,param1[param1.length - 1]);
         if(_loc3_)
         {
            if(_loc3_.getAnimation() != PortalAnimationEnum.STATE_NORMAL)
            {
               _loc2_ = new PlayAnimationStep(_loc3_,PortalAnimationEnum.STATE_NORMAL,false,false);
               if(!this.latestStep)
               {
                  SpellFxApi.AddFrontStep(this.runner,_loc2_);
               }
               else
               {
                  SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc2_);
               }
               this.latestStep = _loc2_;
            }
            _loc2_ = new PlayAnimationStep(_loc3_,PortalAnimationEnum.STATE_EXIT_SPELL,false,false);
            SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc2_);
            this.latestStep = _loc2_;
         }
      }
      
      protected function destroy() : void
      {
         this.latestStep = null;
         this.spell = null;
         this.caster = null;
      }
   }
}
