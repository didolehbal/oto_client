package com.ankamagames.tiphon.engine
{
   import com.ankamagames.jerakine.utils.display.FpsControler;
   import com.ankamagames.tiphon.types.DynamicSprite;
   import com.ankamagames.tiphon.types.ScriptedAnimation;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class TiphonFpsManager
   {
      
      private static var _tiphonGarbageCollectorTimer:Timer = new Timer(60000);
      
      private static var _oldScriptedAnimation:Dictionary = new Dictionary(true);
       
      
      public function TiphonFpsManager()
      {
         super();
      }
      
      public static function init() : void
      {
         _tiphonGarbageCollectorTimer.addEventListener(TimerEvent.TIMER,onTiphonGarbageCollector);
      }
      
      public static function addOldScriptedAnimation(param1:ScriptedAnimation, param2:Boolean = false) : void
      {
      }
      
      private static function onTiphonGarbageCollector(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ScriptedAnimation = null;
         var _loc6_:Vector.<ScriptedAnimation> = new Vector.<ScriptedAnimation>();
         var _loc7_:int = getTimer();
         for(_loc2_ in _oldScriptedAnimation)
         {
            _loc5_ = _loc2_ as ScriptedAnimation;
            if(_loc7_ - _oldScriptedAnimation[_loc5_] > 300000)
            {
               _loc6_.push(_loc5_);
               destroyScriptedAnimation(_loc5_);
            }
         }
         _loc3_ = -1;
         _loc4_ = _loc6_.length;
         while(++_loc3_ < _loc4_)
         {
            delete _oldScriptedAnimation[_loc6_[_loc3_]];
         }
      }
      
      private static function destroyScriptedAnimation(param1:ScriptedAnimation) : void
      {
         if(param1 && !param1.parent)
         {
            param1.destroyed = true;
            if(param1.parent)
            {
               param1.parent.removeChild(param1);
            }
            param1.spriteHandler = null;
            eraseMovieClip(param1);
         }
      }
      
      private static function eraseMovieClip(param1:MovieClip) : void
      {
         var _loc2_:int = param1.totalFrames + 1;
         var _loc3_:int = 1;
         while(_loc3_ < _loc2_)
         {
            param1.gotoAndStop(_loc3_);
            eraseFrame(param1);
            _loc3_++;
         }
         param1.stop();
         if(param1.isControled)
         {
            FpsControler.uncontrolFps(param1);
         }
      }
      
      private static function eraseFrame(param1:DisplayObjectContainer) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         while(param1.numChildren > _loc4_)
         {
            _loc3_ = param1.removeChildAt(_loc4_);
            if(_loc3_ == _loc2_)
            {
               _loc4_++;
            }
            _loc2_ = _loc3_;
            if(!(_loc3_ is DynamicSprite))
            {
               if(_loc3_ is ScriptedAnimation)
               {
                  destroyScriptedAnimation(param1 as ScriptedAnimation);
               }
               else if(_loc3_ is MovieClip)
               {
                  eraseMovieClip(_loc3_ as MovieClip);
               }
               else if(_loc3_ is DisplayObjectContainer)
               {
                  eraseFrame(_loc3_ as DisplayObjectContainer);
               }
               else if(_loc3_ is Shape)
               {
                  (_loc3_ as Shape).graphics.clear();
               }
            }
         }
      }
   }
}
