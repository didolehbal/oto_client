package com.ankamagames.dofus.kernel.sound.manager
{
   import com.ankamagames.dofus.datacenter.ambientSounds.AmbientSound;
   import com.ankamagames.dofus.datacenter.ambientSounds.PlaylistSound;
   import com.ankamagames.dofus.datacenter.playlists.Playlist;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.TubulSoundConfiguration;
   import com.ankamagames.dofus.kernel.sound.type.SoundDofus;
   import com.ankamagames.dofus.kernel.sound.utils.SoundUtil;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.protocolAudio.ProtocolEnum;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.tubul.enum.EnumSoundType;
   import com.ankamagames.tubul.factory.SoundFactory;
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.tubul.types.VolumeFadeEffect;
   import flash.utils.getQualifiedClassName;
   
   public class AmbientSoundsManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(AmbientSoundsManager));
       
      
      private var _useCriterion:Boolean = false;
      
      private var _criterionID:uint;
      
      private var _ambientSounds:Vector.<AmbientSound>;
      
      private var _roleplayMusics:Vector.<AmbientSound>;
      
      private var _roleplayPlaylist:Playlist;
      
      private var _ambiantPlaylist:Playlist;
      
      private var _music:ISound;
      
      private var _previousMusic:ISound;
      
      private var _ambience:ISound;
      
      private var _previousAmbience:ISound;
      
      private var _musicA:PlaylistSound;
      
      private var _ambienceA:PlaylistSound;
      
      private var _previousMusicId:String;
      
      private var _previousMusicPlaylistID:int;
      
      private var _previousAmbienceId:String;
      
      private var _previousAmbiancePlaylistId:int;
      
      private var tubulOption:OptionManager;
      
      public function AmbientSoundsManager()
      {
         super();
         this.init();
      }
      
      public function get music() : ISound
      {
         return this._music;
      }
      
      public function get ambience() : ISound
      {
         return this._ambience;
      }
      
      public function get criterionID() : uint
      {
         return this._criterionID;
      }
      
      public function set criterionID(param1:uint) : void
      {
         this._criterionID = param1;
      }
      
      public function get ambientSounds() : Vector.<AmbientSound>
      {
         return this._ambientSounds;
      }
      
      public function setAmbientSounds(param1:Vector.<AmbientSound>, param2:Vector.<AmbientSound>, param3:Playlist = null, param4:Playlist = null) : void
      {
         var _loc5_:PlaylistSound = null;
         this._ambientSounds = param1;
         this._roleplayMusics = param2;
         this._roleplayPlaylist = param3;
         this._ambiantPlaylist = param4;
         var _loc6_:* = "";
         if(this._ambientSounds.length == 0 && this._roleplayMusics.length == 0 && (!this._roleplayPlaylist || this._roleplayPlaylist.sounds.length == 0) && (!this._ambiantPlaylist || this._ambiantPlaylist.sounds.length == 0))
         {
            _loc6_ = "Ni musique ni ambiance pour cette map ??!!";
         }
         else
         {
            _loc6_ = "Cette map contient les ambiances d\'id : ";
            for each(_loc5_ in this._ambientSounds)
            {
               _loc6_ = _loc6_ + (_loc5_.id + ", ");
            }
            _loc6_ = _loc6_ + ", les musiques d\'id : ";
            for each(_loc5_ in this._roleplayMusics)
            {
               _loc6_ = _loc6_ + (_loc5_.id + ", ");
            }
            _loc6_ = _loc6_ + ", une playlist contenant les musique d\'id";
            if(this._roleplayPlaylist)
            {
               for each(_loc5_ in this._roleplayPlaylist.sounds)
               {
                  _loc6_ = _loc6_ + (_loc5_.id + ", ");
               }
            }
            _loc6_ = _loc6_ + "et une playlist contenant les ambiances d\'id";
            if(this._ambiantPlaylist)
            {
               for each(_loc5_ in this._ambiantPlaylist.sounds)
               {
                  _loc6_ = _loc6_ + (_loc5_.id + ", ");
               }
            }
         }
         _log.info(_loc6_);
      }
      
      public function selectValidSounds() : void
      {
         var _loc1_:int = 0;
         var _loc2_:PlaylistSound = null;
         var _loc3_:AmbientSound = null;
         var _loc4_:int = 0;
         if(this._ambiantPlaylist && this._ambiantPlaylist.sounds.length > 0)
         {
            _loc4_ = this._ambiantPlaylist.sounds.length;
            _loc1_ = int(int(Math.random() * _loc4_));
            for each(_loc2_ in this._ambiantPlaylist.sounds)
            {
               if(_loc1_ == 0)
               {
                  this._ambienceA = _loc2_;
                  break;
               }
               _loc1_--;
            }
         }
         else
         {
            for each(_loc3_ in this._ambientSounds)
            {
               if(!this._useCriterion || _loc3_.criterionId == this._criterionID)
               {
                  _loc4_++;
               }
            }
            _loc1_ = int(int(Math.random() * _loc4_));
            for each(_loc3_ in this._ambientSounds)
            {
               if(!this._useCriterion || _loc3_.criterionId == this._criterionID)
               {
                  if(_loc1_ == 0)
                  {
                     this._ambienceA = _loc3_;
                     break;
                  }
                  _loc1_--;
               }
            }
         }
         _loc4_ = 0;
         for each(_loc3_ in this._roleplayMusics)
         {
            if(!this._useCriterion || _loc3_.criterionId == this._criterionID)
            {
               _loc4_++;
            }
         }
         _loc1_ = int(int(Math.random() * _loc4_));
         if(this._roleplayPlaylist && this._roleplayPlaylist.sounds.length > 0)
         {
            _loc4_ = this._roleplayPlaylist.sounds.length;
            _loc1_ = int(int(Math.random() * _loc4_));
            for each(_loc2_ in this._roleplayPlaylist.sounds)
            {
               if(_loc1_ == 0)
               {
                  this._musicA = _loc2_;
                  break;
               }
               _loc1_--;
            }
         }
         else
         {
            for each(_loc3_ in this._roleplayMusics)
            {
               if(!this._useCriterion || _loc3_.criterionId == this._criterionID)
               {
                  if(_loc1_ == 0)
                  {
                     this._musicA = _loc3_;
                     break;
                  }
                  _loc1_--;
               }
            }
         }
      }
      
      public function playMusicAndAmbient() : void
      {
         var _loc1_:String = null;
         var _loc2_:Uri = null;
         var _loc3_:VolumeFadeEffect = null;
         var _loc4_:VolumeFadeEffect = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Uri = null;
         var _loc8_:VolumeFadeEffect = null;
         var _loc9_:VolumeFadeEffect = null;
         var _loc10_:int = 0;
         if(!SoundManager.getInstance().manager.soundIsActivate)
         {
            return;
         }
         if(SoundManager.getInstance().manager is RegSoundManager && !RegConnectionManager.getInstance().isMain)
         {
            return;
         }
         if(this._ambienceA == null)
         {
            _log.warn("It seems that we have no ambiance for this map");
         }
         else
         {
            if(this._previousAmbienceId == this._ambienceA.id || this._ambiantPlaylist && this._previousAmbiancePlaylistId == this._ambiantPlaylist.id)
            {
               _log.warn("Same ambiance as in the previous map, we just adjust its volume");
               this._ambience.volume = this._ambienceA.volume / 100;
            }
            else
            {
               if(this._previousAmbience != null)
               {
                  _loc4_ = new VolumeFadeEffect(-1,0,TubulSoundConfiguration.TIME_FADE_OUT_AMBIANCE);
                  this._previousAmbience.stop(_loc4_);
               }
               _loc1_ = SoundUtil.getConfigEntryByBusId(this._ambienceA.channel);
               _loc2_ = new Uri(_loc1_ + this._ambienceA.id + ".mp3");
               if(SoundManager.getInstance().manager is ClassicSoundManager)
               {
                  this._ambience = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,_loc2_);
                  this._ambience.busId = this._ambienceA.channel;
               }
               if(SoundManager.getInstance().manager is RegSoundManager)
               {
                  this._ambience = new SoundDofus(String(this._ambienceA.id));
               }
               this._ambience.volume = this._ambienceA.volume / 100;
               this._ambience.currentFadeVolume = 0;
               _loc3_ = new VolumeFadeEffect(-1,1,TubulSoundConfiguration.TIME_FADE_IN_AMBIANCE);
               _loc10_ = -1;
               if(this._ambiantPlaylist)
               {
                  if(this._ambiantPlaylist.iteration <= 0)
                  {
                     _loc10_ = 1;
                  }
                  else
                  {
                     _loc10_ = this._ambiantPlaylist.iteration;
                  }
               }
               if(this._ambiantPlaylist && this._ambiantPlaylist.sounds.length > 1)
               {
                  _loc5_ = this.createPlaylistSounds(this._ambiantPlaylist);
                  RegConnectionManager.getInstance().send(ProtocolEnum.ADD_SOUNDS_PLAYLIST,_loc5_);
               }
               this._ambience.play(true,_loc10_,_loc3_);
            }
            this._previousAmbienceId = this._ambienceA.id;
         }
         this._previousAmbience = this._ambience;
         if(this._ambiantPlaylist)
         {
            this._previousAmbiancePlaylistId = this._ambiantPlaylist.id;
         }
         if(this._musicA == null)
         {
            _log.warn("It seems that we have no music for this map");
         }
         else
         {
            if(this._previousMusicId == this._musicA.id || this._roleplayPlaylist && this._previousMusicPlaylistID == this._roleplayPlaylist.id)
            {
               _log.warn("Same music as in the previous map");
            }
            else
            {
               if(this._previousMusic != null)
               {
                  _loc9_ = new VolumeFadeEffect(-1,0,TubulSoundConfiguration.TIME_FADE_OUT_MUSIC);
                  this._previousMusic.stop(_loc9_);
               }
               _loc6_ = SoundUtil.getConfigEntryByBusId(this._musicA.channel);
               _loc7_ = new Uri(_loc6_ + this._musicA.id + ".mp3");
               if(SoundManager.getInstance().manager is ClassicSoundManager)
               {
                  this._music = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,_loc7_);
                  this._music.busId = this._musicA.channel;
               }
               if(SoundManager.getInstance().manager is RegSoundManager)
               {
                  this._music = new SoundDofus(String(this._musicA.id));
               }
               if(this._roleplayPlaylist)
               {
                  RegConnectionManager.getInstance().send(ProtocolEnum.SET_SILENCE,this._roleplayPlaylist.silenceDuration,this._roleplayPlaylist.silenceDuration);
               }
               else
               {
                  RegConnectionManager.getInstance().send(ProtocolEnum.SET_SILENCE,3,3);
               }
               this._music.volume = this._musicA.volume / 100;
               this._music.currentFadeVolume = 0;
               this.tubulOption = OptionManager.getOptionManager("tubul");
               if(this._roleplayPlaylist)
               {
                  _loc10_ = this._roleplayPlaylist.iteration;
               }
               if(_loc10_ <= 0)
               {
                  _loc10_ = 1;
               }
               this._music.play(true,_loc10_);
               if(this._roleplayPlaylist && this._roleplayPlaylist.sounds.length > 1)
               {
                  _loc5_ = this.createPlaylistSounds(this._roleplayPlaylist);
                  RegConnectionManager.getInstance().send(ProtocolEnum.ADD_SOUNDS_PLAYLIST,_loc5_);
               }
               this.tubulOption.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
               (_loc8_ = new VolumeFadeEffect(-1,1,TubulSoundConfiguration.TIME_FADE_IN_MUSIC)).attachToSoundSource(this._music);
               _loc8_.start();
            }
            this._previousMusicId = this._musicA.id;
         }
         this._previousMusic = this._music;
         if(this._roleplayPlaylist)
         {
            this._previousMusicPlaylistID = this._roleplayPlaylist.id;
         }
      }
      
      public function stopMusicAndAmbient() : void
      {
         if(this.ambience)
         {
            this.ambience.stop();
         }
         if(this.music)
         {
            this.music.stop();
         }
         this._previousAmbienceId = "";
         this._previousMusicId = "";
         this._previousAmbiancePlaylistId = -1;
         this._previousMusicPlaylistID = -1;
         if(this.tubulOption)
         {
            this.tubulOption.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         }
      }
      
      public function mergeSoundsArea(param1:Vector.<AmbientSound>) : void
      {
      }
      
      public function clear(param1:Number = 0, param2:Number = 0) : void
      {
         this.stopMusicAndAmbient();
      }
      
      private function init() : void
      {
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.propertyName != "infiniteLoopMusics")
         {
            return;
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.OPTION_MUSIC_LOOP_VALUE_CHANGED,param1.propertyValue);
      }
      
      private function createPlaylistSounds(param1:Playlist) : Array
      {
         var _loc2_:PlaylistSound = null;
         var _loc3_:ISound = null;
         var _loc4_:Uri = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Array = new Array();
         for each(_loc2_ in param1.sounds)
         {
            if(_loc2_.id != this._musicA.id)
            {
               _loc5_ = SoundUtil.getConfigEntryByBusId(_loc2_.channel);
               _loc4_ = new Uri(_loc5_ + _loc2_.id + ".mp3");
               if(SoundManager.getInstance().manager is ClassicSoundManager)
               {
                  _loc3_ = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,_loc4_);
                  _loc3_.busId = _loc2_.channel;
               }
               if(SoundManager.getInstance().manager is RegSoundManager)
               {
                  _loc3_ = new SoundDofus(String(_loc2_.id));
               }
               if((_loc6_ = param1.iteration) <= 0)
               {
                  _loc6_ = 1;
               }
               _loc3_.setLoops(_loc6_);
               _loc3_.volume = _loc2_.volume / 100;
               _loc3_.currentFadeVolume = 0;
               _loc7_.push(_loc3_.id);
            }
         }
         return _loc7_;
      }
   }
}
