package com.ankamagames.jerakine.messages
{
   public class LangAllFilesLoadedMessage implements Message
   {
       
      
      private var _sFile:String;
      
      private var _bSuccess:Boolean;
      
      public function LangAllFilesLoadedMessage(param1:String, param2:Boolean)
      {
         super();
         this._sFile = param1;
         this._bSuccess = param2;
      }
      
      public function get file() : String
      {
         return this._sFile;
      }
      
      public function get success() : Boolean
      {
         return this._bSuccess;
      }
   }
}
