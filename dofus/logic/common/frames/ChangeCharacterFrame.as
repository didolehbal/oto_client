package com.ankamagames.dofus.logic.common.frames
{
   import avmplus.getQualifiedClassName;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.logic.common.actions.ChangeCharacterAction;
   import com.ankamagames.dofus.logic.common.actions.ChangeServerAction;
   import com.ankamagames.dofus.logic.common.actions.DirectSelectionCharacterAction;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationWithTicketAction;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.game.common.frames.QuestFrame;
   import com.ankamagames.dofus.misc.utils.errormanager.WebServiceDataHandler;
   import com.ankamagames.dofus.network.messages.game.approach.ReloginTokenRequestMessage;
   import com.ankamagames.dofus.network.messages.game.approach.ReloginTokenStatusMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationListMessage;
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   
   public class ChangeCharacterFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ChangeCharacterFrame));
       
      
      private var _currentAction:Action;
      
      private var _token:String = "";
      
      public function ChangeCharacterFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return 0;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:DirectSelectionCharacterAction = null;
         var _loc3_:ChangeCharacterAction = null;
         var _loc4_:ReloginTokenStatusMessage = null;
         var _loc5_:NotificationListMessage = null;
         var _loc6_:int = 0;
         var _loc7_:ReloginTokenRequestMessage = null;
         var _loc8_:LoginValidationWithTicketAction = null;
         var _loc9_:LoginValidationAction = null;
         var _loc10_:LoginValidationAction = null;
         var _loc11_:ReloginTokenRequestMessage = null;
         var _loc12_:LoginValidationWithTicketAction = null;
         var _loc13_:LoginValidationAction = null;
         var _loc14_:LoginValidationAction = null;
         var _loc15_:ReloginTokenRequestMessage = null;
         var _loc16_:LoginValidationWithTicketAction = null;
         var _loc17_:LoginValidationAction = null;
         var _loc18_:LoginValidationAction = null;
         var _loc19_:int = 0;
         var _loc20_:* = 0;
         var _loc21_:int = 0;
         switch(true)
         {
            case param1 is DirectSelectionCharacterAction:
               _loc2_ = param1 as DirectSelectionCharacterAction;
               if(!this._currentAction)
               {
                  this._currentAction = _loc2_;
                  (_loc7_ = new ReloginTokenRequestMessage()).initReloginTokenRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc7_);
               }
               else
               {
                  this._currentAction = null;
                  WebServiceDataHandler.getInstance().changeCharacter();
                  PlayerManager.getInstance().allowAutoConnectCharacter = true;
                  PlayerManager.getInstance().autoConnectOfASpecificCharacterId = _loc2_.characterId;
                  if(this._token != "")
                  {
                     _loc8_ = LoginValidationWithTicketAction.create(this._token,true,_loc2_.serverId);
                     AuthentificationManager.getInstance().setValidationAction(_loc8_);
                  }
                  else
                  {
                     _loc9_ = AuthentificationManager.getInstance().loginValidationAction;
                     _loc10_ = LoginValidationAction.create(_loc9_.username,_loc9_.password,true,_loc2_.serverId);
                     AuthentificationManager.getInstance().setValidationAction(_loc10_);
                  }
                  SoundManager.getInstance().manager.removeAllSounds();
                  ConnectionsHandler.closeConnection();
                  Kernel.getWorker().resume();
                  Kernel.getInstance().reset(null,AuthentificationManager.getInstance().canAutoConnectWithToken || !AuthentificationManager.getInstance().tokenMode);
               }
               return true;
            case param1 is ChangeCharacterAction:
               _loc3_ = param1 as ChangeCharacterAction;
               if(!this._currentAction)
               {
                  this._currentAction = _loc3_;
                  (_loc11_ = new ReloginTokenRequestMessage()).initReloginTokenRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc11_);
               }
               else
               {
                  this._currentAction = null;
                  WebServiceDataHandler.getInstance().changeCharacter();
                  PlayerManager.getInstance().allowAutoConnectCharacter = false;
                  PlayerManager.getInstance().autoConnectOfASpecificCharacterId = -1;
                  if(this._token != "")
                  {
                     _loc12_ = LoginValidationWithTicketAction.create(this._token,true,_loc3_.serverId);
                     AuthentificationManager.getInstance().setValidationAction(_loc12_);
                  }
                  else
                  {
                     _loc13_ = AuthentificationManager.getInstance().loginValidationAction;
                     _loc14_ = LoginValidationAction.create(_loc13_.username,_loc13_.password,true,_loc3_.serverId);
                     AuthentificationManager.getInstance().setValidationAction(_loc14_);
                  }
                  SoundManager.getInstance().manager.removeAllSounds();
                  ConnectionsHandler.closeConnection();
                  Kernel.getWorker().resume();
                  Kernel.getInstance().reset(null,AuthentificationManager.getInstance().canAutoConnectWithToken || !AuthentificationManager.getInstance().tokenMode);
               }
               return true;
            case param1 is ChangeServerAction:
               if(!this._currentAction)
               {
                  this._currentAction = param1 as ChangeServerAction;
                  (_loc15_ = new ReloginTokenRequestMessage()).initReloginTokenRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc15_);
               }
               else
               {
                  this._currentAction = null;
                  if(this._token != "")
                  {
                     _loc16_ = LoginValidationWithTicketAction.create(this._token,false);
                     AuthentificationManager.getInstance().setValidationAction(_loc16_);
                  }
                  else
                  {
                     _loc17_ = AuthentificationManager.getInstance().loginValidationAction;
                     _loc18_ = LoginValidationAction.create(_loc17_.username,_loc17_.password,false);
                     AuthentificationManager.getInstance().setValidationAction(_loc18_);
                  }
                  ConnectionsHandler.closeConnection();
                  Kernel.getInstance().reset(null,AuthentificationManager.getInstance().canAutoConnectWithToken || !AuthentificationManager.getInstance().tokenMode);
               }
               return true;
            case param1 is ReloginTokenStatusMessage:
               if((_loc4_ = ReloginTokenStatusMessage(param1)).validToken)
               {
                  this._token = _loc4_.token;
                  AuthentificationManager.getInstance().tokenMode = true;
                  AuthentificationManager.getInstance().nextToken = _loc4_.token;
               }
               else
               {
                  this._token = "";
                  AuthentificationManager.getInstance().tokenMode = false;
                  AuthentificationManager.getInstance().nextToken = null;
               }
               this.process(this._currentAction);
               return true;
            case param1 is NotificationListMessage:
               _loc5_ = param1 as NotificationListMessage;
               QuestFrame.notificationList = new Array();
               _loc6_ = _loc5_.flags.length;
               _loc19_ = 0;
               while(_loc19_ < _loc6_)
               {
                  _loc20_ = int(_loc5_.flags[_loc19_]);
                  _loc21_ = 0;
                  while(_loc21_ < 32)
                  {
                     QuestFrame.notificationList[_loc21_ + _loc19_ * 32] = Boolean(_loc20_ & 1);
                     _loc20_ = _loc20_ >> 1;
                     _loc21_++;
                  }
                  _loc19_++;
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
   }
}
