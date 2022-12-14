package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialEntityInFightWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialFightersWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.dofus.network.enums.TaxCollectorStateEnum;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalPlusLookInformations;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorFightersInformation;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.prism.PrismFightersInformation;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class TaxCollectorsManager implements IDestroyable
   {
      
      private static const TYPE_TAX_COLLECTOR:int = 0;
      
      private static const TYPE_PRISM:int = 1;
      
      private static var _self:TaxCollectorsManager;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TaxCollectorsManager));
       
      
      private var _taxCollectors:Dictionary;
      
      private var _guildTaxCollectorsInFight:Dictionary;
      
      private var _allTaxCollectorsInPreFight:Dictionary;
      
      private var _collectedTaxCollectors:Dictionary;
      
      private var _prismsInFight:Dictionary;
      
      public var maxTaxCollectorsCount:int;
      
      public var taxCollectorsCount:int;
      
      public var taxCollectorLifePoints:int;
      
      public var taxCollectorDamagesBonuses:int;
      
      public var taxCollectorPods:int;
      
      public var taxCollectorProspecting:int;
      
      public var taxCollectorWisdom:int;
      
      public function TaxCollectorsManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("TaxCollectorsManager is a singleton and should not be instanciated directly.");
         }
         this._taxCollectors = new Dictionary();
         this._guildTaxCollectorsInFight = new Dictionary();
         this._allTaxCollectorsInPreFight = new Dictionary();
         this._collectedTaxCollectors = new Dictionary();
         this._prismsInFight = new Dictionary();
      }
      
      public static function getInstance() : TaxCollectorsManager
      {
         if(_self == null)
         {
            _self = new TaxCollectorsManager();
         }
         return _self;
      }
      
      public function destroy() : void
      {
         this._taxCollectors = new Dictionary();
         this._guildTaxCollectorsInFight = new Dictionary();
         this._allTaxCollectorsInPreFight = new Dictionary();
         this._collectedTaxCollectors = new Dictionary();
         this._prismsInFight = new Dictionary();
         _self = null;
      }
      
      public function get taxCollectors() : Dictionary
      {
         return this._taxCollectors;
      }
      
      public function get guildTaxCollectorsFighters() : Dictionary
      {
         return this._guildTaxCollectorsInFight;
      }
      
      public function get allTaxCollectorsInPreFight() : Dictionary
      {
         return this._allTaxCollectorsInPreFight;
      }
      
      public function get collectedTaxCollectors() : Dictionary
      {
         return this._collectedTaxCollectors;
      }
      
      public function get prismsFighters() : Dictionary
      {
         return this._prismsInFight;
      }
      
      public function setTaxCollectors(param1:Vector.<TaxCollectorInformations>) : void
      {
         var _loc2_:TaxCollectorInformations = null;
         this._taxCollectors = new Dictionary();
         for each(_loc2_ in param1)
         {
            this._taxCollectors[_loc2_.uniqueId] = TaxCollectorWrapper.create(_loc2_);
         }
      }
      
      public function setTaxCollectorsFighters(param1:Vector.<TaxCollectorFightersInformation>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc5_:TaxCollectorFightersInformation = null;
         var _loc6_:TaxCollectorWrapper = null;
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         var _loc9_:int = SocialFrame.getInstance().guild.guildId;
         this._guildTaxCollectorsInFight = new Dictionary();
         this._allTaxCollectorsInPreFight = new Dictionary();
         for each(_loc5_ in param1)
         {
            if(!(_loc6_ = this._taxCollectors[_loc5_.collectorId]))
            {
               _log.error("Tax collector " + _loc5_.collectorId + " doesn\'t exist IS PROBLEM");
            }
            else
            {
               _loc2_ = _loc6_.fightTime;
               _loc3_ = _loc6_.waitTimeForPlacement * 100;
               _loc7_ = new Array();
               _loc8_ = new Array();
               for each(_loc4_ in _loc5_.allyCharactersInformations)
               {
                  _loc7_.push(_loc4_);
               }
               for each(_loc4_ in _loc5_.enemyCharactersInformations)
               {
                  _loc8_.push(_loc4_);
               }
               if(!_loc6_.guild || _loc6_.guild.guildId == _loc9_)
               {
                  if(this._guildTaxCollectorsInFight[_loc5_.collectorId])
                  {
                     this._guildTaxCollectorsInFight[_loc5_.collectorId].update(TYPE_TAX_COLLECTOR,_loc5_.collectorId,_loc7_,_loc8_,_loc2_,_loc3_,_loc6_.nbPositionPerTeam);
                  }
                  else
                  {
                     this._guildTaxCollectorsInFight[_loc5_.collectorId] = SocialEntityInFightWrapper.create(TYPE_TAX_COLLECTOR,_loc5_.collectorId,_loc7_,_loc8_,_loc2_,_loc3_,_loc6_.nbPositionPerTeam);
                  }
                  this._guildTaxCollectorsInFight[_loc5_.collectorId].addPonyFighter(_loc6_);
               }
               if(_loc6_.state != TaxCollectorStateEnum.STATE_WAITING_FOR_HELP)
               {
                  if(this._allTaxCollectorsInPreFight[_loc5_.collectorId])
                  {
                     delete this._allTaxCollectorsInPreFight[_loc5_.collectorId];
                  }
               }
               else
               {
                  if(this._allTaxCollectorsInPreFight[_loc5_.collectorId])
                  {
                     this._allTaxCollectorsInPreFight[_loc5_.collectorId].update(TYPE_TAX_COLLECTOR,_loc5_.collectorId,_loc7_,_loc8_,_loc2_,_loc3_,_loc6_.nbPositionPerTeam);
                  }
                  else
                  {
                     this._allTaxCollectorsInPreFight[_loc5_.collectorId] = SocialEntityInFightWrapper.create(TYPE_TAX_COLLECTOR,_loc5_.collectorId,_loc7_,_loc8_,_loc2_,_loc3_,_loc6_.nbPositionPerTeam);
                  }
                  this._allTaxCollectorsInPreFight[_loc5_.collectorId].addPonyFighter(_loc6_);
               }
            }
         }
      }
      
      public function setPrismsInFight(param1:Vector.<PrismFightersInformation>) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:PrismFightersInformation = null;
         this._prismsInFight = new Dictionary();
         for each(_loc6_ in param1)
         {
            _loc2_ = new Array();
            _loc3_ = new Array();
            for each(_loc4_ in _loc6_.allyCharactersInformations)
            {
               _loc2_.push(_loc4_);
            }
            for each(_loc4_ in _loc6_.enemyCharactersInformations)
            {
               _loc3_.push(_loc4_);
            }
            _loc5_ = _loc6_.waitingForHelpInfo.timeLeftBeforeFight * 100 + getTimer();
            if(this._prismsInFight[_loc6_.subAreaId])
            {
               this._prismsInFight[_loc6_.subAreaId].update(TYPE_PRISM,_loc6_.subAreaId,_loc2_,_loc3_,_loc5_,_loc6_.waitingForHelpInfo.waitTimeForPlacement * 100,_loc6_.waitingForHelpInfo.nbPositionForDefensors);
            }
            else
            {
               this._prismsInFight[_loc6_.subAreaId] = SocialEntityInFightWrapper.create(TYPE_PRISM,_loc6_.subAreaId,_loc2_,_loc3_,_loc5_,_loc6_.waitingForHelpInfo.waitTimeForPlacement * 100,_loc6_.waitingForHelpInfo.nbPositionForDefensors);
            }
         }
      }
      
      public function updateGuild(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int) : void
      {
         this.maxTaxCollectorsCount = param1;
         this.taxCollectorsCount = param2;
         this.taxCollectorLifePoints = param3;
         this.taxCollectorDamagesBonuses = param4;
         this.taxCollectorPods = param5;
         this.taxCollectorProspecting = param6;
         this.taxCollectorWisdom = param7;
      }
      
      public function addTaxCollector(param1:TaxCollectorInformations) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this._taxCollectors[param1.uniqueId])
         {
            this._taxCollectors[param1.uniqueId].update(param1);
         }
         else
         {
            this._taxCollectors[param1.uniqueId] = TaxCollectorWrapper.create(param1);
            _loc2_ = true;
         }
         var _loc3_:Boolean = this._taxCollectors[param1.uniqueId].guild == null || this._taxCollectors[param1.uniqueId].guild.guildId == SocialFrame.getInstance().guild.guildId;
         if(_loc3_)
         {
            if(param1.state == TaxCollectorStateEnum.STATE_COLLECTING)
            {
               delete this._guildTaxCollectorsInFight[param1.uniqueId];
            }
            else
            {
               if(this._guildTaxCollectorsInFight[param1.uniqueId])
               {
                  this._guildTaxCollectorsInFight[param1.uniqueId].update(TYPE_TAX_COLLECTOR,param1.uniqueId,new Array(),new Array());
               }
               else
               {
                  this._guildTaxCollectorsInFight[param1.uniqueId] = SocialEntityInFightWrapper.create(TYPE_TAX_COLLECTOR,param1.uniqueId);
               }
               if(param1.state == TaxCollectorStateEnum.STATE_WAITING_FOR_HELP)
               {
                  this._guildTaxCollectorsInFight[param1.uniqueId].addPonyFighter(this._taxCollectors[param1.uniqueId]);
               }
            }
         }
         if(param1.state != TaxCollectorStateEnum.STATE_WAITING_FOR_HELP)
         {
            delete this._allTaxCollectorsInPreFight[param1.uniqueId];
         }
         else
         {
            this._allTaxCollectorsInPreFight[param1.uniqueId] = SocialEntityInFightWrapper.create(TYPE_TAX_COLLECTOR,param1.uniqueId);
            this._allTaxCollectorsInPreFight[param1.uniqueId].addPonyFighter(this._taxCollectors[param1.uniqueId]);
         }
         return _loc2_;
      }
      
      public function addPrism(param1:PrismFightersInformation) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         for each(_loc2_ in param1.allyCharactersInformations)
         {
            _loc4_.push(_loc2_);
         }
         for each(_loc2_ in param1.enemyCharactersInformations)
         {
            _loc5_.push(_loc2_);
         }
         _loc3_ = param1.waitingForHelpInfo.timeLeftBeforeFight * 100 + getTimer();
         this._prismsInFight[param1.subAreaId] = SocialEntityInFightWrapper.create(TYPE_PRISM,param1.subAreaId,_loc4_,_loc5_,_loc3_,param1.waitingForHelpInfo.waitTimeForPlacement * 100,param1.waitingForHelpInfo.nbPositionForDefensors);
      }
      
      public function addFighter(param1:int, param2:int, param3:CharacterMinimalPlusLookInformations, param4:Boolean, param5:Boolean = true) : void
      {
         var _loc6_:SocialEntityInFightWrapper = null;
         var _loc7_:Array = new Array();
         if(param1 == TYPE_PRISM)
         {
            _loc7_.push(this._prismsInFight[param2]);
         }
         else if(param1 == TYPE_TAX_COLLECTOR)
         {
            if(this._guildTaxCollectorsInFight[param2])
            {
               _loc7_.push(this._guildTaxCollectorsInFight[param2]);
            }
            if(this._allTaxCollectorsInPreFight[param2])
            {
               _loc7_.push(this._allTaxCollectorsInPreFight[param2]);
            }
         }
         for each(_loc6_ in _loc7_)
         {
            if(param4)
            {
               if(_loc6_.allyCharactersInformations == null)
               {
                  _loc6_.allyCharactersInformations = new Vector.<SocialFightersWrapper>();
               }
               _loc6_.allyCharactersInformations.push(SocialFightersWrapper.create(0,param3));
               if(param5)
               {
                  KernelEventsManager.getInstance().processCallback(SocialHookList.GuildFightAlliesListUpdate,param1,param2);
               }
            }
            else
            {
               if(_loc6_.enemyCharactersInformations == null)
               {
                  _loc6_.enemyCharactersInformations = new Vector.<SocialFightersWrapper>();
               }
               _loc6_.enemyCharactersInformations.push(SocialFightersWrapper.create(1,param3));
               if(param5)
               {
                  KernelEventsManager.getInstance().processCallback(SocialHookList.GuildFightEnnemiesListUpdate,param1,param2);
               }
            }
         }
         if(param5)
         {
            if(param4)
            {
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildFightAlliesListUpdate,param1,param2);
            }
            else
            {
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildFightEnnemiesListUpdate,param1,param2);
            }
         }
      }
      
      public function removeFighter(param1:int, param2:int, param3:int, param4:Boolean, param5:Boolean = true) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:SocialEntityInFightWrapper = null;
         var _loc8_:SocialFightersWrapper = null;
         var _loc9_:SocialFightersWrapper = null;
         var _loc10_:Array = new Array();
         if(param1 == TYPE_PRISM)
         {
            _loc10_.push(this._prismsInFight[param2]);
         }
         else if(param1 == TYPE_TAX_COLLECTOR)
         {
            if(this._guildTaxCollectorsInFight[param2])
            {
               _loc10_.push(this._guildTaxCollectorsInFight[param2]);
            }
            if(this._allTaxCollectorsInPreFight[param2])
            {
               _loc10_.push(this._allTaxCollectorsInPreFight[param2]);
            }
         }
         if(_loc10_.length == 0)
         {
            _log.error("Error ! Fighter " + param3 + " cannot be removed from unknown fight " + param2 + ".");
            return;
         }
         for each(_loc7_ in _loc10_)
         {
            _loc6_ = 0;
            if(param4)
            {
               for each(_loc8_ in _loc7_.allyCharactersInformations)
               {
                  if(_loc8_.playerCharactersInformations.id == param3)
                  {
                     break;
                  }
                  _loc6_++;
               }
               _loc7_.allyCharactersInformations.splice(_loc6_,1);
            }
            else
            {
               for each(_loc9_ in _loc7_.enemyCharactersInformations)
               {
                  if(_loc9_.playerCharactersInformations.id == param3)
                  {
                     break;
                  }
                  _loc6_++;
               }
               _loc7_.enemyCharactersInformations.splice(_loc6_,1);
            }
         }
         if(param5)
         {
            if(param4)
            {
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildFightAlliesListUpdate,param1,param2);
            }
            else
            {
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildFightEnnemiesListUpdate,param1,param2);
            }
         }
      }
   }
}
