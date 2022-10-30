package com.ankamagames.dofus.logic.game.roleplay.managers
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.dofus.datacenter.monsters.AnimFunMonsterData;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.AnimFunNpcData;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.types.SynchroTimer;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.types.AnimFun;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Swl;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.utils.prng.PRNG;
   import com.ankamagames.jerakine.utils.prng.ParkMillerCarta;
   import com.ankamagames.tiphon.display.TiphonAnimation;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.engine.Tiphon;
   import com.ankamagames.tiphon.events.SwlEvent;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public final class AnimFunManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AnimFunManager));
      
      public static const ANIM_FUN_TIMER_MIN:int = 40000;
      
      public static const ANIM_FUN_TIMER_MAX:int = 80000;
      
      public static const ANIM_FUN_MAX_ANIM_DURATION:int = 20000;
      
      public static const FAST_ANIM_FUN_TIMER_MIN:int = 4000;
      
      public static const FAST_ANIM_FUN_TIMER_MAX:int = 5000;
      
      public static const ANIM_DELAY_SIZE:uint = 20;
      
      private static var _self:AnimFunManager;
       
      
      private var _animFunNpcData:AnimFunNpcData;
      
      private var _animFunMonsterData:AnimFunMonsterData;
      
      private var _anims:Vector.<AnimFun>;
      
      private var _nbAnims:int;
      
      private var _nbFastAnims:int;
      
      private var _nbNormalAnims:int;
      
      private var _mapId:int = -1;
      
      private var _entitiesList:Array;
      
      private var _running:Boolean;
      
      private var _animFunPlaying:Boolean;
      
      private var _animFunEntityId:int;
      
      private var _animSeq:SerialSequencer;
      
      private var _synchedAnimFuns:Dictionary;
      
      private var _fastTimer:SynchroTimer;
      
      private var _normalTimer:SynchroTimer;
      
      private var _lastFastAnimTime:int;
      
      private var _nextFastAnimDelay:int;
      
      private var _lastNormalAnimTime:int;
      
      private var _nextNormalAnimDelay:int;
      
      private var _lastAnim:AnimFun;
      
      private var _lastAnimFast:AnimFun;
      
      private var _lastAnimNormal:AnimFun;
      
      private var _cancelledAnim:AnimFun;
      
      private var _firstAnim:Boolean;
      
      public function AnimFunManager()
      {
         this._anims = new Vector.<AnimFun>(0);
         this._animSeq = new SerialSequencer();
         this._synchedAnimFuns = new Dictionary();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : AnimFunManager
      {
         if(!_self)
         {
            _self = new AnimFunManager();
         }
         return _self;
      }
      
      public function get mapId() : int
      {
         return this._mapId;
      }
      
      public function initializeByMap(param1:uint) : void
      {
         var _loc2_:GameContextActorInformations = null;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         this._mapId = param1;
         var _loc7_:PRNG;
         (_loc7_ = new ParkMillerCarta()).seed(param1 + 5435);
         var _loc8_:RoleplayEntitiesFrame;
         var _loc9_:Dictionary = (_loc8_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame).getEntitiesDictionnary();
         this._entitiesList = new Array();
         for each(_loc2_ in _loc9_)
         {
            if(this.hasAnimsFun(_loc2_.contextualId))
            {
               this._entitiesList.push(_loc2_);
            }
         }
         this._entitiesList.sortOn("contextualId",Array.NUMERIC);
         this._nbNormalAnims = this._nbFastAnims = 0;
         this._normalTimer = this._fastTimer = null;
         _loc3_ = 0;
         while(_loc3_ < ANIM_DELAY_SIZE)
         {
            _loc5_ = this.randomActor(_loc7_.nextInt());
            if(this.hasAnimsFun(_loc5_))
            {
               if(!(_loc4_ = this.hasFastAnims(_loc5_)))
               {
                  _loc6_ = _loc7_.nextIntR(ANIM_FUN_TIMER_MIN,ANIM_FUN_TIMER_MAX);
                  ++this._nbNormalAnims;
               }
               else
               {
                  _loc6_ = _loc7_.nextIntR(FAST_ANIM_FUN_TIMER_MIN,FAST_ANIM_FUN_TIMER_MAX);
                  ++this._nbFastAnims;
               }
               this._anims.push(new AnimFun(_loc5_,this.randomAnim(_loc5_,_loc7_.nextInt()),_loc6_,_loc4_));
            }
            _loc3_++;
         }
         this._nbAnims = this._anims.length;
         if(this._anims.length > 0)
         {
            this.start();
         }
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function start() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:AnimFun = null;
         for each(_loc3_ in this._anims)
         {
            if(!_loc3_.fastAnim)
            {
               _loc1_ = _loc1_ + _loc3_.delayTime;
            }
            else
            {
               _loc2_ = _loc2_ + _loc3_.delayTime;
            }
         }
         this._animSeq.addEventListener(SequencerEvent.SEQUENCE_END,this.onAnimFunEnd);
         this._firstAnim = true;
         if(this._nbFastAnims > 0)
         {
            this._fastTimer = new SynchroTimer(_loc2_);
            this._fastTimer.start(this.checkAvailableAnim);
         }
         if(this._nbNormalAnims > 0)
         {
            this._normalTimer = new SynchroTimer(_loc1_);
            this._normalTimer.start(this.checkAvailableAnim);
         }
         this._running = true;
      }
      
      public function stop() : void
      {
         Tiphon.skullLibrary.removeEventListener(SwlEvent.SWL_LOADED,this.onSwlLoaded);
         this._running = this._animFunPlaying = false;
         this._animFunEntityId = 0;
         this._lastAnimFast = this._lastAnimNormal = this._lastAnim = null;
         this._anims.length = 0;
         this._animSeq.clear();
         this._animSeq.removeEventListener(SequencerEvent.SEQUENCE_END,this.onAnimFunEnd);
         if(this._fastTimer)
         {
            this._fastTimer.stop();
         }
         if(this._normalTimer)
         {
            this._normalTimer.stop();
         }
      }
      
      public function restart() : void
      {
         this.stop();
         this.initializeByMap(this._mapId);
      }
      
      public function cancelAnim(param1:int) : void
      {
         var _loc2_:TiphonSprite = null;
         if(this._animFunPlaying && this._animFunEntityId == param1)
         {
            this._cancelledAnim = this._lastAnim;
            _loc2_ = DofusEntities.getEntity(this._animFunEntityId) as TiphonSprite;
            _loc2_.dispatchEvent(new Event(TiphonEvent.ANIMATION_END));
         }
         Tiphon.skullLibrary.removeEventListener(SwlEvent.SWL_LOADED,this.onSwlLoaded);
         this._firstAnim = false;
         this._animFunPlaying = false;
         this._animFunEntityId = 0;
      }
      
      private function getTimerValue() : int
      {
         return getTimer() % int.MAX_VALUE;
      }
      
      private function checkAvailableAnim(param1:SynchroTimer) : void
      {
         var _loc2_:AnimFun = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:AnimatedCharacter = null;
         var _loc7_:RoleplayEntitiesFrame = null;
         var _loc8_:CellData = null;
         var _loc9_:* = param1 == this._fastTimer;
         if(!this._animFunPlaying)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            if(_loc9_)
            {
               if(this.getTimerValue() - this._lastFastAnimTime > this._nextFastAnimDelay)
               {
                  _loc3_ = 0;
                  while(_loc3_ < this._nbAnims)
                  {
                     if(this._anims[_loc3_].fastAnim)
                     {
                        if((_loc4_ = _loc4_ + this._anims[_loc3_].delayTime) >= param1.value)
                        {
                           _loc5_ = param1.value - (_loc4_ - this._anims[_loc3_].delayTime);
                           _loc2_ = _loc3_ > 0?this._anims[_loc3_ - 1]:this._anims[0];
                           this._lastFastAnimTime = this.getTimerValue();
                           this._nextFastAnimDelay = this._anims[_loc3_].delayTime;
                           break;
                        }
                     }
                     _loc3_++;
                  }
               }
            }
            else if(this.getTimerValue() - this._lastNormalAnimTime > this._nextNormalAnimDelay)
            {
               _loc3_ = 0;
               while(_loc3_ < this._nbAnims)
               {
                  if(!this._anims[_loc3_].fastAnim)
                  {
                     if((_loc4_ = _loc4_ + this._anims[_loc3_].delayTime) >= param1.value)
                     {
                        _loc5_ = param1.value - (_loc4_ - this._anims[_loc3_].delayTime);
                        _loc2_ = _loc3_ > 0?this._anims[_loc3_ - 1]:this._anims[0];
                        this._lastNormalAnimTime = this.getTimerValue();
                        this._nextNormalAnimDelay = this._anims[_loc3_].delayTime;
                        break;
                     }
                  }
                  _loc3_++;
               }
            }
         }
         if(!_loc2_)
         {
            return;
         }
         if((!this._firstAnim || this._firstAnim && !this._lastAnim) && (this._lastAnim != _loc2_ && (_loc2_.fastAnim && _loc2_ != this._lastAnimFast || !_loc2_.fastAnim && _loc2_ != this._lastAnimNormal)))
         {
            if(_loc2_.fastAnim)
            {
               this._lastAnimFast = _loc2_;
            }
            else
            {
               this._lastAnimNormal = _loc2_;
            }
            this._lastAnim = _loc2_;
            if(_loc2_)
            {
               if(this.getIsMapStatic())
               {
                  if(!(_loc6_ = DofusEntities.getEntity(_loc2_.actorId) as AnimatedCharacter))
                  {
                     return;
                  }
                  if(!(_loc7_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame))
                  {
                     return;
                  }
                  _loc8_ = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[_loc6_.position.cellId];
                  if(!Atouin.getInstance().options.transparentOverlayMode && !_loc8_.visible)
                  {
                     return;
                  }
                  if(_loc7_.hasIcon(_loc2_.actorId))
                  {
                     _loc7_.forceIconUpdate(_loc2_.actorId);
                  }
                  this.synchCurrentAnim(_loc2_,_loc5_);
               }
            }
            return;
         }
      }
      
      private function playAnimFun(param1:AnimFun, param2:int = -1) : void
      {
         var _loc3_:TiphonSprite = DofusEntities.getEntity(param1.actorId) as TiphonSprite;
         var _loc4_:PlayAnimationStep;
         (_loc4_ = new PlayAnimationStep(_loc3_,param1.animName)).timeout = ANIM_FUN_MAX_ANIM_DURATION;
         _loc4_.startFrame = param2;
         this._animFunPlaying = true;
         this._animFunEntityId = param1.actorId;
         this._animSeq.addStep(_loc4_);
         this._animSeq.start();
         this._firstAnim = false;
      }
      
      private function onAnimFunEnd(param1:SequencerEvent) : void
      {
         this._animFunPlaying = false;
         this._animFunEntityId = 0;
      }
      
      private function randomActor(param1:int) : int
      {
         var _loc2_:int = 0;
         if(this._entitiesList.length)
         {
            _loc2_ = param1 % this._entitiesList.length;
            return this._entitiesList[_loc2_].contextualId;
         }
         return 0;
      }
      
      private function randomAnim(param1:int, param2:int) : String
      {
         var _loc3_:Object = null;
         var _loc4_:GameRolePlayGroupMonsterInformations = null;
         var _loc5_:Monster = null;
         var _loc6_:GameRolePlayNpcInformations = null;
         var _loc7_:Npc = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc13_:int = 0;
         var _loc8_:RoleplayEntitiesFrame;
         if(!(_loc8_ = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame))
         {
            return null;
         }
         var _loc9_:GameContextActorInformations;
         if((_loc9_ = _loc8_.getEntityInfos(param1)) is GameRolePlayGroupMonsterInformations)
         {
            _loc4_ = _loc9_ as GameRolePlayGroupMonsterInformations;
            if(!(_loc5_ = Monster.getMonsterById(_loc4_.staticInfos.mainCreatureLightInfos.creatureGenericId)))
            {
               return null;
            }
            _loc3_ = _loc5_.animFunList;
         }
         else
         {
            if(!(_loc9_ is GameRolePlayNpcInformations))
            {
               return null;
            }
            _loc6_ = _loc9_ as GameRolePlayNpcInformations;
            if(!(_loc7_ = Npc.getNpcById(_loc6_.npcId)))
            {
               return null;
            }
            _loc3_ = _loc7_.animFunList;
         }
         var _loc12_:int = _loc3_.length;
         while(_loc13_ < _loc12_)
         {
            _loc11_ = _loc11_ + _loc3_[_loc13_].animWeight;
            _loc13_++;
         }
         var _loc14_:Number = param2 % _loc11_;
         _loc11_ = 0;
         _loc13_ = 0;
         while(_loc13_ < _loc12_)
         {
            if((_loc11_ = _loc11_ + _loc3_[_loc13_].animWeight) > _loc14_)
            {
               return _loc3_[_loc13_].animName;
            }
            _loc13_++;
         }
         return null;
      }
      
      private function getIsMapStatic() : Boolean
      {
         var _loc1_:GameContextActorInformations = null;
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         var _loc4_:Dictionary = _loc3_.getEntitiesDictionnary();
         var _loc5_:Array = new Array();
         for each(_loc1_ in _loc4_)
         {
            _loc2_ = DofusEntities.getEntity(_loc1_.contextualId) as AnimatedCharacter;
            if(_loc2_ && _loc2_.isMoving)
            {
               return false;
            }
         }
         return true;
      }
      
      private function synchCurrentAnim(param1:AnimFun, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:AnimFun = null;
         var _loc5_:AnimFun = null;
         var _loc6_:TiphonSprite = null;
         var _loc7_:Callback = null;
         var _loc8_:* = false;
         var _loc9_:int = this._anims.indexOf(param1);
         var _loc10_:int;
         _loc3_ = (_loc10_ = this._anims.length) - 1;
         while(_loc3_ >= 0)
         {
            if(this._anims[_loc3_].fastAnim == param1.fastAnim && _loc3_ < _loc9_)
            {
               _loc5_ = this._anims[_loc3_];
               break;
            }
            _loc3_--;
         }
         if(!this._firstAnim || _loc5_ == this._cancelledAnim)
         {
            _loc5_ = null;
         }
         this._cancelledAnim = null;
         if(_loc4_ = param1)
         {
            _loc6_ = DofusEntities.getEntity(_loc4_.actorId) as TiphonSprite;
            Tiphon.skullLibrary.removeEventListener(SwlEvent.SWL_LOADED,this.onSwlLoaded);
            if((_loc8_ = Tiphon.skullLibrary.getResourceById(_loc6_.look.getBone(),_loc4_.animName,true) != null) && (!_loc5_ || Tiphon.skullLibrary.getResourceById((DofusEntities.getEntity(_loc5_.actorId) as TiphonSprite).look.getBone(),_loc5_.animName,true) != null))
            {
               this.playSynchAnim(new AnimFunInfo(_loc4_,_loc5_,param2));
            }
            else
            {
               this._synchedAnimFuns[_loc6_] = new AnimFunInfo(_loc4_,_loc5_,param2,this.getTimerValue());
               Tiphon.skullLibrary.addEventListener(SwlEvent.SWL_LOADED,this.onSwlLoaded);
            }
         }
      }
      
      private function onSwlLoaded(param1:SwlEvent) : void
      {
         var _loc2_:AnimFunInfo = null;
         var _loc3_:TiphonSprite = DofusEntities.getEntity(this._lastAnim.actorId) as TiphonSprite;
         var _loc4_:Boolean;
         if(_loc4_ = Tiphon.skullLibrary.isLoaded(_loc3_.look.getBone(),this._lastAnim.animName))
         {
            Tiphon.skullLibrary.removeEventListener(SwlEvent.SWL_LOADED,this.onSwlLoaded);
            _loc2_ = this._synchedAnimFuns[_loc3_] as AnimFunInfo;
            if(!_loc2_.previousAnimFun || Tiphon.skullLibrary.getResourceById((DofusEntities.getEntity(_loc2_.previousAnimFun.actorId) as TiphonSprite).look.getBone(),_loc2_.previousAnimFun.animName,true) != null)
            {
               if(_loc2_.previousAnimLoadTime > 0)
               {
                  _loc2_.loadTime = _loc2_.loadTime + (this.getTimerValue() - _loc2_.previousAnimLoadTime);
               }
               this.playSynchAnim(_loc2_);
               delete this._synchedAnimFuns[_loc3_];
            }
            else
            {
               if(_loc2_.previousAnimFun)
               {
                  _loc2_.previousAnimLoadTime = this.getTimerValue();
               }
               Tiphon.skullLibrary.addEventListener(SwlEvent.SWL_LOADED,this.onSwlLoaded);
            }
         }
      }
      
      private function getAnimSum(param1:AnimFun) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this._nbAnims)
         {
            _loc3_ = _loc3_ + this._anims[_loc2_].delayTime;
            if(this._anims[_loc2_] == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      private function playSynchAnim(param1:AnimFunInfo) : void
      {
         var _loc2_:AnimFunClipInfo = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = param1.elapsedTime + (param1.loadTime > 0?this.getTimerValue() - param1.loadTime:0);
         var _loc7_:AnimFunClipInfo = !!param1.previousAnimFun?this.getAnimClipInfo(param1.previousAnimFun):null;
         var _loc8_:AnimFun = param1.animFun;
         if(_loc7_)
         {
            _loc3_ = this.getAnimSum(param1.previousAnimFun);
            _loc4_ = this.getAnimSum(param1.animFun);
            if(_loc3_ + _loc7_.duration > _loc4_ + _loc6_)
            {
               _loc2_ = _loc7_;
               _loc6_ = _loc7_.duration - (_loc3_ + _loc7_.duration - _loc4_ + _loc6_);
               _loc8_ = param1.previousAnimFun;
               this._lastAnim = _loc8_;
            }
            else
            {
               _loc2_ = this.getAnimClipInfo(param1.animFun);
            }
         }
         else
         {
            _loc2_ = this.getAnimClipInfo(param1.animFun);
         }
         if(_loc2_)
         {
            if(!this._firstAnim || this._firstAnim && _loc6_ < _loc2_.duration)
            {
               if(this._firstAnim)
               {
                  _loc5_ = _loc6_ / _loc2_.duration;
                  this.playAnimFun(_loc8_,_loc5_ * _loc2_.totalFrames);
               }
               else
               {
                  this.playAnimFun(_loc8_,0);
               }
            }
            else
            {
               this._firstAnim = false;
               this._animFunPlaying = false;
               this._animFunEntityId = 0;
            }
         }
         else
         {
            this._firstAnim = false;
            this._animFunPlaying = false;
            this._animFunEntityId = 0;
         }
      }
      
      private function getAnimClipInfo(param1:AnimFun) : AnimFunClipInfo
      {
         var _loc2_:Class = null;
         var _loc3_:* = null;
         var _loc4_:TiphonAnimation = null;
         var _loc5_:TiphonSprite = DofusEntities.getEntity(param1.actorId) as TiphonSprite;
         var _loc6_:Swl = Tiphon.skullLibrary.getResourceById(_loc5_.look.getBone(),param1.animName);
         var _loc7_:Array = _loc5_.getAvaibleDirection(param1.animName,true);
         var _loc8_:uint = _loc5_.getDirection();
         if(!_loc7_[_loc8_])
         {
            for(_loc3_ in _loc7_)
            {
               if(_loc7_[_loc3_])
               {
                  _loc8_ = uint(_loc3_);
                  break;
               }
            }
         }
         var _loc9_:String = param1.animName + "_" + _loc8_;
         if(_loc6_.hasDefinition(_loc9_))
         {
            _loc2_ = _loc6_.getDefinition(_loc9_) as Class;
         }
         else
         {
            _loc9_ = param1.animName + "_" + TiphonUtility.getFlipDirection(_loc8_);
            if(_loc6_.hasDefinition(_loc9_))
            {
               _loc2_ = _loc6_.getDefinition(_loc9_) as Class;
            }
         }
         if(_loc2_)
         {
            _loc4_ = new _loc2_() as TiphonAnimation;
            return new AnimFunClipInfo(_loc4_.totalFrames / _loc6_.frameRate * 1000,_loc4_.totalFrames);
         }
         return null;
      }
      
      private function hasFastAnims(param1:int) : Boolean
      {
         var _loc2_:Monster = null;
         var _loc3_:Npc = null;
         var _loc4_:GameContextActorInformations;
         if((_loc4_ = (Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame).getEntityInfos(param1)) is GameRolePlayGroupMonsterInformations)
         {
            _loc2_ = Monster.getMonsterById((_loc4_ as GameRolePlayGroupMonsterInformations).staticInfos.mainCreatureLightInfos.creatureGenericId);
            return _loc2_.fastAnimsFun;
         }
         if(_loc4_ is GameRolePlayNpcInformations)
         {
            _loc3_ = Npc.getNpcById((_loc4_ as GameRolePlayNpcInformations).npcId);
            return _loc3_.fastAnimsFun;
         }
         return false;
      }
      
      private function hasAnimsFun(param1:int) : Boolean
      {
         var _loc2_:Monster = null;
         var _loc3_:Npc = null;
         var _loc4_:GameContextActorInformations;
         if((_loc4_ = (Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame).getEntityInfos(param1)) is GameRolePlayGroupMonsterInformations)
         {
            _loc2_ = Monster.getMonsterById((_loc4_ as GameRolePlayGroupMonsterInformations).staticInfos.mainCreatureLightInfos.creatureGenericId);
            return _loc2_ && _loc2_.animFunList.length != 0;
         }
         if(_loc4_ is GameRolePlayNpcInformations)
         {
            _loc3_ = Npc.getNpcById((_loc4_ as GameRolePlayNpcInformations).npcId);
            return _loc3_ && _loc3_.animFunList.length != 0;
         }
         return false;
      }
   }
}

import com.ankamagames.dofus.logic.game.roleplay.types.AnimFun;

class AnimFunInfo
{
    
   
   public var animFun:AnimFun;
   
   public var previousAnimFun:AnimFun;
   
   public var elapsedTime:int;
   
   public var loadTime:int;
   
   public var previousAnimLoadTime:int;
   
   function AnimFunInfo(param1:AnimFun, param2:AnimFun, param3:int, param4:int = 0)
   {
      super();
      this.animFun = param1;
      this.previousAnimFun = param2;
      this.elapsedTime = param3;
      this.loadTime = param4;
   }
}

class AnimFunClipInfo
{
    
   
   public var duration:int;
   
   public var totalFrames:int;
   
   function AnimFunClipInfo(param1:int, param2:int)
   {
      super();
      this.duration = param1;
      this.totalFrames = param2;
   }
}
