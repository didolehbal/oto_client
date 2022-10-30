package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.berilia.managers.HtmlManager;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.managers.OptionManager;
   
   public class SpellDamage
   {
       
      
      public var invulnerableState:Boolean;
      
      public var unhealableState:Boolean;
      
      public var hasCriticalDamage:Boolean;
      
      public var hasCriticalShieldPointsRemoved:Boolean;
      
      public var hasCriticalLifePointsAdded:Boolean;
      
      public var isHealingSpell:Boolean;
      
      public var hasHeal:Boolean;
      
      private var _effectDamages:Vector.<EffectDamage>;
      
      private var _minDamage:int;
      
      private var _maxDamage:int;
      
      private var _minCriticalDamage:int;
      
      private var _maxCriticalDamage:int;
      
      private var _minShieldPointsRemoved:int;
      
      private var _maxShieldPointsRemoved:int;
      
      private var _minCriticalShieldPointsRemoved:int;
      
      private var _maxCriticalShieldPointsRemoved:int;
      
      public var effectIcons:Array;
      
      public function SpellDamage()
      {
         super();
         this._effectDamages = new Vector.<EffectDamage>();
      }
      
      public function get minDamage() : int
      {
         var _loc1_:EffectDamage = null;
         this._minDamage = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._minDamage = this._minDamage + _loc1_.minDamage;
         }
         return this._minDamage;
      }
      
      public function set minDamage(param1:int) : void
      {
         this._minDamage = param1;
      }
      
      public function get maxDamage() : int
      {
         var _loc1_:EffectDamage = null;
         this._maxDamage = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._maxDamage = this._maxDamage + _loc1_.maxDamage;
         }
         return this._maxDamage;
      }
      
      public function set maxDamage(param1:int) : void
      {
         this._maxDamage = param1;
      }
      
      public function get minCriticalDamage() : int
      {
         var _loc1_:EffectDamage = null;
         this._minCriticalDamage = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._minCriticalDamage = this._minCriticalDamage + _loc1_.minCriticalDamage;
         }
         return this._minCriticalDamage;
      }
      
      public function set minCriticalDamage(param1:int) : void
      {
         this._minCriticalDamage = param1;
      }
      
      public function get maxCriticalDamage() : int
      {
         var _loc1_:EffectDamage = null;
         this._maxCriticalDamage = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._maxCriticalDamage = this._maxCriticalDamage + _loc1_.maxCriticalDamage;
         }
         return this._maxCriticalDamage;
      }
      
      public function set maxCriticalDamage(param1:int) : void
      {
         this._maxCriticalDamage = param1;
      }
      
      public function get minErosionDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.minErosionDamage;
         }
         return _loc1_;
      }
      
      public function get maxErosionDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.maxErosionDamage;
         }
         return _loc1_;
      }
      
      public function get minCriticalErosionDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.minCriticalErosionDamage;
         }
         return _loc1_;
      }
      
      public function get maxCriticalErosionDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.maxCriticalErosionDamage;
         }
         return _loc1_;
      }
      
      public function get minShieldPointsRemoved() : int
      {
         var _loc1_:EffectDamage = null;
         this._minShieldPointsRemoved = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._minShieldPointsRemoved = this._minShieldPointsRemoved + _loc1_.minShieldPointsRemoved;
         }
         return this._minShieldPointsRemoved;
      }
      
      public function set minShieldPointsRemoved(param1:int) : void
      {
         this._minShieldPointsRemoved = param1;
      }
      
      public function get maxShieldPointsRemoved() : int
      {
         var _loc1_:EffectDamage = null;
         this._maxShieldPointsRemoved = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._maxShieldPointsRemoved = this._maxShieldPointsRemoved + _loc1_.maxShieldPointsRemoved;
         }
         return this._maxShieldPointsRemoved;
      }
      
      public function set maxShieldPointsRemoved(param1:int) : void
      {
         this._maxShieldPointsRemoved = param1;
      }
      
      public function get minCriticalShieldPointsRemoved() : int
      {
         var _loc1_:EffectDamage = null;
         this._minCriticalShieldPointsRemoved = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._minCriticalShieldPointsRemoved = this._minCriticalShieldPointsRemoved + _loc1_.minCriticalShieldPointsRemoved;
         }
         return this._minCriticalShieldPointsRemoved;
      }
      
      public function set minCriticalShieldPointsRemoved(param1:int) : void
      {
         this._minCriticalShieldPointsRemoved = param1;
      }
      
      public function get maxCriticalShieldPointsRemoved() : int
      {
         var _loc1_:EffectDamage = null;
         this._maxCriticalShieldPointsRemoved = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._maxCriticalShieldPointsRemoved = this._maxCriticalShieldPointsRemoved + _loc1_.maxCriticalShieldPointsRemoved;
         }
         return this._maxCriticalShieldPointsRemoved;
      }
      
      public function set maxCriticalShieldPointsRemoved(param1:int) : void
      {
         this._maxCriticalShieldPointsRemoved = param1;
      }
      
      public function get minLifePointsAdded() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.minLifePointsAdded;
         }
         return _loc1_;
      }
      
      public function get maxLifePointsAdded() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.maxLifePointsAdded;
         }
         return _loc1_;
      }
      
      public function get minCriticalLifePointsAdded() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.minCriticalLifePointsAdded;
         }
         return _loc1_;
      }
      
      public function get maxCriticalLifePointsAdded() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.maxCriticalLifePointsAdded;
         }
         return _loc1_;
      }
      
      public function get lifePointsAddedBasedOnLifePercent() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.lifePointsAddedBasedOnLifePercent;
         }
         return _loc1_;
      }
      
      public function get criticalLifePointsAddedBasedOnLifePercent() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.criticalLifePointsAddedBasedOnLifePercent;
         }
         return _loc1_;
      }
      
      public function updateDamage() : void
      {
         this.minDamage;
         this.maxDamage;
         this.minCriticalDamage;
         this.maxCriticalDamage;
         this.minShieldPointsRemoved;
         this.maxShieldPointsRemoved;
         this.minCriticalShieldPointsRemoved;
         this.maxCriticalShieldPointsRemoved;
      }
      
      public function addEffectDamage(param1:EffectDamage) : void
      {
         this._effectDamages.push(param1);
      }
      
      public function get effectDamages() : Vector.<EffectDamage>
      {
         return this._effectDamages;
      }
      
      public function get hasRandomEffects() : Boolean
      {
         var _loc1_:EffectDamage = null;
         for each(_loc1_ in this._effectDamages)
         {
            if(_loc1_.random > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get random() : int
      {
         var _loc1_:EffectDamage = null;
         var _loc2_:int = -1;
         var _loc3_:Boolean = true;
         for each(_loc1_ in this._effectDamages)
         {
            if(_loc1_.random > 0)
            {
               if(_loc3_)
               {
                  _loc2_ = _loc1_.random;
                  _loc3_ = false;
               }
               else if(_loc1_.random != _loc2_)
               {
                  return -1;
               }
            }
         }
         return _loc2_;
      }
      
      public function get element() : int
      {
         var _loc1_:EffectDamage = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = -1;
         var _loc4_:Boolean = true;
         for each(_loc1_ in this._effectDamages)
         {
            if(_loc1_.element != -1)
            {
               if(_loc4_)
               {
                  _loc3_ = _loc1_.element;
                  _loc4_ = false;
               }
               else if(_loc1_.element != _loc3_)
               {
                  return -1;
               }
            }
            if(_loc1_.effectId == 5)
            {
               _loc2_ = true;
            }
         }
         if(_loc3_ != -1 && _loc2_)
         {
            _loc3_ = -1;
         }
         return _loc3_;
      }
      
      private function get damageConvertedToHeal() : Boolean
      {
         var _loc1_:EffectDamage = null;
         for each(_loc1_ in this._effectDamages)
         {
            if(_loc1_.damageConvertedToHeal)
            {
               return true;
            }
         }
         return false;
      }
      
      private function getElementTextColor(param1:int) : String
      {
         var _loc2_:String = null;
         if(param1 == -1)
         {
            _loc2_ = "fight.text.multi";
         }
         else
         {
            switch(param1)
            {
               case 0:
                  _loc2_ = "fight.text.neutral";
                  break;
               case 1:
                  _loc2_ = "fight.text.earth";
                  break;
               case 2:
                  _loc2_ = "fight.text.fire";
                  break;
               case 3:
                  _loc2_ = "fight.text.water";
                  break;
               case 4:
                  _loc2_ = "fight.text.air";
            }
         }
         return XmlConfig.getInstance().getEntry("colors." + _loc2_);
      }
      
      private function getEffectString(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:int = 0) : String
      {
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:* = "";
         if(param1 == param2)
         {
            _loc7_ = String(param2);
         }
         else
         {
            _loc7_ = param1 + (param2 != 0?" - " + param2:"");
         }
         if(param5)
         {
            if(param3 == param4)
            {
               _loc8_ = String(param4);
            }
            else
            {
               _loc8_ = param3 + (param4 != 0?" - " + param4:"");
            }
         }
         if(_loc7_)
         {
            _loc9_ = _loc7_;
         }
         if(_loc8_)
         {
            if(_loc7_)
            {
               _loc9_ = _loc9_ + (" (<b>" + _loc8_ + "</b>)");
            }
         }
         return param6 > 0?param6 + "% " + _loc9_:_loc9_;
      }
      
      public function toString() : String
      {
         var _loc1_:EffectDamage = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:* = "";
         var _loc7_:String = this.getElementTextColor(this.element);
         var _loc8_:* = "0x9966CC";
         var _loc9_:int = OptionManager.getOptionManager("chat")["channelColor" + ChatActivableChannelsEnum.PSEUDO_CHANNEL_FIGHT_LOG];
         this.effectIcons = new Array();
         if(this.hasRandomEffects && !this.invulnerableState)
         {
            for each(_loc1_ in this._effectDamages)
            {
               if(_loc1_.element != -1)
               {
                  if(this.damageConvertedToHeal)
                  {
                     this.effectIcons.push("lifePoints");
                     _loc2_ = this.getEffectString(_loc1_.minLifePointsAdded,_loc1_.maxLifePointsAdded,_loc1_.minCriticalLifePointsAdded,_loc1_.maxCriticalLifePointsAdded,_loc1_.hasCritical,_loc1_.random);
                  }
                  else
                  {
                     this.effectIcons.push(null);
                     _loc2_ = this.getEffectString(_loc1_.minDamage,_loc1_.maxDamage,_loc1_.minCriticalDamage,_loc1_.maxCriticalDamage,_loc1_.hasCritical,_loc1_.random);
                  }
                  _loc6_ = _loc6_ + (HtmlManager.addTag(_loc2_,HtmlManager.SPAN,{"color":(!!this.damageConvertedToHeal?_loc9_:this.getElementTextColor(_loc1_.element))}) + "\n");
               }
            }
         }
         else
         {
            if(!this.isHealingSpell && !this.damageConvertedToHeal)
            {
               _loc4_ = this.getEffectString(this._minDamage,this._maxDamage,this._minCriticalDamage,this._maxCriticalDamage,this.hasCriticalDamage);
               _loc4_ = !!this.invulnerableState?SpellState.getSpellStateById(56).name:_loc4_;
               this.effectIcons.push(null);
               _loc6_ = _loc6_ + (HtmlManager.addTag(_loc4_,HtmlManager.SPAN,{"color":_loc7_}) + "\n");
            }
            if(!this.isHealingSpell && !this.invulnerableState)
            {
               if(this._minShieldPointsRemoved != 0 && this._maxShieldPointsRemoved != 0)
               {
                  _loc3_ = this.getEffectString(this._minShieldPointsRemoved,this._maxShieldPointsRemoved,this._minCriticalShieldPointsRemoved,this._maxCriticalShieldPointsRemoved,this.hasCriticalShieldPointsRemoved);
               }
               if(_loc3_)
               {
                  this.effectIcons.push(null);
                  _loc6_ = _loc6_ + (HtmlManager.addTag(_loc3_,HtmlManager.SPAN,{"color":_loc8_}) + "\n");
               }
            }
            if(this.hasHeal || this.damageConvertedToHeal)
            {
               _loc5_ = this.getEffectString(this.minLifePointsAdded,this.maxLifePointsAdded,this.minCriticalLifePointsAdded,this.maxCriticalLifePointsAdded,this.hasCriticalLifePointsAdded);
               if(this.unhealableState)
               {
                  this.effectIcons.push(null);
                  _loc5_ = SpellState.getSpellStateById(76).name;
               }
               else
               {
                  this.effectIcons.push("lifePoints");
               }
               _loc6_ = _loc6_ + HtmlManager.addTag(_loc5_,HtmlManager.SPAN,{"color":_loc9_});
            }
         }
         return _loc6_;
      }
   }
}
