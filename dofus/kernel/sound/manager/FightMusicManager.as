package com.ankamagames.dofus.kernel.sound.manager
{
   import com.ankamagames.dofus.datacenter.ambientSounds.AmbientSound;
   import com.ankamagames.dofus.datacenter.ambientSounds.PlaylistSound;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.playlists.Playlist;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.TubulSoundConfiguration;
   import com.ankamagames.dofus.kernel.sound.type.SoundDofus;
   import com.ankamagames.dofus.kernel.sound.utils.SoundUtil;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.jerakine.BalanceManager.BalanceManager;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.protocolAudio.ProtocolEnum;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tubul.enum.EnumSoundType;
   import com.ankamagames.tubul.factory.SoundFactory;
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.tubul.types.VolumeFadeEffect;
   import flash.utils.getQualifiedClassName;
   
   public class FightMusicManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(FightMusicManager));
       
      
      private var _fightMusics:Vector.<AmbientSound>;
      
      private var _bossMusics:Vector.<AmbientSound>;
      
      private var _fightMusic:PlaylistSound;
      
      private var _bossMusic:PlaylistSound;
      
      private var _hasBoss:Boolean;
      
      private var _fightMusicsId:Array;
      
      private var _fightMusicBalanceManager:BalanceManager;
      
      private var _actualFightMusic:ISound;
      
      private var _fightMusicPlaylist:Playlist;
      
      private var _bossMusicPlaylist:Playlist;
      
      public function FightMusicManager()
      {
         super();
         this.init();
      }
      
      public function prepareFightMusic() : void
      {
         if(SoundManager.getInstance().manager is RegSoundManager && !RegConnectionManager.getInstance().isMain)
         {
            return;
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.PREPARE_FIGHT_MUSIC);
      }
      
      public function isBossBattle() : void
      {
         var _loc1_:GameContextActorInformations = null;
         var _loc2_:GameFightMonsterInformations = null;
         var _loc3_:Monster = null;
         this._hasBoss = false;
         var _loc4_:FightEntitiesFrame;
         if(_loc4_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame)
         {
            for each(_loc1_ in _loc4_.getEntitiesDictionnary())
            {
               if(_loc1_ is GameFightMonsterInformations)
               {
                  _loc2_ = _loc1_ as GameFightMonsterInformations;
                  _loc3_ = Monster.getMonsterById(_loc2_.creatureGenericId);
                  if(_loc3_.isBoss)
                  {
                     this._hasBoss = true;
                  }
               }
            }
         }
      }
      
      public function startFightPlaylist(param1:Number = -1, param2:Number = 1) : void
      {
         var _loc3_:PlaylistSound = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:Uri = null;
         var _loc7_:VolumeFadeEffect = null;
         var _loc8_:Array = null;
         if(!SoundManager.getInstance().manager.soundIsActivate)
         {
            return;
         }
         if(SoundManager.getInstance().manager is RegSoundManager && !RegConnectionManager.getInstance().isMain)
         {
            return;
         }
         if(this._hasBoss && this._bossMusic)
         {
            _loc3_ = this._bossMusic;
         }
         else
         {
            _loc3_ = this._fightMusic;
         }
         if(_loc3_)
         {
            _loc4_ = SoundUtil.getBusIdBySoundId(String(_loc3_.id));
            _loc5_ = SoundUtil.getConfigEntryByBusId(_loc4_);
            _loc6_ = new Uri(_loc5_ + _loc3_.id + ".mp3");
            if(SoundManager.getInstance().manager is ClassicSoundManager)
            {
               this._actualFightMusic = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,_loc6_);
            }
            if(SoundManager.getInstance().manager is RegSoundManager)
            {
               this._actualFightMusic = new SoundDofus(String(_loc3_.id));
            }
            this._actualFightMusic.busId = _loc4_;
            this._actualFightMusic.volume = 1;
            this._actualFightMusic.currentFadeVolume = 0;
            _loc7_ = new VolumeFadeEffect(param1,param2,TubulSoundConfiguration.TIME_FADE_IN_MUSIC);
            _loc8_ = new Array();
            if(this._hasBoss && this._bossMusicPlaylist)
            {
               _loc8_ = this.createPlaylistSounds(this._bossMusicPlaylist);
            }
            else if(this._fightMusicPlaylist)
            {
               _loc8_ = this.createPlaylistSounds(this._fightMusicPlaylist);
            }
            if(_loc8_.length > 0)
            {
               RegConnectionManager.getInstance().send(ProtocolEnum.ADD_SOUNDS_PLAYLIST,_loc8_);
            }
            this._actualFightMusic.play(true,0,_loc7_);
         }
      }
      
      public function stopFightMusic() : void
      {
         if(!SoundManager.getInstance().manager.soundIsActivate)
         {
            return;
         }
         if(SoundManager.getInstance().manager is RegSoundManager && !RegConnectionManager.getInstance().isMain)
         {
            return;
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.STOP_FIGHT_MUSIC);
      }
      
      public function setFightSounds(param1:Vector.<AmbientSound>, param2:Vector.<AmbientSound>, param3:Playlist, param4:Playlist) : void
      {
         var _loc5_:AmbientSound = null;
         this._fightMusics = param1;
         this._bossMusics = param2;
         this._fightMusicPlaylist = param3;
         this._bossMusicPlaylist = param4;
         var _loc6_:* = "";
         if(this._fightMusics.length == 0 && this._bossMusics.length == 0 && (!this._fightMusicPlaylist || this._fightMusicPlaylist.sounds.length == 0) && (!this._bossMusicPlaylist || this._bossMusicPlaylist.sounds.length == 0))
         {
            _loc6_ = "Ni musique de combat, ni musique de boss ???";
         }
         else
         {
            _loc6_ = "Cette map contient les musiques de combat : ";
            for each(_loc5_ in this._fightMusics)
            {
               _loc6_ = _loc6_ + (_loc5_.id + ", ");
            }
            _loc6_ = " et les musiques de boss d\'id : ";
            for each(_loc5_ in this._bossMusics)
            {
               _loc6_ = _loc6_ + (_loc5_.id + ", ");
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
         if(this._fightMusicPlaylist && this._fightMusicPlaylist.sounds.length > 0)
         {
            _loc4_ = this._fightMusicPlaylist.sounds.length;
            _loc1_ = int(int(Math.random() * _loc4_));
            for each(_loc2_ in this._fightMusicPlaylist.sounds)
            {
               if(_loc1_ == 0)
               {
                  this._fightMusic = _loc2_;
                  break;
               }
               _loc1_--;
            }
         }
         else
         {
            for each(_loc3_ in this._fightMusics)
            {
               _loc4_++;
            }
            _loc1_ = int(int(Math.random() * _loc4_));
            for each(_loc3_ in this._fightMusics)
            {
               if(_loc1_ == 0)
               {
                  this._fightMusic = _loc3_;
                  break;
               }
               _loc1_--;
            }
         }
         if(this._bossMusicPlaylist && this._bossMusicPlaylist.sounds.length > 0)
         {
            _loc4_ = this._bossMusicPlaylist.sounds.length;
            _loc1_ = int(int(Math.random() * _loc4_));
            for each(_loc2_ in this._bossMusicPlaylist.sounds)
            {
               if(_loc1_ == 0)
               {
                  this._bossMusic = _loc2_;
                  break;
               }
               _loc1_--;
            }
         }
         else
         {
            for each(_loc3_ in this._bossMusics)
            {
               _loc4_++;
            }
            _loc1_ = int(int(Math.random() * _loc4_));
            for each(_loc3_ in this._bossMusics)
            {
               if(_loc1_ == 0)
               {
                  this._bossMusic = _loc3_;
                  break;
               }
               _loc1_--;
            }
         }
      }
      
      private function init() : void
      {
         this._fightMusicsId = TubulSoundConfiguration.fightMusicIds;
         this._fightMusicBalanceManager = new BalanceManager(this._fightMusicsId);
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
            if(!(this._fightMusic && _loc2_.id == this._fightMusic.id || this._bossMusic && _loc2_.id == this._bossMusic.id))
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
