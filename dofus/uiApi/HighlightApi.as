package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkDisplayArrowManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowMonsterManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowNpcManager;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   [InstanciedApi]
   public class HighlightApi implements IApi
   {
      
      private static var _showCellTimer:Timer;
      
      private static var _cellIds:Array;
      
      private static var _currentCell:int;
       
      
      public function HighlightApi()
      {
         super();
      }
      
      private static function onCellTimer(param1:Event) : void
      {
         HyperlinkShowCellManager.showCell(_cellIds[_currentCell]);
         ++_currentCell;
         if(_currentCell >= _cellIds.length)
         {
            _currentCell = 0;
         }
      }
      
      [Untrusted]
      public function forceArrowPosition(param1:String, param2:String, param3:Point) : void
      {
         HyperlinkDisplayArrowManager.setArrowPosition(param1,param2,param3);
      }
      
      [Untrusted]
      public function highlightUi(param1:String, param2:String, param3:int = 0, param4:int = 0, param5:int = 5, param6:Boolean = false) : void
      {
         HyperlinkDisplayArrowManager.showArrow(param1,param2,param3,param4,param5,!!param6?1:0);
      }
      
      [Untrusted]
      public function highlightCell(param1:Array, param2:Boolean = false) : void
      {
         if(param2)
         {
            if(!_showCellTimer)
            {
               _showCellTimer = new Timer(2000);
               _showCellTimer.addEventListener(TimerEvent.TIMER,onCellTimer);
            }
            _cellIds = param1;
            _currentCell = 0;
            _showCellTimer.reset();
            _showCellTimer.start();
            onCellTimer(null);
         }
         else
         {
            if(_showCellTimer)
            {
               _showCellTimer.reset();
            }
            HyperlinkShowCellManager.showCell(param1);
         }
      }
      
      [Untrusted]
      public function highlightAbsolute(param1:Rectangle, param2:uint, param3:int = 0, param4:int = 5, param5:Boolean = false) : void
      {
         HyperlinkDisplayArrowManager.showAbsoluteArrow(param1,param2,param3,param4,!!param5?1:0);
      }
      
      [Untrusted]
      public function highlightMapTransition(param1:int, param2:int, param3:int, param4:Boolean = false, param5:int = 5, param6:Boolean = false) : void
      {
         HyperlinkDisplayArrowManager.showMapTransition(param1,param2,param3,!!param4?1:0,param5,!!param6?1:0);
      }
      
      [Untrusted]
      public function highlightNpc(param1:int, param2:Boolean = false) : void
      {
         HyperlinkShowNpcManager.showNpc(param1,!!param2?1:0);
      }
      
      [Untrusted]
      public function highlightMonster(param1:int, param2:Boolean = false) : void
      {
         HyperlinkShowMonsterManager.showMonster(param1,!!param2?1:0);
      }
      
      [Untrusted]
      public function stop() : void
      {
         HyperlinkDisplayArrowManager.destroyArrow();
         if(_showCellTimer)
         {
            _showCellTimer.reset();
         }
      }
   }
}
