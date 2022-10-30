package com.ankamagames.jerakine.utils.benchmark.monitoring
{
   import com.ankamagames.jerakine.utils.benchmark.monitoring.ui.ExtensionPanel;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.ui.GraphDisplayer;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.ui.RedrawRegionButton;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.ui.StateButton;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.StatusEvent;
   import flash.geom.Point;
   import flash.net.LocalConnection;
   import flash.profiler.showRedrawRegions;
   import flash.system.System;
   import flash.utils.getTimer;
   
   public class FpsManager extends Sprite
   {
      
      private static var _instance:FpsManager;
       
      
      private var conn:LocalConnection;
      
      private var isExternal:Boolean;
      
      private var _decal:Point;
      
      private var _btnStateSpr:StateButton;
      
      private var _btnRetrace:RedrawRegionButton;
      
      private var _graphPanel:GraphDisplayer;
      
      private var _extensionPanel:ExtensionPanel;
      
      private var _redrawRegionsVisible:Boolean = false;
      
      private var _ticks:uint = 0;
      
      private var _last:uint;
      
      public function FpsManager()
      {
         this._last = getTimer();
         super();
         this._btnRetrace = new RedrawRegionButton(FpsManagerConst.BOX_WIDTH + 30,0);
         this._btnRetrace.addEventListener(MouseEvent.CLICK,this.redrawRegionHandler);
         addChild(this._btnRetrace);
         this._graphPanel = new GraphDisplayer();
         addChild(this._graphPanel);
         this._extensionPanel = new ExtensionPanel(this);
         this._btnStateSpr = new StateButton(FpsManagerConst.BOX_WIDTH + 5,0);
         this._btnStateSpr.addEventListener(MouseEvent.CLICK,this.changeState);
         addChild(this._btnStateSpr);
         FpsManagerConst.PLAYER_VERSION = FpsManagerUtils.getVersion();
         x = y = 50;
         if(FpsManagerConst.PLAYER_VERSION >= 10)
         {
            if(AirScanner.hasAir())
            {
               this._graphPanel.previousFreeMem = FpsManagerUtils.calculateMB(System["freeMemory"]);
            }
            this._extensionPanel.lastGc = getTimer();
         }
         this.startTracking(FpsManagerConst.SPECIAL_GRAPH[1].name,FpsManagerConst.SPECIAL_GRAPH[1].color);
      }
      
      public static function getInstance() : FpsManager
      {
         if(_instance == null)
         {
            _instance = new FpsManager();
         }
         return _instance;
      }
      
      public function display(param1:Boolean = false) : void
      {
         if(_instance == null)
         {
            throw new Error("FpsManager is not initialized");
         }
         this.isExternal = param1;
         if(param1)
         {
            this.conn = new LocalConnection();
            this.conn.addEventListener(StatusEvent.STATUS,this.onStatus);
            this.conn.send("app#DofusDebugger:DofusDebugConnection","updateStatus",true);
         }
         StageShareManager.stage.addChild(_instance);
         this._graphPanel.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         StageShareManager.stage.addEventListener(Event.ENTER_FRAME,this.loop);
      }
      
      public function hide() : void
      {
         if(_instance == null)
         {
            throw new Error("FpsManager is not initialized");
         }
         if(this.isExternal)
         {
            this.conn.send("app#DofusDebugger:DofusDebugConnection","updateStatus",false);
            this.conn.removeEventListener(StatusEvent.STATUS,this.onStatus);
            this.conn.close();
            this.conn = null;
         }
         else
         {
            StageShareManager.stage.removeChild(_instance);
            this._graphPanel.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         }
         StageShareManager.stage.removeEventListener(Event.ENTER_FRAME,this.loop);
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this._decal = new Point(param1.localX,param1.localY);
         StageShareManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         StageShareManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this._decal = null;
         StageShareManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         StageShareManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         x = StageShareManager.stage.mouseX - this._decal.x;
         y = StageShareManager.stage.mouseY - this._decal.y;
         param1.updateAfterEvent();
      }
      
      private function onStatus(param1:StatusEvent) : void
      {
         switch(param1.level)
         {
            case "status":
               return;
            case "error":
               this.conn.removeEventListener(StatusEvent.STATUS,this.onStatus);
               this.conn = null;
               return;
            default:
               return;
         }
      }
      
      private function redrawRegionHandler(param1:MouseEvent) : void
      {
         this._redrawRegionsVisible = !this._redrawRegionsVisible;
         showRedrawRegions(this._redrawRegionsVisible,17595);
      }
      
      public function changeState(param1:MouseEvent = null) : void
      {
         this._extensionPanel.changeState();
      }
      
      private function loop(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         this.stopTracking(FpsManagerConst.SPECIAL_GRAPH[0].name);
         this.startTracking(FpsManagerConst.SPECIAL_GRAPH[0].name,FpsManagerConst.SPECIAL_GRAPH[0].color);
         this._graphPanel.update();
         this.updateMem();
         ++this._ticks;
         var _loc6_:uint;
         var _loc5_:uint;
         if((_loc6_ = (_loc5_ = getTimer()) - this._last) >= 500)
         {
            _loc2_ = this._ticks / _loc6_ * 1000;
            if(this.isExternal && this.conn != null)
            {
               this.conn.send("app#DofusDebugger:DofusDebugConnection","updateValues",_loc2_,this._graphPanel.memory,FpsManagerUtils.getTimeFromNow(this._extensionPanel.lastGc));
               _loc3_ = this._graphPanel.getExternalGraphs();
               for each(_loc4_ in _loc3_)
               {
                  if(this.conn == null)
                  {
                     break;
                  }
                  this.conn.send("app#DofusDebugger:DofusDebugConnection","updateGraphValues",_loc4_.name,_loc4_.color,_loc4_.points);
               }
               this.conn.send("app#DofusDebugger:DofusDebugConnection","updateGraphes");
            }
            this._graphPanel.updateFpsValue(_loc2_);
            this._extensionPanel.update();
            this._ticks = 0;
            this._last = _loc5_;
         }
      }
      
      private function updateMem() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         this._graphPanel.memory = FpsManagerUtils.calculateMB(System.totalMemory).toPrecision(3);
         if(AirScanner.hasAir())
         {
            if(FpsManagerConst.PLAYER_VERSION >= 10)
            {
               _loc1_ = FpsManagerUtils.calculateMB(System["freeMemory"]);
               if(_loc1_ - this._graphPanel.previousFreeMem > 1)
               {
                  this._extensionPanel.lastGc = getTimer();
               }
               _loc2_ = FpsManagerUtils.calculateMB(System["privateMemory"]);
               this._graphPanel.memory = this._graphPanel.memory + ("/" + _loc2_.toPrecision(3));
               this._graphPanel.previousFreeMem = _loc1_;
               this._extensionPanel.updateGc(_loc2_);
            }
         }
         this._graphPanel.memory = this._graphPanel.memory + " MB";
      }
      
      public function startTracking(param1:String, param2:uint = 16777215) : void
      {
         this._graphPanel.startTracking(param1,param2);
      }
      
      public function stopTracking(param1:String) : void
      {
         this._graphPanel.stopTracking(param1);
      }
      
      public function watchObject(param1:Object, param2:Boolean = false) : void
      {
         this._extensionPanel.watchObject(param1,FpsManagerUtils.getBrightRandomColor(),param2);
      }
   }
}
