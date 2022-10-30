package com.ankamagames.dofus.misc.interClient
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.events.AsyncErrorEvent;
   import flash.events.StatusEvent;
   import flash.net.LocalConnection;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class InterClientMaster
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(InterClientSlave));
      
      private static var _receiving_lc:LocalConnection;
       
      
      private var _sending_lc:LocalConnection;
      
      private var _lastPingTs:uint;
      
      private var _lastClientPing:Array;
      
      public function InterClientMaster()
      {
         this._lastClientPing = new Array();
         super();
         this._sending_lc = new LocalConnection();
         this._sending_lc.allowDomain("*");
         this._sending_lc.allowInsecureDomain("*");
         this._sending_lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onError);
         this._sending_lc.addEventListener(StatusEvent.STATUS,this.onStatusEvent);
         _receiving_lc.client = new Object();
         _receiving_lc.allowDomain("*");
         _receiving_lc.allowInsecureDomain("*");
         _receiving_lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onError);
         _receiving_lc.addEventListener(StatusEvent.STATUS,this.onStatusEvent);
         _receiving_lc.client.ping = this.ping;
         _receiving_lc.client.clientGainFocus = this.clientGainFocus;
         _receiving_lc.client.updateFocusMessage = this.updateFocusMessage;
         this._lastPingTs = getTimer();
      }
      
      public static function etreLeCalif() : InterClientMaster
      {
         try
         {
            if(!_receiving_lc)
            {
               _receiving_lc = new LocalConnection();
            }
            _receiving_lc.connect("_dofus");
            return new InterClientMaster();
         }
         catch(e:ArgumentError)
         {
            return null;
         }
      }
      
      public function get isAlone() : Boolean
      {
         return getTimer() - this._lastPingTs > 20000;
      }
      
      public function destroy() : void
      {
         this._sending_lc = null;
         _receiving_lc.close();
      }
      
      public function clientGainFocus(param1:String) : void
      {
         var clientListInfo:Array = null;
         var num:int = 0;
         var i:int = 0;
         var id:String = null;
         var baseInfo:String = param1;
         var info:Array = baseInfo.split(",");
         var connId:String = info[0];
         var time:Number = info[1];
         clientListInfo = InterClientManager.getInstance().clientListInfo;
         var index:int = clientListInfo.indexOf(connId);
         if(index == -1)
         {
            clientListInfo.push(connId,time);
         }
         else
         {
            clientListInfo[index + 1] = time;
         }
         var baseClientListInfo:String = clientListInfo.join(",");
         num = clientListInfo.length;
         i = 0;
         while(i < num)
         {
            id = clientListInfo[i];
            try
            {
               this._sending_lc.send(id,"updateFocusMessage",baseClientListInfo);
            }
            catch(e:Error)
            {
               _log.debug(e.getStackTrace());
               clientListInfo.splice(i,2);
               i = i - 2;
               num = num - 2;
            }
            i = i + 2;
         }
      }
      
      private function onError(param1:AsyncErrorEvent) : void
      {
         _log.debug(param1.error.getStackTrace());
      }
      
      private function onStatusEvent(param1:StatusEvent) : void
      {
      }
      
      public function updateFocusMessage(param1:String) : void
      {
         InterClientManager.getInstance().clientListInfo = param1.split(",");
         InterClientManager.getInstance().updateFocusList();
      }
      
      private function ping(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc5_:int = 0;
         this._lastPingTs = getTimer();
         this._sending_lc.send(param1,"pong");
         this._lastClientPing[param1] = this._lastPingTs;
         var _loc3_:Array = InterClientManager.getInstance().clientListInfo;
         var _loc4_:int = _loc3_.length;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = _loc3_[_loc5_];
            if(_loc2_ != "_dofus")
            {
               if(this._lastClientPing[_loc2_])
               {
                  if(this._lastPingTs - this._lastClientPing[_loc2_] > 20000)
                  {
                     _loc3_.splice(_loc5_,2);
                     _loc5_ = _loc5_ - 2;
                     _loc4_ = _loc4_ - 2;
                  }
               }
               else
               {
                  this._lastClientPing[_loc2_] = this._lastPingTs;
               }
            }
            _loc5_ = _loc5_ + 2;
         }
      }
   }
}
