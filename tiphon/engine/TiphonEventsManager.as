package com.ankamagames.tiphon.engine
{
   import com.ankamagames.jerakine.interfaces.IFLAEventHandler;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.memory.WeakReference;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.types.EventListener;
   import com.ankamagames.tiphon.types.TiphonEventInfo;
   import flash.display.FrameLabel;
   import flash.display.Scene;
   import flash.utils.getQualifiedClassName;
   
   public class TiphonEventsManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(TiphonEventsManager));
      
      private static var _listeners:Vector.<EventListener> = new Vector.<EventListener>();
      
      private static var _eventsDic:Array;
      
      private static const EVENT_SHOT:String = "SHOT";
      
      private static const EVENT_END:String = "END";
      
      private static const PLAYER_STOP:String = "STOP";
      
      private static const EVENT_SOUND:String = "SOUND";
      
      private static const EVENT_DATASOUND:String = "DATASOUND";
      
      private static const EVENT_PLAYANIM:String = "PLAYANIM";
      
      public static var BALISE_SOUND:String = "Sound";
      
      public static var BALISE_DATASOUND:String = "DataSound";
      
      public static var BALISE_PLAYANIM:String = "PlayAnim";
      
      public static var BALISE_EVT:String = "Evt";
      
      public static var BALISE_PARAM_BEGIN:String = "(";
      
      public static var BALISE_PARAM_END:String = ")";
       
      
      private var _weakTiphonSprite:WeakReference;
      
      private var _events:Array;
      
      public function TiphonEventsManager(param1:TiphonSprite)
      {
         super();
         this._weakTiphonSprite = new WeakReference(param1);
         this._events = new Array();
         if(_eventsDic == null)
         {
            _eventsDic = new Array();
         }
      }
      
      public static function get listeners() : Vector.<EventListener>
      {
         return _listeners;
      }
      
      public static function addListener(param1:IFLAEventHandler, param2:String) : void
      {
         var _loc3_:EventListener = null;
         var _loc4_:int = -1;
         var _loc5_:int = _listeners.length;
         while(++_loc4_ < _loc5_)
         {
            _loc3_ = _listeners[_loc4_];
            if(_loc3_.listener == param1 && _loc3_.typesEvents == param2)
            {
               return;
            }
         }
         TiphonEventsManager._listeners.push(new EventListener(param1,param2));
      }
      
      public static function removeListener(param1:IFLAEventHandler) : void
      {
         var _loc2_:int = TiphonEventsManager._listeners.indexOf(param1);
         if(_loc2_ != -1)
         {
            TiphonEventsManager._listeners.splice(_loc2_,1);
         }
      }
      
      public function parseLabels(param1:Scene, param2:String) : void
      {
         var _loc3_:FrameLabel = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = param1.labels.length;
         var _loc7_:int = -1;
         while(++_loc7_ < _loc6_)
         {
            _loc3_ = param1.labels[_loc7_] as FrameLabel;
            _loc4_ = _loc3_.name;
            _loc5_ = _loc3_.frame;
            this.addEvent(_loc4_,_loc5_,param2);
         }
      }
      
      public function dispatchEvents(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TiphonEventInfo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:EventListener = null;
         if(!this._weakTiphonSprite)
         {
            return;
         }
         if(param1 == 0)
         {
            param1 = 1;
         }
         var _loc9_:uint;
         var _loc8_:TiphonSprite;
         if((_loc9_ = (_loc8_ = this._weakTiphonSprite.object as TiphonSprite).getDirection()) == 3)
         {
            _loc9_ = 1;
         }
         if(_loc9_ == 7)
         {
            _loc9_ = 5;
         }
         if(_loc9_ == 4)
         {
            _loc9_ = 0;
         }
         var _loc10_:String = _loc8_.getAnimation();
         var _loc11_:Vector.<TiphonEventInfo>;
         if(_loc11_ = this._events[param1])
         {
            _loc2_ = _loc11_.length;
            _loc3_ = -1;
            while(++_loc3_ < _loc2_)
            {
               _loc4_ = _loc11_[_loc3_];
               _loc5_ = _listeners.length;
               _loc6_ = -1;
               while(++_loc6_ < _loc5_)
               {
                  if((_loc7_ = _listeners[_loc6_]).typesEvents == _loc4_.type && _loc4_.animationType == _loc10_ && _loc4_.direction == _loc9_)
                  {
                     _loc7_.listener.handleFLAEvent(_loc4_.animationName,_loc4_.type,_loc4_.params,_loc8_);
                  }
               }
            }
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<TiphonEventInfo> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TiphonEventInfo = null;
         if(this._events)
         {
            _loc1_ = -1;
            _loc2_ = this._events.length;
            while(++_loc1_ < _loc2_)
            {
               _loc3_ = this._events[_loc1_];
               if(_loc3_)
               {
                  _loc4_ = -1;
                  _loc5_ = _loc3_.length;
                  while(++_loc4_ < _loc5_)
                  {
                     (_loc6_ = _loc3_[_loc4_]).destroy();
                  }
               }
            }
            this._events = null;
         }
         if(this._weakTiphonSprite)
         {
            this._weakTiphonSprite.destroy();
            this._weakTiphonSprite = null;
         }
      }
      
      public function addEvent(param1:String, param2:int, param3:String) : void
      {
         var _loc4_:TiphonEventInfo = null;
         var _loc5_:TiphonEventInfo = null;
         var _loc6_:TiphonEventInfo = null;
         var _loc7_:TiphonSprite = null;
         if(this._events[param2] == null)
         {
            this._events[param2] = new Vector.<TiphonEventInfo>();
         }
         for each(_loc4_ in this._events[param2])
         {
            if(_loc4_.animationName == param3 && _loc4_.label == param1)
            {
               return;
            }
         }
         if(_eventsDic[param1])
         {
            (_loc5_ = (_eventsDic[param1] as TiphonEventInfo).duplicate()).label = param1;
            this._events[param2].push(_loc5_);
            _loc5_.animationName = param3;
         }
         else if(_loc6_ = this.parseLabel(param1))
         {
            _eventsDic[param1] = _loc6_;
            _loc6_.animationName = param3;
            _loc6_.label = param1;
            this._events[param2].push(_loc6_);
         }
         else if(param1 != "END")
         {
            _loc7_ = this._weakTiphonSprite.object as TiphonSprite;
            _log.error("Found label \'" + param1 + "\' on sprite " + _loc7_.look.getBone() + " (anim " + _loc7_.getAnimation() + ")");
         }
      }
      
      public function removeEvents(param1:String, param2:String) : void
      {
         var _loc3_:* = null;
         var _loc4_:Vector.<TiphonEventInfo> = null;
         var _loc5_:Vector.<TiphonEventInfo> = null;
         var _loc6_:TiphonEventInfo = null;
         for(_loc3_ in this._events)
         {
            _loc4_ = this._events[_loc3_];
            _loc5_ = new Vector.<TiphonEventInfo>();
            for each(_loc6_ in _loc4_)
            {
               if(_loc6_.animationName != param2 || _loc6_.type != param1)
               {
                  _loc5_.push(_loc6_);
               }
            }
            if(_loc5_.length != _loc4_.length)
            {
               this._events[_loc3_] = _loc5_;
            }
         }
      }
      
      private function parseLabel(param1:String) : TiphonEventInfo
      {
         var _loc2_:TiphonEventInfo = null;
         var _loc3_:String = null;
         var _loc4_:String = param1.split(BALISE_PARAM_BEGIN)[0];
         var _loc5_:RegExp = /^\s*(.*?)\s*$/g;
         _loc4_ = _loc4_.replace(_loc5_,"$1");
         switch(_loc4_.toUpperCase())
         {
            case BALISE_SOUND.toUpperCase():
               _loc3_ = param1.split(BALISE_PARAM_BEGIN)[1];
               _loc3_ = _loc3_.split(BALISE_PARAM_END)[0];
               _loc2_ = new TiphonEventInfo(TiphonEvent.SOUND_EVENT,_loc3_);
               break;
            case BALISE_DATASOUND.toUpperCase():
               _loc3_ = param1.split(BALISE_PARAM_BEGIN)[1];
               _loc3_ = _loc3_.split(BALISE_PARAM_END)[0];
               _loc2_ = new TiphonEventInfo(TiphonEvent.DATASOUND_EVENT,_loc3_);
               break;
            case BALISE_PLAYANIM.toUpperCase():
               _loc3_ = param1.split(BALISE_PARAM_BEGIN)[1];
               _loc3_ = _loc3_.split(BALISE_PARAM_END)[0];
               _loc2_ = new TiphonEventInfo(TiphonEvent.PLAYANIM_EVENT,_loc3_);
               break;
            case BALISE_EVT.toUpperCase():
               _loc3_ = param1.split(BALISE_PARAM_BEGIN)[1];
               _loc3_ = _loc3_.split(BALISE_PARAM_END)[0];
               _loc2_ = new TiphonEventInfo(TiphonEvent.EVT_EVENT,_loc3_);
               break;
            default:
               _loc2_ = this.convertOldLabel(param1);
         }
         return _loc2_;
      }
      
      private function convertOldLabel(param1:String) : TiphonEventInfo
      {
         var _loc2_:TiphonEventInfo = null;
         switch(param1)
         {
            case EVENT_END:
               _loc2_ = new TiphonEventInfo(TiphonEvent.EVT_EVENT,EVENT_END);
               break;
            case PLAYER_STOP:
               _loc2_ = new TiphonEventInfo(TiphonEvent.EVT_EVENT,PLAYER_STOP);
               break;
            case EVENT_SHOT:
               _loc2_ = new TiphonEventInfo(TiphonEvent.EVT_EVENT,EVENT_SHOT);
         }
         return _loc2_;
      }
   }
}
