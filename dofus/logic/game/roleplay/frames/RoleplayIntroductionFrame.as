package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesDisplayManager;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.messages.MapLoadedMessage;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.types.event.UiUnloadEvent;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataMessage;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.messages.RegisteringFrame;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class RoleplayIntroductionFrame extends RegisteringFrame
   {
      
      private static const START_MAP_ID:uint = 152305664;
      
      private static const START_CELL_ID:uint = 342;
      
      private static const CINEMATIC_UI_NAME:String = "cinematic";
       
      
      private var _spawnEntity:AnimatedCharacter;
      
      public function RoleplayIntroductionFrame()
      {
         super();
      }
      
      override protected function registerMessages() : void
      {
         register(MapLoadedMessage,this.onMapLoaded);
         register(MapComplementaryInformationsDataMessage,this.onMapData);
      }
      
      private function onMapLoaded(param1:MapLoadedMessage) : Boolean
      {
         if(param1.id != START_MAP_ID)
         {
            Kernel.getWorker().removeFrame(this);
            return false;
         }
         KernelEventsManager.getInstance().processCallback(HookList.IntroductionCinematicStart);
         Atouin.getInstance().rootContainer.mouseChildren = false;
         Atouin.getInstance().rootContainer.mouseEnabled = false;
         if(Berilia.getInstance().isUiDisplayed(CINEMATIC_UI_NAME))
         {
            this.initSprite(true);
            Berilia.getInstance().addEventListener(UiUnloadEvent.UNLOAD_UI_COMPLETE,this.onUiUnloaded);
         }
         else
         {
            this.initSprite(false);
         }
         return false;
      }
      
      private function onMapData(param1:MapComplementaryInformationsDataMessage) : Boolean
      {
         this.setPlayerVisibility(false);
         return false;
      }
      
      private function initSprite(param1:Boolean) : void
      {
         this._spawnEntity = new AnimatedCharacter(EntitiesManager.getInstance().getFreeEntityId(),TiphonEntityLook.fromString("{3440}"));
         this._spawnEntity.addEventListener(TiphonEvent.ANIMATION_END,this.onSpawnAnimEnd);
         this._spawnEntity.addEventListener(TiphonEvent.ANIMATION_SHOT,this.onSpawnAnimShot);
         if(param1)
         {
            this._spawnEntity.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onSpawnEntityRendered);
         }
         this._spawnEntity.setAnimationAndDirection("FX",0);
         EntitiesDisplayManager.getInstance().displayEntity(this._spawnEntity,MapPoint.fromCellId(START_CELL_ID),PlacementStrataEnums.STRATA_NO_Z_ORDER);
      }
      
      private function setPlayerVisibility(param1:Boolean) : void
      {
         var _loc2_:DisplayObject = EntitiesManager.getInstance().getEntity(PlayedCharacterManager.getInstance().id) as DisplayObject;
         if(_loc2_ != null)
         {
            _loc2_.visible = param1;
         }
      }
      
      protected function onSpawnAnimShot(param1:Event) : void
      {
         this.setPlayerVisibility(true);
      }
      
      protected function onSpawnAnimEnd(param1:Event) : void
      {
         this.setPlayerVisibility(true);
         EntitiesDisplayManager.getInstance().removeEntity(this._spawnEntity);
         this._spawnEntity.removeEventListener(TiphonEvent.ANIMATION_END,this.onSpawnAnimEnd);
         Atouin.getInstance().rootContainer.mouseChildren = true;
         Atouin.getInstance().rootContainer.mouseEnabled = true;
         KernelEventsManager.getInstance().processCallback(HookList.IntroductionCinematicEnd);
      }
      
      protected function onSpawnEntityRendered(param1:Event) : void
      {
         this._spawnEntity.stopAnimation(1);
      }
      
      protected function onUiUnloaded(param1:UiUnloadEvent) : void
      {
         if(param1.name != CINEMATIC_UI_NAME)
         {
            return;
         }
         this._spawnEntity.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onSpawnEntityRendered);
         this._spawnEntity.restartAnimation();
      }
   }
}
