package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.MapsLoadingStartedMessage;
   import com.ankamagames.atouin.types.CellReference;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.HtmlManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.ChatChannelsMultiEnum;
   import com.ankamagames.dofus.network.messages.authorized.AdminQuietCommandMessage;
   import com.ankamagames.dofus.network.messages.common.basic.BasicPingMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatServerMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapFightCountMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapRunningFightListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapRunningFightListRequestMessage;
   import com.ankamagames.dofus.network.types.game.context.fight.FightExternalInformations;
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
   
   public class DebugBotFrame implements Frame
   {
      
      private static var _self:DebugBotFrame;
       
      
      private var _frameFightListRequest:Boolean;
      
      private var _fightCount:uint;
      
      private var _mapPos:Array;
      
      private var _enabled:Boolean;
      
      private var _rollOverTimer:Timer;
      
      private var _actionTimer:Timer;
      
      private var _chatTimer:Timer;
      
      private var _inFight:Boolean;
      
      private var _lastElemOver:Sprite;
      
      private var _lastEntityOver:IInteractive;
      
      private var _wait:Boolean;
      
      private var _changeMap:Boolean = true;
      
      private var ttSentence:int = 0;
      
      private var limit:int = 100;
      
      public function DebugBotFrame()
      {
         this._rollOverTimer = new Timer(2000);
         this._actionTimer = new Timer(5000);
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this.initRight();
         this._actionTimer.addEventListener(TimerEvent.TIMER,this.onAction);
         this._rollOverTimer.addEventListener(TimerEvent.TIMER,this.randomOver);
      }
      
      public static function getInstance() : DebugBotFrame
      {
         if(!_self)
         {
            _self = new DebugBotFrame();
         }
         return _self;
      }
      
      public function enableChatMessagesBot(param1:Boolean, param2:int = 500) : void
      {
         if(param1)
         {
            this._changeMap = false;
            this._chatTimer = new Timer(param2);
            this._chatTimer.addEventListener(TimerEvent.TIMER,this.sendChatMessage);
         }
         else if(this._chatTimer)
         {
            this._changeMap = true;
            this._chatTimer.removeEventListener(TimerEvent.TIMER,this.sendChatMessage);
         }
      }
      
      public function pushed() : Boolean
      {
         this._enabled = true;
         this.fakeActivity();
         this._actionTimer.start();
         this._rollOverTimer.start();
         if(this._chatTimer)
         {
            this._chatTimer.start();
         }
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
         if(this._chatTimer)
         {
            this._chatTimer.stop();
         }
         this._enabled = false;
         return true;
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function get fightCount() : uint
      {
         return this._fightCount;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:MapFightCountMessage = null;
         var _loc3_:MapRunningFightListMessage = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:GameFightJoinRequestMessage = null;
         var _loc7_:ChatServerMessage = null;
         var _loc8_:MapRunningFightListRequestMessage = null;
         var _loc9_:FightExternalInformations = null;
         switch(true)
         {
            case param1 is MapFightCountMessage:
               _loc2_ = param1 as MapFightCountMessage;
               if(_loc2_.fightCount)
               {
                  (_loc8_ = new MapRunningFightListRequestMessage()).initMapRunningFightListRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc8_);
                  this._frameFightListRequest = true;
               }
               break;
            case param1 is MapRunningFightListMessage:
               if(!this._frameFightListRequest)
               {
                  break;
               }
               this._frameFightListRequest = false;
               _loc3_ = param1 as MapRunningFightListMessage;
               for each(_loc9_ in _loc3_.fights)
               {
                  if(_loc9_.fightTeams.length > _loc5_)
                  {
                     _loc5_ = _loc9_.fightTeams.length;
                     _loc4_ = _loc9_.fightId;
                  }
               }
               if(this._wait || Math.random() < 0.6)
               {
                  return true;
               }
               (_loc6_ = new GameFightJoinRequestMessage()).initGameFightJoinRequestMessage(0,_loc4_);
               ConnectionsHandler.getConnection().send(_loc6_);
               this._actionTimer.reset();
               this._actionTimer.start();
               return true;
               break;
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
            case param1 is ChatServerMessage:
               if((_loc7_ = param1 as ChatServerMessage).channel == ChatChannelsMultiEnum.CHANNEL_SALES || _loc7_.channel == ChatChannelsMultiEnum.CHANNEL_SEEK && Math.random() > 0.95)
               {
                  this.join(_loc7_.senderName);
               }
         }
         return false;
      }
      
      private function initRight() : void
      {
         var _loc1_:AdminQuietCommandMessage = new AdminQuietCommandMessage();
         _loc1_.initAdminQuietCommandMessage("adminaway");
         ConnectionsHandler.getConnection().send(_loc1_);
         _loc1_.initAdminQuietCommandMessage("god");
         ConnectionsHandler.getConnection().send(_loc1_);
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
         if(this._inFight || this._wait || !this._changeMap)
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
         var _loc1_:CellReference = null;
         var _loc2_:MapPoint = null;
         if(this._inFight || this._wait)
         {
            return;
         }
         var _loc3_:Array = [];
         for each(_loc1_ in MapDisplayManager.getInstance().getDataMapContainer().getCell())
         {
            _loc2_ = MapPoint.fromCellId(_loc1_.id);
            if(DataMapProvider.getInstance().pointMov(_loc2_.x,_loc2_.y))
            {
               _loc3_.push(_loc2_);
            }
         }
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:CellClickMessage;
         (_loc4_ = new CellClickMessage()).cell = _loc3_[Math.floor(_loc3_.length * Math.random())];
         _loc4_.cellId = _loc4_.cell.cellId;
         _loc4_.id = MapDisplayManager.getInstance().currentMapPoint.mapId;
         Kernel.getWorker().process(_loc4_);
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
      
      private function sendChatMessage(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = uint(Math.random() * 16777215);
         var _loc5_:Vector.<String>;
         (_loc5_ = new Vector.<String>())[0] = "Test html: salut <span style=\"color:#" + (Math.random() * 16777215).toString(8) + "\">je suis la</span> et la";
         _loc5_[1] = "i\'m batman";
         _loc5_[2] = HtmlManager.addLink("i\'m a link now, awesome !!","");
         _loc5_[3] = ":( sd :p :) fdg dfg f";
         _loc5_[4] = "je suis <u>underlineeeeeee</u> et moi <b>BOLD</b>" + "\nEt un retour a la ligne, un !!";
         _loc5_[5] = "*test de texte italic via la commande*";
         var _loc6_:String = _loc5_[Math.floor(Math.random() * _loc5_.length)];
         ++this.ttSentence;
         KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc6_,ChatActivableChannelsEnum.CHANNEL_GLOBAL);
         if(this.ttSentence > this.limit + 1)
         {
            --this.ttSentence;
            _loc2_ = 0;
            _loc3_ = 1;
            KernelEventsManager.getInstance().processCallback(ChatHookList.NewMessage,_loc2_,_loc3_);
         }
      }
   }
}
