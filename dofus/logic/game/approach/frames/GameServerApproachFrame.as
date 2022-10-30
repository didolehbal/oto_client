package com.ankamagames.dofus.logic.game.approach.frames
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.messages.AllModulesLoadedMessage;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.console.moduleLUA.ConsoleLUA;
   import com.ankamagames.dofus.console.moduleLogger.Console;
   import com.ankamagames.dofus.console.moduleLogger.ModuleDebugManager;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.externalnotification.ExternalNotificationManager;
   import com.ankamagames.dofus.internalDatacenter.connection.BasicCharacterWrapper;
   import com.ankamagames.dofus.internalDatacenter.connection.CreationCharacterWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.frames.LoadingModuleFrame;
   import com.ankamagames.dofus.logic.common.frames.MiscFrame;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.frames.GameStartingFrame;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterCreationAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterDeletionAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterDeselectionAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterNameSuggestionRequestAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterRemodelSelectionAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterReplayRequestAction;
   import com.ankamagames.dofus.logic.game.approach.actions.CharacterSelectionAction;
   import com.ankamagames.dofus.logic.game.approach.actions.GiftAssignRequestAction;
   import com.ankamagames.dofus.logic.game.approach.managers.PartManager;
   import com.ankamagames.dofus.logic.game.common.frames.AlignmentFrame;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.frames.AveragePricesFrame;
   import com.ankamagames.dofus.logic.game.common.frames.CameraControlFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.frames.CommonUiFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ContextChangeFrame;
   import com.ankamagames.dofus.logic.game.common.frames.EmoticonFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ExternalGameFrame;
   import com.ankamagames.dofus.logic.game.common.frames.HouseFrame;
   import com.ankamagames.dofus.logic.game.common.frames.IdolsFrame;
   import com.ankamagames.dofus.logic.game.common.frames.InventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.JobsFrame;
   import com.ankamagames.dofus.logic.game.common.frames.LivingObjectFrame;
   import com.ankamagames.dofus.logic.game.common.frames.MountFrame;
   import com.ankamagames.dofus.logic.game.common.frames.PartyManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.PlayedCharacterUpdatesFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ProtectPishingFrame;
   import com.ankamagames.dofus.logic.game.common.frames.QuestFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ScreenCaptureFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ServerTransferFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SpellInventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.StackManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SynchronisationFrame;
   import com.ankamagames.dofus.logic.game.common.frames.TinselFrame;
   import com.ankamagames.dofus.logic.game.common.frames.WorldFrame;
   import com.ankamagames.dofus.logic.game.common.managers.InactivityManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayIntroductionFrame;
   import com.ankamagames.dofus.logic.shield.SecureModeManager;
   import com.ankamagames.dofus.misc.interClient.InterClientManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.stats.StatisticsManager;
   import com.ankamagames.dofus.network.ProtocolConstantsEnum;
   import com.ankamagames.dofus.network.enums.CharacterDeletionErrorEnum;
   import com.ankamagames.dofus.network.enums.CharacterRemodelingEnum;
   import com.ankamagames.dofus.network.messages.authorized.ConsoleCommandsListMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AccountCapabilitiesMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AlreadyConnectedMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AuthenticationTicketAcceptedMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AuthenticationTicketMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AuthenticationTicketRefusedMessage;
   import com.ankamagames.dofus.network.messages.game.approach.HelloGameMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicTimeMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.BasicCharactersListMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterFirstSelectionMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterReplayWithRemodelRequestMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedErrorMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedForceMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedForceReadyMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedSuccessMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectionMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectionWithRemodelMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListErrorMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListWithRemodelingMessage;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterCreationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterCreationResultMessage;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterNameSuggestionFailureMessage;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterNameSuggestionRequestMessage;
   import com.ankamagames.dofus.network.messages.game.character.creation.CharacterNameSuggestionSuccessMessage;
   import com.ankamagames.dofus.network.messages.game.character.deletion.CharacterDeletionErrorMessage;
   import com.ankamagames.dofus.network.messages.game.character.deletion.CharacterDeletionRequestMessage;
   import com.ankamagames.dofus.network.messages.game.character.replay.CharacterReplayRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextCreateRequestMessage;
   import com.ankamagames.dofus.network.messages.game.startup.StartupActionFinishedMessage;
   import com.ankamagames.dofus.network.messages.game.startup.StartupActionsExecuteMessage;
   import com.ankamagames.dofus.network.messages.game.startup.StartupActionsListMessage;
   import com.ankamagames.dofus.network.messages.game.startup.StartupActionsObjetAttributionMessage;
   import com.ankamagames.dofus.network.messages.security.ClientKeyMessage;
   import com.ankamagames.dofus.network.messages.security.RawDataMessage;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterBaseInformations;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterHardcoreOrEpicInformations;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterToRemodelInformations;
   import com.ankamagames.dofus.network.types.game.character.choice.RemodelingInformation;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemInformationWithQuantity;
   import com.ankamagames.dofus.network.types.game.startup.StartupActionAddObject;
   import com.ankamagames.dofus.scripts.api.CameraApi;
   import com.ankamagames.dofus.scripts.api.EntityApi;
   import com.ankamagames.dofus.scripts.api.ScriptSequenceApi;
   import com.ankamagames.dofus.types.data.ServerCommand;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.lua.LuaPlayer;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.messages.ConnectionResumedMessage;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.messages.ServerConnectionFailedMessage;
   import com.ankamagames.jerakine.script.ScriptsManager;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   
   public class GameServerApproachFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(GameServerApproachFrame));
      
      private static var _changeLogLoader:Loader = new Loader();
       
      
      private var _charactersList:Vector.<BasicCharacterWrapper>;
      
      private var _charactersToRemodelList:Array;
      
      private var _kernel:KernelEventsManager;
      
      private var _gmaf:LoadingModuleFrame;
      
      private var _waitingMessages:Vector.<Message>;
      
      private var _cssmsg:CharacterSelectedSuccessMessage;
      
      private var _requestedCharacterId:uint;
      
      private var _requestedToRemodelCharacterId:uint;
      
      private var _lc:LoaderContext;
      
      private var commonMod:Object;
      
      private var _giftList:Array;
      
      private var _charaListMinusDeadPeople:Array;
      
      private var _reconnectMsgSend:Boolean = false;
      
      public function GameServerApproachFrame()
      {
         this._charactersList = new Vector.<BasicCharacterWrapper>();
         this._charactersToRemodelList = new Array();
         this._kernel = KernelEventsManager.getInstance();
         this._lc = new LoaderContext(false,ApplicationDomain.currentDomain);
         this.commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
         this._giftList = new Array();
         this._charaListMinusDeadPeople = new Array();
         super();
      }
      
      private static function onChangeLogError(param1:IOErrorEvent) : void
      {
      }
      
      private static function onChangeLogLoaded(param1:Event) : void
      {
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get giftList() : Array
      {
         return this._giftList;
      }
      
      public function get charaListMinusDeadPeople() : Array
      {
         return this._charaListMinusDeadPeople;
      }
      
      public function get requestedCharaId() : uint
      {
         return this._requestedCharacterId;
      }
      
      public function set requestedCharaId(param1:uint) : void
      {
         this._requestedCharacterId = param1;
      }
      
      public function isCharacterWaitingForChange(param1:uint) : Boolean
      {
         if(this._charactersToRemodelList[param1])
         {
            return true;
         }
         return false;
      }
      
      public function pushed() : Boolean
      {
         SecureModeManager.getInstance().checkMigrate();
         AirScanner.allowByteCodeExecution(this._lc,true);
         Kernel.getWorker().addFrame(new MiscFrame());
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:BasicCharacterWrapper = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:Vector.<int> = null;
         var _loc9_:Boolean = false;
         var _loc10_:Vector.<uint> = null;
         var _loc11_:AuthenticationTicketMessage = null;
         var _loc12_:AuthenticationTicketAcceptedMessage = null;
         var _loc13_:AuthenticationTicketRefusedMessage = null;
         var _loc14_:ServerConnectionFailedMessage = null;
         var _loc15_:AlreadyConnectedMessage = null;
         var _loc16_:CharactersListMessage = null;
         var _loc17_:Vector.<uint> = null;
         var _loc18_:BasicCharacterWrapper = null;
         var _loc19_:Boolean = false;
         var _loc20_:Server = null;
         var _loc21_:BasicCharactersListMessage = null;
         var _loc22_:BasicCharacterWrapper = null;
         var _loc23_:AccountCapabilitiesMessage = null;
         var _loc24_:CharacterCreationAction = null;
         var _loc25_:CharacterCreationRequestMessage = null;
         var _loc26_:Vector.<int> = null;
         var _loc27_:CharacterCreationResultMessage = null;
         var _loc28_:CharacterDeletionAction = null;
         var _loc29_:CharacterDeletionRequestMessage = null;
         var _loc30_:CharacterDeletionErrorMessage = null;
         var _loc31_:String = null;
         var _loc32_:CharacterNameSuggestionRequestAction = null;
         var _loc33_:CharacterNameSuggestionRequestMessage = null;
         var _loc34_:CharacterNameSuggestionSuccessMessage = null;
         var _loc35_:CharacterNameSuggestionFailureMessage = null;
         var _loc36_:CharacterRemodelSelectionAction = null;
         var _loc37_:RemodelingInformation = null;
         var _loc38_:Vector.<int> = null;
         var _loc39_:Boolean = false;
         var _loc40_:CharacterSelectedSuccessMessage = null;
         var _loc41_:ClientKeyMessage = null;
         var _loc42_:GameContextCreateRequestMessage = null;
         var _loc43_:SoundApi = null;
         var _loc44_:LuaPlayer = null;
         var _loc45_:CharacterSelectedErrorMessage = null;
         var _loc46_:BasicTimeMessage = null;
         var _loc47_:Date = null;
         var _loc48_:StartupActionsListMessage = null;
         var _loc49_:ConsoleCommandsListMessage = null;
         var _loc50_:CharactersListWithRemodelingMessage = null;
         var _loc51_:CharacterToRemodelInformations = null;
         var _loc52_:CharacterHardcoreOrEpicInformations = null;
         var _loc53_:CharacterBaseInformations = null;
         var _loc54_:int = 0;
         var _loc55_:CharacterBaseInformations = null;
         var _loc56_:Boolean = false;
         var _loc57_:StartupActionsExecuteMessage = null;
         var _loc58_:BasicCharacterWrapper = null;
         var _loc59_:int = 0;
         var _loc60_:BasicCharacterWrapper = null;
         var _loc61_:CharacterSelectionAction = null;
         var _loc62_:CharacterHardcoreOrEpicInformations = null;
         var _loc63_:CharacterBaseInformations = null;
         var _loc66_:* = 0;
         var _loc67_:Object = null;
         var _loc68_:CharacterReplayWithRemodelRequestMessage = null;
         var _loc69_:CharacterSelectionWithRemodelMessage = null;
         var _loc70_:Object = null;
         var _loc71_:Vector.<int> = null;
         var _loc72_:CreationCharacterWrapper = null;
         var _loc73_:Array = null;
         var _loc74_:Array = null;
         var _loc75_:Boolean = false;
         var _loc76_:CharacterFirstSelectionMessage = null;
         var _loc77_:CharacterReplayRequestMessage = null;
         var _loc78_:CharacterSelectionMessage = null;
         var _loc79_:HelloGameMessage = null;
         var _loc80_:RawDataMessage = null;
         var _loc81_:uint = 0;
         var _loc82_:uint = 0;
         var _loc83_:StartupActionAddObject = null;
         var _loc84_:Array = null;
         var _loc85_:ObjectItemInformationWithQuantity = null;
         var _loc86_:Object = null;
         var _loc87_:ItemWrapper = null;
         var _loc88_:GiftAssignRequestAction = null;
         var _loc89_:StartupActionsObjetAttributionMessage = null;
         var _loc90_:StartupActionFinishedMessage = null;
         var _loc91_:int = 0;
         var _loc92_:Object = null;
         var _loc93_:uint = 0;
         var _loc3_:* = undefined;
         var _loc64_:* = undefined;
         var _loc65_:* = undefined;
         switch(true)
         {
            case param1 is HelloGameMessage:
               _loc79_ = param1 as HelloGameMessage;
               NetworkMessage.setEncryptionKey(_loc79_.encryptionKey);
               ConnectionsHandler.confirmGameServerConnection();
               _loc10_ = PartManager.getInstance().getServerPartList();
               (_loc11_ = new AuthenticationTicketMessage()).initAuthenticationTicketMessage(LangManager.getInstance().getEntry("config.lang.current"),AuthentificationManager.getInstance().gameServerTicket);
               ConnectionsHandler.getConnection().send(_loc11_);
               InactivityManager.getInstance().start();
               this._kernel.processCallback(HookList.AuthenticationTicket);
               return true;
            case param1 is AuthenticationTicketAcceptedMessage:
               _loc12_ = param1 as AuthenticationTicketAcceptedMessage;
               setTimeout(this.requestCharactersList,500);
               this._kernel.processCallback(HookList.AuthenticationTicketAccepted);
               return true;
            case param1 is AuthenticationTicketRefusedMessage:
               _loc13_ = param1 as AuthenticationTicketRefusedMessage;
               this._kernel.processCallback(HookList.AuthenticationTicketRefused);
               return true;
            case param1 is ServerConnectionFailedMessage:
               if((_loc14_ = ServerConnectionFailedMessage(param1)).failedConnection == ConnectionsHandler.getConnection().getSubConnection(_loc14_))
               {
                  PlayerManager.getInstance().destroy();
                  this.commonMod.openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.connexion.gameConnexionFailed"),[I18n.getUiText("ui.common.ok")],[this.onEscapePopup],this.onEscapePopup,this.onEscapePopup);
                  KernelEventsManager.getInstance().processCallback(HookList.SelectedServerFailed);
               }
               return true;
            case param1 is AlreadyConnectedMessage:
               _loc15_ = AlreadyConnectedMessage(param1);
               KernelEventsManager.getInstance().processCallback(HookList.AlreadyConnected);
               return true;
            case param1 is CharactersListMessage:
               _loc16_ = param1 as CharactersListMessage;
               _loc17_ = new Vector.<uint>();
               if(param1 is CharactersListWithRemodelingMessage)
               {
                  _loc50_ = param1 as CharactersListWithRemodelingMessage;
                  for each(_loc51_ in _loc50_.charactersToRemodel)
                  {
                     this._charactersToRemodelList[_loc51_.id] = _loc51_;
                  }
               }
               this._charactersList = new Vector.<BasicCharacterWrapper>();
               _loc19_ = false;
               if((_loc20_ = PlayerManager.getInstance().server).gameTypeId == 1 || _loc20_.gameTypeId == 4)
               {
                  for each(_loc52_ in _loc16_.characters)
                  {
                     if(_loc17_.indexOf(_loc52_.id) != -1)
                     {
                        _loc19_ = true;
                     }
                     _loc18_ = BasicCharacterWrapper.create(_loc52_.id,_loc52_.name,_loc52_.level,_loc52_.entityLook,_loc52_.breed,_loc52_.sex,_loc52_.deathState,_loc52_.deathCount,1,_loc19_);
                     this._charactersList.push(_loc18_);
                  }
               }
               else
               {
                  for each(_loc53_ in _loc16_.characters)
                  {
                     if(_loc17_.indexOf(_loc53_.id) != -1)
                     {
                        _loc19_ = true;
                     }
                     _loc54_ = 1;
                     for each(_loc55_ in _loc16_.characters)
                     {
                        if(_loc55_.id != _loc53_.id && _loc55_.level > _loc53_.level && _loc54_ < 4)
                        {
                           _loc54_ = _loc54_ + 1;
                        }
                     }
                     _loc18_ = BasicCharacterWrapper.create(_loc53_.id,_loc53_.name,_loc53_.level,_loc53_.entityLook,_loc53_.breed,_loc53_.sex,0,0,_loc54_,_loc19_);
                     this._charactersList.push(_loc18_);
                  }
               }
               PlayerManager.getInstance().charactersList = this._charactersList;
               if(this._charactersList.length)
               {
                  _loc56_ = true;
                  if(_loc16_.hasStartupActions)
                  {
                     (_loc57_ = new StartupActionsExecuteMessage()).initStartupActionsExecuteMessage();
                     ConnectionsHandler.getConnection().send(_loc57_);
                     _loc56_ = false;
                  }
                  else if((Dofus.getInstance().options && Dofus.getInstance().options.autoConnectType == 2 || PlayerManager.getInstance().autoConnectOfASpecificCharacterId > -1) && PlayerManager.getInstance().allowAutoConnectCharacter)
                  {
                     if((_loc59_ = PlayerManager.getInstance().autoConnectOfASpecificCharacterId) == -1)
                     {
                        _loc58_ = this._charactersList[0];
                     }
                     else
                     {
                        for each(_loc60_ in this._charactersList)
                        {
                           if(_loc60_.id == _loc59_)
                           {
                              _loc58_ = _loc60_;
                              break;
                           }
                        }
                     }
                     if(_loc58_ && ((_loc20_.gameTypeId != 1 && _loc20_.gameTypeId != 4 || _loc58_.deathState == 0) && !SecureModeManager.getInstance().active && !this.isCharacterWaitingForChange(_loc58_.id)))
                     {
                        _loc56_ = false;
                        this._kernel.processCallback(HookList.CharactersListUpdated,this._charactersList);
                        (_loc61_ = new CharacterSelectionAction()).btutoriel = false;
                        _loc61_.characterId = _loc58_.id;
                        this.process(_loc61_);
                        PlayerManager.getInstance().allowAutoConnectCharacter = false;
                     }
                  }
                  if(_loc56_)
                  {
                     if(!Berilia.getInstance().getUi("characterSelection"))
                     {
                        this._kernel.processCallback(HookList.CharacterSelectionStart,this._charactersList);
                     }
                     else
                     {
                        this._kernel.processCallback(HookList.CharactersListUpdated,this._charactersList);
                     }
                  }
               }
               else
               {
                  this._kernel.processCallback(HookList.CharacterCreationStart,[["create"],true]);
                  this._kernel.processCallback(HookList.CharactersListUpdated,this._charactersList);
               }
               return true;
            case param1 is BasicCharactersListMessage:
               _loc21_ = param1 as BasicCharactersListMessage;
               this._charactersList = new Vector.<BasicCharacterWrapper>();
               if(PlayerManager.getInstance().server.gameTypeId == 1 || PlayerManager.getInstance().server.gameTypeId == 4)
               {
                  for each(_loc62_ in _loc21_.characters)
                  {
                     _loc22_ = BasicCharacterWrapper.create(_loc62_.id,_loc62_.name,_loc62_.level,_loc62_.entityLook,_loc62_.breed,_loc62_.sex,_loc62_.deathState,_loc62_.deathCount,1,false);
                     this._charactersList.push(_loc22_);
                  }
               }
               else
               {
                  for each(_loc63_ in _loc21_.characters)
                  {
                     _loc22_ = BasicCharacterWrapper.create(_loc63_.id,_loc63_.name,_loc63_.level,_loc63_.entityLook,_loc63_.breed,_loc63_.sex,0,0,1,false);
                     this._charactersList.push(_loc22_);
                  }
               }
               PlayerManager.getInstance().charactersList = this._charactersList;
               return true;
            case param1 is CharactersListErrorMessage:
               this.commonMod.openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.connexion.charactersListError"),[I18n.getUiText("ui.common.ok")]);
               return false;
            case param1 is AccountCapabilitiesMessage:
               _loc23_ = param1 as AccountCapabilitiesMessage;
               this._kernel.processCallback(HookList.TutorielAvailable,_loc23_.tutorialAvailable);
               this._kernel.processCallback(HookList.BreedsAvailable,_loc23_.breedsAvailable,_loc23_.breedsVisible);
               PlayerManager.getInstance().adminStatus = _loc23_.status;
               KernelEventsManager.getInstance().processCallback(HookList.CharacterCreationStart,[["create"]]);
               return true;
            case param1 is CharacterCreationAction:
               _loc24_ = param1 as CharacterCreationAction;
               _loc25_ = new CharacterCreationRequestMessage();
               _loc26_ = new Vector.<int>();
               for each(_loc64_ in _loc24_.colors)
               {
                  _loc26_.push(_loc64_);
               }
               while(_loc26_.length < ProtocolConstantsEnum.MAX_PLAYER_COLOR)
               {
                  _loc26_.push(-1);
               }
               _loc25_.initCharacterCreationRequestMessage(_loc24_.name,_loc24_.breed,_loc24_.sex,_loc26_,_loc24_.head);
               ConnectionsHandler.getConnection().send(_loc25_);
               return true;
            case param1 is CharacterCreationResultMessage:
               _loc27_ = param1 as CharacterCreationResultMessage;
               this._kernel.processCallback(HookList.CharacterCreationResult,_loc27_.result);
               return true;
            case param1 is CharacterDeletionAction:
               _loc28_ = param1 as CharacterDeletionAction;
               (_loc29_ = new CharacterDeletionRequestMessage()).initCharacterDeletionRequestMessage(_loc28_.id,MD5.hash(_loc28_.id + "~" + _loc28_.answer));
               ConnectionsHandler.getConnection().send(_loc29_);
               return true;
            case param1 is CharacterDeletionErrorMessage:
               _loc30_ = param1 as CharacterDeletionErrorMessage;
               _loc31_ = "";
               if(_loc30_.reason == CharacterDeletionErrorEnum.DEL_ERR_TOO_MANY_CHAR_DELETION)
               {
                  _loc31_ = "TooManyDeletion";
               }
               else if(_loc30_.reason == CharacterDeletionErrorEnum.DEL_ERR_BAD_SECRET_ANSWER)
               {
                  _loc31_ = "WrongAnswer";
               }
               else if(_loc30_.reason == CharacterDeletionErrorEnum.DEL_ERR_RESTRICED_ZONE)
               {
                  _loc31_ = "UnsecureMode";
               }
               this._kernel.processCallback(HookList.CharacterDeletionError,_loc31_);
               return true;
            case param1 is CharacterNameSuggestionRequestAction:
               _loc32_ = param1 as CharacterNameSuggestionRequestAction;
               (_loc33_ = new CharacterNameSuggestionRequestMessage()).initCharacterNameSuggestionRequestMessage();
               ConnectionsHandler.getConnection().send(_loc33_);
               return true;
            case param1 is CharacterNameSuggestionSuccessMessage:
               _loc34_ = param1 as CharacterNameSuggestionSuccessMessage;
               this._kernel.processCallback(HookList.CharacterNameSuggestioned,_loc34_.suggestion);
               return true;
            case param1 is CharacterNameSuggestionFailureMessage:
               _loc35_ = param1 as CharacterNameSuggestionFailureMessage;
               _log.error("Generation de nom impossible !");
               return true;
            case param1 is CharacterSelectedForceMessage:
               if(!this._reconnectMsgSend)
               {
                  Kernel.beingInReconection = true;
                  _loc4_ = CharacterSelectedForceMessage(param1).id;
                  this._reconnectMsgSend = true;
                  ConnectionsHandler.getConnection().send(new CharacterSelectedForceReadyMessage());
               }
               return true;
            case param1 is CharacterRemodelSelectionAction:
               _loc36_ = param1 as CharacterRemodelSelectionAction;
               (_loc37_ = new RemodelingInformation()).sex = _loc36_.sex;
               _loc37_.breed = _loc36_.breed;
               _loc37_.cosmeticId = _loc36_.cosmeticId;
               _loc37_.name = _loc36_.name;
               _loc38_ = new Vector.<int>();
               for(_loc65_ in _loc36_.colors)
               {
                  if((_loc66_ = int(_loc36_.colors[_loc65_])) >= 0)
                  {
                     _loc66_ = _loc66_ & 16777215;
                     _loc38_.push(_loc66_ | int(_loc65_) + 1 << 24);
                  }
               }
               _loc37_.colors = _loc38_;
               if(PlayerManager.getInstance().server.gameTypeId == 1 || PlayerManager.getInstance().server.gameTypeId == 4)
               {
                  for each(_loc67_ in this._charactersList)
                  {
                     if(_loc67_.id == this._requestedToRemodelCharacterId)
                     {
                        if(_loc67_.deathState == 1)
                        {
                           _loc9_ = true;
                        }
                        else if(_loc67_.deathState == 0)
                        {
                           _loc9_ = false;
                        }
                        else
                        {
                           this.commonMod.openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.common.cantSelectThisCharacterLimb"),[I18n.getUiText("ui.common.ok")]);
                        }
                     }
                  }
               }
               else
               {
                  _loc9_ = false;
               }
               if(_loc9_)
               {
                  (_loc68_ = new CharacterReplayWithRemodelRequestMessage()).initCharacterReplayWithRemodelRequestMessage(this._requestedToRemodelCharacterId,_loc37_);
                  ConnectionsHandler.getConnection().send(_loc68_);
               }
               else
               {
                  (_loc69_ = new CharacterSelectionWithRemodelMessage()).initCharacterSelectionWithRemodelMessage(this._requestedToRemodelCharacterId,_loc37_);
                  ConnectionsHandler.getConnection().send(_loc69_);
               }
               return true;
            case param1 is CharacterDeselectionAction:
               this._requestedCharacterId = 0;
               return true;
            case param1 is CharacterSelectionAction:
            case param1 is CharacterReplayRequestAction:
               if(this._requestedCharacterId)
               {
                  return false;
               }
               _loc39_ = false;
               if(param1 is CharacterSelectionAction)
               {
                  _loc4_ = (param1 as CharacterSelectionAction).characterId;
                  _loc39_ = (param1 as CharacterSelectionAction).btutoriel;
                  _loc9_ = false;
               }
               else if(param1 is CharacterReplayRequestAction)
               {
                  _loc4_ = (param1 as CharacterReplayRequestAction).characterId;
                  _loc39_ = false;
                  _loc9_ = true;
               }
               this._requestedCharacterId = _loc4_;
               if(this._charactersToRemodelList[_loc4_])
               {
                  this._requestedToRemodelCharacterId = _loc4_;
                  _loc70_ = this._charactersToRemodelList[_loc4_];
                  _loc71_ = this.getCharacterColorsInformations(_loc70_);
                  _loc72_ = CreationCharacterWrapper.create(_loc70_.name,_loc70_.sex,_loc70_.breed,_loc70_.cosmeticId,_loc71_);
                  for each(_loc2_ in this._charactersList)
                  {
                     if(_loc2_.id == _loc4_)
                     {
                        _loc72_.entityLook = _loc2_.entityLook;
                     }
                  }
                  _loc73_ = new Array();
                  if((_loc70_.possibleChangeMask & CharacterRemodelingEnum.CHARACTER_REMODELING_BREED) > 0)
                  {
                     _loc73_.push("rebreed");
                  }
                  if((_loc70_.possibleChangeMask & CharacterRemodelingEnum.CHARACTER_REMODELING_COLORS) > 0)
                  {
                     _loc73_.push("recolor");
                  }
                  if((_loc70_.possibleChangeMask & CharacterRemodelingEnum.CHARACTER_REMODELING_COSMETIC) > 0)
                  {
                     _loc73_.push("relook");
                  }
                  if((_loc70_.possibleChangeMask & CharacterRemodelingEnum.CHARACTER_REMODELING_NAME) > 0)
                  {
                     _loc73_.push("rename");
                  }
                  if((_loc70_.possibleChangeMask & CharacterRemodelingEnum.CHARACTER_REMODELING_GENDER) > 0)
                  {
                     _loc73_.push("regender");
                  }
                  _loc74_ = new Array();
                  if((_loc70_.mandatoryChangeMask & CharacterRemodelingEnum.CHARACTER_REMODELING_BREED) > 0)
                  {
                     _loc74_.push("rebreed");
                  }
                  if((_loc70_.mandatoryChangeMask & CharacterRemodelingEnum.CHARACTER_REMODELING_COLORS) > 0)
                  {
                     _loc74_.push("recolor");
                  }
                  if((_loc70_.mandatoryChangeMask & CharacterRemodelingEnum.CHARACTER_REMODELING_COSMETIC) > 0)
                  {
                     _loc74_.push("relook");
                  }
                  if((_loc70_.mandatoryChangeMask & CharacterRemodelingEnum.CHARACTER_REMODELING_NAME) > 0)
                  {
                     _loc74_.push("rename");
                  }
                  if((_loc70_.mandatoryChangeMask & CharacterRemodelingEnum.CHARACTER_REMODELING_GENDER) > 0)
                  {
                     _loc74_.push("regender");
                  }
                  this._kernel.processCallback(HookList.CharacterCreationStart,new Array(_loc73_,_loc74_,_loc72_));
               }
               else
               {
                  _loc75_ = _loc39_;
                  if(_loc39_)
                  {
                     (_loc76_ = new CharacterFirstSelectionMessage()).initCharacterFirstSelectionMessage(_loc4_,true);
                     ConnectionsHandler.getConnection().send(_loc76_);
                  }
                  else if(_loc9_)
                  {
                     (_loc77_ = new CharacterReplayRequestMessage()).initCharacterReplayRequestMessage(_loc4_);
                     ConnectionsHandler.getConnection().send(_loc77_);
                  }
                  else
                  {
                     (_loc78_ = new CharacterSelectionMessage()).initCharacterSelectionMessage(_loc4_);
                     ConnectionsHandler.getConnection().send(_loc78_);
                  }
               }
               return true;
               break;
            case param1 is CharacterSelectedSuccessMessage:
               _loc40_ = param1 as CharacterSelectedSuccessMessage;
               ConnectionsHandler.pause();
               if(this._gmaf == null)
               {
                  this._gmaf = new LoadingModuleFrame();
                  Kernel.getWorker().addFrame(this._gmaf);
               }
               PlayedCharacterManager.getInstance().infos = _loc40_.infos;
               DataStoreType.CHARACTER_ID = _loc40_.infos.id.toString();
               Kernel.getWorker().pause();
               this._cssmsg = _loc40_;
               UiModuleManager.getInstance().reset();
               if(PlayerManager.getInstance().hasRights)
               {
                  UiModuleManager.getInstance().init(Constants.PRE_GAME_MODULE,false);
               }
               else
               {
                  UiModuleManager.getInstance().init(Constants.PRE_GAME_MODULE.concat(Constants.ADMIN_MODULE),false);
               }
               Dofus.getInstance().renameApp(_loc40_.infos.name);
               if(AirScanner.hasAir())
               {
                  ExternalNotificationManager.getInstance().init();
               }
               StatisticsManager.getInstance().statsEnabled = _loc40_.isCollectingStats;
               return true;
            case param1 is AllModulesLoadedMessage:
               this._gmaf = null;
               Kernel.getWorker().addFrame(new WorldFrame());
               Kernel.getWorker().addFrame(new AlignmentFrame());
               Kernel.getWorker().addFrame(new SynchronisationFrame());
               Kernel.getWorker().addFrame(new LivingObjectFrame());
               Kernel.getWorker().addFrame(new AllianceFrame());
               Kernel.getWorker().addFrame(new PlayedCharacterUpdatesFrame());
               Kernel.getWorker().addFrame(new SocialFrame());
               Kernel.getWorker().addFrame(new SpellInventoryManagementFrame());
               Kernel.getWorker().addFrame(new InventoryManagementFrame());
               Kernel.getWorker().addFrame(new ContextChangeFrame());
               Kernel.getWorker().addFrame(new CommonUiFrame());
               Kernel.getWorker().addFrame(new ChatFrame());
               Kernel.getWorker().addFrame(new JobsFrame());
               Kernel.getWorker().addFrame(new MountFrame());
               Kernel.getWorker().addFrame(new HouseFrame());
               Kernel.getWorker().addFrame(new EmoticonFrame());
               Kernel.getWorker().addFrame(new QuestFrame());
               Kernel.getWorker().addFrame(new TinselFrame());
               Kernel.getWorker().addFrame(new PartyManagementFrame());
               Kernel.getWorker().addFrame(new ProtectPishingFrame());
               Kernel.getWorker().addFrame(new StackManagementFrame());
               Kernel.getWorker().addFrame(new ExternalGameFrame());
               Kernel.getWorker().addFrame(new AveragePricesFrame());
               Kernel.getWorker().addFrame(new CameraControlFrame());
               Kernel.getWorker().addFrame(new IdolsFrame());
               Kernel.getWorker().addFrame(new RoleplayIntroductionFrame());
               Kernel.getWorker().addFrame(new ScreenCaptureFrame());
               Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(GameStartingFrame));
               Kernel.getWorker().resume();
               ConnectionsHandler.resume();
               if(Kernel.beingInReconection && !this._reconnectMsgSend)
               {
                  this._reconnectMsgSend = true;
                  ConnectionsHandler.getConnection().send(new CharacterSelectedForceReadyMessage());
               }
               if(this._cssmsg != null)
               {
                  PlayedCharacterManager.getInstance().infos = this._cssmsg.infos;
                  DataStoreType.CHARACTER_ID = this._cssmsg.infos.id.toString();
               }
               Kernel.getWorker().removeFrame(this);
               if(PlayerManager.getInstance().subscriptionEndDate > 0)
               {
                  PartManager.getInstance().checkAndDownload("all");
                  PartManager.getInstance().checkAndDownload("subscribed");
               }
               if(XmlConfig.getInstance().getBooleanEntry("config.dev.mode"))
               {
                  ModuleDebugManager.display(XmlConfig.getInstance().getBooleanEntry("config.dev.auto.display.controler"));
                  Console.getInstance().display(!XmlConfig.getInstance().getBooleanEntry("config.dev.auto.display.eventUtil"));
                  ConsoleLUA.getInstance().display(!XmlConfig.getInstance().getBooleanEntry("config.dev.auto.display.luaUtil"));
                  if(XmlConfig.getInstance().getBooleanEntry("config.dev.auto.display.fpsManager"))
                  {
                     FpsManager.getInstance().display();
                     if(_loc81_ = XmlConfig.getInstance().getEntry("config.dev.auto.display.fpsManager.state"))
                     {
                        _loc82_ = 0;
                        while(_loc82_ < _loc81_)
                        {
                           FpsManager.getInstance().changeState();
                           _loc82_++;
                        }
                     }
                  }
               }
               else
               {
                  Console.logChatMessagesOnly = true;
                  Console.getInstance().activate();
               }
               this._kernel.processCallback(HookList.GameStart);
               Kernel.getWorker().addFrame(new ServerTransferFrame());
               (_loc41_ = new ClientKeyMessage()).initClientKeyMessage(InterClientManager.getInstance().flashKey);
               ConnectionsHandler.getConnection().send(_loc41_);
               _loc42_ = new GameContextCreateRequestMessage();
               ConnectionsHandler.getConnection().send(_loc42_);
               (_loc43_ = new SoundApi()).stopIntroMusic();
               Shortcut.loadSavedData();
               if(!(_loc44_ = ScriptsManager.getInstance().getPlayer(ScriptsManager.LUA_PLAYER) as LuaPlayer))
               {
                  _loc44_ = new LuaPlayer();
                  ScriptsManager.getInstance().addPlayer(ScriptsManager.LUA_PLAYER,_loc44_);
                  ScriptsManager.getInstance().addPlayerApi(_loc44_,"EntityApi",new EntityApi());
                  ScriptsManager.getInstance().addPlayerApi(_loc44_,"SeqApi",new ScriptSequenceApi());
                  ScriptsManager.getInstance().addPlayerApi(_loc44_,"CameraApi",new CameraApi());
               }
               return true;
            case param1 is ConnectionResumedMessage:
               return true;
            case param1 is CharacterSelectedErrorMessage:
               _loc45_ = param1 as CharacterSelectedErrorMessage;
               this._kernel.processCallback(HookList.CharacterImpossibleSelection,this._requestedCharacterId);
               this._requestedCharacterId = 0;
               return true;
            case param1 is BasicTimeMessage:
               _loc46_ = param1 as BasicTimeMessage;
               _loc47_ = new Date();
               TimeManager.getInstance().serverTimeLag = _loc46_.timestamp + _loc46_.timezoneOffset * 60 * 1000 - _loc47_.getTime();
               TimeManager.getInstance().serverUtcTimeLag = _loc46_.timestamp - _loc47_.getTime();
               TimeManager.getInstance().timezoneOffset = _loc46_.timezoneOffset * 60 * 1000;
               TimeManager.getInstance().dofusTimeYearLag = -1370;
               return true;
            case param1 is StartupActionsListMessage:
               _loc48_ = param1 as StartupActionsListMessage;
               this._giftList = new Array();
               for each(_loc83_ in _loc48_.actions)
               {
                  _loc84_ = new Array();
                  for each(_loc85_ in _loc83_.items)
                  {
                     _loc87_ = ItemWrapper.create(0,0,_loc85_.objectGID,_loc85_.quantity,_loc85_.effects,false);
                     _loc84_.push(_loc87_);
                  }
                  _loc86_ = {
                     "uid":_loc83_.uid,
                     "title":_loc83_.title,
                     "text":_loc83_.text,
                     "items":_loc84_
                  };
                  this._giftList.push(_loc86_);
               }
               if(this._giftList.length)
               {
                  this._charaListMinusDeadPeople = new Array();
                  for each(_loc2_ in this._charactersList)
                  {
                     if(!_loc2_.deathState || _loc2_.deathState == 0)
                     {
                        this._charaListMinusDeadPeople.push(_loc2_);
                     }
                  }
                  if(!Berilia.getInstance().getUi("characterSelection"))
                  {
                     this._kernel.processCallback(HookList.CharacterSelectionStart,this._charactersList);
                  }
                  else
                  {
                     this._kernel.processCallback(HookList.CharactersListUpdated,this._charactersList);
                  }
               }
               else
               {
                  Kernel.getWorker().removeFrame(this);
                  _log.warn("Empty Gift List Received");
               }
               return true;
            case param1 is GiftAssignRequestAction:
               _loc88_ = param1 as GiftAssignRequestAction;
               (_loc89_ = new StartupActionsObjetAttributionMessage()).initStartupActionsObjetAttributionMessage(_loc88_.giftId,_loc88_.characterId);
               ConnectionsHandler.getConnection().send(_loc89_);
               return true;
            case param1 is StartupActionFinishedMessage:
               _loc90_ = param1 as StartupActionFinishedMessage;
               _loc91_ = -1;
               for each(_loc92_ in this._giftList)
               {
                  if(_loc92_.uid == _loc90_.actionId)
                  {
                     _loc91_ = this._giftList.indexOf(_loc92_);
                     break;
                  }
               }
               if(_loc91_ > -1)
               {
                  this._giftList.splice(_loc91_,1);
                  KernelEventsManager.getInstance().processCallback(HookList.GiftAssigned,_loc90_.actionId);
               }
               return true;
            case param1 is ConsoleCommandsListMessage:
               _loc49_ = param1 as ConsoleCommandsListMessage;
               _loc93_ = 0;
               while(_loc93_ < _loc49_.aliases.length)
               {
                  new ServerCommand(_loc49_.aliases[_loc93_],_loc49_.descriptions[_loc93_]);
                  _loc93_++;
               }
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function getCharacterColorsInformations(param1:*) : Vector.<int>
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         if(!param1 || !param1.colors)
         {
            return null;
         }
         var _loc5_:Vector.<int> = new Vector.<int>();
         while(_loc6_ < ProtocolConstantsEnum.MAX_PLAYER_COLOR)
         {
            _loc5_.push(-1);
            _loc6_++;
         }
         var _loc7_:int = param1.colors.length;
         while(_loc8_ < _loc7_)
         {
            _loc2_ = param1.colors[_loc8_];
            _loc3_ = (_loc2_ >> 24) - 1;
            _loc4_ = _loc2_ & 16777215;
            if(_loc3_ > -1 && _loc3_ < _loc5_.length)
            {
               _loc5_[_loc3_] = _loc4_;
            }
            _loc8_++;
         }
         return _loc5_;
      }
      
      private function onEscapePopup() : void
      {
         Kernel.getInstance().reset();
      }
      
      private function requestCharactersList() : void
      {
         var _loc1_:CharactersListRequestMessage = new CharactersListRequestMessage();
         if(ConnectionsHandler && ConnectionsHandler.getConnection())
         {
            ConnectionsHandler.getConnection().send(_loc1_);
         }
      }
   }
}
