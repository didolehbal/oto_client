package com.ankamagames.dofus.logic.connection.actions
{
   public class LoginValidationWithTicketAction extends LoginValidationAction
   {
       
      
      public var ticket:String;
      
      public function LoginValidationWithTicketAction()
      {
         super();
      }
      
      public static function create(param1:String, param2:Boolean, param3:uint = 0) : LoginValidationWithTicketAction
      {
         var _loc4_:LoginValidationWithTicketAction;
         (_loc4_ = new LoginValidationWithTicketAction()).password = "";
         _loc4_.username = "";
         _loc4_.ticket = param1;
         _loc4_.autoSelectServer = param2;
         _loc4_.serverId = param3;
         return _loc4_;
      }
   }
}
