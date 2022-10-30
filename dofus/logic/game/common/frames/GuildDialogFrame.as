package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.actions.ChangeWorldInteractionAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildCreationValidAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildInvitationAnswerAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildModificationEmblemValidAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildModificationNameValidAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildModificationValidAction;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.DialogTypeEnum;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildCreationValidMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildModificationEmblemValidMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildModificationNameValidMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildModificationValidMessage;
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class GuildDialogFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(GuildDialogFrame));
       
      
      private var guildEmblem:GuildEmblem;
      
      public function GuildDialogFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:GuildCreationValidAction = null;
         var _loc3_:GuildCreationValidMessage = null;
         var _loc4_:GuildModificationValidAction = null;
         var _loc5_:GuildModificationValidMessage = null;
         var _loc6_:GuildModificationNameValidAction = null;
         var _loc7_:GuildModificationNameValidMessage = null;
         var _loc8_:GuildModificationEmblemValidAction = null;
         var _loc9_:GuildModificationEmblemValidMessage = null;
         var _loc10_:GuildInvitationAnswerAction = null;
         var _loc11_:GuildInvitationAnswerMessage = null;
         var _loc12_:LeaveDialogMessage = null;
         switch(true)
         {
            case param1 is GuildCreationValidAction:
               _loc2_ = param1 as GuildCreationValidAction;
               this.guildEmblem = new GuildEmblem();
               this.guildEmblem.symbolShape = _loc2_.upEmblemId;
               this.guildEmblem.symbolColor = _loc2_.upColorEmblem;
               this.guildEmblem.backgroundShape = _loc2_.backEmblemId;
               this.guildEmblem.backgroundColor = _loc2_.backColorEmblem;
               _loc3_ = new GuildCreationValidMessage();
               _loc3_.initGuildCreationValidMessage(_loc2_.guildName,this.guildEmblem);
               ConnectionsHandler.getConnection().send(_loc3_);
               return true;
            case param1 is GuildModificationValidAction:
               _loc4_ = param1 as GuildModificationValidAction;
               this.guildEmblem = new GuildEmblem();
               this.guildEmblem.symbolShape = _loc4_.upEmblemId;
               this.guildEmblem.symbolColor = _loc4_.upColorEmblem;
               this.guildEmblem.backgroundShape = _loc4_.backEmblemId;
               this.guildEmblem.backgroundColor = _loc4_.backColorEmblem;
               (_loc5_ = new GuildModificationValidMessage()).initGuildModificationValidMessage(_loc4_.guildName,this.guildEmblem);
               ConnectionsHandler.getConnection().send(_loc5_);
               return true;
            case param1 is GuildModificationNameValidAction:
               _loc6_ = param1 as GuildModificationNameValidAction;
               (_loc7_ = new GuildModificationNameValidMessage()).initGuildModificationNameValidMessage(_loc6_.guildName);
               ConnectionsHandler.getConnection().send(_loc7_);
               return true;
            case param1 is GuildModificationEmblemValidAction:
               _loc8_ = param1 as GuildModificationEmblemValidAction;
               this.guildEmblem = new GuildEmblem();
               this.guildEmblem.symbolShape = _loc8_.upEmblemId;
               this.guildEmblem.symbolColor = _loc8_.upColorEmblem;
               this.guildEmblem.backgroundShape = _loc8_.backEmblemId;
               this.guildEmblem.backgroundColor = _loc8_.backColorEmblem;
               (_loc9_ = new GuildModificationEmblemValidMessage()).initGuildModificationEmblemValidMessage(this.guildEmblem);
               ConnectionsHandler.getConnection().send(_loc9_);
               return true;
            case param1 is GuildInvitationAnswerAction:
               _loc10_ = param1 as GuildInvitationAnswerAction;
               (_loc11_ = new GuildInvitationAnswerMessage()).initGuildInvitationAnswerMessage(_loc10_.accept);
               ConnectionsHandler.getConnection().send(_loc11_);
               this.leaveDialog();
               return true;
            case param1 is LeaveDialogMessage:
               if((_loc12_ = param1 as LeaveDialogMessage).dialogType == DialogTypeEnum.DIALOG_GUILD_CREATE || _loc12_.dialogType == DialogTypeEnum.DIALOG_GUILD_INVITATION || _loc12_.dialogType == DialogTypeEnum.DIALOG_GUILD_RENAME)
               {
                  this.leaveDialog();
               }
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         KernelEventsManager.getInstance().processCallback(HookList.LeaveDialog);
         return true;
      }
      
      private function leaveDialog() : void
      {
         Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
         Kernel.getWorker().removeFrame(this);
      }
   }
}
