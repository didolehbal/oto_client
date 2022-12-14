package com.ankamagames.dofus.internalDatacenter.communication
{
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class ChatInformationSentence extends BasicChatSentence implements IDataCenter
   {
       
      
      private var _textKey:uint;
      
      private var _params:Array;
      
      public function ChatInformationSentence(param1:uint, param2:String, param3:String, param4:uint = 0, param5:Number = 0, param6:String = "", param7:uint = 0, param8:Array = null)
      {
         super(param1,param2,param3,param4,param5,param6);
         this._textKey = param7;
         this._params = param8;
      }
      
      public function get textKey() : uint
      {
         return this._textKey;
      }
      
      public function get params() : Array
      {
         return this._params;
      }
      
      override public function get msg() : String
      {
         return I18n.getText(this._textKey,this._params);
      }
   }
}
