package com.ankamagames.dofus.scripts.spells
{
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.dofus.scripts.api.FxApi;
   import com.ankamagames.dofus.scripts.api.SequenceApi;
   import com.ankamagames.dofus.scripts.api.SpellFxApi;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class SpellScript5 extends SpellScriptBase
   {
       
      
      public function SpellScript5(param1:SpellFxRunner)
      {
         var _loc2_:MapPoint = null;
         var _loc3_:MapPoint = null;
         var _loc4_:ISequencable = null;
         super(param1);
         var _loc5_:MapPoint = FxApi.GetCurrentTargetedCell(runner);
         var _loc6_:MapPoint = FxApi.GetEntityCell(caster);
         var _loc7_:Vector.<MapPoint>;
         if((_loc7_ = SpellFxApi.GetPortalCells(runner)) && _loc7_.length > 1)
         {
            _loc2_ = _loc7_[0];
            _loc3_ = _loc7_[_loc7_.length - 1];
         }
         var _loc8_:MapPoint = !!_loc2_?_loc2_:_loc5_;
         var _loc9_:MapPoint = !!_loc3_?_loc3_:_loc6_;
         addCasterSetDirectionStep(_loc8_);
         addCasterAnimationStep();
         if(_loc2_)
         {
            addPortalAnimationSteps(SpellFxApi.GetPortalIds(runner));
         }
         if(SpellFxApi.HasSpellParam(spell,"glyphGfxId") && spell.silentCast == false && _loc5_)
         {
            _loc4_ = SequenceApi.CreateAddGlyphGfxStep(runner,SpellFxApi.GetSpellParam(spell,"glyphGfxId"),_loc5_,spell.markId);
            if(!latestStep)
            {
               SpellFxApi.AddFrontStep(runner,_loc4_);
            }
            else
            {
               SpellFxApi.AddStepAfter(runner,latestStep,_loc4_);
            }
            latestStep = _loc4_;
         }
         if(SpellFxApi.HasSpellParam(spell,"casterGfxId"))
         {
            addGfxEntityStep(_loc6_,_loc9_,_loc5_,PREFIX_CASTER);
         }
         if(SpellFxApi.HasSpellParam(spell,"targetGfxId"))
         {
            addGfxEntityStep(_loc5_,_loc9_,_loc5_,PREFIX_TARGET);
         }
         addAnimHitSteps();
         destroy();
      }
   }
}
