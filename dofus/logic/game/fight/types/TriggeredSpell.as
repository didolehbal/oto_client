package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellZoneManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.DamageUtil;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.types.zones.IZone;
   
   public class TriggeredSpell
   {
       
      
      private var _casterId:int;
      
      private var _targetId:int;
      
      private var _spell:SpellWrapper;
      
      private var _triggers:String;
      
      private var _targets:Vector.<int>;
      
      private var _hasCritical:Boolean;
      
      public function TriggeredSpell(param1:int, param2:int, param3:SpellWrapper, param4:String, param5:Vector.<int>, param6:Boolean)
      {
         super();
         this._casterId = param1;
         this._targetId = param2;
         this._spell = param3;
         this._triggers = param4;
         this._targets = param5;
         this._hasCritical = param6;
      }
      
      public static function create(param1:String, param2:uint, param3:int, param4:int, param5:int, param6:int, param7:Boolean = true) : TriggeredSpell
      {
         var _loc8_:uint = 0;
         var _loc9_:EffectInstance = null;
         var _loc10_:Array = null;
         var _loc11_:IEntity = null;
         var _loc12_:SpellWrapper = null;
         var _loc13_:FightContextFrame = null;
         var _loc14_:Vector.<int> = null;
         var _loc15_:int = 0;
         var _loc16_:GameFightFighterInformations = null;
         var _loc17_:SpellWrapper = SpellWrapper.create(0,param2,param3,param7,param5);
         var _loc18_:IZone = SpellZoneManager.getInstance().getSpellZone(_loc17_,false,false);
         var _loc20_:int = (_loc19_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame) && _loc19_.getEntityInfos(param6)?int(_loc19_.getEntityInfos(param6).disposition.cellId):0;
         var _loc21_:Vector.<uint> = _loc18_.getCells(_loc20_);
         if(param4 > 0)
         {
            _loc12_ = SpellWrapper.create(0,param2,param4,false,param5);
            _loc17_.criticalEffect = _loc12_.effects;
         }
         var _loc22_:Vector.<int> = new Vector.<int>(0);
         for each(_loc8_ in _loc21_)
         {
            _loc10_ = EntitiesManager.getInstance().getEntitiesOnCell(_loc8_,AnimatedCharacter);
            for each(_loc11_ in _loc10_)
            {
               if(_loc19_.getEntityInfos(_loc11_.id))
               {
                  for each(_loc9_ in _loc17_.effects)
                  {
                     if(DamageUtil.verifySpellEffectMask(param5,_loc11_.id,_loc9_,_loc20_))
                     {
                        _loc22_.push(_loc11_.id);
                        break;
                     }
                  }
               }
            }
         }
         if(_loc18_.radius == 63)
         {
            _loc14_ = (_loc13_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame).entitiesFrame.getEntitiesIdsList();
            for each(_loc9_ in _loc17_.effects)
            {
               if(_loc9_.targetMask.indexOf("E263") != -1)
               {
                  for each(_loc15_ in _loc14_)
                  {
                     if((_loc16_ = _loc13_.entitiesFrame.getEntityInfos(_loc15_) as GameFightFighterInformations).disposition.cellId == -1 && DamageUtil.verifySpellEffectMask(param5,_loc15_,_loc9_,_loc20_))
                     {
                        _loc22_.push(_loc15_);
                     }
                  }
                  break;
               }
            }
         }
         return new TriggeredSpell(param5,param6,_loc17_,param1,_loc22_,param4 > 0);
      }
      
      public function get casterId() : int
      {
         return this._casterId;
      }
      
      public function get targetId() : int
      {
         return this._targetId;
      }
      
      public function get spell() : SpellWrapper
      {
         return this._spell;
      }
      
      public function get triggers() : String
      {
         return this._triggers;
      }
      
      public function get targets() : Vector.<int>
      {
         return this._targets;
      }
      
      public function get hasCritical() : Boolean
      {
         return this._hasCritical;
      }
   }
}
