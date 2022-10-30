package com.ankamagames.dofus.scripts.spells
{
   import com.ankamagames.atouin.types.sequences.AddWorldEntityStep;
   import com.ankamagames.atouin.types.sequences.DestroyEntityStep;
   import com.ankamagames.atouin.types.sequences.ParableGfxMovementStep;
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.dofus.scripts.api.FxApi;
   import com.ankamagames.dofus.scripts.api.SequenceApi;
   import com.ankamagames.dofus.scripts.api.SpellFxApi;
   import com.ankamagames.dofus.types.entities.Projectile;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class SpellScript2 extends SpellScriptBase
   {
       
      
      public function SpellScript2(param1:SpellFxRunner)
      {
         var _loc2_:MapPoint = null;
         var _loc3_:MapPoint = null;
         var _loc4_:Projectile = null;
         var _loc5_:AddWorldEntityStep = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:Number = NaN;
         var _loc10_:ParableGfxMovementStep = null;
         var _loc11_:DestroyEntityStep = null;
         var _loc12_:Projectile = null;
         var _loc13_:AddWorldEntityStep = null;
         var _loc14_:ParableGfxMovementStep = null;
         var _loc15_:DestroyEntityStep = null;
         super(param1);
         var _loc16_:MapPoint = FxApi.GetCurrentTargetedCell(runner);
         var _loc17_:MapPoint = FxApi.GetEntityCell(caster);
         var _loc18_:Vector.<MapPoint>;
         if((_loc18_ = SpellFxApi.GetPortalCells(runner)) && _loc18_.length > 1)
         {
            _loc2_ = _loc18_[0];
            _loc3_ = _loc18_[_loc18_.length - 1];
         }
         var _loc19_:MapPoint = !!_loc2_?_loc2_:_loc16_;
         var _loc20_:MapPoint = !!_loc3_?_loc3_:_loc17_;
         addCasterSetDirectionStep(_loc19_);
         addCasterAnimationStep();
         if(SpellFxApi.HasSpellParam(spell,"casterGfxId"))
         {
            addGfxEntityStep(_loc17_,_loc17_,_loc19_,PREFIX_CASTER);
         }
         if(SpellFxApi.HasSpellParam(spell,"missileGfxId") && _loc19_ && caster)
         {
            _loc4_ = FxApi.CreateGfxEntity(SpellFxApi.GetSpellParam(spell,"missileGfxId"),_loc17_) as Projectile;
            _loc5_ = SequenceApi.CreateAddWorldEntityStep(_loc4_);
            _loc6_ = 100;
            if(SpellFxApi.HasSpellParam(spell,"missileSpeed"))
            {
               _loc6_ = (SpellFxApi.GetSpellParam(spell,"missileSpeed") + 10) * 10;
            }
            _loc7_ = 0.5;
            if(SpellFxApi.HasSpellParam(spell,"missileCurvature"))
            {
               _loc7_ = SpellFxApi.GetSpellParam(spell,"missileCurvature") / 10;
            }
            _loc8_ = true;
            if(SpellFxApi.HasSpellParam(spell,"missileOrientedToCurve"))
            {
               _loc8_ = SpellFxApi.GetSpellParam(spell,"missileOrientedToCurve");
            }
            _loc9_ = 0;
            if(SpellFxApi.HasSpellParam(spell,"missileGfxYOffset"))
            {
               _loc9_ = SpellFxApi.GetSpellParam(spell,"missileGfxYOffset");
            }
            _loc10_ = SequenceApi.CreateParableGfxMovementStep(runner,_loc4_,_loc19_,_loc6_,_loc7_,_loc9_,_loc8_);
            _loc11_ = SequenceApi.CreateDestroyEntityStep(_loc4_);
            if(_loc2_ && _loc19_ == _loc2_)
            {
               _loc12_ = FxApi.CreateGfxEntity(SpellFxApi.GetSpellParam(spell,"missileGfxId"),_loc3_) as Projectile;
               _loc13_ = SequenceApi.CreateAddWorldEntityStep(_loc12_);
               _loc14_ = SequenceApi.CreateParableGfxMovementStep(runner,_loc12_,_loc16_,_loc6_,_loc7_,_loc9_,_loc8_);
               _loc15_ = SequenceApi.CreateDestroyEntityStep(_loc12_);
            }
            if(!latestStep)
            {
               SpellFxApi.AddFrontStep(runner,_loc5_);
               SpellFxApi.AddStepAfter(runner,_loc5_,_loc10_);
               SpellFxApi.AddStepAfter(runner,_loc10_,_loc11_);
            }
            else
            {
               SpellFxApi.AddStepAfter(runner,latestStep,_loc5_);
               SpellFxApi.AddStepAfter(runner,_loc5_,_loc10_);
               SpellFxApi.AddStepAfter(runner,_loc10_,_loc11_);
            }
            latestStep = _loc10_;
            if(_loc12_)
            {
               latestStep = _loc11_;
               addPortalAnimationSteps(SpellFxApi.GetPortalIds(runner));
               SpellFxApi.AddStepAfter(runner,latestStep,_loc13_);
               SpellFxApi.AddStepAfter(runner,_loc13_,_loc14_);
               SpellFxApi.AddStepAfter(runner,_loc14_,_loc15_);
               latestStep = _loc14_;
            }
         }
         if(SpellFxApi.HasSpellParam(spell,"targetGfxId"))
         {
            addGfxEntityStep(_loc16_,_loc20_,_loc16_,PREFIX_TARGET);
         }
         addAnimHitSteps();
         destroy();
      }
   }
}
