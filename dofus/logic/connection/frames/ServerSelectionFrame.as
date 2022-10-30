package com.ankamagames.dofus.logic.connection.frames
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.net.DisconnectionReasonEnum;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.actions.AcquaintanceSearchAction;
   import com.ankamagames.dofus.logic.connection.actions.ServerSelectionAction;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.connection.managers.GuestModeManager;
   import com.ankamagames.dofus.logic.game.approach.frames.GameServerApproachFrame;
   import com.ankamagames.dofus.logic.shield.SecureModeManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.ServerConnectionErrorEnum;
   import com.ankamagames.dofus.network.enums.ServerStatusEnum;
   import com.ankamagames.dofus.network.messages.connection.SelectedServerDataExtendedMessage;
   import com.ankamagames.dofus.network.messages.connection.SelectedServerDataMessage;
   import com.ankamagames.dofus.network.messages.connection.SelectedServerRefusedMessage;
   import com.ankamagames.dofus.network.messages.connection.ServerSelectionMessage;
   import com.ankamagames.dofus.network.messages.connection.ServerStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.connection.ServersListMessage;
   import com.ankamagames.dofus.network.messages.connection.search.AcquaintanceSearchErrorMessage;
   import com.ankamagames.dofus.network.messages.connection.search.AcquaintanceSearchMessage;
   import com.ankamagames.dofus.network.messages.connection.search.AcquaintanceServerListMessage;
   import com.ankamagames.dofus.network.types.connection.GameServerInformations;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.*;
   import com.ankamagames.jerakine.network.messages.ExpectedSocketClosureMessage;
   import com.ankamagames.jerakine.network.messages.WrongSocketClosureReasonMessage;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.crypto.symmetric.ICipher;
   import com.hurlant.crypto.symmetric.NullPad;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class ServerSelectionFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ServerSelectionFrame));
       
      
      private var _serversList:Vector.<GameServerInformations>;
      
      private var _serversUsedList:Vector.<GameServerInformations>;
      
      private var _selectedServer:SelectedServerDataMessage;
      
      private var _worker:Worker;
      
      public function ServerSelectionFrame()
      {
         super();
      }
      
      private static function serverDateSortFunction(param1:GameServerInformations, param2:GameServerInformations) : Number
      {
         if(param1.date < param2.date)
         {
            return 1;
         }
         if(param1.date == param2.date)
         {
            return 0;
         }
         return -1;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get usedServers() : Vector.<GameServerInformations>
      {
         return this._serversUsedList;
      }
      
      public function get servers() : Vector.<GameServerInformations>
      {
         return this._serversList;
      }
      
      public function pushed() : Boolean
      {
         this._worker = Kernel.getWorker();
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:ServersListMessage = null;
         var _loc3_:ServerStatusUpdateMessage = null;
         var _loc4_:ServerSelectionAction = null;
         var _loc5_:SelectedServerDataExtendedMessage = null;
         var _loc6_:SelectedServerDataMessage = null;
         var _loc7_:ICipher = null;
         var _loc8_:ByteArray = null;
         var _loc9_:ExpectedSocketClosureMessage = null;
         var _loc10_:AcquaintanceSearchAction = null;
         var _loc11_:AcquaintanceSearchMessage = null;
         var _loc12_:AcquaintanceSearchErrorMessage = null;
         var _loc13_:String = null;
         var _loc14_:AcquaintanceServerListMessage = null;
         var _loc15_:SelectedServerRefusedMessage = null;
         var _loc16_:* = null;
         var _loc17_:* = undefined;
         var _loc18_:ServerSelectionMessage = null;
         var _loc19_:* = null;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         switch(true)
         {
            case param1 is ServersListMessage:
               _loc2_ = param1 as ServersListMessage;
               PlayerManager.getInstance().server = null;
               this._serversList = _loc2_.servers;
               this._serversList.sort(serverDateSortFunction);
               if(!Berilia.getInstance().uiList["CharacterHeader"])
               {
                  KernelEventsManager.getInstance().processCallback(HookList.AuthenticationTicketAccepted);
               }
               this.broadcastServersListUpdate();
               return true;
            case param1 is ServerStatusUpdateMessage:
               _loc3_ = param1 as ServerStatusUpdateMessage;
               this._serversList.forEach(this.getUpdateServerFunction(_loc3_.server));
               _log.info("Server " + _loc3_.server.id + " status changed to " + _loc3_.server.status + ".");
               this.broadcastServersListUpdate();
               return true;
            case param1 is ServerSelectionAction:
               _loc4_ = param1 as ServerSelectionAction;
               GuestModeManager.getInstance().forceGuestMode = false;
               for each(_loc17_ in this._serversList)
               {
                  if(_loc17_.id == _loc4_.serverId)
                  {
                     if(_loc17_.status == ServerStatusEnum.ONLINE)
                     {
                        (_loc18_ = new ServerSelectionMessage()).initServerSelectionMessage(_loc4_.serverId);
                        ConnectionsHandler.getConnection().send(_loc18_);
                     }
                     else
                     {
                        _loc19_ = "Status";
                        switch(_loc17_.status)
                        {
                           case ServerStatusEnum.OFFLINE:
                              _loc19_ = _loc19_ + "Offline";
                              break;
                           case ServerStatusEnum.STARTING:
                              _loc19_ = _loc19_ + "Starting";
                              break;
                           case ServerStatusEnum.NOJOIN:
                              _loc19_ = _loc19_ + "Nojoin";
                              break;
                           case ServerStatusEnum.SAVING:
                              _loc19_ = _loc19_ + "Saving";
                              break;
                           case ServerStatusEnum.STOPING:
                              _loc19_ = _loc19_ + "Stoping";
                              break;
                           case ServerStatusEnum.FULL:
                              _loc19_ = _loc19_ + "Full";
                              break;
                           case ServerStatusEnum.STATUS_UNKNOWN:
                           default:
                              _loc19_ = _loc19_ + "Unknown";
                        }
                        KernelEventsManager.getInstance().processCallback(HookList.SelectedServerRefused,_loc17_.id,_loc19_,this.getSelectableServers());
                     }
                  }
               }
               return true;
            case param1 is SelectedServerDataExtendedMessage:
               _loc5_ = param1 as SelectedServerDataExtendedMessage;
               PlayerManager.getInstance().serversList = new Vector.<int>();
               for each(_loc20_ in _loc5_.serverIds)
               {
                  PlayerManager.getInstance().serversList.push(_loc20_);
               }
               break;
            case param1 is SelectedServerDataMessage:
               break;
            case param1 is ExpectedSocketClosureMessage:
               if((_loc9_ = param1 as ExpectedSocketClosureMessage).reason != DisconnectionReasonEnum.SWITCHING_TO_GAME_SERVER)
               {
                  this._worker.process(new WrongSocketClosureReasonMessage(DisconnectionReasonEnum.SWITCHING_TO_GAME_SERVER,_loc9_.reason));
                  return true;
               }
               this._worker.removeFrame(this);
               this._worker.addFrame(new GameServerApproachFrame());
               ConnectionsHandler.connectToGameServer(this._selectedServer.address,this._selectedServer.port);
               return true;
               break;
            case param1 is AcquaintanceSearchAction:
               _loc10_ = param1 as AcquaintanceSearchAction;
               (_loc11_ = new AcquaintanceSearchMessage()).initAcquaintanceSearchMessage(_loc10_.friendName);
               ConnectionsHandler.getConnection().send(_loc11_);
               return true;
            case param1 is AcquaintanceSearchErrorMessage:
               _loc12_ = param1 as AcquaintanceSearchErrorMessage;
               switch(_loc12_.reason)
               {
                  case 1:
                     _loc13_ = "unavailable";
                     break;
                  case 2:
                     _loc13_ = "no_result";
                     break;
                  case 3:
                     _loc13_ = "flood";
                     break;
                  case 0:
                  default:
                     _loc13_ = "unknown";
               }
               KernelEventsManager.getInstance().processCallback(HookList.AcquaintanceSearchError,_loc13_);
               return true;
            case param1 is AcquaintanceServerListMessage:
               _loc14_ = param1 as AcquaintanceServerListMessage;
               KernelEventsManager.getInstance().processCallback(HookList.AcquaintanceServerList,_loc14_.servers);
               return true;
            case param1 is SelectedServerRefusedMessage:
               _loc15_ = param1 as SelectedServerRefusedMessage;
               this._serversList.forEach(this.getUpdateServerStatusFunction(_loc15_.serverId,_loc15_.serverStatus));
               this.broadcastServersListUpdate();
               switch(_loc15_.error)
               {
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_DUE_TO_STATUS:
                     _loc16_ = "Status";
                     switch(_loc15_.serverStatus)
                     {
                        case ServerStatusEnum.OFFLINE:
                           _loc16_ = _loc16_ + "Offline";
                           break;
                        case ServerStatusEnum.STARTING:
                           _loc16_ = _loc16_ + "Starting";
                           break;
                        case ServerStatusEnum.NOJOIN:
                           _loc16_ = _loc16_ + "Nojoin";
                           break;
                        case ServerStatusEnum.SAVING:
                           _loc16_ = _loc16_ + "Saving";
                           break;
                        case ServerStatusEnum.STOPING:
                           _loc16_ = _loc16_ + "Stoping";
                           break;
                        case ServerStatusEnum.FULL:
                           _loc16_ = _loc16_ + "Full";
                           break;
                        case ServerStatusEnum.STATUS_UNKNOWN:
                        default:
                           _loc16_ = _loc16_ + "Unknown";
                     }
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_ACCOUNT_RESTRICTED:
                     _loc16_ = "AccountRestricted";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_COMMUNITY_RESTRICTED:
                     _loc16_ = "CommunityRestricted";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_LOCATION_RESTRICTED:
                     _loc16_ = "LocationRestricted";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_SUBSCRIBERS_ONLY:
                     _loc16_ = "SubscribersOnly";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_REGULAR_PLAYERS_ONLY:
                     _loc16_ = "RegularPlayersOnly";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_NO_REASON:
                  default:
                     _loc16_ = "NoReason";
               }
               KernelEventsManager.getInstance().processCallback(HookList.SelectedServerRefused,_loc15_.serverId,_loc16_,this.getSelectableServers());
               return true;
            default:
               return false;
         }
         _loc6_ = param1 as SelectedServerDataMessage;
         ConnectionsHandler.connectionGonnaBeClosed(DisconnectionReasonEnum.SWITCHING_TO_GAME_SERVER);
         this._selectedServer = _loc6_;
         _loc7_ = Crypto.getCipher("simple-aes256-cbc",AuthentificationManager.getInstance().AESKey,new NullPad());
         AuthentificationManager.getInstance().AESKey.position = 0;
         (_loc8_ = new ByteArray()).writeBytes(AuthentificationManager.getInstance().AESKey,0,16);
         _loc21_ = 0;
         while(_loc21_ < _loc6_.ticket.length)
         {
            _loc8_.writeByte(_loc6_.ticket[_loc21_]);
            _loc21_++;
         }
         _loc7_.decrypt(_loc8_);
         AuthentificationManager.getInstance().gameServerTicket = _loc8_.toString();
         PlayerManager.getInstance().server = Server.getServerById(_loc6_.serverId);
         SecureModeManager.getInstance().initRPC(_loc6_.address + ":" + _loc6_.webapiPort);
         return true;
      }
      
      public function pulled() : Boolean
      {
         this._serversList = null;
         this._serversUsedList = null;
         this._selectedServer = null;
         this._worker = null;
         return true;
      }
      
      private function getSelectableServers() : Array
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = new Array();
         for each(_loc1_ in this._serversList)
         {
            if(_loc1_.status == ServerStatusEnum.ONLINE && _loc1_.isSelectable)
            {
               _loc2_.push(_loc1_.id);
            }
         }
         return _loc2_;
      }
      
      private function broadcastServersListUpdate() : void
      {
         var _loc1_:Object = null;
         this._serversUsedList = new Vector.<GameServerInformations>();
         PlayerManager.getInstance().serversList = new Vector.<int>();
         for each(_loc1_ in this._serversList)
         {
            if(_loc1_.charactersCount > 0)
            {
               this._serversUsedList.push(_loc1_);
               PlayerManager.getInstance().serversList.push(_loc1_.id);
            }
         }
         KernelEventsManager.getInstance().processCallback(HookList.ServersList,this._serversList);
      }
      
      private function getUpdateServerFunction(param1:GameServerInformations) : Function
      {
         var serverToUpdate:GameServerInformations = param1;
         return function(param1:*, param2:int, param3:Vector.<GameServerInformations>):void
         {
            var _loc4_:* = param1 as GameServerInformations;
            if(serverToUpdate.id == _loc4_.id)
            {
               _loc4_.charactersCount = serverToUpdate.charactersCount;
               _loc4_.completion = serverToUpdate.completion;
               _loc4_.isSelectable = serverToUpdate.isSelectable;
               _loc4_.status = serverToUpdate.status;
            }
         };
      }
      
      private function getUpdateServerStatusFunction(param1:uint, param2:uint) : Function
      {
         var serverId:uint = param1;
         var newStatus:uint = param2;
         return function(param1:*, param2:int, param3:Vector.<GameServerInformations>):void
         {
            var _loc4_:* = param1 as GameServerInformations;
            if(serverId == _loc4_.id)
            {
               _loc4_.status = newStatus;
            }
         };
      }
   }
}
