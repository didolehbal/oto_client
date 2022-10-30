package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.internalDatacenter.communication.BasicChatSentence;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildFactSheetWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialEntityInFightWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialFightersWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.EnemyWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.FriendWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.IgnoredWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.SpouseWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.frames.PlayedCharacterUpdatesFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TaxCollectorsManager;
   import com.ankamagames.dofus.network.types.game.guild.GuildMember;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class SocialApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function SocialApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(SocialApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      public function get socialFrame() : SocialFrame
      {
         return Kernel.getWorker().getFrame(SocialFrame) as SocialFrame;
      }
      
      public function get allianceFrame() : AllianceFrame
      {
         return Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getFriendsList() : Array
      {
         var _loc1_:FriendWrapper = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = this.socialFrame.friendsList;
         for each(_loc1_ in _loc3_)
         {
            _loc2_.push(_loc1_);
         }
         _loc2_.sortOn("name",Array.CASEINSENSITIVE);
         return _loc2_;
      }
      
      [Untrusted]
      public function isFriend(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:Array = this.socialFrame.friendsList;
         for each(_loc2_ in _loc3_)
         {
            if(_loc2_.playerName == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getEnemiesList() : Array
      {
         var _loc1_:EnemyWrapper = null;
         var _loc2_:Array = new Array();
         for each(_loc1_ in this.socialFrame.enemiesList)
         {
            _loc2_.push(_loc1_);
         }
         _loc2_.sortOn("name",Array.CASEINSENSITIVE);
         return _loc2_;
      }
      
      [Untrusted]
      public function isEnemy(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this.socialFrame.enemiesList)
         {
            if(_loc2_.playerName == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getIgnoredList() : Array
      {
         var _loc1_:IgnoredWrapper = null;
         var _loc2_:Array = new Array();
         for each(_loc1_ in this.socialFrame.ignoredList)
         {
            _loc2_.push(_loc1_);
         }
         _loc2_.sortOn("name",Array.CASEINSENSITIVE);
         return _loc2_;
      }
      
      [Untrusted]
      public function isIgnored(param1:String, param2:int = 0) : Boolean
      {
         return this.socialFrame.isIgnored(param1,param2);
      }
      
      [Trusted]
      public function getAccountName(param1:String) : String
      {
         return param1;
      }
      
      [Untrusted]
      public function getWarnOnFriendConnec() : Boolean
      {
         return this.socialFrame.warnFriendConnec;
      }
      
      [Untrusted]
      public function getWarnOnMemberConnec() : Boolean
      {
         return this.socialFrame.warnMemberConnec;
      }
      
      [Untrusted]
      public function getWarnWhenFriendOrGuildMemberLvlUp() : Boolean
      {
         return this.socialFrame.warnWhenFriendOrGuildMemberLvlUp;
      }
      
      [Untrusted]
      public function getWarnWhenFriendOrGuildMemberAchieve() : Boolean
      {
         return this.socialFrame.warnWhenFriendOrGuildMemberAchieve;
      }
      
      [Untrusted]
      public function getWarnOnHardcoreDeath() : Boolean
      {
         return this.socialFrame.warnOnHardcoreDeath;
      }
      
      [Untrusted]
      public function getSpouse() : SpouseWrapper
      {
         return this.socialFrame.spouse;
      }
      
      [Untrusted]
      public function hasSpouse() : Boolean
      {
         return this.socialFrame.hasSpouse;
      }
      
      [Untrusted]
      public function getAllowedGuildEmblemSymbolCategories() : int
      {
         var _loc1_:PlayedCharacterUpdatesFrame = Kernel.getWorker().getFrame(PlayedCharacterUpdatesFrame) as PlayedCharacterUpdatesFrame;
         return _loc1_.guildEmblemSymbolCategories;
      }
      
      [Untrusted]
      public function hasGuild() : Boolean
      {
         return this.socialFrame.hasGuild;
      }
      
      [Untrusted]
      public function getGuild() : GuildWrapper
      {
         return this.socialFrame.guild;
      }
      
      [Untrusted]
      public function getGuildMembers() : Vector.<GuildMember>
      {
         return this.socialFrame.guildmembers;
      }
      
      [Untrusted]
      public function getGuildRights() : Array
      {
         return GuildWrapper.guildRights;
      }
      
      [Untrusted]
      public function getGuildByid(param1:int) : GuildFactSheetWrapper
      {
         return this.socialFrame.getGuildById(param1);
      }
      
      [Untrusted]
      public function hasGuildRight(param1:uint, param2:String) : Boolean
      {
         var _loc3_:GuildMember = null;
         var _loc4_:GuildWrapper = null;
         if(!this.socialFrame.hasGuild)
         {
            return false;
         }
         if(param1 == PlayedCharacterManager.getInstance().id)
         {
            return this.socialFrame.guild.hasRight(param2);
         }
         for each(_loc3_ in this.socialFrame.guildmembers)
         {
            if(_loc3_.id == param1)
            {
               return (_loc4_ = GuildWrapper.create(0,"",null,_loc3_.rights,true)).hasRight(param2);
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getGuildHouses() : Object
      {
         return this.socialFrame.guildHouses;
      }
      
      [Untrusted]
      public function guildHousesUpdateNeeded() : Boolean
      {
         return this.socialFrame.guildHousesUpdateNeeded;
      }
      
      [Untrusted]
      public function getGuildPaddocks() : Object
      {
         return this.socialFrame.guildPaddocks;
      }
      
      [Untrusted]
      public function getMaxGuildPaddocks() : int
      {
         return this.socialFrame.maxGuildPaddocks;
      }
      
      [Untrusted]
      public function isGuildNameInvalid() : Boolean
      {
         if(this.socialFrame.guild)
         {
            return this.socialFrame.guild.realGuildName == "#NONAME#";
         }
         return false;
      }
      
      [Untrusted]
      public function getMaxCollectorCount() : uint
      {
         return TaxCollectorsManager.getInstance().maxTaxCollectorsCount;
      }
      
      [Untrusted]
      public function getTaxCollectors() : Dictionary
      {
         return TaxCollectorsManager.getInstance().taxCollectors;
      }
      
      [Untrusted]
      public function getTaxCollector(param1:int) : TaxCollectorWrapper
      {
         return TaxCollectorsManager.getInstance().taxCollectors[param1];
      }
      
      [Untrusted]
      public function getGuildFightingTaxCollectors() : Dictionary
      {
         return TaxCollectorsManager.getInstance().guildTaxCollectorsFighters;
      }
      
      [Untrusted]
      public function getGuildFightingTaxCollector(param1:uint) : SocialEntityInFightWrapper
      {
         return TaxCollectorsManager.getInstance().guildTaxCollectorsFighters[param1];
      }
      
      [Untrusted]
      public function getAllFightingTaxCollectors() : Dictionary
      {
         return TaxCollectorsManager.getInstance().allTaxCollectorsInPreFight;
      }
      
      [Untrusted]
      public function getAllFightingTaxCollector(param1:uint) : SocialEntityInFightWrapper
      {
         return TaxCollectorsManager.getInstance().allTaxCollectorsInPreFight[param1];
      }
      
      [Untrusted]
      public function isPlayerDefender(param1:int, param2:uint, param3:int) : Boolean
      {
         var _loc4_:SocialEntityInFightWrapper = null;
         var _loc5_:SocialFightersWrapper = null;
         if(param1 == 0)
         {
            if(!(_loc4_ = TaxCollectorsManager.getInstance().guildTaxCollectorsFighters[param3]))
            {
               _loc4_ = TaxCollectorsManager.getInstance().allTaxCollectorsInPreFight[param3];
            }
         }
         else if(param1 == 1)
         {
            _loc4_ = TaxCollectorsManager.getInstance().prismsFighters[param3];
         }
         if(_loc4_)
         {
            for each(_loc5_ in _loc4_.allyCharactersInformations)
            {
               if(_loc5_.playerCharactersInformations.id == param2)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      [Untrusted]
      public function hasAlliance() : Boolean
      {
         return this.allianceFrame.hasAlliance;
      }
      
      [Untrusted]
      public function getAlliance() : AllianceWrapper
      {
         return this.allianceFrame.alliance;
      }
      
      [Untrusted]
      public function getAllianceById(param1:int) : AllianceWrapper
      {
         return this.allianceFrame.getAllianceById(param1);
      }
      
      [Untrusted]
      public function getAllianceGuilds() : Vector.<GuildFactSheetWrapper>
      {
         return this.allianceFrame.alliance.guilds;
      }
      
      [Untrusted]
      public function isAllianceNameInvalid() : Boolean
      {
         if(this.allianceFrame.alliance)
         {
            return this.allianceFrame.alliance.realAllianceName == "#NONAME#";
         }
         return false;
      }
      
      [Untrusted]
      public function isAllianceTagInvalid() : Boolean
      {
         if(this.allianceFrame.alliance)
         {
            return this.allianceFrame.alliance.realAllianceTag == "#TAG#";
         }
         return false;
      }
      
      [Untrusted]
      public function getPrismSubAreaById(param1:int) : PrismSubAreaWrapper
      {
         return this.allianceFrame.getPrismSubAreaById(param1);
      }
      
      [Untrusted]
      public function getFightingPrisms() : Dictionary
      {
         return TaxCollectorsManager.getInstance().prismsFighters;
      }
      
      [Untrusted]
      public function getFightingPrism(param1:uint) : SocialEntityInFightWrapper
      {
         return TaxCollectorsManager.getInstance().prismsFighters[param1];
      }
      
      [Untrusted]
      public function isPlayerPrismDefender(param1:uint, param2:int) : Boolean
      {
         var _loc3_:SocialFightersWrapper = null;
         var _loc4_:SocialEntityInFightWrapper;
         if(_loc4_ = TaxCollectorsManager.getInstance().prismsFighters[param2])
         {
            for each(_loc3_ in _loc4_.allyCharactersInformations)
            {
               if(_loc3_.playerCharactersInformations.id == param1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      [Trusted]
      public function getChatSentence(param1:Number, param2:String) : BasicChatSentence
      {
         var _loc3_:Array = null;
         var _loc4_:BasicChatSentence = null;
         var _loc5_:Boolean = false;
         var _loc6_:BasicChatSentence = null;
         var _loc7_:ChatFrame = Kernel.getWorker().getFrame(ChatFrame) as ChatFrame;
         for each(_loc3_ in _loc7_.getMessages())
         {
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_.fingerprint == param2 && _loc4_.timestamp == param1)
               {
                  _loc6_ = _loc4_;
                  _loc5_ = true;
                  break;
               }
            }
            if(_loc5_)
            {
               break;
            }
         }
         return _loc6_;
      }
   }
}
