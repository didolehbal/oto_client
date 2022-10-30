package com.ankamagames.berilia.utils.web
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   
   [Event(name="complete",type="flash.events.Event")]
   public class HttpSocket extends EventDispatcher
   {
      
      private static const SEPERATOR:RegExp = new RegExp(/\r?\n\r?\n/);
      
      private static const NL:RegExp = new RegExp(/\r?\n/);
       
      
      private var requestSocket:Socket;
      
      private var requestBuffer:ByteArray;
      
      private var _rootPath:String;
      
      public function HttpSocket(param1:Socket, param2:String)
      {
         super();
         this.requestSocket = param1;
         this.requestBuffer = new ByteArray();
         this.requestSocket.addEventListener(ProgressEvent.SOCKET_DATA,this.onRequestSocketData);
         this.requestSocket.addEventListener(Event.CLOSE,this.onRequestSocketClose);
         this._rootPath = param2;
      }
      
      public function get rootPath() : String
      {
         return this._rootPath;
      }
      
      private function onRequestSocketData(param1:ProgressEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:HttpResponder = null;
         this.requestSocket.readBytes(this.requestBuffer,this.requestBuffer.length,this.requestSocket.bytesAvailable);
         var _loc10_:Number;
         var _loc9_:String;
         if((_loc10_ = (_loc9_ = this.requestBuffer.toString()).search(SEPERATOR)) != -1)
         {
            _loc2_ = _loc9_.substring(0,_loc10_);
            _loc3_ = _loc2_.substring(0,_loc2_.search(NL));
            _loc5_ = (_loc4_ = _loc3_.split(" "))[0];
            _loc6_ = (_loc6_ = _loc4_[1]).replace(/^http(s)?:\/\//,"");
            _loc7_ = _loc6_.substring(_loc6_.indexOf("/"),_loc6_.length);
            _loc8_ = new HttpResponder(this.requestSocket,_loc5_,_loc7_,this._rootPath);
         }
      }
      
      private function onRequestSocketClose(param1:Event) : void
      {
         this.done();
      }
      
      private function done() : void
      {
         this.tearDown();
         var _loc1_:Event = new Event(Event.COMPLETE);
         this.dispatchEvent(_loc1_);
      }
      
      private function testSocket(param1:Socket) : Boolean
      {
         if(!param1.connected)
         {
            this.done();
            return false;
         }
         return true;
      }
      
      public function tearDown() : void
      {
         if(this.requestSocket != null && this.requestSocket.connected)
         {
            this.requestSocket.flush();
            this.requestSocket.close();
         }
      }
   }
}
