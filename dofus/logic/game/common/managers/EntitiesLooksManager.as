package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.dofus.datacenter.appearance.CreatureBoneType;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.items.Incarnation;
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.logic.game.common.frames.AbstractEntitiesFrame;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayHumanoidInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.utils.getQualifiedClassName;
   
   public class EntitiesLooksManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(EntitiesLooksManager));
      
      private static var _self:EntitiesLooksManager;
       
      
      private var _entitiesFrame:AbstractEntitiesFrame;
      
      public function EntitiesLooksManager()
      {
         super();
      }
      
      public static function getInstance() : EntitiesLooksManager
      {
         if(!_self)
         {
            _self = new EntitiesLooksManager();
         }
         return _self;
      }
      
      public function set entitiesFrame(param1:AbstractEntitiesFrame) : void
      {
         this._entitiesFrame = param1;
      }
      
      public function isCreatureMode() : Boolean
      {
         if(!this._entitiesFrame)
         {
            return false;
         }
         return this._entitiesFrame is RoleplayEntitiesFrame?Boolean((this._entitiesFrame as RoleplayEntitiesFrame).isCreatureMode):Boolean((this._entitiesFrame as FightEntitiesFrame).isInCreaturesFightMode());
      }
      
      public function isCreature(param1:int) : Boolean
      {
         var _loc2_:TiphonEntityLook = this.getTiphonEntityLook(param1);
         if(_loc2_)
         {
            if(this.isCreatureFromLook(_loc2_) || this.isCreatureMode() && this.getLookFromContext(param1).getBone() == _loc2_.getBone())
            {
               return true;
            }
         }
         return false;
      }
      
      public function isCreatureFromLook(param1:TiphonEntityLook) : Boolean
      {
         var _loc2_:Breed = null;
         var _loc3_:uint = param1.getBone();
         var _loc4_:Array = Breed.getBreeds();
         for each(_loc2_ in _loc4_)
         {
            if(_loc2_.creatureBonesId == _loc3_)
            {
               return true;
            }
         }
         if(param1.getBone() == CreatureBoneType.getPlayerIncarnationCreatureBone())
         {
            return true;
         }
         return false;
      }
      
      public function isIncarnation(param1:int) : Boolean
      {
         var _loc2_:TiphonEntityLook = this.getRealTiphonEntityLook(param1,true);
         if(_loc2_ && this.isIncarnationFromLook(_loc2_))
         {
            return true;
         }
         return false;
      }
      
      public function isIncarnationFromLook(param1:TiphonEntityLook) : Boolean
      {
         var _loc2_:Incarnation = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1.getBone() == CreatureBoneType.getPlayerIncarnationCreatureBone())
         {
            return true;
         }
         var _loc5_:Array = Incarnation.getAllIncarnation();
         var _loc6_:String;
         var _loc7_:String = (_loc6_ = param1.toString()).slice(1,_loc6_.indexOf("|"));
         for each(_loc2_ in _loc5_)
         {
            _loc3_ = _loc2_.lookMale.slice(1,_loc2_.lookMale.indexOf("|"));
            _loc4_ = _loc2_.lookFemale.slice(1,_loc2_.lookFemale.indexOf("|"));
            if(_loc7_ == _loc3_ || _loc7_ == _loc4_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getTiphonEntityLook(param1:int) : TiphonEntityLook
      {
         var _loc2_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         return !!_loc2_?_loc2_.look.clone():null;
      }
      
      public function getRealTiphonEntityLook(param1:int, param2:Boolean = false) : TiphonEntityLook
      {
         var _loc3_:EntityLook = null;
         var _loc4_:GameContextActorInformations = null;
         var _loc5_:TiphonEntityLook = null;
         if(this._entitiesFrame)
         {
            if(this._entitiesFrame is FightEntitiesFrame)
            {
               _loc3_ = (this._entitiesFrame as FightEntitiesFrame).getRealFighterLook(param1);
            }
            else
            {
               _loc3_ = !!(_loc4_ = this._entitiesFrame.getEntityInfos(param1))?_loc4_.look:null;
            }
         }
         if(!_loc3_ && param1 == PlayedCharacterManager.getInstance().id)
         {
            _loc3_ = PlayedCharacterManager.getInstance().infos.entityLook;
         }
         var _loc6_:TiphonEntityLook;
         if((_loc6_ = !!_loc3_?EntityLookAdapter.fromNetwork(_loc3_):null) && param2)
         {
            if(_loc5_ = _loc6_.getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0))
            {
               _loc6_ = _loc5_;
            }
         }
         return _loc6_;
      }
      
      public function getCreatureLook(param1:int) : TiphonEntityLook
      {
         var _loc2_:GameContextActorInformations = !!this._entitiesFrame?this._entitiesFrame.getEntityInfos(param1):null;
         return !!_loc2_?this.getLookFromContextInfos(_loc2_,true):null;
      }
      
      public function getLookFromContext(param1:int, param2:Boolean = false) : TiphonEntityLook
      {
         var _loc3_:GameContextActorInformations = !!this._entitiesFrame?this._entitiesFrame.getEntityInfos(param1):null;
         return !!_loc3_?this.getLookFromContextInfos(_loc3_,param2):null;
      }
      
      public function getLookFromContextInfos(param1:GameContextActorInformations, param2:Boolean = false) : TiphonEntityLook
      {
         var _loc3_:GameFightCompanionInformations = null;
         var _loc4_:Companion = null;
         var _loc5_:GameFightMonsterInformations = null;
         var _loc6_:* = false;
         var _loc7_:Monster = null;
         var _loc8_:int = 0;
         var _loc9_:TiphonEntityLook = null;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:Breed = null;
         var _loc13_:TiphonEntityLook = null;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         var _loc16_:TiphonEntityLook = EntityLookAdapter.fromNetwork(param1.look);
         if(this.isCreatureMode() || param2)
         {
            switch(true)
            {
               case param1 is GameRolePlayHumanoidInformations:
               case param1 is GameFightCharacterInformations:
                  if(this.isIncarnation(param1.contextualId))
                  {
                     _loc16_.setBone(CreatureBoneType.getPlayerIncarnationCreatureBone());
                  }
                  else
                  {
                     _loc9_ = !!_loc16_.getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0)?TiphonUtility.getLookWithoutMount(_loc16_):_loc16_;
                     _loc10_ = !!param1.hasOwnProperty("breed")?int(param1["breed"]):0;
                     _loc11_ = this.isBoneCorrect(_loc9_.getBone());
                     _loc12_ = Breed.getBreedFromSkin(_loc9_.firstSkin);
                     if(_loc10_ <= 0 && _loc11_ && _loc12_)
                     {
                        _loc10_ = _loc12_.id;
                     }
                     else if(!_loc11_)
                     {
                        switch(_loc9_.getBone())
                        {
                           case 453:
                              _loc10_ = 12;
                              break;
                           case 706:
                           case 1504:
                           case 1509:
                           case 113:
                              _loc16_.setBone(CreatureBoneType.getPlayerIncarnationCreatureBone());
                        }
                     }
                     if(_loc10_ <= 0)
                     {
                        return _loc16_;
                     }
                     _loc16_.setBone(Breed.getBreedById(_loc10_).creatureBonesId);
                  }
                  break;
               case param1 is GameRolePlayPrismInformations:
                  _loc16_.setBone(CreatureBoneType.getPrismCreatureBone());
                  break;
               case param1 is GameRolePlayMerchantInformations:
                  _loc16_.setBone(CreatureBoneType.getPlayerMerchantCreatureBone());
                  break;
               case param1 is GameRolePlayTaxCollectorInformations:
               case param1 is GameFightTaxCollectorInformations:
                  _loc16_.setBone(CreatureBoneType.getTaxCollectorCreatureBone());
                  break;
               case param1 is GameFightCompanionInformations:
                  _loc3_ = param1 as GameFightCompanionInformations;
                  _loc4_ = Companion.getCompanionById(_loc3_.companionGenericId);
                  _loc16_.setBone(_loc4_.creatureBoneId);
                  break;
               case param1 is GameFightMutantInformations:
                  _loc16_.setBone(CreatureBoneType.getMonsterCreatureBone());
                  break;
               case param1 is GameFightMonsterInformations:
                  _loc6_ = (_loc5_ = param1 as GameFightMonsterInformations).creatureGenericId == 3451;
                  _loc7_ = Monster.getMonsterById(_loc5_.creatureGenericId);
                  if(_loc5_.stats.summoned)
                  {
                     _loc8_ = CreatureBoneType.getMonsterInvocationCreatureBone();
                  }
                  else if(_loc7_.isBoss)
                  {
                     _loc8_ = CreatureBoneType.getBossMonsterCreatureBone();
                  }
                  else if(_loc6_)
                  {
                     _loc8_ = CreatureBoneType.getPrismCreatureBone();
                  }
                  else
                  {
                     _loc8_ = CreatureBoneType.getMonsterCreatureBone();
                  }
                  _loc16_.setBone(_loc8_);
                  break;
               case param1 is GameRolePlayActorInformations:
                  return _loc16_;
            }
            _loc16_.setScales(0.9,0.9);
         }
         else if(param1 is GameFightCharacterInformations && !(this._entitiesFrame as FightEntitiesFrame).charactersMountsVisible)
         {
            if(!(_loc13_ = _loc16_.getSubEntity(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0)))
            {
               _loc13_ = _loc16_;
            }
            _loc14_ = _loc13_.getBone();
            _loc16_ = TiphonUtility.getLookWithoutMount(_loc16_);
            if(_loc14_ == 2)
            {
               if(_loc15_ = FightersStateManager.getInstance().getStates(param1.contextualId))
               {
                  if(_loc15_.indexOf(98) == -1)
                  {
                     if(_loc15_.indexOf(99) != -1)
                     {
                        _loc16_.setBone(1575);
                     }
                     else if(_loc15_.indexOf(100) != -1)
                     {
                        _loc16_.setBone(1576);
                     }
                  }
               }
            }
         }
         return _loc16_;
      }
      
      private function isBoneCorrect(param1:int) : Boolean
      {
         if(param1 == 1 || param1 == 44 || param1 == 1575 || param1 == 1576)
         {
            return true;
         }
         return false;
      }
   }
}
