package com.ankamagames.dofus.kernel.sound.manager
{
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.types.WorldEntitySprite;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.ambientSounds.AmbientSound;
   import com.ankamagames.dofus.datacenter.playlists.Playlist;
   import com.ankamagames.dofus.datacenter.sounds.SoundAnimation;
   import com.ankamagames.dofus.datacenter.sounds.SoundBones;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.TubulSoundConfiguration;
   import com.ankamagames.dofus.kernel.sound.type.SoundDofus;
   import com.ankamagames.dofus.kernel.sound.utils.SoundUtil;
   import com.ankamagames.dofus.logic.game.common.frames.AbstractEntitiesFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.types.enums.PlaylistTypeEnum;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.protocolAudio.ProtocolEnum;
   import com.ankamagames.jerakine.types.SoundEventParamWrapper;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.parser.FLAEventLabelParser;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.tubul.enum.EnumSoundType;
   import com.ankamagames.tubul.events.AudioBusEvent;
   import com.ankamagames.tubul.events.SoundCompleteEvent;
   import com.ankamagames.tubul.factory.SoundFactory;
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.tubul.types.PlayListPlayer;
   import com.ankamagames.tubul.types.VolumeFadeEffect;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.filesystem.File;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class RegSoundManager extends EventDispatcher implements ISoundManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RegSoundManager));
      
      private static var _self:ISoundManager;
       
      
      private var _previousSubareaId:int;
      
      private var _criterionSubarea:int;
      
      private var _entitySounds:Array;
      
      private var _reverseEntitySounds:Dictionary;
      
      private var _entityDictionary:Dictionary;
      
      private var _adminSounds:Dictionary;
      
      private var _ambientManager:AmbientSoundsManager;
      
      private var _localizedSoundsManager:LocalizedSoundsManager;
      
      private var _fightMusicManager:FightMusicManager;
      
      private var _forceSounds:Boolean = true;
      
      private var _soundDirectoryExist:Boolean = true;
      
      private var _inFight:Boolean;
      
      private var _adminPlaylist:PlayListPlayer;
      
      private var _stopableSounds:Array;
      
      public function RegSoundManager()
      {
         super();
         this.init();
      }
      
      public function set soundDirectoryExist(param1:Boolean) : void
      {
         this._soundDirectoryExist = param1;
      }
      
      public function get soundDirectoryExist() : Boolean
      {
         return this._soundDirectoryExist;
      }
      
      public function get soundIsActivate() : Boolean
      {
         return this.checkIfAvailable();
      }
      
      public function get entitySounds() : Array
      {
         return this._entitySounds;
      }
      
      public function get reverseEntitySounds() : Dictionary
      {
         return this._reverseEntitySounds;
      }
      
      public function set forceSoundsDebugMode(param1:Boolean) : void
      {
         this._forceSounds = param1;
      }
      
      public function playMainClientSounds() : void
      {
         if(this._localizedSoundsManager != null && this._localizedSoundsManager.isInitialized)
         {
            this._localizedSoundsManager.playLocalizedSounds();
         }
         if(this._ambientManager != null)
         {
            this._ambientManager.playMusicAndAmbient();
         }
         if(this._fightMusicManager != null && this._inFight)
         {
            this._fightMusicManager.startFightPlaylist();
         }
         this.playIntroMusic();
         SoundManager.getInstance().setSoundOptions();
      }
      
      public function stopMainClientSounds() : void
      {
         if(this._localizedSoundsManager != null && this._localizedSoundsManager.isInitialized)
         {
            this._localizedSoundsManager.stopLocalizedSounds();
         }
         if(this._ambientManager != null)
         {
            this._ambientManager.stopMusicAndAmbient();
         }
         if(this._fightMusicManager != null && this._inFight)
         {
            this._fightMusicManager.stopFightMusic();
         }
         this.stopAllStopableSounds();
         this.stopIntroMusic(true);
      }
      
      public function activateSound() : void
      {
         this._forceSounds = true;
         this.playMainClientSounds();
      }
      
      public function deactivateSound() : void
      {
         this.stopMainClientSounds();
         this._forceSounds = false;
         RegConnectionManager.getInstance().send(ProtocolEnum.DEACTIVATE_SOUNDS);
      }
      
      public function setSubArea(param1:Map = null) : void
      {
         var _loc2_:AmbientSound = null;
         var _loc3_:AmbientSound = null;
         var _loc4_:Playlist = null;
         var _loc5_:Playlist = null;
         var _loc6_:Playlist = null;
         var _loc7_:Playlist = null;
         var _loc8_:Vector.<int> = null;
         var _loc9_:Vector.<int> = null;
         var _loc13_:int = 0;
         var _loc10_:MapPosition = MapPosition.getMapPositionById(param1.id);
         this.removeLocalizedSounds();
         this._localizedSoundsManager.setMap(param1);
         if(this.soundIsActivate && RegConnectionManager.getInstance().isMain)
         {
            this._localizedSoundsManager.playLocalizedSounds();
         }
         this._previousSubareaId = param1.subareaId;
         this._criterionSubarea = 1;
         var _loc11_:SubArea;
         if((_loc11_ = SubArea.getSubAreaById(param1.subareaId)) == null)
         {
            return;
         }
         var _loc12_:Vector.<Vector.<AmbientSound>> = new Vector.<Vector.<AmbientSound>>();
         while(_loc13_ < 4)
         {
            _loc12_[_loc13_] = new Vector.<AmbientSound>();
            _loc13_++;
         }
         if(_loc10_)
         {
            for each(_loc2_ in _loc10_.sounds)
            {
               _loc3_ = new AmbientSound();
               _loc3_.channel = _loc2_.channel;
               _loc3_.criterionId = _loc2_.criterionId;
               _loc3_.id = _loc2_.id;
               _loc3_.silenceMax = _loc2_.silenceMax;
               _loc3_.silenceMin = _loc2_.silenceMin;
               _loc3_.volume = _loc2_.volume;
               _loc12_[_loc2_.type_id - 1].push(_loc3_);
            }
         }
         for each(_loc2_ in _loc11_.ambientSounds)
         {
            if(!(_loc2_.type_id == 2 && _loc12_[_loc2_.type_id - 1].length == 1))
            {
               _loc3_ = new AmbientSound();
               _loc3_.channel = _loc2_.channel;
               _loc3_.criterionId = _loc2_.criterionId;
               _loc3_.id = _loc2_.id;
               _loc3_.silenceMax = _loc2_.silenceMax;
               _loc3_.silenceMin = _loc2_.silenceMin;
               _loc3_.volume = _loc2_.volume;
               _loc12_[_loc2_.type_id - 1].push(_loc3_);
            }
         }
         _log.info("Subarea Id : " + _loc11_.id + " / Map id : " + param1.id);
         if(_loc10_.playlists && _loc10_.playlists.length > 0)
         {
            for each(_loc9_ in _loc10_.playlists)
            {
               if(_loc9_[0] == PlaylistTypeEnum.ROLEPLAY_MUSIC)
               {
                  _loc4_ = Playlist.getPlaylistById(_loc9_[1]);
               }
               if(_loc9_[0] == PlaylistTypeEnum.AMBIANCE_MUSIC)
               {
                  _loc5_ = Playlist.getPlaylistById(_loc9_[1]);
               }
               if(_loc9_[0] == PlaylistTypeEnum.COMBAT_MUSIC)
               {
                  _loc6_ = Playlist.getPlaylistById(_loc9_[1]);
               }
               if(_loc9_[0] == PlaylistTypeEnum.BOSS_MUSIC)
               {
                  _loc7_ = Playlist.getPlaylistById(_loc9_[1]);
               }
            }
         }
         for each(_loc8_ in _loc11_.playlists)
         {
            if(_loc8_[0] == PlaylistTypeEnum.ROLEPLAY_MUSIC && !_loc4_)
            {
               _loc4_ = Playlist.getPlaylistById(_loc8_[1]);
            }
            if(_loc8_[0] == PlaylistTypeEnum.AMBIANCE_MUSIC && !_loc5_)
            {
               _loc5_ = Playlist.getPlaylistById(_loc8_[1]);
            }
            if(_loc8_[0] == PlaylistTypeEnum.COMBAT_MUSIC && !_loc6_)
            {
               _loc6_ = Playlist.getPlaylistById(_loc8_[1]);
            }
            if(_loc8_[0] == PlaylistTypeEnum.BOSS_MUSIC && !_loc7_)
            {
               _loc7_ = Playlist.getPlaylistById(_loc8_[1]);
            }
         }
         this._ambientManager.setAmbientSounds(_loc12_[1],_loc12_[0],_loc4_,_loc5_);
         this._ambientManager.selectValidSounds();
         this._ambientManager.playMusicAndAmbient();
         this._fightMusicManager.setFightSounds(_loc12_[2],_loc12_[3],_loc6_,_loc7_);
      }
      
      public function playUISound(param1:String, param2:Boolean = false) : void
      {
         if(!this.checkIfAvailable())
         {
            return;
         }
         var _loc3_:SoundDofus = new SoundDofus(param1);
         _loc3_.play(param2);
      }
      
      public function playSound(param1:ISound, param2:Boolean = false, param3:int = -1) : ISound
      {
         var _loc4_:* = null;
         if(!this.checkIfAvailable())
         {
            return null;
         }
         var _loc5_:String = param1.uri.fileName.split(".mp3")[0];
         var _loc6_:SoundDofus = new SoundDofus(_loc5_,true);
         for(_loc4_ in param1)
         {
            if(_loc6_.hasOwnProperty(_loc4_))
            {
               _loc6_[_loc4_] = param1;
            }
         }
         _loc6_.play(param2,param3);
         return _loc6_;
      }
      
      public function upFightMusicVolume() : void
      {
         this._inFight = true;
         this.fadeBusVolume(TubulSoundConfiguration.BUS_FIGHT_MUSIC_ID,1,0);
      }
      
      public function playFightMusic() : void
      {
         this._fightMusicManager.prepareFightMusic();
         this._fightMusicManager.selectValidSounds();
         this._fightMusicManager.isBossBattle();
         this._fightMusicManager.startFightPlaylist();
      }
      
      public function stopFightMusic() : void
      {
         this._inFight = false;
         this._fightMusicManager.stopFightMusic();
      }
      
      public function handleFLAEvent(param1:String, param2:String, param3:String, param4:Object = null) : void
      {
         var _loc5_:TiphonSprite = null;
         var _loc6_:Object = null;
         if(!(this.soundIsActivate && RegConnectionManager.getInstance().isMain))
         {
            return;
         }
         if(param4 is TiphonSprite && TiphonSprite(param4).parentSprite && TiphonSprite(param4).parentSprite.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET,0))
         {
            return;
         }
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         var _loc9_:int = -1;
         if(param4.hasOwnProperty("absoluteBounds"))
         {
            _loc7_ = param4.absoluteBounds.x;
            _loc8_ = param4.absoluteBounds.y;
            if((_loc9_ = param4.id) != PlayedCharacterManager.getInstance().id && _loc9_ > 0 && Kernel.getWorker().getFrame(FightBattleFrame) == null)
            {
               return;
            }
         }
         else if(param4 is WorldEntitySprite)
         {
            _loc7_ = InteractiveCellManager.getInstance().getCell((param4 as WorldEntitySprite).cellId).x;
            _loc8_ = InteractiveCellManager.getInstance().getCell((param4 as WorldEntitySprite).cellId).y;
            _loc9_ = (param4 as WorldEntitySprite).identifier;
         }
         else
         {
            if(!(param4 is TiphonSprite))
            {
               return;
            }
            if(!((_loc5_ = param4 as TiphonSprite).parentSprite is TiphonSprite))
            {
               return;
            }
            if(_loc5_.parentSprite.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) != null)
            {
               if((_loc6_ = _loc5_.parentSprite).hasOwnProperty("absoluteBounds"))
               {
                  _loc7_ = _loc6_.absoluteBounds.x;
                  _loc8_ = _loc6_.absoluteBounds.y;
                  if((_loc9_ = _loc6_.id) != PlayedCharacterManager.getInstance().id && _loc9_ > 0 && Kernel.getWorker().getFrame(FightBattleFrame) == null)
                  {
                     return;
                  }
               }
            }
         }
         switch(param2)
         {
            case "Sound":
               param3 = param3 + "*";
               break;
            case "DataSound":
               param3 = this.buildSoundLabel(_loc9_,param1,param3) + "*";
         }
         var _loc10_:int = -1;
         if(param4.look.skins)
         {
            _loc10_ = TiphonEntityLook(param4.look).firstSkin;
         }
         if(param3)
         {
            RegConnectionManager.getInstance().send(ProtocolEnum.FLA_EVENT,param3,_loc9_,_loc7_,_loc8_,_loc10_);
         }
      }
      
      public function applyDynamicMix(param1:VolumeFadeEffect, param2:uint, param3:VolumeFadeEffect) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.DYNAMIC_MIX,RegConnectionManager.getInstance().socketClientID,param1.endingValue,param1.timeFade,param2,param3.timeFade);
      }
      
      public function retriveRollOffPresets() : void
      {
      }
      
      public function setSoundSourcePosition(param1:int, param2:Point) : void
      {
         if(!this.checkIfAvailable())
         {
            return;
         }
         if(param1 == PlayedCharacterManager.getInstance().id)
         {
            RegConnectionManager.getInstance().send(ProtocolEnum.SET_PLAYER_POSITION,RegConnectionManager.getInstance().socketClientID,param2.x,param2.y);
         }
         else
         {
            RegConnectionManager.getInstance().send(ProtocolEnum.SET_SOUND_SOURCE_POSITION,RegConnectionManager.getInstance().socketClientID,this._entitySounds[param1],param2.x,param2.y);
         }
      }
      
      public function addSoundEntity(param1:ISound, param2:int) : void
      {
         if(!this.checkIfAvailable())
         {
            return;
         }
         if(this._entitySounds[param2] == null)
         {
            this._entitySounds[param2] = new Vector.<ISound>();
         }
         this._entityDictionary[DofusEntities.getEntity(param2)] = this._entitySounds[param2];
         this._entitySounds[param2].push(param1);
         this._reverseEntitySounds[param1] = param2;
      }
      
      public function removeSoundEntity(param1:ISound) : void
      {
         var _loc2_:ISound = null;
         var _loc3_:int = this._reverseEntitySounds[param1];
         if(!this._entitySounds[_loc3_])
         {
            return;
         }
         for each(_loc2_ in this._entitySounds[_loc3_])
         {
            if(_loc2_ == param1)
            {
               _loc2_.stop();
               this._entitySounds[_loc3_].splice(this._entitySounds[_loc3_].indexOf(_loc2_),1);
               delete this._reverseEntitySounds[param1];
               if(this._entitySounds[_loc3_].length == 0)
               {
                  this._entitySounds[_loc3_] = null;
               }
               return;
            }
         }
      }
      
      public function removeEntitySound(param1:IEntity) : void
      {
         var _loc2_:ISound = null;
         var _loc3_:VolumeFadeEffect = null;
         if(this._entityDictionary[param1] == null)
         {
            return;
         }
         for each(_loc2_ in this._entityDictionary[param1])
         {
            _loc3_ = new VolumeFadeEffect(-1,0,0.1);
            _loc2_.stop(_loc3_);
         }
         delete this._entityDictionary[param1];
      }
      
      public function retriveXMLSounds() : void
      {
      }
      
      private function playIntro() : void
      {
      }
      
      public function playIntroMusic(param1:Boolean = true) : void
      {
         if(!(this.soundIsActivate && RegConnectionManager.getInstance().isMain))
         {
            return;
         }
         var _loc2_:SystemApi = new SystemApi();
         if(_loc2_.isInGame())
         {
            return;
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.PLAY_INTRO,RegConnectionManager.getInstance().socketClientID);
      }
      
      public function switchIntroMusic(param1:Boolean) : void
      {
         if(!(this.soundIsActivate && RegConnectionManager.getInstance().isMain))
         {
            return;
         }
         var _loc2_:SystemApi = new SystemApi();
         if(_loc2_.isInGame())
         {
            return;
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.SWITCH_INTRO,RegConnectionManager.getInstance().socketClientID,param1);
      }
      
      public function stopIntroMusic(param1:Boolean = false) : void
      {
         if(!this.checkIfAvailable())
         {
            return;
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.STOP_INTRO,RegConnectionManager.getInstance().socketClientID,param1);
      }
      
      public function removeAllSounds(param1:Number = 0, param2:Number = 0) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.REMOVE_ALL_SOUNDS,RegConnectionManager.getInstance().socketClientID);
      }
      
      public function fadeBusVolume(param1:int, param2:Number, param3:Number) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.FADE_BUS,param1,param2,param3);
      }
      
      public function setBusVolume(param1:int, param2:Number) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.SET_BUS_VOLUME,param1,param2);
      }
      
      public function reset() : void
      {
         this.stopMainClientSounds();
         this.removeAllSounds();
      }
      
      private function init() : void
      {
         this._previousSubareaId = -1;
         this._localizedSoundsManager = new LocalizedSoundsManager();
         this._ambientManager = new AmbientSoundsManager();
         this._fightMusicManager = new FightMusicManager();
         this._entitySounds = new Array();
         this._reverseEntitySounds = new Dictionary();
         this._adminSounds = new Dictionary();
         this._stopableSounds = new Array();
         this._entityDictionary = new Dictionary();
         if(AirScanner.hasAir())
         {
            StageShareManager.stage["nativeWindow"].addEventListener(Event.CLOSE,this.onClose);
         }
         var _loc1_:* = "config.xml";
         if(File.applicationDirectory.resolvePath("config-custom.xml").exists)
         {
            _loc1_ = "config-custom.xml";
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.SAY_HELLO,RegConnectionManager.getInstance().socketClientID,File.applicationDirectory.nativePath + "/" + _loc1_);
      }
      
      private function removeLocalizedSounds() : void
      {
         this._entitySounds = new Array();
         this._reverseEntitySounds = new Dictionary();
         RegConnectionManager.getInstance().send(ProtocolEnum.REMOVE_LOCALIZED_SOUNDS,RegConnectionManager.getInstance().socketClientID);
      }
      
      private function checkIfAvailable() : Boolean
      {
         return this._forceSounds && this._soundDirectoryExist;
      }
      
      public function playAdminSound(param1:String, param2:Number, param3:Boolean, param4:uint) : void
      {
         var _loc5_:uint = SoundUtil.getBusIdBySoundId(param1);
         var _loc6_:String = SoundUtil.getConfigEntryByBusId(_loc5_);
         var _loc7_:Uri = new Uri(_loc6_ + param1 + ".mp3");
         var _loc8_:ISound;
         (_loc8_ = new SoundDofus(param1)).busId = _loc5_;
         this._adminSounds[param4] = _loc8_;
         _loc8_.play(param3);
         _loc8_.volume = param2;
      }
      
      public function stopAdminSound(param1:uint) : void
      {
         var _loc2_:ISound = this._adminSounds[param1] as ISound;
         _loc2_.stop();
      }
      
      public function addSoundInPlaylist(param1:String, param2:Number, param3:uint, param4:uint) : Boolean
      {
         if(this._adminPlaylist == null)
         {
            this._adminPlaylist = new PlayListPlayer(false,true);
         }
         var _loc5_:uint = SoundUtil.getBusIdBySoundId(param1);
         var _loc6_:String = SoundUtil.getConfigEntryByBusId(_loc5_);
         var _loc7_:Uri = new Uri(_loc6_ + param1 + ".mp3");
         var _loc8_:ISound;
         (_loc8_ = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,_loc7_)).busId = _loc5_;
         if(this._adminPlaylist.addSound(_loc8_) > 0)
         {
            return true;
         }
         return false;
      }
      
      public function removeSoundInPLaylist(param1:String) : Boolean
      {
         if(this._adminPlaylist == null)
         {
            return false;
         }
         this._adminPlaylist.removeSoundBySoundId(param1,true);
         return true;
      }
      
      public function playPlaylist() : void
      {
         if(this.checkIfAvailable())
         {
            return;
         }
         if(this._adminPlaylist == null)
         {
            return;
         }
         this._adminPlaylist.play();
      }
      
      public function stopPlaylist() : void
      {
         if(this.checkIfAvailable())
         {
            return;
         }
         if(this._adminPlaylist == null)
         {
            return;
         }
         this._adminPlaylist.stop();
      }
      
      public function resetPlaylist() : void
      {
         if(this._adminPlaylist)
         {
            this._adminPlaylist.reset();
         }
      }
      
      private function onRemoveSoundInTubul(param1:AudioBusEvent) : void
      {
         this.removeSoundEntity(param1.sound);
      }
      
      private function onSoundAdminComplete(param1:SoundCompleteEvent) : void
      {
         param1.sound.eventDispatcher.removeEventListener(SoundCompleteEvent.SOUND_COMPLETE,this.onSoundAdminComplete);
         var _loc2_:String = param1.sound.uri.fileName.split(".mp3")[0];
         this._adminSounds[_loc2_] = null;
         delete this._adminSounds[_loc2_];
      }
      
      public function onClose(param1:Event) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.SAY_GOODBYE,RegConnectionManager.getInstance().socketClientID);
      }
      
      public function buildSoundLabel(param1:int, param2:String, param3:String) : String
      {
         var _loc4_:RegExp = null;
         if(param3 != null)
         {
            _loc4_ = /^\s*(.*?)\s*$/g;
            param3 = param3.replace(_loc4_,"$1");
            if(param3.length == 0)
            {
               param3 = null;
            }
         }
         var _loc5_:AbstractEntitiesFrame;
         if(!(_loc5_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as AbstractEntitiesFrame))
         {
            _loc5_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as AbstractEntitiesFrame;
         }
         var _loc6_:GameContextActorInformations;
         if(!(_loc6_ = !!_loc5_?_loc5_.getEntityInfos(param1):null) || !_loc6_.look)
         {
            _log.error(param1 + " : donnés incomplètes pour ce bones, impossible de créer les sons");
            return null;
         }
         var _loc7_:TiphonSprite;
         if(!(_loc7_ = DofusEntities.getEntity(param1) as TiphonSprite) || !_loc7_.look)
         {
            _log.error(param1 + " : donnés incomplètes pour ce bones, impossible de créer les sons");
            return null;
         }
         var _loc8_:int = _loc7_.look.getBone();
         var _loc9_:SoundBones = SoundBones.getSoundBonesById(_loc8_);
         var _loc10_:Vector.<SoundEventParamWrapper> = new Vector.<SoundEventParamWrapper>();
         if(_loc9_ != null)
         {
            _loc10_ = this.createSoundEvent(_loc9_,param2,param3);
         }
         if(_loc10_.length <= 0)
         {
            _loc8_ = (TiphonUtility.getEntityWithoutMount(_loc7_) as TiphonSprite).look.getBone();
            if((_loc9_ = SoundBones.getSoundBonesById(_loc8_)) != null)
            {
               _loc10_ = this.createSoundEvent(_loc9_,param2,param3);
            }
         }
         if(_loc10_.length > 0)
         {
            return FLAEventLabelParser.buildSoundLabel(_loc10_);
         }
         return null;
      }
      
      public function playStopableSound(param1:String) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ISound = null;
         if(this._forceSounds)
         {
            _loc2_ = SoundUtil.getBusIdBySoundId(param1);
            _loc3_ = new SoundDofus(param1);
            _loc3_.busId = _loc2_;
            _loc3_.volume = 100 / 100;
            this._stopableSounds[param1] = [_loc3_,param1];
            _loc3_.play(false,1);
         }
         else
         {
            KernelEventsManager.getInstance().processCallback(HookList.StopableSoundEndend,param1);
         }
      }
      
      public function stopStopableSound(param1:String) : void
      {
         if(!this._stopableSounds[param1])
         {
            return;
         }
         var _loc2_:ISound = this._stopableSounds[param1][0] as ISound;
         var _loc3_:Number = 0;
         var _loc4_:VolumeFadeEffect = new VolumeFadeEffect(-1,0,_loc3_);
         _loc2_.stop(_loc4_);
      }
      
      public function stopAllStopableSounds() : void
      {
         var _loc1_:Array = null;
         for each(_loc1_ in this._stopableSounds)
         {
            _loc1_[0].stop(null,true);
            KernelEventsManager.getInstance().processCallback(HookList.StopableSoundEndend,_loc1_[1]);
         }
      }
      
      public function endOfSound(param1:int) : void
      {
         var _loc2_:Array = null;
         var _loc3_:ISound = null;
         for each(_loc2_ in this._stopableSounds)
         {
            _loc3_ = _loc2_[0];
            if(_loc3_.id == param1)
            {
               KernelEventsManager.getInstance().processCallback(HookList.StopableSoundEndend,_loc2_[1]);
               delete this[this._stopableSounds.indexOf(_loc3_)];
               break;
            }
         }
      }
      
      private function createSoundEvent(param1:SoundBones, param2:String, param3:String) : Vector.<SoundEventParamWrapper>
      {
         var _loc4_:SoundAnimation = null;
         var _loc5_:Vector.<SoundEventParamWrapper> = new Vector.<SoundEventParamWrapper>();
         for each(_loc4_ in param1.getSoundAnimationByLabel(param2,param3))
         {
            _loc5_.push(new SoundEventParamWrapper(_loc4_.filename,_loc4_.volume,_loc4_.rolloff,_loc4_.automationDuration,_loc4_.automationVolume,_loc4_.automationFadeIn,_loc4_.automationFadeOut,_loc4_.noCutSilence));
         }
         return _loc5_;
      }
   }
}
