package com.ankamagames.dofus.kernel.sound.manager
{
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.pools.PoolableSoundCommand;
   import com.ankamagames.dofus.pools.PoolsManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.protocolAudio.ProtocolEnum;
   import com.ankamagames.jerakine.sound.FlashSoundSender;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.utils.getQualifiedClassName;
   
   public class RegConnectionManager
   {
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(RegConnectionManager));
      
      private static var _self:RegConnectionManager;
       
      
      private var _sock:Socket;
      
      private var _socketClientID:uint;
      
      private var _socketAvaible:Boolean;
      
      private var _buffer:Vector.<PoolableSoundCommand>;
      
      private var _isMain:Boolean = true;
      
      public function RegConnectionManager(param1:SingletonEnforcer)
      {
         super();
         if(_self)
         {
            throw new Error("RegConnectionManager is a Singleton");
         }
         this.init();
      }
      
      public static function getInstance() : RegConnectionManager
      {
         if(_self == null)
         {
            _self = new RegConnectionManager(new SingletonEnforcer());
         }
         return _self;
      }
      
      public function get socketClientID() : uint
      {
         return this._socketClientID;
      }
      
      public function get socketAvailable() : Boolean
      {
         return this._socketAvaible;
      }
      
      public function get isMain() : Boolean
      {
         return this._isMain;
      }
      
      public function send(param1:String, ... rest) : void
      {
         var _loc3_:PoolableSoundCommand = null;
         if(!this._socketAvaible)
         {
            this.updateBuffer();
            _loc3_ = PoolsManager.getInstance().getSoundCommandPool().checkOut() as PoolableSoundCommand;
            _loc3_.init(param1,rest);
            this._buffer.push(_loc3_);
            return;
         }
         if(param1 == ProtocolEnum.SAY_GOODBYE)
         {
            this._sock.writeUTFBytes(String(0));
            this._sock.writeUTFBytes("=>" + param1 + "();" + this._socketClientID + "=>" + ProtocolEnum.PLAY_SOUND + "(10,100)");
            this._sock.writeUTFBytes("|");
            this._sock.flush();
         }
         else
         {
            this._sock.writeUTFBytes(String(this._socketClientID));
            this._sock.writeUTFBytes("=>" + param1 + "(" + rest + ")");
            this._sock.writeUTFBytes("|");
            this._sock.flush();
         }
      }
      
      private function init() : void
      {
         this._socketClientID = uint.MAX_VALUE * Math.random();
         if(AirScanner.isStreamingVersion())
         {
            _log.debug("init flash sound sender");
            this._sock = new FlashSoundSender(Dofus.getInstance().REG_LOCAL_CONNECTION_ID);
         }
         else
         {
            _log.debug("init socket");
            this._sock = new Socket();
         }
         this._sock.addEventListener(ProgressEvent.SOCKET_DATA,this.onData);
         this._sock.addEventListener(Event.CONNECT,this.onSocketConnect);
         this._sock.addEventListener(Event.CLOSE,this.onSocketClose);
         this._sock.addEventListener(IOErrorEvent.IO_ERROR,this.onSocketError);
         this._sock.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSocketSecurityError);
         if(CommandLineArguments.getInstance().hasArgument("reg-client-port"))
         {
            this._sock.connect("localhost",int(CommandLineArguments.getInstance().getArgument("reg-client-port")));
         }
         else
         {
            this._sock.connect("localhost",8081);
         }
         this._buffer = new Vector.<PoolableSoundCommand>();
      }
      
      private function showInformationPopup() : void
      {
         var _loc1_:Object = null;
         if(UiModuleManager.getInstance().getModule("Ankama_Common"))
         {
            _loc1_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
            if(_loc1_)
            {
               _loc1_.openPopup(I18n.getUiText("ui.popup.warning"),I18n.getUiText("ui.common.soundsDeactivated"),[I18n.getUiText("ui.common.ok")]);
            }
         }
      }
      
      private function setAsMain(param1:Boolean) : void
      {
         if(param1 == this._isMain)
         {
            return;
         }
         this._isMain = param1;
         if(param1 == true)
         {
            _log.warn("[" + this._socketClientID + "] Je passe en main");
            if(SoundManager.getInstance().manager is RegSoundManager)
            {
               (SoundManager.getInstance().manager as RegSoundManager).playMainClientSounds();
            }
         }
         else
         {
            _log.warn("[" + this._socketClientID + "] Je ne suis plus main");
            if(SoundManager.getInstance().manager is RegSoundManager)
            {
               (SoundManager.getInstance().manager as RegSoundManager).stopMainClientSounds();
            }
         }
      }
      
      private function updateBuffer() : void
      {
         while(this._buffer.length)
         {
            if(this._buffer[0].hasExpired)
            {
               PoolsManager.getInstance().getSoundCommandPool().checkIn(this._buffer.shift());
               continue;
            }
            return;
         }
      }
      
      private function onSocketClose(param1:Event) : void
      {
         this._socketAvaible = false;
         _log.error("The socket has been closed");
         try
         {
            this.showInformationPopup();
         }
         catch(e:Error)
         {
         }
      }
      
      private function onData(param1:ProgressEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Array = this._sock.readUTFBytes(param1.bytesLoaded).split("|");
         for each(_loc2_ in _loc6_)
         {
            if(_loc2_ == "")
            {
               return;
            }
            _loc3_ = _loc2_.split("(")[0];
            switch(_loc3_)
            {
               case ProtocolEnum.REG_SHUT_DOWN:
                  this._socketAvaible = false;
                  _log.error("The socket connection with REG has been lost");
                  this.showInformationPopup();
                  continue;
               case ProtocolEnum.REG_IS_UP:
                  this._socketAvaible = true;
                  _log.info("The socket connection with REG has been established");
                  continue;
               case ProtocolEnum.PING:
                  this.send(ProtocolEnum.PONG);
                  continue;
               case ProtocolEnum.MAIN_CLIENT_IS:
                  if((_loc4_ = Number(_loc2_.split(":")[1])) == this._socketClientID)
                  {
                     this.setAsMain(true);
                  }
                  else
                  {
                     this.setAsMain(false);
                  }
                  continue;
               case ProtocolEnum.ENDOFSONG:
                  _loc5_ = Number(_loc2_.split(":")[1]);
                  if(this._isMain)
                  {
                     SoundManager.getInstance().manager.endOfSound(_loc5_);
                     break;
                  }
            }
         }
      }
      
      private function onSocketError(param1:IOErrorEvent) : void
      {
         this._socketAvaible = false;
         _log.error("Connection to Reg failed. " + param1.text);
      }
      
      private function onSocketSecurityError(param1:SecurityErrorEvent) : void
      {
         this._socketAvaible = false;
         _log.error("Connection to Reg failed. " + param1.text);
      }
      
      private function onSocketConnect(param1:Event) : void
      {
         var _loc2_:PoolableSoundCommand = null;
         this._socketAvaible = true;
         if(this._buffer && this._buffer.length)
         {
            while(this._buffer.length)
            {
               _loc2_ = this._buffer.shift();
               CallWithParameters.call(this.send,([_loc2_.method] as Array).concat(_loc2_.params));
               PoolsManager.getInstance().getSoundCommandPool().checkIn(_loc2_);
            }
         }
      }
   }
}

class SingletonEnforcer
{
    
   
   function SingletonEnforcer()
   {
      super();
   }
}
