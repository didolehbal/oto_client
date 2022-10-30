package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.dofus.kernel.net.ConnectionType;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.KoliseumMessageRouter;
   import com.ankamagames.dofus.network.messages.connection.SelectedServerDataMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AuthenticationTicketAcceptedMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AuthenticationTicketMessage;
   import com.ankamagames.dofus.network.messages.game.approach.HelloGameMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedSuccessMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextCreateRequestMessage;
   import com.ankamagames.dofus.network.messages.game.initialization.CharacterLoadingCompleteMessage;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.messages.RegisteringFrame;
   import com.hurlant.crypto.Crypto;
   import com.hurlant.crypto.symmetric.ICipher;
   import com.hurlant.crypto.symmetric.NullPad;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class ServerTransferFrame extends RegisteringFrame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ServerTransferFrame));
       
      
      private var _newServerLoginTicket:String;
      
      public function ServerTransferFrame()
      {
         super();
      }
      
      override public function pushed() : Boolean
      {
         return true;
      }
      
      override public function pulled() : Boolean
      {
         return true;
      }
      
      override protected function registerMessages() : void
      {
         register(SelectedServerDataMessage,this.onSelectedServerDataMessage);
         register(HelloGameMessage,this.onHelloGameMessage);
         register(AuthenticationTicketAcceptedMessage,this.onAuthenticationTicketAcceptedMessage);
         register(CharacterSelectedSuccessMessage,this.onCharacterSelectedSuccessMessage);
         register(CharacterLoadingCompleteMessage,this.onCharacterLoadingCompleteMessage);
      }
      
      protected function getConnectionType(param1:Message) : String
      {
         return ConnectionsHandler.getConnection().getConnectionId(param1);
      }
      
      private function onCharacterSelectedSuccessMessage(param1:CharacterSelectedSuccessMessage) : void
      {
         PlayedCharacterManager.getInstance().infos = param1.infos;
      }
      
      private function onHelloGameMessage(param1:HelloGameMessage) : Boolean
      {
         var _loc2_:String = XmlConfig.getInstance().getEntry("config.lang.current");
         var _loc3_:AuthenticationTicketMessage = new AuthenticationTicketMessage();
         _loc3_.initAuthenticationTicketMessage(_loc2_,this._newServerLoginTicket);
         switch(this.getConnectionType(param1))
         {
            case ConnectionType.TO_KOLI_SERVER:
               ConnectionsHandler.getConnection().messageRouter = new KoliseumMessageRouter();
               break;
            case ConnectionType.TO_GAME_SERVER:
               ConnectionsHandler.getConnection().messageRouter = null;
         }
         ConnectionsHandler.getConnection().send(_loc3_);
         return true;
      }
      
      private function onAuthenticationTicketAcceptedMessage(param1:AuthenticationTicketAcceptedMessage) : Boolean
      {
         var _loc2_:CharactersListRequestMessage = null;
         switch(this.getConnectionType(param1))
         {
            case ConnectionType.TO_KOLI_SERVER:
               _loc2_ = new CharactersListRequestMessage();
               _loc2_.initCharactersListRequestMessage();
               ConnectionsHandler.getConnection().send(_loc2_);
               return true;
            default:
               return false;
         }
      }
      
      private function onCharacterLoadingCompleteMessage(param1:CharacterLoadingCompleteMessage) : Boolean
      {
         var _loc2_:GameContextCreateRequestMessage = null;
         switch(this.getConnectionType(param1))
         {
            case ConnectionType.TO_KOLI_SERVER:
               _loc2_ = new GameContextCreateRequestMessage();
               _loc2_.initGameContextCreateRequestMessage();
               ConnectionsHandler.getConnection().send(_loc2_);
               return true;
            default:
               return false;
         }
      }
      
      private function onSelectedServerDataMessage(param1:SelectedServerDataMessage) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:ICipher = Crypto.getCipher("simple-aes256-cbc",AuthentificationManager.getInstance().AESKey,new NullPad());
         AuthentificationManager.getInstance().AESKey.position = 0;
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeBytes(AuthentificationManager.getInstance().AESKey,0,16);
         while(_loc4_ < param1.ticket.length)
         {
            _loc3_.writeByte(param1.ticket[_loc4_]);
            _loc4_++;
         }
         _loc2_.decrypt(_loc3_);
         this._newServerLoginTicket = _loc3_.toString();
         ConnectionsHandler.getConnection().mainConnection.close();
         ConnectionsHandler.connectToKoliServer(param1.address,param1.port);
         return true;
      }
   }
}
