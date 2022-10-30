package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.livingObjects.SpeakingItemText;
   import com.ankamagames.dofus.datacenter.livingObjects.SpeakingItemsTrigger;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.messages.game.inventory.items.LivingObjectMessageRequestMessage;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SpeakingItemManager implements IDestroyable
   {
      
      private static const SPEAKING_ITEMS_MSG_COUNT:Number = 30;
      
      private static const SPEAKING_ITEMS_MSG_COUNT_DELTA:Number = 0.2;
      
      private static const SPEAKING_ITEMS_CHAT_PROBA:Number = 0.01;
      
      private static var _timer:Timer;
      
      public static const MINUTE_DELAY:int = 1000 * 60;
      
      public static const GREAT_DROP_LIMIT:int = 10;
      
      public static const SPEAK_TRIGGER_MINUTE:int = 1;
      
      public static const SPEAK_TRIGGER_AGRESS:int = 2;
      
      public static const SPEAK_TRIGGER_AGRESSED:int = 3;
      
      public static const SPEAK_TRIGGER_KILL_ENEMY:int = 4;
      
      public static const SPEAK_TRIGGER_KILLED_BY_ENEMY:int = 5;
      
      public static const SPEAK_TRIGGER_CC_OWNER:int = 6;
      
      public static const SPEAK_TRIGGER_EC_OWNER:int = 7;
      
      public static const SPEAK_TRIGGER_FIGHT_WON:int = 8;
      
      public static const SPEAK_TRIGGER_FIGHT_LOST:int = 9;
      
      public static const SPEAK_TRIGGER_NEW_ENEMY_WEAK:int = 10;
      
      public static const SPEAK_TRIGGER_NEW_ENEMY_STRONG:int = 11;
      
      public static const SPEAK_TRIGGER_CC_ALLIED:int = 12;
      
      public static const SPEAK_TRIGGER_EC_ALLIED:int = 13;
      
      public static const SPEAK_TRIGGER_CC_ENEMY:int = 14;
      
      public static const SPEAK_TRIGGER_EC_ENEMY:int = 15;
      
      public static const SPEAK_TRIGGER_ON_CONNECT:int = 16;
      
      public static const SPEAK_TRIGGER_KILL_ALLY:int = 17;
      
      public static const SPEAK_TRIGGER_KILLED_BY_ALLY:int = 18;
      
      public static const SPEAK_TRIGGER_GREAT_DROP:int = 19;
      
      public static const SPEAK_TRIGGER_KILLED_HIMSELF:int = 20;
      
      public static const SPEAK_TRIGGER_CRAFT_OK:int = 21;
      
      public static const SPEAK_TRIGGER_CRAFT_KO:int = 22;
      
      private static var _self:SpeakingItemManager;
       
      
      private var _nextMessageCount:int;
      
      public function SpeakingItemManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("TimeManager is a singleton and should not be instanciated directly.");
         }
         this.init();
      }
      
      public static function getInstance() : SpeakingItemManager
      {
         if(_self == null)
         {
            _self = new SpeakingItemManager();
         }
         return _self;
      }
      
      public function get speakTimerMinuteDelay() : int
      {
         return _timer.delay;
      }
      
      public function set speakTimerMinuteDelay(param1:int) : void
      {
         _timer.delay = param1;
         _timer.stop();
         _timer.start();
      }
      
      public function triggerEvent(param1:int) : void
      {
         var _loc2_:ItemWrapper = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:SpeakingItemText = null;
         var _loc9_:Array = null;
         var _loc10_:LivingObjectMessageRequestMessage = null;
         if(!Kernel.getWorker().getFrame(ChatFrame))
         {
            return;
         }
         var _loc11_:Boolean;
         if(!(_loc11_ = OptionManager.getOptionManager("chat").letLivingObjectTalk))
         {
            return;
         }
         var _loc12_:Array = new Array();
         for each(_loc2_ in InventoryManager.getInstance().inventory.getView("equipment").content)
         {
            if(_loc2_ && _loc2_.isSpeakingObject)
            {
               _loc12_.push(_loc2_);
            }
         }
         if(_loc12_.length == 0)
         {
            return;
         }
         --this._nextMessageCount;
         this._nextMessageCount = this._nextMessageCount - (_loc12_.length - 1) / 4;
         if(this._nextMessageCount > 0)
         {
            return;
         }
         var _loc13_:SpeakingItemsTrigger = SpeakingItemsTrigger.getSpeakingItemsTriggerById(param1);
         var _loc14_:ItemWrapper = _loc12_[Math.floor(Math.random() * _loc12_.length)];
         var _loc15_:Array = new Array();
         if(_loc13_)
         {
            _loc3_ = _loc14_.objectGID.toString();
            _loc4_ = 0;
            while(_loc4_ < _loc13_.textIds.length)
            {
               if(!(_loc14_.isLivingObject && _loc13_.states[_loc4_] != _loc14_.livingObjectMood))
               {
                  if(_loc8_ = SpeakingItemText.getSpeakingItemTextById(_loc13_.textIds[_loc4_]))
                  {
                     if(!(_loc8_.textLevel > _loc14_.livingObjectLevel && _loc14_.isLivingObject))
                     {
                        _loc9_ = _loc8_.textRestriction.split(",");
                        if(!(_loc8_.textRestriction != "" && _loc9_.indexOf(_loc3_) == -1))
                        {
                           _loc15_.push(_loc13_.textIds[_loc4_]);
                        }
                     }
                  }
               }
               _loc4_++;
            }
            if(_loc15_.length == 0)
            {
               return;
            }
            _loc6_ = false;
            _loc4_ = 0;
            while(_loc4_ < 10)
            {
               _loc5_ = _loc15_[Math.floor(Math.random() * _loc15_.length)];
               _loc8_ = SpeakingItemText.getSpeakingItemTextById(_loc5_);
               if(Math.random() < _loc8_.textProba)
               {
                  _loc6_ = true;
               }
               _loc4_++;
            }
            if(!_loc6_)
            {
               return;
            }
            if(_loc8_.textSound != -1)
            {
               _loc7_ = Math.floor(Math.random() * 3);
            }
            else
            {
               _loc7_ = 1;
            }
            if(Math.random() < SPEAKING_ITEMS_CHAT_PROBA)
            {
               (_loc10_ = new LivingObjectMessageRequestMessage()).msgId = _loc8_.textId;
               _loc10_.livingObject = _loc14_.objectUID;
               ConnectionsHandler.getConnection().send(_loc10_);
            }
            else
            {
               KernelEventsManager.getInstance().processCallback(ChatHookList.ChatSpeakingItem,ChatActivableChannelsEnum.PSEUDO_CHANNEL_PRIVATE,_loc14_,_loc8_.textString,TimeManager.getInstance().getTimestamp());
            }
         }
         this.generateNextMsgCount(false);
      }
      
      public function destroy() : void
      {
         _self = null;
         _timer.removeEventListener("timer",this.onTimer);
      }
      
      private function init() : void
      {
         _timer = new Timer(MINUTE_DELAY);
         _timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         _timer.start();
         this.generateNextMsgCount(true);
      }
      
      private function generateNextMsgCount(param1:Boolean) : void
      {
         var _loc2_:Number = SPEAKING_ITEMS_MSG_COUNT;
         var _loc3_:Number = SPEAKING_ITEMS_MSG_COUNT_DELTA;
         if(param1)
         {
            this._nextMessageCount = Math.floor(_loc2_ * Math.random());
         }
         else
         {
            this._nextMessageCount = _loc2_ + Math.floor(2 * _loc3_ * Math.random());
         }
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this.triggerEvent(SPEAK_TRIGGER_MINUTE);
      }
   }
}
