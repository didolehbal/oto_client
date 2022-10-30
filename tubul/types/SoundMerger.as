package com.ankamagames.tubul.types
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.SampleDataEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class SoundMerger extends EventDispatcher
   {
      
      private static const DATA_SAMPLES_BUFFER_SIZE:uint = 4096;
      
      private static const SILENCE_SAMPLES_BUFFER_SIZE:uint = 2048;
      
      public static const MINIMAL_LENGTH_TO_MERGE:uint = 3500;
      
      public static const MAXIMAL_LENGTH_TO_MERGE:uint = 10000;
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(SoundMerger));
       
      
      private var _output:Sound;
      
      private var _outputChannel:SoundChannel;
      
      private var _sounds:Vector.<SoundWrapper>;
      
      private var _soundsCount:uint;
      
      private var _directlyPlayed:Dictionary;
      
      private var _directChannels:Dictionary;
      
      private var _outputBytes:ByteArray;
      
      private var _cuttingBytes:ByteArray;
      
      public function SoundMerger()
      {
         super();
         this.init();
      }
      
      public function getSoundChannel(param1:SoundWrapper) : SoundChannel
      {
         return this._directlyPlayed[param1];
      }
      
      public function addSound(param1:SoundWrapper) : void
      {
         this.directPlay(param1,param1.loops);
      }
      
      public function removeSound(param1:SoundWrapper) : void
      {
         var _loc2_:int = this._sounds.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._sounds.splice(_loc2_,1);
            param1.dispatchEvent(new Event(Event.SOUND_COMPLETE));
            if(!--this._soundsCount)
            {
               this.setSilence(true);
            }
         }
         else if(this._directlyPlayed[param1])
         {
            this.directStop(param1);
         }
      }
      
      private function init() : void
      {
         this._sounds = new Vector.<SoundWrapper>();
         this._directlyPlayed = new Dictionary();
         this._directChannels = new Dictionary();
         this._cuttingBytes = new ByteArray();
         this._output = new Sound();
         this._output.addEventListener(SampleDataEvent.SAMPLE_DATA,this.sampleSilence);
         this._outputChannel = this._output.play();
         StageShareManager.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function setSilence(param1:Boolean) : void
      {
         if(param1)
         {
            this._output.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.sampleData);
            this._output.addEventListener(SampleDataEvent.SAMPLE_DATA,this.sampleSilence);
         }
         else
         {
            this._output.addEventListener(SampleDataEvent.SAMPLE_DATA,this.sampleData);
            this._output.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.sampleSilence);
         }
      }
      
      private function directPlay(param1:SoundWrapper, param2:int) : void
      {
         var _loc3_:SoundChannel = null;
         if(!StageShareManager.stage.hasEventListener(Event.ENTER_FRAME))
         {
            StageShareManager.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         _loc3_ = param1.sound.play(0,1,param1.getSoundTransform());
         if(_loc3_ == null)
         {
            _log.error("directChannel is null !");
            return;
         }
         if(this._directlyPlayed[param1] != null)
         {
            this._directChannels[this._directlyPlayed[param1]] = null;
            delete this._directChannels[this._directlyPlayed[param1]];
         }
         this._directlyPlayed[param1] = _loc3_;
         this._directChannels[_loc3_] = param1;
         if(!_loc3_.hasEventListener(Event.SOUND_COMPLETE))
         {
            _loc3_.addEventListener(Event.SOUND_COMPLETE,this.directSoundComplete);
         }
      }
      
      private function directStop(param1:SoundWrapper, param2:Boolean = false) : void
      {
         var _loc3_:SoundChannel = this._directlyPlayed[param1];
         _loc3_.removeEventListener(Event.SOUND_COMPLETE,this.directSoundComplete);
         _loc3_.stop();
         param1.currentLoop = 0;
         if(!param2)
         {
            param1.dispatchEvent(new Event(Event.SOUND_COMPLETE));
         }
         delete this._directlyPlayed[param1];
         delete this._directChannels[_loc3_];
         if(StageShareManager.stage.hasEventListener(Event.ENTER_FRAME) && this._directChannels.length == 0)
         {
            StageShareManager.stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function sampleData(param1:SampleDataEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:ByteArray = null;
         var _loc13_:SoundWrapper = null;
         var _loc14_:* = false;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Boolean = false;
         var _loc20_:uint = getTimer();
         var _loc21_:ByteArray = param1.data;
         _loc10_ = 0;
         while(_loc10_ < this._soundsCount)
         {
            if(!(_loc13_ = this._sounds[_loc10_] as SoundWrapper)._extractFinished)
            {
               _loc3_ = DATA_SAMPLES_BUFFER_SIZE;
               _loc2_ = _loc13_.soundData.position;
               _loc19_ = true;
               do
               {
                  if(_loc2_ == 0 && _loc19_)
                  {
                     _loc4_ = _loc13_.sound.extract(_loc13_.soundData,_loc3_,0);
                  }
                  else
                  {
                     _loc4_ = _loc13_.sound.extract(_loc13_.soundData,_loc3_);
                  }
                  _loc19_ = false;
                  _loc14_ = _loc4_ != _loc3_;
                  if(!_loc13_.hadBeenCut && (_loc13_.loops == 0 || _loc13_.loops > 1))
                  {
                     ++_loc13_.currentLoop;
                     _loc13_.soundData.position = _loc8_;
                     _loc9_ = 0;
                     while(_loc9_ < _loc4_)
                     {
                        _loc5_ = _loc13_.soundData.readFloat();
                        _loc6_ = _loc13_.soundData.readFloat();
                        if(_loc5_ > 0.001 || _loc5_ < -0.001 || _loc6_ > 0.001 || _loc6_ < -0.001)
                        {
                           _loc13_.hadBeenCut = true;
                           break;
                        }
                        _loc9_++;
                     }
                     _loc7_ = _loc9_ + 1;
                     _loc9_ = _loc9_ + 1;
                     while(_loc9_ < _loc4_)
                     {
                        this._cuttingBytes.writeFloat(_loc13_.soundData.readFloat());
                        this._cuttingBytes.writeFloat(_loc13_.soundData.readFloat());
                        _loc9_++;
                     }
                     if(this._cuttingBytes.length > 0)
                     {
                        _loc3_ = _loc3_ + _loc7_;
                        _loc12_ = _loc13_.soundData;
                        _loc13_.soundData = this._cuttingBytes;
                        this._cuttingBytes = _loc12_;
                        this._cuttingBytes.clear();
                     }
                     else
                     {
                        _loc8_ = _loc8_ + DATA_SAMPLES_BUFFER_SIZE * 8;
                        _loc3_ = _loc3_ + DATA_SAMPLES_BUFFER_SIZE;
                     }
                  }
                  if(_loc14_)
                  {
                     _loc13_.extractFinished();
                     break;
                  }
                  _loc3_ = _loc3_ - _loc4_;
               }
               while(_loc3_ > 0);
               
               _loc13_.soundData.position = _loc2_;
            }
            _loc10_++;
         }
         _loc9_ = 0;
         while(_loc9_ < DATA_SAMPLES_BUFFER_SIZE)
         {
            _loc15_ = _loc16_ = 0;
            _loc10_ = 0;
            for(; _loc10_ < this._soundsCount; _loc10_++)
            {
               if(_loc9_ == 0)
               {
                  _loc13_.checkSoundPosition();
               }
               if((_loc13_ = this._sounds[_loc10_] as SoundWrapper).soundData.bytesAvailable < 8)
               {
                  if(_loc13_.loops == 0 || _loc13_.loops > 1 && _loc13_.currentLoop + 1 < _loc13_.loops)
                  {
                     _loc13_.soundData.position = 0;
                     ++_loc13_.currentLoop;
                     continue;
                  }
                  this.removeSound(_loc13_);
                  break;
               }
               _loc17_ = _loc13_.soundData.readFloat() * _loc13_._volume * (1 - _loc13_._pan);
               _loc18_ = _loc13_.soundData.readFloat() * _loc13_._volume * (1 + _loc13_._pan);
               _loc15_ = _loc15_ + (_loc17_ * _loc13_._leftToLeft + _loc18_ * _loc13_._rightToLeft);
               _loc16_ = _loc16_ + (_loc17_ * _loc13_._leftToRight + _loc18_ * _loc13_._rightToRight);
            }
            if(_loc15_ > 1)
            {
               _loc15_ = 1;
            }
            if(_loc15_ < -1)
            {
               _loc15_ = -1;
            }
            if(_loc16_ > 1)
            {
               _loc16_ = 1;
            }
            if(_loc16_ < -1)
            {
               _loc16_ = -1;
            }
            _loc21_.writeFloat(_loc15_);
            _loc21_.writeFloat(_loc16_);
            _loc9_++;
         }
      }
      
      private function sampleSilence(param1:SampleDataEvent) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < SILENCE_SAMPLES_BUFFER_SIZE)
         {
            param1.data.writeFloat(0);
            param1.data.writeFloat(0);
            _loc2_++;
         }
      }
      
      private function directSoundComplete(param1:Event) : void
      {
         var _loc2_:SoundWrapper = this._directChannels[param1.target];
         ++_loc2_.currentLoop;
         if(_loc2_.currentLoop < _loc2_.loops || _loc2_.loops == 0)
         {
            this.directPlay(_loc2_,_loc2_.loops);
         }
         else
         {
            this.directStop(_loc2_,true);
            _loc2_.dispatchEvent(param1);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:SoundWrapper = null;
         for each(_loc2_ in this._directChannels)
         {
            _loc2_.checkSoundPosition();
         }
      }
   }
}
