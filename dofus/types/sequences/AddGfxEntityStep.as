package com.ankamagames.dofus.types.sequences
{
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.dofus.types.entities.Projectile;
   import com.ankamagames.jerakine.enum.AddGfxModeEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.getQualifiedClassName;
   
   public class AddGfxEntityStep extends AbstractSequencable
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AddGfxEntityStep));
       
      
      private var _gfxId:uint;
      
      private var _cellId:uint;
      
      private var _entity:Projectile;
      
      private var _shot:Boolean = false;
      
      private var _angle:Number;
      
      private var _yOffset:int;
      
      private var _mode:uint;
      
      private var _startCell:MapPoint;
      
      private var _endCell:MapPoint;
      
      private var _popUnderPlayer:Boolean;
      
      public function AddGfxEntityStep(param1:uint, param2:uint, param3:Number = 0, param4:int = 0, param5:uint = 0, param6:MapPoint = null, param7:MapPoint = null, param8:Boolean = false)
      {
         super();
         this._mode = param5;
         this._gfxId = param1;
         this._cellId = param2;
         this._angle = param3;
         this._yOffset = param4;
         this._startCell = param6;
         this._endCell = param7;
         this._popUnderPlayer = param8;
      }
      
      override public function start() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:int = EntitiesManager.getInstance().getFreeEntityId();
         this._entity = new Projectile(_loc4_,TiphonEntityLook.fromString("{" + this._gfxId + "}"),true);
         this._entity.addEventListener(TiphonEvent.ANIMATION_SHOT,this.shot);
         this._entity.addEventListener(TiphonEvent.ANIMATION_END,this.remove);
         this._entity.addEventListener(TiphonEvent.RENDER_FAILED,this.remove);
         this._entity.addEventListener(TiphonEvent.SPRITE_INIT_FAILED,this.remove);
         this._entity.rotation = this._angle;
         this._entity.mouseEnabled = false;
         this._entity.mouseChildren = false;
         switch(this._mode)
         {
            case AddGfxModeEnum.NORMAL:
               this._entity.init();
               break;
            case AddGfxModeEnum.RANDOM:
               _loc1_ = this._entity.getAvaibleDirection();
               _loc2_ = new Array();
               _loc3_ = 0;
               while(_loc3_ < 8)
               {
                  if(_loc1_[_loc3_])
                  {
                     _loc2_.push(_loc3_);
                  }
                  _loc3_++;
               }
               this._entity.init(_loc2_[Math.floor(Math.random() * _loc2_.length)]);
               break;
            case AddGfxModeEnum.ORIENTED:
               this._entity.init(this._startCell.advancedOrientationTo(this._endCell,true));
         }
         this._entity.position = MapPoint.fromCellId(this._cellId);
         if(MapDisplayManager.getInstance().renderer.isCellUnderFixture(this._cellId))
         {
            this._entity.display(PlacementStrataEnums.STRATA_FOREGROUND);
         }
         else if(this._popUnderPlayer)
         {
            this._entity.display(PlacementStrataEnums.STRATA_SPELL_BACKGROUND);
         }
         else
         {
            this._entity.display(PlacementStrataEnums.STRATA_SPELL_FOREGROUND);
         }
         this._entity.y = this._entity.y + this._yOffset;
      }
      
      private function remove(param1:Event) : void
      {
         this._entity.removeEventListener(TiphonEvent.ANIMATION_END,this.remove);
         this._entity.removeEventListener(TiphonEvent.ANIMATION_SHOT,this.shot);
         this._entity.removeEventListener(TiphonEvent.RENDER_FAILED,this.remove);
         this._entity.removeEventListener(TiphonEvent.SPRITE_INIT_FAILED,this.remove);
         this._entity.destroy();
         if(!this._shot)
         {
            this.shot(null);
         }
      }
      
      private function shot(param1:Event) : void
      {
         this._shot = true;
         this._entity.removeEventListener(TiphonEvent.ANIMATION_SHOT,this.shot);
         executeCallbacks();
      }
      
      override protected function onTimeOut(param1:TimerEvent) : void
      {
         _log.error("Timeout en attendant le SHOT du bone du projectile " + this._gfxId);
         if(this._entity)
         {
            this._entity.destroy();
         }
         super.onTimeOut(param1);
      }
   }
}
