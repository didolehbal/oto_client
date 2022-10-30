package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.berilia.managers.CssManager;
   import com.ankamagames.berilia.types.data.ExtendedStyleSheet;
   import com.ankamagames.dofus.datacenter.appearance.Ornament;
   import com.ankamagames.dofus.datacenter.appearance.Title;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayHumanoidInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionOrnament;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionTitle;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Callback;
   import flash.utils.getQualifiedClassName;
   
   public class CharacterTooltipInformation
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CharacterTooltipInformation));
       
      
      private var _cssUri:String;
      
      public var infos:GameRolePlayHumanoidInformations;
      
      public var wingsEffect:int;
      
      public var titleName:String;
      
      public var titleColor:String;
      
      public var ornamentAssetId:int;
      
      public function CharacterTooltipInformation(param1:GameRolePlayHumanoidInformations, param2:int)
      {
         var _loc3_:GameRolePlayCharacterInformations = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:Title = null;
         var _loc9_:Ornament = null;
         this._cssUri = XmlConfig.getInstance().getEntry("config.ui.skin") + "css/tooltip_title.css";
         super();
         this.infos = param1;
         this.wingsEffect = param2;
         if(param1 is GameRolePlayCharacterInformations)
         {
            _loc3_ = param1 as GameRolePlayCharacterInformations;
            CssManager.getInstance().askCss(this._cssUri,new Callback(this.onCssLoaded));
            for each(_loc7_ in param1.humanoidInfo.options)
            {
               if(_loc7_ is HumanOptionTitle)
               {
                  _loc4_ = _loc7_.titleId;
                  _loc5_ = _loc7_.titleParam;
               }
               if(_loc7_ is HumanOptionOrnament)
               {
                  _loc6_ = _loc7_.ornamentId;
               }
            }
            if(_loc4_)
            {
               if(_loc8_ = Title.getTitleById(_loc4_))
               {
                  if(param1.humanoidInfo.sex == 0)
                  {
                     this.titleName = "« " + _loc8_.nameMale + " »";
                  }
                  else
                  {
                     this.titleName = "« " + _loc8_.nameFemale + " »";
                  }
                  if(_loc5_)
                  {
                     this.titleName = this.titleName.split("%1").join(_loc5_);
                  }
               }
            }
            if(_loc6_)
            {
               _loc9_ = Ornament.getOrnamentById(_loc6_);
               this.ornamentAssetId = _loc9_.assetId;
            }
         }
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
