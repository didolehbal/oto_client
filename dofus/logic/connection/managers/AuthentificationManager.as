package com.ankamagames.dofus.logic.connection.managers
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationWithTicketAction;
   import com.ankamagames.dofus.logic.game.common.frames.ProtectPishingFrame;
   import com.ankamagames.dofus.logic.shield.SecureModeManager;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.enums.ClientInstallTypeEnum;
   import com.ankamagames.dofus.network.enums.ClientTechnologyEnum;
   import com.ankamagames.dofus.network.messages.connection.IdentificationAccountForceMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationMessage;
   import com.ankamagames.dofus.network.types.secure.TrustCertificate;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.crypto.Base64;
   import com.ankamagames.jerakine.utils.crypto.RSA;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.filesystem.File;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class AuthentificationManager implements IDestroyable
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AuthentificationManager));
      
      private static var _self:AuthentificationManager;
      
      private static const AES_KEY_LENGTH = 32;
      
      private static const PUBLIC_KEY_V2Base64:String = "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFyRTZ2c3NqdTNLYmlreERoNkU4NG5ib0twRVFDUytUT0k5Uk9EekJFSlhYazczeGVQTnZ0STRHNDBHTi9HNlJSNkk4QnJFd2xNSmN0RHIxeC8xRitRWkdTaHB0bTFvUUVDb0N0WTZYZEVIdHljZW5nS09VY3pESklvRG91UXlDVDNpRmt0YnJndGptWGp2Zi9ibWxNb3NvYkRQS0t2dlhNZnUxZUlxdTlnSDlkOHpKMDcxUWlBRktEcXBPM0lWM09GQ1l5Qno3UG5wZUx0NVF5SDhEZzFic0JsMmdsSmU2ZW9TQXdDOHBmY2tOYUNWeG1VT3dkRXgva0ZnVngxNVhJZ2g1ak91Z1ZkNlZSa0VqVVY0aEJXNlB3REswT1cyaTExZC9BenZPSUQ2aEhYQUQzQlV3S1orem1VeWpleTg4ckdEcU1IVzlaOE5kbjdxNFJLcmZaN3dJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0t";
       
      
      private var PUBLIC_KEY_V2:ByteArray;
      
      private var _publicKey:String;
      
      private var _salt:String;
      
      private var _lva:LoginValidationAction;
      
      private var _certificate:TrustCertificate;
      
      private var _AESKey:ByteArray;
      
      private var _verifyKeyBase64:String = "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlJQklqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUFyRTZ2c3NqdTNLYmlreERoNkU4NG5ib0twRVFDUytUT0k5Uk9EekJFSlhYazczeGVQTnZ0STRHNDBHTi9HNlJSNkk4QnJFd2xNSmN0RHIxeC8xRitRWkdTaHB0bTFvUUVDb0N0WTZYZEVIdHljZW5nS09VY3pESklvRG91UXlDVDNpRmt0YnJndGptWGp2Zi9ibWxNb3NvYkRQS0t2dlhNZnUxZUlxdTlnSDlkOHpKMDcxUWlBRktEcXBPM0lWM09GQ1l5Qno3UG5wZUx0NVF5SDhEZzFic0JsMmdsSmU2ZW9TQXdDOHBmY2tOYUNWeG1VT3dkRXgva0ZnVngxNVhJZ2g1ak91Z1ZkNlZSa0VqVVY0aEJXNlB3REswT1cyaTExZC9BenZPSUQ2aEhYQUQzQlV3S1orem1VeWpleTg4ckdEcU1IVzlaOE5kbjdxNFJLcmZaN3dJREFRQUIKLS0tLS1FTkQgUFVCTElDIEtFWS0tLS0t";
      
      private var _verifyKey:ByteArray;
      
      private var _gameServerTicket:String;
      
      public var ankamaPortalKey:String;
      
      public var username:String;
      
      public var nextToken:String;
      
      public var tokenMode:Boolean = false;
      
      public function AuthentificationManager()
      {
         this.PUBLIC_KEY_V2 = new ByteArray();
         this._verifyKey = new ByteArray();
         super();
         this._verifyKey = Base64.decodeToByteArray(this._verifyKeyBase64);
         this.PUBLIC_KEY_V2 = Base64.decodeToByteArray(PUBLIC_KEY_V2Base64);
         if(_self != null)
         {
            throw new SingletonError("AuthentificationManager is a singleton and should not be instanciated directly.");
         }
      }
      
      public static function getInstance() : AuthentificationManager
      {
         if(_self == null)
         {
            _self = new AuthentificationManager();
         }
         return _self;
      }
      
      public function get gameServerTicket() : String
      {
         return this._gameServerTicket;
      }
      
      public function set gameServerTicket(param1:String) : void
      {
         this._gameServerTicket = param1;
      }
      
      public function get salt() : String
      {
         return this._salt;
      }
      
      public function get AESKey() : ByteArray
      {
         return this._AESKey;
      }
      
      public function initAESKey() : void
      {
         this._AESKey = this.generateRandomAESKey();
      }
      
      public function setSalt(param1:String) : void
      {
         this._salt = param1;
         if(this._salt.length < 32)
         {
            _log.warn("Authentification salt size is lower than 32 ");
            while(this._salt.length < 32)
            {
               this._salt = this._salt + " ";
            }
         }
      }
      
      public function setPublicKey(param1:Vector.<int>) : void
      {
         var commonMod:Object = null;
         commonMod = null;
         var publicKey:Vector.<int> = param1;
         var baSignedKey:ByteArray = new ByteArray();
         var i:int = 0;
         while(i < publicKey.length)
         {
            baSignedKey.writeByte(publicKey[i]);
            i++;
         }
         baSignedKey.position = 0;
         var key:ByteArray = new ByteArray();
         try
         {
            this._verifyKey.position = 0;
            key = RSA.publicDecrypt(this._verifyKey.readUTFBytes(this._verifyKey.length),baSignedKey);
         }
         catch(e:Error)
         {
            commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
            commonMod.openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.server.authentificationImpossible"),[I18n.getUiText("ui.common.ok")]);
            return;
         }
         this._publicKey = "-----BEGIN PUBLIC KEY-----\n" + Base64.encodeByteArray(key) + "-----END PUBLIC KEY-----";
      }
      
      public function setValidationAction(param1:LoginValidationAction) : void
      {
         this.username = param1["username"];
         this._lva = param1;
         this._certificate = SecureModeManager.getInstance().retreiveCertificate();
         ProtectPishingFrame.setPasswordHash(MD5.hash(param1.password.toUpperCase()),param1.password.length);
      }
      
      public function get loginValidationAction() : LoginValidationAction
      {
         return this._lva;
      }
      
      public function get canAutoConnectWithToken() : Boolean
      {
         return this.nextToken != null;
      }
      
      public function get isLoggingWithTicket() : Boolean
      {
         return this._lva is LoginValidationWithTicketAction;
      }
      
      public function getIdentificationMessage() : IdentificationMessage
      {
         var _loc1_:IdentificationMessage = null;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:IdentificationAccountForceMessage = null;
         var _loc5_:uint = BuildInfos.BUILD_VERSION.buildType;
         if(AirScanner.isStreamingVersion() && BuildInfos.BUILD_VERSION.buildType == BuildTypeEnum.BETA)
         {
            _loc5_ = BuildTypeEnum.RELEASE;
         }
         if(this._lva.username.indexOf("|") == -1)
         {
            _loc1_ = new IdentificationMessage();
            if(this._lva is LoginValidationWithTicketAction || this.nextToken)
            {
               _loc2_ = !!this.nextToken?this.nextToken:LoginValidationWithTicketAction(this._lva).ticket;
               this.nextToken = null;
               this.ankamaPortalKey = this.cipherMd5String(_loc2_);
               _loc1_.initIdentificationMessage(_loc1_.version,XmlConfig.getInstance().getEntry("config.lang.current"),this.cipherRsa("   ",_loc2_),this._lva.serverId,this._lva.autoSelectServer,this._certificate != null,true,this._certificate);
            }
            else
            {
               this.ankamaPortalKey = this.cipherMd5String(this._lva.password);
               _loc1_.initIdentificationMessage(_loc1_.version,XmlConfig.getInstance().getEntry("config.lang.current"),this.cipherRsa(this._lva.username,this._lva.password),this._lva.serverId,this._lva.autoSelectServer,this._certificate != null,false,this._certificate);
            }
            _loc1_.version.initVersionExtended(BuildInfos.BUILD_VERSION.major,BuildInfos.BUILD_VERSION.minor,BuildInfos.BUILD_VERSION.release,BuildInfos.BUILD_REVISION,BuildInfos.BUILD_PATCH,_loc5_,!!AirScanner.isStreamingVersion()?uint(uint(ClientInstallTypeEnum.CLIENT_STREAMING)):uint(uint(ClientInstallTypeEnum.CLIENT_BUNDLE)),!!AirScanner.hasAir()?uint(uint(ClientTechnologyEnum.CLIENT_AIR)):uint(uint(ClientTechnologyEnum.CLIENT_FLASH)));
            return _loc1_;
         }
         this.ankamaPortalKey = this.cipherMd5String(this._lva.password);
         _loc3_ = this._lva.username.split("|");
         _loc4_ = new IdentificationAccountForceMessage();
         _loc4_.initIdentificationAccountForceMessage(_loc4_.version,XmlConfig.getInstance().getEntry("config.lang.current"),this.cipherRsa(_loc3_[0],this._lva.password),this._lva.serverId,this._lva.autoSelectServer,this._certificate != null,false,this._certificate,0,null,_loc3_[1]);
         _loc4_.version.initVersionExtended(BuildInfos.BUILD_VERSION.major,BuildInfos.BUILD_VERSION.minor,BuildInfos.BUILD_VERSION.release,BuildInfos.BUILD_REVISION,BuildInfos.BUILD_PATCH,_loc5_,!!AirScanner.isStreamingVersion()?uint(uint(ClientInstallTypeEnum.CLIENT_STREAMING)):uint(uint(ClientInstallTypeEnum.CLIENT_BUNDLE)),!!AirScanner.hasAir()?uint(uint(ClientTechnologyEnum.CLIENT_AIR)):uint(uint(ClientTechnologyEnum.CLIENT_FLASH)));
         return _loc4_;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      private function cipherMd5String(param1:String) : String
      {
         return MD5.hash(param1 + this._salt);
      }
      
      private function cipherRsa(param1:String, param2:String) : Vector.<int>
      {
         var baOut:ByteArray = null;
         var debugOutput:ByteArray = null;
         var n:int = 0;
         var login:String = param1;
         var pwd:String = param2;
         var baIn:ByteArray = new ByteArray();
         baIn.writeUTFBytes(this._salt);
         baIn.writeBytes(this._AESKey);
         baIn.writeByte(login.length);
         baIn.writeUTFBytes(login);
         baIn.writeUTFBytes(pwd);
         try
         {
            if(File.applicationDirectory.resolvePath("debug-login.txt") || File.applicationDirectory.resolvePath("debuglogin.txt"))
            {
               _log.debug("login with certificate");
               debugOutput = new ByteArray();
               baIn.position = 0;
               debugOutput.position = 0;
               debugOutput = RSA.publicEncrypt(this.PUBLIC_KEY_V2.readUTFBytes(this.PUBLIC_KEY_V2.length),baIn);
               _log.debug("Login info (RSA Encrypted, " + debugOutput.length + " bytes) : " + Base64.encodeByteArray(debugOutput));
            }
         }
         catch(e:Error)
         {
            _log.error("Erreur lors du log des informations de login " + e.getStackTrace());
         }
         baOut = RSA.publicEncrypt(this._publicKey,baIn);
         var ret:Vector.<int> = new Vector.<int>();
         baOut.position = 0;
         var i:int = 0;
         while(baOut.bytesAvailable != 0)
         {
            n = baOut.readByte();
            ret[i] = n;
            i++;
         }
         return ret;
      }
      
      public function generateRandomAESKey() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         var _loc2_:int = 0;
         while(_loc2_ < AES_KEY_LENGTH)
         {
            _loc1_[_loc2_] = Math.floor(Math.random() * 256);
            _loc2_++;
         }
         return _loc1_;
      }
   }
}
