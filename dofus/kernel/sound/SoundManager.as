package com.ankamagames.dofus.kernel.sound
{
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.kernel.sound.manager.ISoundManager;
   import com.ankamagames.dofus.kernel.sound.manager.RegConnectionManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.protocolAudio.ProtocolEnum;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.tubul.types.TubulOptions;
   import flash.utils.getQualifiedClassName;
   
   public class SoundManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SoundManager));
      
      private static var _self:SoundManager;
       
      
      public var manager:ISoundManager;
      
      private var _tuOptions:TubulOptions;
      
      public function SoundManager()
      {
         super();
         if(_self)
         {
            throw new Error("Warning : SoundManager is a singleton class and shoulnd\'t be instancied directly!");
         }
      }
      
      public static function getInstance() : SoundManager
      {
         if(!_self)
         {
            _self = new SoundManager();
         }
         return _self;
      }
      
      public function get options() : TubulOptions
      {
         return this._tuOptions;
      }
      
      public function setSoundOptions() : void
      {
         var musicMute:Boolean = false;
         var soundMute:Boolean = false;
         var ambientSoundMute:Boolean = false;
         var infiniteLoop:Boolean = false;
         var soundActivated:Boolean = false;
         var obj:* = undefined;
         var commonMod:Object = null;
         obj = undefined;
         try
         {
            musicMute = OptionManager.getOptionManager("tubul")["muteMusic"];
            soundMute = OptionManager.getOptionManager("tubul")["muteSound"];
            ambientSoundMute = OptionManager.getOptionManager("tubul")["muteAmbientSound"];
            infiniteLoop = OptionManager.getOptionManager("tubul")["infiniteLoopMusics"];
            this.setMusicVolume(!!musicMute?Number(0):Number(OptionManager.getOptionManager("tubul")["volumeMusic"]));
            this.setSoundVolume(!!soundMute?Number(0):Number(OptionManager.getOptionManager("tubul")["volumeSound"]));
            this.setAmbienceVolume(!!ambientSoundMute?Number(0):Number(OptionManager.getOptionManager("tubul")["volumeAmbientSound"]));
            RegConnectionManager.getInstance().send(ProtocolEnum.OPTION_MUSIC_LOOP_VALUE_CHANGED,infiniteLoop);
            soundActivated = OptionManager.getOptionManager("tubul")["tubulIsDesactivated"];
            if(soundActivated)
            {
               this.manager.deactivateSound();
            }
         }
         catch(e:Error)
         {
            _log.warn("Une erreur est survenue lors de la récupération/application des paramètres audio (option audio)");
            try
            {
               obj = UiModuleManager.getInstance().getModule("Ankama_Common");
               if(obj == null)
               {
                  return;
               }
               commonMod = obj.mainClass;
               commonMod.openPopup(I18n.getUiText("ui.popup.warning"),I18n.getUiText("ui.common.soundsDeactivated"),[I18n.getUiText("ui.common.ok")]);
            }
            catch(error:Error)
            {
               _log.warn("Nous n\'étions probablement pas encore en jeu, ni en pré jeu");
            }
         }
      }
      
      public function setDisplayOptions(param1:TubulOptions) : void
      {
         this._tuOptions = param1;
         this._tuOptions.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         this.setSoundOptions();
      }
      
      public function checkSoundDirectory() : void
      {
         this.manager.soundDirectoryExist = true;
      }
      
      public function setMusicVolume(param1:Number) : void
      {
         if(!this.manager.soundIsActivate)
         {
            return;
         }
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_MUSIC_ID,param1);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_FIGHT_MUSIC_ID,param1);
      }
      
      public function setSoundVolume(param1:Number) : void
      {
         if(!this.manager.soundIsActivate)
         {
            return;
         }
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_UI_ID,param1);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_BARKS_ID,param1);
      }
      
      public function setAmbienceVolume(param1:Number) : void
      {
         if(!this.manager.soundIsActivate)
         {
            return;
         }
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_AMBIENT_2D_ID,param1);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_AMBIENT_3D_ID,param1);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_BARKS_ID,param1);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_FIGHT_ID,param1);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_GFX_ID,param1);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_NPC_FOLEYS_ID,param1);
         this.manager.setBusVolume(TubulSoundConfiguration.BUS_SFX_ID,param1);
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         switch(param1.propertyName)
         {
            case "muteMusic":
               this.setMusicVolume(!!param1.propertyValue?Number(0):Number(this._tuOptions.volumeMusic));
               return;
            case "muteSound":
               this.setSoundVolume(!!param1.propertyValue?Number(0):Number(this._tuOptions.volumeSound));
               return;
            case "muteAmbientSound":
               this.setAmbienceVolume(!!param1.propertyValue?Number(0):Number(this._tuOptions.volumeAmbientSound));
               return;
            case "volumeMusic":
               if(this._tuOptions.muteMusic == false)
               {
                  this.setMusicVolume(param1.propertyValue);
               }
               return;
            case "volumeSound":
               if(this._tuOptions.muteSound == false)
               {
                  this.setSoundVolume(param1.propertyValue);
               }
               return;
            case "volumeAmbientSound":
               if(this._tuOptions.muteAmbientSound == false)
               {
                  this.setAmbienceVolume(param1.propertyValue);
               }
               return;
            case "tubulIsDesactivated":
               if(param1.propertyValue == true)
               {
                  this.manager.deactivateSound();
               }
               if(param1.propertyValue == false)
               {
                  this.manager.activateSound();
               }
               return;
            case "playSoundForGuildMessage":
               return;
            case "playSoundAtTurnStart":
               return;
            case "infiniteLoopMusics":
               RegConnectionManager.getInstance().send(ProtocolEnum.OPTION_MUSIC_LOOP_VALUE_CHANGED,param1.propertyValue);
               return;
            default:
               return;
         }
      }
   }
}
