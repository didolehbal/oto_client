package com.ankamagames.dofus.logic.common.managers
{
   import avmplus.getQualifiedClassName;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.ChatAutocompleteNameManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.geom.Rectangle;
   
   public class HyperlinkShowPlayerMenuManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HyperlinkShowPlayerMenuManager));
       
      
      public function HyperlinkShowPlayerMenuManager()
      {
         super();
      }
      
      public static function showPlayerMenu(param1:String, param2:int = 0, param3:Number = 0, param4:String = null, param5:uint = 0) : void
      {
         var _loc6_:GameRolePlayCharacterInformations = null;
         if(param1)
         {
            param1 = unescape(param1);
         }
         var _loc7_:Object = UiModuleManager.getInstance().getModule("Ankama_ContextMenu").mainClass;
         if(param1 && param1.indexOf("★") == 0)
         {
            param1 = param1.substr(1);
         }
         var _loc8_:RoleplayEntitiesFrame;
         if((_loc8_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame) && param2)
         {
            if(!(_loc6_ = _loc8_.getEntityInfos(param2) as GameRolePlayCharacterInformations))
            {
               (_loc6_ = new GameRolePlayCharacterInformations()).contextualId = param2;
               _loc6_.name = param1;
            }
            _loc7_.createContextMenu(MenusFactory.create(_loc6_,null,[{
               "id":param2,
               "fingerprint":param4,
               "timestamp":param3,
               "chan":param5
            }]));
         }
         else
         {
            _loc7_.createContextMenu(MenusFactory.create(param1));
         }
      }
      
      public static function getPlayerName(param1:String, param2:int = 0, param3:Number = 0, param4:String = null, param5:uint = 0) : String
      {
         var _loc6_:int = 0;
         switch(param5)
         {
            case ChatActivableChannelsEnum.CHANNEL_TEAM:
            case ChatActivableChannelsEnum.CHANNEL_GUILD:
            case ChatActivableChannelsEnum.CHANNEL_PARTY:
            case ChatActivableChannelsEnum.CHANNEL_ARENA:
            case ChatActivableChannelsEnum.CHANNEL_ADMIN:
               _loc6_ = 3;
               break;
            case ChatActivableChannelsEnum.PSEUDO_CHANNEL_PRIVATE:
               _loc6_ = 4;
               break;
            default:
               _loc6_ = 1;
         }
         if(param1 && param1.indexOf("★") == 0)
         {
            param1 = param1.substr(1);
         }
         ChatAutocompleteNameManager.getInstance().addEntry(param1,_loc6_);
         return param1;
      }
      
      public static function rollOverPlayer(param1:int, param2:int, param3:String, param4:int = 0, param5:Number = 0, param6:String = null, param7:uint = 0) : void
      {
         var _loc8_:Rectangle = new Rectangle(param1,param2,10,10);
         var _loc9_:TextTooltipInfo = new TextTooltipInfo(I18n.getUiText("ui.tooltip.chat.player"));
         TooltipManager.show(_loc9_,_loc8_,UiModuleManager.getInstance().getModule("Ankama_GameUiCore"),false,"HyperLink",6,2,3,true,null,null,null,null,false,StrataEnum.STRATA_TOOLTIP,1);
      }
   }
}
