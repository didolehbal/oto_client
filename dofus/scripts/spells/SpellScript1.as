package com.ankamagames.dofus.scripts.spells
{
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.dofus.scripts.api.FxApi;
   import com.ankamagames.dofus.scripts.api.SpellFxApi;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class SpellScript1 extends SpellScriptBase
   {
       
      
      public function SpellScript1(param1:SpellFxRunner)
      {
         var _loc2_:MapPoint = null;
         var _loc3_:MapPoint = null;
         super(param1);
         var _loc4_:MapPoint = FxApi.GetCurrentTargetedCell(runner);
         var _loc5_:MapPoint = FxApi.GetEntityCell(caster);
         var _loc6_:Vector.<MapPoint>;
         if((_loc6_ = SpellFxApi.GetPortalCells(runner)) && _loc6_.length > 1)
         {
            _loc2_ = _loc6_[0];
            _loc3_ = _loc6_[_loc6_.length - 1];
         }
         var _loc7_:MapPoint = !!_loc2_?_loc2_:_loc4_;
         var _loc8_:MapPoint = !!_loc3_?_loc3_:_loc5_;
         addCasterSetDirectionStep(_loc7_);
         addCasterAnimationStep();
         if(SpellFxApi.HasSpellParam(spell,"casterGfxId"))
         {
            addGfxEntityStep(_loc5_,_loc5_,_loc7_,PREFIX_CASTER);
         }
         if(_loc2_)
         {
            addPortalAnimationSteps(SpellFxApi.GetPortalIds(runner));
         }
         if(SpellFxApi.HasSpellParam(spell,"targetGfxId"))
         {
            addGfxEntityStep(_loc4_,_loc8_,_loc4_,PREFIX_TARGET);
         }
         if(SpellFxApi.HasSpellParam(spell,"targetGfxId2"))
         {
            addGfxEntityStep(_loc4_,_loc8_,_loc4_,PREFIX_TARGET,"2");
         }
         addAnimHitSteps();
         destroy();
      }
   }
}
