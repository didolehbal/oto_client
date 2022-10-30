package com.ankamagames.dofus.logic.shield
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.utils.RpcServiceManager;
   import com.ankamagames.dofus.network.types.secure.TrustCertificate;
   import com.ankamagames.dofus.types.events.RpcEvent;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.ErrorManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.types.CustomSharedObject;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class SecureModeManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SecureModeManager));
      
      private static const VALIDATECODE_CODEEXPIRE:String = "CODEEXPIRE";
      
      private static const VALIDATECODE_CODEBADCODE:String = "CODEBADCODE";
      
      private static const VALIDATECODE_CODENOTFOUND:String = "CODENOTFOUND";
      
      private static const VALIDATECODE_SECURITY:String = "SECURITY";
      
      private static const VALIDATECODE_TOOMANYCERTIFICATE:String = "TOOMANYCERTIFICATE";
      
      private static const VALIDATECODE_NOTAVAILABLE:String = "NOTAVAILABLE";
      
      private static const ACCOUNT_AUTHENTIFICATION_FAILED:String = "ACCOUNT_AUTHENTIFICATION_FAILED";
      
      private static var RPC_URL:String;
      
      private static const RPC_METHOD_SECURITY_CODE:String = "SecurityCode";
      
      private static const RPC_METHOD_VALIDATE_CODE:String = "ValidateCode";
      
      private static const RPC_METHOD_MIGRATE:String = "Migrate";
      
      private static var _self:SecureModeManager;
       
      
      private var _timeout:Timer;
      
      private var _active:Boolean;
      
      private var _computerName:String;
      
      private var _methodsCallback:Dictionary;
      
      private var _hasV1Certif:Boolean;
      
      private var _rpcManager:RpcServiceManager;
      
      public var shieldLevel:uint;
      
      public function SecureModeManager()
      {
         this._timeout = new Timer(30000);
         this._methodsCallback = new Dictionary();
         this.shieldLevel = StoreDataManager.getInstance().getSetData(Constants.DATASTORE_COMPUTER_OPTIONS,"shieldLevel",ShieldSecureLevel.MEDIUM);
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : SecureModeManager
      {
         if(!_self)
         {
            _self = new SecureModeManager();
         }
         return _self;
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
         KernelEventsManager.getInstance().processCallback(HookList.SecureModeChange,param1);
      }
      
      public function get computerName() : String
      {
         return this._computerName;
      }
      
      public function set computerName(param1:String) : void
      {
         this._computerName = param1;
      }
      
      public function get certificate() : TrustCertificate
      {
         return this.retreiveCertificate();
      }
      
      public function askCode(param1:Function) : void
      {
         this._methodsCallback[RPC_METHOD_SECURITY_CODE] = param1;
         this._rpcManager.callMethod(RPC_METHOD_SECURITY_CODE,[this.getUsername(),AuthentificationManager.getInstance().ankamaPortalKey,1]);
      }
      
      public function sendCode(param1:String, param2:Function) : void
      {
         var _loc3_:ShieldCertifcate = new ShieldCertifcate();
         _loc3_.secureLevel = this.shieldLevel;
         this._methodsCallback[RPC_METHOD_VALIDATE_CODE] = param2;
         this._rpcManager.callMethod(RPC_METHOD_VALIDATE_CODE,[this.getUsername(),AuthentificationManager.getInstance().ankamaPortalKey,1,param1.toUpperCase(),_loc3_.hash,_loc3_.reverseHash,!!this._computerName?true:false,!!this._computerName?this._computerName:""]);
      }
      
      public function initRPC(param1:String) : void
      {
         RPC_URL = "http://" + param1 + "/shield.json";
         this._rpcManager = new RpcServiceManager(RPC_URL,"json");
         this._rpcManager.addEventListener(RpcEvent.EVENT_DATA,this.onRpcData);
         this._rpcManager.addEventListener(RpcEvent.EVENT_ERROR,this.onRpcData);
      }
      
      private function getUsername() : String
      {
         return AuthentificationManager.getInstance().username.split("|")[0];
      }
      
      private function parseRpcValidateResponse(param1:Object, param2:String) : Object
      {
         var _loc3_:Boolean = false;
         var _loc4_:Object;
         (_loc4_ = new Object()).error = param1.error;
         _loc4_.fatal = false;
         _loc4_.retry = false;
         _loc4_.text = "";
         switch(param1.error)
         {
            case VALIDATECODE_CODEEXPIRE:
               _loc4_.text = I18n.getUiText("ui.secureMode.error.checkCode.expire");
               _loc4_.fatal = true;
               break;
            case VALIDATECODE_CODEBADCODE:
               _loc4_.text = I18n.getUiText("ui.secureMode.error.checkCode.403");
               _loc4_.retry = true;
               break;
            case VALIDATECODE_CODENOTFOUND:
               _loc4_.text = I18n.getUiText("ui.secureMode.error.checkCode.404") + " (1)";
               _loc4_.fatal = true;
               break;
            case VALIDATECODE_SECURITY:
               _loc4_.text = I18n.getUiText("ui.secureMode.error.checkCode.security");
               _loc4_.fatal = true;
               break;
            case VALIDATECODE_TOOMANYCERTIFICATE:
               _loc4_.text = I18n.getUiText("ui.secureMode.error.checkCode.413");
               _loc4_.fatal = true;
               break;
            case VALIDATECODE_NOTAVAILABLE:
               _loc4_.text = I18n.getUiText("ui.secureMode.error.checkCode.202");
               _loc4_.fatal = true;
               break;
            case ACCOUNT_AUTHENTIFICATION_FAILED:
               _loc4_.text = I18n.getUiText("ui.secureMode.error.checkCode.404") + " (2)";
               _loc4_.fatal = true;
               break;
            default:
               _loc4_.text = !!param1.error?param1.error:I18n.getUiText("ui.secureMode.error.default");
               _loc4_.fatal = true;
         }
         if(param1.certificate && param1.id)
         {
            if(!(_loc3_ = this.addCertificate(param1.id,param1.certificate,this.shieldLevel)))
            {
               _loc4_.text = I18n.getUiText("ui.secureMode.error.checkCode.202.fatal");
               _loc4_.fatal = true;
            }
         }
         return _loc4_;
      }
      
      private function parseRpcASkCodeResponse(param1:Object, param2:String) : Object
      {
         var _loc3_:Object = new Object();
         _loc3_.error = !_loc3_.error;
         _loc3_.fatal = false;
         _loc3_.retry = false;
         _loc3_.text = "";
         if(!param1.error)
         {
            _loc3_.domain = param1.domain;
            _loc3_.error = false;
         }
         else
         {
            switch(param1.error)
            {
               case ACCOUNT_AUTHENTIFICATION_FAILED:
                  _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.404") + " (3)";
                  _loc3_.fatal = true;
                  break;
               case VALIDATECODE_CODEEXPIRE:
                  _loc3_.text = I18n.getUiText("ui.secureMode.error.checkCode.expire");
                  _loc3_.fatal = true;
                  break;
               default:
                  _loc3_.text = I18n.getUiText("ui.secureMode.error.default");
                  _loc3_.fatal = true;
            }
         }
         return _loc3_;
      }
      
      private function getCertifFolder(param1:uint, param2:Boolean = false) : File
      {
         var _loc3_:File = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         if(!param2)
         {
            (_loc4_ = File.applicationStorageDirectory.nativePath.split(File.separator)).pop();
            _loc4_.pop();
            _loc5_ = _loc4_.join(File.separator);
         }
         else
         {
            _loc5_ = CustomSharedObject.getCustomSharedObjectDirectory();
         }
         if(param1 == 1)
         {
            _loc3_ = new File(_loc5_ + File.separator + "AnkamaCertificates/");
         }
         if(param1 == 2)
         {
            _loc3_ = new File(_loc5_ + File.separator + "AnkamaCertificates/v2-RELEASE");
         }
         _loc3_.createDirectory();
         return _loc3_;
      }
      
      private function addCertificate(param1:uint, param2:String, param3:uint = 2) : Boolean
      {
         var cert:ShieldCertifcate = null;
         var f:File = null;
         var fs:FileStream = null;
         cert = null;
         f = null;
         fs = null;
         var id:uint = param1;
         var content:String = param2;
         var secureLevel:uint = param3;
         cert = new ShieldCertifcate();
         cert.id = id;
         cert.version = 3;
         cert.content = content;
         cert.secureLevel = secureLevel;
         try
         {
            f = this.getCertifFolder(2);
            f = f.resolvePath(MD5.hash(this.getUsername()));
            fs = new FileStream();
            fs.open(f,FileMode.WRITE);
            fs.writeBytes(cert.serialize());
            fs.close();
            return true;
         }
         catch(e:Error)
         {
            try
            {
               f = getCertifFolder(2,true);
               f = f.resolvePath(MD5.hash(getUsername()));
               fs = new FileStream();
               fs.open(f,FileMode.WRITE);
               fs.writeBytes(cert.serialize());
               fs.close();
               return true;
            }
            catch(e:Error)
            {
               ErrorManager.addError("Error writing certificate file at " + f.nativePath,e);
               return false;
            }
         }
      }
      
      public function checkMigrate() : void
      {
         if(!this._hasV1Certif)
         {
            return;
         }
         var _loc1_:TrustCertificate = this.retreiveCertificate();
         this.migrate(_loc1_.id,_loc1_.hash);
      }
      
      private function getCertificateFile() : File
      {
         var userName:String = null;
         var f:File = null;
         try
         {
            userName = this.getUsername();
            f = this.getCertifFolder(2).resolvePath(MD5.hash(userName));
            if(!f.exists)
            {
               f = this.getCertifFolder(1).resolvePath(MD5.hash(userName));
            }
            if(!f.exists)
            {
               f = this.getCertifFolder(2,true).resolvePath(MD5.hash(userName));
            }
            if(f.exists)
            {
               return f;
            }
         }
         catch(e:Error)
         {
            _log.error("Erreur lors de la recherche du certifcat : " + e.message);
         }
         return null;
      }
      
      public function retreiveCertificate() : TrustCertificate
      {
         var f:File = null;
         var fs:FileStream = null;
         var certif:ShieldCertifcate = null;
         try
         {
            this._hasV1Certif = false;
            f = this.getCertificateFile();
            if(f)
            {
               fs = new FileStream();
               fs.open(f,FileMode.READ);
               certif = ShieldCertifcate.fromRaw(fs);
               fs.close();
               if(certif.id == 0)
               {
                  _log.error("Certificat invalide (id=0)");
                  return null;
               }
               return certif.toNetwork();
            }
         }
         catch(e:Error)
         {
            ErrorManager.addError("Impossible de lire le fichier de certificat.",e);
         }
         return null;
      }
      
      private function onRpcData(param1:RpcEvent) : void
      {
         if(param1.type == RpcEvent.EVENT_ERROR && !param1.result)
         {
            this._methodsCallback[param1.method]({
               "error":true,
               "fatal":true,
               "text":I18n.getUiText("ui.secureMode.error.checkCode.503")
            });
            return;
         }
         if(param1.method == RPC_METHOD_SECURITY_CODE)
         {
            this._methodsCallback[param1.method](this.parseRpcASkCodeResponse(param1.result,param1.method));
         }
         if(param1.method == RPC_METHOD_VALIDATE_CODE)
         {
            this._methodsCallback[param1.method](this.parseRpcValidateResponse(param1.result,param1.method));
         }
         if(param1.method == RPC_METHOD_MIGRATE)
         {
            if(param1.result.success)
            {
               this.migrationSuccess(param1.result);
            }
            else
            {
               _log.error("Impossible de migrer le certificat : " + param1.result.error);
            }
         }
      }
      
      private function migrate(param1:uint, param2:String) : void
      {
         var _loc3_:ShieldCertifcate = new ShieldCertifcate();
         _loc3_.secureLevel = this.shieldLevel;
         this._rpcManager.callMethod(RPC_METHOD_MIGRATE,[this.getUsername(),AuthentificationManager.getInstance().ankamaPortalKey,1,2,param1,param2,_loc3_.hash,_loc3_.reverseHash]);
      }
      
      private function migrationSuccess(param1:Object) : void
      {
         var _loc2_:File = this.getCertificateFile();
         if(_loc2_.exists)
         {
         }
         this.addCertificate(param1.id,param1.certificate);
      }
   }
}
