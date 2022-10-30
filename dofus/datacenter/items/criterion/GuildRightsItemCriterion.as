package com.ankamagames.dofus.datacenter.items.criterion
{
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.network.enums.GuildRightsBitEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class GuildRightsItemCriterion extends ItemCriterion implements IDataCenter
   {
       
      
      public function GuildRightsItemCriterion(param1:String)
      {
         super(param1);
      }
      
      override public function get isRespected() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:SocialFrame = Kernel.getWorker().getFrame(SocialFrame) as SocialFrame;
         if(!_loc2_.hasGuild)
         {
            if(_operator.text == ItemCriterionOperator.DIFFERENT)
            {
               return true;
            }
            return false;
         }
         var _loc3_:GuildWrapper = _loc2_.guild;
         switch(criterionValue)
         {
            case GuildRightsBitEnum.GUILD_RIGHT_BOSS:
               _loc1_ = _loc3_.isBoss;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_BAN_MEMBERS:
               _loc1_ = _loc3_.banMembers;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_COLLECT:
               _loc1_ = _loc3_.collect;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_COLLECT_MY_TAX_COLLECTOR:
               _loc1_ = _loc3_.collectMyTaxCollectors;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_DEFENSE_PRIORITY:
               _loc1_ = _loc3_.prioritizeMeInDefense;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_HIRE_TAX_COLLECTOR:
               _loc1_ = _loc3_.hireTaxCollector;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_INVITE_NEW_MEMBERS:
               _loc1_ = _loc3_.inviteNewMembers;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_MANAGE_GUILD_BOOSTS:
               _loc1_ = _loc3_.manageGuildBoosts;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_MANAGE_MY_XP_CONTRIBUTION:
               _loc1_ = _loc3_.manageMyXpContribution;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_MANAGE_RANKS:
               _loc1_ = _loc3_.manageRanks;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_MANAGE_RIGHTS:
               _loc1_ = _loc3_.manageRights;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_MANAGE_XP_CONTRIBUTION:
               _loc1_ = _loc3_.manageXPContribution;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_ORGANIZE_PADDOCKS:
               _loc1_ = _loc3_.organizeFarms;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_SET_ALLIANCE_PRISM:
               _loc1_ = _loc3_.setAlliancePrism;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_TALK_IN_ALLIANCE_CHAN:
               _loc1_ = _loc3_.talkInAllianceChannel;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_TAKE_OTHERS_MOUNTS_IN_PADDOCKS:
               _loc1_ = _loc3_.takeOthersRidesInFarm;
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_USE_PADDOCKS:
               _loc1_ = _loc3_.useFarms;
         }
         switch(_operator.text)
         {
            case ItemCriterionOperator.EQUAL:
               return _loc1_;
            case ItemCriterionOperator.DIFFERENT:
               return !_loc1_;
            default:
               return false;
         }
      }
      
      override public function get text() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         switch(criterionValue)
         {
            case GuildRightsBitEnum.GUILD_RIGHT_BOSS:
               _loc2_ = I18n.getUiText("ui.guild.right.leader");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_BAN_MEMBERS:
               _loc2_ = I18n.getUiText("ui.social.guildRightsBann");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_COLLECT:
               _loc2_ = I18n.getUiText("ui.social.guildRightsCollect");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_COLLECT_MY_TAX_COLLECTOR:
               _loc2_ = I18n.getUiText("ui.social.guildRightsCollectMy");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_DEFENSE_PRIORITY:
               _loc2_ = I18n.getUiText("ui.social.guildRightsPrioritizeMe");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_HIRE_TAX_COLLECTOR:
               _loc2_ = I18n.getUiText("ui.social.guildRightsHiretax");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_INVITE_NEW_MEMBERS:
               _loc2_ = I18n.getUiText("ui.social.guildRightsInvit");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_MANAGE_GUILD_BOOSTS:
               _loc2_ = I18n.getUiText("ui.social.guildRightsBoost");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_MANAGE_MY_XP_CONTRIBUTION:
               _loc2_ = I18n.getUiText("ui.social.guildRightManageOwnXP");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_MANAGE_RANKS:
               _loc2_ = I18n.getUiText("ui.social.guildRightsRank");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_MANAGE_RIGHTS:
               _loc2_ = I18n.getUiText("ui.social.guildManageRights");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_MANAGE_XP_CONTRIBUTION:
               _loc2_ = I18n.getUiText("ui.social.guildRightsPercentXp");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_ORGANIZE_PADDOCKS:
               _loc2_ = I18n.getUiText("ui.social.guildRightsMountParkArrange");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_SET_ALLIANCE_PRISM:
               _loc2_ = I18n.getUiText("ui.social.guildRightsSetAlliancePrism");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_TALK_IN_ALLIANCE_CHAN:
               _loc2_ = I18n.getUiText("ui.social.guildRightsTalkInAllianceChannel");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_TAKE_OTHERS_MOUNTS_IN_PADDOCKS:
               _loc2_ = I18n.getUiText("ui.social.guildRightsManageOtherMount");
               break;
            case GuildRightsBitEnum.GUILD_RIGHT_USE_PADDOCKS:
               _loc2_ = I18n.getUiText("ui.social.guildRightsMountParkUse");
         }
         switch(_operator.text)
         {
            case ItemCriterionOperator.EQUAL:
               _loc1_ = I18n.getUiText("ui.criterion.guildRights",[_loc2_]);
               break;
            case ItemCriterionOperator.DIFFERENT:
               _loc1_ = I18n.getUiText("ui.criterion.notGuildRights",[_loc2_]);
         }
         return _loc1_;
      }
      
      override public function clone() : IItemCriterion
      {
         return new GuildRightsItemCriterion(this.basicText);
      }
   }
}
