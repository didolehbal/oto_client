package com.ankamagames.atouin.types
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   
   public class Frustum extends Rectangle
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Frustum));
      
      public static const MAX_WIDTH:Number = (AtouinConstants.MAP_WIDTH + 0.5) * AtouinConstants.CELL_WIDTH;
      
      public static const MAX_HEIGHT:Number = (AtouinConstants.MAP_HEIGHT + 0.5) * AtouinConstants.CELL_HEIGHT;
      
      public static const RATIO:Number = MAX_WIDTH / MAX_HEIGHT;
       
      
      private var _marginLeft:int;
      
      private var _marginRight:int;
      
      private var _marginTop:int;
      
      private var _marginBottom:int;
      
      public var scale:Number;
      
      public function Frustum(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:uint = 0)
      {
         super();
         this._marginTop = param2;
         this._marginRight = param1;
         this._marginBottom = param4;
         this._marginLeft = param3;
         this.refresh();
      }
      
      public function refresh() : Frustum
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         width = MAX_WIDTH + this._marginRight + this._marginLeft;
         height = MAX_HEIGHT + this._marginTop + this._marginBottom;
         var _loc3_:Number = StageShareManager.startHeight / height;
         width = MAX_WIDTH * _loc3_;
         height = MAX_HEIGHT * _loc3_;
         if(width / height < RATIO)
         {
            height = width / RATIO;
         }
         if(width / height > RATIO)
         {
            width = height * RATIO;
         }
         this.scale = _loc3_;
         var _loc4_:Number = StageShareManager.startWidth - MAX_WIDTH * this.scale + this._marginLeft - this._marginRight;
         var _loc5_:Number = StageShareManager.startHeight - MAX_HEIGHT * this.scale + this._marginTop - this._marginBottom;
         if(this._marginLeft && this._marginRight)
         {
            _loc1_ = (this._marginLeft + this._marginRight) / this._marginLeft;
         }
         else if(this._marginLeft)
         {
            _loc1_ = 2 + _loc4_ / this._marginLeft;
         }
         else if(this._marginRight)
         {
            _loc1_ = 2 - _loc4_ / this._marginRight;
         }
         else
         {
            _loc1_ = 2;
         }
         if(this._marginTop && this._marginBottom)
         {
            _loc2_ = (this._marginTop + this._marginBottom) / this._marginTop;
         }
         else if(this._marginTop)
         {
            _loc2_ = 2 + _loc5_ / this._marginTop;
         }
         else if(this._marginBottom)
         {
            _loc2_ = _loc5_ / this._marginBottom - 2;
         }
         else
         {
            _loc2_ = 2;
         }
         x = _loc4_ / _loc1_;
         y = _loc5_ / _loc2_;
         return this;
      }
      
      override public function toString() : String
      {
         return super.toString() + " scale=" + this.scale;
      }
   }
}
