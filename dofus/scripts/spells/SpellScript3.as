package com.ankamagames.dofus.scripts.spells
{
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.dofus.scripts.api.FxApi;
   import com.ankamagames.dofus.scripts.api.SequenceApi;
   import com.ankamagames.dofus.scripts.api.SpellFxApi;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class SpellScript3 extends SpellScriptBase
   {
       
      
      public function SpellScript3(param1:SpellFxRunner)
      {
         var _loc2_:MapPoint = null;
         var _loc3_:MapPoint = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:ISequencable = null;
         var _loc8_:ISequencable = null;
         super(param1);
         var _loc9_:MapPoint = FxApi.GetCurrentTargetedCell(runner);
         var _loc10_:MapPoint = FxApi.GetEntityCell(caster);
         var _loc11_:Vector.<MapPoint>;
         if((_loc11_ = SpellFxApi.GetPortalCells(runner)) && _loc11_.length > 1)
         {
            _loc2_ = _loc11_[0];
            _loc3_ = _loc11_[_loc11_.length - 1];
         }
         var _loc12_:MapPoint = !!_loc2_?_loc2_:_loc9_;
         var _loc13_:MapPoint = !!_loc3_?_loc3_:_loc10_;
         addCasterSetDirectionStep(_loc12_);
         addCasterAnimationStep();
         if(SpellFxApi.HasSpellParam(spell,"casterGfxId"))
         {
            addGfxEntityStep(_loc10_,_loc10_,_loc9_,PREFIX_CASTER);
         }
         if(SpellFxApi.HasSpellParam(spell,"trailGfxId") && _loc12_)
         {
            _loc4_ = false;
            if(SpellFxApi.HasSpellParam(spell,"trailGfxShowUnder"))
            {
               _loc4_ = SpellFxApi.GetSpellParam(spell,"trailGfxShowUnder");
            }
            _loc5_ = false;
            if(SpellFxApi.HasSpellParam(spell,"useSpellZone"))
            {
               _loc5_ = SpellFxApi.GetSpellParam(spell,"useSpellZone");
            }
            _loc6_ = false;
            if(SpellFxApi.HasSpellParam(spell,"useOnlySpellZone"))
            {
               _loc6_ = SpellFxApi.GetSpellParam(spell,"useOnlySpellZone");
            }
            _loc7_ = SequenceApi.CreateAddGfxInLineStep(runner,SpellFxApi.GetSpellParam(spell,"trailGfxId"),_loc10_,_loc12_,SpellFxApi.GetSpellParam(spell,"trailGfxYOffset"),SpellFxApi.GetSpellParam(spell,"trailDisplayType"),SpellFxApi.GetSpellParam(spell,"trailGfxMinScale"),SpellFxApi.GetSpellParam(spell,"trailGfxMaxScale"),SpellFxApi.GetSpellParam(spell,"startTrailOnCaster"),SpellFxApi.GetSpellParam(spell,"endTrailOnTarget"),_loc4_,_loc5_,_loc6_);
            if(_loc2_ && _loc12_ == _loc2_)
            {
               _loc8_ = SequenceApi.CreateAddGfxInLineStep(runner,SpellFxApi.GetSpellParam(spell,"trailGfxId"),_loc13_,_loc9_,SpellFxApi.GetSpellParam(spell,"trailGfxYOffset"),SpellFxApi.GetSpellParam(spell,"trailDisplayType"),SpellFxApi.GetSpellParam(spell,"trailGfxMinScale"),SpellFxApi.GetSpellParam(spell,"trailGfxMaxScale"),SpellFxApi.GetSpellParam(spell,"startTrailOnCaster"),SpellFxApi.GetSpellParam(spell,"endTrailOnTarget"),_loc4_,_loc5_,_loc6_);
            }
            if(!latestStep)
            {
               SpellFxApi.AddFrontStep(runner,_loc7_);
            }
            else
            {
               SpellFxApi.AddStepAfter(runner,latestStep,_loc7_);
            }
            latestStep = _loc7_;
            if(_loc8_)
            {
               addPortalAnimationSteps(SpellFxApi.GetPortalIds(runner));
               SpellFxApi.AddStepAfter(runner,latestStep,_loc8_);
               latestStep = _loc8_;
            }
         }
         if(SpellFxApi.HasSpellParam(spell,"targetGfxId"))
         {
            addGfxEntityStep(_loc9_,_loc13_,_loc9_,PREFIX_TARGET);
         }
         addAnimHitSteps();
         destroy();
      }
   }
}
