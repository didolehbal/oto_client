package com.ankamagames.dofus.internalDatacenter.communication
{
   import com.ankamagames.berilia.managers.SlotDataHolderManager;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.EmoticonFrame;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   use namespace flash_proxy;
   
   public class EmoteWrapper extends Proxy implements IDataCenter, ISlotData
   {
      
      private static var _cache:Array = new Array();
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(EmoteWrapper));
       
      
      private var _uri:Uri;
      
      private var _slotDataHolderManager:SlotDataHolderManager;
      
      private var _timerDuration:int = 0;
      
      private var _timerStartTime:int = 0;
      
      private var _timerEndTime:int = 0;
      
      public var position:uint;
      
      public var id:uint = 0;
      
      public var gfxId:int;
      
      public var isOkForMultiUse:Boolean = false;
      
      public var quantity:uint = 1;
      
      public function EmoteWrapper()
      {
         super();
      }
      
      public static function create(param1:uint, param2:int = -1, param3:Boolean = true) : EmoteWrapper
      {
         var _loc4_:EmoteWrapper = new EmoteWrapper();
         if(!_cache[param1] || !param3)
         {
            (_loc4_ = new EmoteWrapper()).id = param1;
            if(param3)
            {
               _cache[param1] = _loc4_;
            }
            _loc4_._slotDataHolderManager = new SlotDataHolderManager(_loc4_);
         }
         else
         {
            _loc4_ = _cache[param1];
         }
         _loc4_.id = param1;
         _loc4_.gfxId = param1;
         if(param2 >= 0)
         {
            _loc4_.position = param2;
         }
         return _loc4_;
      }
      
      public static function refreshAllEmoteHolders() : void
      {
         var _loc1_:EmoteWrapper = null;
         for each(_loc1_ in _cache)
         {
            _loc1_._slotDataHolderManager.refreshAll();
         }
      }
      
      public static function getEmoteWrapperById(param1:uint) : EmoteWrapper
      {
         return _cache[param1];
      }
      
      public function get iconUri() : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path").concat("gfx/emotes/").concat(this.id).concat(".png"));
         }
         return this._uri;
      }
      
      public function get fullSizeIconUri() : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path").concat("gfx/emotes/").concat(this.id).concat(".png"));
         }
         return this._uri;
      }
      
      public function get backGroundIconUri() : Uri
      {
         return null;
      }
      
      public function get errorIconUri() : Uri
      {
         return null;
      }
      
      public function get info1() : String
      {
         return null;
      }
      
      public function get startTime() : int
      {
         return this._timerStartTime;
      }
      
      public function get endTime() : int
      {
         return this._timerEndTime;
      }
      
      public function set endTime(param1:int) : void
      {
         this._timerEndTime = param1;
      }
      
      public function get timer() : int
      {
         var _loc1_:int = this._timerStartTime + this._timerDuration - getTimer();
         if(_loc1_ > 0)
         {
            return _loc1_;
         }
         return 0;
      }
      
      public function set timerToStart(param1:int) : void
      {
         this._timerDuration = param1;
         this._timerStartTime = getTimer();
         this._slotDataHolderManager.refreshAll();
      }
      
      public function get active() : Boolean
      {
         var _loc1_:EmoticonFrame = Kernel.getWorker().getFrame(EmoticonFrame) as EmoticonFrame;
         return _loc1_.isKnownEmote(this.id);
      }
      
      public function get emote() : Emoticon
      {
         return Emoticon.getEmoticonById(this.id);
      }
      
      public function get emoteId() : uint
      {
         return this.id;
      }
      
      public function get isUsable() : Boolean
      {
         return true;
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var name:* = param1;
         var l:* = undefined;
         var r:* = undefined;
         if(isAttribute(name))
         {
            return this[name];
         }
         l = this.emote;
         if(!l)
         {
            r = "";
         }
         try
         {
            return l[name];
         }
         catch(e:Error)
         {
            return "Error_on_item_" + name;
         }
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return isAttribute(param1);
      }
      
      public function toString() : String
      {
         return "[EmoteWrapper#" + this.id + "]";
      }
      
      public function addHolder(param1:ISlotDataHolder) : void
      {
         this._slotDataHolderManager.addHolder(param1);
      }
      
      public function removeHolder(param1:ISlotDataHolder) : void
      {
         this._slotDataHolderManager.removeHolder(param1);
      }
      
      public function setLinkedSlotData(param1:ISlotData) : void
      {
         this._slotDataHolderManager.setLinkedSlotData(param1);
      }
      
      public function getIconUri(param1:Boolean = true) : Uri
      {
         if(!this._uri)
         {
            this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path").concat("gfx/emotes/").concat(this.id).concat(".png"));
         }
         return this._uri;
      }
   }
}
