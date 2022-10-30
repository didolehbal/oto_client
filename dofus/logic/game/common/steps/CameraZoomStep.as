package com.ankamagames.dofus.logic.game.common.steps
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.dofus.misc.utils.Camera;
   import com.ankamagames.dofus.scripts.ScriptsUtil;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   import gs.TweenLite;
   
   public class CameraZoomStep extends AbstractSequencable
   {
       
      
      private var _camera:Camera;
      
      private var _args:Array;
      
      private var _instant:Boolean;
      
      private var _targetPos:Point;
      
      private var _container:DisplayObjectContainer;
      
      public function CameraZoomStep(param1:Camera, param2:Array, param3:Boolean)
      {
         super();
         this._camera = param1;
         this._args = param2;
         this._instant = param3;
         this._container = Atouin.getInstance().rootContainer;
      }
      
      override public function start() : void
      {
         var _loc1_:Object = null;
         var _loc2_:TweenLite = null;
         var _loc3_:MapPoint = ScriptsUtil.getMapPoint(this._args);
         var _loc4_:GraphicCell;
         var _loc5_:Point = (_loc4_ = InteractiveCellManager.getInstance().getCell(_loc3_.cellId)).parent.localToGlobal(new Point(_loc4_.x + _loc4_.width / 2,_loc4_.y + _loc4_.height / 2));
         this._targetPos = this._container.globalToLocal(_loc5_);
         if(this._instant)
         {
            this._camera.zoomOnPos(this._camera.currentZoom,this._targetPos.x,this._targetPos.y);
            executeCallbacks();
         }
         else
         {
            _loc1_ = {"zoom":Atouin.getInstance().currentZoom};
            _loc2_ = new TweenLite(_loc1_,1,{
               "zoom":this._camera.currentZoom,
               "onUpdate":this.updateZoom,
               "onUpdateParams":[_loc1_],
               "onComplete":this.zoomComplete
            });
         }
      }
      
      private function updateZoom(param1:Object) : void
      {
         this._camera.zoomOnPos(param1.zoom,this._targetPos.x,this._targetPos.y);
      }
      
      private function zoomComplete() : void
      {
         executeCallbacks();
      }
   }
}
