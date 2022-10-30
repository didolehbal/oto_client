package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberCompanionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberWithAllianceCharacterInformations;
   import com.ankamagames.jerakine.data.I18n;
   import flash.utils.Dictionary;
   
   public class RoleplayTeamFightersTooltipInformation
   {
       
      
      private var _waitingCompanions:Dictionary;
      
      public var fighters:Vector.<Fighter>;
      
      public var nbWaves:uint;
      
      public function RoleplayTeamFightersTooltipInformation(param1:FightTeam)
      {
         var _loc2_:FightTeamMemberInformations = null;
         var _loc3_:int = 0;
         var _loc4_:Fighter = null;
         var _loc5_:String = null;
         var _loc6_:Monster = null;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:FightTeamMemberCompanionInformations = null;
         super();
         this.nbWaves = param1.teamInfos.nbWaves;
         this.fighters = new Vector.<Fighter>();
         var _loc14_:int = param1.teamInfos.teamMembers.length;
         _loc3_ = 0;
         for(; _loc3_ < _loc14_; if(_loc4_)
         {
            this.fighters.push(_loc4_);
            if(this._waitingCompanions && this._waitingCompanions[_loc4_.id])
            {
               this.fighters.push(this.getCompanionFighter(_loc4_,this._waitingCompanions[_loc4_.id].id,this._waitingCompanions[_loc4_.id].genericId));
               delete this._waitingCompanions[_loc4_.id];
            }
         },_loc3_++)
         {
            _loc2_ = param1.teamInfos.teamMembers[_loc3_];
            _loc4_ = null;
            switch(true)
            {
               case _loc2_ is FightTeamMemberCharacterInformations:
                  if(_loc2_ is FightTeamMemberWithAllianceCharacterInformations)
                  {
                     _loc5_ = (_loc2_ as FightTeamMemberWithAllianceCharacterInformations).allianceInfos.allianceTag;
                  }
                  _loc4_ = new Fighter(_loc2_.id,(_loc2_ as FightTeamMemberCharacterInformations).name,(_loc2_ as FightTeamMemberCharacterInformations).level,_loc5_);
                  continue;
               case _loc2_ is FightTeamMemberMonsterInformations:
                  _loc7_ = (_loc6_ = Monster.getMonsterById((_loc2_ as FightTeamMemberMonsterInformations).monsterId)).getMonsterGrade((_loc2_ as FightTeamMemberMonsterInformations).grade).level;
                  _loc8_ = _loc6_.name;
                  _loc4_ = new Fighter(_loc2_.id,_loc8_,_loc7_);
                  continue;
               case _loc2_ is FightTeamMemberTaxCollectorInformations:
                  _loc9_ = (_loc2_ as FightTeamMemberTaxCollectorInformations).level;
                  _loc10_ = TaxCollectorFirstname.getTaxCollectorFirstnameById((_loc2_ as FightTeamMemberTaxCollectorInformations).firstNameId).firstname;
                  _loc11_ = TaxCollectorName.getTaxCollectorNameById((_loc2_ as FightTeamMemberTaxCollectorInformations).lastNameId).name;
                  _loc12_ = _loc10_ + " " + _loc11_;
                  _loc4_ = new Fighter(_loc2_.id,_loc12_,_loc9_);
                  continue;
               case _loc2_ is FightTeamMemberCompanionInformations:
                  _loc13_ = _loc2_ as FightTeamMemberCompanionInformations;
                  if(this.fighters.length > 0 && _loc3_ > 0 && this.fighters[_loc3_ - 1].id == _loc13_.masterId)
                  {
                     _loc4_ = this.getCompanionFighter(this.fighters[_loc3_ - 1],_loc13_.id,_loc13_.companionId);
                  }
                  else
                  {
                     if(!this._waitingCompanions)
                     {
                        this._waitingCompanions = new Dictionary();
                     }
                     this._waitingCompanions[_loc13_.masterId] = {
                        "id":_loc13_.id,
                        "genericId":_loc13_.companionId
                     };
                  }
                  continue;
               default:
                  continue;
            }
         }
      }
      
      private function getCompanionFighter(param1:Fighter, param2:int, param3:int) : Fighter
      {
         return new Fighter(param2,I18n.getUiText("ui.common.belonging",[Companion.getCompanionById(param3).name,param1.name]),param1.level,param1.allianceTagName);
      }
   }
}

class Fighter
{
    
   
   private var _id:int;
   
   public var allianceTagName:String;
   
   public var name:String;
   
   public var level:uint;
   
   function Fighter(param1:int, param2:String, param3:uint, param4:String = null)
   {
      super();
      this._id = param1;
      this.name = param2;
      this.level = param3;
      this.allianceTagName = param4;
   }
   
   public function get allianceTag() : String
   {
      return !!this.allianceTagName?"[" + this.allianceTagName + "]":null;
   }
   
   public function get id() : int
   {
      return this._id;
   }
}
