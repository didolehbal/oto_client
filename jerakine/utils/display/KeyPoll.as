package com.ankamagames.jerakine.utils.display
{
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.utils.ByteArray;
   
   public class KeyPoll
   {
      
      private static var _self:KeyPoll;
       
      
      private var states:ByteArray;
      
      public function KeyPoll()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this.states = new ByteArray();
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         StageShareManager.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownListener,false,0,true);
         StageShareManager.stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpListener,false,0,true);
         StageShareManager.stage.addEventListener(Event.ACTIVATE,this.activateListener,false,0,true);
         StageShareManager.stage.addEventListener(Event.DEACTIVATE,this.deactivateListener,false,0,true);
      }
      
      public static function getInstance() : KeyPoll
      {
         if(!_self)
         {
            _self = new KeyPoll();
         }
         return _self;
      }
      
      private function keyDownListener(param1:KeyboardEvent) : void
      {
         this.states[param1.keyCode >>> 3] = this.states[param1.keyCode >>> 3] | 1 << (param1.keyCode & 7);
      }
      
      private function keyUpListener(param1:KeyboardEvent) : void
      {
         this.states[param1.keyCode >>> 3] = this.states[param1.keyCode >>> 3] & ~(1 << (param1.keyCode & 7));
      }
      
      private function activateListener(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 32)
         {
            this.states[_loc2_] = 0;
            _loc2_++;
         }
      }
      
      private function deactivateListener(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 32)
         {
            this.states[_loc2_] = 0;
            _loc2_++;
         }
      }
      
      public function isDown(param1:uint) : Boolean
      {
         return (this.states[param1 >>> 3] & 1 << (param1 & 7)) != 0;
      }
      
      public function isUp(param1:uint) : Boolean
      {
         return (this.states[param1 >>> 3] & 1 << (param1 & 7)) == 0;
      }
   }
}
