package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.datacenter.abuse.AbuseReasons;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentBalance;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   import com.ankamagames.dofus.datacenter.almanax.AlmanaxCalendar;
   import com.ankamagames.dofus.datacenter.appearance.Ornament;
   import com.ankamagames.dofus.datacenter.appearance.Title;
   import com.ankamagames.dofus.datacenter.appearance.TitleCategory;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.breeds.BreedRole;
   import com.ankamagames.dofus.datacenter.breeds.Head;
   import com.ankamagames.dofus.datacenter.characteristics.Characteristic;
   import com.ankamagames.dofus.datacenter.characteristics.CharacteristicCategory;
   import com.ankamagames.dofus.datacenter.communication.ChatChannel;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.communication.InfoMessage;
   import com.ankamagames.dofus.datacenter.communication.Smiley;
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.externalnotifications.ExternalNotification;
   import com.ankamagames.dofus.datacenter.guild.EmblemBackground;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbolCategory;
   import com.ankamagames.dofus.datacenter.guild.RankName;
   import com.ankamagames.dofus.datacenter.houses.House;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.datacenter.items.Incarnation;
   import com.ankamagames.dofus.datacenter.items.IncarnationLevel;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.ItemSet;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.datacenter.items.PresetIcon;
   import com.ankamagames.dofus.datacenter.items.VeteranReward;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.datacenter.livingObjects.Pet;
   import com.ankamagames.dofus.datacenter.misc.ActionDescription;
   import com.ankamagames.dofus.datacenter.misc.OptionalFeature;
   import com.ankamagames.dofus.datacenter.misc.Pack;
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.datacenter.monsters.CompanionCharacteristic;
   import com.ankamagames.dofus.datacenter.monsters.CompanionSpell;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.monsters.MonsterMiniBoss;
   import com.ankamagames.dofus.datacenter.monsters.MonsterRace;
   import com.ankamagames.dofus.datacenter.monsters.MonsterSuperRace;
   import com.ankamagames.dofus.datacenter.notifications.Notification;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.datacenter.npcs.NpcAction;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   import com.ankamagames.dofus.datacenter.quest.AchievementCategory;
   import com.ankamagames.dofus.datacenter.quest.AchievementObjective;
   import com.ankamagames.dofus.datacenter.quest.AchievementReward;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.datacenter.quest.QuestCategory;
   import com.ankamagames.dofus.datacenter.quest.QuestObjective;
   import com.ankamagames.dofus.datacenter.quest.QuestStep;
   import com.ankamagames.dofus.datacenter.quest.treasureHunt.LegendaryTreasureHunt;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.datacenter.servers.ServerPopulation;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellBomb;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.datacenter.spells.SpellPair;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.datacenter.spells.SpellType;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.datacenter.world.Dungeon;
   import com.ankamagames.dofus.datacenter.world.HintCategory;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.world.SuperArea;
   import com.ankamagames.dofus.datacenter.world.Waypoint;
   import com.ankamagames.dofus.datacenter.world.WorldMap;
   import com.ankamagames.dofus.internalDatacenter.almanax.AlmanaxEvent;
   import com.ankamagames.dofus.internalDatacenter.almanax.AlmanaxMonth;
   import com.ankamagames.dofus.internalDatacenter.almanax.AlmanaxZodiac;
   import com.ankamagames.dofus.internalDatacenter.appearance.OrnamentWrapper;
   import com.ankamagames.dofus.internalDatacenter.appearance.TitleWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.EmoteWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.SmileyWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.LivingObjectSkinWrapper;
   import com.ankamagames.dofus.internalDatacenter.jobs.JobWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.internalDatacenter.taxi.TeleportDestinationWrapper;
   import com.ankamagames.dofus.internalDatacenter.userInterface.ButtonWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.managers.AlmanaxManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.misc.utils.GameDataQuery;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import com.ankamagames.dofus.types.data.GenericSlotData;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import flash.net.registerClassAlias;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class DataApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function DataApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(DataApi));
         super();
      }
      
      private function get entitiesFrame() : RoleplayEntitiesFrame
      {
         return Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getNotifications() : Array
      {
         return Notification.getNotifications();
      }
      
      [Trusted]
      public function getServer(param1:int) : Server
      {
         return Server.getServerById(param1);
      }
      
      [Trusted]
      public function getServerPopulation(param1:int) : ServerPopulation
      {
         return ServerPopulation.getServerPopulationById(param1);
      }
      
      [Untrusted]
      public function getBreed(param1:int) : Breed
      {
         return Breed.getBreedById(param1);
      }
      
      [Untrusted]
      public function getBreeds() : Array
      {
         return Breed.getBreeds();
      }
      
      [Untrusted]
      public function getBreedRole(param1:int) : BreedRole
      {
         return BreedRole.getBreedRoleById(param1);
      }
      
      [Untrusted]
      public function getBreedRoles() : Array
      {
         return BreedRole.getBreedRoles();
      }
      
      [Untrusted]
      public function getHead(param1:int) : Head
      {
         return Head.getHeadById(param1);
      }
      
      [Untrusted]
      public function getHeads() : Array
      {
         return Head.getHeads();
      }
      
      [Untrusted]
      public function getCharacteristic(param1:int) : Characteristic
      {
         return Characteristic.getCharacteristicById(param1);
      }
      
      [Untrusted]
      public function getCharacteristics() : Array
      {
         return Characteristic.getCharacteristics();
      }
      
      [Untrusted]
      public function getCharacteristicCategory(param1:int) : CharacteristicCategory
      {
         return CharacteristicCategory.getCharacteristicCategoryById(param1);
      }
      
      [Untrusted]
      public function getCharacteristicCategories() : Array
      {
         return CharacteristicCategory.getCharacteristicCategories();
      }
      
      [Untrusted]
      public function getSpell(param1:int) : Spell
      {
         return Spell.getSpellById(param1);
      }
      
      [Untrusted]
      public function getSpells() : Array
      {
         return Spell.getSpells();
      }
      
      [Untrusted]
      public function getSpellWrapper(param1:uint, param2:uint = 1) : SpellWrapper
      {
         return SpellWrapper.create(-1,param1,param2,false);
      }
      
      [Untrusted]
      public function getEmoteWrapper(param1:uint, param2:uint = 0) : EmoteWrapper
      {
         return EmoteWrapper.create(param1,param2);
      }
      
      [Untrusted]
      public function getButtonWrapper(param1:uint, param2:int, param3:String, param4:Function, param5:String, param6:String = "") : ButtonWrapper
      {
         return ButtonWrapper.create(param1,param2,param3,param4,param5,param6);
      }
      
      [Untrusted]
      public function getJobs() : Array
      {
         return Job.getJobs();
      }
      
      [Untrusted]
      public function getJobWrapper(param1:uint) : JobWrapper
      {
         return JobWrapper.create(param1);
      }
      
      [Untrusted]
      public function getTitleWrapper(param1:uint) : TitleWrapper
      {
         return TitleWrapper.create(param1);
      }
      
      [Untrusted]
      public function getOrnamentWrapper(param1:uint) : OrnamentWrapper
      {
         return OrnamentWrapper.create(param1);
      }
      
      [Untrusted]
      public function getSpellLevel(param1:int) : SpellLevel
      {
         return SpellLevel.getLevelById(param1);
      }
      
      [Untrusted]
      public function getSpellLevelBySpell(param1:Spell, param2:int) : SpellLevel
      {
         return param1.getSpellLevel(param2);
      }
      
      [Untrusted]
      public function getSpellType(param1:int) : SpellType
      {
         return SpellType.getSpellTypeById(param1);
      }
      
      [Untrusted]
      public function getSpellState(param1:int) : SpellState
      {
         return SpellState.getSpellStateById(param1);
      }
      
      [Untrusted]
      public function getChatChannel(param1:int) : ChatChannel
      {
         return ChatChannel.getChannelById(param1);
      }
      
      [Untrusted]
      public function getAllChatChannels() : Array
      {
         return ChatChannel.getChannels();
      }
      
      [Untrusted]
      public function getSubArea(param1:int) : SubArea
      {
         return SubArea.getSubAreaById(param1);
      }
      
      [Untrusted]
      public function getSubAreaFromMap(param1:int) : SubArea
      {
         return SubArea.getSubAreaByMapId(param1);
      }
      
      [Untrusted]
      public function getAllSubAreas() : Array
      {
         return SubArea.getAllSubArea();
      }
      
      [Untrusted]
      public function getArea(param1:int) : Area
      {
         return Area.getAreaById(param1);
      }
      
      [Untrusted]
      public function getSuperArea(param1:int) : SuperArea
      {
         return SuperArea.getSuperAreaById(param1);
      }
      
      [Untrusted]
      public function getAllArea(param1:Boolean = false, param2:Boolean = false) : Array
      {
         var _loc3_:Area = null;
         var _loc4_:Array = new Array();
         for each(_loc3_ in Area.getAllArea())
         {
            if(param1 && _loc3_.containHouses || param2 && _loc3_.containPaddocks || !param1 && !param2)
            {
               _loc4_.push(_loc3_);
            }
         }
         return _loc4_;
      }
      
      [Untrusted]
      public function getWorldPoint(param1:int) : WorldPoint
      {
         return WorldPoint.fromMapId(param1);
      }
      
      [Untrusted]
      public function getItem(param1:int, param2:Boolean = true) : Item
      {
         return Item.getItemById(param1,param2);
      }
      
      [Untrusted]
      public function getItems() : Array
      {
         return Item.getItems();
      }
      
      [Untrusted]
      public function getIncarnationLevel(param1:int, param2:int) : IncarnationLevel
      {
         return IncarnationLevel.getIncarnationLevelByIdAndLevel(param1,param2);
      }
      
      [Untrusted]
      public function getIncarnation(param1:int) : Incarnation
      {
         return Incarnation.getIncarnationById(param1);
      }
      
      [NoBoxing]
      [Untrusted]
      public function getNewGenericSlotData() : GenericSlotData
      {
         return new GenericSlotData();
      }
      
      [Untrusted]
      public function getItemIconUri(param1:uint) : Uri
      {
         return new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.item.bitmap").concat(param1).concat(".png"));
      }
      
      [Untrusted]
      public function getItemName(param1:int) : String
      {
         var _loc2_:Item = Item.getItemById(param1);
         if(_loc2_)
         {
            return _loc2_.name;
         }
         return null;
      }
      
      [Untrusted]
      public function getItemType(param1:int) : ItemType
      {
         return ItemType.getItemTypeById(param1);
      }
      
      [Untrusted]
      public function getItemSet(param1:int) : ItemSet
      {
         return ItemSet.getItemSetById(param1);
      }
      
      [Untrusted]
      public function getPet(param1:int) : Pet
      {
         return Pet.getPetById(param1);
      }
      
      [Untrusted]
      public function getSetEffects(param1:Array, param2:Array = null) : Array
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:EffectInstance = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:Dictionary = new Dictionary();
         var _loc14_:Array = new Array();
         var _loc15_:Array = new Array();
         var _loc16_:Array = new Array();
         for each(_loc3_ in PlayedCharacterManager.getInstance().inventory)
         {
            if(_loc3_.position <= 15)
            {
               for(_loc8_ in param1)
               {
                  if(_loc3_.objectGID == param1[_loc8_])
                  {
                     _loc16_.push(_loc3_);
                     param1[_loc8_] = -1;
                  }
               }
            }
         }
         for each(_loc4_ in param1)
         {
            if(_loc4_ != -1)
            {
               for each(_loc9_ in Item.getItemById(_loc4_).possibleEffects)
               {
                  if(Effect.getEffectById(_loc9_.effectId).useDice)
                  {
                     if(_loc13_[_loc9_.effectId])
                     {
                        _loc13_[_loc9_.effectId].add(_loc9_);
                     }
                     else
                     {
                        _loc13_[_loc9_.effectId] = _loc9_.clone();
                     }
                  }
                  else
                  {
                     _loc15_.push(_loc9_.clone());
                  }
               }
            }
         }
         for each(_loc5_ in _loc16_)
         {
            for each(_loc10_ in _loc5_.effects)
            {
               if(Effect.getEffectById(_loc10_.effectId).useDice)
               {
                  if(_loc13_[_loc10_.effectId])
                  {
                     _loc13_[_loc10_.effectId].add(_loc10_);
                  }
                  else
                  {
                     _loc13_[_loc10_.effectId] = _loc10_.clone();
                  }
               }
               else
               {
                  _loc15_.push(_loc10_.clone());
               }
            }
         }
         if(param2 && param2.length)
         {
            for each(_loc11_ in param2)
            {
               if((_loc12_ = this.deepClone(SecureCenter.unsecure(_loc11_))) is String)
               {
                  this._log.debug("Bonus en texte, on ne peut pas l\'ajouter \'" + _loc12_ + "\'");
               }
               else if(Effect.getEffectById(_loc12_.effectId) && Effect.getEffectById(_loc12_.effectId).useDice)
               {
                  if(_loc13_[_loc12_.effectId])
                  {
                     _loc13_[_loc12_.effectId].add(SecureCenter.unsecure(_loc12_));
                  }
                  else
                  {
                     _loc13_[_loc12_.effectId] = SecureCenter.unsecure(_loc12_).clone();
                  }
               }
               else
               {
                  _loc15_.push(this.deepClone(SecureCenter.unsecure(_loc12_)));
               }
            }
         }
         for each(_loc6_ in _loc13_)
         {
            if(_loc6_.showInSet > 0)
            {
               _loc14_.push(_loc6_);
            }
         }
         for each(_loc7_ in _loc15_)
         {
            if(_loc7_.showInSet > 0)
            {
               _loc14_.push(_loc7_);
            }
         }
         return _loc14_;
      }
      
      [Untrusted]
      public function getMonsterFromId(param1:uint) : Monster
      {
         return Monster.getMonsterById(param1);
      }
      
      [Untrusted]
      public function getMonsters() : Array
      {
         return Monster.getMonsters();
      }
      
      [Untrusted]
      public function getMonsterMiniBossFromId(param1:uint) : MonsterMiniBoss
      {
         return MonsterMiniBoss.getMonsterById(param1);
      }
      
      [Untrusted]
      public function getMonsterRaceFromId(param1:uint) : MonsterRace
      {
         return MonsterRace.getMonsterRaceById(param1);
      }
      
      [Untrusted]
      public function getMonsterRaces() : Array
      {
         return MonsterRace.getMonsterRaces();
      }
      
      [Untrusted]
      public function getMonsterSuperRaceFromId(param1:uint) : MonsterSuperRace
      {
         return MonsterSuperRace.getMonsterSuperRaceById(param1);
      }
      
      [Untrusted]
      public function getMonsterSuperRaces() : Array
      {
         return MonsterSuperRace.getMonsterSuperRaces();
      }
      
      [Untrusted]
      public function getCompanion(param1:uint) : Companion
      {
         return Companion.getCompanionById(param1);
      }
      
      [Untrusted]
      public function getAllCompanions() : Array
      {
         return Companion.getCompanions();
      }
      
      [Untrusted]
      public function getCompanionCharacteristic(param1:uint) : CompanionCharacteristic
      {
         return CompanionCharacteristic.getCompanionCharacteristicById(param1);
      }
      
      [Untrusted]
      public function getCompanionSpell(param1:uint) : CompanionSpell
      {
         return CompanionSpell.getCompanionSpellById(param1);
      }
      
      [Untrusted]
      public function getNpc(param1:uint) : Npc
      {
         return Npc.getNpcById(param1);
      }
      
      [Untrusted]
      public function getNpcAction(param1:uint) : NpcAction
      {
         return NpcAction.getNpcActionById(param1);
      }
      
      [Untrusted]
      public function getAlignmentSide(param1:uint) : AlignmentSide
      {
         return AlignmentSide.getAlignmentSideById(param1);
      }
      
      [Untrusted]
      public function getAlignmentBalance(param1:uint) : AlignmentBalance
      {
         var _loc2_:uint = 0;
         if(param1 == 0)
         {
            _loc2_ = 1;
         }
         else if(param1 == 10)
         {
            _loc2_ = 2;
         }
         else if(param1 == 20)
         {
            _loc2_ = 3;
         }
         else if(param1 == 30)
         {
            _loc2_ = 4;
         }
         else if(param1 == 40)
         {
            _loc2_ = 5;
         }
         else if(param1 == 50)
         {
            _loc2_ = 6;
         }
         else if(param1 == 60)
         {
            _loc2_ = 7;
         }
         else if(param1 == 70)
         {
            _loc2_ = 8;
         }
         else if(param1 == 80)
         {
            _loc2_ = 9;
         }
         else if(param1 == 90)
         {
            _loc2_ = 10;
         }
         else
         {
            _loc2_ = Math.ceil(param1 / 10);
         }
         return AlignmentBalance.getAlignmentBalanceById(_loc2_);
      }
      
      [Untrusted]
      public function getRankName(param1:uint) : RankName
      {
         return RankName.getRankNameById(param1);
      }
      
      [Untrusted]
      public function getAllRankNames() : Array
      {
         return RankName.getRankNames();
      }
      
      [Untrusted]
      public function getItemWrapper(param1:uint, param2:int = 0, param3:uint = 0, param4:uint = 0, param5:* = null) : ItemWrapper
      {
         if(param5 == null)
         {
            param5 = new Vector.<ObjectEffect>();
         }
         return ItemWrapper.create(param2,param3,param1,param4,param5,false);
      }
      
      [Untrusted]
      public function getItemFromUId(param1:uint) : ItemWrapper
      {
         return ItemWrapper.getItemFromUId(param1);
      }
      
      [Untrusted]
      public function getSkill(param1:uint) : Skill
      {
         return Skill.getSkillById(param1);
      }
      
      [Untrusted]
      public function getSkills() : Array
      {
         return Skill.getSkills();
      }
      
      [Untrusted]
      public function getHouseSkills() : Array
      {
         var _loc1_:Skill = null;
         var _loc2_:Array = new Array();
         for each(_loc1_ in Skill.getSkills())
         {
            if(_loc1_.availableInHouse)
            {
               _loc2_.push(_loc1_);
            }
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getInfoMessage(param1:uint) : InfoMessage
      {
         return InfoMessage.getInfoMessageById(param1);
      }
      
      [Untrusted]
      public function getAllInfoMessages() : Array
      {
         return InfoMessage.getInfoMessages();
      }
      
      [Untrusted]
      public function getSmiliesWrapperForPlayers() : Array
      {
         var _loc1_:Smiley = null;
         var _loc2_:SmileyWrapper = null;
         var _loc3_:ChatFrame = Kernel.getWorker().getFrame(ChatFrame) as ChatFrame;
         if(_loc3_ && _loc3_.smilies && _loc3_.smilies.length > 0)
         {
            return _loc3_.smilies;
         }
         var _loc4_:Array = new Array();
         for each(_loc1_ in Smiley.getSmileys())
         {
            if(_loc1_.forPlayers)
            {
               _loc2_ = SmileyWrapper.create(_loc1_.id,_loc1_.gfxId,_loc1_.order);
               _loc4_.push(_loc2_);
            }
         }
         _loc4_.sortOn("order",Array.NUMERIC);
         return _loc4_;
      }
      
      [Untrusted]
      public function getSmiley(param1:uint) : Smiley
      {
         return Smiley.getSmileyById(param1);
      }
      
      [Untrusted]
      public function getAllSmiley() : Array
      {
         return Smiley.getSmileys();
      }
      
      [Untrusted]
      public function getEmoticon(param1:uint) : Emoticon
      {
         return Emoticon.getEmoticonById(param1);
      }
      
      [Untrusted]
      public function getTaxCollectorName(param1:uint) : TaxCollectorName
      {
         return TaxCollectorName.getTaxCollectorNameById(param1);
      }
      
      [Untrusted]
      public function getTaxCollectorFirstname(param1:uint) : TaxCollectorFirstname
      {
         return TaxCollectorFirstname.getTaxCollectorFirstnameById(param1);
      }
      
      [Untrusted]
      public function getEmblems() : Array
      {
         var _loc1_:EmblemSymbol = null;
         var _loc2_:EmblemBackground = null;
         var _loc3_:Array = null;
         var _loc4_:Array = EmblemSymbol.getEmblemSymbols();
         var _loc5_:Array = EmblemBackground.getEmblemBackgrounds();
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         for each(_loc1_ in _loc4_)
         {
            _loc6_.push(EmblemWrapper.create(_loc1_.id,EmblemWrapper.UP));
         }
         _loc6_.sortOn("order",Array.NUMERIC);
         for each(_loc2_ in _loc5_)
         {
            _loc7_.push(EmblemWrapper.create(_loc2_.id,EmblemWrapper.BACK));
         }
         _loc7_.sortOn("order",Array.NUMERIC);
         return new Array(_loc6_,_loc7_);
      }
      
      [Untrusted]
      public function getEmblemSymbol(param1:int) : EmblemSymbol
      {
         return EmblemSymbol.getEmblemSymbolById(param1);
      }
      
      [Untrusted]
      public function getAllEmblemSymbolCategories() : Array
      {
         return EmblemSymbolCategory.getEmblemSymbolCategories();
      }
      
      [Untrusted]
      public function getQuest(param1:int) : Quest
      {
         return Quest.getQuestById(param1);
      }
      
      [Untrusted]
      public function getQuestCategory(param1:int) : QuestCategory
      {
         return QuestCategory.getQuestCategoryById(param1);
      }
      
      [Untrusted]
      public function getQuestObjective(param1:int) : QuestObjective
      {
         return QuestObjective.getQuestObjectiveById(param1);
      }
      
      [Untrusted]
      public function getQuestStep(param1:int) : QuestStep
      {
         return QuestStep.getQuestStepById(param1);
      }
      
      [Untrusted]
      public function getAchievement(param1:int) : Achievement
      {
         return Achievement.getAchievementById(param1);
      }
      
      [Untrusted]
      public function getAchievements() : Array
      {
         return Achievement.getAchievements();
      }
      
      [Untrusted]
      public function getAchievementCategory(param1:int) : AchievementCategory
      {
         return AchievementCategory.getAchievementCategoryById(param1);
      }
      
      [Untrusted]
      public function getAchievementCategories() : Array
      {
         return AchievementCategory.getAchievementCategories();
      }
      
      [Untrusted]
      public function getAchievementReward(param1:int) : AchievementReward
      {
         return AchievementReward.getAchievementRewardById(param1);
      }
      
      [Untrusted]
      public function getAchievementRewards() : Array
      {
         return AchievementReward.getAchievementRewards();
      }
      
      [Untrusted]
      public function getAchievementObjective(param1:int) : AchievementObjective
      {
         return AchievementObjective.getAchievementObjectiveById(param1);
      }
      
      [Untrusted]
      public function getAchievementObjectives() : Array
      {
         return AchievementObjective.getAchievementObjectives();
      }
      
      [Untrusted]
      public function getHouse(param1:int) : House
      {
         return House.getGuildHouseById(param1);
      }
      
      [Untrusted]
      public function getLivingObjectSkins(param1:ItemWrapper) : Array
      {
         if(!param1.isLivingObject)
         {
            return [];
         }
         var _loc2_:Array = new Array();
         var _loc3_:int = 1;
         while(_loc3_ <= param1.livingObjectLevel)
         {
            _loc2_.push(LivingObjectSkinWrapper.create(!!param1.livingObjectId?int(param1.livingObjectId):int(param1.id),param1.livingObjectMood,_loc3_));
            _loc3_++;
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getAbuseReasonName(param1:uint) : AbuseReasons
      {
         return AbuseReasons.getReasonNameById(param1);
      }
      
      [Untrusted]
      public function getAllAbuseReasons() : Array
      {
         return AbuseReasons.getReasonNames();
      }
      
      [Untrusted]
      public function getPresetIcons() : Array
      {
         return PresetIcon.getPresetIcons();
      }
      
      [Untrusted]
      public function getPresetIcon(param1:uint) : PresetIcon
      {
         return PresetIcon.getPresetIconById(param1);
      }
      
      [Untrusted]
      public function getDungeons() : Array
      {
         return Dungeon.getAllDungeons();
      }
      
      [Untrusted]
      public function getDungeon(param1:uint) : Dungeon
      {
         return Dungeon.getDungeonById(param1);
      }
      
      [Untrusted]
      public function getMapInfo(param1:uint) : MapPosition
      {
         return MapPosition.getMapPositionById(param1);
      }
      
      [Untrusted]
      public function getWorldMap(param1:uint) : WorldMap
      {
         return WorldMap.getWorldMapById(param1);
      }
      
      [Untrusted]
      public function getAllWorldMaps() : Array
      {
         return WorldMap.getAllWorldMaps();
      }
      
      [Untrusted]
      public function getHintCategory(param1:uint) : HintCategory
      {
         return HintCategory.getHintCategoryById(param1);
      }
      
      [Untrusted]
      public function getHintCategories() : Array
      {
         return HintCategory.getHintCategories();
      }
      
      [Untrusted]
      public function getHousesInformations() : Dictionary
      {
         if(this.entitiesFrame)
         {
            return this.entitiesFrame.housesInformations;
         }
         return null;
      }
      
      [Untrusted]
      public function getHouseInformations(param1:uint) : HouseWrapper
      {
         if(this.entitiesFrame)
         {
            return this.entitiesFrame.housesInformations[param1];
         }
         return null;
      }
      
      [Untrusted]
      public function getSpellPair(param1:uint) : SpellPair
      {
         return SpellPair.getSpellPairById(param1);
      }
      
      [Untrusted]
      public function getBomb(param1:uint) : SpellBomb
      {
         return SpellBomb.getSpellBombById(param1);
      }
      
      [Untrusted]
      public function getPack(param1:uint) : Pack
      {
         return Pack.getPackById(param1);
      }
      
      [Untrusted]
      public function getLegendaryTreasureHunt(param1:uint) : LegendaryTreasureHunt
      {
         return LegendaryTreasureHunt.getLegendaryTreasureHuntById(param1);
      }
      
      [Untrusted]
      public function getLegendaryTreasureHunts() : Array
      {
         return LegendaryTreasureHunt.getLegendaryTreasureHunts();
      }
      
      [Untrusted]
      public function getTitle(param1:uint) : Title
      {
         return Title.getTitleById(param1);
      }
      
      [Untrusted]
      public function getTitles() : Array
      {
         return Title.getAllTitle();
      }
      
      [Untrusted]
      public function getTitleCategory(param1:uint) : TitleCategory
      {
         return TitleCategory.getTitleCategoryById(param1);
      }
      
      [Untrusted]
      public function getTitleCategories() : Array
      {
         return TitleCategory.getTitleCategories();
      }
      
      [Untrusted]
      public function getOrnament(param1:uint) : Ornament
      {
         return Ornament.getOrnamentById(param1);
      }
      
      [Untrusted]
      public function getOrnaments() : Array
      {
         return Ornament.getAllOrnaments();
      }
      
      [Untrusted]
      public function getOptionalFeatureByKeyword(param1:String) : OptionalFeature
      {
         return OptionalFeature.getOptionalFeatureByKeyword(param1);
      }
      
      [Untrusted]
      public function getEffect(param1:uint) : Effect
      {
         return Effect.getEffectById(param1);
      }
      
      [Untrusted]
      public function getAlmanaxEvent() : AlmanaxEvent
      {
         return AlmanaxManager.getInstance().event;
      }
      
      [Untrusted]
      public function getAlmanaxZodiac() : AlmanaxZodiac
      {
         return AlmanaxManager.getInstance().zodiac;
      }
      
      [Untrusted]
      public function getAlmanaxMonth() : AlmanaxMonth
      {
         return AlmanaxManager.getInstance().month;
      }
      
      [Untrusted]
      public function getAlmanaxCalendar(param1:uint) : AlmanaxCalendar
      {
         return AlmanaxCalendar.getAlmanaxCalendarById(param1);
      }
      
      [Untrusted]
      public function getExternalNotification(param1:int) : ExternalNotification
      {
         return ExternalNotification.getExternalNotificationById(param1);
      }
      
      [Untrusted]
      public function getExternalNotifications() : Array
      {
         return ExternalNotification.getExternalNotifications();
      }
      
      [Untrusted]
      public function getActionDescriptionByName(param1:String) : ActionDescription
      {
         return ActionDescription.getActionDescriptionByName(param1);
      }
      
      [Untrusted]
      public function queryString(param1:Class, param2:String, param3:String) : Vector.<uint>
      {
         return GameDataQuery.queryString(param1,param2,param3);
      }
      
      [Untrusted]
      public function queryEquals(param1:Class, param2:String, param3:*) : Vector.<uint>
      {
         return GameDataQuery.queryEquals(param1,param2,param3);
      }
      
      [Untrusted]
      public function queryUnion(... rest) : Vector.<uint>
      {
         return GameDataQuery.union.apply(null,rest);
      }
      
      [Untrusted]
      public function queryIntersection(... rest) : Vector.<uint>
      {
         return GameDataQuery.intersection.apply(null,rest);
      }
      
      [Untrusted]
      public function queryGreaterThan(param1:Class, param2:String, param3:*) : Vector.<uint>
      {
         return GameDataQuery.queryGreaterThan(param1,param2,param3);
      }
      
      [Untrusted]
      public function querySmallerThan(param1:Class, param2:String, param3:*) : Vector.<uint>
      {
         return GameDataQuery.querySmallerThan(param1,param2,param3);
      }
      
      [Untrusted]
      public function queryReturnInstance(param1:Class, param2:Vector.<uint>) : Vector.<Object>
      {
         return GameDataQuery.returnInstance(param1,param2);
      }
      
      [Untrusted]
      public function querySort(param1:Class, param2:Vector.<uint>, param3:*, param4:* = true) : Vector.<uint>
      {
         return GameDataQuery.sort(param1,param2,param3,param4);
      }
      
      [Untrusted]
      public function querySortI18nId(param1:*, param2:*, param3:* = true) : *
      {
         return GameDataQuery.sortI18n(param1,param2,param3);
      }
      
      [Untrusted]
      public function getAllZaaps() : Array
      {
         var _loc1_:Waypoint = null;
         var _loc2_:Array = new Array();
         var _loc3_:Array = Waypoint.getAllWaypoints();
         for each(_loc1_ in _loc3_)
         {
            _loc2_.push(new TeleportDestinationWrapper(0,_loc1_.mapId,_loc1_.subAreaId,0,0,false,null,false));
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getUnknowZaaps(param1:Array) : Array
      {
         var _loc2_:TeleportDestinationWrapper = null;
         var _loc3_:* = undefined;
         var _loc4_:Array = this.getAllZaaps();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc5_.push(_loc3_.coord);
         }
         for each(_loc2_ in _loc4_)
         {
            if(_loc5_.indexOf(_loc2_.coord) == -1)
            {
               _loc6_.push(_loc2_);
            }
         }
         return _loc6_;
      }
      
      [Untrusted]
      public function getAllVeteranRewards() : Array
      {
         return VeteranReward.getAllVeteranRewards();
      }
      
      [Untrusted]
      public function getIdol(param1:uint) : Idol
      {
         return Idol.getIdolById(param1);
      }
      
      [Untrusted]
      public function getIdolByItemId(param1:int) : Idol
      {
         return Idol.getIdolByItemId(param1);
      }
      
      [Untrusted]
      public function getAllIdols() : Array
      {
         return Idol.getIdols();
      }
      
      [Untrusted]
      public function getNullEffectInstance(param1:*) : *
      {
         var _loc2_:* = this.deepClone(param1);
         _loc2_.setParameter(0,0);
         _loc2_.setParameter(1,0);
         _loc2_.setParameter(2,0);
         return _loc2_;
      }
      
      [Trusted]
      private function deepClone(param1:*) : *
      {
         var _loc2_:String = getQualifiedClassName(param1);
         var _loc3_:Class = param1.constructor;
         registerClassAlias(_loc2_,_loc3_);
         var _loc4_:ByteArray;
         (_loc4_ = new ByteArray()).writeObject(param1);
         _loc4_.position = 0;
         return _loc4_.readObject() as _loc3_;
      }
   }
}
