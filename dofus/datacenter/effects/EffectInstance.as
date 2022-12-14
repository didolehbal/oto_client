package com.ankamagames.dofus.datacenter.effects
{
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   import com.ankamagames.dofus.datacenter.appearance.Title;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.documents.Document;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceInteger;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.monsters.MonsterRace;
   import com.ankamagames.dofus.datacenter.monsters.MonsterSuperRace;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.types.enums.LanguageEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   import flash.utils.getQualifiedClassName;
   
   public class EffectInstance implements IDataCenter
   {
      
      private static const UNKNOWN_NAME:String = "???";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(EffectInstance));
      
      private static const UNDEFINED_CATEGORY:int = -2;
      
      private static const UNDEFINED_SHOW:int = -1;
      
      private static const UNDEFINED_DESCRIPTION:String = "undefined";
       
      
      public var effectUid:uint;
      
      public var effectId:uint;
      
      public var targetId:int;
      
      public var targetMask:String;
      
      public var duration:int;
      
      public var delay:int;
      
      public var random:int;
      
      public var group:int;
      
      public var modificator:int;
      
      public var trigger:Boolean;
      
      public var triggers:String;
      
      public var visibleInTooltip:Boolean = true;
      
      public var visibleInBuffUi:Boolean = true;
      
      public var visibleInFightLog:Boolean = true;
      
      public var zoneSize:Object;
      
      public var zoneShape:uint;
      
      public var zoneMinSize:Object;
      
      public var zoneEfficiencyPercent:Object;
      
      public var zoneMaxEfficiency:Object;
      
      private var _effectData:Effect;
      
      private var _durationStringValue:int;
      
      private var _delayStringValue:int;
      
      private var _durationString:String;
      
      private var _order:int = 0;
      
      private var _bonusType:int = -2;
      
      private var _oppositeId:int = -1;
      
      private var _category:int = -2;
      
      private var _description:String = "undefined";
      
      private var _theoricDescription:String = "undefined";
      
      private var _showSet:int = -1;
      
      private var _rawZoneInit:Boolean;
      
      private var _rawZone:String;
      
      public function EffectInstance()
      {
         super();
      }
      
      public function set rawZone(param1:String) : void
      {
         this._rawZone = param1;
         this.parseZone();
      }
      
      public function get rawZone() : String
      {
         return this._rawZone;
      }
      
      public function get durationString() : String
      {
         if(!this._durationString || this._durationStringValue != this.duration || this._delayStringValue != this.delay)
         {
            this._durationStringValue = this.duration;
            this._delayStringValue = this.delay;
            this._durationString = this.getTurnCountStr(false);
         }
         return this._durationString;
      }
      
      public function get category() : int
      {
         if(this._category == UNDEFINED_CATEGORY)
         {
            if(!this._effectData)
            {
               this._effectData = Effect.getEffectById(this.effectId);
            }
            this._category = !!this._effectData?int(this._effectData.category):-1;
         }
         return this._category;
      }
      
      public function get order() : int
      {
         if(this._order == 0)
         {
            if(!this._effectData)
            {
               this._effectData = Effect.getEffectById(this.effectId);
            }
            this._order = !!this._effectData?int(this._effectData.effectPriority):0;
         }
         return this._order;
      }
      
      public function get bonusType() : int
      {
         if(this._bonusType == -2)
         {
            if(!this._effectData)
            {
               this._effectData = Effect.getEffectById(this.effectId);
            }
            this._bonusType = !!this._effectData?int(this._effectData.bonusType):-2;
         }
         return this._bonusType;
      }
      
      public function get oppositeId() : int
      {
         if(this._oppositeId == -1)
         {
            if(!this._effectData)
            {
               this._effectData = Effect.getEffectById(this.effectId);
            }
            this._oppositeId = !!this._effectData?int(this._effectData.oppositeId):-1;
         }
         return this._oppositeId;
      }
      
      public function get showInSet() : int
      {
         if(this._showSet == UNDEFINED_SHOW)
         {
            if(!this._effectData)
            {
               this._effectData = Effect.getEffectById(this.effectId);
            }
            this._showSet = !!this._effectData?!!this._effectData.showInSet?1:0:0;
         }
         return this._showSet;
      }
      
      public function get parameter0() : Object
      {
         return null;
      }
      
      public function get parameter1() : Object
      {
         return null;
      }
      
      public function get parameter2() : Object
      {
         return null;
      }
      
      public function get parameter3() : Object
      {
         return null;
      }
      
      public function get parameter4() : Object
      {
         return null;
      }
      
      public function get description() : String
      {
         if(this._description == UNDEFINED_DESCRIPTION)
         {
            if(!this._effectData)
            {
               this._effectData = Effect.getEffectById(this.effectId);
            }
            if(!this._effectData)
            {
               this._description = null;
               return null;
            }
            this._description = this.prepareDescription(this._effectData.description,this.effectId);
         }
         return this._description;
      }
      
      public function get theoreticalDescription() : String
      {
         var _loc1_:String = null;
         if(this._theoricDescription == UNDEFINED_DESCRIPTION)
         {
            if(!this._effectData)
            {
               this._effectData = Effect.getEffectById(this.effectId);
            }
            if(!this._effectData)
            {
               this._theoricDescription = null;
               return null;
            }
            if(this._effectData.theoreticalPattern == 0)
            {
               this._theoricDescription = null;
               return null;
            }
            if(this._effectData.theoreticalPattern == 1)
            {
               _loc1_ = this._effectData.description;
            }
            else
            {
               _loc1_ = this._effectData.theoreticalDescription;
            }
            this._theoricDescription = this.prepareDescription(_loc1_,this.effectId);
         }
         return this._theoricDescription;
      }
      
      public function clone() : EffectInstance
      {
         var _loc1_:EffectInstance = new EffectInstance();
         _loc1_.zoneShape = this.zoneShape;
         _loc1_.zoneSize = this.zoneSize;
         _loc1_.zoneMinSize = this.zoneMinSize;
         _loc1_.zoneEfficiencyPercent = this.zoneEfficiencyPercent;
         _loc1_.zoneMaxEfficiency = this.zoneMaxEfficiency;
         _loc1_.effectUid = this.effectUid;
         _loc1_.effectId = this.effectId;
         _loc1_.duration = this.duration;
         _loc1_.random = this.random;
         _loc1_.group = this.group;
         _loc1_.targetId = this.targetId;
         _loc1_.targetMask = this.targetMask;
         _loc1_.delay = this.delay;
         _loc1_.triggers = this.triggers;
         _loc1_.visibleInTooltip = this.visibleInTooltip;
         _loc1_.visibleInBuffUi = this.visibleInBuffUi;
         _loc1_.visibleInFightLog = this.visibleInFightLog;
         return _loc1_;
      }
      
      public function add(param1:*) : EffectInstance
      {
         return new EffectInstance();
      }
      
      public function setParameter(param1:uint, param2:*) : void
      {
      }
      
      public function forceDescriptionRefresh() : void
      {
         this._description = UNDEFINED_DESCRIPTION;
         this._theoricDescription = UNDEFINED_DESCRIPTION;
      }
      
      private function getTurnCountStr(param1:Boolean) : String
      {
         var _loc2_:String = new String();
         if(this.delay > 0)
         {
            return PatternDecoder.combine(I18n.getUiText("ui.common.delayTurn",[this.delay]),"n",this.delay <= 1);
         }
         var _loc3_:int = this.duration;
         if(isNaN(_loc3_))
         {
            return "";
         }
         if(_loc3_ > -1)
         {
            if(_loc3_ > 1)
            {
               return PatternDecoder.combine(I18n.getUiText("ui.common.turn",[_loc3_]),"n",false);
            }
            if(_loc3_ == 0)
            {
               return "";
            }
            if(param1)
            {
               return I18n.getUiText("ui.common.lastTurn");
            }
            return PatternDecoder.combine(I18n.getUiText("ui.common.turn",[_loc3_]),"n",true);
         }
         return I18n.getUiText("ui.common.infinit");
      }
      
      private function getEmoticonName(param1:int) : String
      {
         var _loc2_:Emoticon = Emoticon.getEmoticonById(param1);
         return !!_loc2_?_loc2_.name:UNKNOWN_NAME;
      }
      
      private function getItemTypeName(param1:int) : String
      {
         var _loc2_:ItemType = ItemType.getItemTypeById(param1);
         return !!_loc2_?_loc2_.name:UNKNOWN_NAME;
      }
      
      private function getMonsterName(param1:int) : String
      {
         var _loc2_:Monster = Monster.getMonsterById(param1);
         return !!_loc2_?_loc2_.name:UNKNOWN_NAME;
      }
      
      private function getCompanionName(param1:int) : String
      {
         var _loc2_:Companion = Companion.getCompanionById(param1);
         return !!_loc2_?_loc2_.name:UNKNOWN_NAME;
      }
      
      private function getMonsterGrade(param1:int, param2:int) : String
      {
         var _loc3_:Monster = Monster.getMonsterById(param1);
         return !!_loc3_?_loc3_.getMonsterGrade(param2).level.toString():UNKNOWN_NAME;
      }
      
      private function getSpellName(param1:int) : String
      {
         var _loc2_:Spell = Spell.getSpellById(param1);
         return !!_loc2_?_loc2_.name:UNKNOWN_NAME;
      }
      
      private function getSpellLevelName(param1:int) : String
      {
         var _loc2_:SpellLevel = SpellLevel.getLevelById(param1);
         var _loc3_:String = !!_loc2_?this.getSpellName(_loc2_.spellId):UNKNOWN_NAME;
         return !!_loc2_?this.getSpellName(_loc2_.spellId):UNKNOWN_NAME;
      }
      
      private function getJobName(param1:int) : String
      {
         var _loc2_:Job = Job.getJobById(param1);
         return !!_loc2_?_loc2_.name:UNKNOWN_NAME;
      }
      
      private function getDocumentTitle(param1:int) : String
      {
         var _loc2_:Document = Document.getDocumentById(param1);
         return !!_loc2_?_loc2_.title:UNKNOWN_NAME;
      }
      
      private function getAlignmentSideName(param1:int) : String
      {
         var _loc2_:AlignmentSide = AlignmentSide.getAlignmentSideById(param1);
         return !!_loc2_?_loc2_.name:UNKNOWN_NAME;
      }
      
      private function getItemName(param1:int) : String
      {
         var _loc2_:Item = Item.getItemById(param1);
         return !!_loc2_?_loc2_.name:UNKNOWN_NAME;
      }
      
      private function getMonsterSuperRaceName(param1:int) : String
      {
         var _loc2_:MonsterSuperRace = MonsterSuperRace.getMonsterSuperRaceById(param1);
         return !!_loc2_?_loc2_.name:UNKNOWN_NAME;
      }
      
      private function getMonsterRaceName(param1:int) : String
      {
         var _loc2_:MonsterRace = MonsterRace.getMonsterRaceById(param1);
         return !!_loc2_?_loc2_.name:UNKNOWN_NAME;
      }
      
      private function getTitleName(param1:int) : String
      {
         var _loc2_:Title = Title.getTitleById(param1);
         return !!_loc2_?_loc2_.name:UNKNOWN_NAME;
      }
      
      private function parseZone() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Boolean = false;
         if(this.rawZone && this.rawZone.length)
         {
            this.zoneShape = this.rawZone.charCodeAt(0);
            _loc1_ = this.rawZone.substr(1).split(",");
            _loc2_ = this.zoneShape == SpellShapeEnum.C || this.zoneShape == SpellShapeEnum.X || this.zoneShape == SpellShapeEnum.Q || this.zoneShape == SpellShapeEnum.plus || this.zoneShape == SpellShapeEnum.sharp;
            switch(_loc1_.length)
            {
               case 1:
                  this.zoneSize = parseInt(_loc1_[0]);
                  break;
               case 2:
                  this.zoneSize = parseInt(_loc1_[0]);
                  if(_loc2_)
                  {
                     this.zoneMinSize = parseInt(_loc1_[1]);
                  }
                  else
                  {
                     this.zoneEfficiencyPercent = parseInt(_loc1_[1]);
                  }
                  break;
               case 3:
                  this.zoneSize = parseInt(_loc1_[0]);
                  if(_loc2_)
                  {
                     this.zoneMinSize = parseInt(_loc1_[1]);
                     this.zoneEfficiencyPercent = parseInt(_loc1_[2]);
                  }
                  else
                  {
                     this.zoneEfficiencyPercent = parseInt(_loc1_[1]);
                     this.zoneMaxEfficiency = parseInt(_loc1_[2]);
                  }
                  break;
               case 4:
                  this.zoneSize = parseInt(_loc1_[0]);
                  this.zoneMinSize = parseInt(_loc1_[1]);
                  this.zoneEfficiencyPercent = parseInt(_loc1_[2]);
                  this.zoneMaxEfficiency = parseInt(_loc1_[3]);
            }
            this._rawZoneInit = true;
         }
         else
         {
            _log.error("Zone incorrect (" + this.rawZone + ")");
         }
      }
      
      private function prepareDescription(param1:String, param2:uint) : String
      {
         var _loc3_:Array = null;
         var _loc4_:SpellState = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         if(param1 == null)
         {
            return "";
         }
         var _loc11_:* = "";
         if(param1.indexOf("#") != -1)
         {
            _loc3_ = [this.parameter0,this.parameter1,this.parameter2,this.parameter3,this.parameter4];
            switch(param2)
            {
               case 10:
                  _loc3_[2] = this.getEmoticonName(_loc3_[0]);
                  break;
               case 165:
               case 1084:
               case 1179:
                  _loc3_[0] = this.getItemTypeName(_loc3_[0]);
                  break;
               case 197:
               case 181:
               case 185:
               case 405:
               case 2796:
                  _loc3_[0] = this.getMonsterName(_loc3_[0]);
                  break;
               case 220:
                  if(!_loc3_[0] && !_loc3_[1] && _loc3_[2])
                  {
                     _loc3_[0] = _loc3_[2];
                  }
                  break;
               case 281:
               case 282:
               case 283:
               case 284:
               case 285:
               case 286:
               case 287:
               case 288:
               case 289:
               case 290:
               case 291:
               case 292:
               case 293:
               case 294:
               case 1160:
                  _loc3_[0] = this.getSpellName(_loc3_[0]);
                  break;
               case 1175:
                  _loc3_[0] = "{spellNoLvl," + _loc3_[0] + "," + _loc3_[1] + "}";
                  break;
               case 406:
                  _loc3_[2] = this.getSpellName(_loc3_[2]);
                  break;
               case 604:
                  if(_loc3_[2] == null)
                  {
                     _loc3_[2] = _loc3_[0];
                  }
                  _loc3_[2] = this.getSpellLevelName(_loc3_[2]);
                  break;
               case 614:
               case 1050:
                  _loc3_[0] = _loc3_[2];
                  _loc3_[1] = this.getJobName(_loc3_[1]);
                  break;
               case 616:
               case 624:
                  _loc3_[2] = this.getSpellName(_loc3_[0]);
                  break;
               case 620:
                  _loc3_[2] = this.getDocumentTitle(_loc3_[0]);
                  break;
               case 621:
                  _loc3_[2] = this.getMonsterName(_loc3_[1]);
                  break;
               case 623:
               case 628:
                  _loc3_[1] = this.getMonsterGrade(_loc3_[2],_loc3_[0]);
                  _loc3_[2] = this.getMonsterName(_loc3_[2]);
                  break;
               case 649:
               case 960:
                  _loc3_[2] = this.getAlignmentSideName(_loc3_[0]);
                  break;
               case 669:
                  break;
               case 699:
                  _loc3_[0] = this.getJobName(_loc3_[0]);
                  break;
               case 706:
                  break;
               case 715:
                  _loc3_[0] = this.getMonsterSuperRaceName(_loc3_[0]);
                  break;
               case 716:
                  _loc3_[0] = this.getMonsterRaceName(_loc3_[0]);
                  break;
               case 717:
               case 1008:
               case 1011:
                  _loc3_[0] = this.getMonsterName(_loc3_[0]);
                  break;
               case 724:
                  _loc3_[2] = this.getTitleName(_loc3_[0]);
                  break;
               case 787:
               case 792:
               case 793:
               case 1017:
               case 1018:
               case 1019:
               case 1035:
               case 1036:
               case 1044:
               case 1045:
                  _loc3_[0] = this.getSpellName(_loc3_[0]);
                  break;
               case 800:
                  _loc3_[2] = _loc3_[0];
                  break;
               case 806:
                  if(_loc3_[1] > 6)
                  {
                     _loc3_[0] = I18n.getUiText("ui.petWeight.fat",[_loc3_[1]]);
                  }
                  else if(_loc3_[2] > 6)
                  {
                     _loc3_[0] = I18n.getUiText("ui.petWeight.lean",[_loc3_[2]]);
                  }
                  else if(this is EffectInstanceInteger && _loc3_[0] > 6)
                  {
                     _loc3_[0] = I18n.getUiText("ui.petWeight.lean",[_loc3_[0]]);
                  }
                  else
                  {
                     _loc3_[0] = I18n.getUiText("ui.petWeight.nominal");
                  }
                  break;
               case 807:
                  if(_loc3_[0])
                  {
                     _loc3_[0] = this.getItemName(_loc3_[0]);
                  }
                  else
                  {
                     _loc3_[0] = I18n.getUiText("ui.common.none");
                  }
                  break;
               case 814:
               case 1151:
               case 1176:
                  _loc3_[0] = this.getItemName(_loc3_[0]);
                  break;
               case 905:
                  _loc3_[1] = this.getMonsterName(_loc3_[1]);
                  break;
               case 939:
               case 940:
                  _loc3_[2] = this.getItemName(_loc3_[0]);
                  break;
               case 950:
               case 951:
               case 952:
                  if(_loc4_ = _loc3_[2] != null?SpellState.getSpellStateById(_loc3_[2]):SpellState.getSpellStateById(_loc3_[0]))
                  {
                     if(_loc4_.isSilent)
                     {
                        return "";
                     }
                     _loc3_[2] = _loc4_.name;
                  }
                  else
                  {
                     _loc3_[2] = UNKNOWN_NAME;
                  }
                  break;
               case 961:
               case 962:
                  _loc3_[2] = _loc3_[0];
                  break;
               case 982:
                  break;
               case 988:
               case 987:
               case 985:
               case 996:
                  _loc3_[3] = "{player," + _loc3_[3] + "}";
                  break;
               case 1111:
                  _loc3_[2] = _loc3_[0];
                  break;
               case 1161:
                  _loc3_[0] = this.getCompanionName(_loc3_[0]);
                  break;
               case 805:
               case 808:
               case 983:
                  if(_loc3_[0] == undefined && _loc3_[1] == undefined && _loc3_[2] > 0)
                  {
                     _loc3_[0] = _loc3_[2];
                     break;
                  }
                  if(_loc3_[0] == null && _loc3_[1] == null && _loc3_[2] == null)
                  {
                     break;
                  }
                  _loc3_[2] = _loc3_[2] == undefined?0:_loc3_[2];
                  _loc5_ = _loc3_[0];
                  _loc6_ = _loc3_[1].substr(0,2);
                  _loc7_ = _loc3_[1].substr(2,2);
                  _loc8_ = _loc3_[2].substr(0,2);
                  _loc9_ = _loc3_[2].substr(2,2);
                  _loc10_ = XmlConfig.getInstance().getEntry("config.lang.current");
                  switch(_loc10_)
                  {
                     case LanguageEnum.LANG_FR:
                        _loc3_[0] = _loc7_ + "/" + _loc6_ + "/" + _loc5_ + " " + _loc8_ + ":" + _loc9_;
                        break;
                     case LanguageEnum.LANG_EN:
                        _loc3_[0] = _loc6_ + "/" + _loc7_ + "/" + _loc5_ + " " + _loc8_ + ":" + _loc9_;
                        break;
                     default:
                        _loc3_[0] = _loc6_ + "/" + _loc7_ + "/" + _loc5_ + " " + _loc8_ + ":" + _loc9_;
                  }
                  break;
            }
            if((_loc11_ = PatternDecoder.getDescription(param1,_loc3_)) == null || _loc11_ == "")
            {
               return "";
            }
         }
         else
         {
            _loc11_ = param1;
         }
         if(this.modificator != 0)
         {
            _loc11_ = _loc11_ + (" " + I18n.getUiText("ui.effect.boosted.spell.complement",[this.modificator],"%"));
         }
         if(this.random > 0)
         {
            if(this.group > 0)
            {
               _loc11_ = _loc11_ + (" (" + I18n.getUiText("ui.common.random") + ")");
            }
            else
            {
               _loc11_ = _loc11_ + (" " + I18n.getUiText("ui.effect.randomProbability",[this.random],"%"));
            }
         }
         return _loc11_;
      }
   }
}
