package com.ankamagames.dofus.internalDatacenter.spells
{
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.interfaces.IClonable;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.SlotDataHolderManager;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.network.enums.CharacterSpellModificationTypeEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.display.spellZone.ICellZoneProvider;
   import com.ankamagames.jerakine.utils.display.spellZone.IZoneShape;
   import flash.utils.Dictionary;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.getQualifiedClassName;
   
   use namespace flash_proxy;
   
   public dynamic class SpellWrapper extends Proxy implements ISlotData, IClonable, ICellZoneProvider, IDataCenter
   {
      
      private static var _cache:Array = new Array();
      
      private static var _playersCache:Dictionary = new Dictionary();
      
      private static var _cac:Array = new Array();
      
      private static var _errorIconUri:Uri;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellWrapper));
      
      public static const BASE_DAMAGE_EFFECT_IDS:Array = new Array(100,95,96,97,98,99,92,93,94,95,1012,1013,1014,1015,1016);
       
      
      private var _uri:Uri;
      
      private var _slotDataHolderManager:SlotDataHolderManager;
      
      private var _spellLevel:SpellLevel;
      
      private var _canTargetCasterOutOfZone:Object;
      
      public var position:uint;
      
      public var id:uint = 0;
      
      public var spellLevel:int;
      
      public var effects:Vector.<EffectInstance>;
      
      public var criticalEffect:Vector.<EffectInstance>;
      
      public var gfxId:int;
      
      public var playerId:int;
      
      public var versionNum:int;
      
      private var _actualCooldown:uint = 0;
      
      public function SpellWrapper()
      {
         super();
      }
      
      public static function create(param1:int, param2:uint, param3:int, param4:Boolean = true, param5:int = 0) : SpellWrapper
      {
         var _loc6_:SpellWrapper = null;
         var _loc7_:EffectInstance = null;
         var _loc8_:CharacterSpellModification = null;
         var _loc9_:CharacterSpellModification = null;
         var _loc10_:CharacterSpellModification = null;
         var _loc11_:int = 0;
         if(param2 == 0)
         {
            param4 = false;
         }
         param1 = 63;
         if(param4)
         {
            if(_cache[param2] && _cache[param2].length > 0 && _cache[param2][param1] && !param5)
            {
               _loc6_ = _cache[param2][param1];
            }
            else if(_playersCache[param5] && _playersCache[param5][param2] && _playersCache[param5][param2].length > 0 && _playersCache[param5][param2][param1])
            {
               _loc6_ = _playersCache[param5][param2][param1];
            }
         }
         if(param2 == 0 && _cac != null && _cac.length > 0 && _cac[param1])
         {
            _loc6_ = _cac[param1];
         }
         if(!_loc6_)
         {
            (_loc6_ = new SpellWrapper()).id = param2;
            if(param4)
            {
               if(param5)
               {
                  if(!_playersCache[param5])
                  {
                     _playersCache[param5] = new Array();
                  }
                  if(!_playersCache[param5][param2])
                  {
                     _playersCache[param5][param2] = new Array();
                  }
                  _playersCache[param5][param2][param1] = _loc6_;
               }
               else
               {
                  if(!_cache[param2])
                  {
                     _cache[param2] = new Array();
                  }
                  _cache[param2][param1] = _loc6_;
               }
            }
            _loc6_._slotDataHolderManager = new SlotDataHolderManager(_loc6_);
         }
         if(param2 == 0)
         {
            if(!_cac)
            {
               _cac = new Array();
            }
            _cac[param1] = _loc6_;
         }
         _loc6_.id = param2;
         _loc6_.gfxId = param2;
         if(param1 != -1)
         {
            _loc6_.position = param1;
         }
         _loc6_.spellLevel = param3;
         _loc6_.playerId = param5;
         _loc6_.effects = new Vector.<EffectInstance>();
         _loc6_.criticalEffect = new Vector.<EffectInstance>();
         var _loc12_:Spell;
         if(!(_loc12_ = Spell.getSpellById(param2)))
         {
            return null;
         }
         _loc6_._spellLevel = _loc12_.getSpellLevel(param3);
         for each(_loc7_ in _loc6_._spellLevel.effects)
         {
            if((_loc7_ = _loc7_.clone()).category == 2 && BASE_DAMAGE_EFFECT_IDS.indexOf(_loc7_.effectId) != -1)
            {
               if((_loc8_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(param2,CharacterSpellModificationTypeEnum.BASE_DAMAGE)) && _loc7_ is EffectInstanceDice)
               {
                  _loc11_ = _loc8_.value.alignGiftBonus + _loc8_.value.base + _loc8_.value.contextModif + _loc8_.value.objectsAndMountBonus;
                  (_loc7_ as EffectInstanceDice).diceNum = (_loc7_ as EffectInstanceDice).diceNum + _loc11_;
                  if((_loc7_ as EffectInstanceDice).diceSide > 0)
                  {
                     (_loc7_ as EffectInstanceDice).diceSide = (_loc7_ as EffectInstanceDice).diceSide + _loc11_;
                  }
               }
               _loc9_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(param2,CharacterSpellModificationTypeEnum.DAMAGE);
               _loc10_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(param2,CharacterSpellModificationTypeEnum.HEAL_BONUS);
               if(_loc9_)
               {
                  _loc7_.modificator = _loc9_.value.alignGiftBonus + _loc9_.value.base + _loc9_.value.contextModif + _loc9_.value.objectsAndMountBonus;
               }
               else if(_loc10_)
               {
                  _loc7_.modificator = _loc10_.value.alignGiftBonus + _loc10_.value.base + _loc10_.value.contextModif + _loc10_.value.objectsAndMountBonus;
               }
            }
            _loc6_.effects.push(_loc7_);
         }
         for each(_loc7_ in _loc6_._spellLevel.criticalEffect)
         {
            if((_loc7_ = _loc7_.clone()).category == 2 && BASE_DAMAGE_EFFECT_IDS.indexOf(_loc7_.effectId) != -1)
            {
               if((_loc8_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(param2,CharacterSpellModificationTypeEnum.BASE_DAMAGE)) && _loc7_ is EffectInstanceDice)
               {
                  _loc11_ = _loc8_.value.alignGiftBonus + _loc8_.value.base + _loc8_.value.contextModif + _loc8_.value.objectsAndMountBonus;
                  (_loc7_ as EffectInstanceDice).diceNum = (_loc7_ as EffectInstanceDice).diceNum + _loc11_;
                  if((_loc7_ as EffectInstanceDice).diceSide > 0)
                  {
                     (_loc7_ as EffectInstanceDice).diceSide = (_loc7_ as EffectInstanceDice).diceSide + _loc11_;
                  }
               }
               _loc9_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(param2,CharacterSpellModificationTypeEnum.DAMAGE);
               _loc10_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(param2,CharacterSpellModificationTypeEnum.HEAL_BONUS);
               if(_loc9_)
               {
                  _loc7_.modificator = _loc9_.value.alignGiftBonus + _loc9_.value.base + _loc9_.value.contextModif + _loc9_.value.objectsAndMountBonus;
               }
               else if(_loc10_)
               {
                  _loc7_.modificator = _loc10_.value.alignGiftBonus + _loc10_.value.base + _loc10_.value.contextModif + _loc10_.value.objectsAndMountBonus;
               }
            }
            _loc6_.criticalEffect.push(_loc7_);
         }
         return _loc6_;
      }
      
      public static function getSpellWrapperById(param1:uint, param2:int, param3:int) : SpellWrapper
      {
         var _loc4_:int = 0;
         if(param2 != 0)
         {
            if(!_playersCache[param2])
            {
               return null;
            }
            if(!_playersCache[param2][param1] && _cache[param1])
            {
               _playersCache[param2][param1] = new Array();
               _loc4_ = 0;
               while(_loc4_ < 20)
               {
                  if(_cache[param1][_loc4_])
                  {
                     _playersCache[param2][param1][_loc4_] = _cache[param1][_loc4_].clone();
                  }
                  _loc4_++;
               }
            }
            if(param1 == 0 && _cac && _cac[param3])
            {
               return _cac[param3];
            }
            return _playersCache[param2][param1][param3];
         }
         return _cache[param1][param3];
      }
      
      public static function getFirstSpellWrapperById(param1:uint, param2:int) : SpellWrapper
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param2 != 0)
         {
            if(!_playersCache[param2])
            {
               return null;
            }
            if(!_playersCache[param2][param1] && _cache[param1])
            {
               _playersCache[param2][param1] = new Array();
               _loc4_ = 0;
               while(_loc4_ < 20)
               {
                  if(_cache[param1][_loc4_])
                  {
                     _playersCache[param2][param1][_loc4_] = _cache[param1][_loc4_].clone();
                  }
                  _loc4_++;
               }
            }
            if(param1 == 0 && _cac && _cac.length)
            {
               _loc3_ = _cac;
            }
            else
            {
               _loc3_ = _playersCache[param2][param1];
            }
         }
         else
         {
            _loc3_ = _cache[param1];
         }
         if(_loc3_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               if(_loc3_[_loc5_])
               {
                  return _loc3_[_loc5_];
               }
               _loc5_++;
            }
         }
         return null;
      }
      
      public static function getSpellWrappersById(param1:uint, param2:int) : Array
      {
         var _loc3_:int = 0;
         if(param2 != 0)
         {
            if(!_playersCache[param2])
            {
               return null;
            }
            if(!_playersCache[param2][param1] && _cache[param1])
            {
               _playersCache[param2][param1] = new Array();
               _loc3_ = 0;
               while(_loc3_ < 20)
               {
                  if(_cache[param1][_loc3_])
                  {
                     _playersCache[param2][param1][_loc3_] = _cache[param1][_loc3_].clone();
                  }
                  _loc3_++;
               }
            }
            if(param1 == 0)
            {
               return _cac;
            }
            return _playersCache[param2][param1];
         }
         return _cache[param1];
      }
      
      public static function refreshAllPlayerSpellHolder(param1:int) : void
      {
         var _loc2_:Array = null;
         var _loc3_:SpellWrapper = null;
         var _loc4_:SpellWrapper = null;
         var _loc5_:SlotDataHolderManager = null;
         for each(_loc2_ in _playersCache[param1])
         {
            for each(_loc3_ in _loc2_)
            {
               _loc3_._slotDataHolderManager.refreshAll();
            }
         }
         if(_cac)
         {
            for each(_loc4_ in _cac)
            {
               if(_loc4_)
               {
                  _loc5_ = _loc4_._slotDataHolderManager;
                  SpellWrapper(_loc4_)._slotDataHolderManager.refreshAll();
               }
            }
         }
      }
      
      public static function resetAllCoolDown(param1:int, param2:Object) : void
      {
         var _loc3_:Array = null;
         var _loc4_:SpellWrapper = null;
         SecureCenter.checkAccessKey(param2);
         for each(_loc3_ in _playersCache[param1])
         {
            for each(_loc4_ in _loc3_)
            {
               SpellWrapper(_loc4_).actualCooldown = 0;
            }
         }
      }
      
      public static function removeAllSpellWrapperBut(param1:int, param2:Object) : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         SecureCenter.checkAccessKey(param2);
         var _loc6_:Array = new Array();
         for(_loc3_ in _playersCache)
         {
            if(int(_loc3_) != param1)
            {
               _loc6_.push(_loc3_);
            }
         }
         _loc4_ = _loc6_.length;
         _loc5_ = -1;
         while(++_loc5_ < _loc4_)
         {
            delete _playersCache[_loc6_[_loc5_]];
         }
      }
      
      public static function removeAllSpellWrapper() : void
      {
         _playersCache = new Dictionary();
         _cache = new Array();
      }
      
      public function set actualCooldown(param1:uint) : void
      {
         this._actualCooldown = param1;
         this._slotDataHolderManager.refreshAll();
      }
      
      public function get actualCooldown() : uint
      {
         return !!PlayedCharacterManager.getInstance().isFighting?uint(this._actualCooldown):uint(0);
      }
      
      public function get spellLevelInfos() : SpellLevel
      {
         return this._spellLevel;
      }
      
      public function get minimalRange() : uint
      {
         return this["minRange"];
      }
      
      public function get maximalRange() : uint
      {
         return this["range"];
      }
      
      public function get castZoneInLine() : Boolean
      {
         return this["castInLine"];
      }
      
      public function get castZoneInDiagonal() : Boolean
      {
         return this["castInDiagonal"];
      }
      
      public function get spellZoneEffects() : Vector.<IZoneShape>
      {
         var _loc1_:SpellLevel = null;
         if(this.id != 0 || !PlayedCharacterManager.getInstance().currentWeapon)
         {
            _loc1_ = this.spell.getSpellLevel(this.spellLevel);
            if(_loc1_)
            {
               return _loc1_.spellZoneEffects;
            }
         }
         return null;
      }
      
      public function get hideEffects() : Boolean
      {
         if(this.id == 0 && PlayedCharacterManager.getInstance().currentWeapon != null)
         {
            return (PlayedCharacterManager.getInstance().currentWeapon as ItemWrapper).hideEffects;
         }
         var _loc1_:SpellLevel = this.spell.getSpellLevel(this.spellLevel);
         if(_loc1_)
         {
            return _loc1_.hideEffects;
         }
         return false;
      }
      
      public function get backGroundIconUri() : Uri
      {
         if(this.id == 0 && PlayedCharacterManager.getInstance().currentWeapon != null)
         {
            return new Uri(XmlConfig.getInstance().getEntry("config.content.path").concat("gfx/spells/all.swf|noIcon"));
         }
         return null;
      }
      
      public function get iconUri() : Uri
      {
         return this.fullSizeIconUri;
      }
      
      public function get fullSizeIconUri() : Uri
      {
         if(!this._uri || this.id == 0)
         {
            if(this.id == 0 && PlayedCharacterManager.getInstance().currentWeapon != null)
            {
               this._uri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.spells").concat("all.swf|weapon_").concat(PlayedCharacterManager.getInstance().currentWeapon.typeId));
            }
            else
            {
               this._uri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.spells").concat("all.swf|sort_").concat(!!this.spell?this.spell.iconId:0));
            }
            this._uri.tag = Slot.NEED_CACHE_AS_BITMAP;
         }
         return this._uri;
      }
      
      public function get errorIconUri() : Uri
      {
         if(!_errorIconUri)
         {
            _errorIconUri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.spells").concat("all.swf|noIcon"));
         }
         return _errorIconUri;
      }
      
      public function get info1() : String
      {
         if(this.actualCooldown == 0 || !PlayedCharacterManager.getInstance().isFighting)
         {
            return null;
         }
         if(this.actualCooldown == 63)
         {
            return "-";
         }
         return this.actualCooldown.toString();
      }
      
      public function get startTime() : int
      {
         return 0;
      }
      
      public function get endTime() : int
      {
         return 0;
      }
      
      public function set endTime(param1:int) : void
      {
      }
      
      public function get timer() : int
      {
         return 0;
      }
      
      public function get active() : Boolean
      {
         if(!PlayedCharacterManager.getInstance().isFighting)
         {
            return true;
         }
         return CurrentPlayedFighterManager.getInstance().canCastThisSpell(this.spellId,this.spellLevel);
      }
      
      public function get spell() : Spell
      {
         return Spell.getSpellById(this.id);
      }
      
      public function get spellId() : uint
      {
         if(this.spell)
         {
            return this.spell.id;
         }
         return 0;
      }
      
      public function get playerCriticalRate() : int
      {
         var _loc1_:Number = NaN;
         var _loc2_:uint = 0;
         var _loc3_:CharacterCharacteristicsInformations = null;
         var _loc4_:CharacterBaseCharacteristic = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this["isSpellWeapon"] && !this["isDefaultSpellWeapon"])
         {
            _loc2_ = this.getWeaponProperty("criticalHitProbability");
            _loc1_ = _loc2_ > 0?Number(55 - _loc2_):Number(0);
         }
         else
         {
            _loc1_ = this.getCriticalHitProbability();
         }
         if(_loc1_ && PlayedCharacterApi.knowSpell(this.spellId) >= 0)
         {
            if(!(!Kernel.getWorker().contains(FightContextFrame) || !CurrentPlayedFighterManager.getInstance() || PlayedCharacterManager.getInstance().id == CurrentPlayedFighterManager.getInstance().currentFighterId))
            {
               return _loc1_;
            }
            _loc3_ = PlayedCharacterManager.getInstance().characteristics;
            if(_loc3_)
            {
               _loc5_ = (_loc4_ = _loc3_.criticalHit).alignGiftBonus + _loc4_.base + _loc4_.contextModif + _loc4_.objectsAndMountBonus;
               if((_loc6_ = _loc1_ - _loc5_) > 54)
               {
                  _loc6_ = 54;
               }
               return _loc6_;
            }
         }
         return 0;
      }
      
      public function get playerCriticalFailureRate() : int
      {
         var _loc1_:CharacterCharacteristicsInformations = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Number;
         if((_loc4_ = this.criticalFailureProbability) && PlayedCharacterApi.knowSpell(this.spellId) >= 0)
         {
            _loc1_ = PlayedCharacterManager.getInstance().characteristics;
            if(_loc1_)
            {
               _loc2_ = _loc1_.criticalMiss;
               return int(_loc4_ - _loc2_.alignGiftBonus - _loc2_.base - _loc2_.contextModif - _loc2_.objectsAndMountBonus);
            }
         }
         return 0;
      }
      
      public function get maximalRangeWithBoosts() : int
      {
         var _loc1_:CharacterSpellModification = null;
         var _loc2_:int = 0;
         var _loc3_:CharacterCharacteristicsInformations = PlayedCharacterManager.getInstance().characteristics;
         var _loc4_:Boolean;
         if(!(_loc4_ = this._spellLevel.rangeCanBeBoosted))
         {
            for each(_loc1_ in _loc3_.spellModifications)
            {
               if(_loc1_.spellId == this.id && _loc1_.modificationType == CharacterSpellModificationTypeEnum.RANGEABLE)
               {
                  _loc4_ = true;
                  break;
               }
            }
         }
         if(_loc4_)
         {
            _loc2_ = _loc3_.range.base + _loc3_.range.alignGiftBonus + _loc3_.range.contextModif + _loc3_.range.objectsAndMountBonus;
            if(this.maximalRange + _loc2_ < this.minimalRange)
            {
               return this.minimalRange;
            }
            return this.maximalRange + _loc2_;
         }
         return this.maximalRange;
      }
      
      public function get canTargetCasterOutOfZone() : Boolean
      {
         var _loc1_:EffectInstance = null;
         if(this._canTargetCasterOutOfZone == null)
         {
            for each(_loc1_ in this.effects)
            {
               if(_loc1_.category == 2 && _loc1_.targetMask.indexOf("C") != -1)
               {
                  this._canTargetCasterOutOfZone = true;
                  break;
               }
            }
            if(!this._canTargetCasterOutOfZone)
            {
               for each(_loc1_ in this.criticalEffect)
               {
                  if(_loc1_.category == 2 && _loc1_.targetMask.indexOf("C") != -1)
                  {
                     this._canTargetCasterOutOfZone = true;
                     break;
                  }
               }
            }
            if(!this._canTargetCasterOutOfZone)
            {
               this._canTargetCasterOutOfZone = false;
            }
         }
         return this._canTargetCasterOutOfZone;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return isAttribute(param1);
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var _loc2_:CurrentPlayedFighterManager = null;
         var _loc3_:CharacterSpellModification = null;
         if(isAttribute(param1))
         {
            return this[param1];
         }
         if(this.id == 0 && PlayedCharacterManager.getInstance().currentWeapon != null)
         {
            return this.getWeaponProperty(param1);
         }
         _loc2_ = CurrentPlayedFighterManager.getInstance();
         switch(param1.toString())
         {
            case "id":
            case "nameId":
            case "descriptionId":
            case "typeId":
            case "scriptParams":
            case "scriptParamsCritical":
            case "scriptId":
            case "scriptIdCritical":
            case "iconId":
            case "spellLevels":
            case "useParamCache":
            case "name":
            case "description":
               return Spell.getSpellById(this.id)[param1];
            case "spellBreed":
            case "needFreeCell":
            case "needTakenCell":
            case "criticalFailureEndsTurn":
            case "criticalFailureProbability":
            case "minPlayerLevel":
            case "minRange":
            case "maxStack":
            case "globalCooldown":
               return this._spellLevel[param1.toString()];
            case "criticalHitProbability":
               return this.getCriticalHitProbability();
            case "maxCastPerTurn":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.MAX_CAST_PER_TURN);
               if(_loc3_)
               {
                  return this._spellLevel["maxCastPerTurn"] + _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus;
               }
               return this._spellLevel["maxCastPerTurn"];
               break;
            case "range":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.RANGE);
               if(_loc3_)
               {
                  return this._spellLevel["range"] + _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus;
               }
               return this._spellLevel["range"];
               break;
            case "maxCastPerTarget":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.MAX_CAST_PER_TARGET);
               if(_loc3_)
               {
                  return this._spellLevel["maxCastPerTarget"] + _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus;
               }
               return this._spellLevel["maxCastPerTarget"];
               break;
            case "castInLine":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.CAST_LINE);
               if(_loc3_)
               {
                  return this._spellLevel["castInLine"] && _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus + _loc3_.value.base + _loc3_.value.additionnal + _loc3_.value.alignGiftBonus == 0;
               }
               return this._spellLevel["castInLine"];
               break;
            case "castInDiagonal":
               return this._spellLevel["castInDiagonal"];
            case "castTestLos":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.LOS);
               if(_loc3_)
               {
                  return this._spellLevel["castTestLos"] && _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus + _loc3_.value.base + _loc3_.value.additionnal + _loc3_.value.alignGiftBonus == 0;
               }
               return this._spellLevel["castTestLos"];
               break;
            case "rangeCanBeBoosted":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.RANGEABLE);
               if(_loc3_)
               {
                  return this._spellLevel["rangeCanBeBoosted"] || _loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus + _loc3_.value.base + _loc3_.value.additionnal + _loc3_.value.alignGiftBonus > 0;
               }
               return this._spellLevel["rangeCanBeBoosted"];
               break;
            case "apCost":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.AP_COST);
               if(_loc3_)
               {
                  return this._spellLevel["apCost"] - (_loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus + _loc3_.value.base + _loc3_.value.additionnal + _loc3_.value.alignGiftBonus);
               }
               return this._spellLevel["apCost"];
               break;
            case "minCastInterval":
               _loc3_ = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.CAST_INTERVAL);
               if(_loc3_)
               {
                  return this._spellLevel["minCastInterval"] - (_loc3_.value.contextModif + _loc3_.value.objectsAndMountBonus + _loc3_.value.base + _loc3_.value.additionnal + _loc3_.value.alignGiftBonus);
               }
               return this._spellLevel["minCastInterval"];
               break;
            case "isSpellWeapon":
               return this.id == 0;
            case "isDefaultSpellWeapon":
               return this.id == 0 && !PlayedCharacterManager.getInstance().currentWeapon;
            case "statesRequired":
               return this._spellLevel.statesRequired;
            case "statesForbidden":
               return this._spellLevel.statesForbidden;
            default:
               return;
         }
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         return null;
      }
      
      private function getWeaponProperty(param1:*) : *
      {
         var _loc2_:int = 0;
         var _loc3_:ItemWrapper = PlayedCharacterManager.getInstance().currentWeapon as ItemWrapper;
         if(!_loc3_)
         {
            return null;
         }
         switch(param1.toString())
         {
            case "id":
               return 0;
            case "nameId":
            case "descriptionId":
            case "iconId":
            case "name":
            case "description":
            case "criticalFailureProbability":
            case "criticalHitProbability":
            case "castInLine":
            case "castInDiagonal":
            case "castTestLos":
            case "apCost":
            case "minRange":
            case "range":
               return _loc3_[param1];
            case "isDefaultSpellWeapon":
            case "useParamCache":
            case "needTakenCell":
            case "rangeCanBeBoosted":
               return false;
            case "isSpellWeapon":
            case "needFreeCell":
            case "criticalFailureEndsTurn":
               return true;
            case "minCastInterval":
            case "minPlayerLevel":
            case "maxStack":
            case "maxCastPerTurn":
            case "maxCastPerTarget":
               return 0;
            case "typeId":
               return 24;
            case "scriptParams":
            case "scriptParamsCritical":
            case "spellLevels":
               return null;
            case "scriptId":
            case "scriptIdCritical":
            case "spellBreed":
               return 0;
            default:
               return;
         }
      }
      
      private function getCriticalHitProbability() : Number
      {
         var _loc1_:int = 0;
         var _loc2_:CharacterSpellModification = CurrentPlayedFighterManager.getInstance().getSpellModifications(this.id,CharacterSpellModificationTypeEnum.CRITICAL_HIT_BONUS);
         var _loc3_:int = this._spellLevel["criticalHitProbability"] > 0?int(55 - this._spellLevel["criticalHitProbability"]):0;
         if(_loc2_)
         {
            _loc1_ = _loc2_.value.contextModif + _loc2_.value.objectsAndMountBonus + _loc2_.value.alignGiftBonus + _loc2_.value.base + _loc2_.value.additionnal;
            return _loc3_ > 0?Number(_loc3_ - _loc1_):Number(0);
         }
         return _loc3_;
      }
      
      public function clone() : *
      {
         var _loc1_:SpellWrapper = null;
         var _loc2_:Boolean = false;
         if(_cache[this.spellId] != null || _playersCache[this.playerId][this.spellId])
         {
            _loc2_ = true;
         }
         return SpellWrapper.create(this.position,this.id,this.spellLevel,_loc2_,this.playerId);
      }
      
      public function addHolder(param1:ISlotDataHolder) : void
      {
         this._slotDataHolderManager.addHolder(param1);
      }
      
      public function setLinkedSlotData(param1:ISlotData) : void
      {
         this._slotDataHolderManager.setLinkedSlotData(param1);
      }
      
      public function removeHolder(param1:ISlotDataHolder) : void
      {
         this._slotDataHolderManager.removeHolder(param1);
      }
      
      public function toString() : String
      {
         return "[SpellWrapper #" + this.id + "]";
      }
   }
}
