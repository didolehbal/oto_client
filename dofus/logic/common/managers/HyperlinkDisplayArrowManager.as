package com.ankamagames.dofus.logic.common.managers
{
   import avmplus.getQualifiedClassName;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class HyperlinkDisplayArrowManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HyperlinkDisplayArrowManager));
      
      private static const ARROW_CLIP:Class = HyperlinkDisplayArrowManager_ARROW_CLIP;
      
      private static var _arrowClip:MovieClip;
      
      private static var _arrowTimer:Timer;
      
      private static var _displayLastArrow:Boolean = false;
      
      private static var _lastArrowX:int;
      
      private static var _lastArrowY:int;
      
      private static var _lastArrowPos:int;
      
      private static var _lastStrata:int;
      
      private static var _lastReverse:int;
      
      private static var _arrowPositions:Dictionary = new Dictionary();
       
      
      public function HyperlinkDisplayArrowManager()
      {
         super();
      }
      
      public static function showArrow(param1:String, param2:String, param3:int = 0, param4:int = 0, param5:int = 5, param6:int = 0) : MovieClip
      {
         var _loc7_:UiRootContainer = null;
         var _loc8_:Array = null;
         var _loc9_:DisplayObject = null;
         var _loc10_:String = null;
         var _loc11_:Rectangle = null;
         var _loc12_:Grid = null;
         var _loc13_:int = 0;
         var _loc14_:MovieClip = getArrow(param6 == 1);
         var _loc15_:DisplayObjectContainer;
         (_loc15_ = Berilia.getInstance().docMain.getChildAt(param5) as DisplayObjectContainer).addChild(_loc14_);
         if(isNaN(Number(param1)))
         {
            if(_loc7_ = Berilia.getInstance().getUi(param1))
            {
               _loc8_ = param2.split("|");
               if((_loc9_ = _loc7_.getElement(_loc8_[0])) && _loc9_.visible)
               {
                  _loc10_ = param1;
                  if(_loc8_.length == 1)
                  {
                     _loc11_ = _loc9_.getRect(_loc15_);
                     _loc10_ = _loc10_ + ("_" + _loc8_[0]);
                  }
                  else
                  {
                     _loc12_ = _loc9_ as Grid;
                     _loc13_ = 0;
                     while(_loc13_ < _loc12_.dataProvider.length)
                     {
                        if(_loc12_.dataProvider[_loc13_] && _loc12_.dataProvider[_loc13_].hasOwnProperty(_loc8_[1]) && _loc12_.dataProvider[_loc13_][_loc8_[1]] == _loc8_[2])
                        {
                           _loc11_ = (_loc12_.slots[_loc13_] as DisplayObject).getRect(_loc15_);
                           break;
                        }
                        _loc13_++;
                     }
                     if(!_loc11_)
                     {
                        _log.error("The arrow can\'t be displayed : no data with " + _loc8_[1] + " = " + _loc8_[2] + " in " + _loc8_[0] + ".");
                        return null;
                     }
                  }
                  if(_arrowPositions[_loc10_])
                  {
                     _loc14_.x = _arrowPositions[_loc10_].x;
                     _loc14_.y = _arrowPositions[_loc10_].y;
                  }
                  else
                  {
                     place(_arrowClip,_loc11_,param3);
                  }
               }
            }
            if(param4 == 1)
            {
               _arrowClip.scaleX = _arrowClip.scaleX * -1;
            }
            if(param6)
            {
               _displayLastArrow = true;
               _lastArrowX = _loc14_.x;
               _lastArrowY = _loc14_.y;
               _lastArrowPos = param3;
               _lastStrata = param5;
               _lastReverse = _arrowClip.scaleX;
            }
            return _arrowClip;
         }
         return showAbsoluteArrow(new Rectangle(int(param1),int(param2)),param3,param4,param5,param6);
      }
      
      public static function showAbsoluteArrow(param1:Rectangle, param2:int = 0, param3:int = 0, param4:int = 5, param5:int = 0) : MovieClip
      {
         var _loc6_:MovieClip = getArrow(param5 == 1);
         DisplayObjectContainer(Berilia.getInstance().docMain.getChildAt(param4)).addChild(_loc6_);
         place(_loc6_,param1,param2);
         if(param3 == 1)
         {
            _arrowClip.scaleX = _arrowClip.scaleX * -1;
         }
         if(param5)
         {
            _displayLastArrow = true;
            _lastArrowX = _loc6_.x;
            _lastArrowY = _loc6_.y;
            _lastArrowPos = param2;
            _lastStrata = param4;
            _lastReverse = _arrowClip.scaleX;
         }
         return _loc6_;
      }
      
      public static function setArrowPosition(param1:String, param2:String, param3:Point) : void
      {
         _arrowPositions[param1 + "_" + param2] = param3;
      }
      
      public static function showMapTransition(param1:int, param2:int, param3:int, param4:int = 0, param5:int = 5, param6:int = 0) : MovieClip
      {
         var _loc7_:MovieClip = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         if(param1 == -1 || param1 == PlayedCharacterManager.getInstance().currentMap.mapId)
         {
            _loc7_ = getArrow(param6 == 1);
            DisplayObjectContainer(Berilia.getInstance().docMain.getChildAt(param5)).addChild(_loc7_);
            switch(param2)
            {
               case DirectionsEnum.DOWN:
                  _loc8_ = param3;
                  _loc9_ = 880;
                  _loc10_ = 1;
                  break;
               case DirectionsEnum.LEFT:
                  _loc8_ = 0;
                  _loc9_ = param3;
                  _loc10_ = 5;
                  break;
               case DirectionsEnum.UP:
                  _loc8_ = param3;
                  _loc9_ = 0;
                  _loc10_ = 7;
                  break;
               case DirectionsEnum.RIGHT:
                  _loc8_ = 1280;
                  _loc9_ = param3;
                  _loc10_ = 1;
            }
            place(_loc7_,new Rectangle(_loc8_,_loc9_),_loc10_);
            if(param4 == 1)
            {
               _arrowClip.scaleX = _arrowClip.scaleX * -1;
            }
            if(param6)
            {
               _displayLastArrow = true;
               _lastArrowX = _loc7_.x;
               _lastArrowY = _loc7_.y;
               _lastArrowPos = _loc10_;
               _lastStrata = param5;
               _lastReverse = _arrowClip.scaleX;
            }
            return _loc7_;
         }
         return null;
      }
      
      public static function destroyArrow(param1:Event = null) : void
      {
         if(param1)
         {
            param1.currentTarget.removeEventListener(TimerEvent.TIMER,destroyArrow);
            if(_displayLastArrow)
            {
               (Berilia.getInstance().docMain.getChildAt(_lastStrata) as DisplayObjectContainer).addChild(_arrowClip);
               place(_arrowClip,new Rectangle(_lastArrowX,_lastArrowY),_lastArrowPos);
               _arrowClip.scaleX = _lastReverse;
               return;
            }
         }
         else
         {
            _displayLastArrow = false;
         }
         if(_arrowClip)
         {
            _arrowClip.gotoAndStop(1);
            if(_arrowClip.parent)
            {
               _arrowClip.parent.removeChild(_arrowClip);
            }
         }
         if(_arrowTimer)
         {
            _arrowTimer.reset();
            _arrowTimer = null;
         }
      }
      
      private static function getArrow(param1:Boolean = false) : MovieClip
      {
         if(_arrowClip)
         {
            _arrowClip.gotoAndPlay(1);
         }
         else
         {
            _arrowClip = new ARROW_CLIP() as MovieClip;
            _arrowClip.mouseEnabled = false;
            _arrowClip.mouseChildren = false;
         }
         if(param1)
         {
            if(_arrowTimer)
            {
               _arrowTimer.reset();
               _arrowTimer = null;
            }
         }
         else
         {
            if(_arrowTimer)
            {
               _arrowTimer.reset();
            }
            else
            {
               _arrowTimer = new Timer(5000,1);
               _arrowTimer.addEventListener(TimerEvent.TIMER,destroyArrow);
            }
            _arrowTimer.start();
         }
         return _arrowClip;
      }
      
      public static function place(param1:MovieClip, param2:Rectangle, param3:int) : void
      {
         if(param3 == 0)
         {
            param1.scaleX = 1;
            param1.scaleY = 1;
            param1.x = int(param2.x);
            param1.y = int(param2.y);
         }
         else if(param3 == 1)
         {
            param1.scaleX = 1;
            param1.scaleY = 1;
            param1.x = int(param2.x + param2.width / 2);
            param1.y = int(param2.y);
         }
         else if(param3 == 2)
         {
            param1.scaleX = -1;
            param1.scaleY = 1;
            param1.x = int(param2.x + param2.width);
            param1.y = int(param2.y);
         }
         else if(param3 == 3)
         {
            param1.scaleX = 1;
            param1.scaleY = 1;
            param1.x = int(param2.x);
            param1.y = int(param2.y + param2.height / 2);
         }
         else if(param3 == 4)
         {
            param1.scaleX = 1;
            param1.scaleY = 1;
            param1.x = int(param2.x + param2.width / 2);
            param1.y = int(param2.y + param2.height / 2);
         }
         else if(param3 == 5)
         {
            param1.scaleX = -1;
            param1.scaleY = 1;
            param1.x = int(param2.x + param2.width);
            param1.y = int(param2.y + param2.height / 2);
         }
         else if(param3 == 6)
         {
            param1.scaleX = 1;
            param1.scaleY = -1;
            param1.x = int(param2.x);
            param1.y = int(param2.y + param2.height);
         }
         else if(param3 == 7)
         {
            param1.scaleX = 1;
            param1.scaleY = -1;
            param1.x = int(param2.x + param2.width / 2);
            param1.y = int(param2.y + param2.height);
         }
         else if(param3 == 8)
         {
            param1.scaleY = -1;
            param1.scaleX = -1;
            param1.x = int(param2.x + param2.width);
            param1.y = int(param2.y + param2.height);
         }
         else
         {
            param1.scaleX = 1;
            param1.scaleY = 1;
            param1.x = int(param2.x);
            param1.y = int(param2.y);
         }
      }
   }
}
