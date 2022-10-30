package com.ankamagames.dofus.misc.stats.ui
{
   import com.ankamagames.berilia.api.ReadOnlyObject;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.messages.SelectItemMessage;
   import com.ankamagames.berilia.enums.SelectMethodEnum;
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.actions.GameContextQuitAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenInventoryAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.GuidedModeQuitRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestInfosRequestAction;
   import com.ankamagames.dofus.logic.game.common.frames.QuestFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightReadyAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightSpellCastAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.NpcDialogReplyAction;
   import com.ankamagames.dofus.misc.lists.CustomUiHookList;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.misc.lists.QuestHookList;
   import com.ankamagames.dofus.misc.lists.RoleplayHookList;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.misc.stats.StatsAction;
   import com.ankamagames.dofus.network.enums.StatisticTypeEnum;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import flash.utils.getQualifiedClassName;
   
   public class TutorialStats implements IUiStats
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(TutorialStats));
      
      private static const START_QUEST_ID:uint = 489;
       
      
      private var _init:Boolean;
      
      private var _arrivalAction:StatsAction;
      
      private var _quitAction:StatsAction;
      
      public function TutorialStats(param1:UiRootContainer)
      {
         super();
         if(!param1.getElement("ctr_joinTutorial").visible)
         {
            this.initTutorial();
         }
      }
      
      public function process(param1:Message) : void
      {
         var _loc2_:MouseClickMessage = null;
         var _loc3_:QuestInfosRequestAction = null;
         var _loc4_:OpenInventoryAction = null;
         var _loc5_:SelectItemMessage = null;
         var _loc6_:Grid = null;
         switch(true)
         {
            case param1 is MouseClickMessage:
               _loc2_ = param1 as MouseClickMessage;
               switch(_loc2_.target.name)
               {
                  case "btn_continue":
                  case "btn_closePopup":
                     this.getStepAction(1042).restart();
               }
               return;
            case param1 is QuestInfosRequestAction:
               _loc3_ = param1 as QuestInfosRequestAction;
               if(_loc3_.questId == START_QUEST_ID)
               {
                  this.initTutorial();
               }
               return;
            case param1 is GuidedModeQuitRequestAction:
               if(this._quitAction)
               {
                  this._quitAction.updateTimestamp();
                  this._quitAction.send();
               }
               this._init = false;
               return;
            case param1 is OpenInventoryAction:
               if((_loc4_ = param1 as OpenInventoryAction).behavior == "bag" && StatsAction.exists(StatisticTypeEnum.STEP0820_CLIC_BAG))
               {
                  StatsAction.get(StatisticTypeEnum.STEP0820_CLIC_BAG).send();
                  StatsAction.get(StatisticTypeEnum.STEP0840_CLIC_RING).start();
               }
               return;
            case param1 is SelectItemMessage:
               if((_loc5_ = param1 as SelectItemMessage).target is Grid)
               {
                  if((_loc6_ = _loc5_.target as Grid).selectedItem is ItemWrapper && _loc5_.selectMethod != SelectMethodEnum.AUTO && _loc6_.selectedItem.objectGID == 10785 && StatsAction.exists(StatisticTypeEnum.STEP0840_CLIC_RING))
                  {
                     StatsAction.get(StatisticTypeEnum.STEP0840_CLIC_RING).send();
                     StatsAction.get(StatisticTypeEnum.STEP0860_EQUIP_RING).start();
                  }
               }
               return;
            case param1 is GameFightReadyAction:
               if(StatsAction.exists(StatisticTypeEnum.STEP1160_CLIC_READY))
               {
                  StatsAction.get(StatisticTypeEnum.STEP1160_CLIC_READY).send();
               }
               return;
            case param1 is GameFightSpellCastAction:
               if(StatsAction.exists(StatisticTypeEnum.STEP1930_CHOSE_SPELL))
               {
                  StatsAction.get(StatisticTypeEnum.STEP1930_CHOSE_SPELL).send();
                  StatsAction.get(StatisticTypeEnum.STEP1960_USE_SPELL).start();
               }
               return;
            case param1 is GameContextQuitAction:
               if(StatsAction.exists(StatisticTypeEnum.STEP2100_TUTO10_WIN_FIGHT))
               {
                  StatsAction.get(StatisticTypeEnum.STEP2050_TUTO10_LOSE_FIGHT).start();
                  StatsAction.get(StatisticTypeEnum.STEP2050_TUTO10_LOSE_FIGHT).send();
               }
               return;
            case param1 is NpcDialogReplyAction:
               if(StatsAction.exists(StatisticTypeEnum.STEP2260_ACCEPT_MISSION))
               {
                  StatsAction.get(StatisticTypeEnum.STEP2260_ACCEPT_MISSION).send();
               }
               else if(StatsAction.exists(StatisticTypeEnum.STEP2640_END_DIALOG))
               {
                  StatsAction.get(StatisticTypeEnum.STEP2640_END_DIALOG).send();
               }
               return;
            default:
               return;
         }
      }
      
      public function onHook(param1:Hook, param2:Array) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:ItemWrapper = null;
         var _loc5_:ReadOnlyObject = null;
         var _loc6_:QuestFrame = null;
         var _loc7_:Object = null;
         var _loc8_:Quest = null;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         switch(param1.name)
         {
            case QuestHookList.QuestInfosUpdated.name:
               if(param2[0] == START_QUEST_ID && param2[1] == true)
               {
                  _loc7_ = (_loc6_ = Kernel.getWorker().getFrame(QuestFrame) as QuestFrame).getQuestInformations(START_QUEST_ID);
                  this.getStepAction(_loc7_.stepId).start();
                  this.startSubSteps(_loc7_.stepId);
               }
               return;
            case QuestHookList.QuestStepValidated.name:
               _loc3_ = param2[1];
               if(param2[0] == START_QUEST_ID)
               {
                  this.getStepAction(_loc3_).send();
                  if(_loc3_ == 1046)
                  {
                     this.getStepAction(1051).start();
                  }
                  if(_loc3_ == 1060)
                  {
                     StatsAction.get(StatisticTypeEnum.STEP2350_EXIT_BAG).start();
                  }
                  _loc11_ = (_loc8_ = Quest.getQuestById(param2[0])).stepIds.length;
                  _loc10_ = 0;
                  while(_loc10_ < _loc11_)
                  {
                     if(_loc8_.stepIds[_loc10_] == _loc3_)
                     {
                        break;
                     }
                     _loc10_++;
                  }
                  if(_loc10_ + 1 < _loc11_)
                  {
                     _loc12_ = _loc8_.stepIds[_loc10_ + 1];
                     this.getStepAction(_loc12_).start();
                     this.startSubSteps(_loc12_);
                  }
               }
               return;
            case QuestHookList.QuestValidated.name:
               if(param2[0] == START_QUEST_ID)
               {
                  this.getStepAction(1059).send();
               }
               return;
            case InventoryHookList.EquipmentObjectMove.name:
               if((_loc4_ = param2[0]) && _loc4_.objectGID == 10785 && StatsAction.exists(StatisticTypeEnum.STEP0860_EQUIP_RING))
               {
                  StatsAction.get(StatisticTypeEnum.STEP0860_EQUIP_RING).send();
                  StatsAction.get(StatisticTypeEnum.STEP0860_EXIT_BAG).start();
               }
               return;
            case BeriliaHookList.UiUnloaded.name:
               if(param2[0] == "storage")
               {
                  if(StatsAction.exists(StatisticTypeEnum.STEP0860_EXIT_BAG))
                  {
                     StatsAction.get(StatisticTypeEnum.STEP0860_EXIT_BAG).send();
                  }
                  else if(StatsAction.exists(StatisticTypeEnum.STEP2350_EXIT_BAG))
                  {
                     StatsAction.get(StatisticTypeEnum.STEP2350_EXIT_BAG).send();
                  }
               }
               return;
            case FightHookList.GameEntityDisposition.name:
               if(param2[0] == PlayedCharacterManager.getInstance().id)
               {
                  if(StatsAction.exists(StatisticTypeEnum.STEP1130_CHOSE_POSITION))
                  {
                     StatsAction.get(StatisticTypeEnum.STEP1130_CHOSE_POSITION).send();
                     StatsAction.get(StatisticTypeEnum.STEP1160_CLIC_READY).start();
                  }
                  else if(StatsAction.exists(StatisticTypeEnum.STEP1100_TUTO6_CHOSE_START_POSITION))
                  {
                     StatsAction.get(StatisticTypeEnum.STEP1130_CHOSE_POSITION).start();
                     StatsAction.get(StatisticTypeEnum.STEP1130_CHOSE_POSITION).send();
                  }
               }
               return;
            case TriggerHookList.FightSpellCast.name:
               if(StatsAction.exists(StatisticTypeEnum.STEP1960_USE_SPELL))
               {
                  StatsAction.get(StatisticTypeEnum.STEP1960_USE_SPELL).send();
               }
               return;
            case CustomUiHookList.OpeningContextMenu.name:
               if(param2[0].makerName != "player" && StatsAction.exists(StatisticTypeEnum.STEP2220_CLIC_YAKASI))
               {
                  StatsAction.get(StatisticTypeEnum.STEP2220_CLIC_YAKASI).send();
                  StatsAction.get(StatisticTypeEnum.STEP2240_TALK_YAKASI).start();
               }
               else if(param2[0].makerName != "player" && StatsAction.exists(StatisticTypeEnum.STEP2620_CLIC_YAKASI))
               {
                  StatsAction.get(StatisticTypeEnum.STEP2620_CLIC_YAKASI).send();
                  StatsAction.get(StatisticTypeEnum.STEP2640_END_DIALOG).start();
               }
               return;
            case RoleplayHookList.NpcDialogCreation.name:
               if(StatsAction.exists(StatisticTypeEnum.STEP2240_TALK_YAKASI))
               {
                  StatsAction.get(StatisticTypeEnum.STEP2240_TALK_YAKASI).send();
                  StatsAction.get(StatisticTypeEnum.STEP2260_ACCEPT_MISSION).start();
               }
               return;
            case BeriliaHookList.MouseClick.name:
               if((_loc5_ = param2[0] as ReadOnlyObject) && _loc5_.simplyfiedQualifiedClassName == "FrustumShape" && StatsAction.exists(StatisticTypeEnum.STEP2430_GO_TO_NEXT_MAP))
               {
                  StatsAction.get(StatisticTypeEnum.STEP2430_GO_TO_NEXT_MAP).send();
                  StatsAction.get(StatisticTypeEnum.STEP2460_CLIC_MONSTER).start();
               }
               else if(_loc5_ && _loc5_.simplyfiedQualifiedClassName == "AnimatedCharacter" && param2[0].id != PlayedCharacterManager.getInstance().id)
               {
                  if(StatsAction.exists(StatisticTypeEnum.STEP2460_CLIC_MONSTER))
                  {
                     StatsAction.get(StatisticTypeEnum.STEP2460_CLIC_MONSTER).send();
                  }
               }
               return;
            default:
               return;
         }
      }
      
      private function initTutorial() : void
      {
         if(!this._init)
         {
            this._arrivalAction = StatsAction.get(StatisticTypeEnum.STEP0500_ARRIVES_ON_TUTORIAL);
            this._arrivalAction.start();
            this._arrivalAction.send();
            this._quitAction = StatsAction.get(StatisticTypeEnum.STEP0550_QUITS_TUTORIAL);
            this._quitAction.start();
            this.getStepAction(1059).start();
            this._init = true;
         }
      }
      
      private function getStepAction(param1:uint) : StatsAction
      {
         var _loc2_:StatsAction = null;
         switch(param1)
         {
            case 1042:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP0600_TUTO1_MOVE_MAP,true);
               break;
            case 1043:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP0700_TUTO2_TALK_TO_YAKASI,true);
               break;
            case 1044:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP0800_TUTO3_EQUIP_RING,true);
               break;
            case 1045:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP0900_TUTO4_CHANGE_MAP,true);
               break;
            case 1046:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP1000_TUTO5_START_FIRST_FIGHT,true);
               break;
            case 1047:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP1100_TUTO6_CHOSE_START_POSITION,true);
               break;
            case 1048:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP1200_TUTO7_MOVE_IN_FIGHT,true);
               break;
            case 1049:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP1900_TUTO8_USE_SPELL,true);
               break;
            case 1050:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP2000_TUTO9_END_TURN,true);
               break;
            case 1051:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP2100_TUTO10_WIN_FIGHT,true);
               break;
            case 1052:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP2200_TUTO11_START_FIRST_QUEST,true);
               break;
            case 1060:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP2300_TUTO12_EQUIP_SET,true);
               break;
            case 1053:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP2400_TUTO13_LETS_KILL_MONSTER,true);
               break;
            case 1061:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP2500_TUTO14_END_SECOND_FIGHT,true);
               break;
            case 1059:
               _loc2_ = StatsAction.get(StatisticTypeEnum.STEP2600_TUTO15_END_TUTO,true);
         }
         return _loc2_;
      }
      
      private function startSubSteps(param1:uint) : void
      {
         switch(param1)
         {
            case 1044:
               StatsAction.get(StatisticTypeEnum.STEP0820_CLIC_BAG).start();
               return;
            case 1047:
               StatsAction.get(StatisticTypeEnum.STEP1130_CHOSE_POSITION).start();
               return;
            case 1049:
               StatsAction.get(StatisticTypeEnum.STEP1930_CHOSE_SPELL).start();
               return;
            case 1052:
               StatsAction.get(StatisticTypeEnum.STEP2220_CLIC_YAKASI).start();
               return;
            case 1053:
               StatsAction.get(StatisticTypeEnum.STEP2430_GO_TO_NEXT_MAP).start();
               return;
            case 1059:
               StatsAction.get(StatisticTypeEnum.STEP2620_CLIC_YAKASI).start();
               return;
            default:
               return;
         }
      }
      
      public function remove() : void
      {
      }
   }
}
