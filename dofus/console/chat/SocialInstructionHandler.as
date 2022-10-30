package com.ankamagames.dofus.console.chat
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.party.PartyInvitationAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.messages.game.friend.FriendAddRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredAddRequestMessage;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.data.I18n;
   
   public class SocialInstructionHandler implements ConsoleInstructionHandler
   {
       
      
      public function SocialInstructionHandler()
      {
         super();
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:PartyInvitationAction = null;
         var _loc8_:String = null;
         var _loc9_:FriendAddRequestMessage = null;
         var _loc10_:IgnoredAddRequestMessage = null;
         switch(param2)
         {
            case "f":
               if(param3.length != 2)
               {
                  return;
               }
               _loc4_ = param3[0] as String;
               if((_loc5_ = param3[1] as String).length < 2 || _loc5_.length > 20)
               {
                  _loc8_ = I18n.getUiText("ui.social.friend.addFailureNotFound");
                  param1.output(_loc8_);
                  return;
               }
               if(_loc5_ != PlayedCharacterManager.getInstance().infos.name)
               {
                  if(_loc4_ == "a" || _loc4_ == "+")
                  {
                     (_loc9_ = new FriendAddRequestMessage()).initFriendAddRequestMessage(_loc5_);
                     ConnectionsHandler.getConnection().send(_loc9_);
                  }
               }
               else
               {
                  param1.output(I18n.getUiText("ui.social.friend.addFailureEgocentric"));
               }
               return;
               break;
            case "ignore":
               if(param3.length != 2)
               {
                  return;
               }
               _loc4_ = param3[0] as String;
               if((_loc5_ = param3[1] as String).length < 2 || _loc5_.length > 20)
               {
                  _loc8_ = I18n.getUiText("ui.social.friend.addFailureNotFound");
                  param1.output(_loc8_);
                  return;
               }
               if(_loc5_ == PlayedCharacterManager.getInstance().infos.name)
               {
                  param1.output(I18n.getUiText("ui.social.friend.addFailureEgocentric"));
                  return;
               }
               if(_loc4_ == "a" || _loc4_ == "+")
               {
                  (_loc10_ = new IgnoredAddRequestMessage()).initIgnoredAddRequestMessage(_loc5_);
                  ConnectionsHandler.getConnection().send(_loc10_);
               }
               return;
               break;
            case "invite":
               if(param3.length != 1)
               {
                  return;
               }
               if((_loc6_ = param3[0] as String) == "" || _loc6_.length < 2 || _loc6_.length > 19)
               {
                  return;
               }
               _loc7_ = PartyInvitationAction.create(_loc6_);
               Kernel.getWorker().process(_loc7_);
               return;
               break;
            default:
               return;
         }
      }
      
      public function getHelp(param1:String) : String
      {
         switch(param1)
         {
            case "f":
               return I18n.getUiText("ui.chat.console.help.friendhelp");
            case "ignore":
               return I18n.getUiText("ui.chat.console.help.enemyhelp");
            case "invite":
               return I18n.getUiText("ui.chat.console.help.invite");
            default:
               return I18n.getUiText("ui.chat.console.noHelp",[param1]);
         }
      }
      
      public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
      {
         return [];
      }
   }
}
