package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceInteger;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.network.enums.FightDispellableEnum;
   import com.ankamagames.dofus.network.types.game.actions.fight.AbstractFightDispellableEffect;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class BasicBuff
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(BasicBuff));
       
      
      protected var _effect:EffectInstance;
      
      protected var _disabled:Boolean = false;
      
      protected var _removed:Boolean = false;
      
      public var uid:uint;
      
      public var duration:int;
      
      public var castingSpell:CastingSpell;
      
      public var targetId:int;
      
      public var critical:Boolean = false;
      
      public var dispelable:int;
      
      public var actionId:uint;
      
      public var id:uint;
      
      public var source:int;
      
      public var aliveSource:int;
      
      public var stack:Vector.<BasicBuff>;
      
      public var parentBoostUid:uint;
      
      public var dataUid:int;
      
      public var finishing:Boolean;
      
      public function BasicBuff(param1:AbstractFightDispellableEffect = null, param2:CastingSpell = null, param3:uint = 0, param4:* = null, param5:* = null, param6:* = null)
      {
         var _loc7_:FightBattleFrame = null;
         super();
         if(param1)
         {
            this.id = param1.uid;
            this.uid = param1.uid;
            this.actionId = param3;
            this.targetId = param1.targetId;
            this.castingSpell = param2;
            this.duration = param1.turnDuration;
            this.dispelable = param1.dispelable;
            this.source = param2.casterId;
            this.dataUid = param1.effectId;
            _loc7_ = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame;
            if(Kernel.beingInReconection || PlayedCharacterManager.getInstance().isSpectator || _loc7_.currentPlayerId == 0)
            {
               this.aliveSource = this.source;
            }
            else
            {
               this.aliveSource = _loc7_.currentPlayerId;
            }
            this.parentBoostUid = this.parentBoostUid;
            this.initParam(param4,param5,param6);
         }
      }
      
      public function get effect() : EffectInstance
      {
         return this._effect;
      }
      
      public function get type() : String
      {
         return "BasicBuff";
      }
      
      public function get param1() : *
      {
         if(this._effect is EffectInstanceDice)
         {
            return EffectInstanceDice(this._effect).diceNum;
         }
         return null;
      }
      
      public function get param2() : *
      {
         if(this._effect is EffectInstanceDice)
         {
            return EffectInstanceDice(this._effect).diceSide;
         }
         return null;
      }
      
      public function get param3() : *
      {
         if(this._effect is EffectInstanceInteger)
         {
            return EffectInstanceInteger(this._effect).value;
         }
         return null;
      }
      
      public function set param1(param1:*) : void
      {
         this._effect.setParameter(0,param1 == 0?null:param1);
      }
      
      public function set param2(param1:*) : void
      {
         this._effect.setParameter(1,param1 == 0?null:param1);
      }
      
      public function set param3(param1:*) : void
      {
         this._effect.setParameter(2,param1 == 0?null:param1);
      }
      
      public function get unusableNextTurn() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(this.duration > 1 || this.duration < 0)
         {
            return false;
         }
         var _loc8_:FightBattleFrame;
         if(_loc8_ = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame)
         {
            _loc1_ = _loc8_.currentPlayerId;
            _loc2_ = PlayedCharacterManager.getInstance().id;
            if(_loc1_ == _loc2_ || _loc1_ == this.source)
            {
               return false;
            }
            _loc3_ = -1;
            _loc4_ = -1;
            _loc5_ = -1;
            _loc6_ = 0;
            while(_loc6_ < _loc8_.fightersList.length)
            {
               if((_loc7_ = _loc8_.fightersList[_loc6_]) == _loc2_)
               {
                  _loc3_ = _loc6_;
               }
               if(_loc7_ == _loc1_)
               {
                  _loc4_ = _loc6_;
               }
               if(_loc7_ == this.source)
               {
                  _loc5_ = _loc6_;
               }
               _loc6_++;
            }
            if(_loc5_ < _loc4_)
            {
               _loc5_ = _loc5_ + _loc8_.fightersList.length;
            }
            if(_loc3_ < _loc4_)
            {
               _loc3_ = _loc3_ + _loc8_.fightersList.length;
            }
            if(_loc3_ > _loc4_ && _loc3_ <= _loc5_)
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      public function get trigger() : Boolean
      {
         return false;
      }
      
      public function initParam(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:SpellLevel = null;
         var _loc5_:int = 0;
         var _loc6_:EffectInstance = null;
         if(param1 && param1 != 0 || param2 && param2 != 0)
         {
            this._effect = new EffectInstanceDice();
            this._effect.effectId = this.actionId;
            this._effect.duration = this.duration;
            (this._effect as EffectInstanceDice).diceNum = param1;
            (this._effect as EffectInstanceDice).diceSide = param2;
            (this._effect as EffectInstanceDice).value = param3;
            this._effect.trigger = this.trigger;
         }
         else
         {
            this._effect = new EffectInstanceInteger();
            this._effect.effectId = this.actionId;
            this._effect.duration = this.duration;
            (this._effect as EffectInstanceInteger).value = param3;
            this._effect.trigger = this.trigger;
         }
         for each(_loc5_ in this.castingSpell.spell.spellLevels)
         {
            if(_loc4_ = SpellLevel.getLevelById(_loc5_))
            {
               for each(_loc6_ in _loc4_.effects)
               {
                  if(_loc6_.effectUid == this.dataUid)
                  {
                     this._effect.visibleInTooltip = _loc6_.visibleInTooltip;
                     this._effect.visibleInBuffUi = _loc6_.visibleInBuffUi;
                     this._effect.visibleInFightLog = _loc6_.visibleInFightLog;
                  }
               }
            }
         }
      }
      
      public function canBeDispell(param1:Boolean = false, param2:int = -2.147483648E9, param3:Boolean = false) : Boolean
      {
         if(param2 == this.id)
         {
            return true;
         }
         switch(this.dispelable)
         {
            case FightDispellableEnum.DISPELLABLE:
               return true;
            case FightDispellableEnum.DISPELLABLE_BY_STRONG_DISPEL:
               return param1;
            case FightDispellableEnum.DISPELLABLE_BY_DEATH:
               return param3 || param1;
            case FightDispellableEnum.REALLY_NOT_DISPELLABLE:
               return param2 == this.id;
            default:
               return false;
         }
      }
      
      public function dispellableByDeath() : Boolean
      {
         return this.dispelable == FightDispellableEnum.DISPELLABLE_BY_DEATH || this.dispelable == FightDispellableEnum.DISPELLABLE;
      }
      
      public function onDisabled() : void
      {
         this._disabled = true;
      }
      
      public function undisable() : void
      {
         this._disabled = false;
      }
      
      public function onRemoved() : void
      {
         this._removed = true;
         if(!this._disabled)
         {
            this.onDisabled();
         }
      }
      
      public function onApplyed() : void
      {
         this._disabled = false;
         this._removed = false;
      }
      
      public function equals(param1:BasicBuff, param2:Boolean = false) : Boolean
      {
         var _loc3_:StateBuff = null;
         var _loc4_:StateBuff = null;
         if(this.targetId != param1.targetId || this.aliveSource != param1.aliveSource || this.effect.effectId != param1.actionId || this.duration != param1.duration || this.effect.hasOwnProperty("delay") && param1.effect.hasOwnProperty("delay") && this.effect.delay != param1.effect.delay || this.castingSpell.spellRank && param1.castingSpell.spellRank && !param2 && this.castingSpell.spellRank.id != param1.castingSpell.spellRank.id || !param2 && this.castingSpell.spell.id != param1.castingSpell.spell.id || getQualifiedClassName(this) != getQualifiedClassName(param1) || this.source != param1.source || this.trigger && (this.effect.triggers.indexOf("|") == -1 || this.dataUid != param1.dataUid))
         {
            return false;
         }
         var _loc5_:Array = [ActionIdConverter.ACTION_BOOST_SPELL_RANGE,ActionIdConverter.ACTION_BOOST_SPELL_RANGEABLE,ActionIdConverter.ACTION_BOOST_SPELL_DMG,ActionIdConverter.ACTION_BOOST_SPELL_HEAL,ActionIdConverter.ACTION_BOOST_SPELL_AP_COST,ActionIdConverter.ACTION_BOOST_SPELL_CAST_INTVL,ActionIdConverter.ACTION_BOOST_SPELL_CC,ActionIdConverter.ACTION_BOOST_SPELL_CASTOUTLINE,ActionIdConverter.ACTION_BOOST_SPELL_NOLINEOFSIGHT,ActionIdConverter.ACTION_BOOST_SPELL_MAXPERTURN,ActionIdConverter.ACTION_BOOST_SPELL_MAXPERTARGET,ActionIdConverter.ACTION_BOOST_SPELL_CAST_INTVL_SET,ActionIdConverter.ACTION_BOOST_SPELL_BASE_DMG,ActionIdConverter.ACTION_DEBOOST_SPELL_RANGE,406,787,792,793,1017,1018,1019,1035,1036,1044,1045];
         var _loc6_:uint;
         if((_loc6_ = this.actionId) == 788)
         {
            if(this.param1 != param1.param1)
            {
               return false;
            }
         }
         else if(_loc5_.indexOf(_loc6_) != -1)
         {
            if(this.param1 != param1.param1)
            {
               return false;
            }
         }
         else
         {
            if(_loc6_ == 165)
            {
               return false;
            }
            if(_loc6_ == param1.actionId && (_loc6_ == 952 || _loc6_ == 951 || _loc6_ == 950))
            {
               _loc3_ = this as StateBuff;
               _loc4_ = param1 as StateBuff;
               if(_loc3_ && _loc4_)
               {
                  if(_loc3_.stateId != _loc4_.stateId)
                  {
                     return false;
                  }
               }
            }
         }
         return true;
      }
      
      public function add(param1:BasicBuff) : void
      {
         if(!this.stack)
         {
            this.stack = new Vector.<BasicBuff>();
            this.stack.push(this.clone(this.id));
         }
         this.stack.push(param1);
         switch(this.actionId)
         {
            case 293:
               this.param1 = param1.param1;
               this.param2 = this.param2 + param1.param2;
               this.param3 = this.param3 + param1.param3;
               break;
            case 788:
               this.param1 = this.param1 + param1.param2;
               break;
            case 950:
            case 951:
            case 952:
               break;
            default:
               this.param1 = this.param1 + param1.param1;
               this.param2 = this.param2 + param1.param2;
               this.param3 = this.param3 + param1.param3;
         }
         this.refreshDescription();
      }
      
      public function updateParam(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = -1) : void
      {
         var _loc5_:BasicBuff = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param4 == -1)
         {
            _loc6_ = param1;
            _loc7_ = param2;
            _loc8_ = param3;
         }
         else if(this.stack && this.stack.length < 1)
         {
            var _loc9_:int = 0;
            var _loc10_:* = this.stack;
            for(; §§hasnext(_loc10_,_loc9_); _loc6_ = _loc6_ + _loc5_.param1,_loc7_ = _loc7_ + _loc5_.param2,_loc8_ = _loc8_ + _loc5_.param3)
            {
               _loc5_ = §§nextvalue(_loc9_,_loc10_);
               if(_loc5_.id != param4)
               {
                  continue;
               }
               switch(_loc5_.actionId)
               {
                  case 788:
                  case 950:
                  case 951:
                  case 952:
                     continue;
                  default:
                     _loc5_.param1 = param1;
                     _loc5_.param2 = param2;
                     _loc5_.param3 = param3;
                     continue;
               }
            }
         }
         else
         {
            _loc6_ = param1;
            _loc7_ = param2;
            _loc8_ = param3;
         }
         switch(this.actionId)
         {
            case 788:
               this.param1 = _loc7_;
               break;
            case 950:
            case 951:
            case 952:
               break;
            default:
               this.param1 = _loc6_;
               this.param2 = _loc7_;
               this.param3 = _loc8_;
         }
         this.refreshDescription();
      }
      
      public function refreshDescription() : void
      {
         this._effect.forceDescriptionRefresh();
      }
      
      public function incrementDuration(param1:int, param2:Boolean = false) : Boolean
      {
         if(!param2 || this.canBeDispell())
         {
            if(this.duration >= 63 || this.duration == -1000)
            {
               return false;
            }
            if(this.duration + param1 > 0)
            {
               this.duration = this.duration + param1;
               this.effect.duration = this.effect.duration + param1;
               return true;
            }
            if(this.duration > 0)
            {
               this.duration = 0;
               this.effect.duration = 0;
               return true;
            }
            return false;
         }
         return false;
      }
      
      public function get active() : Boolean
      {
         return this.duration != 0;
      }
      
      public function clone(param1:int = 0) : BasicBuff
      {
         var _loc2_:BasicBuff = new BasicBuff();
         _loc2_.id = this.uid;
         _loc2_.uid = this.uid;
         _loc2_.actionId = this.actionId;
         _loc2_.targetId = this.targetId;
         _loc2_.castingSpell = this.castingSpell;
         _loc2_.duration = this.duration;
         _loc2_.dispelable = this.dispelable;
         _loc2_.source = this.source;
         _loc2_.aliveSource = this.aliveSource;
         _loc2_.parentBoostUid = this.parentBoostUid;
         _loc2_.initParam(this.param1,this.param2,this.param3);
         return _loc2_;
      }
      
      public function toString() : String
      {
         return "[BasicBuff id=" + this.id + ", uid=" + this.uid + ", targetId=" + this.targetId + ", sourceId=" + this.source + ", duration=" + this.duration + ", stack.length=" + (!!this.stack?this.stack.length:"0") + "]";
      }
   }
}
