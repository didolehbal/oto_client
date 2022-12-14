package com.ankamagames.dofus.logic.game.fight.messages
{
   import com.ankamagames.jerakine.messages.Message;
   
   public class TextActionInformationMessage implements Message
   {
       
      
      private var _textKey:uint;
      
      private var _params:Array;
      
      public function TextActionInformationMessage(param1:uint, param2:Array = null)
      {
         super();
         this._textKey = param1;
         this._params = param2;
      }
      
      public function get textKey() : uint
      {
         return this._textKey;
      }
      
      public function get params() : Array
      {
         return this._params;
      }
   }
}
