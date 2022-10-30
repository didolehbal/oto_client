package com.ankamagames.dofus.scripts.api
{
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.steps.IFightStep;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.dofus.types.entities.ExplosionEntity;
   import com.ankamagames.dofus.types.entities.Glyph;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.TiphonConstants;
   
   public class SpellFxApi extends FxApi
   {
       
      
      public function SpellFxApi()
      {
         super();
      }
      
      public static function GetCastingSpell(param1:SpellFxRunner) : CastingSpell
      {
         return param1.castingSpell;
      }
      
      public static function GetUsedWeaponType(param1:CastingSpell) : uint
      {
         if(param1.weaponId > 0)
         {
            return Item.getItemById(param1.weaponId).typeId;
         }
         return 0;
      }
      
      public static function IsCriticalHit(param1:CastingSpell) : Boolean
      {
         return param1.isCriticalHit;
      }
      
      public static function IsCriticalFail(param1:CastingSpell) : Boolean
      {
         return param1.isCriticalFail;
      }
      
      public static function GetSpellParam(param1:CastingSpell, param2:String) : *
      {
         var _loc3_:* = param1.spell.getParamByName(param2,IsCriticalHit(param1));
         if(_loc3_ is String)
         {
            return _loc3_;
         }
         return !!isNaN(_loc3_)?0:_loc3_;
      }
      
      public static function HasSpellParam(param1:CastingSpell, param2:String) : Boolean
      {
         if(!param1 || !param1.spell)
         {
            return false;
         }
         var _loc3_:* = param1.spell.getParamByName(param2,IsCriticalHit(param1));
         return !isNaN(_loc3_) || _loc3_ != null;
      }
      
      public static function GetPortalCells(param1:SpellFxRunner) : Vector.<MapPoint>
      {
         return param1.castingSpell.portalMapPoints;
      }
      
      public static function GetPortalIds(param1:SpellFxRunner) : Vector.<int>
      {
         return param1.castingSpell.portalIds;
      }
      
      public static function GetPortalEntity(param1:SpellFxRunner, param2:int) : Glyph
      {
         return MarkedCellsManager.getInstance().getGlyph(param2);
      }
      
      public static function GetStepType(param1:ISequencable) : String
      {
         if(param1 is IFightStep)
         {
            return (param1 as IFightStep).stepType;
         }
         return "other";
      }
      
      public static function GetStepsFromType(param1:SpellFxRunner, param2:String) : Vector.<IFightStep>
      {
         var _loc3_:ISequencable = null;
         var _loc4_:IFightStep = null;
         var _loc5_:Vector.<IFightStep> = new Vector.<IFightStep>(0,false);
         for each(_loc3_ in param1.stepsBuffer)
         {
            if(_loc3_ is IFightStep)
            {
               if((_loc4_ = _loc3_ as IFightStep).stepType == param2)
               {
                  _loc5_.push(_loc4_);
               }
            }
         }
         return _loc5_;
      }
      
      public static function AddFrontStep(param1:SpellFxRunner, param2:ISequencable) : void
      {
         param1.stepsBuffer.splice(0,0,param2);
      }
      
      public static function AddBackStep(param1:SpellFxRunner, param2:ISequencable) : void
      {
         param1.stepsBuffer.push(param2);
      }
      
      public static function AddStepBefore(param1:SpellFxRunner, param2:ISequencable, param3:ISequencable) : void
      {
         var _loc4_:ISequencable = null;
         var _loc6_:uint = 0;
         var _loc5_:int = -1;
         for each(_loc4_ in param1.stepsBuffer)
         {
            if(_loc4_ == param2)
            {
               _loc5_ = _loc6_;
               break;
            }
            _loc6_++;
         }
         if(_loc5_ < 0)
         {
            _log.warn("Cannot add a step before " + param2 + "; step not found.");
            return;
         }
         param1.stepsBuffer.splice(_loc5_,0,param3);
      }
      
      public static function AddStepAfter(param1:SpellFxRunner, param2:ISequencable, param3:ISequencable) : void
      {
         var _loc4_:ISequencable = null;
         var _loc6_:uint = 0;
         var _loc5_:int = -1;
         for each(_loc4_ in param1.stepsBuffer)
         {
            if(_loc4_ == param2)
            {
               _loc5_ = _loc6_;
               break;
            }
            _loc6_++;
         }
         if(_loc5_ < 0)
         {
            _log.warn("Cannot add a step after " + param2 + "; step not found.");
            return;
         }
         param1.stepsBuffer.splice(_loc5_ + 1,0,param3);
      }
      
      public static function CreateExplosionEntity(param1:SpellFxRunner, param2:uint, param3:String, param4:uint, param5:Boolean, param6:Boolean, param7:uint) : ExplosionEntity
      {
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:Uri = new Uri(TiphonConstants.SWF_SKULL_PATH + "/" + param2 + ".swl");
         if(param3)
         {
            _loc8_ = param3.split(";");
            while(_loc9_ < _loc8_.length)
            {
               _loc8_[_loc9_] = parseInt(_loc8_[_loc9_],16);
               _loc9_++;
            }
         }
         if(param5)
         {
            if((_loc10_ = param1.castingSpell.spellRank.spell.spellLevels.indexOf(param1.castingSpell.spellRank.id)) != -1)
            {
               param4 = param4 * param1.castingSpell.spellRank.spell.spellLevels.length / 10 + param4 * (_loc10_ + 1) / 10;
            }
         }
         return new ExplosionEntity(_loc11_,_loc8_,param4,param6,param7);
      }
   }
}
