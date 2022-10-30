package com.ankamagames.jerakine.utils.display
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class MovieClipUtils
   {
      
      private static var _asynchClip:Dictionary = new Dictionary(true);
      
      private static var _isAsync:Boolean;
      
      public static var asynchStopCount:uint;
      
      public static var asynchStopDoneCount:uint;
       
      
      public function MovieClipUtils()
      {
         super();
      }
      
      public static function isSingleFrame(param1:DisplayObjectContainer) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:DisplayObjectContainer = null;
         var _loc5_:MovieClip;
         if((_loc5_ = param1 as MovieClip) && _loc5_.totalFrames > 1)
         {
            return false;
         }
         _loc2_ = -1;
         _loc3_ = param1.numChildren;
         while(++_loc2_ < _loc3_)
         {
            if((_loc4_ = param1.getChildAt(_loc2_) as DisplayObjectContainer) && !isSingleFrame(_loc4_))
            {
               return false;
            }
         }
         return true;
      }
      
      public static function stopMovieClip(param1:DisplayObjectContainer) : void
      {
         var _loc2_:DisplayObject = null;
         if(param1 is MovieClip)
         {
            MovieClip(param1).stop();
            if(_isAsync && MovieClip(param1).totalFrames > 1)
            {
               ++asynchStopDoneCount;
            }
         }
         var _loc3_:int = -1;
         var _loc4_:int = param1.numChildren;
         while(++_loc3_ < _loc4_)
         {
            _loc2_ = param1.getChildAt(_loc3_);
            if(_loc2_ is DisplayObjectContainer)
            {
               stopMovieClip(_loc2_ as DisplayObjectContainer);
            }
         }
      }
      
      private static function stopMovieClipASynch(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:Boolean = false;
         var _loc4_:* = undefined;
         var _loc5_:DisplayObject = null;
         var _loc6_:Boolean = true;
         for(_loc2_ in _asynchClip)
         {
            if(_loc2_)
            {
               for(_loc4_ in _asynchClip[_loc2_])
               {
                  if(!_asynchClip[_loc2_][_loc4_])
                  {
                     if(!(_loc5_ = _loc2_.getChildAt(_loc4_)))
                     {
                        _loc3_ = true;
                     }
                     else if(_loc5_ is DisplayObjectContainer)
                     {
                        _isAsync = true;
                        stopMovieClip(_loc5_ as DisplayObjectContainer);
                        _isAsync = false;
                     }
                  }
               }
               if(!_loc3_)
               {
                  delete _asynchClip[_loc2_];
               }
               else
               {
                  _loc6_ = false;
               }
            }
         }
         if(_loc6_)
         {
            EnterFrameDispatcher.removeEventListener(stopMovieClipASynch);
         }
      }
   }
}
