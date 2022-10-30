package com.ankamagames.tubul.types
{
   import com.ankamagames.tubul.Tubul;
   import com.ankamagames.tubul.events.LoopEvent;
   import com.ankamagames.tubul.events.SoundWrapperEvent;
   import flash.events.EventDispatcher;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   [Event(name="soon_end_of_file",type="com.ankamagames.tubul.event.SoundWrapperEvent")]
   [Event(name="sound_loop",type="com.ankamagames.tubul.event.LoopEvent")]
   [Event(name="SOUND_COMPLETE",type="flash.events.Event")]
   public class SoundWrapper extends EventDispatcher
   {
       
      
      private var _currentLoop:uint;
      
      private var _snd:Sound;
      
      private var _loops:int;
      
      private var _length:Number;
      
      private var _stDic:Dictionary;
      
      private var _duration:Number;
      
      private var _endOfFileEventDispatched:Boolean = false;
      
      private var _notify:Boolean = false;
      
      private var _notifyTime:Number;
      
      var _volume:Number = 1;
      
      var _leftToLeft:Number = 1;
      
      var _rightToLeft:Number = 0;
      
      var _rightToRight:Number = 1;
      
      var _leftToRight:Number = 0;
      
      var _pan:Number = 0;
      
      var soundData:ByteArray;
      
      var hadBeenCut:Boolean;
      
      var _extractFinished:Boolean;
      
      public function SoundWrapper(param1:Sound, param2:int = 1)
      {
         super();
         this._snd = param1;
         this._loops = param2;
         this._length = param1.length;
         this.currentLoop = 0;
         if(this._snd != null)
         {
            this._duration = Math.floor(this._snd.length) / 1000;
         }
      }
      
      public function get currentLoop() : uint
      {
         return this._currentLoop;
      }
      
      public function set currentLoop(param1:uint) : void
      {
         this._currentLoop = param1;
         var _loc2_:LoopEvent = new LoopEvent(LoopEvent.SOUND_LOOP);
         _loc2_.loop = this._currentLoop;
         _loc2_.sound = this;
         dispatchEvent(_loc2_);
      }
      
      public function get position() : Number
      {
         var _loc1_:SoundChannel = null;
         if(this.soundData == null && this.sound == null)
         {
            return -1;
         }
         var _loc2_:Number = 0;
         if(this.soundData != null)
         {
            _loc2_ = Math.round(this.soundData.position / (8 * 44.1)) / 1000;
         }
         else
         {
            _loc1_ = Tubul.getInstance().soundMerger.getSoundChannel(this);
            if(_loc1_ != null)
            {
               _loc2_ = Math.round(_loc1_.position) / 1000;
            }
         }
         return _loc2_;
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function get sound() : Sound
      {
         return this._snd;
      }
      
      public function get loops() : int
      {
         return this._loops;
      }
      
      public function set loops(param1:int) : void
      {
         this._loops = param1;
      }
      
      public function get length() : Number
      {
         return this._length;
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(param1:Number) : void
      {
         this._volume = param1;
         var _loc2_:SoundTransform = this.getSoundTransform();
         _loc2_.volume = this._volume;
         this.applySoundTransform(_loc2_);
      }
      
      public function get leftToLeft() : Number
      {
         return this._leftToLeft;
      }
      
      public function set leftToLeft(param1:Number) : void
      {
         this._leftToLeft = param1;
         var _loc2_:SoundTransform = this.getSoundTransform();
         _loc2_.leftToLeft = this._leftToLeft;
         this.applySoundTransform(_loc2_);
      }
      
      public function get rightToLeft() : Number
      {
         return this._rightToLeft;
      }
      
      public function set rightToLeft(param1:Number) : void
      {
         this._rightToLeft = param1;
         var _loc2_:SoundTransform = this.getSoundTransform();
         _loc2_.rightToLeft = this._rightToLeft;
         this.applySoundTransform(_loc2_);
      }
      
      public function get rightToRight() : Number
      {
         return this._rightToRight;
      }
      
      public function set rightToRight(param1:Number) : void
      {
         this._rightToRight = param1;
         var _loc2_:SoundTransform = this.getSoundTransform();
         _loc2_.rightToRight = this._rightToRight;
         this.applySoundTransform(_loc2_);
      }
      
      public function get leftToRight() : Number
      {
         return this._leftToRight;
      }
      
      public function set leftToRight(param1:Number) : void
      {
         this._leftToRight = param1;
         var _loc2_:SoundTransform = this.getSoundTransform();
         _loc2_.leftToRight = this._leftToRight;
         this.applySoundTransform(_loc2_);
      }
      
      public function get pan() : Number
      {
         return this._pan;
      }
      
      public function set pan(param1:Number) : void
      {
         this._pan = param1;
         var _loc2_:SoundTransform = this.getSoundTransform();
         _loc2_.pan = this._pan;
         this.applySoundTransform(_loc2_);
      }
      
      function extractFinished() : void
      {
         this._extractFinished = true;
         this._snd = null;
      }
      
      public function checkSoundPosition() : void
      {
         var _loc1_:SoundWrapperEvent = null;
         if(this._notify == false)
         {
            return;
         }
         if(this.duration - this.position < this._notifyTime + 0.5)
         {
            if(this.currentLoop == this._loops - 1 && this._endOfFileEventDispatched == false)
            {
               _loc1_ = new SoundWrapperEvent(SoundWrapperEvent.SOON_END_OF_FILE);
               dispatchEvent(_loc1_);
               this._endOfFileEventDispatched = true;
            }
         }
         else
         {
            this._endOfFileEventDispatched = false;
         }
      }
      
      public function getSoundTransform() : SoundTransform
      {
         var _loc1_:* = undefined;
         if(this._stDic)
         {
            var _loc3_:int = 0;
            var _loc4_:* = this._stDic;
            for(_loc1_ in _loc4_)
            {
               return _loc1_;
            }
         }
         if(!this._stDic)
         {
            this._stDic = new Dictionary(true);
         }
         var _loc2_:SoundTransform = new SoundTransform(this._volume,this._pan);
         _loc2_.leftToLeft = this._leftToLeft;
         _loc2_.leftToRight = this._leftToRight;
         _loc2_.rightToLeft = this._rightToLeft;
         _loc2_.rightToRight = this._rightToRight;
         this._stDic[_loc2_] = true;
         return _loc2_;
      }
      
      public function notifyWhenEndOfFile(param1:Boolean = false, param2:Number = -1) : void
      {
         this._notify = param1;
         if(param1 && param2 <= 0)
         {
            this._notify = false;
            return;
         }
         this._notifyTime = param2;
      }
      
      private function applySoundTransform(param1:SoundTransform) : void
      {
         var _loc2_:SoundChannel = Tubul.getInstance().soundMerger.getSoundChannel(this);
         if(_loc2_ != null)
         {
            _loc2_.soundTransform = param1;
         }
      }
   }
}
