package com.ankamagames.berilia.types.messages
{
   import com.ankamagames.jerakine.messages.Message;
   
   public class ModuleExecErrorMessage implements Message
   {
       
      
      private var _moduleName:String;
      
      private var _stackTrace:String;
      
      public function ModuleExecErrorMessage(param1:String, param2:String)
      {
         super();
         this._moduleName = param1;
         this._stackTrace = param2;
      }
      
      public function get moduleName() : String
      {
         return this._moduleName;
      }
      
      public function get stackTrace() : String
      {
         return this._stackTrace;
      }
   }
}
