package com.ankamagames.dofus.logic.connection.frames
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.api.ApiBinder;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.factories.HyperlinkFactory;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.berilia.factories.TooltipsFactory;
   import com.ankamagames.berilia.managers.EmbedFontManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.ThemeManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.managers.UiRenderManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.berilia.types.messages.AllModulesLoadedMessage;
   import com.ankamagames.berilia.types.messages.AllUiXmlParsedMessage;
   import com.ankamagames.berilia.types.messages.ModuleExecErrorMessage;
   import com.ankamagames.berilia.types.messages.ModuleLoadedMessage;
   import com.ankamagames.berilia.types.messages.ModuleRessourceLoadFailedMessage;
   import com.ankamagames.berilia.types.messages.NoThemeErrorMessage;
   import com.ankamagames.berilia.types.messages.ThemeLoadErrorMessage;
   import com.ankamagames.berilia.types.messages.ThemeLoadedMessage;
   import com.ankamagames.berilia.types.messages.UiXmlParsedErrorMessage;
   import com.ankamagames.berilia.types.messages.UiXmlParsedMessage;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.datacenter.appearance.SkinMapping;
   import com.ankamagames.dofus.datacenter.misc.CensoredContent;
   import com.ankamagames.dofus.datacenter.spells.SpellPair;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatBubble;
   import com.ankamagames.dofus.internalDatacenter.communication.CraftSmileyItem;
   import com.ankamagames.dofus.internalDatacenter.communication.DelayedActionItem;
   import com.ankamagames.dofus.internalDatacenter.communication.SmileyWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.ThinkBubble;
   import com.ankamagames.dofus.internalDatacenter.fight.ChallengeWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.PaddockWrapper;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.MountWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.QuantifiedItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.WeaponWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.PartyCompanionWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsListWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.PanicMessages;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.manager.ClassicSoundManager;
   import com.ankamagames.dofus.logic.common.frames.QueueFrame;
   import com.ankamagames.dofus.logic.common.managers.DofusFpsManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkDisplayArrowManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkItemManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkMapPosition;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowAccountMenuManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowAchievementManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowAllianceManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowEntityManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowGuildManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowMonsterChatManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowMonsterFightManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowMonsterManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowNpcManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowOfflineSales;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowOrnamentManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowPlayerMenuManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowQuestManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowRecipeManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowSubArea;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowTitleManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkSocialManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkSpellManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkSubstitutionManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkSwapPositionRequest;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkSystem;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkTaxCollectorCollected;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkTaxCollectorPosition;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkURLManager;
   import com.ankamagames.dofus.logic.connection.messages.UpdaterConnectionStatusMessage;
   import com.ankamagames.dofus.logic.game.roleplay.types.CharacterTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.GameContextPaddockItemInformations;
   import com.ankamagames.dofus.logic.game.roleplay.types.GroundObject;
   import com.ankamagames.dofus.logic.game.roleplay.types.MutantTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.PortalTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.PrismTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.TaxCollectorTooltipInformation;
   import com.ankamagames.dofus.misc.lists.AlignmentHookList;
   import com.ankamagames.dofus.misc.lists.ApiActionList;
   import com.ankamagames.dofus.misc.lists.ApiChatActionList;
   import com.ankamagames.dofus.misc.lists.ApiCraftActionList;
   import com.ankamagames.dofus.misc.lists.ApiExchangeActionList;
   import com.ankamagames.dofus.misc.lists.ApiLivingObjectActionList;
   import com.ankamagames.dofus.misc.lists.ApiMountActionList;
   import com.ankamagames.dofus.misc.lists.ApiRolePlayActionList;
   import com.ankamagames.dofus.misc.lists.ApiSocialActionList;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.misc.lists.CustomUiHookList;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.misc.lists.ExternalGameHookList;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.GameDataList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.misc.lists.LivingObjectHookList;
   import com.ankamagames.dofus.misc.lists.MountHookList;
   import com.ankamagames.dofus.misc.lists.PrismHookList;
   import com.ankamagames.dofus.misc.lists.QuestHookList;
   import com.ankamagames.dofus.misc.lists.RoleplayHookList;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.misc.utils.CustomLoadingScreenManager;
   import com.ankamagames.dofus.misc.utils.DofusApiAction;
   import com.ankamagames.dofus.misc.utils.LoadingScreen;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterWaveInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMountInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcWithQuestInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPortalInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.types.data.SpellTooltipInfo;
   import com.ankamagames.dofus.uiApi.AlignmentApi;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.CaptureApi;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.ColorApi;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.ConnectionApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.DocumentApi;
   import com.ankamagames.dofus.uiApi.ExchangeApi;
   import com.ankamagames.dofus.uiApi.ExternalNotificationApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.FileApi;
   import com.ankamagames.dofus.uiApi.HighlightApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.MountApi;
   import com.ankamagames.dofus.uiApi.NotificationApi;
   import com.ankamagames.dofus.uiApi.PartyApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SecurityApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TestApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.jerakine.data.CensoredContentManager;
   import com.ankamagames.jerakine.data.GameDataUpdater;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.I18nUpdater;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.FontManager;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.LangAllFilesLoadedMessage;
   import com.ankamagames.jerakine.messages.LangFileLoadedMessage;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.events.FileEvent;
   import com.ankamagames.jerakine.types.events.LangFileEvent;
   import com.ankamagames.jerakine.utils.display.FpsControler;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import com.ankamagames.performance.Benchmark;
   import com.ankamagames.tiphon.engine.SubstituteAnimationManager;
   import com.ankamagames.tiphon.engine.TiphonEventsManager;
   import com.ankamagames.tiphon.types.ScriptedAnimation;
   import com.ankamagames.tiphon.types.Skin;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class InitializationFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(InitializationFrame));
       
      
      private var _aFiles:Array;
      
      private var _aLoadedFiles:Array;
      
      private var _aModuleInit:Array;
      
      private var _loadingScreen:LoadingScreen;
      
      private var _subConfigCount:uint;
      
      private var _percentPerModule:Number = 0;
      
      private var _modPercents:Array;
      
      private var _isSubLangConfig:Boolean;
      
      private var _isSubCustomConfig:Boolean;
      
      private var _updaterConnectionSuccess:Boolean;
      
      public function InitializationFrame()
      {
         this._modPercents = new Array();
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         var _loc1_:Boolean = false;
         this.initPerformancesWatcher();
         this.initStaticConstants();
         this.initModulesBindings();
         this.displayLoadingScreen();
         this._aModuleInit = new Array();
         this._aModuleInit["config"] = false;
         this._aModuleInit["colors"] = false;
         this._aModuleInit["langFiles"] = false;
         this._aModuleInit["font"] = false;
         this._aModuleInit["i18n"] = false;
         this._aModuleInit["gameData"] = false;
         this._aModuleInit["modules"] = false;
         this._aModuleInit["uiXmlParsing"] = false;
         for each(_loc1_ in this._aModuleInit)
         {
            ++this._percentPerModule;
         }
         this._percentPerModule = 100 / this._percentPerModule;
         LangManager.getInstance().loadFile("config.xml");
         SubstituteAnimationManager.setDefaultAnimation("AnimStatique","AnimStatique");
         SubstituteAnimationManager.setDefaultAnimation("AnimTacle","AnimHit");
         SubstituteAnimationManager.setDefaultAnimation("AnimAttaque","AnimAttaque0");
         SubstituteAnimationManager.setDefaultAnimation("AnimArme","AnimArme0");
         SubstituteAnimationManager.setDefaultAnimation("AnimThrow","AnimStatique");
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var ucsmsg:UpdaterConnectionStatusMessage = null;
         var langMsg:LangFileLoadedMessage = null;
         var langAllMsg:LangAllFilesLoadedMessage = null;
         var ankamaModule:Boolean = false;
         var mrlfm:ModuleRessourceLoadFailedMessage = null;
         var lang:String = null;
         var subLangConfigFile:String = null;
         var subCustomConfigFile:String = null;
         var xmlPos:int = 0;
         var fileNamePos:int = 0;
         var catName:String = null;
         var newValues:Array = null;
         var key:String = null;
         var keyInfo:Array = null;
         var oldKey:String = null;
         var lastLang:String = null;
         var resetLang:Boolean = false;
         var overrideFile:Uri = null;
         var currentCommunity:String = null;
         var msg:Message = param1;
         switch(true)
         {
            case msg is UpdaterConnectionStatusMessage:
               ucsmsg = msg as UpdaterConnectionStatusMessage;
               this._updaterConnectionSuccess = ucsmsg.success;
               return true;
            case msg is LangFileLoadedMessage:
               langMsg = LangFileLoadedMessage(msg);
               if(!langMsg.success)
               {
                  if(langMsg.file.indexOf("i18n") > -1)
                  {
                     this._loadingScreen.log("Unabled to load i18n file " + langMsg.file,LoadingScreen.ERROR);
                     Kernel.panic(PanicMessages.I18N_LOADING_FAILED,[LangManager.getInstance().getEntry("config.lang.current")]);
                  }
                  else if(langMsg.file.indexOf("config.xml") > -1)
                  {
                     this._loadingScreen.log("Unabled to load main config file : " + langMsg.file,LoadingScreen.ERROR);
                     Kernel.panic(PanicMessages.CONFIG_LOADING_FAILED);
                  }
                  else if(langMsg.file.indexOf("config-") > -1)
                  {
                     this._loadingScreen.log("Unabled to load secondary config file : " + langMsg.file,LoadingScreen.INFO);
                     this._aModuleInit["config"] = true;
                     this.setModulePercent("config",100);
                  }
                  else
                  {
                     this._loadingScreen.log("Unabled to load  " + langMsg.file,LoadingScreen.ERROR);
                  }
               }
               if(this._loadingScreen)
               {
                  this._loadingScreen.log(langMsg.file + " loaded.",LoadingScreen.INFO);
               }
               return true;
            case msg is LangAllFilesLoadedMessage:
               langAllMsg = LangAllFilesLoadedMessage(msg);
               _log.debug("file : " + langAllMsg.file);
               switch(langAllMsg.file)
               {
                  case "file://config.xml":
                     if(!langAllMsg.success)
                     {
                        throw new BeriliaError("Impossible de charger " + langAllMsg.file);
                     }
                     if(Dofus.getInstance().forcedLang)
                     {
                        LangManager.getInstance().setEntry("config.lang.current",Dofus.getInstance().forcedLang);
                     }
                     lang = CommandLineArguments.getInstance().getArgument("lang");
                     if(lang)
                     {
                        LangManager.getInstance().setEntry("config.lang.current",lang);
                     }
                     this._aFiles = new Array();
                     this._aLoadedFiles = new Array();
                     subLangConfigFile = "config-" + LangManager.getInstance().getEntry("config.lang.current") + ".xml";
                     subCustomConfigFile = "config-custom.xml";
                     this._isSubLangConfig = File.applicationDirectory.resolvePath(subLangConfigFile).exists;
                     this._isSubCustomConfig = File.applicationDirectory.resolvePath(subCustomConfigFile).exists;
                     this._subConfigCount = 0;
                     if(this._isSubLangConfig || this._isSubCustomConfig)
                     {
                        if(this._isSubLangConfig)
                        {
                           LangManager.getInstance().loadFile(subLangConfigFile);
                           ++this._subConfigCount;
                        }
                        if(this._isSubCustomConfig)
                        {
                           LangManager.getInstance().loadFile(subCustomConfigFile);
                           ++this._subConfigCount;
                        }
                        this.setModulePercent("config",50);
                     }
                     else
                     {
                        this._aModuleInit["config"] = true;
                        this.setModulePercent("config",100);
                        this.initAfterLoadConfig();
                     }
                     break;
                  default:
                     if(langAllMsg.file.indexOf("colors.xml") != -1)
                     {
                        if(!langAllMsg.success)
                        {
                           throw new BeriliaError("Impossible de charger " + langAllMsg.file);
                        }
                        XmlConfig.getInstance().addCategory(LangManager.getInstance().getCategory("colors"));
                        this._aModuleInit["colors"] = true;
                        this.setModulePercent("colors",100);
                        this._loadingScreen.value = this._loadingScreen.value + this._percentPerModule;
                        break;
                     }
                     if(langAllMsg.file.indexOf("config-") != -1)
                     {
                        try
                        {
                           xmlPos = langAllMsg.file.lastIndexOf(".xml");
                           fileNamePos = langAllMsg.file.lastIndexOf("config-");
                           catName = langAllMsg.file.substring(fileNamePos,xmlPos);
                           newValues = LangManager.getInstance().getCategory(catName);
                           for(key in newValues)
                           {
                              keyInfo = key.split(".");
                              keyInfo[0] = "config";
                              oldKey = keyInfo.join(".");
                              XmlConfig.getInstance().setEntry(oldKey,newValues[key]);
                              LangManager.getInstance().setEntry(oldKey,newValues[key]);
                           }
                        }
                        catch(e:Error)
                        {
                           throw e;
                        }
                        --this._subConfigCount;
                        if(!this._subConfigCount)
                        {
                           this.setModulePercent("config",100);
                           this._aModuleInit["config"] = true;
                           this.initAfterLoadConfig();
                           this.checkInit();
                        }
                     }
                     else
                     {
                        this._aLoadedFiles.push(langAllMsg.file);
                     }
                     this._aModuleInit["langFiles"] = this._aLoadedFiles.length == this._aFiles.length && XmlConfig.getInstance().getEntry("config.data.path.i18n.list");
                     if(this._aModuleInit["langFiles"])
                     {
                        this.setModulePercent("langFiles",100);
                        this.initFonts();
                        I18nUpdater.getInstance().addEventListener(Event.COMPLETE,this.onI18nReady);
                        I18nUpdater.getInstance().addEventListener(FileEvent.ERROR,this.onDataFileError);
                        I18nUpdater.getInstance().addEventListener(LangFileEvent.COMPLETE,this.onI18nPartialDataReady);
                        GameDataUpdater.getInstance().addEventListener(Event.COMPLETE,this.onGameDataReady);
                        GameDataUpdater.getInstance().addEventListener(FileEvent.ERROR,this.onDataFileError);
                        GameDataUpdater.getInstance().addEventListener(LangFileEvent.COMPLETE,this.onGameDataPartialDataReady);
                        lastLang = StoreDataManager.getInstance().getData(Constants.DATASTORE_LANG_VERSION,"lastLang");
                        resetLang = lastLang != XmlConfig.getInstance().getEntry("config.lang.current");
                        if(resetLang)
                        {
                           UiRenderManager.getInstance().clearCache();
                        }
                        currentCommunity = XmlConfig.getInstance().getEntry("config.community.current");
                        if(currentCommunity && currentCommunity.charAt(0) != "!")
                        {
                           overrideFile = new Uri(XmlConfig.getInstance().getEntry("config.data.path.root") + "com/" + currentCommunity + ".xml");
                        }
                        I18nUpdater.getInstance().initI18n(XmlConfig.getInstance().getEntry("config.lang.current"),new Uri(XmlConfig.getInstance().getEntry("config.data.path.i18n.list")),resetLang,overrideFile);
                        GameDataUpdater.getInstance().init(new Uri(XmlConfig.getInstance().getEntry("config.data.path.common.list")));
                     }
                     this.checkInit();
                     break;
               }
               return true;
            case msg is AllModulesLoadedMessage:
               this._aModuleInit["modules"] = true;
               this._loadingScreen.log("Launch main modules scripts",LoadingScreen.IMPORTANT);
               this.setModulePercent("modules",100);
               this.checkInit();
               return true;
            case msg is ModuleLoadedMessage:
               this.setModulePercent("modules",this._percentPerModule * 1 / UiModuleManager.getInstance().moduleCount,true);
               ankamaModule = UiModuleManager.getInstance().getModule(ModuleLoadedMessage(msg).moduleName).trusted;
               this._loadingScreen.log(ModuleLoadedMessage(msg).moduleName + " script loaded " + (!!ankamaModule?"":"UNTRUSTED module"),!!ankamaModule?uint(LoadingScreen.IMPORTANT):uint(LoadingScreen.WARNING));
               return true;
            case msg is UiXmlParsedMessage:
               this._loadingScreen.log("Preparsing " + UiXmlParsedMessage(msg).url,LoadingScreen.INFO);
               this.setModulePercent("uiXmlParsing",this._percentPerModule * 1 / UiModuleManager.getInstance().unparsedXmlCount,true);
               return true;
            case msg is UiXmlParsedErrorMessage:
               this._loadingScreen.log("Error while parsing  " + UiXmlParsedErrorMessage(msg).url + " : " + UiXmlParsedErrorMessage(msg).msg,LoadingScreen.ERROR);
               this.setModulePercent("uiXmlParsing",this._percentPerModule * 1 / UiModuleManager.getInstance().unparsedXmlCount,true);
               return true;
            case msg is AllUiXmlParsedMessage:
               this._aModuleInit["uiXmlParsing"] = true;
               this.setModulePercent("uiXmlParsing",100);
               this.checkInit();
               return true;
            case msg is ModuleExecErrorMessage:
               this._loadingScreen.log("Error while executing " + ModuleExecErrorMessage(msg).moduleName + "\'s main script :\n" + ModuleExecErrorMessage(msg).stackTrace,LoadingScreen.ERROR);
               return true;
            case msg is ModuleRessourceLoadFailedMessage:
               mrlfm = msg as ModuleRessourceLoadFailedMessage;
               this._loadingScreen.log("Module " + mrlfm.moduleName + " : Cannot load " + mrlfm.uri,!!mrlfm.isImportant?uint(LoadingScreen.ERROR):uint(LoadingScreen.WARNING));
               return true;
            case msg is ThemeLoadedMessage:
               this._loadingScreen.log("Theme \"" + ThemeLoadedMessage(msg).themeName + "\" loaded",LoadingScreen.IMPORTANT);
               return true;
            case msg is ThemeLoadErrorMessage:
               this._loadingScreen.log(ThemeLoadErrorMessage(msg).themeName + " theme load failed : " + ThemeLoadErrorMessage(msg).themeName + ".dt cannot be found. If this file exists, maybe it contains an error.",LoadingScreen.ERROR);
               return true;
            case msg is NoThemeErrorMessage:
               this._loadingScreen.log(I18n.getUiText("ui.popup.noTheme"),LoadingScreen.ERROR);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         if(AirScanner.isStreamingVersion())
         {
            Dofus.getInstance().strLoaderComplete();
         }
         this._loadingScreen.parent.removeChild(this._loadingScreen);
         this._loadingScreen = null;
         StageShareManager.testQuality();
         EmbedFontManager.getInstance().removeEventListener(Event.COMPLETE,this.onFontsManagerInit);
         return true;
      }
      
      private function initAfterLoadConfig() : void
      {
         var _loc1_:uint = 0;
         Kernel.getInstance().postInit();
         this._aFiles.push(LangManager.getInstance().getEntry("config.ui.asset.fontsList"));
         while(_loc1_ < this._aFiles.length)
         {
            FontManager.getInstance().loadFile(this._aFiles[_loc1_]);
            _loc1_++;
         }
         this._loadingScreen.value = this._loadingScreen.value + this._percentPerModule;
         KernelEventsManager.getInstance().processCallback(HookList.ConfigStart);
         this.initTubul();
         if(!(SoundManager.getInstance().manager is ClassicSoundManager))
         {
            Berilia.getInstance().addUIListener(SoundManager.getInstance().manager);
            TiphonEventsManager.addListener(SoundManager.getInstance().manager,"Sound");
            TiphonEventsManager.addListener(SoundManager.getInstance().manager,"DataSound");
         }
         ThemeManager.getInstance().init();
         ThemeManager.getInstance().applyTheme(OptionManager.getOptionManager("dofus").switchUiSkin);
         if(!CommandLineArguments.getInstance().hasArgument("functional-test"))
         {
            CustomLoadingScreenManager.getInstance().loadCustomScreenList();
         }
      }
      
      private function initPerformancesWatcher() : void
      {
         DofusFpsManager.init();
         FpsControler.Init(ScriptedAnimation);
      }
      
      private function initStaticConstants() : void
      {
         HookList.AuthenticationTicket;
         ChatHookList.ShowObjectLinked;
         PrismHookList.PrismsList;
         AlignmentHookList.AlignmentAreaUpdate;
         CraftHookList.ExchangeStartOkCraft;
         ExchangeHookList.AskExchangeMoveObject;
         FightHookList.AfkModeChanged;
         InventoryHookList.BankViewContent;
         LivingObjectHookList.LivingObjectAssociate;
         MountHookList.CertificateMountData;
         QuestHookList.QuestInfosUpdated;
         SocialHookList.AttackPlayer;
         TriggerHookList.CreaturesMode;
         CustomUiHookList.ActivateSound;
         RoleplayHookList.SpellForgetUI;
         CraftHookList.DoNothing;
         ExternalGameHookList.DofusShopMoney;
         ApiActionList.AuthorizedCommand;
         ApiChatActionList.ChannelEnabling;
         ApiCraftActionList.JobCrafterDirectoryDefineSettings;
         ApiSocialActionList.FriendsListRequest;
         ApiRolePlayActionList.PlayerFightFriendlyAnswer;
         ApiExchangeActionList.BidHouseStringSearch;
         ApiMountActionList.MountFeedRequest;
         ApiLivingObjectActionList.LivingObjectChangeSkinRequest;
      }
      
      private function initModulesBindings() : void
      {
         ApiBinder.addApi("Ui",UiApi);
         ApiBinder.addApi("System",SystemApi);
         ApiBinder.addApi("Data",DataApi);
         ApiBinder.addApi("Time",TimeApi);
         ApiBinder.addApi("Tooltip",TooltipApi);
         ApiBinder.addApi("ContextMenu",ContextMenuApi);
         ApiBinder.addApi("Test",TestApi);
         ApiBinder.addApi("Jobs",JobsApi);
         ApiBinder.addApi("Storage",StorageApi);
         ApiBinder.addApi("Util",UtilApi);
         ApiBinder.addApi("Exchange",ExchangeApi);
         ApiBinder.addApi("Config",ConfigApi);
         ApiBinder.addApi("Binds",BindsApi);
         ApiBinder.addApi("Chat",ChatApi);
         ApiBinder.addApi("Sound",SoundApi);
         ApiBinder.addApi("Fight",FightApi);
         ApiBinder.addApi("PlayedCharacter",PlayedCharacterApi);
         ApiBinder.addApi("Connection",ConnectionApi);
         ApiBinder.addApi("Social",SocialApi);
         ApiBinder.addApi("Roleplay",RoleplayApi);
         ApiBinder.addApi("Map",MapApi);
         ApiBinder.addApi("Quest",QuestApi);
         ApiBinder.addApi("Alignment",AlignmentApi);
         ApiBinder.addApi("Inventory",InventoryApi);
         ApiBinder.addApi("Document",DocumentApi);
         ApiBinder.addApi("Mount",MountApi);
         ApiBinder.addApi("Party",PartyApi);
         ApiBinder.addApi("Highlight",HighlightApi);
         ApiBinder.addApi("File",FileApi);
         ApiBinder.addApi("Security",SecurityApi);
         ApiBinder.addApi("Capture",CaptureApi);
         ApiBinder.addApi("Notification",NotificationApi);
         ApiBinder.addApi("ExternalNotification",ExternalNotificationApi);
         ApiBinder.addApi("AveragePrices",AveragePricesApi);
         ApiBinder.addApi("Color",ColorApi);
         TooltipsFactory.registerAssoc(String,"text");
         TooltipsFactory.registerAssoc(TextTooltipInfo,"textInfo");
         TooltipsFactory.registerAssoc(SpellWrapper,"spell");
         TooltipsFactory.registerAssoc(SpellPair,"spell");
         TooltipsFactory.registerAssoc(SpellTooltipInfo,"spellBanner");
         TooltipsFactory.registerAssoc(ItemWrapper,"item");
         TooltipsFactory.registerAssoc(WeaponWrapper,"item");
         TooltipsFactory.registerAssoc(QuantifiedItemWrapper,"item");
         TooltipsFactory.registerAssoc(SmileyWrapper,"smiley");
         TooltipsFactory.registerAssoc(ChatBubble,"chatBubble");
         TooltipsFactory.registerAssoc(ThinkBubble,"thinkBubble");
         TooltipsFactory.registerAssoc(GameRolePlayCharacterInformations,"player");
         TooltipsFactory.registerAssoc(GameRolePlayMutantInformations,"mutant");
         TooltipsFactory.registerAssoc(CharacterTooltipInformation,"player");
         TooltipsFactory.registerAssoc(MutantTooltipInformation,"mutant");
         TooltipsFactory.registerAssoc(GameRolePlayNpcInformations,"npc");
         TooltipsFactory.registerAssoc(GameRolePlayGroupMonsterInformations,"monsterGroup");
         TooltipsFactory.registerAssoc(GameRolePlayGroupMonsterWaveInformations,"monsterGroup");
         TooltipsFactory.registerAssoc(GameRolePlayMerchantInformations,"merchant");
         TooltipsFactory.registerAssoc(GroundObject,"groundObject");
         TooltipsFactory.registerAssoc(TaxCollectorTooltipInformation,"taxCollector");
         TooltipsFactory.registerAssoc(GameFightTaxCollectorInformations,"fightTaxCollector");
         TooltipsFactory.registerAssoc(EffectsWrapper,"effects");
         TooltipsFactory.registerAssoc(EffectsListWrapper,"effectsList");
         TooltipsFactory.registerAssoc(Vector.<String>,"texturesList");
         TooltipsFactory.registerAssoc(CraftSmileyItem,"craftSmiley");
         TooltipsFactory.registerAssoc(DelayedActionItem,"delayedAction");
         TooltipsFactory.registerAssoc(PrismTooltipInformation,"prism");
         TooltipsFactory.registerAssoc(PortalTooltipInformation,"portal");
         TooltipsFactory.registerAssoc(Object,"mount");
         TooltipsFactory.registerAssoc(MountWrapper,"mount");
         TooltipsFactory.registerAssoc(GameContextPaddockItemInformations,"paddockItem");
         TooltipsFactory.registerAssoc(GameRolePlayMountInformations,"paddockMount");
         TooltipsFactory.registerAssoc(ChallengeWrapper,"challenge");
         TooltipsFactory.registerAssoc(PaddockWrapper,"paddock");
         TooltipsFactory.registerAssoc(GameFightCharacterInformations,"playerFighter");
         TooltipsFactory.registerAssoc(GameFightMonsterInformations,"monsterFighter");
         TooltipsFactory.registerAssoc(GameFightCompanionInformations,"companionFighter");
         TooltipsFactory.registerAssoc(HouseWrapper,"house");
         MenusFactory.registerAssoc(GameRolePlayMerchantInformations,"humanVendor");
         MenusFactory.registerAssoc(ItemWrapper,"item");
         MenusFactory.registerAssoc(QuantifiedItemWrapper,"item");
         MenusFactory.registerAssoc(WeaponWrapper,"item");
         MenusFactory.registerAssoc(MountWrapper,"mount");
         MenusFactory.registerAssoc(GameRolePlayCharacterInformations,"player");
         MenusFactory.registerAssoc(GameRolePlayMutantInformations,"mutant");
         MenusFactory.registerAssoc(GameRolePlayNpcInformations,"npc");
         MenusFactory.registerAssoc(GameRolePlayNpcWithQuestInformations,"npc");
         MenusFactory.registerAssoc(GameRolePlayTaxCollectorInformations,"taxCollector");
         MenusFactory.registerAssoc(GameRolePlayPrismInformations,"prism");
         MenusFactory.registerAssoc(GameRolePlayPortalInformations,"portal");
         MenusFactory.registerAssoc(GameContextPaddockItemInformations,"paddockItem");
         MenusFactory.registerAssoc(GameRolePlayMountInformations,"mount");
         MenusFactory.registerAssoc(String,"player");
         MenusFactory.registerAssoc(GameRolePlayGroupMonsterInformations,"monsterGroup");
         MenusFactory.registerAssoc(GameFightCompanionInformations,"companion");
         MenusFactory.registerAssoc(PartyCompanionWrapper,"companion");
         MenusFactory.registerAssoc(GameFightFighterInformations,"fightAlly");
         HyperlinkFactory.registerProtocol("ui",HyperlinkDisplayArrowManager.showArrow);
         HyperlinkFactory.registerProtocol("spell",HyperlinkSpellManager.showSpell,HyperlinkSpellManager.getSpellLevelName);
         HyperlinkFactory.registerProtocol("spellNoLvl",HyperlinkSpellManager.showSpellNoLevel,HyperlinkSpellManager.getSpellName);
         HyperlinkFactory.registerProtocol("spellPair",HyperlinkSpellManager.showSpellPair);
         HyperlinkFactory.registerProtocol("cell",HyperlinkShowCellManager.showCell);
         HyperlinkFactory.registerProtocol("entity",HyperlinkShowEntityManager.showEntity,null,null,true,HyperlinkShowEntityManager.rollOver);
         HyperlinkFactory.registerProtocol("recipe",HyperlinkShowRecipeManager.showRecipe,HyperlinkShowRecipeManager.getRecipeName,null,true,HyperlinkShowRecipeManager.rollOver);
         HyperlinkFactory.registerProtocol("player",HyperlinkShowPlayerMenuManager.showPlayerMenu,HyperlinkShowPlayerMenuManager.getPlayerName,null,false,HyperlinkShowPlayerMenuManager.rollOverPlayer);
         HyperlinkFactory.registerProtocol("account",HyperlinkShowAccountMenuManager.showAccountMenu);
         HyperlinkFactory.registerProtocol("item",HyperlinkItemManager.showItem,HyperlinkItemManager.getItemName);
         HyperlinkFactory.registerProtocol("map",HyperlinkMapPosition.showPosition,HyperlinkMapPosition.getText,null,true,HyperlinkMapPosition.rollOver);
         HyperlinkFactory.registerProtocol("chatitem",HyperlinkItemManager.showChatItem,null,HyperlinkItemManager.duplicateChatHyperlink,true,HyperlinkItemManager.rollOver);
         HyperlinkFactory.registerProtocol("guild",HyperlinkShowGuildManager.showGuild,HyperlinkShowGuildManager.getGuildName,null,true,HyperlinkShowGuildManager.rollOver);
         HyperlinkFactory.registerProtocol("alliance",HyperlinkShowAllianceManager.showAlliance,HyperlinkShowAllianceManager.getAllianceName,null,true,HyperlinkShowAllianceManager.rollOver);
         HyperlinkFactory.registerProtocol("openSocial",HyperlinkSocialManager.openSocial,null,null,true,HyperlinkSocialManager.rollOver);
         HyperlinkFactory.registerProtocol("chatLinkRelease",HyperlinkURLManager.chatLinkRelease,null,null,true,HyperlinkURLManager.rollOver);
         HyperlinkFactory.registerProtocol("chatWarning",HyperlinkURLManager.chatWarning);
         HyperlinkFactory.registerProtocol("subst",HyperlinkSubstitutionManager.openAnkabox,HyperlinkSubstitutionManager.substitute,null,true,HyperlinkItemManager.rollOver);
         HyperlinkFactory.registerProtocol("npc",HyperlinkShowNpcManager.showNpc);
         HyperlinkFactory.registerProtocol("monster",HyperlinkShowMonsterManager.showMonster,HyperlinkShowMonsterManager.getMonsterName);
         HyperlinkFactory.registerProtocol("monsterFight",HyperlinkShowMonsterFightManager.showEntity,null,null,true,HyperlinkShowMonsterFightManager.rollOver);
         HyperlinkFactory.registerProtocol("spellEffectArea",HyperlinkSpellManager.showSpellArea,null,null,true,HyperlinkSpellManager.rollOver);
         HyperlinkFactory.registerProtocol("chatquest",HyperlinkShowQuestManager.showQuest,null,null,true,HyperlinkShowQuestManager.rollOver);
         HyperlinkFactory.registerProtocol("chatachievement",HyperlinkShowAchievementManager.showAchievement,HyperlinkShowAchievementManager.getAchievementName,null,true,HyperlinkShowAchievementManager.rollOver);
         HyperlinkFactory.registerProtocol("chattitle",HyperlinkShowTitleManager.showTitle,null,null,true,HyperlinkShowTitleManager.rollOver);
         HyperlinkFactory.registerProtocol("chatornament",HyperlinkShowOrnamentManager.showOrnament,null,null,true,HyperlinkShowOrnamentManager.rollOver);
         HyperlinkFactory.registerProtocol("chatmonster",HyperlinkShowMonsterChatManager.showMonster,HyperlinkShowMonsterChatManager.getMonsterName,null,true,HyperlinkShowMonsterChatManager.rollOver);
         HyperlinkFactory.registerProtocol("subArea",HyperlinkShowSubArea.showSubArea,HyperlinkShowSubArea.getSubAreaName);
         HyperlinkFactory.registerProtocol("offlineSales",HyperlinkShowOfflineSales.showOfflineSales,null,null,false);
         HyperlinkFactory.registerProtocol("taxcollectorPosition",HyperlinkTaxCollectorPosition.showPosition,null,null,false,HyperlinkTaxCollectorPosition.rollOver);
         HyperlinkFactory.registerProtocol("taxcollectorCollected",HyperlinkTaxCollectorCollected.showCollectedTaxCollector,null,null,false,HyperlinkTaxCollectorCollected.rollOver);
         HyperlinkFactory.registerProtocol("swapPositionRequest",HyperlinkSwapPositionRequest.showMenu,null,null,false);
         HyperlinkFactory.registerProtocol("system",HyperlinkSystem.open,null,null,true);
      }
      
      private function displayLoadingScreen() : void
      {
         this._loadingScreen = new LoadingScreen(false,true);
         Dofus.getInstance().addChild(this._loadingScreen);
      }
      
      private function initTubul() : void
      {
         SoundManager.getInstance().checkSoundDirectory();
      }
      
      private function checkInit() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:* = null;
         var _loc3_:XML = null;
         var _loc4_:Array = null;
         var _loc5_:XML = null;
         var _loc6_:uint = 0;
         var _loc7_:Array = null;
         var _loc8_:SkinMapping = null;
         var _loc9_:XML = null;
         var _loc10_:XML = null;
         var _loc11_:Boolean = true;
         for(_loc2_ in this._aModuleInit)
         {
            _loc11_ = _loc11_ && this._aModuleInit[_loc2_];
            if(!this._aModuleInit[_loc2_])
            {
               _loc1_++;
            }
         }
         if(_loc1_ == 2)
         {
            UiModuleManager.getInstance().init(Constants.COMMON_GAME_MODULE.concat(Constants.PRE_GAME_MODULE),true);
         }
         if(_loc11_ && !Benchmark.hasCachedResults && !Benchmark.isDone)
         {
            Benchmark.run(StageShareManager.stage,this.checkInit);
            return;
         }
         if(_loc11_)
         {
            _loc3_ = describeType(GameDataList);
            _loc4_ = [];
            for each(_loc5_ in _loc3_..constant)
            {
               _loc9_ = describeType(getDefinitionByName(_loc5_.@type));
               for each(_loc10_ in _loc9_..method)
               {
                  if(_loc10_.@returnType.toString() == _loc5_.@type.toString() && _loc10_.@name.toString().indexOf("get") == 0 && _loc10_.@name.toString().indexOf("ById") != -1)
                  {
                     _loc4_.push({
                        "fct":getDefinitionByName(_loc5_.@type)[_loc10_.@name.toString()],
                        "returnClass":getDefinitionByName(_loc5_.@type),
                        "testIndex":[0,1,2,3,4,100,1000,2000,10000,100000]
                     });
                  }
               }
            }
            DofusApiAction.updateInfo();
            CensoredContentManager.getInstance().init(CensoredContent.getCensoredContents(),XmlConfig.getInstance().getEntry("config.lang.current"));
            _loc7_ = SkinMapping.getSkinMappings();
            for each(_loc8_ in _loc7_)
            {
               Skin.addAlternativeSkin(_loc8_.id,_loc8_.lowDefId);
            }
            _log.info("Initialization frame end");
            Constants.EVENT_MODE = LangManager.getInstance().getEntry("config.eventMode") == "true";
            Constants.EVENT_MODE_PARAM = LangManager.getInstance().getEntry("config.eventModeParams");
            Constants.CHARACTER_CREATION_ALLOWED = LangManager.getInstance().getEntry("config.characterCreationAllowed") == "true";
            Constants.FORCE_MAXIMIZED_WINDOW = LangManager.getInstance().getEntry("config.autoMaximize") == "true";
            if(Constants.FORCE_MAXIMIZED_WINDOW && AirScanner.hasAir())
            {
               StageShareManager.stage["nativeWindow"].maximize();
            }
            Kernel.getWorker().removeFrame(this);
            Kernel.getWorker().addFrame(new AuthentificationFrame());
            Kernel.getWorker().addFrame(new QueueFrame());
            Kernel.getWorker().addFrame(new GameStartingFrame());
            if(!AirScanner.isStreamingVersion() && !this._updaterConnectionSuccess && BuildInfos.BUILD_TYPE != BuildTypeEnum.DEBUG)
            {
               KernelEventsManager.getInstance().processCallback(HookList.UpdaterConnectionFailed);
            }
         }
      }
      
      private function initFonts() : void
      {
         EmbedFontManager.getInstance().addEventListener(Event.COMPLETE,this.onFontsManagerInit);
         var _loc1_:Array = FontManager.getInstance().getFontsList();
         EmbedFontManager.getInstance().initialize(_loc1_);
      }
      
      private function setModulePercent(param1:String, param2:Number, param3:Boolean = false) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         if(!this._modPercents[param1])
         {
            this._modPercents[param1] = 0;
         }
         if(param3)
         {
            this._modPercents[param1] = this._modPercents[param1] + param2;
         }
         else
         {
            this._modPercents[param1] = param2;
         }
         var _loc6_:Number = 0;
         for each(_loc4_ in this._modPercents)
         {
            _loc6_ = _loc6_ + _loc4_ / 100 * this._percentPerModule;
         }
         _loc5_ = Dofus.getInstance().instanceId;
         if(this._modPercents[param1] == 100)
         {
            this._loadingScreen.log(param1 + " initialized",LoadingScreen.IMPORTANT);
         }
         this._loadingScreen.value = _loc6_;
      }
      
      private function onFontsManagerInit(param1:Event) : void
      {
         this._aModuleInit["font"] = true;
         this.setModulePercent("font",100);
         this.checkInit();
      }
      
      private function onI18nReady(param1:Event) : void
      {
         this._aModuleInit["i18n"] = true;
         this.setModulePercent("i18n",100);
         StoreDataManager.getInstance().setData(Constants.DATASTORE_LANG_VERSION,"lastLang",LangManager.getInstance().getEntry("config.lang.current"));
         this.checkInit();
         Input.numberStrSeparator = I18n.getUiText("ui.common.numberSeparator");
      }
      
      private function onGameDataReady(param1:Event) : void
      {
         this._aModuleInit["gameData"] = true;
         this.setModulePercent("gameData",100);
         this.checkInit();
      }
      
      private function onGameDataPartialDataReady(param1:LangFileEvent) : void
      {
         if(!this._loadingScreen)
         {
            this._loadingScreen = new LoadingScreen();
            Dofus.getInstance().addChild(this._loadingScreen);
         }
         this._loadingScreen.log("[GameData] " + FileUtils.getFileName(param1.url) + " parsed",LoadingScreen.INFO);
         this.setModulePercent("gameData",this._percentPerModule * 1 / GameDataUpdater.getInstance().files.length,true);
         KernelEventsManager.getInstance().processCallback(HookList.LangFileLoaded,param1.url,true);
      }
      
      private function onI18nPartialDataReady(param1:LangFileEvent) : void
      {
         this._loadingScreen.log("[i18n] " + FileUtils.getFileName(param1.url) + " parsed",LoadingScreen.INFO);
         this.setModulePercent("i18n",this._percentPerModule * 1 / I18nUpdater.getInstance().files.length,true);
         KernelEventsManager.getInstance().processCallback(HookList.LangFileLoaded,param1.url,true);
      }
      
      private function onDataFileError(param1:FileEvent) : void
      {
         this._loadingScreen.log("Unabled to load  " + param1.file,LoadingScreen.ERROR);
      }
   }
}
