package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.EntitiesLooksManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightPreparationFrame;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.display.DisplayObject;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SwapPositionRequest
   {
       
      
      private var _instanceName:String;
      
      private var _icon:UiRootContainer;
      
      private var _timelineInstanceName:String;
      
      private var _timelineIcon:UiRootContainer;
      
      private var _isRequesterIcon:Boolean;
      
      public var requestId:uint;
      
      public var requesterId:int;
      
      public var requestedId:int;
      
      public function SwapPositionRequest(param1:uint, param2:int, param3:int)
      {
         super();
         this.requestId = param1;
         this.requesterId = param2;
         this.requestedId = param3;
         this._instanceName = "swapPositionRequest#" + param1;
         this._timelineInstanceName = "timeline_" + this._instanceName;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._timelineIcon.visible = param1;
      }
      
      public function destroy() : void
      {
         Berilia.getInstance().unloadUi(this._instanceName);
         Berilia.getInstance().unloadUi(this._timelineInstanceName);
         var _loc1_:FightPreparationFrame = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame;
         if(_loc1_)
         {
            _loc1_.removeSwapPositionRequest(this.requestId);
         }
      }
      
      public function showRequesterIcon() : void
      {
         this._isRequesterIcon = true;
         this.showIcon();
      }
      
      public function showRequestedIcon() : void
      {
         this._isRequesterIcon = false;
         this.showIcon();
      }
      
      public function updateIcon() : void
      {
         var _loc1_:AnimatedCharacter = DofusEntities.getEntity(!!this._isRequesterIcon?int(this.requesterId):int(this.requestedId)) as AnimatedCharacter;
         if(this._icon.scale != Atouin.getInstance().currentZoom)
         {
            this._icon.scale = Atouin.getInstance().currentZoom;
         }
         this.placeIcon(_loc1_);
         this.placeTimelineIcon(_loc1_);
      }
      
      private function showIcon() : void
      {
         var _loc2_:UiModule = null;
         var _loc1_:int = !!this._isRequesterIcon?int(this.requesterId):int(this.requestedId);
         _loc2_ = UiModuleManager.getInstance().getModule("Ankama_Fight");
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(_loc1_) as AnimatedCharacter;
         this._icon = Berilia.getInstance().loadUi(_loc2_,_loc2_.uis["swapPositionIcon"],this._instanceName,{
            "requestId":this.requestId,
            "isRequester":this._isRequesterIcon,
            "entityId":_loc1_,
            "rollEvents":false
         },false);
         this._icon.filters = [new GlowFilter(0,1,2,2,2,1)];
         this.placeIcon(_loc3_);
         this._timelineIcon = Berilia.getInstance().loadUi(_loc2_,_loc2_.uis["swapPositionIcon"],this._timelineInstanceName,{
            "requestId":this.requestId,
            "isRequester":this._isRequesterIcon,
            "entityId":_loc1_,
            "rollEvents":true
         },false);
         this.placeTimelineIcon(_loc3_);
      }
      
      private function placeIcon(param1:AnimatedCharacter) : void
      {
         var _loc2_:IRectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Rectangle2 = null;
         var _loc5_:Number = NaN;
         var _loc6_:Point = null;
         var _loc7_:TiphonSprite;
         if((_loc7_ = param1 as TiphonSprite).getSubEntitySlot(2,0) && !EntitiesLooksManager.getInstance().isCreatureMode())
         {
            _loc7_ = _loc7_.getSubEntitySlot(2,0) as TiphonSprite;
         }
         var _loc8_:DisplayObject = _loc7_.getSlot("Tete");
         var _loc9_:DisplayObject = _loc7_.getBackground("readySwords");
         if(_loc8_ && !_loc9_)
         {
            _loc3_ = _loc8_.getBounds(StageShareManager.stage);
            _loc2_ = _loc4_ = new Rectangle2(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
         }
         else if(!_loc9_)
         {
            _loc2_ = (_loc7_ as IDisplayable).absoluteBounds;
         }
         else
         {
            _loc3_ = _loc9_.getBounds(StageShareManager.stage);
            _loc2_ = _loc4_ = new Rectangle2(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
         }
         if(_loc2_)
         {
            _loc5_ = !!TooltipManager.isVisible("tooltipOverEntity_" + param1.id)?Number(70):Number(10);
            _loc6_ = new Point(_loc2_.x + _loc2_.width / 2,_loc2_.y - _loc5_);
            this._icon.x = _loc6_.x;
            this._icon.y = _loc6_.y;
         }
      }
      
      private function placeTimelineIcon(param1:AnimatedCharacter) : void
      {
         var _loc2_:UiRootContainer = Berilia.getInstance().getUi("timeline");
         var _loc3_:Object = _loc2_.uiClass.getFighterById(param1.id).frame;
         var _loc4_:Point = _loc3_.getParent().localToGlobal(new Point(_loc3_.x,_loc3_.y));
         this._timelineIcon.x = _loc4_.x + 20;
         this._timelineIcon.y = _loc4_.y - 6;
      }
   }
}
