package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.data.I18n;
   import flash.geom.Rectangle;
   
   public class HyperlinkShowQuestManager
   {
      
      private static var _questList:Array = new Array();
      
      private static var _questId:uint = 0;
       
      
      public function HyperlinkShowQuestManager()
      {
         super();
      }
      
      public static function showQuest(param1:uint) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Quest = Quest.getQuestById(_questList[param1].id);
         if(_loc3_)
         {
            _loc2_ = new Object();
            _loc2_.quest = _loc3_;
            _loc2_.forceOpen = true;
            KernelEventsManager.getInstance().processCallback(HookList.OpenBook,"questTab",_loc2_);
         }
      }
      
      public static function addQuest(param1:uint) : String
      {
         var _loc2_:* = null;
         var _loc3_:Quest = Quest.getQuestById(param1);
         if(_loc3_)
         {
            _questList[_questId] = _loc3_;
            _loc2_ = "{chatquest," + _questId + "::[" + _loc3_.name + "]}";
            ++_questId;
            return _loc2_;
         }
         return "[null]";
      }
      
      public static function rollOver(param1:int, param2:int, param3:uint, param4:uint = 0) : void
      {
         var _loc5_:Rectangle = new Rectangle(param1,param2,10,10);
         var _loc6_:TextTooltipInfo = new TextTooltipInfo(I18n.getUiText("ui.tooltip.chat.quest"));
         TooltipManager.show(_loc6_,_loc5_,UiModuleManager.getInstance().getModule("Ankama_GameUiCore"),false,"HyperLink",6,2,3,true,null,null,null,null,false,StrataEnum.STRATA_TOOLTIP,1);
      }
   }
}
