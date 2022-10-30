package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.types.listener.GenericListener;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class GenericEventsManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(GenericEventsManager));
       
      
      protected var _aEvent:Array;
      
      public function GenericEventsManager()
      {
         this._aEvent = new Array();
         super();
      }
      
      public function initialize() : void
      {
         this._aEvent = new Array();
      }
      
      public function registerEvent(param1:GenericListener) : void
      {
         if(this._aEvent[param1.event] == null)
         {
            this._aEvent[param1.event] = new Array();
         }
         this._aEvent[param1.event].push(param1);
         (this._aEvent[param1.event] as Array).sortOn("sortIndex",Array.NUMERIC | Array.DESCENDING);
      }
      
      public function removeEventListener(param1:GenericListener) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:GenericListener = null;
         for(_loc2_ in this._aEvent)
         {
            if(this._aEvent[_loc2_])
            {
               _loc3_ = 0;
               while(_loc3_ < this._aEvent[_loc2_].length)
               {
                  if(_loc4_ = this._aEvent[_loc2_][_loc3_])
                  {
                     if(_loc4_ == param1)
                     {
                        _loc4_.destroy();
                        (this._aEvent[_loc2_] as Array).splice(_loc3_,1);
                        _loc3_--;
                     }
                  }
                  _loc3_++;
               }
               if(!this._aEvent[_loc2_].length)
               {
                  this._aEvent[_loc2_] = null;
                  delete this._aEvent[_loc2_];
               }
            }
         }
      }
      
      public function removeAllEventListeners(param1:*) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:GenericListener = null;
         for(_loc2_ in this._aEvent)
         {
            if(this._aEvent[_loc2_])
            {
               _loc3_ = 0;
               while(_loc3_ < this._aEvent[_loc2_].length)
               {
                  if(_loc4_ = this._aEvent[_loc2_][_loc3_])
                  {
                     if(_loc4_.listener == param1)
                     {
                        _loc4_.destroy();
                        (this._aEvent[_loc2_] as Array).splice(_loc3_,1);
                        _loc3_--;
                     }
                  }
                  _loc3_++;
               }
               if(!this._aEvent[_loc2_].length)
               {
                  this._aEvent[_loc2_] = null;
                  delete this._aEvent[_loc2_];
               }
            }
         }
      }
   }
}
