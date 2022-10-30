package com.ankamagames.atouin.types
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.pools.PoolableRectangle;
   import com.ankamagames.jerakine.pools.PoolsManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   
   public class CellReference
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CellReference));
       
      
      private var _visible:Boolean;
      
      private var _lock:Boolean = false;
      
      public var id:uint;
      
      public var listSprites:Array;
      
      public var elevation:int = 0;
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var width:Number = 0;
      
      public var height:Number = 0;
      
      public var mov:Boolean;
      
      public var isDisabled:Boolean = false;
      
      public var rendered:Boolean = false;
      
      public var heightestDecor:Sprite;
      
      public var gfxId:Array;
      
      public function CellReference(param1:uint)
      {
         super();
         this.id = param1;
         this.listSprites = new Array();
         this.gfxId = new Array();
      }
      
      public function addSprite(param1:DisplayObject) : void
      {
         this.listSprites.push(param1);
      }
      
      public function addGfx(param1:int) : void
      {
         this.gfxId.push(param1);
      }
      
      public function lock() : void
      {
         this._lock = true;
      }
      
      public function get locked() : Boolean
      {
         return this._lock;
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         if(this._visible != param1)
         {
            this._visible = param1;
            _loc2_ = 0;
            while(_loc2_ < this.listSprites.length)
            {
               if(this.listSprites[_loc2_] != null)
               {
                  this.listSprites[_loc2_].visible = param1;
               }
               _loc2_++;
            }
         }
      }
      
      public function get bounds() : Rectangle
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:PoolableRectangle = (PoolsManager.getInstance().getRectanglePool().checkOut() as PoolableRectangle).renew();
         var _loc3_:PoolableRectangle = PoolsManager.getInstance().getRectanglePool().checkOut() as PoolableRectangle;
         for each(_loc1_ in this.listSprites)
         {
            _loc2_.extend(_loc3_.renew(_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height));
         }
         PoolsManager.getInstance().getRectanglePool().checkIn(_loc3_);
         PoolsManager.getInstance().getRectanglePool().checkIn(_loc2_);
         return _loc2_ as Rectangle;
      }
      
      public function getAvgColor() : uint
      {
         var _loc1_:ColorTransform = null;
         var _loc2_:int = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:int = this.listSprites.length;
         _loc2_ = 0;
         while(_loc2_ < _loc6_)
         {
            _loc1_ = (this.listSprites[_loc2_] as DisplayObject).transform.colorTransform;
            _loc3_ = _loc3_ + _loc1_.redOffset * _loc1_.redMultiplier;
            _loc4_ = _loc4_ + _loc1_.greenOffset * _loc1_.greenMultiplier;
            _loc5_ = _loc5_ + _loc1_.blueOffset * _loc1_.blueMultiplier;
            _loc2_ = _loc2_ + 1;
         }
         _loc3_ = _loc3_ / _loc6_;
         _loc4_ = _loc4_ / _loc6_;
         _loc5_ = _loc5_ / _loc6_;
         return _loc3_ << 16 | _loc4_ << 8 | _loc5_;
      }
   }
}
