package com.ankamagames.jerakine.replay
{
   public class LogClassField
   {
       
      
      public var fieldNameId:uint;
      
      public var type:int;
      
      public var transient:Boolean;
      
      public function LogClassField(param1:uint, param2:int, param3:Boolean)
      {
         super();
         this.fieldNameId = param1;
         this.type = param2;
         this.transient = param3;
      }
   }
}
