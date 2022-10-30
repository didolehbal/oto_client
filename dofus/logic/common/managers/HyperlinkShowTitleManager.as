package com.ankamagames.dofus.logic.common.managers
{
   import avmplus.getQualifiedClassName;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.dofus.datacenter.appearance.Title;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.geom.Rectangle;
   
   public class HyperlinkShowTitleManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HyperlinkShowTitleManager));
      
      private static var _titleList:Array = new Array();
      
      private static var _titleId:uint = 0;
       
      
      public function HyperlinkShowTitleManager()
      {
         super();
      }
      
      public static function showTitle(param1:uint) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.id = _titleList[param1].id;
         _loc2_.idIsTitle = true;
         _loc2_.forceOpen = true;
         KernelEventsManager.getInstance().processCallback(HookList.OpenBook,"titleTab",_loc2_);
      }
      
      public static function addTitle(param1:uint) : String
      {
         var _loc2_:* = null;
         var _loc3_:Title = Title.getTitleById(param1);
         if(_loc3_)
         {
            _titleList[_titleId] = _loc3_;
            _loc2_ = "{chattitle," + _titleId + "::[" + _loc3_.name + "]}";
            ++_titleId;
            return _loc2_;
         }
         return "[null]";
      }
      
      public static function rollOver(param1:int, param2:int, param3:uint, param4:uint = 0) : void
      {
         var _loc5_:Rectangle = new Rectangle(param1,param2,10,10);
         var _loc6_:TextTooltipInfo = new TextTooltipInfo(I18n.getUiText("ui.tooltip.chat.title"));
         TooltipManager.show(_loc6_,_loc5_,UiModuleManager.getInstance().getModule("Ankama_GameUiCore"),false,"HyperLink",6,2,3,true,null,null,null,null,false,StrataEnum.STRATA_TOOLTIP,1);
      }
   }
}
