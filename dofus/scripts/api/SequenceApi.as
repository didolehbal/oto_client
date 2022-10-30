package com.ankamagames.dofus.scripts.api
{
   import com.ankamagames.atouin.types.sequences.AddWorldEntityStep;
   import com.ankamagames.atouin.types.sequences.DestroyEntityStep;
   import com.ankamagames.atouin.types.sequences.ParableGfxMovementStep;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDestroyEntityStep;
   import com.ankamagames.dofus.scripts.FxRunner;
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.dofus.types.sequences.AddGfxInLineStep;
   import com.ankamagames.dofus.types.sequences.AddGlyphGfxStep;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.sequencer.DebugStep;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.jerakine.sequencer.ParallelStartSequenceStep;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.sequencer.StartSequenceStep;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.types.zones.Line;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.SetDirectionStep;
   import com.ankamagames.tiphon.types.CarriedSprite;
   import flash.display.DisplayObject;
   
   public class SequenceApi
   {
       
      
      public function SequenceApi()
      {
         super();
      }
      
      public static function CreateSerialSequencer() : ISequencer
      {
         return new SerialSequencer();
      }
      
      public static function CreateParallelStartSequenceStep(param1:Array, param2:Boolean = true, param3:Boolean = false) : ISequencable
      {
         return new ParallelStartSequenceStep(param1,param2,param3);
      }
      
      public static function CreateStartSequenceStep(param1:ISequencer) : ISequencable
      {
         return new StartSequenceStep(param1);
      }
      
      public static function CreateAddGfxEntityStep(param1:FxRunner, param2:uint, param3:MapPoint, param4:Number = 0, param5:int = 0, param6:uint = 0, param7:MapPoint = null, param8:MapPoint = null, param9:Boolean = false) : ISequencable
      {
         return new AddGfxEntityStep(param2,param3.cellId,param4,-DisplayObject(param1.caster).height * param5 / 10,param6,param7,param8,param9);
      }
      
      public static function CreateAddGlyphGfxStep(param1:SpellFxRunner, param2:uint, param3:MapPoint, param4:int) : ISequencable
      {
         return new AddGlyphGfxStep(param2,param3.cellId,param4,param1.castingSpell.markType);
      }
      
      public static function CreatePlayAnimationStep(param1:TiphonSprite, param2:String, param3:Boolean, param4:Boolean, param5:String = "animation_event_end", param6:int = 1) : ISequencable
      {
         return new PlayAnimationStep(param1,param2,param3,param4,param5,param6);
      }
      
      public static function CreateSetDirectionStep(param1:TiphonSprite, param2:uint) : ISequencable
      {
         return new SetDirectionStep(param1,param2);
      }
      
      public static function CreateParableGfxMovementStep(param1:FxRunner, param2:IMovable, param3:MapPoint, param4:Number = 100, param5:Number = 0.5, param6:int = 0, param7:Boolean = true) : ParableGfxMovementStep
      {
         var _loc8_:int = 0;
         var _loc9_:DisplayObject = TiphonSprite(param1.caster).parent;
         while(_loc9_)
         {
            if(_loc9_ is CarriedSprite)
            {
               _loc8_ = _loc8_ + _loc9_.y;
            }
            _loc9_ = _loc9_.parent;
         }
         return new ParableGfxMovementStep(param2,param3,param4,param5,-DisplayObject(param1.caster).height * param6 / 10 + _loc8_,param7);
      }
      
      public static function CreateAddGfxInLineStep(param1:SpellFxRunner, param2:uint, param3:MapPoint, param4:MapPoint, param5:Number = 0, param6:uint = 0, param7:Number = 0, param8:Number = 0, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false, param12:Boolean = false, param13:Boolean = false) : AddGfxInLineStep
      {
         var _loc14_:Vector.<uint> = null;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:EffectInstance = null;
         var _loc18_:IZone = null;
         var _loc19_:Cross = null;
         var _loc20_:uint = param1.castingSpell.spell.spellLevels.indexOf(param1.castingSpell.spellRank.id);
         var _loc21_:Number = 1 + (param7 + (param8 - param7) * _loc20_ / 6) / 10;
         if(param12)
         {
            _loc15_ = 88;
            _loc16_ = 0;
            for each(_loc17_ in param1.castingSpell.spellRank.effects)
            {
               if(_loc17_.zoneShape != 0 && _loc17_.zoneSize < 63 && (_loc17_.zoneSize > _loc16_ || _loc17_.zoneSize == _loc16_ && _loc15_ == SpellShapeEnum.P))
               {
                  _loc16_ = uint(_loc17_.zoneSize);
                  _loc15_ = _loc17_.zoneShape;
               }
            }
            switch(_loc15_)
            {
               case SpellShapeEnum.X:
                  _loc18_ = new Cross(0,_loc16_,DataMapProvider.getInstance());
                  break;
               case SpellShapeEnum.L:
                  _loc18_ = new Line(_loc16_,DataMapProvider.getInstance());
                  break;
               case SpellShapeEnum.T:
                  (_loc19_ = new Cross(0,_loc16_,DataMapProvider.getInstance())).onlyPerpendicular = true;
                  _loc18_ = _loc19_;
                  break;
               case SpellShapeEnum.D:
                  _loc18_ = new Cross(0,_loc16_,DataMapProvider.getInstance());
                  break;
               case SpellShapeEnum.C:
                  _loc18_ = new Lozenge(0,_loc16_,DataMapProvider.getInstance());
                  break;
               case SpellShapeEnum.O:
                  _loc18_ = new Cross(_loc16_ - 1,_loc16_,DataMapProvider.getInstance());
                  break;
               case SpellShapeEnum.P:
               default:
                  _loc18_ = new Cross(0,0,DataMapProvider.getInstance());
            }
            _loc18_.direction = param3.advancedOrientationTo(param1.castingSpell.targetedCell);
            _loc14_ = _loc18_.getCells(param1.castingSpell.targetedCell.cellId);
         }
         return new AddGfxInLineStep(param2,param3,param4,-DisplayObject(param1.caster).height * param5 / 10,param6,_loc21_,param9,param10,_loc14_,param13,param11);
      }
      
      public static function CreateAddWorldEntityStep(param1:IEntity) : AddWorldEntityStep
      {
         return new AddWorldEntityStep(param1);
      }
      
      public static function CreateDestroyEntityStep(param1:IEntity) : DestroyEntityStep
      {
         return new FightDestroyEntityStep(param1);
      }
      
      public static function CreateDebugStep(param1:String) : DebugStep
      {
         return new DebugStep(param1);
      }
   }
}
