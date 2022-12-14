package com.ankamagames.jerakine.network.messages
{
   import com.ankamagames.jerakine.messages.Message;
   
   public class WrongSocketClosureReasonMessage implements Message
   {
       
      
      private var _expectedReason:uint;
      
      private var _gotReason:uint;
      
      public function WrongSocketClosureReasonMessage(param1:uint, param2:uint)
      {
         super();
         this._expectedReason = param1;
         this._gotReason = param2;
      }
      
      public function get expectedReason() : uint
      {
         return this._expectedReason;
      }
      
      public function get gotReason() : uint
      {
         return this._gotReason;
      }
   }
}
