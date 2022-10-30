package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.dofus.internalDatacenter.people.PartyMemberWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.PartyManagementFrame;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.network.enums.FightOptionsEnum;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightOptionsInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class FightTeam extends GameContextActorInformations
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightTeam));
       
      
      public var fight:Fight;
      
      public var teamType:uint;
      
      public var teamEntity:IEntity;
      
      public var teamInfos:FightTeamInformations;
      
      public var teamOptions:Array;
      
      public function FightTeam(param1:Fight, param2:uint, param3:IEntity, param4:FightTeamInformations, param5:FightOptionsInformations)
      {
         super();
         this.fight = param1;
         this.teamType = param2;
         this.teamEntity = param3;
         this.teamInfos = param4;
         this.look = EntityLookAdapter.toNetwork((param3 as AnimatedCharacter).look);
         this.teamOptions = new Array();
         this.teamOptions[FightOptionsEnum.FIGHT_OPTION_ASK_FOR_HELP] = param5.isAskingForHelp;
         this.teamOptions[FightOptionsEnum.FIGHT_OPTION_SET_CLOSED] = param5.isClosed;
         this.teamOptions[FightOptionsEnum.FIGHT_OPTION_SET_SECRET] = param5.isSecret;
         this.teamOptions[FightOptionsEnum.FIGHT_OPTION_SET_TO_PARTY_ONLY] = param5.isRestrictedToPartyOnly;
      }
      
      public function hasGroupMember() : Boolean
      {
         var _loc1_:PartyMemberWrapper = null;
         var _loc2_:FightTeamMemberInformations = null;
         var _loc3_:Boolean = false;
         var _loc4_:PartyManagementFrame = Kernel.getWorker().getFrame(PartyManagementFrame) as PartyManagementFrame;
         var _loc5_:Vector.<String> = new Vector.<String>();
         for each(_loc1_ in _loc4_.partyMembers)
         {
            _loc5_.push(_loc1_.name);
         }
         for each(_loc2_ in this.teamInfos.teamMembers)
         {
            if(_loc2_ && _loc2_ is FightTeamMemberCharacterInformations && _loc5_.indexOf(FightTeamMemberCharacterInformations(_loc2_).name) != -1)
            {
               _loc3_ = true;
               break;
            }
         }
         return _loc3_;
      }
      
      public function hasOptions() : Boolean
      {
         var _loc1_:* = undefined;
         var _loc2_:Boolean = false;
         for(_loc1_ in this.teamOptions)
         {
            if(this.teamOptions[_loc1_])
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
   }
}
