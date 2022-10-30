package com.ankamagames.dofus.logic.game.common.types
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.DofusShopManager;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.types.Uri;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DofusShopArticle extends DofusShopObject implements IDataCenter
   {
      
      private static const date_regexp:RegExp = new RegExp(/\-/g);
       
      
      private var _subtitle:String;
      
      private var _price:Number;
      
      private var _originalPrice:Number;
      
      private var _endDate:Date;
      
      private var _currency:String;
      
      private var _stock:int;
      
      private var _imgSmall:String;
      
      private var _imgNormal:String;
      
      private var _imgSwf:Uri;
      
      private var _references:Array;
      
      private var _promo:Array;
      
      private var _endTimer:Timer;
      
      private var _gids:Array;
      
      private var _isNew:Boolean;
      
      private var _hasExpired:Boolean;
      
      public function DofusShopArticle(param1:Object)
      {
         super(param1);
      }
      
      override public function init(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Object = null;
         var _loc6_:Date = null;
         var _loc7_:Object = null;
         var _loc8_:ItemWrapper = null;
         super.init(param1);
         this._subtitle = param1.subtitle;
         this._price = param1.price;
         this._originalPrice = param1.original_price;
         this._isNew = false;
         var _loc9_:Number = new Date().getTime();
         if(param1.startdate)
         {
            _loc2_ = param1.startdate;
            _loc2_ = _loc2_.replace(date_regexp,"/");
            _loc3_ = (_loc6_ = new Date(Date.parse(_loc2_))).getTime();
            _loc4_ = _loc9_ - _loc3_;
            this._isNew = _loc4_ > 0 && _loc4_ < 864000000;
         }
         if(param1.enddate)
         {
            _loc2_ = param1.enddate;
            _loc2_ = _loc2_.replace(date_regexp,"/");
            this._endDate = new Date(Date.parse(_loc2_));
            _loc3_ = this._endDate.getTime();
            if((_loc4_ = _loc3_ - _loc9_) <= 0)
            {
               this._hasExpired = true;
            }
            else if(_loc4_ <= 43200000)
            {
               this._endTimer = new Timer(_loc4_,1);
               this._endTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onEndDate);
               this._endTimer.start();
            }
         }
         this._currency = param1.currency;
         this._stock = param1.stock == null?-1:int(param1.stock);
         this._references = param1.references;
         this._gids = [];
         for each(_loc5_ in this._references)
         {
            if(_loc5_ && typeof _loc5_ == "object" && _loc5_.hasOwnProperty("content"))
            {
               for each(_loc7_ in _loc5_.content)
               {
                  if(_loc7_ && typeof _loc7_ == "object" && _loc7_.hasOwnProperty("id"))
                  {
                     this._gids.push(parseInt(_loc7_.id));
                  }
               }
            }
         }
         if(this._gids.length == 1)
         {
            _loc8_ = ItemWrapper.create(0,0,this._gids[0],1,null,false);
            this._imgSwf = _loc8_.getIconUri(false);
         }
         if(param1.image)
         {
            this._imgSmall = param1.image["70_70"];
            this._imgNormal = param1.image["200_200"];
         }
         this._promo = param1.promo;
      }
      
      protected function onEndDate(param1:TimerEvent) : void
      {
         this._endTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onEndDate);
         DofusShopManager.getInstance().updateAfterExpiredArticle(id);
      }
      
      override public function free() : void
      {
         if(this._endTimer)
         {
            this._endTimer.stop();
            this._endTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onEndDate);
            this._endTimer = null;
         }
         this._subtitle = null;
         this._price = 0;
         this._originalPrice = 0;
         this._endDate = null;
         this._currency = null;
         this._stock = 0;
         this._imgSmall = null;
         this._imgNormal = null;
         this._references = null;
         this._promo = null;
         this._gids = null;
         super.free();
      }
      
      public function get subtitle() : String
      {
         return this._subtitle;
      }
      
      public function get price() : Number
      {
         return this._price;
      }
      
      public function get originalPrice() : Number
      {
         return this._originalPrice;
      }
      
      public function get endDate() : Date
      {
         return this._endDate;
      }
      
      public function get currency() : String
      {
         return this._currency;
      }
      
      public function get stock() : int
      {
         return this._stock;
      }
      
      public function get imageSmall() : String
      {
         return this._imgSmall;
      }
      
      public function get imageSwf() : Uri
      {
         return this._imgSwf;
      }
      
      public function get imageNormal() : String
      {
         return this._imgNormal;
      }
      
      public function get references() : Array
      {
         return this._references;
      }
      
      public function get gids() : Array
      {
         return this._gids;
      }
      
      public function get promo() : Array
      {
         return this._promo;
      }
      
      public function get isNew() : Boolean
      {
         return this._isNew;
      }
      
      public function get hasExpired() : Boolean
      {
         return this._hasExpired;
      }
   }
}
