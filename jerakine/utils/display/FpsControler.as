package com.ankamagames.jerakine.utils.display
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class FpsControler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FpsControler));
      
      private static var ScriptedAnimation:Class;
      
      private static var _clipList:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private static var _garbageTimer:Timer;
      
      private static var _groupId:int = 0;
       
      
      public function FpsControler()
      {
         super();
      }
      
      public static function Init(param1:Class) : void
      {
         ScriptedAnimation = param1;
         if(!_garbageTimer)
         {
            _garbageTimer = new Timer(10000);
            _garbageTimer.addEventListener(TimerEvent.TIMER,onGarbageTimer);
            _garbageTimer.start();
         }
      }
      
      private static function onGarbageTimer(param1:Event) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         while(_loc3_ < _clipList.length)
         {
            _loc2_ = _clipList[_loc3_];
            if(!_loc2_.stage)
            {
               uncontrolFps(_loc2_,false);
            }
            _loc3_++;
         }
      }
      
      public static function controlFps(param1:MovieClip, param2:uint, param3:Boolean = false) : MovieClip
      {
         if(!MovieClipUtils.isSingleFrame(param1))
         {
            ++_groupId;
            controlSingleClip(param1,_groupId,param2,param3);
         }
         return param1;
      }
      
      public static function uncontrolFps(param1:DisplayObjectContainer, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<MovieClip> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         if(!param1)
         {
            return;
         }
         MovieClipUtils.stopMovieClip(param1);
         var _loc8_:MovieClip = param1 as MovieClip;
         if(param2 && _loc8_)
         {
            _loc3_ = _loc8_.groupId;
            if(_loc3_)
            {
               _loc4_ = new Vector.<MovieClip>();
               _loc5_ = _clipList.length;
               _loc6_ = -1;
               while(++_loc6_ < _loc5_)
               {
                  if((_loc7_ = _clipList[_loc6_]).groupId == _loc3_)
                  {
                     _loc7_.isControled = null;
                     _clipList.splice(_loc6_,1);
                     _loc6_--;
                     _loc5_--;
                  }
               }
            }
         }
         removeClip(_loc8_);
      }
      
      private static function removeClip(param1:MovieClip) : void
      {
         var _loc2_:int = _clipList.indexOf(param1);
         if(_loc2_ != -1)
         {
            _clipList.splice(_loc2_,1);
         }
      }
      
      private static function controlSingleClip(param1:DisplayObjectContainer, param2:int, param3:uint, param4:Boolean = false, param5:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:DisplayObjectContainer = null;
         if(param1 && !param4)
         {
            _loc6_ = -1;
            _loc7_ = param1.numChildren;
            while(++_loc6_ < _loc7_)
            {
               if(_loc8_ = param1.getChildAt(_loc6_) as DisplayObjectContainer)
               {
                  controlSingleClip(_loc8_,param2,param3,true,true);
               }
            }
         }
         if(param5 && param1 is ScriptedAnimation)
         {
            return;
         }
         var _loc9_:MovieClip;
         if(!(_loc9_ = param1 as MovieClip) || _loc9_.totalFrames == 1 || _clipList.indexOf(_loc9_) != -1)
         {
            return;
         }
         _loc9_.groupId = param2;
         var _loc10_:int = _loc9_.currentFrame > 0?int(_loc9_.currentFrame):1;
         _loc9_.gotoAndStop(_loc10_);
         if(_loc9_ is ScriptedAnimation)
         {
            _loc9_.playEventAtFrame(_loc10_);
         }
         _clipList.push(_loc9_);
         _loc9_.groupId = param2;
         _loc9_.isControled = true;
      }
      
      public static function nextFrame() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = _clipList.length;
         var _loc5_:int = -1;
         while(++_loc5_ < _loc4_)
         {
            _loc1_ = _clipList[_loc5_];
            _loc2_ = _loc1_.currentFrame + 1;
            if(_loc2_ > _loc1_.totalFrames)
            {
               _loc2_ = 1;
            }
            _loc1_.gotoAndStop(_loc2_);
            if(_loc1_ is ScriptedAnimation)
            {
               _loc1_.playEventAtFrame(_loc2_);
            }
            _loc3_ = _loc4_ - _clipList.length;
            if(_loc3_)
            {
               _loc4_ = _loc4_ - _loc3_;
               if((_loc5_ = _loc5_ - _loc3_) < 0)
               {
                  _loc5_ = 0;
               }
            }
         }
      }
   }
}
