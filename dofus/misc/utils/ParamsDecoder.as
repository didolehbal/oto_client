package com.ankamagames.dofus.misc.utils
{
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   import com.ankamagames.dofus.datacenter.appearance.Ornament;
   import com.ankamagames.dofus.datacenter.appearance.Title;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.challenges.Challenge;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.monsters.MonsterRace;
   import com.ankamagames.dofus.datacenter.monsters.MonsterSuperRace;
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.datacenter.world.Dungeon;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkItemManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowAchievementManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowOrnamentManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowQuestManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowTitleManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.getQualifiedClassName;
   
   public class ParamsDecoder
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ParamsDecoder));
       
      
      public function ParamsDecoder()
      {
         super();
      }
      
      public static function applyParams(param1:String, param2:Array, param3:String = "%") : String
      {
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc10_:uint = 0;
         var _loc7_:* = "";
         var _loc8_:* = "";
         var _loc9_:* = "";
         while(_loc10_ < param1.length)
         {
            if((_loc4_ = param1.charAt(_loc10_)) == "$")
            {
               _loc5_ = true;
            }
            else if(_loc4_ == param3)
            {
               if(_loc10_ + 1 < param1.length && param1.charAt(_loc10_ + 1) == param3)
               {
                  _loc6_ = false;
                  _loc5_ = false;
                  _loc10_++;
               }
               else
               {
                  _loc5_ = false;
                  _loc6_ = true;
               }
            }
            if(_loc5_)
            {
               _loc7_ = _loc7_ + _loc4_;
            }
            else if(_loc6_)
            {
               if(_loc4_ == param3)
               {
                  if(_loc8_.length == 0)
                  {
                     _loc8_ = _loc8_ + _loc4_;
                  }
                  else
                  {
                     _loc9_ = _loc9_ + processReplace(_loc7_,_loc8_,param2);
                     _loc7_ = "";
                     _loc8_ = "" + _loc4_;
                  }
               }
               else if(_loc4_ >= "0" && _loc4_ <= "9")
               {
                  _loc8_ = _loc8_ + _loc4_;
                  if(_loc10_ + 1 == param1.length)
                  {
                     _loc6_ = false;
                     _loc9_ = _loc9_ + processReplace(_loc7_,_loc8_,param2);
                     _loc7_ = "";
                     _loc8_ = "";
                  }
               }
               else
               {
                  _loc6_ = false;
                  _loc9_ = _loc9_ + processReplace(_loc7_,_loc8_,param2);
                  _loc7_ = "";
                  _loc8_ = "";
                  _loc9_ = _loc9_ + _loc4_;
               }
            }
            else
            {
               if(_loc8_ != "")
               {
                  _loc9_ = _loc9_ + processReplace(_loc7_,_loc8_,param2);
                  _loc7_ = "";
                  _loc8_ = "";
               }
               _loc9_ = _loc9_ + _loc4_;
            }
            _loc10_++;
         }
         return _loc9_;
      }
      
      private static function processReplace(param1:String, param2:String, param3:Array) : String
      {
         var _loc4_:int = 0;
         var _loc5_:Item = null;
         var _loc6_:ItemType = null;
         var _loc7_:Job = null;
         var _loc8_:Quest = null;
         var _loc9_:Achievement = null;
         var _loc10_:Title = null;
         var _loc11_:Ornament = null;
         var _loc12_:Spell = null;
         var _loc13_:SpellState = null;
         var _loc14_:Breed = null;
         var _loc15_:Area = null;
         var _loc16_:SubArea = null;
         var _loc17_:MapPosition = null;
         var _loc18_:Emoticon = null;
         var _loc19_:Monster = null;
         var _loc20_:MonsterRace = null;
         var _loc21_:MonsterSuperRace = null;
         var _loc22_:Challenge = null;
         var _loc23_:AlignmentSide = null;
         var _loc24_:Array = null;
         var _loc25_:Dungeon = null;
         var _loc26_:Date = null;
         var _loc27_:uint = 0;
         var _loc28_:Companion = null;
         var _loc29_:ItemWrapper = null;
         var _loc30_:* = "";
         _loc4_ = int(Number(param2.substr(1))) - 1;
         if(param1 == "")
         {
            _loc30_ = param3[_loc4_];
         }
         else
         {
            switch(param1)
            {
               case "$item":
                  if(_loc5_ = Item.getItemById(param3[_loc4_]))
                  {
                     _loc29_ = ItemWrapper.create(0,0,param3[_loc4_],0,null,false);
                     _loc30_ = HyperlinkItemManager.newChatItem(_loc29_);
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$itemType":
                  if(_loc6_ = ItemType.getItemTypeById(param3[_loc4_]))
                  {
                     _loc30_ = _loc6_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$quantity":
                  _loc30_ = StringUtils.formateIntToString(int(param3[_loc4_]));
                  break;
               case "$job":
                  if(_loc7_ = Job.getJobById(param3[_loc4_]))
                  {
                     _loc30_ = _loc7_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$quest":
                  if(_loc8_ = Quest.getQuestById(param3[_loc4_]))
                  {
                     _loc30_ = HyperlinkShowQuestManager.addQuest(_loc8_.id);
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$achievement":
                  if(_loc9_ = Achievement.getAchievementById(param3[_loc4_]))
                  {
                     _loc30_ = HyperlinkShowAchievementManager.addAchievement(_loc9_.id);
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$title":
                  if(_loc10_ = Title.getTitleById(param3[_loc4_]))
                  {
                     _loc30_ = HyperlinkShowTitleManager.addTitle(_loc10_.id);
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$ornament":
                  if(_loc11_ = Ornament.getOrnamentById(param3[_loc4_]))
                  {
                     _loc30_ = HyperlinkShowOrnamentManager.addOrnament(_loc11_.id);
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$spell":
                  if(_loc12_ = Spell.getSpellById(param3[_loc4_]))
                  {
                     _loc30_ = _loc12_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$spellState":
                  if(_loc13_ = SpellState.getSpellStateById(param3[_loc4_]))
                  {
                     _loc30_ = _loc13_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$breed":
                  if(_loc14_ = Breed.getBreedById(param3[_loc4_]))
                  {
                     _loc30_ = _loc14_.shortName;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$area":
                  if(_loc15_ = Area.getAreaById(param3[_loc4_]))
                  {
                     _loc30_ = _loc15_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$subarea":
                  if(_loc16_ = SubArea.getSubAreaById(param3[_loc4_]))
                  {
                     _loc30_ = "{subArea," + param3[_loc4_] + "}";
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$map":
                  if(_loc17_ = MapPosition.getMapPositionById(param3[_loc4_]))
                  {
                     if(_loc17_.name)
                     {
                        _loc30_ = _loc17_.name;
                     }
                     else
                     {
                        _loc30_ = "{map," + int(_loc17_.posX) + "," + int(_loc17_.posY) + "," + int(_loc17_.worldMap) + "}";
                     }
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$emote":
                  if(_loc18_ = Emoticon.getEmoticonById(param3[_loc4_]))
                  {
                     _loc30_ = _loc18_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$monster":
                  if(_loc19_ = Monster.getMonsterById(param3[_loc4_]))
                  {
                     _loc30_ = _loc19_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$monsterRace":
                  if(_loc20_ = MonsterRace.getMonsterRaceById(param3[_loc4_]))
                  {
                     _loc30_ = _loc20_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$monsterSuperRace":
                  if(_loc21_ = MonsterSuperRace.getMonsterSuperRaceById(param3[_loc4_]))
                  {
                     _loc30_ = _loc21_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$challenge":
                  if(_loc22_ = Challenge.getChallengeById(param3[_loc4_]))
                  {
                     _loc30_ = _loc22_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$alignment":
                  if(_loc23_ = AlignmentSide.getAlignmentSideById(param3[_loc4_]))
                  {
                     _loc30_ = _loc23_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$stat":
                  if((_loc24_ = I18n.getUiText("ui.item.characteristics").split(","))[param3[_loc4_]])
                  {
                     _loc30_ = _loc24_[param3[_loc4_]];
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$dungeon":
                  if(_loc25_ = Dungeon.getDungeonById(param3[_loc4_]))
                  {
                     _loc30_ = _loc25_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
                  break;
               case "$time":
                  _loc26_ = new Date();
                  _loc27_ = param3[_loc4_] * 1000 - _loc26_.time;
                  _loc30_ = TimeManager.getInstance().getDuration(_loc27_);
                  break;
               case "$companion":
               case "$sidekick":
                  if(_loc28_ = Companion.getCompanionById(param3[_loc4_]))
                  {
                     _loc30_ = _loc28_.name;
                  }
                  else
                  {
                     _log.error(param1 + " " + param3[_loc4_] + " introuvable");
                     _loc30_ = "";
                  }
            }
         }
         return _loc30_;
      }
   }
}
