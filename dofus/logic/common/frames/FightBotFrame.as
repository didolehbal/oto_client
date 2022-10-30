package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.MapsLoadingStartedMessage;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightReachableCellsMaker;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.network.messages.authorized.AdminQuietCommandMessage;
   import com.ankamagames.dofus.network.messages.common.basic.BasicPingMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCastRequestMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightReadyMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnFinishMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnStartMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapFightCountMessage;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOutMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOverMessage;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.pools.GenericPool;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class FightBotFrame implements Frame
   {
      
      private static var _self:FightBotFrame;
       
      
      private var _frameFightListRequest:Boolean;
      
      private var _fightCount:uint;
      
      private var _mapPos:Array;
      
      private var _enabled:Boolean;
      
      private var _rollOverTimer:Timer;
      
      private var _actionTimer:Timer;
      
      private var _inFight:Boolean;
      
      private var _lastElemOver:Sprite;
      
      private var _lastEntityOver:IInteractive;
      
      private var _wait:Boolean;
      
      private var _turnPlayed:uint;
      
      private var _myTurn:Boolean;
      
      private var _turnAction:Array;
      
      public function FightBotFrame()
      {
         this._rollOverTimer = new Timer(2000);
         this._actionTimer = new Timer(5000);
         this._turnAction = [];
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this.initRight();
         this._actionTimer.addEventListener(TimerEvent.TIMER,this.onAction);
         this._rollOverTimer.addEventListener(TimerEvent.TIMER,this.randomOver);
      }
      
      public static function getInstance() : FightBotFrame
      {
         if(!_self)
         {
            _self = new FightBotFrame();
         }
         return _self;
      }
      
      public function pushed() : Boolean
      {
         this._enabled = true;
         this.fakeActivity();
         this._myTurn = false;
         this._actionTimer.start();
         this._rollOverTimer.start();
         this._mapPos = MapPosition.getMapPositions();
         var _loc1_:MapFightCountMessage = new MapFightCountMessage();
         _loc1_.initMapFightCountMessage(1);
         this.process(_loc1_);
         return true;
      }
      
      public function pulled() : Boolean
      {
         this._rollOverTimer.stop();
         this._actionTimer.stop();
         this._enabled = false;
         return true;
      }
      
      public function get priority() : int
      {
         return Priority.ULTIMATE_HIGHEST_DEPTH_OF_DOOM;
      }
      
      public function get fightCount() : uint
      {
         return this._fightCount;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:GameFightReadyMessage = null;
         var _loc3_:GameFightTurnStartMessage = null;
         switch(true)
         {
            case param1 is GameFightJoinMessage:
               ++this._fightCount;
               this._inFight = true;
               break;
            case param1 is GameFightEndMessage:
               this._inFight = false;
               break;
            case param1 is MapComplementaryInformationsDataMessage:
               this._wait = false;
               break;
            case param1 is MapsLoadingStartedMessage:
               this._wait = true;
               break;
            case param1 is GameFightShowFighterMessage:
               this.sendAdminCmd("givelife *");
               this.sendAdminCmd("giveenergy *");
               this._turnPlayed = 0;
               this._myTurn = false;
               _loc2_ = new GameFightReadyMessage();
               _loc2_.initGameFightReadyMessage(true);
               ConnectionsHandler.getConnection().send(_loc2_);
               break;
            case param1 is GameFightTurnStartMessage:
               _loc3_ = param1 as GameFightTurnStartMessage;
               this._turnAction = [];
               if(_loc3_.id == PlayedCharacterManager.getInstance().id)
               {
                  this._myTurn = true;
                  ++this._turnPlayed;
                  if(this._turnPlayed > 2)
                  {
                     this.castSpell(411,true);
                  }
                  else
                  {
                     this.addTurnAction(this.fightRandomMove,[]);
                     this.addTurnAction(this.castSpell,[173,false]);
                     this.addTurnAction(this.castSpell,[173,false]);
                     this.addTurnAction(this.castSpell,[173,false]);
                     this.addTurnAction(this.turnEnd,[]);
                     this.nextTurnAction();
                  }
               }
               else
               {
                  this._myTurn = false;
               }
               break;
            case param1 is SequenceEndMessage:
               this.nextTurnAction();
         }
         return false;
      }
      
      private function initRight() : void
      {
         this.sendAdminCmd("adminaway");
         this.sendAdminCmd("givelevel * 200");
         this.sendAdminCmd("givespell * 173 6");
         this.sendAdminCmd("givespell * 411 6");
         this.sendAdminCmd("dring po=63,vita=8000,pa=100,agi=150 true");
      }
      
      private function sendAdminCmd(param1:String) : void
      {
         var _loc2_:AdminQuietCommandMessage = new AdminQuietCommandMessage();
         _loc2_.initAdminQuietCommandMessage(param1);
         ConnectionsHandler.getConnection().send(_loc2_);
      }
      
      private function onAction(param1:Event) : void
      {
         if(Math.random() < 0.9)
         {
            this.randomWalk();
         }
         else
         {
            this.randomMove();
         }
      }
      
      private function nextTurnAction() : void
      {
         var _loc1_:Object = null;
         if(this._turnAction.length)
         {
            _loc1_ = this._turnAction.shift();
            _loc1_.fct.apply(this,_loc1_.args);
         }
      }
      
      private function addTurnAction(param1:Function, param2:Array) : void
      {
         this._turnAction.push({
            "fct":param1,
            "args":param2
         });
      }
      
      private function turnEnd() : void
      {
         var _loc1_:GameFightTurnFinishMessage = new GameFightTurnFinishMessage();
         _loc1_.initGameFightTurnFinishMessage();
         ConnectionsHandler.getConnection().send(_loc1_);
      }
      
      private function join(param1:String) : void
      {
         if(this._inFight || this._wait)
         {
            return;
         }
         var _loc2_:AdminQuietCommandMessage = new AdminQuietCommandMessage();
         _loc2_.initAdminQuietCommandMessage("join " + param1);
         ConnectionsHandler.getConnection().send(_loc2_);
         this._actionTimer.reset();
         this._actionTimer.start();
      }
      
      private function randomMove() : void
      {
         if(this._inFight || this._wait)
         {
            return;
         }
         var _loc1_:MapPosition = this._mapPos[int(Math.random() * this._mapPos.length)];
         var _loc2_:AdminQuietCommandMessage = new AdminQuietCommandMessage();
         _loc2_.initAdminQuietCommandMessage("moveto " + _loc1_.id);
         ConnectionsHandler.getConnection().send(_loc2_);
         this._actionTimer.reset();
         this._actionTimer.start();
      }
      
      private function fakeActivity() : void
      {
         if(!this._enabled)
         {
            return;
         }
         setTimeout(this.fakeActivity,1000 * 60 * 5);
         var _loc1_:BasicPingMessage = new BasicPingMessage();
         _loc1_.initBasicPingMessage(false);
         ConnectionsHandler.getConnection().send(_loc1_);
      }
      
      private function randomWalk() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:IEntity = null;
         if(this._inFight || this._wait)
         {
            return;
         }
         var _loc3_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Array = [];
         for each(_loc1_ in _loc3_.getEntitiesDictionnary())
         {
            if(_loc1_ is GameRolePlayGroupMonsterInformations)
            {
               _loc2_ = DofusEntities.getEntity(GameRolePlayGroupMonsterInformations(_loc1_).contextualId);
               _loc4_.push(MapPoint.fromCellId(_loc2_.position.cellId));
            }
         }
         if(!_loc4_ || !_loc4_.length)
         {
            return;
         }
         var _loc5_:CellClickMessage;
         (_loc5_ = new CellClickMessage()).cell = _loc4_[Math.floor(_loc4_.length * Math.random())];
         _loc5_.cellId = _loc5_.cell.cellId;
         _loc5_.id = MapDisplayManager.getInstance().currentMapPoint.mapId;
         Kernel.getWorker().process(_loc5_);
      }
      
      private function fightRandomMove() : void
      {
         var _loc1_:FightReachableCellsMaker = new FightReachableCellsMaker(FightEntitiesFrame.getCurrentInstance().getEntityInfos(PlayedCharacterManager.getInstance().id) as GameFightFighterInformations);
         if(!_loc1_.reachableCells.length)
         {
            this.nextTurnAction();
            return;
         }
         var _loc2_:CellClickMessage = new CellClickMessage();
         _loc2_.cell = MapPoint.fromCellId(_loc1_.reachableCells[Math.floor(_loc1_.reachableCells.length * Math.random())]);
         _loc2_.cellId = _loc2_.cell.cellId;
         _loc2_.id = MapDisplayManager.getInstance().currentMapPoint.mapId;
         Kernel.getWorker().process(_loc2_);
      }
      
      private function randomOver(... rest) : void
      {
         var _loc2_:IEntity = null;
         var _loc3_:IInteractive = null;
         var _loc4_:UiRootContainer = null;
         var _loc5_:EntityMouseOutMessage = null;
         var _loc6_:GraphicContainer = null;
         var _loc7_:MouseOutMessage = null;
         if(this._wait)
         {
            return;
         }
         var _loc8_:Array = [];
         for each(_loc2_ in EntitiesManager.getInstance().entities)
         {
            if(_loc2_ is IInteractive)
            {
               _loc8_.push(_loc2_);
            }
         }
         _loc3_ = _loc8_[Math.floor(_loc8_.length * Math.random())];
         if(!_loc3_)
         {
            return;
         }
         if(this._lastEntityOver)
         {
            _loc5_ = new EntityMouseOutMessage(this._lastEntityOver);
            Kernel.getWorker().process(_loc5_);
         }
         this._lastEntityOver = _loc3_;
         var _loc9_:EntityMouseOverMessage = new EntityMouseOverMessage(_loc3_);
         Kernel.getWorker().process(_loc9_);
         var _loc10_:Array = [];
         for each(_loc4_ in Berilia.getInstance().uiList)
         {
            for each(_loc6_ in _loc4_.getElements())
            {
               if(_loc6_.mouseChildren || _loc6_.mouseEnabled)
               {
                  _loc10_.push(_loc6_);
               }
            }
         }
         if(!_loc10_.length)
         {
            return;
         }
         if(this._lastElemOver)
         {
            _loc7_ = GenericPool.get(MouseOutMessage,this._lastElemOver,new MouseEvent(MouseEvent.MOUSE_OUT));
            Kernel.getWorker().process(_loc7_);
         }
         var _loc11_:GraphicContainer = _loc10_[Math.floor(_loc10_.length * Math.random())];
         var _loc12_:MouseOverMessage = GenericPool.get(MouseOverMessage,_loc11_,new MouseEvent(MouseEvent.MOUSE_OVER));
         Kernel.getWorker().process(_loc12_);
         this._lastElemOver = _loc11_;
      }
      
      private function castSpell(param1:uint, param2:Boolean) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         var _loc6_:GameFightMonsterInformations = null;
         var _loc7_:GameActionFightCastRequestMessage = new GameActionFightCastRequestMessage();
         if(param2)
         {
            _loc3_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(PlayedCharacterManager.getInstance().id).disposition.cellId;
         }
         else
         {
            _loc4_ = [];
            for each(_loc5_ in FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary())
            {
               if(_loc5_.contextualId < 0 && _loc5_ is GameFightMonsterInformations)
               {
                  if((_loc6_ = _loc5_ as GameFightMonsterInformations).alive)
                  {
                     _loc4_.push(_loc5_.disposition.cellId);
                  }
               }
            }
            _loc3_ = uint(_loc4_[Math.floor(_loc4_.length * Math.random())]);
         }
         _loc7_.initGameActionFightCastRequestMessage(param1,_loc3_);
         ConnectionsHandler.getConnection().send(_loc7_);
      }
   }
}
