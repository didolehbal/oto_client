package com.ankamagames.dofus.scripts.api
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.types.SpriteWrapper;
   import com.ankamagames.atouin.types.WorldEntitySprite;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.scripts.ScriptEntity;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.lua.LuaPackage;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.utils.Dictionary;
   
   public class EntityApi implements LuaPackage
   {
       
      
      private var _entities:Dictionary;
      
      private var _playerPosition:MapPoint;
      
      public function EntityApi()
      {
         this._entities = new Dictionary();
         super();
      }
      
      public function init() : void
      {
         this._playerPosition = (DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as AnimatedCharacter).position;
      }
      
      public function reset() : void
      {
         this.removeEntities();
         var _loc1_:ScriptEntity = this._entities[PlayedCharacterManager.getInstance().id];
         if(_loc1_)
         {
            _loc1_.teleport(this._playerPosition.x,this._playerPosition.y).start();
         }
         delete this._entities[PlayedCharacterManager.getInstance().id];
      }
      
      public function getEntity(param1:int) : ScriptEntity
      {
         var _loc2_:AnimatedCharacter = null;
         if(!this._entities[param1] && param1 == PlayedCharacterManager.getInstance().id)
         {
            _loc2_ = DofusEntities.getEntity(param1) as AnimatedCharacter;
            this._entities[param1] = new ScriptEntity(param1,_loc2_.look.toString());
         }
         return this._entities[param1];
      }
      
      public function getWorldEntity(param1:int) : ScriptEntity
      {
         var _loc2_:SpriteWrapper = null;
         var _loc3_:WorldEntitySprite = null;
         if(!this._entities[param1])
         {
            _loc2_ = Atouin.getInstance().getIdentifiedElement(param1) as SpriteWrapper;
            _loc3_ = _loc2_.getChildAt(0) as WorldEntitySprite;
            this._entities[param1] = new ScriptEntity(param1,_loc3_.look.toString(),_loc3_);
         }
         return this._entities[param1];
      }
      
      public function getEntityFromCell(param1:uint) : ScriptEntity
      {
         var _loc2_:SpriteWrapper = null;
         var _loc3_:WorldEntitySprite = null;
         var _loc7_:int = 0;
         var _loc4_:AnimatedCharacter;
         if(_loc4_ = Atouin.getInstance().getEntityOnCell(param1) as AnimatedCharacter)
         {
            if(!this._entities[_loc4_.id])
            {
               this._entities[_loc4_.id] = new ScriptEntity(_loc4_.id,_loc4_.look.toString(),_loc4_);
            }
            return this._entities[_loc4_.id];
         }
         var _loc5_:RoleplayContextFrame;
         var _loc6_:Vector.<InteractiveElement> = (_loc5_ = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame).entitiesFrame.interactiveElements;
         while(_loc7_ < _loc6_.length)
         {
            _loc2_ = Atouin.getInstance().getIdentifiedElement(_loc6_[_loc7_].elementId) as SpriteWrapper;
            _loc3_ = _loc2_.getChildAt(0) as WorldEntitySprite;
            if(_loc3_.cellId == param1)
            {
               this._entities[_loc3_.identifier] = new ScriptEntity(_loc3_.identifier,_loc3_.look.toString(),_loc3_);
               return this._entities[_loc3_.identifier];
            }
            _loc7_++;
         }
         return null;
      }
      
      public function getPlayer() : ScriptEntity
      {
         return this.getEntity(PlayedCharacterManager.getInstance().id);
      }
      
      public function createMonster(param1:int, param2:Boolean = true, param3:int = 0, param4:int = 0, param5:int = 1) : ScriptEntity
      {
         var _loc6_:ScriptEntity = this.createEntity(Monster.getMonsterById(param1).look);
         if(param2)
         {
            _loc6_.x = param3;
            _loc6_.y = param4;
            _loc6_.direction = param5;
            _loc6_.display().start();
         }
         return _loc6_;
      }
      
      public function createNpc(param1:int, param2:Boolean = true, param3:int = 0, param4:int = 0, param5:int = 1) : ScriptEntity
      {
         var _loc6_:ScriptEntity = this.createEntity(Npc.getNpcById(param1).look);
         if(param2)
         {
            _loc6_.x = param3;
            _loc6_.y = param4;
            _loc6_.direction = param5;
            _loc6_.display().start();
         }
         return _loc6_;
      }
      
      public function createCustom(param1:String, param2:Boolean = true, param3:int = 0, param4:int = 0, param5:int = 1) : ScriptEntity
      {
         var _loc6_:ScriptEntity = this.createEntity(param1);
         if(param2)
         {
            _loc6_.x = param3;
            _loc6_.y = param4;
            _loc6_.direction = param5;
            _loc6_.display().start();
         }
         return _loc6_;
      }
      
      public function removeEntity(param1:int) : void
      {
         delete this._entities[param1];
      }
      
      public function removeEntities() : void
      {
         var _loc1_:ScriptEntity = null;
         for each(_loc1_ in this._entities)
         {
            if(_loc1_.id != PlayedCharacterManager.getInstance().id)
            {
               _loc1_.destroy();
               _loc1_.remove().start();
            }
         }
      }
      
      private function createEntity(param1:String) : ScriptEntity
      {
         var _loc2_:int = EntitiesManager.getInstance().getFreeEntityId();
         this._entities[_loc2_] = new ScriptEntity(_loc2_,param1);
         return this._entities[_loc2_];
      }
   }
}
