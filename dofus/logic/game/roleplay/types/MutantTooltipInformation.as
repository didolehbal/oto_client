package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.berilia.managers.CssManager;
   import com.ankamagames.berilia.types.data.ExtendedStyleSheet;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMutantInformations;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class MutantTooltipInformation
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MutantTooltipInformation));
       
      
      private var _cssUri:String;
      
      public var infos:GameRolePlayMutantInformations;
      
      public var wingsEffect:int;
      
      public var titleName:String;
      
      public var titleColor:String;
      
      public function MutantTooltipInformation(param1:GameRolePlayMutantInformations)
      {
         this._cssUri = XmlConfig.getInstance().getEntry("config.ui.skin") + "css/tooltip_title.css";
         super();
         this.infos = param1;
      }
      
      private function onCssLoaded() : void
      {
         var _loc1_:Object = null;
         var _loc2_:ExtendedStyleSheet = CssManager.getInstance().getCss(this._cssUri);
         _loc1_ = _loc2_.getStyle("itemset");
         this.titleColor = _loc1_["color"];
      }
   }
}
