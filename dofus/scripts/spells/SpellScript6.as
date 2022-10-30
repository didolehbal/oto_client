package com.ankamagames.dofus.scripts.spells
{
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.dofus.scripts.api.FxApi;
   import com.ankamagames.dofus.scripts.api.SequenceApi;
   import com.ankamagames.dofus.scripts.api.SpellFxApi;
   import com.ankamagames.dofus.types.entities.ExplosionEntity;
   import com.ankamagames.dofus.types.entities.Projectile;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class SpellScript6 extends SpellScriptBase
   {
       
      
      public function SpellScript6(param1:SpellFxRunner)
      {
         var _loc2_:uint = 0;
         var _loc3_:ISequencable = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:ISequencable = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:ISequencable = null;
         var _loc12_:Projectile = null;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:ExplosionEntity = null;
         super(param1);
         var _loc16_:MapPoint = FxApi.GetCurrentTargetedCell(runner);
         if(!caster)
         {
            return;
         }
         addCasterSetDirectionStep(_loc16_);
         if(!FxApi.IsPositionsEquals(FxApi.GetEntityCell(caster),_loc16_))
         {
            _loc2_ = FxApi.GetOrientationTo(FxApi.GetEntityCell(caster),_loc16_);
            _loc3_ = SequenceApi.CreateSetDirectionStep(caster,_loc2_);
            SpellFxApi.AddFrontStep(runner,_loc3_);
            latestStep = _loc3_;
         }
         var _loc17_:ISequencable = SequenceApi.CreatePlayAnimationStep(caster,"AnimAttaque403",true,true,"SHOT");
         if(!latestStep)
         {
            SpellFxApi.AddFrontStep(runner,_loc17_);
         }
         else
         {
            SpellFxApi.AddStepAfter(runner,latestStep,_loc17_);
         }
         latestStep = _loc17_;
         if(SpellFxApi.HasSpellParam(spell,"casterGfxId"))
         {
            _loc4_ = 0;
            if(SpellFxApi.HasSpellParam(spell,"casterGfxOriented"))
            {
               if(SpellFxApi.GetSpellParam(spell,"casterGfxOriented"))
               {
                  _loc4_ = FxApi.GetAngleTo(FxApi.GetEntityCell(caster),FxApi.GetCurrentTargetedCell(runner));
               }
            }
            _loc5_ = 0;
            if(SpellFxApi.HasSpellParam(spell,"casterGfxYOffset"))
            {
               _loc5_ = SpellFxApi.GetSpellParam(spell,"casterGfxYOffset");
            }
            _loc6_ = false;
            if(SpellFxApi.HasSpellParam(spell,"casterGfxShowUnder"))
            {
               _loc6_ = SpellFxApi.GetSpellParam(spell,"casterGfxShowUnder");
            }
            _loc7_ = SequenceApi.CreateAddGfxEntityStep(runner,SpellFxApi.GetSpellParam(spell,"casterGfxId"),FxApi.GetEntityCell(caster),_loc4_,_loc5_,SpellFxApi.GetSpellParam(spell,"casterGfxDisplayType"),FxApi.GetEntityCell(caster),FxApi.GetCurrentTargetedCell(runner),_loc6_);
            if(!latestStep)
            {
               SpellFxApi.AddFrontStep(runner,_loc7_);
            }
            else
            {
               SpellFxApi.AddStepAfter(runner,latestStep,_loc7_);
            }
            latestStep = _loc7_;
         }
         if(SpellFxApi.HasSpellParam(spell,"targetGfxId"))
         {
            _loc8_ = 0;
            if(SpellFxApi.HasSpellParam(spell,"targetGfxOriented"))
            {
               if(SpellFxApi.GetSpellParam(spell,"targetGfxOriented"))
               {
                  _loc8_ = FxApi.GetAngleTo(FxApi.GetEntityCell(caster),FxApi.GetCurrentTargetedCell(runner));
               }
            }
            _loc9_ = 0;
            if(SpellFxApi.HasSpellParam(spell,"targetGfxYOffset"))
            {
               _loc9_ = SpellFxApi.GetSpellParam(spell,"targetGfxYOffset");
            }
            _loc10_ = false;
            if(SpellFxApi.HasSpellParam(spell,"targetGfxShowUnder"))
            {
               _loc10_ = SpellFxApi.GetSpellParam(spell,"targetGfxShowUnder");
            }
            _loc11_ = SequenceApi.CreateAddGfxEntityStep(runner,SpellFxApi.GetSpellParam(spell,"targetGfxId"),_loc16_,_loc8_,_loc9_,SpellFxApi.GetSpellParam(spell,"targetGfxDisplayType"),FxApi.GetEntityCell(caster),FxApi.GetCurrentTargetedCell(runner),_loc10_);
            if(!latestStep)
            {
               SpellFxApi.AddFrontStep(runner,_loc11_);
            }
            else if(SpellFxApi.HasSpellParam(spell,"playTargetGfxFirst") && SpellFxApi.GetSpellParam(spell,"playTargetGfxFirst"))
            {
               SpellFxApi.AddStepBefore(runner,latestStep,_loc11_);
            }
            else
            {
               SpellFxApi.AddStepAfter(runner,latestStep,_loc11_);
            }
            latestStep = _loc11_;
         }
         if(SpellFxApi.HasSpellParam(spell,"animId"))
         {
            _loc12_ = FxApi.CreateGfxEntity(SpellFxApi.GetSpellParam(spell,"animId"),FxApi.GetCurrentTargetedCell(runner),-10,10,true) as Projectile;
            _loc13_ = false;
            if(SpellFxApi.HasSpellParam(spell,"levelChange"))
            {
               _loc13_ = SpellFxApi.GetSpellParam(spell,"levelChange");
            }
            _loc14_ = false;
            if(SpellFxApi.HasSpellParam(spell,"subExplo"))
            {
               _loc14_ = SpellFxApi.GetSpellParam(spell,"subExplo");
            }
            _loc3_ = SequenceApi.CreateSetDirectionStep(_loc12_,1);
            SpellFxApi.AddStepAfter(runner,latestStep,_loc3_);
            latestStep = _loc3_;
            _loc15_ = SpellFxApi.CreateExplosionEntity(runner,SpellFxApi.GetSpellParam(spell,"particleGfxId"),SpellFxApi.GetSpellParam(spell,"particleColor"),SpellFxApi.GetSpellParam(spell,"particleCount"),_loc13_,_loc14_,SpellFxApi.GetSpellParam(spell,"explosionType"));
            FxApi.SetSubEntity(_loc12_,_loc15_,2,1);
            _loc11_ = SequenceApi.CreateAddWorldEntityStep(_loc12_);
            if(!latestStep)
            {
               SpellFxApi.AddFrontStep(runner,_loc11_);
            }
            else if(SpellFxApi.HasSpellParam(spell,"playTargetGfxFirst2") && SpellFxApi.GetSpellParam(spell,"playTargetGfxFirst2"))
            {
               SpellFxApi.AddStepBefore(runner,latestStep,_loc11_);
            }
            else
            {
               SpellFxApi.AddStepAfter(runner,latestStep,_loc11_);
            }
            latestStep = _loc11_;
         }
         destroy();
      }
   }
}
